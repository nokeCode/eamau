import 'dart:async';

import '../connectivity/connectivity_service.dart';
import 'sync_queue.dart';

/// Simple SyncEngine skeleton: listens to connectivity and processes queue
class SyncEngine {
  static final SyncEngine _instance = SyncEngine._();
  factory SyncEngine() => _instance;
  SyncEngine._();

  final SyncQueue _queue = SyncQueue();
  StreamSubscription<bool>? _connectivitySub;

  void start() {
    _connectivitySub ??= ConnectivityService().onConnectivityChanged.listen((isOnline) {
      if (isOnline) {
        _processQueue();
      }
    });
  }

  void stop() {
    _connectivitySub?.cancel();
    _connectivitySub = null;
  }

  void enqueueOperation(SyncOperation op) {
    _queue.enqueue(op);
    // if online, attempt immediate processing
    ConnectivityService().isOnline().then((online) {
      if (online) _processQueue();
    });
  }

  Future<void> _processQueue() async {
    final ops = _queue.all;
    for (final op in ops) {
      // TODO: implement actual sync logic per operation type
      // mark as syncing
      op.status = SyncStatus.syncing;
      try {
        // perform remote API call and await result
        // on success:
        op.status = SyncStatus.synced;
        _queue.remove(op.clientOperationId);
      } catch (_) {
        op.retryCount += 1;
        op.status = SyncStatus.failed;
        // TODO: implement retry limit and backoff
      }
    }
  }
}
