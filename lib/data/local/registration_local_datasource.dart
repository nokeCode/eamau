import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../core/database/app_database.dart';

/// Local datasource for registration: saves drafts, documents, and referentials to SQLite
class RegistrationLocalDatasource {
  final AppDatabase _db = AppDatabase();

  /// Persists a picked/selected file permanently into the application's document storage
  Future<File> persistFilePermanently(File sourceFile, String fileName) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final regDocsDir = Directory(p.join(appDir.path, 'registration_documents'));
      if (!await regDocsDir.exists()) {
        await regDocsDir.create(recursive: true);
      }
      final uniqueSuffix = const Uuid().v4().substring(0, 8);
      final safeName = '${uniqueSuffix}_${p.basename(fileName)}';
      final permanentPath = p.join(regDocsDir.path, safeName);
      return await sourceFile.copy(permanentPath);
    } catch (_) {
      // Fallback to original file if copy fails
      return sourceFile;
    }
  }

  /// Cache the referentials JSON
  Future<void> cacheReferentials(String referentialsJson) async {
    final existing = await (_db.select(_db.registrationReferentials)..limit(1)).getSingleOrNull();
    final now = DateTime.now();

    if (existing == null) {
      final companion = RegistrationReferentialsCompanion(
        referentialsJson: Value(referentialsJson),
        statusJson: const Value.absent(),
        updatedAt: Value(now),
      );
      await _db.into(_db.registrationReferentials).insert(companion);
    } else {
      await (_db.update(_db.registrationReferentials)..where((t) => t.id.equals(existing.id))).write(
        RegistrationReferentialsCompanion(
          referentialsJson: Value(referentialsJson),
          updatedAt: Value(now),
        ),
      );
    }
  }

  /// Get cached referentials JSON if available
  Future<String?> getCachedReferentials() async {
    try {
      final row = await (_db.select(_db.registrationReferentials)..limit(1)).getSingleOrNull();
      return row?.referentialsJson;
    } catch (_) {
      return null;
    }
  }

  /// Cache the registration campaign status JSON
  Future<void> cacheStatus(String statusJson) async {
    final existing = await (_db.select(_db.registrationReferentials)..limit(1)).getSingleOrNull();
    final now = DateTime.now();

    if (existing == null) {
      final companion = RegistrationReferentialsCompanion(
        referentialsJson: const Value('{}'),
        statusJson: Value(statusJson),
        updatedAt: Value(now),
      );
      await _db.into(_db.registrationReferentials).insert(companion);
    } else {
      await (_db.update(_db.registrationReferentials)..where((t) => t.id.equals(existing.id))).write(
        RegistrationReferentialsCompanion(
          statusJson: Value(statusJson),
          updatedAt: Value(now),
        ),
      );
    }
  }

  /// Get cached status JSON if available
  Future<String?> getCachedStatus() async {
    try {
      final row = await (_db.select(_db.registrationReferentials)..limit(1)).getSingleOrNull();
      return row?.statusJson;
    } catch (_) {
      return null;
    }
  }

  /// Get timestamp of last cache update
  Future<DateTime?> getCachedReferentialsUpdatedAt() async {
    try {
      final row = await (_db.select(_db.registrationReferentials)..limit(1)).getSingleOrNull();
      return row?.updatedAt;
    } catch (_) {
      return null;
    }
  }

  /// Save a registration draft locally
  Future<int> saveDraft({
    required String dataJson,
    required String status,
    int? remoteId,
  }) async {
    final localUuid = const Uuid().v4();
    final now = DateTime.now();

    final companion = RegistrationDraftsCompanion(
      localUuid: Value(localUuid),
      remoteId: remoteId != null ? Value(remoteId) : const Value.absent(),
      dataJson: Value(dataJson),
      status: Value(status),
      createdAt: Value(now),
      updatedAt: Value(now),
    );

    return _db.into(_db.registrationDrafts).insert(companion);
  }

  /// Update an existing draft's data in place
  Future<void> updateDraftData(int draftId, String dataJson) async {
    await (_db.update(_db.registrationDrafts)..where((t) => t.id.equals(draftId))).write(
      RegistrationDraftsCompanion(
        dataJson: Value(dataJson),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Attach a document to a draft, persisting the physical file permanently
  Future<int> attachDocument({
    required int draftId,
    required File file,
    required String fileName,
    required String mimeType,
    String? documentType,
  }) async {
    // Copy the file to permanent application storage so it is never lost when /cache is purged
    final permanentFile = await persistFilePermanently(file, fileName);
    final fileSize = await permanentFile.length();
    final localPath = permanentFile.absolute.path;

    final companion = RegistrationDocumentsCompanion(
      draftId: Value(draftId),
      localPath: Value(localPath),
      fileName: Value(fileName),
      mimeType: Value(mimeType),
      size: Value(fileSize),
      documentType: documentType != null ? Value(documentType) : const Value.absent(),
      uploadStatus: const Value('pending'),
      retryCount: const Value(0),
    );

    return _db.into(_db.registrationDocuments).insert(companion);
  }

  /// Get a draft by ID
  Future<RegistrationDraft?> getDraft(int draftId) async {
    try {
      final row = await (_db.select(_db.registrationDrafts)
            ..where((t) => t.id.equals(draftId)))
          .getSingleOrNull();
      return row;
    } catch (_) {
      return null;
    }
  }

  /// Get all drafts (ordered by most recent first)
  Future<List<RegistrationDraft>> getAllDrafts() async {
    try {
      final rows = await (_db.select(_db.registrationDrafts)
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();
      return rows;
    } catch (_) {
      return [];
    }
  }

  /// Get documents attached to a draft
  Future<List<RegistrationDocument>> getDocumentsForDraft(int draftId) async {
    try {
      final rows = await (_db.select(_db.registrationDocuments)
            ..where((d) => d.draftId.equals(draftId)))
          .get();
      return rows;
    } catch (_) {
      return [];
    }
  }

  /// Update draft status (e.g. 'pending_sync', 'created', 'submitted')
  Future<void> updateDraftStatus(int draftId, String status, {int? remoteId}) async {
    await (_db.update(_db.registrationDrafts)
          ..where((t) => t.id.equals(draftId)))
        .write(
      RegistrationDraftsCompanion(
        status: Value(status),
        remoteId: remoteId != null ? Value(remoteId) : const Value.absent(),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Update upload status of a single document
  Future<void> updateDocumentStatus(int docId, String uploadStatus) async {
    await (_db.update(_db.registrationDocuments)..where((d) => d.id.equals(docId))).write(
      RegistrationDocumentsCompanion(
        uploadStatus: Value(uploadStatus),
      ),
    );
  }

  /// Delete a draft and its documents
  Future<void> deleteDraft(int draftId) async {
    await (_db.delete(_db.registrationDocuments)
          ..where((d) => d.draftId.equals(draftId)))
        .go();
    await (_db.delete(_db.registrationDrafts)
          ..where((t) => t.id.equals(draftId)))
        .go();
  }

  /// Remove a single document
  Future<void> removeDocument(int docId) async {
    await (_db.delete(_db.registrationDocuments)..where((d) => d.id.equals(docId))).go();
  }

  /// Get pending documents (not yet synced)
  Future<List<RegistrationDocument>> getPendingDocuments() async {
    try {
      final allDocs = await _db.select(_db.registrationDocuments).get();
      return allDocs.where((d) => d.uploadStatus != 'synced').toList();
    } catch (_) {
      return [];
    }
  }
}
