import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:eamau/core/storage/token_storage.dart';
import 'package:dio/dio.dart';
import 'package:eamau/core/api/dio_client.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final TokenStorage _tokenStorage = TokenStorage();
  final DioClient _dioClient = DioClient();

  // API Base URL - à adapter selon l'environnement
  static const String _baseUrl = 'http://10.0.2.2:9090/api/v1';

  /// Connexion avec Google + Firebase + Backend Symfony
  Future<Map<String, dynamic>> loginWithGoogle() async {
    try {
      // Étape 1 : Authentifier avec Google
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google sign-in cancelled by user');
      }

      // Étape 2 : Obtenir les credentials Firebase
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      // Étape 3 : Se connecter à Firebase
      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      // Étape 4 : Récupérer le Firebase ID Token
      final firebaseUser = userCredential.user!;
      final firebaseIdToken = await firebaseUser.getIdToken(true);

      // Étape 5 : Envoyer au backend Symfony
      final response = await _dioClient.dio.post(
        '$_baseUrl/auth/firebase',
        data: {'idToken': firebaseIdToken},
      );

      // Étape 6 : Traiter la réponse Symfony
      final result = _handleSymfonyResponse(response);

      return result;
    } on FirebaseAuthException catch (e) {
      throw Exception('Firebase auth error: ${e.message}');
    } catch (e) {
      rethrow;
    }
   }

   /// Traiter la réponse du backend Symfony
  Map<String, dynamic> _handleSymfonyResponse(Response response) {
    final data = response.data;

    // Vérifier si la réponse a la structure attendue
    if (data is! Map<String, dynamic>) {
      throw Exception('Invalid response format from backend');
    }

    final responseData = data['data'] as Map<String, dynamic>? ?? data;

    // Extraire les tokens
    final accessToken = responseData['access_token'] as String?;
    final refreshToken = responseData['refresh_token'] as String?;
    final user = responseData['user'] as Map<String, dynamic>?;
    final requires2fa = responseData['requires_2fa'] as bool? ?? false;

    if (accessToken == null) {
      throw Exception('No access token in response');
    }

    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'user': user,
      'requires2fa': requires2fa,
    };
  }

  /// Sauvegarder les tokens localement
  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    await _tokenStorage.saveAccessToken(accessToken);
    if (refreshToken != null) {
      await _tokenStorage.saveRefreshToken(refreshToken);
    }
  }

  /// Récupérer l'access token sauvegardé
  Future<String?> getAccessToken() async {
    return await _tokenStorage.getAccessToken();
  }

  /// Récupérer le refresh token sauvegardé
  Future<String?> getRefreshToken() async {
    return await _tokenStorage.getRefreshToken();
  }

  /// Renouveler les tokens
  Future<void> refreshTokens() async {
    try {
      final refreshToken = await getRefreshToken();
      if (refreshToken == null) {
        throw Exception('No refresh token available');
      }

      final response = await _dioClient.dio.post(
        '$_baseUrl/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      final result = _handleSymfonyResponse(response);
      await saveTokens(
        accessToken: result['accessToken'] as String,
        refreshToken: result['refreshToken'] as String?,
      );
    } catch (e) {
      throw Exception('Token refresh failed: $e');
    }
  }

   /// Déconnexion
   Future<void> logout() async {
     try {
       // Déconnecter de Firebase
       await _firebaseAuth.signOut();

       // Déconnecter de Google
       await _googleSignIn.signOut();

       // Supprimer les tokens locaux
       await _tokenStorage.deleteTokens();
     } catch (e) {
       print('Logout error: $e');
       // Toujours supprimer les tokens même en cas d'erreur
       await _tokenStorage.deleteTokens();
     }
   }

  /// Vérifier si l'utilisateur est connecté
  Future<bool> isLoggedIn() async {
    return await _tokenStorage.isLoggedIn();
  }

  /// Obtenir l'utilisateur Firebase actuel
  User? getCurrentFirebaseUser() {
    return _firebaseAuth.currentUser;
  }

   /// Flux de connexion avec gestion 2FA
   Future<Map<String, dynamic>> handleAuthenticationFlow({
     required bool Function(String) onNeedsVerification,
     required bool Function(Map<String, dynamic>) onSuccess,
     required bool Function(String) onError,
     required String provider, // 'google'
   }) async {
     try {
       late Map<String, dynamic> authResult;

       if (provider == 'google') {
         authResult = await loginWithGoogle();
       } else {
         throw Exception('Unknown provider: $provider');
       }

       // Sauvegarder les tokens
       await saveTokens(
         accessToken: authResult['accessToken'] as String,
         refreshToken: authResult['refreshToken'] as String?,
       );

       // Vérifier si 2FA est requis
       if (authResult['requires2fa'] as bool) {
         return {
           'success': onNeedsVerification(
             authResult['user']?['email'] ?? 'user@example.com',
           ),
           'requires2fa': true,
           'data': authResult,
         };
       }

       // Authentification réussie
       return {
         'success': onSuccess(authResult),
         'requires2fa': false,
         'data': authResult,
       };
     } catch (e) {
       onError(e.toString());
       return {
         'success': false,
         'error': e.toString(),
       };
     }
   }
}

