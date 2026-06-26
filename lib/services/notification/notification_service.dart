import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/notification/notification_model.dart';

class NotificationService {
  /// À remplacer par ton endpoint réel plus tard
  static const String baseUrl = 'https://ton-api.com';
  static const String endpoint = '/api/notification';

  Future<List<NotificationModel>> getNotifications() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final dynamic body = jsonDecode(response.body);

        // Cas où l'API retourne directement une liste
        if (body is List) {
          return body
              .map((e) => NotificationModel.fromJson(e))
              .toList();
        }

        // Cas où les données sont dans "data"
        if (body is Map<String, dynamic> && body['data'] is List) {
          return (body['data'] as List)
              .map((e) => NotificationModel.fromJson(e))
              .toList();
        }
      }

      // Fallback
      return fallbackNotifications;
    } catch (e) {
      // Fallback
      return fallbackNotifications;
    }
  }

  Future<bool> markAsRead(int notificationId) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint/$notificationId/read'),
        headers: {
          'Accept': 'application/json',
        },
      );

      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<bool> markAllAsRead() async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint/read-all'),
        headers: {
          'Accept': 'application/json',
        },
      );

      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<int> getUnreadCount() async {
    try {
      final notifications = await getNotifications();

      return notifications.where((e) => !e.isRead).length;
    } catch (_) {
      return fallbackNotifications.where((e) => !e.isRead).length;
    }
  }
}