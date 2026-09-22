import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../core/database/app_database.dart';
import '../../core/sync/sync_engine.dart';

/// Local datasource for admission: saves drafts and documents to SQLite
class AdmissionLocalDatasource {
  final AppDatabase _db = AppDatabase();

  /// Cache the admission form JSON
  Future<void> cacheAdmissionForm(String dataJson) async {
    // Clear previous entries and insert the latest
    await _db.delete(_db.admissionForms).go();
    final companion = AdmissionFormsCompanion(
      dataJson: Value(dataJson),
      updatedAt: Value(DateTime.now()),
    );
    await _db.into(_db.admissionForms).insert(companion);
  }

  /// Get cached admission form JSON if available
  Future<String?> getCachedAdmissionForm() async {
    final row = await (_db.select(_db.admissionForms)..limit(1)).getSingleOrNull();
    return row?.dataJson;
  }

  /// Cache campaign detail JSON for a given remoteId
  Future<void> cacheCampaignDetail(int remoteId, String dataJson) async {
    // Try to find existing row
    final existing = await (_db.select(_db.admissionCampaigns)
          ..where((t) => t.remoteId.equals(remoteId)))
        .getSingleOrNull();
    final companion = AdmissionCampaignsCompanion(
      remoteId: Value(remoteId),
      dataJson: Value(dataJson),
      updatedAt: Value(DateTime.now()),
    );
    if (existing == null) {
      await _db.into(_db.admissionCampaigns).insert(companion);
    } else {
      await (_db.update(_db.admissionCampaigns)
            ..where((t) => t.remoteId.equals(remoteId)))
          .write(companion);
    }
  }

  /// Get cached campaign detail by remoteId
  Future<String?> getCachedCampaignDetail(int remoteId) async {
    final row = await (_db.select(_db.admissionCampaigns)
          ..where((t) => t.remoteId.equals(remoteId))
          ..limit(1))
        .getSingleOrNull();
    return row?.dataJson;
  }

  /// Save an admission draft locally
  Future<int> saveDraft({
    required String dataJson,
    required String status,
    int? remoteId,
  }) async {
    final localUuid = const Uuid().v4();
    final now = DateTime.now();

    final companion = AdmissionDraftsCompanion(
      localUuid: Value(localUuid),
      remoteId: remoteId != null ? Value(remoteId) : const Value.absent(),
      dataJson: Value(dataJson),
      status: Value(status),
      createdAt: Value(now),
      updatedAt: Value(now),
    );

    return _db.into(_db.admissionDrafts).insert(companion);
  }

  /// Update an existing admission draft's data in place (used when resuming
  /// a draft after the user was sent to log in mid-submission, so we don't
  /// create a second local draft — and a second admission.create retry loop
  /// — for the same request).
  Future<void> updateDraftData(int draftId, String dataJson) async {
    await (_db.update(_db.admissionDrafts)..where((t) => t.id.equals(draftId))).write(
      AdmissionDraftsCompanion(
        dataJson: Value(dataJson),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Attach a document to a draft and enqueue sync
  Future<int> attachDocument({
    required int draftId,
    required File file,
    required String fileName,
    required String mimeType,
    String? attachmentType,
  }) async {
    final fileSize = await file.length();
    final localPath = file.absolute.path;

    final companion = DocumentsCompanion(
      draftId: Value(draftId),
      localPath: Value(localPath),
      fileName: Value(fileName),
      mimeType: Value(mimeType),
      size: Value(fileSize),
      uploadStatus: Value('pending'),
      retryCount: const Value(0),
    );

    final docId = await _db.into(_db.documents).insert(companion);

    // Enqueue document upload to sync engine. Deliberately not awaited: the
    // document is already durably saved locally by the insert above: that's
    // what this method's caller actually needs to know "succeeded". The
    // network attempt is a separate background concern — awaiting it here
    // (as before) meant every call blocked for as long as the underlying
    // HTTP attempt took (up to its full timeout), which is what made
    // picking a document feel stuck. Callers that want to know whether it
    // actually finished uploading within some short window now do that
    // themselves via `SyncEngine().processQueueNow().timeout(...)`.
    unawaited(
      SyncEngine()
          .enqueueDocumentUpload(docId, attachmentType: attachmentType ?? 'OTHER')
          .catchError((_) {}),
    );

    return docId;
  }

  /// Get a draft by ID
  Future<AdmissionDraft?> getDraft(int draftId) async {
    try {
      final row = await (_db.select(_db.admissionDrafts)
            ..where((t) => t.id.equals(draftId)))
          .getSingleOrNull();
      return row;
    } catch (_) {
      return null;
    }
  }

  /// Get all drafts (ordered by most recent first)
  Future<List<AdmissionDraft>> getAllDrafts() async {
    try {
      final rows = await (_db.select(_db.admissionDrafts)
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();
      return rows;
    } catch (_) {
      return [];
    }
  }

  /// Get documents attached to a draft
  Future<List<Document>> getDocumentsForDraft(int draftId) async {
    try {
      final rows = await (_db.select(_db.documents)
            ..where((d) => d.draftId.equals(draftId)))
          .get();
      return rows;
    } catch (_) {
      return [];
    }
  }

  /// Update draft status (e.g., after remote submission)
  Future<void> updateDraftStatus(int draftId, String status, {int? remoteId}) async {
    await (_db.update(_db.admissionDrafts)
          ..where((t) => t.id.equals(draftId)))
        .write(
      AdmissionDraftsCompanion(
        status: Value(status),
        remoteId: remoteId != null ? Value(remoteId) : const Value.absent(),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Delete a draft and its documents
  Future<void> deleteDraft(int draftId) async {
    await (_db.delete(_db.documents)
          ..where((d) => d.draftId.equals(draftId)))
        .go();
    await (_db.delete(_db.admissionDrafts)
          ..where((t) => t.id.equals(draftId)))
        .go();
  }

  /// Remove a single document
  Future<void> removeDocument(int docId) async {
    await (_db.delete(_db.documents)..where((d) => d.id.equals(docId))).go();
  }

  /// Get pending documents (not yet synced)
  Future<List<Document>> getPendingDocuments() async {
    try {
      final allDocs = await _db.select(_db.documents).get();
      return allDocs.where((d) => d.uploadStatus != 'synced').toList();
    } catch (_) {
      return [];
    }
  }
}
