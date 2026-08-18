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

  /// Submit a draft.
  ///
  /// Always saves the draft and its operations through the existing
  /// offline-first queue (SyncQueue/SyncEngine) so no data is ever lost.
  /// When the device is online, [SyncEngine.enqueueOperation] processes the
  /// queue immediately and this method waits for that attempt so it can
  /// report whether the request was actually submitted to the API, or only
  /// saved locally (because the device is offline, or because the online
  /// attempt failed and fell back to the queue).
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

      // Enqueue operations in the correct order: create -> upload documents -> submit
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
      await SyncEngine().enqueueOperation(createOp);

      // Enqueue document uploads for existing attached documents
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
        await SyncEngine().enqueueOperation(docOp);
      }

      // Finally enqueue submit operation which depends on remoteId being available
      final submitOpId = const Uuid().v4();
      final submitOp = SyncOperation(
        clientOperationId: submitOpId,
        type: 'admission.submit',
        payload: {
          'draftId': draftId,
        },
      );
      debugPrint('[ADMISSION][SUBMIT] opération ajoutée à SyncQueue: type=admission.submit clientOperationId=$submitOpId');
      await SyncEngine().enqueueOperation(submitOp);

      if (!wasOnline) {
        debugPrint('[ADMISSION][SUBMIT] appareil hors-ligne -> outcome=queuedOffline draftId=$draftId');
        return AdmissionSubmitOutcome.queuedOffline;
      }

      // The device was online, so enqueueOperation already attempted to
      // process the queue synchronously above. Check whether that attempt
      // actually finished the full flow (create -> documents -> submit)
      // before claiming a real online success.
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

      final outcome = fullySynced
          ? AdmissionSubmitOutcome.submittedOnline
          : AdmissionSubmitOutcome.queuedAfterError;
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
