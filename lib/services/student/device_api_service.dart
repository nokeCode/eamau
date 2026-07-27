import '../api_client.dart';

class DeviceService {
  final ApiClient _apiClient = ApiClient();

  // Récupérer la liste des appareils
  Future<List<dynamic>> getDevices() async {
    try {
      final response = await _apiClient.get(
        '/devices',
        requireAuth: true,
      );

      if (response['success'] == true) {
        final data = response['data'];
        if (data is List) {
          return data;
        } else if (data is Map && data['devices'] is List) {
          return data['devices'];
        }
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }

  // Enregistrer un appareil
  Future<Map<String, dynamic>> registerDevice({
    required String deviceId,
    required String deviceName,
    required String osType,
    String? fcmToken,
  }) async {
    try {
      final response = await _apiClient.post(
        '/devices/register',
        body: {
          'device_id': deviceId,
          'device_name': deviceName,
          'os_type': osType,
          if (fcmToken != null) 'fcm_token': fcmToken,
        },
        requireAuth: true,
      );

      if (response['success'] == true) {
        return response['data'] ?? {};
      } else {
        throw ApiException(response['message'] ?? 'Erreur lors de l\'enregistrement de l\'appareil');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Mettre à jour un appareil
  Future<Map<String, dynamic>> updateDevice({
    required String deviceId,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await _apiClient.put(
        '/devices/$deviceId',
        body: data,
        requireAuth: true,
      );

      if (response['success'] == true) {
        return response['data'] ?? {};
      } else {
        throw ApiException(response['message'] ?? 'Erreur lors de la mise à jour de l\'appareil');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Supprimer un appareil
  Future<void> deleteDevice(String deviceId) async {
    try {
      final response = await _apiClient.delete(
        '/devices/$deviceId',
        requireAuth: true,
      );

      if (response['success'] != true) {
        throw ApiException(response['message'] ?? 'Erreur lors de la suppression de l\'appareil');
      }
    } catch (e) {
      rethrow;
    }
  }
}

