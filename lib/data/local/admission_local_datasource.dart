import 'dart:io';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../core/database/app_database.dart';
import '../../core/sync/sync_engine.dart';

/// Local datasource for admission: saves drafts and documents to SQLite
class AdmissionLocalDatasource {
  final AppDatabase _db = AppDatabase();

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

    // Enqueue document upload to sync engine
    await SyncEngine().enqueueDocumentUpload(
      docId,
      attachmentType: attachmentType ?? 'OTHER',
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
