import 'dart:convert';
import 'dart:io';

import 'package:uuid/uuid.dart';

import '../../core/database/app_database.dart' as adb;
import '../../core/sync/sync_engine.dart';
import '../../core/sync/sync_queue.dart';
import '../local/admission_local_datasource.dart';
import '../remote/admission_remote_datasource.dart';

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

  /// Submit a draft: save locally, then try to sync remotely
  Future<bool> submitDraft(int draftId) async {
    try {
      final draft = await local.getDraft(draftId);
      if (draft == null) return false;

      // Mark draft as pending sync locally
      await local.updateDraftStatus(draftId, 'pending_sync');

      // Enqueue operations in the correct order: create -> upload documents -> submit
      final createOpId = const Uuid().v4();
      final createOp = SyncOperation(
        clientOperationId: createOpId,
        type: 'admission.create',
        payload: {
          'draftId': draftId,
          // campaignId must be provided by caller inside draft data when available
          'campaignId': (jsonDecode(draft.dataJson) as Map<String, dynamic>?)?['campaignId'],
        },
      );

      await SyncEngine().enqueueOperation(createOp);

      // Enqueue document uploads for existing attached documents
      final pendingDocs = await local.getDocumentsForDraft(draftId);
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
      await SyncEngine().enqueueOperation(submitOp);

      return true;
    } catch (_) {
      return false;
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
