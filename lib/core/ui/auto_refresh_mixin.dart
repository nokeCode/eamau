import 'dart:async';

import 'package:flutter/material.dart';

/// Keeps a screen's data current without the user having to pull-to-refresh:
/// calls [onAutoRefresh] on [autoRefreshInterval] while the screen is
/// mounted, and again whenever the app returns to the foreground. Meant for
/// a *silent* refresh — implementers should update state without flashing a
/// loading skeleton or surfacing a transient error, so it doesn't fight
/// with whatever's already on screen.
///
/// Usage:
/// ```dart
/// class _MyScreenState extends State<MyScreen> with AutoRefreshMixin<MyScreen> {
///   @override
///   Future<void> onAutoRefresh() => _loadData(silent: true);
///
///   @override
///   void initState() {
///     super.initState();
///     _loadData();
///     startAutoRefresh();
///   }
///
///   @override
///   void dispose() {
///     stopAutoRefresh();
///     super.dispose();
///   }
/// }
/// ```
mixin AutoRefreshMixin<T extends StatefulWidget> on State<T> {
  Duration get autoRefreshInterval => const Duration(seconds: 20);

  Future<void> onAutoRefresh();

  Timer? _autoRefreshTimer;
  _AutoRefreshLifecycleObserver? _lifecycleObserver;

  void startAutoRefresh() {
    _lifecycleObserver = _AutoRefreshLifecycleObserver(onResumed: onAutoRefresh);
    WidgetsBinding.instance.addObserver(_lifecycleObserver!);
    _autoRefreshTimer = Timer.periodic(autoRefreshInterval, (_) => onAutoRefresh());
  }

  void stopAutoRefresh() {
    _autoRefreshTimer?.cancel();
    _autoRefreshTimer = null;
    if (_lifecycleObserver != null) {
      WidgetsBinding.instance.removeObserver(_lifecycleObserver!);
      _lifecycleObserver = null;
    }
  }
}

class _AutoRefreshLifecycleObserver extends WidgetsBindingObserver {
  final Future<void> Function() onResumed;

  _AutoRefreshLifecycleObserver({required this.onResumed});

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      onResumed();
    }
  }
}
