import 'package:flutter/foundation.dart';

import '../../core/api/api_endpoints.dart';
import '../../core/api/dio_client.dart';
import '../../models/notification/notification_model.dart';

class NotificationService {
  final DioClient _dioClient = DioClient();

  Future<List<NotificationModel>> getNotifications({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dioClient.dio.get(
        ApiEndpoints.notifications,
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      final dynamic body = response.data;

      if (body is Map<String, dynamic>) {
        final data = body['data'];

        if (data is Map<String, dynamic> && data['items'] is List) {
          return (data['items'] as List)
              .map((item) => NotificationModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }

        if (data is List) {
          return data
              .map((item) => NotificationModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }
      }

      return fallbackNotifications;
    } catch (_) {
      return fallbackNotifications;
    }
  }

  Future<bool> markAsRead(int notificationId) async {
    try {
      await _dioClient.dio.post('${ApiEndpoints.notifications}/$notificationId/read');
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> markAllAsRead() async {
    try {
      await _dioClient.dio.post('${ApiEndpoints.notifications}/read-all');
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<Map<String, dynamic>> getPreferences() async {
    try {
      final response = await _dioClient.dio.get(
        ApiEndpoints.notificationsPreferences,
      );

      final dynamic body = response.data;
      if (body is Map<String, dynamic> && body['data'] is Map<String, dynamic>) {
        return Map<String, dynamic>.from(body['data'] as Map);
      }

      return {};
    } catch (_) {
      return {};
    }
  }

  Future<Map<String, dynamic>> updatePreferences(
    Map<String, dynamic> preferences,
  ) async {
    try {
      final response = await _dioClient.dio.put(
        ApiEndpoints.notificationsPreferences,
        data: preferences,
      );

      final dynamic body = response.data;
      if (body is Map<String, dynamic> && body['data'] is Map<String, dynamic>) {
        return Map<String, dynamic>.from(body['data'] as Map);
      }

      return preferences;
    } catch (_) {
      return preferences;
    }
  }

  /// Registers this device's FCM token with the backend. Returns `null` on
  /// any failure — distinct from a successful response with no useful
  /// `data` field (`{}`) — so the caller can tell "registered" apart from
  /// "failed" instead of treating both the same. That distinction matters:
  /// AuthProvider only remembers a token as "already sent to the backend"
  /// (to skip re-sending it on the next launch) when this actually
  /// succeeded — previously it persisted that regardless of outcome, so a
  /// single failed registration meant the backend permanently had no valid
  /// token to push to, silently, for the rest of that install.
  Future<Map<String, dynamic>?> registerDevice(
    Map<String, dynamic> payload,
  ) async {
    debugPrint('[PUSH][DEVICE] POST ${ApiEndpoints.devicesRegister} '
        'deviceToken=${payload['deviceToken']}');
    try {
      final response = await _dioClient.dio.post(
        ApiEndpoints.devicesRegister,
        data: payload,
      );
      debugPrint('[PUSH][DEVICE] status=${response.statusCode} body=${response.data}');

      final dynamic body = response.data;
      if (body is Map<String, dynamic> && body['data'] is Map<String, dynamic>) {
        return Map<String, dynamic>.from(body['data'] as Map);
      }

      return {};
    } catch (error) {
      // This used to be swallowed silently (`catch (_) { return {}; }`),
      // so a failed device registration — meaning the backend has no valid
      // token to send push to at all — left zero trace anywhere: a push
      // that never arrives looks identical whether the backend never sent
      // it, sent it to a stale/unregistered token, or it's a client-side
      // display bug. This is the one of those three the previous code made
      // impossible to tell apart from the other two.
      debugPrint('[PUSH][DEVICE][ERROR] échec enregistrement device: $error');
      return null;
    }
  }

  Future<int> getUnreadCount() async {
    try {
      final response = await _dioClient.dio.get(
        '${ApiEndpoints.notifications}/unread-count',
      );

      final dynamic body = response.data;

      if (body is Map<String, dynamic>) {
        final data = body['data'];
        if (data is Map<String, dynamic> && data['unreadCount'] is int) {
          return data['unreadCount'] as int;
        }
      }

      final notifications = await getNotifications();
      return notifications.where((e) => !e.isRead).length;
    } catch (_) {
      return fallbackNotifications.where((e) => !e.isRead).length;
    }
  }
}