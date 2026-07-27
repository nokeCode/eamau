import '../api_client.dart';

class ContactService {
  final ApiClient _apiClient = ApiClient();

  // Envoyer un message de contact
  Future<Map<String, dynamic>> sendContactMessage({
    required String name,
    required String email,
    required String subject,
    required String message,
    String? phone,
  }) async {
    try {
      final response = await _apiClient.post(
        '/contact',
        body: {
          'name': name,
          'email': email,
          'subject': subject,
          'message': message,
          if (phone != null) 'phone': phone,
        },
      );

      if (response['success'] == true) {
        return response['data'] ?? {};
      } else {
        throw ApiException(response['message'] ?? 'Erreur lors de l\'envoi du message');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Envoyer un message depuis un utilisateur connecté
  Future<Map<String, dynamic>> sendAuthenticatedMessage({
    required String subject,
    required String message,
  }) async {
    try {
      final response = await _apiClient.post(
        '/contact/authenticated',
        body: {
          'subject': subject,
          'message': message,
        },
        requireAuth: true,
      );

      if (response['success'] == true) {
        return response['data'] ?? {};
      } else {
        throw ApiException(response['message'] ?? 'Erreur lors de l\'envoi du message');
      }
    } catch (e) {
      rethrow;
    }
  }
}

