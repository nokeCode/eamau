import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

/// Simple connectivity service wrapper
class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._();
  factory ConnectivityService() => _instance;
  ConnectivityService._() {
    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      final online = result != ConnectivityResult.none;
      _controller.add(online);
    });
  }

  final Connectivity _connectivity = Connectivity();
  late final StreamSubscription<ConnectivityResult> _subscription;
  final StreamController<bool> _controller = StreamController<bool>.broadcast();

  Stream<bool> get onConnectivityChanged => _controller.stream;

  Future<bool> isOnline() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  void dispose() {
    _subscription.cancel();
    _controller.close();
  }
}
