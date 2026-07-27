import '../api_client.dart';

class NotificationService {
  final ApiClient _apiClient = ApiClient();

  // Récupérer la liste des notifications
  Future<List<dynamic>> getNotifications() async {
    try {
      final response = await _apiClient.get(
        '/notifications',
        requireAuth: true,
      );

      if (response['success'] == true) {
        final data = response['data'];
        if (data is List) {
          return data;
        } else if (data is Map && data['notifications'] is List) {
          return data['notifications'];
        }
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }

  // Récupérer les dernières notifications
  Future<List<dynamic>> getLatestNotifications() async {
    try {
      final response = await _apiClient.get(
        '/notifications/latest',
        requireAuth: true,
      );

      if (response['success'] == true) {
        final data = response['data'];
        if (data is List) {
          return data;
        } else if (data is Map && data['notifications'] is List) {
          return data['notifications'];
        }
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }

  // Récupérer le nombre de notifications non lues
  Future<int> getUnreadCount() async {
    try {
      final response = await _apiClient.get(
        '/notifications/unread-count',
        requireAuth: true,
      );

      if (response['success'] == true) {
        final data = response['data'];
        if (data is Map) {
          return data['unread_count'] ?? 0;
        }
      }

      return 0;
    } catch (e) {
      rethrow;
    }
  }

  // Récupérer une notification
  Future<Map<String, dynamic>> getNotification(String id) async {
    try {
      final response = await _apiClient.get(
        '/notifications/$id',
        requireAuth: true,
      );

      if (response['success'] == true) {
        return response['data'] ?? {};
      } else {
        throw ApiException(response['message'] ?? 'Notification non trouvée');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Marquer une notification comme lue
  Future<void> markAsRead(String id) async {
    try {
      final response = await _apiClient.post(
        '/notifications/$id/read',
        body: {},
        requireAuth: true,
      );

      if (response['success'] != true) {
        throw ApiException(response['message'] ?? 'Erreur lors du marquage de la notification');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Marquer toutes les notifications comme lues
  Future<void> markAllAsRead() async {
    try {
      final response = await _apiClient.post(
        '/notifications/read-all',
        body: {},
        requireAuth: true,
      );

      if (response['success'] != true) {
        throw ApiException(response['message'] ?? 'Erreur lors du marquage des notifications');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Supprimer une notification
  Future<void> deleteNotification(String id) async {
    try {
      final response = await _apiClient.delete(
        '/notifications/$id',
        requireAuth: true,
      );

      if (response['success'] != true) {
        throw ApiException(response['message'] ?? 'Erreur lors de la suppression de la notification');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Récupérer les préférences de notification
  Future<Map<String, dynamic>> getPreferences() async {
    try {
      final response = await _apiClient.get(
        '/notifications/preferences',
        requireAuth: true,
      );

      if (response['success'] == true) {
        return response['data'] ?? {};
      } else {
        throw ApiException(response['message'] ?? 'Erreur lors de la récupération des préférences');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Mettre à jour les préférences de notification
  Future<Map<String, dynamic>> updatePreferences(
    Map<String, dynamic> preferences,
  ) async {
    try {
      final response = await _apiClient.put(
        '/notifications/preferences',
        body: preferences,
        requireAuth: true,
      );

      if (response['success'] == true) {
        return response['data'] ?? {};
      } else {
        throw ApiException(response['message'] ?? 'Erreur lors de la mise à jour des préférences');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Notifications push - Récupérer la liste
  Future<List<dynamic>> getPushNotifications() async {
    try {
      final response = await _apiClient.get(
        '/push/notifications',
        requireAuth: true,
      );

      if (response['success'] == true) {
        final data = response['data'];
        if (data is List) {
          return data;
        } else if (data is Map && data['notifications'] is List) {
          return data['notifications'];
        }
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }

  // Notifications push - Récupérer le nombre de non lues
  Future<int> getPushUnreadCount() async {
    try {
      final response = await _apiClient.get(
        '/push/notifications/unread-count',
        requireAuth: true,
      );

      if (response['success'] == true) {
        final data = response['data'];
        if (data is Map) {
          return data['unread_count'] ?? 0;
        }
      }

      return 0;
    } catch (e) {
      rethrow;
    }
  }

  // Notifications push - Récupérer une notification
  Future<Map<String, dynamic>> getPushNotification(String id) async {
    try {
      final response = await _apiClient.get(
        '/push/notifications/$id',
        requireAuth: true,
      );

      if (response['success'] == true) {
        return response['data'] ?? {};
      } else {
        throw ApiException(response['message'] ?? 'Notification non trouvée');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Notifications push - Marquer comme lue
  Future<void> markPushAsRead(String id) async {
    try {
      final response = await _apiClient.post(
        '/push/notifications/$id/read',
        body: {},
        requireAuth: true,
      );

      if (response['success'] != true) {
        throw ApiException(response['message'] ?? 'Erreur lors du marquage');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Notifications push - Marquer toutes comme lues
  Future<void> markAllPushAsRead() async {
    try {
      final response = await _apiClient.post(
        '/push/notifications/read-all',
        body: {},
        requireAuth: true,
      );

      if (response['success'] != true) {
        throw ApiException(response['message'] ?? 'Erreur lors du marquage');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Notifications push - Supprimer
  Future<void> deletePushNotification(String id) async {
    try {
      final response = await _apiClient.delete(
        '/push/notifications/$id',
        requireAuth: true,
      );

      if (response['success'] != true) {
        throw ApiException(response['message'] ?? 'Erreur lors de la suppression');
      }
    } catch (e) {
      rethrow;
    }
  }
}

