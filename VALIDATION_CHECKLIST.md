# ✅ Checklist de Validation - Intégration API EAMAU

## 🔧 Configuration Initiale

### Avant de commencer
- [ ] Vérifier que le serveur backend est en cours d'exécution sur `http://localhost:9090`
- [ ] Vérifier la base URL dans `ApiClient.baseUrl`
- [ ] Vérifier que les dépendances sont à jour (`http`, `shared_preferences`)
- [ ] Nettoyer le cache Flutter: `flutter clean`
- [ ] Récupérer les dépendances: `flutter pub get`

## 🧪 Tests de Connectivité

### Test 1: Vérifier la connexion serveur
```bash
# Terminal
curl -i http://localhost:9090/api/v1/news

# Résultat attendu: Status 200 OK
```
- [ ] Serveur répond sur le port 9090
- [ ] Header `Content-Type: application/json` présent
- [ ] Réponse au format JSON

### Test 2: Vérifier l'authentification
```bash
# Requête de login
curl -X POST http://localhost:9090/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123"
  }'

# Résultat attendu:
# {
#   "success": true,
#   "data": {
#     "token": "eyJhbGc...",
#     "refresh_token": "..."
#   }
# }
```
- [ ] Token d'accès retourné
- [ ] Refresh token retourné
- [ ] Format JWT valide

### Test 3: Tester les requêtes authentifiées
```bash
# Remplacer TOKEN par le JWT reçu
curl -i http://localhost:9090/api/v1/profile \
  -H "Authorization: Bearer TOKEN"

# Résultat attendu: Status 200 OK
```
- [ ] Les requêtes authentifiées fonctionnent
- [ ] Le header Authorization est correctement passé

## 📱 Tests dans l'Application

### 1. AuthService

#### Test: Connexion
- [ ] Ouvrir l'écran de connexion
- [ ] Entrer des identifiants valides
- [ ] Cliquer sur "Connexion"
- [ ] Observer:
  - [ ] Indicateur de chargement s'affiche
  - [ ] Token sauvegardé dans SharedPreferences
  - [ ] Redirection vers HomeScreen
  - [ ] Pas de message d'erreur

#### Test: Connexion avec identifiants invalides
- [ ] Entrer un email inexistant
- [ ] Observer:
  - [ ] Indicateur de chargement s'affiche
  - [ ] Message d'erreur affiché: "Identifiants invalides"
  - [ ] Pas de redirection

#### Test: Déconnexion
- [ ] Être connecté
- [ ] Cliquer sur le bouton "Déconnexion" (Profil)
- [ ] Observer:
  - [ ] Token supprimé de SharedPreferences
  - [ ] Redirection vers LoginScreen
  - [ ] Les écrans protégés ne sont plus accessibles

### 2. NewsService

#### Test: Charger les actualités
- [ ] Ouvrir HomeScreen
- [ ] Observer:
  - [ ] Les actualités en avant s'affichent
  - [ ] Les images se chargent
  - [ ] Le titre et la date s'affichent correctement

#### Test: Accéder à la page complète des actualités
- [ ] Cliquer sur "Voir plus" dans la section actualités
- [ ] Observer:
  - [ ] La page des actualités se charge
  - [ ] La liste des actualités s'affiche
  - [ ] Les catégories s'affichent (si implémentées)

#### Test: Détail d'une actualité
- [ ] Cliquer sur une actualité
- [ ] Observer:
  - [ ] La page de détail se charge
  - [ ] L'image s'affiche
  - [ ] Le titre, la date et le contenu s'affichent

### 3. ConcoursService

#### Test: Charger les concours
- [ ] Ouvrir la page des concours
- [ ] Observer:
  - [ ] La liste des concours s'affiche
  - [ ] Chaque concours affiche titre et description

#### Test: Détail d'un concours
- [ ] Cliquer sur un concours
- [ ] Observer:
  - [ ] Les détails du concours s'affichent
  - [ ] Le bouton "Postuler" est disponible (si authentifié)

#### Test: Postuler à un concours
- [ ] Être connecté
- [ ] Cliquer sur "Postuler"
- [ ] Observer:
  - [ ] Indicateur de chargement
  - [ ] Message de succès: "Candidature enregistrée!"
  - [ ] Le bouton devient inactif ou change d'état

### 4. FiliereService

#### Test: Charger les filières
- [ ] Ouvrir la page des filières
- [ ] Observer:
  - [ ] La liste des filières s'affiche
  - [ ] Chaque filière affiche son titre

#### Test: Détail d'une filière
- [ ] Cliquer sur une filière
- [ ] Observer:
  - [ ] Les détails de la filière s'affichent
  - [ ] Les parcours associés s'affichent (si disponibles)

### 5. ProfileService

#### Test: Afficher le profil
- [ ] Être connecté
- [ ] Ouvrir la page du profil
- [ ] Observer:
  - [ ] Les informations utilisateur s'affichent
  - [ ] Email, nom, prénom sont correctement affichés

#### Test: Mettre à jour le profil
- [ ] Modifier un champ (ex: téléphone)
- [ ] Cliquer sur "Enregistrer"
- [ ] Observer:
  - [ ] Indicateur de chargement
  - [ ] Message de succès: "Profil mis à jour!"
  - [ ] Les données sont mises à jour localement

#### Test: Changer le mot de passe
- [ ] Cliquer sur "Changer le mot de passe"
- [ ] Entrer l'ancien mot de passe, nouveau mot de passe
- [ ] Cliquer sur "Enregistrer"
- [ ] Observer:
  - [ ] Message de succès
  - [ ] Pas d'erreur

### 6. NotificationService

#### Test: Afficher les notifications
- [ ] Être connecté
- [ ] Cliquer sur l'icône notifications
- [ ] Observer:
  - [ ] La page des notifications s'affiche
  - [ ] Un badge affiche le nombre de notifications non lues
  - [ ] Les notifications s'affichent dans une liste

#### Test: Marquer une notification comme lue
- [ ] Cliquer sur une notification
- [ ] Observer:
  - [ ] La notification est marquée comme lue
  - [ ] L'indicateur "non lu" disparaît

#### Test: Marquer tout comme lu
- [ ] Cliquer sur le bouton "Marquer tout comme lu"
- [ ] Observer:
  - [ ] Toutes les notifications sont marquées comme lues
  - [ ] Le badge de notification affiche 0

### 7. AdmissionService

#### Test: Créer une admission
- [ ] Être connecté
- [ ] Ouvrir la page des admissions
- [ ] Cliquer sur le bouton "+"
- [ ] Observer:
  - [ ] Indicateur de chargement
  - [ ] Message de succès: "Admission créée!"
  - [ ] La nouvelle admission apparaît dans la liste

#### Test: Détail d'une admission
- [ ] Cliquer sur une admission
- [ ] Observer:
  - [ ] Les détails s'affichent
  - [ ] Les documents requis s'affichent
  - [ ] Le statut de suivi s'affiche

#### Test: Télécharger un document
- [ ] Sélectionner un fichier
- [ ] Cliquer sur "Télécharger"
- [ ] Observer:
  - [ ] Le fichier se télécharge
  - [ ] Le document apparaît dans la liste

### 8. NotificationService (Push)

#### Test: Recevoir des notifications push
- [ ] L'app est ouverte
- [ ] Un événement qui génère une notification push se produit
- [ ] Observer:
  - [ ] La notification s'affiche
  - [ ] Le nombre de notifications augmente

#### Test: Cliquer sur une notification push
- [ ] Une notification push arrive
- [ ] Cliquer sur elle
- [ ] Observer:
  - [ ] L'app ouvre la page appropriée
  - [ ] La notification est marquée comme lue

## 🐛 Tests de Gestion d'Erreurs

### Test: 401 Unauthorized
- [ ] Supprimer le token de SharedPreferences (DevTools)
- [ ] Essayer d'accéder à une page protégée
- [ ] Observer:
  - [ ] Redirection automatique vers LoginScreen
  - [ ] Message d'erreur: "Veuillez vous connecter"

### Test: 404 Not Found
- [ ] Essayer d'accéder à une ressource inexistante
- [ ] Observer:
  - [ ] Message d'erreur: "Ressource non trouvée"
  - [ ] Pas de crash de l'app

### Test: 422 Validation Error
- [ ] Lors de la création d'une ressource, envoyer des données invalides
- [ ] Observer:
  - [ ] Message d'erreur spécifique reçu du serveur
  - [ ] Les champs en erreur sont identifiés

### Test: Network Error
- [ ] Arrêter le serveur backend
- [ ] Essayer de charger une page
- [ ] Observer:
  - [ ] Message d'erreur réseau
  - [ ] Bouton "Réessayer" disponible
  - [ ] Pas de crash

### Test: Timeout
- [ ] Modifier ApiClient pour avoir un timeout court
- [ ] Faire une requête
- [ ] Observer:
  - [ ] Après le timeout, message d'erreur
  - [ ] L'app ne freeze pas

## 🔄 Tests de Synchronisation

### Test: Rafraîchir les données
- [ ] Pull-to-refresh sur une liste
- [ ] Observer:
  - [ ] Indicateur de refresh s'affiche
  - [ ] Les données se rechargent
  - [ ] L'indicateur disparaît

### Test: Pagination
- [ ] Charger une liste paginée
- [ ] Scroller jusqu'au bas
- [ ] Observer:
  - [ ] La page suivante se charge automatiquement
  - [ ] Les éléments s'ajoutent à la liste

## 🔐 Tests de Sécurité

### Test: Token JWT
- [ ] Copier le token depuis SharedPreferences
- [ ] Décoder le token (jwt.io)
- [ ] Observer:
  - [ ] Le payload est lisible
  - [ ] Le token n'est pas vide
  - [ ] L'expiration n'est pas passée

### Test: Données sensibles
- [ ] Les mots de passe ne sont jamais affichés en clair
- [ ] Les tokens ne sont pas loggés en production
- [ ] Les données sensibles ne sont pas cachées dans un screenshot

## 📊 Tests de Performance

### Test: Temps de chargement
- [ ] Mesurer le temps pour charger une page
- [ ] Observer:
  - [ ] Moins de 3 secondes pour les pages principales
  - [ ] Moins de 1 seconde pour les pages en cache

### Test: Consommation de ressources
- [ ] Monitor la consommation RAM
- [ ] Observer:
  - [ ] Pas de fuites mémoire
  - [ ] La RAM se libère après la fermeture de l'écran

### Test: Batterie
- [ ] Utiliser l'app pendant 1 heure
- [ ] Observer:
  - [ ] La consommation est raisonnable
  - [ ] Les requêtes réseau ne sont pas excessives

## 📝 Logs et Debugging

### Ajouter du logging
```dart
// Dans ApiClient
if (kDebugMode) {
  print('🔵 API Request: $method $endpoint');
  print('Headers: $headers');
  print('Body: $body');
  print('🟢 API Response: ${response.statusCode}');
  print('Body: ${response.body}');
}
```

### Vérifier les logs
- [ ] Les requêtes s'affichent correctement
- [ ] Les réponses s'affichent correctement
- [ ] Les erreurs sont loggées

## ✅ Checklist Finale

- [ ] Tous les tests de connectivité passent
- [ ] Tous les services fonctionnent
- [ ] Tous les écrans s'affichent correctement
- [ ] La gestion des erreurs fonctionne
- [ ] Les performances sont acceptables
- [ ] La sécurité est garantie
- [ ] Les tests manuels passent
- [ ] L'app est prête pour la production

---

**Date de validation**: ___________
**Validé par**: ___________
**Notes**: ___________


