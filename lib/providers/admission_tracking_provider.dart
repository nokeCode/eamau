import 'package:flutter/material.dart';

import '../../models/admission/admission_tracking_model.dart';
import '../../services/admission/admission_tracking_service.dart';

class AdmissionTrackingProvider extends ChangeNotifier {
  final AdmissionTrackingService _service = AdmissionTrackingService();

  AdmissionTrackingModel? _tracking;

  AdmissionTrackingModel? get tracking => _tracking;

  bool _loading = false;

  bool get loading => _loading;

  bool _refreshing = false;

  bool get refreshing => _refreshing;

  String? _error;

  String? get error => _error;

  Future<void> loadTracking({int? requestId, String? uuid}) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _tracking = await _service.getTracking(requestId: requestId, uuid: uuid);
    } catch (e) {
      _error = e.toString();
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> refreshTracking({int? requestId, String? uuid}) async {
    _refreshing = true;
    notifyListeners();

    await _service.refreshTracking(requestId: requestId, uuid: uuid);
    _tracking = await _service.getTracking(requestId: requestId, uuid: uuid);

    _refreshing = false;
    notifyListeners();
  }

  Future<bool> cancelAdmission() async {
    final result = await _service.cancelAdmission();

    if (result) {
      _tracking = null;

      notifyListeners();
    }

    return result;
  }

  void clear() {
    _tracking = null;

    _error = null;

    notifyListeners();
  }
}
