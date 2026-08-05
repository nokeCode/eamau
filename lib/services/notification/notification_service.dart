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

  Future<Map<String, dynamic>> registerDevice(
    Map<String, dynamic> payload,
  ) async {
    try {
      final response = await _dioClient.dio.post(
        ApiEndpoints.devicesRegister,
        data: payload,
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