# 📋 Mapping Endpoints API <-> Services

## Authentification (`/auth`)

| Endpoint | Méthode | Service | Fonction | Requiert Auth |
|----------|---------|---------|----------|---------------|
| `/auth/login` | POST | AuthService | `login()` | ❌ |
| `/auth/logout` | POST | AuthService | `logout()` | ✅ |
| `/auth/me` | GET | AuthService | `getCurrentUser()` | ✅ |
| `/auth/refresh` | POST | AuthService | `refreshToken()` | ❌ |
| `/auth/2fa/check` | POST | AuthService | `verify2FA()` | ❌ |
| `/auth/2fa/resend` | POST | AuthService | `resend2FA()` | ❌ |
| `/auth/forgot-password` | POST | AuthService | `forgotPassword()` | ❌ |
| `/auth/reset-password` | POST | AuthService | `resetPassword()` | ❌ |
| `/auth/google` | GET | AuthService | `getGoogleOAuthUrl()` | ❌ |
| `/auth/google/callback` | GET | AuthService | - | ❌ |
| `/auth/facebook` | GET | AuthService | `getFacebookOAuthUrl()` | ❌ |
| `/auth/facebook/callback` | GET | AuthService | - | ❌ |
| `/auth/register` | POST | RegisterService | `register()` | ❌ |
| `/auth/check-email` | POST | RegisterService | `checkEmailExists()` | ❌ |
| `/auth/check-phone` | POST | RegisterService | `checkPhoneExists()` | ❌ |
| `/auth/confirm-email` | POST | RegisterService | `confirmEmail()` | ❌ |
| `/auth/resend-confirmation` | POST | RegisterService | `resendConfirmationEmail()` | ❌ |

## Actualités (`/news`)

| Endpoint | Méthode | Service | Fonction | Requiert Auth |
|----------|---------|---------|----------|---------------|
| `/news` | GET | NewsService | `getNews()` | ❌ |
| `/news/categories` | GET | NewsService | `getCategories()` | ❌ |
| `/news/featured` | GET | NewsService | `getFeaturedNews()` | ❌ |
| `/news/search` | GET | NewsService | `searchNews()` | ❌ |
| `/news/{slug}` | GET | NewsService | `getNewsBySlug()` | ❌ |

## Concours (`/concours`)

| Endpoint | Méthode | Service | Fonction | Requiert Auth |
|----------|---------|---------|----------|---------------|
| `/concours` | GET | ConcoursService | `getConcours()` | ❌ |
| `/concours/search` | GET | ConcoursService | `searchConcours()` | ❌ |
| `/concours/{slug}` | GET | ConcoursService | `getConcoursDetail()` | ❌ |
| `/concours/{id}/postulation` | POST | ConcoursService | `applyToConcours()` | ✅ |

## Filières (`/filieres` et `/parcours`)

| Endpoint | Méthode | Service | Fonction | Requiert Auth |
|----------|---------|---------|----------|---------------|
| `/filieres` | GET | FiliereService | `getFilieres()` | ❌ |
| `/filieres/search` | GET | FiliereService | `searchFilieres()` | ❌ |
| `/filieres/{slug}` | GET | FiliereService | `getFiliereDetail()` | ❌ |
| `/filieres/{slug}/parcours` | GET | FiliereService | `getFilieureParcours()` | ❌ |
| `/parcours` | GET | FiliereService | `getParcours()` | ❌ |

## Admission

| Endpoint | Méthode | Service | Fonction | Requiert Auth |
|----------|---------|---------|----------|---------------|
| `/admission-conditions` | GET | AdmissionService | `getAdmissionConditions()` | ❌ |
| `/admission-levels` | GET | AdmissionService | `getAdmissionLevels()` | ❌ |
| `/admissions` | GET | AdmissionService | `getAdmissions()` | ✅ |
| `/admissions` | POST | AdmissionService | `createAdmission()` | ✅ |
| `/admissions/statistics` | GET | AdmissionService | `getAdmissionsStatistics()` | ✅ |
| `/admissions/{uuid}` | GET | AdmissionService | `getAdmissionDetail()` | ✅ |
| `/admissions/{uuid}` | PUT | AdmissionService | `updateAdmission()` | ✅ |
| `/admissions/{uuid}` | DELETE | AdmissionService | `deleteAdmission()` | ✅ |
| `/admissions/{uuid}/history` | GET | AdmissionService | `getAdmissionHistory()` | ✅ |
| `/admissions/{uuid}/tracking` | GET | AdmissionService | `getAdmissionTracking()` | ✅ |
| `/admissions/{uuid}/documents` | GET | AdmissionService | `getAdmissionDocuments()` | ✅ |
| `/admissions/{uuid}/documents` | POST | AdmissionService | `addAdmissionDocument()` | ✅ |
| `/admissions/{uuid}/documents/{documentUuid}` | DELETE | AdmissionService | `deleteAdmissionDocument()` | ✅ |
| `/admissions/{uuid}/documents/{documentUuid}` | GET | AdmissionService | - | ✅ |
| `/admissions/{uuid}/submit` | POST | AdmissionService | `submitAdmission()` | ✅ |

## Inscriptions

| Endpoint | Méthode | Service | Fonction | Requiert Auth |
|----------|---------|---------|----------|---------------|
| `/inscriptions` | GET | InscriptionService | `getInscriptions()` | ✅ |
| `/inscriptions` | POST | InscriptionService | `createInscription()` | ✅ |
| `/inscriptions/pieces` | GET | InscriptionService | `getRequiredDocuments()` | ✅ |
| `/inscriptions/{id}` | GET | InscriptionService | `getInscriptionDetail()` | ✅ |
| `/inscriptions/{id}` | PUT | InscriptionService | `updateInscription()` | ✅ |
| `/inscriptions/{id}/documents` | POST | InscriptionService | `uploadDocument()` | ✅ |
| `/inscriptions/{id}/documents/{documentId}` | DELETE | InscriptionService | `deleteDocument()` | ✅ |
| `/inscriptions/{id}/download` | GET | InscriptionService | `downloadInscriptionSheet()` | ✅ |
| `/inscriptions/{id}/history` | GET | InscriptionService | `getInscriptionHistory()` | ✅ |
| `/inscriptions/{id}/submit` | POST | InscriptionService | `submitInscription()` | ✅ |
| `/inscriptions/{id}/tracking` | GET | InscriptionService | `getInscriptionTracking()` | ✅ |

## Postulations

| Endpoint | Méthode | Service | Fonction | Requiert Auth |
|----------|---------|---------|----------|---------------|
| `/postulations/{reference}` | GET | PostulationService | `getPostulationDetail()` | ✅ |
| `/postulations/{id}/documents` | POST | PostulationService | `uploadDocument()` | ✅ |
| `/postulations/{id}/documents/{documentId}` | DELETE | PostulationService | `deleteDocument()` | ✅ |
| `/postulations/{id}/submit` | POST | PostulationService | `submitPostulation()` | ✅ |
| `/postulations/{reference}/attestation` | GET | PostulationService | `getAttestation()` | ✅ |
| `/postulations/{reference}/history` | GET | PostulationService | `getHistory()` | ✅ |
| `/postulations/{reference}/tracking` | GET | PostulationService | `getTracking()` | ✅ |

## Profil

| Endpoint | Méthode | Service | Fonction | Requiert Auth |
|----------|---------|---------|----------|---------------|
| `/profile` | GET | ProfileService | `getProfile()` | ✅ |
| `/profile` | PUT | ProfileService | `updateProfile()` | ✅ |
| `/profile/academic` | GET | ProfileService | `getAcademicInfo()` | ✅ |
| `/profile/password` | PUT | ProfileService | `updatePassword()` | ✅ |
| `/profile/photo` | POST | ProfileService | `uploadProfilePhoto()` | ✅ |
| `/profile/photo` | DELETE | ProfileService | `deleteProfilePhoto()` | ✅ |

## Notifications

| Endpoint | Méthode | Service | Fonction | Requiert Auth |
|----------|---------|---------|----------|---------------|
| `/notifications` | GET | NotificationService | `getNotifications()` | ✅ |
| `/notifications/latest` | GET | NotificationService | `getLatestNotifications()` | ✅ |
| `/notifications/unread-count` | GET | NotificationService | `getUnreadCount()` | ✅ |
| `/notifications/{id}` | GET | NotificationService | `getNotification()` | ✅ |
| `/notifications/{id}` | DELETE | NotificationService | `deleteNotification()` | ✅ |
| `/notifications/{id}/read` | POST | NotificationService | `markAsRead()` | ✅ |
| `/notifications/read-all` | POST | NotificationService | `markAllAsRead()` | ✅ |
| `/notifications/preferences` | GET | NotificationService | `getPreferences()` | ✅ |
| `/notifications/preferences` | PUT | NotificationService | `updatePreferences()` | ✅ |

## Notifications Push

| Endpoint | Méthode | Service | Fonction | Requiert Auth |
|----------|---------|---------|----------|---------------|
| `/push/notifications` | GET | NotificationService | `getPushNotifications()` | ✅ |
| `/push/notifications/unread-count` | GET | NotificationService | `getPushUnreadCount()` | ✅ |
| `/push/notifications/{id}` | GET | NotificationService | `getPushNotification()` | ✅ |
| `/push/notifications/{id}` | DELETE | NotificationService | `deletePushNotification()` | ✅ |
| `/push/notifications/{id}/read` | POST | NotificationService | `markPushAsRead()` | ✅ |
| `/push/notifications/read-all` | POST | NotificationService | `markAllPushAsRead()` | ✅ |

## Publications

| Endpoint | Méthode | Service | Fonction | Requiert Auth |
|----------|---------|---------|----------|---------------|
| `/publications` | GET | PublicationService | `getPublications()` | ✅ |
| `/publications` | POST | PublicationService | `createPublication()` | ✅ |
| `/publications/authors` | GET | PublicationService | `getAuthors()` | ✅ |
| `/publications/categories` | GET | PublicationService | `getCategories()` | ✅ |
| `/publications/favorites` | GET | PublicationService | `getFavorites()` | ✅ |
| `/publications/search` | POST | PublicationService | `searchPublications()` | ✅ |
| `/publications/types` | GET | PublicationService | `getTypes()` | ✅ |
| `/publications/{slug}` | GET | PublicationService | `getPublicationBySlug()` | ✅ |
| `/publications/{id}` | PATCH | PublicationService | `updatePublication()` | ✅ |
| `/publications/{id}/favorite` | POST | PublicationService | `addToFavorites()` | ✅ |
| `/publications/{id}/favorite` | DELETE | PublicationService | `removeFromFavorites()` | ✅ |
| `/publications/{id}/download` | POST | PublicationService | `downloadPublication()` | ✅ |
| `/publications/{id}/download/file/{fileId}` | GET | PublicationService | `downloadFile()` | ✅ |
| `/publications/{id}/history` | GET | PublicationService | `getHistory()` | ✅ |
| `/publications/{id}/view` | POST | PublicationService | `recordView()` | ✅ |

## Devices

| Endpoint | Méthode | Service | Fonction | Requiert Auth |
|----------|---------|---------|----------|---------------|
| `/devices` | GET | DeviceService | `getDevices()` | ✅ |
| `/devices/register` | POST | DeviceService | `registerDevice()` | ✅ |
| `/devices/{id}` | PUT | DeviceService | `updateDevice()` | ✅ |
| `/devices/{id}` | DELETE | DeviceService | `deleteDevice()` | ✅ |

## Contact

| Endpoint | Méthode | Service | Fonction | Requiert Auth |
|----------|---------|---------|----------|---------------|
| `/contact` | POST | ContactService | `sendContactMessage()` | ❌ |
| `/contact/authenticated` | POST | ContactService | `sendAuthenticatedMessage()` | ✅ |

## Résumé par Service

### 🔐 AuthService (12 endpoints)
- Gère toute l'authentification utilisateur
- Inclut 2FA, OAuth, refresh token
- Tous les endpoints sauf `/register`, `/check-email`, `/check-phone`, `/confirm-email`, `/resend-confirmation`

### 📝 RegisterService (5 endpoints)
- Enregistrement de nouveaux utilisateurs
- Vérification d'email/téléphone
- Confirmation d'email

### 📰 NewsService (5 endpoints)
- Actualités, catégories, recherche
- Pas d'authentification requise

### 🎓 ConcoursService (4 endpoints)
- Listing et détails des concours
- Candidature aux concours (authentifié)

### 🏫 FiliereService (5 endpoints)
- Listing, recherche, détails des filières
- Parcours et informations académiques

### 📊 AdmissionService (15 endpoints)
- Gestion complète des demandes d'admission
- Documents, historique, suivi, soumission

### 📋 InscriptionService (11 endpoints)
- Gestion des demandes d'inscription
- Documents, historique, suivi

### 📄 PostulationService (7 endpoints)
- Gestion des postulations
- Attestation, historique, suivi

### 👤 ProfileService (6 endpoints)
- Profil utilisateur et informations académiques
- Photo de profil, changement mot de passe

### 🔔 NotificationService (9 endpoints + 6 pour push)
- Notifications générales et push
- Préférences, marquage comme lu

### 📚 PublicationService (15 endpoints)
- Listing, recherche, création, modification
- Téléchargement, favoris, historique

### 💾 DeviceService (4 endpoints)
- Enregistrement et gestion des appareils
- Pour les notifications push

### 📧 ContactService (2 endpoints)
- Envoi de messages de contact
- Public et authentifié

## Totaux
- **Total d'endpoints**: 99
- **Endpoints protégés (JWT)**: 67
- **Endpoints publics**: 32
- **Services créés**: 12
- **Exceptions personnalisées**: 5

---

**Note**: Tous les endpoints sont disponibles à partir de `http://localhost:9090/api/v1`

