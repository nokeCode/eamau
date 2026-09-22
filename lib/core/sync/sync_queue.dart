import 'dart:convert';

import 'package:drift/drift.dart';

import '../database/app_database.dart';

enum SyncStatus { pending, syncing, synced, failed }

extension SyncStatusX on SyncStatus {
  String get dbValue => name.toUpperCase();

  static SyncStatus fromDbValue(String value) {
    switch (value.toUpperCase()) {
      case 'PENDING':
        return SyncStatus.pending;
      case 'SYNCING':
        return SyncStatus.syncing;
      case 'SYNCED':
        return SyncStatus.synced;
      case 'FAILED':
        return SyncStatus.failed;
      default:
        return SyncStatus.pending;
    }
  }
}

class SyncOperation {
  final String clientOperationId;
  final String type;
  final Map<String, dynamic> payload;
  SyncStatus status;
  int retryCount;
  DateTime createdAt;

  SyncOperation({
    required this.clientOperationId,
    required this.type,
    required this.payload,
    this.status = SyncStatus.pending,
    this.retryCount = 0,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'clientOperationId': clientOperationId,
    'type': type,
    'payload': payload,
    'status': status.dbValue,
    'retryCount': retryCount,
    'createdAt': createdAt.toIso8601String(),
  };

  factory SyncOperation.fromJson(Map<String, dynamic> json) {
    final createdAtRaw = json['createdAt'];
    return SyncOperation(
      clientOperationId: json['clientOperationId']?.toString() ?? '',
      type: json['type']?.toString() ?? 'unknown',
      payload: json['payload'] is Map<String, dynamic>
          ? json['payload'] as Map<String, dynamic>
          : (json['payload'] is Map ? Map<String, dynamic>.from(json['payload']) : <String, dynamic>{}),
      status: SyncStatusX.fromDbValue(json['status']?.toString() ?? 'PENDING'),
      retryCount: int.tryParse(json['retryCount']?.toString() ?? '0') ?? 0,
      createdAt: createdAtRaw is String
          ? DateTime.tryParse(createdAtRaw) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  factory SyncOperation.fromRow(dynamic row) {
    final payloadRaw = row.payload as String? ?? '{}';
    return SyncOperation(
      clientOperationId: row.clientOperationId,
      type: row.type,
      payload: payloadRaw.isEmpty
          ? <String, dynamic>{}
          : jsonDecode(payloadRaw) is Map<String, dynamic>
              ? jsonDecode(payloadRaw) as Map<String, dynamic>
              : Map<String, dynamic>.from(jsonDecode(payloadRaw) as Map),
      status: SyncStatusX.fromDbValue(row.status ?? 'PENDING'),
      retryCount: row.retryCount ?? 0,
      createdAt: row.createdAt ?? DateTime.now(),
    );
  }
}

class SyncQueue {
  static final SyncQueue _instance = SyncQueue._();
  factory SyncQueue() => _instance;

  SyncQueue._();

  final List<SyncOperation> _queue = [];

  Future<List<SyncOperation>> get all async {
    await _refreshFromDatabase();
    return List.unmodifiable(_queue);
  }

  Future<void> enqueue(SyncOperation op) async {
    _queue.removeWhere((e) => e.clientOperationId == op.clientOperationId);
    _queue.add(op);

    final db = AppDatabase();
    final companion = SyncOperationsCompanion(
      clientOperationId: Value(op.clientOperationId),
      type: Value(op.type),
      payload: Value(jsonEncode(op.payload)),
      status: Value(op.status.dbValue),
      retryCount: Value(op.retryCount),
      createdAt: Value(op.createdAt),
    );

    await db.into(db.syncOperations).insertOnConflictUpdate(companion);
  }

  Future<void> update(SyncOperation op) async {
    final index = _queue.indexWhere((e) => e.clientOperationId == op.clientOperationId);
    if (index >= 0) {
      _queue[index] = op;
    } else {
      _queue.add(op);
    }

    final db = AppDatabase();
    final companion = SyncOperationsCompanion(
      clientOperationId: Value(op.clientOperationId),
      type: Value(op.type),
      payload: Value(jsonEncode(op.payload)),
      status: Value(op.status.dbValue),
      retryCount: Value(op.retryCount),
      createdAt: Value(op.createdAt),
    );

    await db.into(db.syncOperations).insertOnConflictUpdate(companion);
  }

  Future<void> remove(String clientOperationId) async {
    _queue.removeWhere((e) => e.clientOperationId == clientOperationId);

    final db = AppDatabase();
    await (db.delete(db.syncOperations)
          ..where((t) => t.clientOperationId.equals(clientOperationId)))
        .go();
  }

  Future<void> clear() async {
    _queue.clear();
    final db = AppDatabase();
    await db.delete(db.syncOperations).go();
  }

  Future<void> _refreshFromDatabase() async {
    try {
      final db = AppDatabase();
      // Ordered by insertion (id) so operations enqueued for the same draft
      // (create -> document uploads -> submit) are always processed in that
      // same order, instead of an unspecified row order.
      final rows = await (db.select(db.syncOperations)
            ..orderBy([(t) => OrderingTerm.asc(t.id)]))
          .get();
      _queue
        ..clear()
        ..addAll(rows.map(SyncOperation.fromRow));
    } catch (_) {
      // DB is not initialized yet. Keep current in-memory queue.
    }
  }
}
