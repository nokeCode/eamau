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
  Future<void>? _processingFuture;
  bool _isNewsSyncing = false;
  bool _isPublicationsSyncing = false;
  bool _isConcoursSyncing = false;
  final StreamController<void> _publicationsSyncedController = StreamController<void>.broadcast();
  // Emits an admission draft's local id whenever its `admission.submit`
  // operation eventually succeeds in the background
  final StreamController<int> _admissionSubmittedController = StreamController<int>.broadcast();
  // Emits a registration draft's local id whenever its `registration.submit`
  // operation eventually succeeds in the background
  final StreamController<int> _registrationSubmittedController = StreamController<int>.broadcast();
  final Map<int, bool> _admissionAuthRequired = {};
  final Map<int, bool> _registrationAuthRequired = {};
  final Map<int, bool> _registrationAlreadySubmittedElsewhere = {};

  /// Whether the last known HTTP response for [draftId]'s admission
  /// create/submit/document-upload calls was a 401.
  bool admissionRequiresAuth(int draftId) => _admissionAuthRequired[draftId] ?? false;

  /// Whether the last known HTTP response for [draftId]'s registration
  /// create/submit/document-upload calls was a 401.
  bool registrationRequiresAuth(int draftId) => _registrationAuthRequired[draftId] ?? false;

  /// Whether a document.upload for [draftId] was permanently rejected
  /// because that registration was already finalized ("Cette demande ne
  /// peut plus recevoir de document.") — a terminal state, distinct from a
  /// transient network/server error: retrying it will never succeed.
  bool registrationAlreadySubmittedElsewhere(int draftId) =>
      _registrationAlreadySubmittedElsewhere[draftId] ?? false;

  void _recordAdmissionAuthStatus(int draftId, int? statusCode) {
    if (statusCode == 401) {
      _admissionAuthRequired[draftId] = true;
    } else if (statusCode != null) {
      _admissionAuthRequired[draftId] = false;
    }
  }

  void _recordRegistrationAuthStatus(int draftId, int? statusCode) {
    if (statusCode == 401) {
      _registrationAuthRequired[draftId] = true;
    } else if (statusCode != null) {
      _registrationAuthRequired[draftId] = false;
    }
  }

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
  Stream<int> get onAdmissionSubmitted => _admissionSubmittedController.stream;
  Stream<int> get onRegistrationSubmitted => _registrationSubmittedController.stream;

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

  /// Triggers a processing pass over the whole pending queue and returns its
  /// [Future]. Exposed so callers (e.g. `AdmissionRepository.submitDraft`)
  /// can bound how long *they* wait for it — via `.timeout(...)` — without
  /// cancelling the pass itself: Dart futures can't be cancelled, so the
  /// processing keeps running to completion in the background regardless of
  /// whether the caller gave up waiting on it.
  Future<void> processQueueNow() => _processQueue();

  /// Processes the pending queue, guaranteeing that every caller's own
  /// awaited call results in at least one full pass over the queue that
  /// includes whatever was enqueued right before calling this method.
  ///
  /// A plain "if already running, return" guard would let a background pass
  /// triggered by [ConnectivityService.onConnectivityChanged] (see [start])
  /// silently swallow an operation just enqueued by e.g.
  /// `AdmissionRepository.submitDraft`: that operation would stay `pending`
  /// until some later pass, after the caller already read the (stale, not
  /// yet synced) local status to decide which UX message to show — making a
  /// genuinely online submission look like it fell back to the offline
  /// queue. Chaining onto any in-flight pass (and always running one more
  /// pass afterwards) closes that race.
  Future<void> _processQueue() {
    // `catchError` before chaining the next pass: without it, a rejected
    // previous pass would permanently poison every future call through
    // `.then`, silently freezing sync for the rest of the app session.
    final future = (_processingFuture ?? Future<void>.value())
        .catchError((_) {})
        .then((_) => _runProcessQueue());
    _processingFuture = future;
    return future;
  }

  /// Runs one pass over the queue. Must never let an exception escape: this
  /// is awaited directly by UI code (e.g. `AdmissionUploadSection`, via
  /// `processQueueNow()`) with no enclosing try/catch of its own, on the
  /// assumption that "the pass didn't finish in time" is the only way this
  /// can fail to produce a definitive answer. A DB hiccup in the queue
  /// bookkeeping itself (outside any single operation's own try/catch
  /// below) used to violate that: it rejected the whole shared processing
  /// future, which then propagated into whatever UI call was awaiting it —
  /// leaving e.g. a document upload stuck showing "Envoi en cours" forever,
  /// since the code that would flip it to "queued" never ran.
  Future<void> _runProcessQueue() async {
    try {
      await _runProcessQueueUnsafe();
    } catch (error, stackTrace) {
      debugPrint('[SYNC][ERROR] exception non gérée dans _runProcessQueue: '
          'type=${error.runtimeType} error=$error');
      debugPrint('[SYNC][ERROR] stackTrace=$stackTrace');
    }
  }

  Future<void> _runProcessQueueUnsafe() async {
    final ops = await _queue.all;
    if (ops.isEmpty) return;

    final online = await ConnectivityService().isOnline();
    if (!online) return;

    for (final op in List<SyncOperation>.from(ops)) {
      final isAdmissionOp = _isAdmissionRelatedOp(op);

      if (op.status == SyncStatus.synced) {
        await _queue.remove(op.clientOperationId);
        continue;
      }

      if (isAdmissionOp) {
        debugPrint(
          '[SYNC][ADMISSION] traitement opération type=${op.type} '
          'clientOperationId=${op.clientOperationId} retryCount=${op.retryCount}',
        );
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
        if (isAdmissionOp) {
          debugPrint('[SYNC][ADMISSION] résultat opération type=${op.type} success=$success');
        }
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

        if (isAdmissionOp) {
          debugPrint(
            '[SYNC][ADMISSION] opération échouée type=${op.type} nextRetry=$nextRetry '
            '${nextRetry >= 5 ? "(abandon après 5 tentatives)" : "(sera retentée)"}',
          );
        }

        if (nextRetry >= 5) {
          await _queue.remove(op.clientOperationId);
        }
      } catch (error, stackTrace) {
        if (isAdmissionOp) {
          debugPrint(
            '[SYNC][ADMISSION][ERROR] exception non gérée type=${op.type} '
            'clientOperationId=${op.clientOperationId} exceptionType=${error.runtimeType} error=$error',
          );
          debugPrint('[SYNC][ADMISSION][ERROR] stackTrace=$stackTrace');
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
      }
    }
  }

  bool _isAdmissionRelatedOp(SyncOperation op) {
    if (op.type == 'admission.create' || op.type == 'admission.submit') {
      return true;
    }
    return op.type == 'document.upload' && op.payload['isRegistration'] != true;
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

          final attributeSlug = docRow.documentType;
          if (attributeSlug == null || attributeSlug.isEmpty) {
            // Document was attached without a matching concours attribute slug;
            // uploading would be rejected by the backend, so drop the retry loop.
            return true;
          }

          final concoursService = ConcoursFormService();
          final prepared = file;
          final uploaded = await concoursService.uploadDocument(
            postulationId: remotePostulationId,
            attributeSlug: attributeSlug,
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

            final regService = RegistrationService();
            final docType = docRow.documentType ?? attachmentType;
            final success = await regService.uploadDocumentFile(
              remoteRegistrationId,
              docType,
              file,
              fileName: docRow.fileName,
              idempotencyKey: op.clientOperationId,
            );
            _recordRegistrationAuthStatus(draftId, regService.lastStatusCode);
            if (regService.lastDocumentUploadRejectedFinal) {
              _registrationAlreadySubmittedElsewhere[draftId] = true;
            }

            if (success) {
              await (database.update(database.registrationDocuments)
                    ..where((d) => d.id.equals(docRow.id)))
                  .write(
                adb.RegistrationDocumentsCompanion(
                  uploadStatus: const Value('synced'),
                  retryCount: Value(docRow.retryCount),
                ),
              );
              return true;
            }

            if (regService.lastDocumentUploadRejectedFinal) {
              // Permanent rejection (registration already finalized):
              // retrying will never succeed, so stop hammering the server —
              // drop this operation from the queue instead of the usual
              // retry-up-to-5-times path. The document stays un-synced
              // locally; RegistrationRepository.submitDraft reads the flag
              // set above to report this as its own outcome.
              return true;
            }
            return false;
          } else {
            // Admission document upload
            debugPrint('[ADMISSION][UPLOAD] début document.upload documentId=$docId attachmentType=$attachmentType');

            final docRow = await (database.select(database.documents)
                  ..where((d) => d.id.equals(docId)))
                .getSingleOrNull();
            if (docRow == null) {
              debugPrint('[ADMISSION][UPLOAD] documentId=$docId introuvable en local, opération abandonnée');
              return true;
            }

            if (docRow.uploadStatus == 'synced') {
              debugPrint('[ADMISSION][UPLOAD] documentId=$docId déjà synchronisé, rien à faire');
              return true;
            }

            final draftId = docRow.draftId;
            if (draftId == null) {
              debugPrint('[ADMISSION][ERROR][UPLOAD] documentId=$docId sans draftId associé');
              return false;
            }

            final draftRow = await (database.select(database.admissionDrafts)
                  ..where((t) => t.id.equals(draftId)))
                .getSingleOrNull();
            if (draftRow == null) {
              debugPrint('[ADMISSION][ERROR][UPLOAD] draft introuvable en local draftId=$draftId '
                  'pour documentId=$docId');
              return false;
            }

            final remoteRequestId = draftRow.remoteId;
            if (remoteRequestId == null) {
              // admission request not yet created remotely; wait and retry later
              debugPrint('[ADMISSION][UPLOAD] remoteId absent pour draftId=$draftId, admission.create '
                  'pas encore réussi -> retry plus tard (documentId=$docId)');
              return false;
            }

            final filePath = docRow.localPath;
            final file = File(filePath);
            if (!await file.exists()) {
              debugPrint('[ADMISSION][ERROR][UPLOAD] fichier local introuvable path=$filePath documentId=$docId');
              return false;
            }

            final url = '${AdmissionRequestService.baseUrl}/admission/requests/$remoteRequestId/documents';
            debugPrint('[ADMISSION][UPLOAD] URL exacte appelée=$url fichier=${docRow.fileName}');

            final prepared = await service.prepareFileForUpload(file, docRow.fileName ?? 'document');
            final success = await service.uploadDocument(
              remoteRequestId,
              attachmentType,
              prepared,
              idempotencyKey: op.clientOperationId,
            );
            debugPrint('[ADMISSION][UPLOAD] code HTTP reçu=${service.lastStatusCode} documentId=$docId');
            _recordAdmissionAuthStatus(draftId, service.lastStatusCode);

            if (success) {
              await (database.update(database.documents)
                    ..where((d) => d.id.equals(docRow.id)))
                  .write(
                adb.DocumentsCompanion(
                  uploadStatus: Value('synced'),
                  retryCount: Value(docRow.retryCount),
                ),
              );
              debugPrint('[ADMISSION][UPLOAD] fin document.upload succès documentId=$docId');
              return true;
            }

            debugPrint('[ADMISSION][ERROR][UPLOAD] échec upload documentId=$docId '
                'statusCode=${service.lastStatusCode} body=${service.lastErrorMessage}');
            debugPrint('[ADMISSION][UPLOAD] fin document.upload échec documentId=$docId');
            return false;
          }
        } catch (error, stackTrace) {
          final isRegistration = op.payload['isRegistration'] as bool? ?? false;
          if (!isRegistration) {
            debugPrint('[ADMISSION][ERROR][UPLOAD] exception type=${error.runtimeType} error=$error '
                'documentId=${op.payload['documentId']}');
            debugPrint('[ADMISSION][ERROR][UPLOAD] stackTrace=$stackTrace');
          }
          return false;
        }
      case 'admission.submit':
        debugPrint('[ADMISSION][FINALIZE] début admission.submit payload=${op.payload}');
        try {
          final draftId = op.payload['draftId'] as int?;
          if (draftId == null || draftId <= 0) {
            debugPrint('[ADMISSION][ERROR][FINALIZE] draftId invalide/absent: ${op.payload['draftId']}');
            return false;
          }

          final database = adb.AppDatabase();
          final draftRow = await (database.select(database.admissionDrafts)
                ..where((t) => t.id.equals(draftId)))
              .getSingleOrNull();
          if (draftRow == null) {
            debugPrint('[ADMISSION][ERROR][FINALIZE] draft introuvable en local draftId=$draftId');
            return false;
          }

          final remoteId = draftRow.remoteId;
          if (remoteId == null) {
            // admission request not yet created remotely; wait and retry later
            debugPrint('[ADMISSION][FINALIZE] remoteId absent pour draftId=$draftId, admission.create '
                'pas encore réussi -> retry plus tard');
            return false;
          }

          final url = '${AdmissionRequestService.baseUrl}/admission/requests/$remoteId/submit';
          debugPrint('[ADMISSION][FINALIZE] URL exacte appelée=$url remoteId=$remoteId');

          // Try to submit the admission request to remote
          final result = await service.submitAdmissionRequest(
            remoteId,
            idempotencyKey: op.clientOperationId,
          );
          debugPrint('[ADMISSION][FINALIZE] code HTTP reçu=${service.lastStatusCode}');
          _recordAdmissionAuthStatus(draftId, service.lastStatusCode);

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
            debugPrint('[ADMISSION][FINALIZE] fin admission.submit succès draftId=$draftId statut final=submitted');
            try {
              _admissionSubmittedController.add(draftId);
            } catch (_) {}
            return true;
          }

          debugPrint('[ADMISSION][ERROR][FINALIZE] échec soumission: statusCode=${service.lastStatusCode} '
              'body=${service.lastErrorMessage}');
          debugPrint('[ADMISSION][FINALIZE] fin admission.submit échec draftId=$draftId');
          return false;
        } catch (error, stackTrace) {
          debugPrint('[ADMISSION][ERROR][FINALIZE] exception type=${error.runtimeType} error=$error');
          debugPrint('[ADMISSION][ERROR][FINALIZE] stackTrace=$stackTrace');
          return false;
        }
      case 'admission.create':
        debugPrint('[ADMISSION][CREATE] début admission.create payload=${op.payload}');
        try {
          final draftId = op.payload['draftId'] as int?;
          final campaignId = op.payload['campaignId'] as int?;
          if (draftId == null || draftId <= 0) {
            debugPrint('[ADMISSION][ERROR][CREATE] draftId invalide/absent: ${op.payload['draftId']}');
            return false;
          }
          if (campaignId == null || campaignId <= 0) {
            debugPrint('[ADMISSION][ERROR][CREATE] campaignId invalide/absent: ${op.payload['campaignId']}');
            return false;
          }
          debugPrint('[ADMISSION][CREATE] campaignId envoyé=$campaignId draftId=$draftId');

          final database = adb.AppDatabase();
          final draftRow = await (database.select(database.admissionDrafts)
                ..where((t) => t.id.equals(draftId)))
              .getSingleOrNull();
          if (draftRow == null) {
            debugPrint('[ADMISSION][ERROR][CREATE] draft introuvable en local draftId=$draftId');
            return false;
          }

          // Skip if already has remote ID
          if (draftRow.remoteId != null) {
            debugPrint('[ADMISSION][CREATE] draftId=$draftId a déjà un remoteId=${draftRow.remoteId}, rien à faire');
            return true;
          }

          // Parse draft data and create AdmissionRequestModel
          final draftDataJson = draftRow.dataJson;
          final draftDataMap = jsonDecode(draftDataJson) as Map<String, dynamic>? ?? {};

          // Reconstruct the AdmissionRequestModel from stored JSON
          final model = AdmissionRequestModel.fromJson(draftDataMap);

          final url = '${AdmissionRequestService.baseUrl}/admission-campaigns/$campaignId/requests';
          debugPrint('[ADMISSION][CREATE] URL exacte appelée=$url');
          // Only log field names, never their values, to avoid leaking personal data.
          debugPrint('[ADMISSION][CREATE] payload envoyé (clés uniquement)=${draftDataMap.keys.toList()}');

          // Try to create the admission request on remote
          final result = await service.createAdmissionRequest(
            campaignId,
            model,
            idempotencyKey: op.clientOperationId,
          );
          debugPrint('[ADMISSION][CREATE] code HTTP reçu=${service.lastStatusCode}');
          _recordAdmissionAuthStatus(draftId, service.lastStatusCode);

          if (result != null && result.id > 0) {
            debugPrint('[ADMISSION][CREATE] remoteId obtenu=${result.id}');
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
            debugPrint('[ADMISSION][CREATE] fin admission.create succès draftId=$draftId remoteId=${result.id}');
            return true;
          }

          debugPrint('[ADMISSION][ERROR][CREATE] échec création: statusCode=${service.lastStatusCode} '
              'body=${service.lastErrorMessage}');
          debugPrint('[ADMISSION][CREATE] fin admission.create échec draftId=$draftId');
          return false;
        } catch (error, stackTrace) {
          debugPrint('[ADMISSION][ERROR][CREATE] exception type=${error.runtimeType} error=$error');
          debugPrint('[ADMISSION][ERROR][CREATE] stackTrace=$stackTrace');
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

          final remoteId = draftRow.remoteId;
          if (remoteId == null) {
            // Registration not yet created remotely; wait for registration.create
            return false;
          }

          // Check if all documents for this draft are synced
          final docs = await (database.select(database.registrationDocuments)
                ..where((d) => d.draftId.equals(draftId)))
              .get();
          final allDocsSynced = docs.every((d) => d.uploadStatus == 'synced');
          if (!allDocsSynced) {
            // Documents still pending upload; wait for document.upload operations
            return false;
          }

          final registrationService = RegistrationService();
          final ok = await registrationService.finalizeRegistration(
            remoteId,
            idempotencyKey: op.clientOperationId,
          );
          _recordRegistrationAuthStatus(draftId, registrationService.lastStatusCode);

          if (ok) {
            await (database.update(database.registrationDrafts)
                  ..where((t) => t.id.equals(draftId)))
                .write(
              adb.RegistrationDraftsCompanion(
                status: const Value('submitted'),
                updatedAt: Value(DateTime.now()),
              ),
            );
            try {
              _registrationSubmittedController.add(draftId);
            } catch (_) {}
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

          // Skip if already has remote ID
          if (draftRow.remoteId != null) return true;

          final draftDataMap = jsonDecode(draftRow.dataJson) as Map<String, dynamic>? ?? {};
          final draft = RegistrationDraft.fromJson(draftDataMap);

          final registrationService = RegistrationService();
          final result = await registrationService.createRegistration(
            draft,
            idempotencyKey: op.clientOperationId,
          );
          _recordRegistrationAuthStatus(draftId, registrationService.lastStatusCode);

          if (result != null && result.registrationId > 0) {
            await (database.update(database.registrationDrafts)
                  ..where((t) => t.id.equals(draftId)))
                .write(
              adb.RegistrationDraftsCompanion(
                remoteId: Value(result.registrationId),
                status: const Value('created'),
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
