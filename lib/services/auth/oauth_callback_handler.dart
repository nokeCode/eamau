import 'package:flutter/foundation.dart';
import 'package:eamau/providers/auth_provider.dart';
import 'dart:async';

/// Gestionnaire des deep links pour les callbacks OAuth
class DeepLinkManager {
  static final DeepLinkManager _instance = DeepLinkManager._internal();

  final _deepLinkController = StreamController<String>.broadcast();

  Stream<String> get deepLinkStream => _deepLinkController.stream;

  DeepLinkManager._internal();

  factory DeepLinkManager() {
    return _instance;
  }

  /// Traiter un deep link reçu
  void handleDeepLink(String url) {
    print('Deep link received: $url');
    _deepLinkController.add(url);
  }

  /// Parser le code d'authentification d'une URL
  String? extractAuthCode(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.queryParameters['code'];
    } catch (e) {
      print('Error parsing deep link: $e');
      return null;
    }
  }

   /// Extraire le type de provider (google)
   String? extractProvider(String url) {
     if (url.contains('google')) return 'google';
     return null;
   }

  /// Nettoyer les ressources
  void dispose() {
    _deepLinkController.close();
  }
}

/// Helper pour gérer les callbacks OAuth
class OAuthCallbackHandler {
  final AuthProvider authProvider;
  late DeepLinkManager _deepLinkManager;
  late StreamSubscription _deepLinkSubscription;

  OAuthCallbackHandler({required this.authProvider}) {
    _deepLinkManager = DeepLinkManager();
    _setupDeepLinkListener();
  }

  void _setupDeepLinkListener() {
    _deepLinkSubscription = _deepLinkManager.deepLinkStream.listen(
      (String deepLink) => _handleDeepLink(deepLink),
      onError: (error) {
        print('Deep link error: $error');
      },
    );
  }

   Future<void> _handleDeepLink(String deepLink) async {
     final provider = _deepLinkManager.extractProvider(deepLink);
     final code = _deepLinkManager.extractAuthCode(deepLink);

     if (code == null) {
       print('No auth code found in deep link');
       return;
     }

     if (provider == 'google') {
       await authProvider.handleGoogleCallback(code);
     }
   }

  /// Traiter un deep link reçu (appelé depuis MainActivity/SceneDelegate)
  void processDeepLink(String url) {
    _deepLinkManager.handleDeepLink(url);
  }

  void dispose() {
    _deepLinkSubscription.cancel();
    _deepLinkManager.dispose();
  }
}

