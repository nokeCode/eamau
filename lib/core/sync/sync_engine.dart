import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';

import '../connectivity/connectivity_service.dart';
import '../database/app_database.dart' as adb;
import '../../models/admission/admission_request_model.dart';
import '../../models/registration/registration_referential_model.dart';
import '../../services/admission/admission_request_service.dart';
import '../../services/registration/registration_service.dart';
import 'sync_queue.dart';
import 'package:flutter/foundation.dart';

import '../../data/local/news_local_datasource.dart';
import '../../data/remote/news_remote_datasource.dart';
import '../../data/repositories/news_repository.dart';
import '../../services/news/news_service.dart';
import '../../data/local/publication_local_datasource.dart';
import '../../data/remote/publication_remote_datasource.dart';
import '../../data/repositories/publication_repository.dart';
import '../../data/local/concours_local_datasource.dart';
import '../../data/remote/concours_remote_datasource.dart';
import '../../data/repositories/concours_repository.dart';
import '../../services/concours/concours_form_service.dart';

/// SyncEngine listens to connectivity changes and processes pending operations
/// in a local-first queue. It keeps a retry/backoff policy and does not block
/// startup if no remote endpoint is yet wired for a given operation type.
class SyncEngine {
  static final SyncEngine _instance = SyncEngine._();
  factory SyncEngine() => _instance;
  SyncEngine._();

  final SyncQueue _queue = SyncQueue();
  StreamSubscription<bool>? _connectivitySub;
  bool _isProcessing = false;
  bool _isNewsSyncing = false;
  bool _isPublicationsSyncing = false;
  bool _isConcoursSyncing = false;
  final StreamController<void> _publicationsSyncedController = StreamController<void>.broadcast();

  void start() {
    if (_connectivitySub != null) return;

    _connectivitySub = ConnectivityService().onConnectivityChanged.listen((isOnline) {
      if (isOnline) {
        _processQueue();
        _tryFullNewsSync();
        _tryFullPublicationsSync();
        _tryFullConcoursSync();
      }
    });
  }

  Stream<void> get onPublicationsSynced => _publicationsSyncedController.stream;

  void stop() {
    _connectivitySub?.cancel();
    _connectivitySub = null;
  }

  Future<void> enqueueOperation(SyncOperation op) async {
    await _queue.enqueue(op);

    final online = await ConnectivityService().isOnline();
    if (online) {
      await _processQueue();
    }
  }

  Future<void> _processQueue() async {
    if (_isProcessing) return;

    _isProcessing = true;
    try {
      final ops = await _queue.all;
      if (ops.isEmpty) return;

      final online = await ConnectivityService().isOnline();
      if (!online) return;

      for (final op in List<SyncOperation>.from(ops)) {
        if (op.status == SyncStatus.synced) {
          await _queue.remove(op.clientOperationId);
          continue;
        }

        final updated = SyncOperation(
          clientOperationId: op.clientOperationId,
          type: op.type,
          payload: op.payload,
          status: SyncStatus.syncing,
          retryCount: op.retryCount,
          createdAt: op.createdAt,
        );
        await _queue.update(updated);

        try {
          final success = await _executeOperation(op);
          if (success) {
            await _queue.remove(op.clientOperationId);
            continue;
          }

          final nextRetry = op.retryCount + 1;
          final failed = SyncOperation(
            clientOperationId: op.clientOperationId,
            type: op.type,
            payload: op.payload,
            status: SyncStatus.failed,
            retryCount: nextRetry,
            createdAt: op.createdAt,
          );
          await _queue.update(failed);

          if (nextRetry >= 5) {
            await _queue.remove(op.clientOperationId);
          }
        } catch (_) {
          final nextRetry = op.retryCount + 1;
          final failed = SyncOperation(
            clientOperationId: op.clientOperationId,
            type: op.type,
            payload: op.payload,
            status: SyncStatus.failed,
            retryCount: nextRetry,
            createdAt: op.createdAt,
          );
          await _queue.update(failed);

          if (nextRetry >= 5) {
            await _queue.remove(op.clientOperationId);
          }
        }
      }
    } finally {
      _isProcessing = false;
    }
  }

  Future<bool> _executeOperation(SyncOperation op) async {
    final service = AdmissionRequestService();
    switch (op.type) {
      case 'postulation.document.upload':
        try {
          final docIdRaw = op.payload['documentId'];
          final docId = int.tryParse(docIdRaw?.toString() ?? '') ?? 0;
          if (docId <= 0) return true;

          final database = adb.AppDatabase();
          final docRow = await (database.select(database.postulationDocuments)..where((d) => d.id.equals(docId))).getSingleOrNull();
          if (docRow == null) return true;
          if (docRow.uploadStatus == 'synced') return true;

          final draftId = docRow.draftId;
          if (draftId == null) return false;

          final draftRow = await (database.select(database.postulationDrafts)..where((t) => t.id.equals(draftId))).getSingleOrNull();
          if (draftRow == null) return false;

          final remotePostulationId = draftRow.remoteId ?? '';
          final postulationToken = draftRow.postulationToken ?? '';
          if (remotePostulationId.isEmpty || postulationToken.isEmpty) {
            // cannot upload without remote id and token yet
            return false;
          }

          final filePath = docRow.localPath;
          final file = File(filePath);
          if (!await file.exists()) return false;

          final concoursService = ConcoursFormService();
          final prepared = file;
          final uploaded = await concoursService.uploadDocument(
            postulationId: remotePostulationId,
            attributeSlug: docRow.fileName ?? 'document',
            file: prepared,
            postulationToken: postulationToken,
          );

          if (uploaded.id.isNotEmpty) {
            await (database.update(database.postulationDocuments)..where((d) => d.id.equals(docRow.id))).write(
              adb.PostulationDocumentsCompanion(
                uploadStatus: Value('synced'),
                retryCount: Value(docRow.retryCount),
              ),
            );
            return true;
          }
          return false;
        } catch (_) {
          return false;
        }
      case 'postulation.save':
        try {
          final draftId = op.payload['draftId'] as int?;
          if (draftId == null || draftId <= 0) return false;

          final database = adb.AppDatabase();
          final draftRow = await (database.select(database.postulationDrafts)..where((t) => t.id.equals(draftId))).getSingleOrNull();
          if (draftRow == null) return false;

          final remoteId = draftRow.remoteId ?? '';
          final token = draftRow.postulationToken ?? '';
          if (remoteId.isEmpty || token.isEmpty) {
            // cannot save without remote id and token
            return false;
          }

          final dataJson = draftRow.dataJson ?? '{}';
          final values = jsonDecode(dataJson) as Map<String, dynamic>? ?? {};
          final concoursService = ConcoursFormService();
          await concoursService.saveValues(remoteId, values, postulationToken: token);

          return true;
        } catch (_) {
          return false;
        }
      case 'postulation.submit':
        try {
          final draftId = op.payload['draftId'] as int?;
          if (draftId == null || draftId <= 0) return false;

          final database = adb.AppDatabase();
          final draftRow = await (database.select(database.postulationDrafts)..where((t) => t.id.equals(draftId))).getSingleOrNull();
          if (draftRow == null) return false;

          final remoteId = draftRow.remoteId ?? '';
          final token = draftRow.postulationToken ?? '';
          if (remoteId.isEmpty || token.isEmpty) {
            return false;
          }

          final concoursService = ConcoursFormService();
          final result = await concoursService.submit(remoteId, postulationToken: token);
          final data = result['data'];
          if (data is Map) {
            final reference = data['reference']?.toString() ?? '';
            await (database.update(database.postulationDrafts)..where((t) => t.id.equals(draftRow.id))).write(
              adb.PostulationDraftsCompanion(
                status: Value('submitted'),
                reference: reference.isNotEmpty ? Value(reference) : const Value.absent(),
                updatedAt: Value(DateTime.now()),
              ),
            );
            return true;
          }
          return false;
        } catch (_) {
          return false;
        }
      case 'document.upload':
        try {
          final docIdRaw = op.payload['documentId'];
          final isRegistration = op.payload['isRegistration'] as bool? ?? false;
          final attachmentType = op.payload['attachmentType']?.toString() ?? 'OTHER';
          final docId = int.tryParse(docIdRaw?.toString() ?? '') ?? 0;
          if (docId <= 0) return true;

          final database = adb.AppDatabase();

          // Check if this is an admission or registration document
          if (isRegistration) {
            // Registration document upload
            final docRow = await (database.select(database.registrationDocuments)
                  ..where((d) => d.id.equals(docId)))
                .getSingleOrNull();
            if (docRow == null) return true;

            if (docRow.uploadStatus == 'synced') return true;

            final draftId = docRow.draftId;
            if (draftId == null) return false;

            final draftRow = await (database.select(database.registrationDrafts)
                  ..where((t) => t.id.equals(draftId)))
                .getSingleOrNull();
            if (draftRow == null) return false;

            final remoteRegistrationId = draftRow.remoteId;
            if (remoteRegistrationId == null) {
              // registration not yet created remotely; wait and retry later
              return false;
            }

            final filePath = docRow.localPath;
            final file = File(filePath);
            if (!await file.exists()) return false;

            // Use AdmissionRequestService for upload (works for both)
            final prepared = await service.prepareFileForUpload(file, docRow.fileName ?? 'document');
            final success = await service.uploadDocument(remoteRegistrationId, attachmentType, prepared);
            if (success) {
              await (database.update(database.registrationDocuments)
                    ..where((d) => d.id.equals(docRow.id)))
                  .write(
                adb.RegistrationDocumentsCompanion(
                  uploadStatus: Value('synced'),
                  retryCount: Value(docRow.retryCount),
                ),
              );
              return true;
            }
            return false;
          } else {
            // Admission document upload
            final docRow = await (database.select(database.documents)
                  ..where((d) => d.id.equals(docId)))
                .getSingleOrNull();
            if (docRow == null) return true;

            if (docRow.uploadStatus == 'synced') return true;

            final draftId = docRow.draftId;
            if (draftId == null) return false;

            final draftRow = await (database.select(database.admissionDrafts)
                  ..where((t) => t.id.equals(draftId)))
                .getSingleOrNull();
            if (draftRow == null) return false;

            final remoteRequestId = draftRow.remoteId;
            if (remoteRequestId == null) {
              // admission request not yet created remotely; wait and retry later
              return false;
            }

            final filePath = docRow.localPath;
            final file = File(filePath);
            if (!await file.exists()) return false;

            final prepared = await service.prepareFileForUpload(file, docRow.fileName ?? 'document');
            final success = await service.uploadDocument(remoteRequestId, attachmentType, prepared);
            if (success) {
              await (database.update(database.documents)
                    ..where((d) => d.id.equals(docRow.id)))
                  .write(
                adb.DocumentsCompanion(
                  uploadStatus: Value('synced'),
                  retryCount: Value(docRow.retryCount),
                ),
              );
              return true;
            }

            return false;
          }
        } catch (_) {
          return false;
        }
      case 'admission.submit':
        try {
          final draftId = op.payload['draftId'] as int?;
          if (draftId == null || draftId <= 0) return false;

          final database = adb.AppDatabase();
          final draftRow = await (database.select(database.admissionDrafts)
                ..where((t) => t.id.equals(draftId)))
              .getSingleOrNull();
          if (draftRow == null) return false;

          final remoteId = draftRow.remoteId;
          if (remoteId == null) {
            // admission request not yet created remotely; wait and retry later
            return false;
          }

          // Try to submit the admission request to remote
          final result = await service.submitAdmissionRequest(remoteId);
          if (result != null && result.success) {
            // Update draft status to submitted
            await (database.update(database.admissionDrafts)
                  ..where((t) => t.id.equals(draftId)))
                .write(
              adb.AdmissionDraftsCompanion(
                status: Value('submitted'),
                updatedAt: Value(DateTime.now()),
              ),
            );
            return true;
          }
          return false;
        } catch (_) {
          return false;
        }
      case 'admission.create':
        try {
          final draftId = op.payload['draftId'] as int?;
          final campaignId = op.payload['campaignId'] as int?;
          if (draftId == null || draftId <= 0) return false;
          if (campaignId == null || campaignId <= 0) return false;

          final database = adb.AppDatabase();
          final draftRow = await (database.select(database.admissionDrafts)
                ..where((t) => t.id.equals(draftId)))
              .getSingleOrNull();
          if (draftRow == null) return false;

          // Skip if already has remote ID
          if (draftRow.remoteId != null) return true;

          // Parse draft data and create AdmissionRequestModel
          final draftDataJson = draftRow.dataJson;
          final draftDataMap = jsonDecode(draftDataJson) as Map<String, dynamic>? ?? {};
          
          // Reconstruct the AdmissionRequestModel from stored JSON
          final model = AdmissionRequestModel.fromJson(draftDataMap);

          // Try to create the admission request on remote
          final result = await service.createAdmissionRequest(campaignId, model);
          if (result != null && result.id > 0) {
            // Update draft with remote ID
            await (database.update(database.admissionDrafts)
                  ..where((t) => t.id.equals(draftId)))
                .write(
              adb.AdmissionDraftsCompanion(
                remoteId: Value(result.id),
                status: Value('created'),
                updatedAt: Value(DateTime.now()),
              ),
            );
            return true;
          }
          return false;
        } catch (_) {
          return false;
        }
      case 'registration.submit':
        try {
          final draftId = op.payload['draftId'] as int?;
          if (draftId == null || draftId <= 0) return false;

          final database = adb.AppDatabase();
          final draftRow = await (database.select(database.registrationDrafts)
                ..where((t) => t.id.equals(draftId)))
              .getSingleOrNull();
          if (draftRow == null) return false;

          final draftDataMap = jsonDecode(draftRow.dataJson) as Map<String, dynamic>? ?? {};
          final draft = _buildRegistrationDraft(draftDataMap);
          final documents = (await (database.select(database.registrationDocuments)
                    ..where((d) => d.draftId.equals(draftId)))
                .get())
              .map((row) => RegistrationDocument(
                    fileName: row.fileName ?? row.localPath.split('/').last,
                    filePath: row.localPath,
                    type: row.mimeType ?? 'OTHER',
                    sizeBytes: row.size ?? 0,
                  ))
              .toList();

          final registrationService = RegistrationService();
          final ok = await registrationService.submitRegistration(draft, documents);
          if (ok) {
            await (database.update(database.registrationDrafts)
                  ..where((t) => t.id.equals(draftId)))
                .write(
              adb.RegistrationDraftsCompanion(
                status: Value('submitted'),
                updatedAt: Value(DateTime.now()),
              ),
            );
            return true;
          }
          return false;
        } catch (_) {
          return false;
        }
      case 'registration.create':
        try {
          final draftId = op.payload['draftId'] as int?;
          if (draftId == null || draftId <= 0) return false;

          final database = adb.AppDatabase();
          final draftRow = await (database.select(database.registrationDrafts)
                ..where((t) => t.id.equals(draftId)))
              .getSingleOrNull();
          if (draftRow == null) return false;

          if (draftRow.remoteId != null) return true;

          final draftDataMap = jsonDecode(draftRow.dataJson) as Map<String, dynamic>? ?? {};
          final draft = _buildRegistrationDraft(draftDataMap);
          final documents = (await (database.select(database.registrationDocuments)
                    ..where((d) => d.draftId.equals(draftId)))
                .get())
              .map((row) => RegistrationDocument(
                    fileName: row.fileName ?? row.localPath.split('/').last,
                    filePath: row.localPath,
                    type: row.mimeType ?? 'OTHER',
                    sizeBytes: row.size ?? 0,
                  ))
              .toList();

          final registrationService = RegistrationService();
          final ok = await registrationService.submitRegistration(draft, documents);
          if (ok) {
            await (database.update(database.registrationDrafts)
                  ..where((t) => t.id.equals(draftId)))
                .write(
              adb.RegistrationDraftsCompanion(
                status: Value('created'),
                updatedAt: Value(DateTime.now()),
              ),
            );
            return true;
          }
          return false;
        } catch (_) {
          return false;
        }
      case 'news.sync':
      case 'notification.sync':
        return true;
      default:
        return true;
    }
  }

  Future<void> _tryFullNewsSync() async {
    if (_isNewsSyncing) return;
    _isNewsSyncing = true;
    try {
      final local = NewsLocalDatasource();
      final remote = NewsRemoteDatasource(service: NewsService());
      final repo = NewsRepository(local: local, remote: remote);
      debugPrint('[SYNC] Début fullSyncNews on connectivity');
      await repo.fullSyncNews();
      debugPrint('[SYNC] fullSyncNews terminé');
    } catch (e) {
      debugPrint('[SYNC] Erreur during fullSyncNews: $e');
    } finally {
      _isNewsSyncing = false;
    }
  }

  Future<void> _tryFullPublicationsSync() async {
    if (_isPublicationsSyncing) return;
    _isPublicationsSyncing = true;
    try {
      final local = PublicationLocalDatasource();
      final remote = PublicationRemoteDatasource();
      final repo = PublicationRepository(local: local, remote: remote);
      debugPrint('[SYNC] Début fullSyncPublications on connectivity');
      await repo.fullSyncPublications();
      // notify listeners (UI can refresh)
      try {
        _publicationsSyncedController.add(null);
      } catch (_) {}
      debugPrint('[SYNC] fullSyncPublications terminé');
    } catch (e) {
      debugPrint('[SYNC] Erreur during fullSyncPublications: $e');
    } finally {
      _isPublicationsSyncing = false;
    }
  }

  Future<void> _tryFullConcoursSync() async {
    if (_isConcoursSyncing) return;
    _isConcoursSyncing = true;
    try {
      final local = ConcoursLocalDatasource();
      final remote = ConcoursRemoteDatasource();
      final repo = ConcoursRepository(local: local, remote: remote);
      debugPrint('[SYNC] Début fullSyncConcours on connectivity');
      await repo.fullSyncConcours();
      debugPrint('[SYNC] fullSyncConcours terminé');
    } catch (e) {
      debugPrint('[SYNC] Erreur during fullSyncConcours: $e');
    } finally {
      _isConcoursSyncing = false;
    }
  }

  RegistrationDraft _buildRegistrationDraft(Map<String, dynamic> draftData) {
    final schoolYearId = draftData['schoolYearId'] ?? draftData['anneeScolaireId'];
    final filiereId = draftData['filiereId'];
    final gradeId = draftData['gradeId'];
    final groupId = draftData['groupeId'];

    return RegistrationDraft(
      firstName: draftData['firstName']?.toString() ?? '',
      lastName: draftData['lastName']?.toString() ?? '',
      email: draftData['email']?.toString() ?? '',
      phone: draftData['phone']?.toString() ?? '',
      matricule: draftData['matricule']?.toString() ?? '',
      author: draftData['author']?.toString() ?? '',
      alreadyRegistered: draftData['oldStudent'] is bool
          ? draftData['oldStudent'] as bool
          : false,
      schoolYear: schoolYearId != null
          ? RegistrationOption(
              id: schoolYearId.toString(),
              value: schoolYearId.toString(),
              label: schoolYearId.toString(),
            )
          : null,
      status: draftData['status'] != null
          ? RegistrationOption(
              id: draftData['status'].toString(),
              value: draftData['status'].toString(),
              label: draftData['status'].toString(),
            )
          : null,
      filiere: filiereId != null
          ? RegistrationOption(
              id: filiereId.toString(),
              value: filiereId.toString(),
              label: filiereId.toString(),
            )
          : null,
      grade: gradeId != null
          ? RegistrationOption(
              id: gradeId.toString(),
              value: gradeId.toString(),
              label: gradeId.toString(),
            )
          : null,
      group: groupId != null
          ? RegistrationOption(
              id: groupId.toString(),
              value: groupId.toString(),
              label: groupId.toString(),
            )
          : null,
    );
  }

  Future<void> enqueueDocumentUpload(int documentId, {String? attachmentType, bool isRegistration = false}) async {
    final id = const Uuid().v4();
    final op = SyncOperation(
      clientOperationId: id,
      type: 'document.upload',
      payload: {
        'documentId': documentId,
        'attachmentType': attachmentType ?? 'OTHER',
        'isRegistration': isRegistration,
      },
    );

    await enqueueOperation(op);
  }
}
