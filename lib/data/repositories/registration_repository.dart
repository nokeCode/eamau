import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../../core/connectivity/connectivity_service.dart';
import '../../core/database/app_database.dart' as adb;
import '../../core/sync/sync_engine.dart';
import '../../core/sync/sync_queue.dart';
import '../../models/registration/registration_referential_model.dart';
import '../../models/registration/registration_status_model.dart';
import '../../models/registration/registration_submit_outcome.dart';
import '../local/registration_local_datasource.dart';
import '../remote/registration_remote_datasource.dart';

class RegistrationRepository {
  final RegistrationLocalDatasource local;
  final RegistrationRemoteDatasource remote;

  RegistrationRepository({
    required this.local,
    required this.remote,
  });

  static const Duration _quickSyncAttempt = Duration(seconds: 10);

  /// Cache-First retrieval of referentials
  Future<RegistrationReferentialCollection> getReferentials() async {
    final isOnline = await ConnectivityService().isOnline();

    if (isOnline) {
      try {
        final remoteCollection = await remote.getReferentials();
        if (remoteCollection.filieres.isNotEmpty ||
            remoteCollection.grades.isNotEmpty ||
            remoteCollection.schoolYears.isNotEmpty) {
          // Cache the referentials locally for offline use
          final cacheMap = {
            'data': {
              'schoolYears': remoteCollection.schoolYears.map((o) => o.toJson()).toList(),
              'statuses': remoteCollection.statuses.map((o) => o.toJson()).toList(),
              'filieres': remoteCollection.filieres.map((o) => o.toJson()).toList(),
              'grades': remoteCollection.grades.map((o) => o.toJson()).toList(),
              'groups': remoteCollection.groups.map((o) => o.toJson()).toList(),
              'semesters': remoteCollection.semesters.map((o) => o.toJson()).toList(),
              'documentTypes': remoteCollection.documentTypes.map((o) => o.toJson()).toList(),
            }
          };
          await local.cacheReferentials(jsonEncode(cacheMap));
          return remoteCollection;
        }
      } catch (e) {
        debugPrint('[REGISTRATION_REPO] Remote referentials error: $e, falling back to local cache');
      }
    }

    // Fallback to local SQLite cache
    final cachedJson = await local.getCachedReferentials();
    if (cachedJson != null && cachedJson.isNotEmpty) {
      try {
        final decoded = jsonDecode(cachedJson);
        final cachedCollection = RegistrationReferentialCollection.fromJson(decoded);
        if (cachedCollection.filieres.isNotEmpty || cachedCollection.grades.isNotEmpty) {
          return cachedCollection;
        }
      } catch (_) {}
    }

    // Default static fallback if completely offline on first launch
    return const RegistrationReferentialCollection(
      documentTypes: [
        RegistrationOption(id: '1', value: 'Demande manuscrites', label: 'Demande manuscrites'),
        RegistrationOption(id: '2', value: 'Certificat Médical', label: 'Certificat Médical'),
        RegistrationOption(id: '3', value: 'Extrait de naissance', label: 'Extrait de naissance'),
        RegistrationOption(id: '4', value: 'Certificat de nationalité', label: 'Certificat de nationalité'),
        RegistrationOption(id: '5', value: 'Copie certifié conforme de diplôme', label: 'Copie certifié conforme de diplôme'),
        RegistrationOption(id: '6', value: "Preuve de versement frais d'inscription", label: "Preuve de versement frais d'inscription"),
        RegistrationOption(id: '7', value: 'Preuve de versement frais de scolarité', label: 'Preuve de versement frais de scolarité'),
        RegistrationOption(id: '8', value: "Preuve d'attestation de bourse ou liste collective de boursiers", label: "Preuve d'attestation de bourse ou liste collective de boursiers"),
      ],
    );
  }

  /// Cache-First retrieval of campaign status
  Future<RegistrationStatus> getRegistrationStatus() async {
    final isOnline = await ConnectivityService().isOnline();

    if (isOnline) {
      try {
        final remoteStatus = await remote.getRegistrationStatus();
        final cacheMap = {
          'data': {
            'open': remoteStatus.open,
            'canCreate': remoteStatus.canCreate,
            'activeSchoolYear': remoteStatus.activeSchoolYear?.toJson(),
            'message': remoteStatus.message,
          }
        };
        await local.cacheStatus(jsonEncode(cacheMap));
        return remoteStatus;
      } catch (e) {
        debugPrint('[REGISTRATION_REPO] Remote status error: $e, falling back to local cache');
      }
    }

    // Fallback to local SQLite cache
    final cachedJson = await local.getCachedStatus();
    final updatedAt = await local.getCachedReferentialsUpdatedAt();
    if (cachedJson != null && cachedJson.isNotEmpty) {
      try {
        final decoded = jsonDecode(cachedJson);
        final cachedStatus = RegistrationStatus.fromJson(decoded['data'] ?? decoded);
        final isStale = updatedAt == null || DateTime.now().difference(updatedAt).inHours > 24;
        return RegistrationStatus(
          open: cachedStatus.open,
          canCreate: cachedStatus.canCreate,
          activeSchoolYear: cachedStatus.activeSchoolYear,
          message: isStale
              ? '${cachedStatus.message} (Informations locales hors-ligne)'
              : cachedStatus.message,
        );
      } catch (_) {}
    }

    return const RegistrationStatus(
      open: true,
      canCreate: true,
      activeSchoolYear: null,
      message: 'Mode hors-ligne : les inscriptions sont ouvertes localement.',
    );
  }

  /// Save a draft locally (durable, offline-ready)
  Future<int> saveDraftLocally({
    required RegistrationDraft draft,
    String status = 'draft',
  }) async {
    return await local.saveDraft(
      dataJson: jsonEncode(draft.toLocalMap()),
      status: status,
    );
  }

  /// Update an existing local draft in place
  Future<void> updateDraftLocally({
    required int draftId,
    required RegistrationDraft draft,
  }) async {
    await local.updateDraftData(draftId, jsonEncode(draft.toLocalMap()));
  }

  /// Attach a document to a draft (copies to permanent storage)
  Future<int> attachDocumentToDraft({
    required int draftId,
    required File file,
    required String fileName,
    required String mimeType,
    String? documentType,
  }) async {
    return await local.attachDocument(
      draftId: draftId,
      file: file,
      fileName: fileName,
      mimeType: mimeType,
      documentType: documentType,
    );
  }

  /// Get all local drafts
  Future<List<adb.RegistrationDraft>> getLocalDrafts() async {
    return await local.getAllDrafts();
  }

  /// Get a single draft by ID
  Future<adb.RegistrationDraft?> getDraft(int draftId) async {
    return await local.getDraft(draftId);
  }

  /// Get documents for a draft
  Future<List<adb.RegistrationDocument>> getDocumentsForDraft(int draftId) async {
    return await local.getDocumentsForDraft(draftId);
  }

  /// Submit a draft using the sequential offline-first queue:
  /// registration.create -> document.upload (for each document) -> registration.submit
  Future<RegistrationSubmitOutcome> submitDraft(int draftId) async {
    debugPrint('[REGISTRATION][SUBMIT] submitDraft() appelé draftId=$draftId');
    try {
      final draft = await local.getDraft(draftId);
      if (draft == null) {
        debugPrint('[REGISTRATION][ERROR][SUBMIT] draft introuvable en local draftId=$draftId');
        return RegistrationSubmitOutcome.failed;
      }

      final wasOnline = await ConnectivityService().isOnline();
      debugPrint('[REGISTRATION][SUBMIT] wasOnline=$wasOnline draftId=$draftId');

      // 1. Mark draft as pending sync in local SQLite
      await local.updateDraftStatus(draftId, 'pending_sync');

      // 2. Enqueue registration.create
      final createOpId = const Uuid().v4();
      final createOp = SyncOperation(
        clientOperationId: createOpId,
        type: 'registration.create',
        payload: {
          'draftId': draftId,
        },
      );
      await SyncQueue().enqueue(createOp);

      // 3. Enqueue document.upload for each non-synced document
      final pendingDocs = await local.getDocumentsForDraft(draftId);
      for (final doc in pendingDocs) {
        if (doc.uploadStatus == 'synced') continue;
        final docOpId = const Uuid().v4();
        final docOp = SyncOperation(
          clientOperationId: docOpId,
          type: 'document.upload',
          payload: {
            'documentId': doc.id,
            'attachmentType': doc.documentType ?? 'OTHER',
            'isRegistration': true,
          },
        );
        await SyncQueue().enqueue(docOp);
      }

      // 4. Enqueue registration.submit
      final submitOpId = const Uuid().v4();
      final submitOp = SyncOperation(
        clientOperationId: submitOpId,
        type: 'registration.submit',
        payload: {
          'draftId': draftId,
        },
      );
      await SyncQueue().enqueue(submitOp);

      if (!wasOnline) {
        debugPrint('[REGISTRATION][SUBMIT] Appareil hors-ligne -> outcome=queuedOffline draftId=$draftId');
        return RegistrationSubmitOutcome.queuedOffline;
      }

      // 5. Try quick bounded sync pass if online
      debugPrint('[REGISTRATION][SUBMIT] Tentative réseau rapide (max ${_quickSyncAttempt.inSeconds}s)');
      await SyncEngine().processQueueNow().timeout(
        _quickSyncAttempt,
        onTimeout: () {
          debugPrint('[REGISTRATION][SUBMIT] Timeout tentative rapide, synchro en arrière-plan');
        },
      );

      final refreshedDraft = await local.getDraft(draftId);
      final refreshedDocs = await local.getDocumentsForDraft(draftId);
      final fullySynced = refreshedDraft?.status == 'submitted' &&
          refreshedDocs.every((doc) => doc.uploadStatus == 'synced');

      if (fullySynced) {
        return RegistrationSubmitOutcome.submittedOnline;
      } else if (SyncEngine().registrationRequiresAuth(draftId)) {
        return RegistrationSubmitOutcome.requiresAuthentication;
      } else if (SyncEngine().registrationAlreadySubmittedElsewhere(draftId)) {
        debugPrint('[REGISTRATION][SUBMIT] déjà soumise via cet email -> '
            'outcome=alreadySubmittedElsewhere draftId=$draftId');
        return RegistrationSubmitOutcome.alreadySubmittedElsewhere;
      } else {
        return RegistrationSubmitOutcome.queuedAfterError;
      }
    } catch (e, st) {
      debugPrint('[REGISTRATION][ERROR][SUBMIT] Exception dans submitDraft: $e\n$st');
      return RegistrationSubmitOutcome.failed;
    }
  }

  /// Remove a draft and its documents
  Future<void> deleteDraft(int draftId) async {
    await local.deleteDraft(draftId);
  }

  /// Remove a single document
  Future<void> removeDocument(int docId) async {
    await local.removeDocument(docId);
  }

  /// Get pending documents
  Future<List<adb.RegistrationDocument>> getPendingDocuments() async {
    return await local.getPendingDocuments();
  }
}
