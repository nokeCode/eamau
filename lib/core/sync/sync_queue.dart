// SyncQueue and SyncOperation skeleton
// TODO: persist queue to local DB (Drift)

enum SyncStatus { pending, syncing, synced, failed }

class SyncOperation {
  final String clientOperationId;
  final String type; // e.g., 'create:admission'
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
}

class SyncQueue {
  static final SyncQueue _instance = SyncQueue._();

  final List<SyncOperation> _queue = [];

  SyncQueue._();
  factory SyncQueue() => _instance;

  void enqueue(SyncOperation op) {
    _queue.add(op);
  }

  List<SyncOperation> get all => List.unmodifiable(_queue);

  void remove(String clientOperationId) {
    _queue.removeWhere((e) => e.clientOperationId == clientOperationId);
  }

  void clear() => _queue.clear();
}
