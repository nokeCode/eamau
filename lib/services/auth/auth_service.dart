import 'package:shared_preferences/shared_preferences.dart';
import '../api_client.dart';

class AuthService {
  static const _tokenKey = "access_token";
  static const _refreshTokenKey = "refresh_token";
  static const _userKey = "user_data";

  final ApiClient _apiClient = ApiClient();

  // Récupérer le token d'accès
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Récupérer le refresh token
  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  // Vérifier si connecté
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Connexion
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post(
        '/auth/login',
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response['success'] == true && response['data'] != null) {
        final token = response['data']['token'];
        final refreshToken = response['data']['refresh_token'];

        await saveToken(token);
        await saveRefreshToken(refreshToken);

        return response['data'];
      } else {
        throw ApiException(response['message'] ?? 'Erreur de connexion');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Vérification 2FA
  Future<Map<String, dynamic>> verify2FA({
    required String email,
    required String code,
  }) async {
    try {
      final response = await _apiClient.post(
        '/auth/2fa/check',
        body: {
          'email': email,
          'code': code,
        },
      );

      if (response['success'] == true && response['data'] != null) {
        final token = response['data']['token'];
        final refreshToken = response['data']['refresh_token'];

        await saveToken(token);
        await saveRefreshToken(refreshToken);

        return response['data'];
      } else {
        throw ApiException(response['message'] ?? 'Code 2FA invalide');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Renvoi du code 2FA
  Future<void> resend2FA({required String email}) async {
    try {
      final response = await _apiClient.post(
        '/auth/2fa/resend',
        body: {'email': email},
      );

      if (response['success'] != true) {
        throw ApiException(response['message'] ?? 'Erreur lors du renvoi du code');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Mot de passe oublié
  Future<void> forgotPassword({required String email}) async {
    try {
      final response = await _apiClient.post(
        '/auth/forgot-password',
        body: {'email': email},
      );

      if (response['success'] != true) {
        throw ApiException(response['message'] ?? 'Erreur lors de la réinitialisation');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Réinitialiser le mot de passe
  Future<void> resetPassword({
    required String token,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post(
        '/auth/reset-password',
        body: {
          'token': token,
          'password': password,
        },
      );

      if (response['success'] != true) {
        throw ApiException(response['message'] ?? 'Erreur lors de la réinitialisation');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Renouveler le token
  Future<void> refreshToken() async {
    try {
      final currentRefreshToken = await getRefreshToken();
      if (currentRefreshToken == null) {
        throw ApiException('Refresh token non trouvé');
      }

      final response = await _apiClient.post(
        '/auth/refresh',
        body: {'refresh_token': currentRefreshToken},
      );

      if (response['success'] == true && response['data'] != null) {
        final newToken = response['data']['token'];
        await saveToken(newToken);
      } else {
        throw ApiException(response['message'] ?? 'Erreur de renouvellement du token');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Récupérer l'utilisateur connecté
  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final response = await _apiClient.get(
        '/auth/me',
        requireAuth: true,
      );

      if (response['success'] == true && response['data'] != null) {
        return response['data'];
      } else {
        throw ApiException(response['message'] ?? 'Impossible de récupérer l\'utilisateur');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Google OAuth
  Future<String> getGoogleOAuthUrl() async {
    try {
      final response = await _apiClient.get('/auth/google');

      if (response['success'] == true && response['data'] != null) {
        return response['data']['url'] ?? '';
      } else {
        throw ApiException('Impossible de récupérer l\'URL Google OAuth');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Facebook OAuth
  Future<String> getFacebookOAuthUrl() async {
    try {
      final response = await _apiClient.get('/auth/facebook');

      if (response['success'] == true && response['data'] != null) {
        return response['data']['url'] ?? '';
      } else {
        throw ApiException('Impossible de récupérer l\'URL Facebook OAuth');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Sauvegarder le token
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // Sauvegarder le refresh token
  Future<void> saveRefreshToken(String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_refreshTokenKey, refreshToken);
  }

  // Déconnexion
  Future<void> logout() async {
    try {
      await _apiClient.post(
        '/auth/logout',
        body: {},
        requireAuth: true,
      );
    } catch (e) {
      // Continue même si l'appel API échoue
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_userKey);
  }

}