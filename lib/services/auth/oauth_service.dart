import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:eamau/services/auth/firebase_auth_service.dart';

/// Service OAuth pour gérer les connexions via Firebase
/// Cet ancien service est remplacé par FirebaseAuthService
@Deprecated('Use FirebaseAuthService instead')
class OAuthService {
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();

   /// Authentifier avec Google
   Future<Map<String, dynamic>> loginWithGoogle() async {
     return await _firebaseAuthService.loginWithGoogle();
   }

   /// Déconnecter
  Future<void> logout() async {
    return await _firebaseAuthService.logout();
  }

  /// Vérifier si connecté
  Future<bool> isLoggedIn() async {
    return await _firebaseAuthService.isLoggedIn();
  }

  /// Nettoyer les ressources
  void dispose() {
    // Rien à faire avec Firebase
  }
}


