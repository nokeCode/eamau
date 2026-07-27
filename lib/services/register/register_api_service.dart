import '../api_client.dart';
import '../auth/auth_service.dart';


class RegisterService {
  final ApiClient _apiClient = ApiClient();
  final AuthService _authService = AuthService();

  // Enregistrer un nouvel utilisateur
  Future<Map<String, dynamic>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? phone,
    String? civility,
    String? dateOfBirth,
  }) async {
    try {
      final response = await _apiClient.post(
        '/auth/register',
        body: {
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
          if (phone != null) 'phone': phone,
          if (civility != null) 'civility': civility,
          if (dateOfBirth != null) 'date_of_birth': dateOfBirth,
        },
      );

      if (response['success'] == true && response['data'] != null) {
        return response['data'];
      } else {
        throw ApiException(response['message'] ?? 'Erreur lors de l\'enregistrement');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Vérifier si un email existe
  Future<bool> checkEmailExists(String email) async {
    try {
      final response = await _apiClient.post(
        '/auth/check-email',
        body: {'email': email},
      );

      if (response['success'] == true && response['data'] != null) {
        final data = response['data'];
        return data['exists'] == true;
      }

      return false;
    } catch (e) {
      rethrow;
    }
  }

  // Vérifier si un téléphone existe
  Future<bool> checkPhoneExists(String phone) async {
    try {
      final response = await _apiClient.post(
        '/auth/check-phone',
        body: {'phone': phone},
      );

      if (response['success'] == true && response['data'] != null) {
        final data = response['data'];
        return data['exists'] == true;
      }

      return false;
    } catch (e) {
      rethrow;
    }
  }

  // Confirmer l'email
  Future<void> confirmEmail(String token) async {
    try {
      final response = await _apiClient.post(
        '/auth/confirm-email',
        body: {'token': token},
      );

      if (response['success'] != true) {
        throw ApiException(response['message'] ?? 'Erreur lors de la confirmation de l\'email');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Renvoyer l'email de confirmation
  Future<void> resendConfirmationEmail(String email) async {
    try {
      final response = await _apiClient.post(
        '/auth/resend-confirmation',
        body: {'email': email},
      );

      if (response['success'] != true) {
        throw ApiException(response['message'] ?? 'Erreur lors du renvoi de l\'email');
      }
    } catch (e) {
      rethrow;
    }
  }
}

