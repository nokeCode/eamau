import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../core/database/app_database.dart';
import '../../core/sync/sync_engine.dart';
import '../../core/sync/sync_queue.dart' as queue;

/// Local datasource for postulation drafts: save draft and attach documents
class PostulationLocalDatasource {
  final AppDatabase _db = AppDatabase();

  Future<int> saveDraft({
    required String concoursSlug,
    required String dataJson,
    required String status,
    String? remoteId,
    String? postulationToken,
  }) async {
    final localUuid = const Uuid().v4();
    final now = DateTime.now();

    final companion = PostulationDraftsCompanion(
      localUuid: Value(localUuid),
      remoteId: remoteId != null ? Value(remoteId) : const Value.absent(),
      reference: const Value.absent(),
      concoursSlug: Value(concoursSlug),
      dataJson: Value(dataJson),
      postulationToken: postulationToken != null ? Value(postulationToken) : const Value.absent(),
      status: Value(status),
      createdAt: Value(now),
      updatedAt: Value(now),
    );

    return _db.into(_db.postulationDrafts).insert(companion);
  }

  Future<void> updateDraftData(int draftId, String dataJson) async {
    await (_db.update(_db.postulationDrafts)..where((t) => t.id.equals(draftId))).write(
      PostulationDraftsCompanion(
        dataJson: Value(dataJson),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> updateDraftStatus(int draftId, String status, {String? reference, String? remoteId}) async {
    await (_db.update(_db.postulationDrafts)..where((t) => t.id.equals(draftId))).write(
      PostulationDraftsCompanion(
        status: Value(status),
        reference: reference != null ? Value(reference) : const Value.absent(),
        remoteId: remoteId != null ? Value(remoteId) : const Value.absent(),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<int> attachDocument({
    required int draftId,
    required File file,
    required String fileName,
    required String mimeType,
    String? documentType,
  }) async {
    final fileSize = await file.length();
    final localPath = file.absolute.path;

    final companion = PostulationDocumentsCompanion(
      draftId: Value(draftId),
      localPath: Value(localPath),
      fileName: Value(fileName),
      mimeType: Value(mimeType),
      size: Value(fileSize),
      uploadStatus: Value('pending'),
      retryCount: const Value(0),
    );

    final docId = await _db.into(_db.postulationDocuments).insert(companion);

    // Enqueue document upload to sync engine
    final opId = const Uuid().v4();
    final op = queue.SyncOperation(
      clientOperationId: opId,
      type: 'postulation.document.upload',
      payload: {'documentId': docId},
    );
    await SyncEngine().enqueueOperation(op);

    return docId;
  }

  Future<PostulationDraft?> getDraft(int draftId) async {
    try {
      final row = await (_db.select(_db.postulationDrafts)..where((t) => t.id.equals(draftId))).getSingleOrNull();
      return row;
    } catch (_) {
      return null;
    }
  }

  Future<List<PostulationDraft>> getAllDrafts() async {
    try {
      final rows = await (_db.select(_db.postulationDrafts)..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).get();
      return rows;
    } catch (_) {
      return [];
    }
  }

  Future<List<PostulationDocument>> getDocumentsForDraft(int draftId) async {
    try {
      final rows = await (_db.select(_db.postulationDocuments)..where((d) => d.draftId.equals(draftId))).get();
      return rows;
    } catch (_) {
      return [];
    }
  }

  Future<void> removeDocument(int docId) async {
    await (_db.delete(_db.postulationDocuments)..where((d) => d.id.equals(docId))).go();
  }
}
