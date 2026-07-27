# 📱 Intégration API EAMAU - Guide Complet

## ✅ Travail Réalisé

### 1. **Client API Centralisé** (`lib/services/api_client.dart`)
- ✅ Configuration centralisée avec base URL: `http://localhost:9090/api/v1`
- ✅ Gestion automatique des headers d'authentification (JWT)
- ✅ Méthodes pour GET, POST, PUT, PATCH, DELETE
- ✅ Gestion des réponses et erreurs standardisées
- ✅ Classes d'exceptions personnalisées:
  - `UnauthorizedException` (401)
  - `ForbiddenException` (403)
  - `NotFoundException` (404)
  - `ValidationException` (422)
  - `ApiException` (générale)

### 2. **Services API Créés**

#### Authentification
- ✅ **AuthService** (`lib/services/auth/auth_service.dart`)
  - `login()` - Connexion
  - `verify2FA()` - Vérification 2FA
  - `resend2FA()` - Renvoi code 2FA
  - `forgotPassword()` - Mot de passe oublié
  - `resetPassword()` - Réinitialiser mot de passe
  - `refreshToken()` - Renouveler le token
  - `getCurrentUser()` - Utilisateur connecté
  - `getGoogleOAuthUrl()` - OAuth Google
  - `getFacebookOAuthUrl()` - OAuth Facebook
  - `logout()` - Déconnexion

- ✅ **RegisterService** (`lib/services/register/register_api_service.dart`)
  - `register()` - Enregistrement utilisateur
  - `checkEmailExists()` - Vérifier email
  - `checkPhoneExists()` - Vérifier téléphone
  - `confirmEmail()` - Confirmer email
  - `resendConfirmationEmail()` - Renvoyer email confirmation

#### Contenu
- ✅ **NewsService** (`lib/services/news/news_service.dart`)
  - `getNews()` - Liste des actualités
  - `getFeaturedNews()` - Actualités en avant
  - `getCategories()` - Catégories
  - `searchNews()` - Recherche
  - `getNewsBySlug()` - Détail par slug
  - `getNewsByCategory()` - Par catégorie

- ✅ **ConcoursService** (`lib/services/concours/concours_api_service.dart`)
  - `getConcours()` - Liste des concours
  - `searchConcours()` - Recherche
  - `getConcoursDetail()` - Détail
  - `applyToConcours()` - Postuler

- ✅ **FiliereService** (`lib/services/filiere/filiere_api_service.dart`)
  - `getFilieres()` - Liste des filières
  - `searchFilieres()` - Recherche
  - `getFiliereDetail()` - Détail
  - `getFilieureParcours()` - Parcours
  - `getParcours()` - Tous les parcours

#### Utilisateur
- ✅ **ProfileService** (`lib/services/profile/profile_api_service.dart`)
  - `getProfile()` - Profil utilisateur
  - `updateProfile()` - Mettre à jour
  - `getAcademicInfo()` - Infos académiques
  - `updatePassword()` - Changer mot de passe
  - `uploadProfilePhoto()` - Photo profil
  - `deleteProfilePhoto()` - Supprimer photo

- ✅ **NotificationService** (`lib/services/notification/notification_api_service.dart`)
  - `getNotifications()` - Liste
  - `getLatestNotifications()` - Dernières
  - `getUnreadCount()` - Non lues
  - `getNotification()` - Détail
  - `markAsRead()` - Marquer lue
  - `markAllAsRead()` - Tout marquer lue
  - `deleteNotification()` - Supprimer
  - `getPreferences()` - Préférences
  - `updatePreferences()` - Mettre à jour
  - `getPushNotifications()` - Push notifications
  - Et 5 autres méthodes pour les notifications push

#### Gestion des Candidatures
- ✅ **AdmissionService** (`lib/services/admission/admission_api_service.dart`)
  - `getAdmissionConditions()` - Conditions
  - `getAdmissionLevels()` - Niveaux
  - `getAdmissions()` - Liste
  - `createAdmission()` - Créer
  - `getAdmissionsStatistics()` - Statistiques
  - `getAdmissionDetail()` - Détail
  - `updateAdmission()` - Mettre à jour
  - `deleteAdmission()` - Supprimer
  - `getAdmissionHistory()` - Historique
  - `getAdmissionTracking()` - Suivi
  - `getAdmissionDocuments()` - Documents
  - `addAdmissionDocument()` - Ajouter document
  - `deleteAdmissionDocument()` - Supprimer document
  - `submitAdmission()` - Soumettre

- ✅ **InscriptionService** (`lib/services/student/inscription_api_service.dart`)
  - `getInscriptions()` - Liste
  - `createInscription()` - Créer
  - `getRequiredDocuments()` - Pièces requises
  - `getInscriptionDetail()` - Détail
  - `updateInscription()` - Mettre à jour
  - `uploadDocument()` - Télécharger document
  - `deleteDocument()` - Supprimer document
  - `downloadInscriptionSheet()` - Télécharger fiche
  - `getInscriptionHistory()` - Historique
  - `submitInscription()` - Soumettre
  - `getInscriptionTracking()` - Suivi

- ✅ **PostulationService** (`lib/services/student/postulation_api_service.dart`)
  - `getPostulationDetail()` - Détail
  - `uploadDocument()` - Document
  - `deleteDocument()` - Supprimer
  - `submitPostulation()` - Soumettre
  - `getAttestation()` - Attestation
  - `getHistory()` - Historique
  - `getTracking()` - Suivi

#### Ressources
- ✅ **PublicationService** (`lib/services/student/publication_api_service.dart`)
  - `getPublications()` - Liste
  - `createPublication()` - Créer
  - `getAuthors()` - Auteurs
  - `getCategories()` - Catégories
  - `getFavorites()` - Favoris
  - `searchPublications()` - Recherche
  - `getTypes()` - Types
  - `getPublicationBySlug()` - Par slug
  - `updatePublication()` - Mettre à jour
  - `addToFavorites()` - Ajouter favoris
  - `removeFromFavorites()` - Retirer favoris
  - `downloadPublication()` - Télécharger
  - `downloadFile()` - Télécharger fichier
  - `getHistory()` - Historique
  - `recordView()` - Enregistrer vue

#### Autres
- ✅ **DeviceService** (`lib/services/student/device_api_service.dart`)
  - `getDevices()` - Liste appareils
  - `registerDevice()` - Enregistrer
  - `updateDevice()` - Mettre à jour
  - `deleteDevice()` - Supprimer

- ✅ **ContactService** (`lib/services/contact/contact_api_service.dart`)
  - `sendContactMessage()` - Message public
  - `sendAuthenticatedMessage()` - Message authentifié

### 3. **Documentation d'Intégration** (`INTEGRATION_GUIDE.dart`)
- ✅ Guide complet avec exemples pour chaque écran
- ✅ Patterns d'utilisation dans les StatefulWidgets
- ✅ Gestion des erreurs
- ✅ Gestion des états de chargement

## 🚀 Prochaines Étapes

### 1. **Intégrer les Services dans les Écrans**

Pour chaque écran, suivez le pattern du guide d'intégration:

```dart
// Exemple simple
import 'package:eamau/services/news/news_service.dart';

class NewsScreen extends StatefulWidget {
  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final NewsService _newsService = NewsService();
  List<NewsModel> news = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  Future<void> _loadNews() async {
    setState(() => isLoading = true);
    try {
      final result = await _newsService.getNews();
      setState(() => news = result);
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Actualités')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: news.length,
              itemBuilder: (context, index) => NewsCard(news[index]),
            ),
    );
  }
}
```

### 2. **État Gestion avec Provider (Recommandé)**

Créez des Providers pour chaque service:

```dart
// lib/providers/news_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eamau/services/news/news_service.dart';

final newsServiceProvider = Provider((ref) => NewsService());

final newsProvider = FutureProvider.family((ref, int page) async {
  final newsService = ref.watch(newsServiceProvider);
  return newsService.getNews(page: page);
});

// Dans l'écran:
class NewsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsAsync = ref.watch(newsProvider(1));

    return newsAsync.when(
      data: (news) => ListView.builder(
        itemCount: news.length,
        itemBuilder: (context, index) => NewsCard(news[index]),
      ),
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, st) => Center(child: Text('Erreur: $error')),
    );
  }
}
```

### 3. **Tester les Appels API**

```bash
# 1. Démarrer le serveur backend
# Base URL: http://localhost:9090

# 2. Vérifier la connectivité
curl -i http://localhost:9090/api/v1/news

# 3. Tester la connexion
curl -X POST http://localhost:9090/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}'
```

### 4. **Points de Vérification**

- [ ] Tous les services utilisent le `ApiClient` centralisé
- [ ] Les tokens JWT sont correctement sauvegardés/utilisés
- [ ] La gestion des erreurs 401/403 fonctionne
- [ ] Les requêtes authentifiées passent le header Bearer token
- [ ] Les pages de chargement sont affichées
- [ ] Les messages d'erreur sont utilisateur-friendly
- [ ] Les données sont rafraîchies correctement
- [ ] La déconnexion nettoie les tokens

### 5. **Logs et Debugging**

Ajoutez du logging dans ApiClient:

```dart
// Dans ApiClient._handleResponse
if (kDebugMode) {
  print('Response: ${response.statusCode}');
  print('Body: ${response.body}');
}
```

## 📚 Structure des Fichiers

```
lib/
├── services/
│   ├── api_client.dart                    # Client API centralisé
│   ├── auth/
│   │   ├── auth_service.dart             # Authentification (MIS À JOUR)
│   ├── news/
│   │   └── news_service.dart             # Actualités (MIS À JOUR)
│   ├── concours/
│   │   └── concours_api_service.dart     # Concours (NOUVEAU)
│   ├── filiere/
│   │   └── filiere_api_service.dart      # Filières (NOUVEAU)
│   ├── admission/
│   │   └── admission_api_service.dart    # Admission (NOUVEAU)
│   ├── notification/
│   │   └── notification_api_service.dart # Notifications (NOUVEAU)
│   ├── profile/
│   │   └── profile_api_service.dart      # Profil (NOUVEAU)
│   ├── register/
│   │   └── register_api_service.dart     # Enregistrement (NOUVEAU)
│   ├── contact/
│   │   └── contact_api_service.dart      # Contact (NOUVEAU)
│   └── student/
│       ├── inscription_api_service.dart  # Inscriptions (NOUVEAU)
│       ├── postulation_api_service.dart  # Postulations (NOUVEAU)
│       ├── publication_api_service.dart  # Publications (NOUVEAU)
│       └── device_api_service.dart       # Devices (NOUVEAU)
└── screens/
    ├── home_screen.dart                  # À intégrer
    ├── login_screen.dart                 # À intégrer
    ├── news_screen.dart                  # À intégrer
    ├── concours/
    │   ├── concours_list_screen.dart    # À intégrer
    │   └── detail_concours_screen.dart  # À intégrer
    ├── filiere_screen.dart               # À intégrer
    ├── profile_screen.dart               # À intégrer
    └── notification_screen.dart          # À intégrer
```

## 🔧 Configuration

### Variables d'Environnement (Optionnel)

Créez un fichier `.env`:

```
API_BASE_URL=http://localhost:9090/api/v1
API_TIMEOUT=30
DEBUG_MODE=true
```

### Pubspec Dependencies

Vérifiez que vous avez:

```yaml
dependencies:
  http: ^1.5.0
  shared_preferences: ^2.0.0
  provider: ^6.0.0  # Si utilisant Provider/Riverpod
  flutter_riverpod: ^2.0.0  # Optionnel
```

## 📋 Checklist de Déploiement

- [ ] Tous les services testés avec le backend
- [ ] Authentification fonctionne correctement
- [ ] Les tokens sont rafraîchis automatiquement
- [ ] La déconnexion fonctionne
- [ ] Les erreurs sont gérées correctement
- [ ] Les pages de loading s'affichent
- [ ] Les pages sont responsives
- [ ] Les animations sont smooth
- [ ] Les tests unitaires passent
- [ ] Les tests d'intégration passent

## 🆘 Troubleshooting

### Erreur 401 Unauthorized
- Vérifiez que le token est sauvegardé correctement
- Vérifiez que le header `Authorization: Bearer <token>` est envoyé
- Renouvelez le token avec `refreshToken()`

### Erreur 422 Validation Error
- Vérifiez le format des données envoyées
- Consultez `ValidationException.errors` pour les détails

### Erreur de Réseau
- Vérifiez que le serveur backend est en cours d'exécution
- Vérifiez la base URL
- Vérifiez les logs du backend

### Données non à jour
- Utilisez `FutureBuilder` ou `StreamBuilder`
- Implémentez un système de cache
- Utilisez des Providers avec auto-refresh

## 📞 Support

Pour toute question sur l'intégration, consultez:
1. Le fichier `INTEGRATION_GUIDE.dart`
2. Les exemples dans chaque service
3. La documentation de l'API dans `API_GUIDE.html`

---

**Date**: 2026-07-27
**Version**: 1.0.0
**Statut**: ✅ Complet et prêt pour l'intégration

