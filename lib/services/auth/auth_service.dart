import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:eamau/core/api/api_endpoints.dart';
import 'package:eamau/core/api/dio_client.dart';
import 'package:eamau/core/storage/token_storage.dart';
import 'package:eamau/models/auth/auth_response.dart';
import 'package:eamau/models/auth/login_response.dart';
import 'package:eamau/models/auth/register_request.dart';
import 'package:eamau/models/auth/user.dart';
import 'package:eamau/models/auth/verify_2fa_response.dart';
import 'package:eamau/services/auth/firebase_auth_service.dart';
import '../../../core/api/api_client.dart';

class AuthService {
  DioClient? _dioClientCache;
  TokenStorage? _tokenStorageCache;
  FirebaseAuthService? _firebaseAuthServiceCache;

  DioClient get _dioClient => _dioClientCache ??= DioClient();
  TokenStorage get _tokenStorage => _tokenStorageCache ??= TokenStorage();
  FirebaseAuthService get _firebaseAuthService =>
      _firebaseAuthServiceCache ??= FirebaseAuthService();

  /// Login avec email et mot de passe
  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );

      final loginResponse = LoginResponse.fromJson(response.data);

      if (!loginResponse.requires2fa && loginResponse.accessToken != null) {
        await _tokenStorage.saveAccessToken(loginResponse.accessToken!);
        if (loginResponse.refreshToken != null) {
          await _tokenStorage.saveRefreshToken(loginResponse.refreshToken!);
        }
      }

      return loginResponse;
    } on DioException catch (e) {
      _handleDioException(e);
      rethrow;
    }
  }

  /// Vérifier le code 2FA
  Future<Verify2FAResponse> verify2FA({
    required String email,
    required String code,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        ApiEndpoints.verify2fa,
        data: {'email': email, 'code': code},
      );

      final verify2FAResponse = Verify2FAResponse.fromJson(response.data);

      await _tokenStorage.saveAccessToken(verify2FAResponse.accessToken);
      await _tokenStorage.saveRefreshToken(verify2FAResponse.refreshToken);

      return verify2FAResponse;
    } on DioException catch (e) {
      _handleDioException(e);
      rethrow;
    }
  }

  /// Renvoyer le code 2FA
  Future<void> resend2FA({required String email}) async {
    final normalizedEmail = _normalizeEmail(email);

    if (normalizedEmail == null) {
      throw ValidationException(
        message: 'Adresse email invalide pour l’envoi du code 2FA',
      );
    }

    try {
      await _dioClient.dio.post(
        ApiEndpoints.resend2fa,
        data: {'email': normalizedEmail},
        options: Options(extra: {'skipAuth': true}),
      );
    } on DioException catch (e) {
      _handleDioException(e);
      rethrow;
    }
  }

  /// Demander la réinitialisation du mot de passe
  Future<void> requestPasswordReset({required String email}) async {
    final normalizedEmail = _normalizeEmail(email);

    if (normalizedEmail == null) {
      throw ValidationException(message: 'Adresse email invalide');
    }

    try {
      await _dioClient.dio.post(
        ApiEndpoints.forgotPassword,
        data: {'email': normalizedEmail},
        options: Options(extra: {'skipAuth': true}),
      );
    } on DioException catch (e) {
      _handleDioException(e);
      rethrow;
    }
  }

  /// Réinitialiser le mot de passe avec un token
  Future<void> resetPassword({
    required String token,
    required String password,
  }) async {
    final normalizedToken = token.trim();
    final normalizedPassword = password.trim();

    if (normalizedToken.isEmpty) {
      throw ValidationException(message: 'Token de réinitialisation requis');
    }

    if (normalizedPassword.length < 8) {
      throw ValidationException(
        message: 'Le mot de passe doit contenir au moins 8 caractères',
      );
    }

    try {
      await _dioClient.dio.post(
        ApiEndpoints.resetPassword,
        data: {'token': normalizedToken, 'password': normalizedPassword},
        options: Options(extra: {'skipAuth': true}),
      );
    } on DioException catch (e) {
      _handleDioException(e);
      rethrow;
    }
  }

  /// Enregistrer un nouvel utilisateur
  Future<AuthResponse> register({
    required String email,
    required String firstName,
    required String lastName,
    required String password,
    required String passwordConfirmation,
    String? phone,
  }) async {
    try {
      final request = RegisterRequest(
        email: email,
        firstName: firstName,
        lastName: lastName,
        password: password,
        passwordConfirmation: passwordConfirmation,
        phone: phone,
      );

      final response = await _dioClient.dio.post(
        ApiEndpoints.register,
        data: request.toJson(),
      );

      final authResponse = AuthResponse.fromJson(response.data);

      await _tokenStorage.saveAccessToken(authResponse.accessToken);
      await _tokenStorage.saveRefreshToken(authResponse.refreshToken);

      return authResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 500) {
        final fallback = await _fallbackLoginAfterRegister(
          email: email,
          password: password,
        );
        if (fallback != null) {
          return fallback;
        }
      }

      _handleDioException(e);
      rethrow;
    }
  }

  Future<AuthResponse?> _fallbackLoginAfterRegister({
    required String email,
    required String password,
  }) async {
    try {
      final loginResponse = await login(email: email, password: password);

      if (loginResponse.accessToken == null) {
        return null;
      }

      final user = await getCurrentUser();

      return AuthResponse(
        accessToken: loginResponse.accessToken!,
        refreshToken: loginResponse.refreshToken ?? '',
        user: user,
      );
    } catch (_) {
      return null;
    }
  }

  /// Récupérer l'utilisateur actuel
  Map<String, dynamic>? _unwrapResponseData(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data['data'] is Map<String, dynamic>) {
        return _unwrapResponseData(data['data']);
      }
      if (data['user'] is Map<String, dynamic>) {
        return _unwrapResponseData(data['user']);
      }
      if (data['profile'] is Map<String, dynamic>) {
        return _unwrapResponseData(data['profile']);
      }
      return data;
    }
    return null;
  }

  Future<User> getCurrentUser() async {
    try {
      final response = await _dioClient.dio.get(ApiEndpoints.me);
      final userData = _unwrapResponseData(response.data);

      if (userData == null) {
        throw ServerException(message: 'Données utilisateur invalides');
      }

      return User.fromJson(userData);
    } on DioException catch (e) {
      _handleDioException(e);
      rethrow;
    }
  }

  // Déconnexion gérée par `logout()` plus bas (inclut Firebase + nettoyage local)

  /// Vérifier si l'utilisateur est connecté
  Future<bool> isLoggedIn() async {
    return await _tokenStorage.isLoggedIn();
  }

  /// Récupérer le token d'accès
  Future<String?> getAccessToken() async {
    return await _tokenStorage.getAccessToken();
  }

  /// Récupérer le refresh token
  Future<String?> getRefreshToken() async {
    return await _tokenStorage.getRefreshToken();
  }

  /// Supprimer tous les tokens
  Future<void> deleteTokens() async {
    await _tokenStorage.deleteTokens();
  }

  /// Gérer les exceptions Dio
  void _handleDioException(DioException e) {
    if (e.error is ApiException) {
      throw e.error as ApiException;
    }

    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.connectionTimeout) {
      throw NetworkException(
        message: e.message ?? 'Erreur de connexion réseau',
      );
    }

    if (e.response?.data != null) {
      throw ServerException(message: _extractErrorMessage(e.response?.data));
    }

    throw ServerException(message: e.message ?? 'Erreur serveur');
  }

  String _extractErrorMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is String && message.trim().isNotEmpty) {
        return message;
      }

      final error = data['error'];
      if (error is String && error.trim().isNotEmpty) {
        return error;
      }

      final errors = data['errors'];
      if (errors is Map) {
        final firstError = errors.values.firstWhere(
          (value) => value != null,
          orElse: () => null,
        );
        if (firstError is List && firstError.isNotEmpty) {
          return firstError.first.toString();
        }
        if (firstError != null) {
          return firstError.toString();
        }
      }
    }

    if (data is String && data.trim().isNotEmpty) {
      return data;
    }

    return 'Erreur serveur';
  }

  /// Connexion avec Google (Firebase)
  Future<LoginResponse> loginWithGoogle() async {
    try {
      final result = await _firebaseAuthService.loginWithGoogle();

      final accessToken = result['accessToken'] as String?;
      final refreshToken = result['refreshToken'] as String?;
      final requires2fa = result['requires2fa'] as bool? ?? false;
      final email = (result['user'] is Map<String, dynamic>)
          ? (result['user'] as Map<String, dynamic>)['email'] as String?
          : null;

      // If 2FA required, don't save tokens (backend will return tokens after verification)
      if (!requires2fa && accessToken != null) {
        await _firebaseAuthService.saveTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
      }

      // Return a LoginResponse describing the result
      return LoginResponse(
        accessToken: accessToken,
        refreshToken: refreshToken,
        requires2fa: requires2fa,
        email: email,
      );
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  /// Renouveler les tokens via l'API refresh
  Future<void> refreshTokens() async {
    try {
      final refreshToken = await getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        throw UnauthorizedException(message: 'Aucun refresh token disponible');
      }

      final response = await _dioClient.dio.post(
        ApiEndpoints.refresh,
        data: {'refresh_token': refreshToken},
        options: Options(extra: {'skipAuth': true}),
      );

      final data = response.data['data'] as Map<String, dynamic>?;
      final newAccessToken =
          (data?['access_token'] ?? data?['token']) as String?;
      final newRefreshToken = data?['refresh_token'] as String?;

      if (newAccessToken != null && newAccessToken.isNotEmpty) {
        await _tokenStorage.saveAccessToken(newAccessToken);
      }

      if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
        await _tokenStorage.saveRefreshToken(newRefreshToken);
      }
    } on DioException catch (e) {
      _handleDioException(e);
      rethrow;
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  /// Déconnexion complète (Firebase + Local)
  Future<void> logout() async {
    try {
      await _dioClient.dio.post(ApiEndpoints.logout);
    } catch (e) {
      // Même en cas d'erreur, on nettoie localement
    } finally {
      await _firebaseAuthService.logout();
      await _tokenStorage.deleteTokens();
      await _dioClient.logout();
    }
  }

  /// Valider et normaliser une adresse email
  String? _normalizeEmail(String email) {
    final normalizedEmail = email.trim();
    if (normalizedEmail.isEmpty ||
        !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(normalizedEmail)) {
      return null;
    }
    return normalizedEmail;
  }

  /// Gérer les erreurs
  void _handleError(dynamic error) {
    debugPrint('Firebase Auth Error: $error');
  }
}
