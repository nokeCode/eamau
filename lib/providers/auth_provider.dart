import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:eamau/core/api/api_client.dart';
import 'package:eamau/models/auth/user.dart';
import 'package:eamau/services/auth/auth_service.dart';
import 'package:eamau/services/auth/user_session_service.dart';
import 'package:eamau/services/notification/notification_service.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  final UserSessionService _sessionService;

  AuthProvider({AuthService? authService, bool checkLoginStatus = true})
    : _authService = authService ?? AuthService(),
      _sessionService = UserSessionService() {
    if (checkLoginStatus) {
      _checkLoginStatus();
    }
  }

  bool _isLoading = false;
  bool _isLoggedIn = false;
  String? _error;
  String? _pending2FAEmail;

  // Getters
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  User? get user => _sessionService.currentUser;
  String? get currentProfile => _sessionService.currentProfile;
  bool get isStudent => _sessionService.isStudent;
  bool get isUser => _sessionService.isUser;
  String? get profileRouteName => _sessionService.profileRouteName;
  String? get error => _error;
  bool get pending2FA => _pending2FAEmail != null;
  String? get pending2FAEmail => _pending2FAEmail;

  static String? formatValidationErrors(Map<String, dynamic>? errors) {
    if (errors == null || errors.isEmpty) {
      return null;
    }

    final parts = <String>[];
    errors.forEach((key, value) {
      try {
        if (value is List && value.isNotEmpty) {
          parts.add('$key: ${value[0]}');
        } else {
          parts.add('$key: $value');
        }
      } catch (_) {
        parts.add('$key: $value');
      }
    });

    return parts.join(' | ');
  }

  /// Vérifier l'état de connexion au démarrage
  Future<void> _checkLoginStatus() async {
    _isLoggedIn = await _authService.isLoggedIn();

    if (_isLoggedIn) {
      try {
        await refreshSessionFromBackend();
      } catch (e) {
        _isLoggedIn = false;
        _sessionService.clearSession();
        await _authService.deleteTokens();
      }
    } else {
      _sessionService.clearSession();
    }

    notifyListeners();
  }

  Future<bool> bootstrapSession() async {
    final hasTokens = await _authService.isLoggedIn();

    if (!hasTokens) {
      _isLoggedIn = false;
      _sessionService.clearSession();
      notifyListeners();
      return false;
    }

    try {
      await refreshSessionFromBackend();
      return true;
    } catch (_) {
      _isLoggedIn = false;
      _sessionService.clearSession();
      await _authService.deleteTokens();
      notifyListeners();
      return false;
    }
  }

  Future<void> refreshSessionFromBackend() async {
    final currentUser = await _authService.getCurrentUser();
    _sessionService.updateSession(
      user: currentUser,
      profile: currentUser.profile ?? currentUser.role,
    );
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<void> _registerDeviceTokenAfterLogin() async {
    try {
      final messaging = FirebaseMessaging.instance;
      final notificationSettings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (notificationSettings.authorizationStatus == AuthorizationStatus.denied) {
        return;
      }

      final token = await messaging.getToken();
      if (token == null || token.isEmpty) {
        return;
      }

      debugPrint(token);

      final packageInfo = await PackageInfo.fromPlatform();
      final payload = {
        'deviceToken': token,
        'platform': Platform.isAndroid ? 'android' : 'ios',
        'deviceName': Platform.localHostname,
        'manufacturer': Platform.isAndroid ? 'Android' : 'Apple',
        'model': Platform.localHostname,
        'osVersion': Platform.operatingSystemVersion,
        'appVersion': packageInfo.version,
        'language': 'fr',
        'timezone': DateTime.now().timeZoneName,
      };

      await NotificationService().registerDevice(payload);
    } catch (e) {
      if (kDebugMode) {
        print('FCM registration error: $e');
      }
    }
  }

  /// Login
  Future<bool> login({required String email, required String password}) async {
    _setLoading(true);
    _error = null;

    try {
      final response = await _authService.login(
        email: email,
        password: password,
      );

      if (response.requires2fa) {
        _pending2FAEmail = response.email ?? email;
        _setLoading(false);
        return false; // Retourner false pour indiquer 2FA requis
      }

      _isLoggedIn = true;
      _sessionService.clearSession();
      await refreshSessionFromBackend();
      await _registerDeviceTokenAfterLogin();
      _setLoading(false);
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      _setLoading(false);
      return false;
    } catch (e) {
      _error = 'Erreur lors de la connexion';
      _setLoading(false);
      return false;
    }
  }

  /// Vérifier 2FA
  Future<bool> verify2FA({required String email, required String code}) async {
    _setLoading(true);
    _error = null;

    try {
      final response = await _authService.verify2FA(email: email, code: code);

      _isLoggedIn = true;
      _sessionService.updateSession(
        user: response.user,
        profile: response.user.profile ?? response.user.role,
      );
      await refreshSessionFromBackend();
      await _registerDeviceTokenAfterLogin();
      _pending2FAEmail = null;
      _setLoading(false);
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      _setLoading(false);
      return false;
    } catch (e) {
      _error = 'Erreur lors de la vérification 2FA';
      _setLoading(false);
      return false;
    }
  }

  /// Renvoyer le code 2FA
  Future<bool> resend2FA({required String email}) async {
    _setLoading(true);
    _error = null;

    try {
      await _authService.resend2FA(email: email);
      _setLoading(false);
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      _setLoading(false);
      return false;
    } catch (e) {
      _error = 'Erreur lors de l\'envoi du code';
      _setLoading(false);
      return false;
    }
  }

  /// Demander la réinitialisation du mot de passe
  Future<bool> requestPasswordReset({required String email}) async {
    _setLoading(true);
    _error = null;

    try {
      await _authService.requestPasswordReset(email: email);
      _setLoading(false);
      return true;
    } on ValidationException catch (e) {
      _error =
          formatValidationErrors(
            e.errors is Map<String, dynamic>
                ? e.errors as Map<String, dynamic>
                : null,
          ) ??
          e.message;
      _setLoading(false);
      return false;
    } on ApiException catch (e) {
      _error = e.message;
      _setLoading(false);
      return false;
    } catch (e) {
      _error = 'Erreur lors de la réinitialisation du mot de passe';
      _setLoading(false);
      return false;
    }
  }

  /// Réinitialiser le mot de passe avec un token
  Future<bool> resetPassword({
    required String token,
    required String password,
  }) async {
    _setLoading(true);
    _error = null;

    try {
      await _authService.resetPassword(token: token, password: password);
      _setLoading(false);
      return true;
    } on ValidationException catch (e) {
      _error =
          formatValidationErrors(
            e.errors is Map<String, dynamic>
                ? e.errors as Map<String, dynamic>
                : null,
          ) ??
          e.message;
      _setLoading(false);
      return false;
    } on ApiException catch (e) {
      _error = e.message;
      _setLoading(false);
      return false;
    } catch (e) {
      _error = 'Erreur lors de la réinitialisation du mot de passe';
      _setLoading(false);
      return false;
    }
  }

  /// Enregistrer un nouvel utilisateur
  Future<bool> register({
    required String email,
    required String firstName,
    required String lastName,
    required String password,
    required String passwordConfirmation,
    String? phone,
  }) async {
    _setLoading(true);
    _error = null;

    try {
      final response = await _authService.register(
        email: email,
        firstName: firstName,
        lastName: lastName,
        password: password,
        passwordConfirmation: passwordConfirmation,
        phone: phone,
      );

      _isLoggedIn = true;
      _sessionService.updateSession(
        user: response.user,
        profile: response.user.profile ?? response.user.role,
      );
      await refreshSessionFromBackend();
      await _registerDeviceTokenAfterLogin();
      _setLoading(false);
      return true;
    } on ValidationException catch (e) {
      _error =
          formatValidationErrors(
            e.errors is Map<String, dynamic>
                ? e.errors as Map<String, dynamic>
                : null,
          ) ??
          e.message;
      _setLoading(false);
      return false;
    } on ApiException catch (e) {
      _error = e.message;
      _setLoading(false);
      return false;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  /// Charger l'utilisateur actuel
  Future<bool> loadCurrentUser() async {
    _setLoading(true);
    _error = null;

    try {
      await refreshSessionFromBackend();
      _setLoading(false);
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      _setLoading(false);
      return false;
    } catch (e) {
      _error = 'Erreur lors du chargement de l\'utilisateur';
      _setLoading(false);
      return false;
    }
  }

  /// Déconnexion
  Future<void> logout() async {
    _setLoading(true);

    try {
      await _authService.logout();
    } catch (e) {
      // Même en cas d'erreur, on nettoie localement
    } finally {
      _isLoggedIn = false;
      _sessionService.clearSession();
      _error = null;
      _setLoading(false);
    }
  }

  /// Connexion avec Google (Firebase)
  Future<bool> loginWithGoogle() async {
    _setLoading(true);
    _error = null;

    try {
      final response = await _authService.loginWithGoogle();

      if (response.requires2fa) {
        _pending2FAEmail = response.email;
        _setLoading(false);
        return false; // Nécessite vérification 2FA
      }

      _isLoggedIn = true;
      _sessionService.clearSession();
      await refreshSessionFromBackend();
      await _registerDeviceTokenAfterLogin();
      _setLoading(false);
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      _setLoading(false);
      return false;
    } catch (e) {
      _error = 'Erreur lors de la connexion avec Google: ${e.toString()}';
      _setLoading(false);
      return false;
    }
  }

  /// Gérer le callback OAuth Google (deep link)
  /// Stub pour compatibilité avec le gestionnaire de deep links.
  Future<void> handleGoogleCallback(String code) async {
    // Currently we map callbacks to the normal Google login flow.
    // If you implement a server-side exchange, handle it here.
    try {
      await loginWithGoogle();
    } catch (e) {
      // ignore errors for now
    }
  }

  /// Effacer l'erreur
  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
