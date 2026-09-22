import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../../core/connectivity/connectivity_service.dart';
import '../../core/database/app_database.dart' as adb;
import '../../core/sync/sync_engine.dart';
import '../../core/sync/sync_queue.dart';
import '../local/admission_local_datasource.dart';
import '../remote/admission_remote_datasource.dart';

/// Result of [AdmissionRepository.submitDraft], used by the UI to show a
/// message that actually matches what happened (immediate online success,
/// offline queueing, or a queued fallback after a failed online attempt).
enum AdmissionSubmitOutcome {
  /// The device was online and admission.create → document uploads →
  /// admission.submit all completed successfully before returning.
  submittedOnline,

  /// The device was offline: the draft and its documents were saved
  /// locally and the operations were queued for later sync.
  queuedOffline,

  /// The device reported being online but the immediate sync attempt did
  /// not fully complete (network error, server error, timeout...). The
  /// request was preserved locally and queued for retry.
  queuedAfterError,

  /// The draft could not even be saved/queued locally.
  failed,

  /// The device was online and the API answered, but rejected the request
  /// with 401 (Authentification requise): the user isn't logged in. The
  /// draft is preserved locally so the UI can send them to log in and come
  /// back to finish this exact submission afterwards.
  requiresAuthentication,
}

class AdmissionRepository {
  final AdmissionLocalDatasource local;
  final AdmissionRemoteDatasource remote;

  AdmissionRepository({
    required this.local,
    required this.remote,
  });

  /// Save a draft locally (no remote sync yet)
  Future<int> saveDraftLocally({
    required Map<String, dynamic> draftData,
    String status = 'draft',
  }) async {
    return await local.saveDraft(
      dataJson: jsonEncode(draftData),
      status: status,
    );
  }

  /// Update an already-existing local draft's data in place, instead of
  /// creating a new one — used when resuming a submission after the user
  /// was sent to log in (same draftId, same admission.create retry loop).
  Future<void> updateDraftLocally({
    required int draftId,
    required Map<String, dynamic> draftData,
  }) async {
    await local.updateDraftData(draftId, jsonEncode(draftData));
  }

  /// Attach a document to a draft (saves locally and enqueues upload)
  Future<int> attachDocumentToDraft({
    required int draftId,
    required File file,
    required String fileName,
    required String mimeType,
    String? attachmentType,
  }) async {
    return await local.attachDocument(
      draftId: draftId,
      file: file,
      fileName: fileName,
      mimeType: mimeType,
      attachmentType: attachmentType,
    );
  }

  /// Get all local drafts
  Future<List<adb.AdmissionDraft>> getLocalDrafts() async {
    return await local.getAllDrafts();
  }

  /// Get a single draft by ID
  Future<adb.AdmissionDraft?> getDraft(int draftId) async {
    return await local.getDraft(draftId);
  }

  /// Get documents for a draft
  Future<List<adb.Document>> getDocumentsForDraft(int draftId) async {
    return await local.getDocumentsForDraft(draftId);
  }

  /// How long [submitDraft] waits for a "try now" network attempt before
  /// giving up on the UI's behalf and returning [AdmissionSubmitOutcome.
  /// queuedAfterError]. Deliberately much shorter than the HTTP client
  /// timeouts (30-60s): the goal is a snappy UI, not a definitive answer.
  /// SyncEngine keeps processing in the background regardless — see
  /// [SyncEngine.processQueueNow].
  static const Duration _quickSyncAttempt = Duration(seconds: 10);

  /// Submit a draft.
  ///
  /// Always saves the draft and its operations through the existing
  /// offline-first queue (SyncQueue/SyncEngine) so no data is ever lost.
  /// When the device is online, this gives the queue a short window to
  /// finish create -> documents -> submit before returning, so it can
  /// report a real online success. If that window elapses (slow/unreachable
  /// API), it returns [AdmissionSubmitOutcome.queuedAfterError] immediately
  /// instead of blocking the UI for the full HTTP timeout — the queue keeps
  /// working in the background and [SyncEngine.onAdmissionSubmitted] fires
  /// once it actually finishes.
  Future<AdmissionSubmitOutcome> submitDraft(int draftId) async {
    debugPrint('[ADMISSION][SUBMIT] submitDraft() appelé draftId=$draftId');
    try {
      final draft = await local.getDraft(draftId);
      if (draft == null) {
        debugPrint('[ADMISSION][ERROR][SUBMIT] draft introuvable en local draftId=$draftId');
        return AdmissionSubmitOutcome.failed;
      }

      final wasOnline = await ConnectivityService().isOnline();
      debugPrint('[ADMISSION][SUBMIT] connectivité au moment de la soumission: wasOnline=$wasOnline');

      // Mark draft as pending sync locally
      await local.updateDraftStatus(draftId, 'pending_sync');

      final draftDataMap = jsonDecode(draft.dataJson) as Map<String, dynamic>? ?? {};
      final campaignId = draftDataMap['campaignId'];
      debugPrint('[ADMISSION][SUBMIT] campaignId envoyé=$campaignId');
      // Only log field names, never their values, to avoid leaking personal data.
      debugPrint('[ADMISSION][SUBMIT] payload draft (clés uniquement)=${draftDataMap.keys.toList()}');

      // Persist the operations to the queue first (fast, local-only writes)
      // in the correct dependency order: create -> upload documents ->
      // submit. Network processing is triggered once, below, as a single
      // bounded pass — instead of the previous 3 separate calls that each
      // re-scanned and re-attempted the whole queue.
      final createOpId = const Uuid().v4();
      final createOp = SyncOperation(
        clientOperationId: createOpId,
        type: 'admission.create',
        payload: {
          'draftId': draftId,
          // campaignId must be provided by caller inside draft data when available
          'campaignId': campaignId,
        },
      );
      debugPrint('[ADMISSION][SUBMIT] opération ajoutée à SyncQueue: type=admission.create clientOperationId=$createOpId');
      await SyncQueue().enqueue(createOp);

      final pendingDocs = await local.getDocumentsForDraft(draftId);
      debugPrint('[ADMISSION][SUBMIT] documents en attente pour draftId=$draftId: count=${pendingDocs.length}');
      for (final doc in pendingDocs) {
        if (doc.uploadStatus == 'synced') continue;
        final docOpId = const Uuid().v4();
        final docOp = SyncOperation(
          clientOperationId: docOpId,
          type: 'document.upload',
          payload: {
            'documentId': doc.id,
            'attachmentType': doc.mimeType ?? 'OTHER',
            'isRegistration': false,
          },
        );
        debugPrint('[ADMISSION][SUBMIT] opération ajoutée à SyncQueue: type=document.upload documentId=${doc.id} clientOperationId=$docOpId');
        await SyncQueue().enqueue(docOp);
      }

      final submitOpId = const Uuid().v4();
      final submitOp = SyncOperation(
        clientOperationId: submitOpId,
        type: 'admission.submit',
        payload: {
          'draftId': draftId,
        },
      );
      debugPrint('[ADMISSION][SUBMIT] opération ajoutée à SyncQueue: type=admission.submit clientOperationId=$submitOpId');
      await SyncQueue().enqueue(submitOp);

      if (!wasOnline) {
        debugPrint('[ADMISSION][SUBMIT] appareil hors-ligne -> outcome=queuedOffline draftId=$draftId');
        return AdmissionSubmitOutcome.queuedOffline;
      }

      // Give the network a short, bounded window instead of waiting through
      // the full per-request HTTP timeout (up to ~60s per call): whatever
      // hasn't finished by then simply keeps running in SyncEngine's
      // background queue (processQueueNow() isn't cancelled by the timeout,
      // only our wait on it is).
      debugPrint('[ADMISSION][SUBMIT] tentative réseau courte (max ${_quickSyncAttempt.inSeconds}s) draftId=$draftId');
      await SyncEngine().processQueueNow().timeout(
        _quickSyncAttempt,
        onTimeout: () {
          debugPrint(
            '[ADMISSION][SUBMIT] tentative réseau courte non terminée en ${_quickSyncAttempt.inSeconds}s '
            '-> la synchronisation continue en arrière-plan draftId=$draftId',
          );
        },
      );

      final refreshedDraft = await local.getDraft(draftId);
      final refreshedDocs = await local.getDocumentsForDraft(draftId);
      final fullySynced = refreshedDraft?.status == 'submitted' &&
          refreshedDocs.every((doc) => doc.uploadStatus == 'synced');

      debugPrint(
        '[ADMISSION][SUBMIT] état après tentative de sync: '
        'remoteId=${refreshedDraft?.remoteId} status=${refreshedDraft?.status} '
        'docs=${refreshedDocs.map((d) => '${d.id}:${d.uploadStatus}').toList()} '
        'fullySynced=$fullySynced',
      );

      AdmissionSubmitOutcome outcome;
      if (fullySynced) {
        outcome = AdmissionSubmitOutcome.submittedOnline;
      } else if (SyncEngine().admissionRequiresAuth(draftId)) {
        // The API answered (so this isn't a network/timeout issue) but
        // rejected the request with 401: retrying automatically forever is
        // pointless without a token, so tell the UI to send the user to log
        // in instead of the generic "queued, will retry" message.
        debugPrint('[ADMISSION][SUBMIT] 401 détecté pour draftId=$draftId -> outcome=requiresAuthentication');
        outcome = AdmissionSubmitOutcome.requiresAuthentication;
      } else {
        outcome = AdmissionSubmitOutcome.queuedAfterError;
      }
      debugPrint('[ADMISSION][SUBMIT] outcome retourné=$outcome draftId=$draftId');
      return outcome;
    } catch (error, stackTrace) {
      debugPrint('[ADMISSION][ERROR][SUBMIT] exception dans submitDraft draftId=$draftId '
          'type=${error.runtimeType} error=$error');
      debugPrint('[ADMISSION][ERROR][SUBMIT] stackTrace=$stackTrace');
      return AdmissionSubmitOutcome.failed;
    }
  }

  /// Remove a draft and its documents
  Future<void> deleteDraft(int draftId) async {
    await local.deleteDraft(draftId);
  }

  /// Remove a single document from a draft
  Future<void> removeDocument(int docId) async {
    await local.removeDocument(docId);
  }

  /// Get pending documents waiting to be uploaded
  Future<List<adb.Document>> getPendingDocuments() async {
    return await local.getPendingDocuments();
  }
}
