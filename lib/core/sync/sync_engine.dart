import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';

import '../connectivity/connectivity_service.dart';
import '../database/app_database.dart' as adb;
import '../../models/admission/admission_request_model.dart';
import '../../services/admission/admission_request_service.dart';
import 'sync_queue.dart';

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

  void start() {
    if (_connectivitySub != null) return;

    _connectivitySub = ConnectivityService().onConnectivityChanged.listen((isOnline) {
      if (isOnline) {
        _processQueue();
      }
    });
  }

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
      case 'document.upload':
        try {
          final docIdRaw = op.payload['documentId'];
          final attachmentType = op.payload['attachmentType']?.toString() ?? 'OTHER';
          final docId = int.tryParse(docIdRaw?.toString() ?? '') ?? 0;
          if (docId <= 0) return true;

          final database = adb.AppDatabase();
          final docRow = await (database.select(database.documents)..where((d) => d.id.equals(docId))).getSingleOrNull();
          if (docRow == null) return true; // nothing to do

          if (docRow.uploadStatus == 'synced') return true;

          final draftId = docRow.draftId;
          if (draftId == null) {
            // no associated draft: mark failed
            return false;
          }

          final draftRow = await (database.select(database.admissionDrafts)..where((t) => t.id.equals(draftId))).getSingleOrNull();
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
            await (database.update(database.documents)..where((d) => d.id.equals(docRow.id))).write(
              adb.DocumentsCompanion(
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
      case 'registration.create':
      case 'news.sync':
      case 'notification.sync':
        return true;
      default:
        return true;
    }
  }

  Future<void> enqueueDocumentUpload(int documentId, {String? attachmentType}) async {
    final id = const Uuid().v4();
    final op = SyncOperation(
      clientOperationId: id,
      type: 'document.upload',
      payload: {
        'documentId': documentId,
        'attachmentType': attachmentType ?? 'OTHER',
      },
    );

    await enqueueOperation(op);
  }
}
