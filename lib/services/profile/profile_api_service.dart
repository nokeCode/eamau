import '../api_client.dart';

class ProfileService {
  final ApiClient _apiClient = ApiClient();

  // Récupérer le profil utilisateur
  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await _apiClient.get(
        '/profile',
        requireAuth: true,
      );

      if (response['success'] == true) {
        return response['data'] ?? {};
      } else {
        throw ApiException(response['message'] ?? 'Erreur lors de la récupération du profil');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Mettre à jour le profil utilisateur
  Future<Map<String, dynamic>> updateProfile(
    Map<String, dynamic> profileData,
  ) async {
    try {
      final response = await _apiClient.put(
        '/profile',
        body: profileData,
        requireAuth: true,
      );

      if (response['success'] == true) {
        return response['data'] ?? {};
      } else {
        throw ApiException(response['message'] ?? 'Erreur lors de la mise à jour du profil');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Récupérer les informations académiques
  Future<Map<String, dynamic>> getAcademicInfo() async {
    try {
      final response = await _apiClient.get(
        '/profile/academic',
        requireAuth: true,
      );

      if (response['success'] == true) {
        return response['data'] ?? {};
      } else {
        throw ApiException(response['message'] ?? 'Erreur lors de la récupération des informations académiques');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Mettre à jour le mot de passe
  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final response = await _apiClient.put(
        '/profile/password',
        body: {
          'current_password': currentPassword,
          'password': newPassword,
          'password_confirmation': confirmPassword,
        },
        requireAuth: true,
      );

      if (response['success'] != true) {
        throw ApiException(response['message'] ?? 'Erreur lors de la mise à jour du mot de passe');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Télécharger une photo de profil
  Future<Map<String, dynamic>> uploadProfilePhoto(String imagePath) async {
    try {
      final response = await _apiClient.post(
        '/profile/photo',
        body: {
          'photo': imagePath,
        },
        requireAuth: true,
      );

      if (response['success'] == true) {
        return response['data'] ?? {};
      } else {
        throw ApiException(response['message'] ?? 'Erreur lors du téléchargement de la photo');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Supprimer la photo de profil
  Future<void> deleteProfilePhoto() async {
    try {
      final response = await _apiClient.delete(
        '/profile/photo',
        requireAuth: true,
      );

      if (response['success'] != true) {
        throw ApiException(response['message'] ?? 'Erreur lors de la suppression de la photo');
      }
    } catch (e) {
      rethrow;
    }
  }
}

