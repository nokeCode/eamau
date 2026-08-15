# EAMAU Flutter Project - Architecture Analysis

**Project Type:** Flutter Mobile Application
**Language:** Dart
**Architecture Pattern:** Clean Architecture with MVVM (Model-View-ViewModel)
**State Management:** Provider Pattern
**HTTP Client:** Dio + HTTP package

---

## 1. CURRENT ARCHITECTURE & PATTERNS

### Overall Structure
```
lib/
├── core/              # Core infrastructure (API, Storage, Exceptions)
├── models/            # Data models and DTOs
├── services/          # Business logic & API communication
├── providers/         # State management (ChangeNotifier)
├── routes/            # Navigation & routing
├── screens/           # UI Pages
├── widgets/           # Reusable UI components
├── utils/             # Utility functions
└── constants/         # App constants
```

### Key Architectural Patterns

1. **Service Layer Pattern**: Each feature has dedicated services (NewsService, FilierEService, AuthService)
2. **Provider Pattern**: Services exposed through ChangeNotifier providers for state management
3. **Singleton Pattern**: DioClient and TokenStorage use singleton pattern for centralized management
4. **Repository Pattern (Implicit)**: Services act as repositories abstracting API calls
5. **JWT + Refresh Token**: Token-based authentication with automatic refresh mechanism
6. **Interceptor Chain**: Dio interceptors handle auth, error handling, and logging

---

## 2. SERVICE LAYER IMPLEMENTATION

### Services Directory Structure
```
services/
├── admission/              # Admission request & tracking
├── auth/                   # Authentication & authorization
├── concours/              # Competitions/Exams
├── contact/               # Contact management
├── evaluation/            # Evaluation services
├── filiere/              # Study programs
├── home/                 # Home/Dashboard
├── news/                 # News & publications
├── notification/         # Notifications
├── profile/              # User profile
├── publication/          # Publications
├── register/             # Registration
├── registration/         # Detailed registration
├── student/              # Student dashboard
└── user/                 # User management
```

### Main Services (5-10 Examples)

#### 1. **AuthService** [lib/services/auth/auth_service.dart]
- **Responsibilities:** User authentication, 2FA, password reset, token management
- **Key Methods:**
  - `login(email, password)` → LoginResponse
  - `verify2FA(email, code)` → Verify2FAResponse
  - `resend2FA(email)` → void
  - `requestPasswordReset(email)` → void
  - `resetPassword(token, password)` → void
  - `register(email, firstName, lastName, phone)` → AuthResponse
  - `getCurrentUser()` → User
  - `logout()` → void
  - `isLoggedIn()` → bool
  - `deleteTokens()` → void
- **Pattern:** Uses DioClient for HTTP calls, caches dependencies via getters
- **Exception Handling:** Throws DioException wrapped in custom API exceptions
- **Dependencies:** DioClient, TokenStorage, FirebaseAuthService

#### 2. **NewsService** [lib/services/news/news_service.dart]
- **Responsibilities:** Fetch news, paginate, search, and manage news categories
- **Key Methods:**
  - `getNewsPage(page, limit, categoryId)` → NewsPageResult
  - `searchNews(query, page, limit)` → NewsPageResult
  - `getFeaturedNews()` → List<NewsModel>
  - `getNewsByCategory(categoryId)` → List<NewsModel>
  - `getNewsDetail(slug)` → NewsModel
- **Pattern:** Uses plain http.Client (injectable for testing), URL building utilities
- **Response Structure:** `{data: [...], meta: {page, perPage, total, lastPage}}`
- **Error Handling:** Custom exception messages from API

#### 3. **FiliereService** [lib/services/filiere/filiere_service.dart]
- **Responsibilities:** Manage study programs/streams (Filieres)
- **Key Methods:**
  - `getFilieresPage(page, perPage, query)` → FilierePageResult
  - `getFiliereBySlug(slug)` → Filiere
- **Pattern:** Handles flexible JSON responses (data as List or Map)
- **Dependencies:** http.Client
- **Data Model:** Includes Filiere with nested Parcours list

#### 4. **AdmissionRequestService** [lib/services/admission/admission_request_service.dart]
- **Responsibilities:** Manage admission request form, submission, and PDF export
- **Key Methods:**
  - `getAdmissionForm()` → Map<String, dynamic>
  - `getCampaignDetail(campaignId)` → AdmissionCampaignDetailModel
  - `submitAdmissionRequest(requestModel, documents)` → AdmissionRequestSubmitResponseModel
  - `getAdmissionRequestStatus()` → AdmissionRequestSummaryModel
  - `exportToPDF()` → File
- **Pattern:** Built on http.Client with custom headers & token handling
- **Timeout Handling:** 30-second timeout with custom error messages
- **File Support:** Handles multipart form data for document uploads
- **Fallback Data:** Includes fallback form for API failures

#### 5. **NotificationService** [lib/services/notification/notification_service.dart]
- **Responsibilities:** Fetch, manage, and track notifications
- **Key Methods:**
  - `getNotifications(page, limit)` → List<NotificationModel>
  - `markAsRead(notificationId)` → bool
  - `markAllAsRead()` → bool
  - `getPreferences()` → Map<String, dynamic>
  - `updatePreferences(preferences)` → Map<String, dynamic>
  - `registerDevice(token, platform)` → bool
- **Pattern:** Uses DioClient with flexible response parsing
- **Fallback Notifications:** Includes mock notification data
- **Device Registration:** Registers FCM tokens with backend

#### 6. **PublicationService** [lib/services/publication/publication_service.dart]
- **Responsibilities:** Manage publications (similar to news but separate)
- **Key Methods:**
  - `getPublicationsPage(page, limit, categoryId, featured)` → PublicationPageResult
  - `searchPublications(query, page, limit)` → PublicationPageResult
- **Pattern:** URL building, query parameter handling
- **Debugging:** Includes console logging for API calls
- **Dependencies:** http.Client, TokenStorage

#### 7. **DashboardService** [lib/services/student/dashboard_service.dart]
- **Responsibilities:** Fetch student dashboard data
- **Key Methods:**
  - `getDashboard()` → DashboardModel
- **Pattern:** Simple wrapper around http.get with JSON parsing
- **Fallback:** Comprehensive fallback dashboard with mock data
- **Response:** Dashboard with quick stats, menu items, and notifications

#### 8. **ConcoursService** [lib/services/concours/concours_service.dart]
- **Responsibilities:** Manage exams/competitions
- **Key Methods:**
  - `getConcours(page, limit, query)` → List<ConcoursModel>
- **Pattern:** Simple list fetch with pagination and search support
- **Dependencies:** http.Client

#### 9. **RegistrationService** [lib/services/registration/registration_service.dart]
- **Responsibilities:** Handle user registration workflow
- **Key Methods:**
  - `getReferentials()` → RegistrationReferentialCollection
  - `submitRegistration(draft, documents)` → bool
  - `getRegistrationStatus()` → RegistrationStatus
  - `_createRegistration(draft)` → _RegistrationCreationResult
  - `_uploadDocument(registrationId, document)` → bool
  - `_finalizeRegistration(registrationId)` → bool
- **Pattern:** Multi-step workflow with fallback document types
- **Dependencies:** DioClient
- **Complex Handling:** Nested response parsing with multiple possible key names

#### 10. **UserSessionService** [lib/services/auth/user_session_service.dart]
- **Responsibilities:** Manage user session state in-memory
- **Key Methods:**
  - `updateSession(user, profile)` → void
  - `clearSession()` → void
  - Properties: `isStudent`, `isUser`, `profileRouteName`
- **Pattern:** In-memory session cache (non-persistent)
- **Profile Normalization:** Normalizes profile to uppercase (STUDENT, USER)

### Service Patterns & Conventions

1. **Dependency Injection:** Services accept dependencies via constructor (http.Client, TokenStorage)
2. **Error Handling:** Custom messages from API, wrapped in Exceptions
3. **Response Parsing:** Flexible JSON parsing with fallback values
4. **Token Management:** Auto-injected via interceptors, not handled per-service
5. **Timeout Handling:** Default 30-60 second timeouts
6. **Fallback Data:** Mock/default data for UI preview and error states

---

## 3. PROVIDER PATTERN USAGE

### Providers Directory
```
providers/
├── admission_provider.dart              # (Empty - placeholder)
├── admission_tracking_provider.dart     # Track admission progress
├── auth_provider.dart                   # Authentication state
├── notification_provider.dart           # Notifications management
├── registration/
│   └── registration_provider.dart       # Registration workflow
└── student/
    └── dashboard_provider.dart          # Student dashboard
```

### Main Providers (3-5 Examples)

#### 1. **AuthProvider** [lib/providers/auth_provider.dart]
- **Extends:** ChangeNotifier
- **State Variables:**
  - `_isLoading: bool` - Loading state
  - `_isLoggedIn: bool` - Authentication status
  - `_error: String?` - Error message
  - `_pending2FAEmail: String?` - 2FA pending email
- **Public Getters:**
  - `isLoading`, `isLoggedIn`, `user`, `currentProfile`, `isStudent`, `isUser`
  - `profileRouteName`, `error`, `pending2FA`, `pending2FAEmail`
- **Key Methods:**
  - `_checkLoginStatus()` - Verify login on app start
  - `bootstrapSession()` - Initialize session
  - `refreshSessionFromBackend()` - Sync user data
  - `login(email, password)` → void
  - `verify2FA(email, code)` → void
  - `logout()` → void
  - `requestPasswordReset(email)` → void
  - `resetPassword(token, password)` → void
  - `register(email, firstName, lastName, phone)` → void
  - `_registerDeviceTokenAfterLogin()` - FCM registration
- **Initialization:** Auto-checks login status, subscribes to FCM token refresh
- **Dependencies:** AuthService, UserSessionService, FirebaseMessaging
- **Special Features:** 
  - Automatic session validation on app startup
  - 2FA workflow support
  - Device token registration
  - Static error formatting utility

#### 2. **NotificationProvider** [lib/providers/notification_provider.dart]
- **Extends:** ChangeNotifier
- **State Variables:**
  - `_notifications: List<NotificationModel>`
  - `_isLoading: bool`
  - `_showUnreadOnly: bool` - Filter toggle
- **Public Getters:**
  - `notifications` - Filtered list based on showUnreadOnly
  - `isLoading`, `showUnreadOnly`, `unreadCount`
  - `todayNotifications` - Today's notifications
  - `weekNotifications` - This week's notifications
  - `olderNotifications` - Older than this week
- **Key Methods:**
  - `loadNotifications()` - Fetch and sort by newest first
  - `refresh()` - Reload notifications
  - `markAsRead(id)` - Mark single notification
  - `markAllAsRead()` - Mark all as read
  - `showAll()` / `showUnread()` - Toggle filtering
- **Dependencies:** NotificationService
- **Notification Organization:** Auto-categorizes by date (today, week, older)

#### 3. **DashboardProvider** [lib/providers/student/dashboard_provider.dart]
- **Extends:** ChangeNotifier
- **State Variables:**
  - `_dashboard: DashboardModel?`
  - `_isLoading: bool`
  - `_error: String?`
- **Public Getters:** `dashboard`, `isLoading`, `error`
- **Key Methods:**
  - `loadDashboard()` - Fetch student dashboard
  - `refresh()` - Reload dashboard
- **Dependencies:** DashboardService
- **Pattern:** Simple load/error/display state management

#### 4. **AdmissionTrackingProvider** [lib/providers/admission_tracking_provider.dart]
- **Extends:** ChangeNotifier
- **State Variables:**
  - `_tracking: AdmissionTrackingModel?`
  - `_loading: bool`
  - `_refreshing: bool` - Pull-to-refresh state
  - `_error: String?`
- **Public Getters:** `tracking`, `loading`, `refreshing`, `error`
- **Key Methods:**
  - `loadTracking(requestId, uuid)` - Fetch tracking info
  - `refreshTracking(requestId, uuid)` - Refresh tracking
  - `cancelAdmission()` - Cancel admission request
  - `clear()` - Reset state
- **Dependencies:** AdmissionTrackingService
- **Features:** Supports refresh while maintaining loading state

#### 5. **RegistrationProvider** [lib/providers/registration/registration_provider.dart]
- **Extends:** ChangeNotifier
- **State Variables:**
  - `status: RegistrationFlowStatus` - Enum: idle, loading, submitting, success, error
  - `message: String?` - Status message
  - `referentials: RegistrationReferentialCollection?` - Form options (filieres, grades, etc)
  - `registrationStatus: RegistrationStatus?` - Current registration state
  - `draft: RegistrationDraft` - Form data
  - `documents: List<RegistrationDocument>` - Attached documents
  - `currentStep: int` - Multi-step form tracking
- **Key Methods:**
  - `loadReferentials()` - Fetch form options
  - `loadRegistrationStatus()` - Check registration state
  - `updateDraft(newDraft)` / `updateField(field, value)` - Update form
  - `addDocument(document)` - Add file
  - `removeDocument(index)` - Remove file
  - `nextStep()` / `previousStep()` - Navigate steps
  - `submitRegistration()` - Submit form
- **Dependencies:** RegistrationService, ProfileService, FilePicker
- **Features:** 
  - Multi-step form workflow
  - Draft persistence
  - Document management
  - Auto-fills from user profile

### Provider Patterns & Conventions

1. **Initialization:** Providers use lazy initialization pattern (getters caching dependencies)
2. **State Management:** Simple flag-based state (isLoading, error, success)
3. **Notifications:** Always call `notifyListeners()` after state changes
4. **Auto-loading:** Some providers auto-load on instantiation (AuthProvider)
5. **Device Integration:** AuthProvider handles FCM token management
6. **Error Display:** Direct error string storage for UI display
7. **Filtering/Grouping:** NotificationProvider groups notifications by date

---

## 4. DATA MODELS STRUCTURE

### Models Directory
```
models/
├── admission/
│   ├── admission_campaign_detail_model.dart
│   ├── admission_request_model.dart
│   ├── admission_request_response_model.dart
│   ├── admission_request_submit_response_model.dart
│   ├── admission_request_summary_model.dart
│   ├── admission_tracking_model.dart
│   └── suivi_candidature_model.dart
├── auth/
│   ├── auth_response.dart
│   ├── login_response.dart
│   ├── register_request.dart
│   ├── user.dart
│   └── verify_2fa_response.dart
├── concours/
│   └── concours_model.dart
├── contact/
│   └── contact_model.dart
├── evaluation/
│   └── evaluation_model.dart
├── filiere/
│   ├── filiere_model.dart
│   └── (Parcours nested in Filiere)
├── home/
├── news/
│   ├── news_category_model.dart
│   └── news_model.dart
├── notification/
│   └── notification_model.dart
├── profile/
│   └── user_model.dart
├── register/
├── registration/
│   ├── registration_document.dart
│   ├── registration_draft.dart
│   ├── registration_option.dart
│   ├── registration_referential_model.dart
│   └── registration_status_model.dart
├── student/
│   ├── dashboard_model.dart
│   ├── dashboard_notification_model.dart
│   ├── menu_item_model.dart
│   └── quick_stat_model.dart
└── user/
    └── user_profile_model.dart
```

### Key Models (Main Examples)

#### 1. **User** [lib/models/auth/user.dart]
```dart
class User {
  final int id;
  final String? uuid;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? avatar;
  final String? role;
  final String? profile;  // STUDENT or USER
  final DateTime? createdAt;
  final DateTime? updatedAt;
  
  // Computed properties
  String get fullName
  int get profileCompletionPercentage
  double get profileCompletionRatio
}
```
- **Factory Constructor:** Handles multiple API variations (role/roles, profile normalization)
- **UUID Variants:** Accepts 'uuid', 'user_uuid', or 'id'
- **Profile Normalization:** Converts to uppercase (STUDENT, USER)

#### 2. **NewsModel** [lib/models/news/news_model.dart]
```dart
class NewsModel {
  final int id;
  final String title;
  final String summary;
  final String slug;
  final String image;
  final String publishedAt;
  final String? content;
  final String? video;
  final bool featured;
  final NewsCategoryModel? category;
  final String type;
  final String categoryName;
}

class NewsMeta {
  final int page;
  final int perPage;
  final int total;
  final int lastPage;
}
```
- **Type Handling:** Extracts from nested Map or string
- **Category:** Handles both nested object and string
- **Meta:** Flexible key names (page/currentPage, perPage/limit, etc)

#### 3. **Filiere** [lib/models/filiere/filiere_model.dart]
```dart
class Filiere {
  final int id;
  final String nom;
  final String slug;
  final String niveau;
  final String description;
  final String presentation;
  final String image;
  final int parcoursCount;
  final List<String> images;
  final List<Parcours> parcours;  // Nested array
  final String? diplomes;
  final String? duree;
  final String? debouches;
}

class Parcours {
  final int id;
  final String nom;
  final String description;
  final String image;
  final String details;
}
```
- **Nested Objects:** Includes Parcours list with full details
- **Flexible Keys:** Handles 'name'/'nom', 'slug', various image key names
- **Metadata:** Includes diploma info, duration, job prospects

#### 4. **AdmissionRequestModel** [lib/models/admission/admission_request_model.dart]
```dart
class AdmissionRequestModel {
  final int? id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final DateTime? birthDate;
  final String nationality;
  final String profession;
  final String address;
  final String universityOrigin;
  final String currentLevel;
  final String requestedLevel;
  final String currentField;
  final String requestedField;
  final Map<String, File?> documents;  // File attachments
}
```
- **File Support:** Documents stored as Map<String, File?>
- **Serialization:** toJson() for API submission
- **Date Format:** YYYY-MM-DD format for birth date

#### 5. **NotificationModel** [lib/models/notification/notification_model.dart]
```dart
class NotificationModel {
  final int id;
  final String title;
  final String message;
  final String icon;  // Normalized icon type
  final bool isRead;
  final DateTime createdAt;
}
```
- **Icon Normalization:** Converts type strings to standard icon names
- **Field Flexibility:** Accepts title/body variations, multiple timestamp keys
- **Copyswith:** Supports immutable updates with copyWith()
- **Fallback Notifications:** Includes mock data for testing

#### 6. **DashboardModel** [lib/models/student/dashboard_model.dart]
```dart
class DashboardModel {
  final String firstName;
  final String matricule;
  final List<QuickStatModel> quickStats;
  final List<MenuItemModel> menu;
  final List<DashboardNotificationModel> notifications;
}
```
- **Composite Structure:** Dashboard has stats, menu items, and notifications
- **Route Support:** Menu items include route information

#### 7. **RegistrationDraft** [lib/models/registration/registration_draft.dart]
```dart
class RegistrationDraft {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String matricule;
  final String? schoolYear;
  final String? filiere;
  final String? niveau;
  final String? grade;
  final String? groupe;
  final String? semester;
  // ... more fields
}
```
- **Multi-step Form:** Fields for complex registration workflow
- **Copywith Pattern:** Immutable updates
- **toJson():** API submission
- **Validation:** Optional field support for step-by-step filling

### Model Conventions

1. **Factory Constructors:** All models use `factory Model.fromJson(Map<String, dynamic> json)`
2. **Flexible Keys:** Handle multiple API variations (snake_case, camelCase)
3. **Type Safety:** Defensive parsing with fallbacks and type checking
4. **Serialization:** toJson() for API requests where needed
5. **Immutability:** Const constructors where possible, copyWith() for updates
6. **Nested Models:** Support composition (e.g., Filiere contains Parcours)
7. **Null Safety:** Optional fields marked with ? and defaulting to null

---

## 5. HTTP/DIO SETUP & INTERCEPTORS

### Core HTTP Configuration

#### **DioClient** [lib/core/api/dio_client.dart]

**Architecture:**
- Singleton pattern with `_instance` static variable
- Factory constructor returning same instance
- Lazy initialization in `_internal()` constructor

**Dio Configuration:**
```dart
BaseOptions(
  baseUrl: ApiEndpoints.baseUrl,
  connectTimeout: Duration(seconds: 60),
  receiveTimeout: Duration(seconds: 60),
  sendTimeout: Duration(seconds: 60),
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  },
  validateStatus: (status) => status >= 200 && status < 300,
)
```

**Interceptor Chain:**
1. `_AuthInterceptor` - Handles JWT tokens
2. `_ErrorInterceptor` - Standardizes error responses
3. `_LoggingInterceptor` - Debug logging

#### **AuthInterceptor** [Detailed Analysis]

**Responsibilities:**
- Injects access token into every authenticated request
- Handles 401 Unauthorized responses
- Implements token refresh mechanism
- Queues pending requests during refresh

**On Request:**
```dart
if (options.extra['skipAuth'] == true) {
  return handler.next(options);  // Skip auth for login/register
}

final accessToken = await secureStorage.read(key: 'access_token');
if (accessToken != null && accessToken.isNotEmpty) {
  options.headers['Authorization'] = 'Bearer $accessToken';  // Bearer token
}
```

**On 401 Error:**
- Checks if already refreshing (queue mechanism)
- Calls `/auth/refresh` with refresh token
- Extracts new tokens from response (multiple key variations)
- Saves tokens to secure storage
- Retries original request with new token
- If refresh fails, clears all tokens and logs user out

**Token Refresh Endpoint:**
```dart
POST /auth/refresh
Body: { "refresh_token": "<token>" }
Response: {
  "data": {
    "access_token": "...",
    "refresh_token": "...",
    "token": "..."  // Alternative key
  }
}
```

#### **ErrorInterceptor**
- Catches all errors and normalizes response format
- Throws appropriate API exceptions (UnauthorizedException, ServerException, etc.)
- Extracts error messages from response body

#### **LoggingInterceptor**
- Logs request/response for debugging
- Includes headers, body, status code

### ApiClient Exceptions

**Exception Hierarchy:** [lib/core/exceptions/api_exceptions.dart]

```dart
abstract class ApiException implements Exception {
  final String message;
  final int? statusCode;
}

// Specific exceptions:
- UnauthorizedException (401)
- ForbiddenException (403)
- NotFoundException (404)
- ValidationException (422) - With errors map
- ServerException (500)
- NetworkException - No status code
- TimeoutException
- CancelledException
```

### API Configuration

**ApiConfig** [lib/core/api/api_config.dart]
```dart
static const String baseUrl = 'http://192.168.7.26:9090/api';
static const String apiVersion = '/v1';
static const String fullBaseUrl = '$baseUrl$apiVersion';

static String imageUrl(String path) {
  // Handles relative/absolute paths and empty strings
  if (path.startsWith('http')) return path;
  return '$mediaBaseUrl$normalizedPath';
}
```

**ApiEndpoints** [lib/core/api/api_endpoints.dart]
```dart
static const String baseUrl = ApiConfig.fullBaseUrl;

// Auth endpoints
static const String login = '/auth/login';
static const String register = '/auth/register';
static const String logout = '/auth/logout';
static const String refresh = '/auth/refresh';
static const String me = '/auth/me';
static const String verify2fa = '/auth/2fa/check';
static const String resend2fa = '/auth/2fa/resend';
static const String forgotPassword = '/auth/forgot-password';
static const String resetPassword = '/auth/reset-password';

// Other endpoints (notifications, profile, etc.)
```

---

## 6. JWT/AUTH IMPLEMENTATION

### Authentication Flow

#### **Login Flow**
```
User enters email & password
    ↓
AuthService.login()
    ↓
POST /auth/login { email, password }
    ↓
Response: LoginResponse {
  accessToken: string,
  refreshToken: string,
  requires2fa: boolean,
  user?: User
}
    ↓
If 2FA required:
  - Show 2FA verification screen
  - Store pending email
  - Wait for user to enter code
Else:
  - Save tokens to secure storage
  - AuthProvider._isLoggedIn = true
  - Load user profile
```

#### **2FA Verification**
```
User enters 2FA code
    ↓
AuthService.verify2FA(email, code)
    ↓
POST /auth/2fa/check { email, code }
    ↓
Response: Verify2FAResponse {
  accessToken: string,
  refreshToken: string,
  user: User
}
    ↓
Save tokens, update session, navigate to dashboard
```

#### **Token Storage & Security**

**Location:** Flutter Secure Storage (platform-native)
```dart
class TokenStorage {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  
  Future<void> saveAccessToken(String token)
  Future<void> saveRefreshToken(String token)
  Future<String?> getAccessToken()
  Future<String?> getRefreshToken()
  Future<bool> isLoggedIn()
  Future<void> deleteTokens()
}
```

**Storage Methods:**
- **iOS:** Keychain
- **Android:** EncryptedSharedPreferences
- **Web:** localStorage (platform dependent)

**DeviceStorage** [lib/core/storage/device_storage.dart]
```dart
// Also uses Flutter Secure Storage
- saveDeviceToken(token)  // FCM token
- saveDeviceId(id)
- getDeviceToken()
- getDeviceId()
```

#### **Token Refresh Mechanism**

**Automatic Refresh on 401:**
1. DioClient detects 401 response
2. Checks if already refreshing (prevents race conditions)
3. Retrieves refresh token from storage
4. POSTs to `/auth/refresh` with `skipAuth: true` option
5. Parses response (tries multiple key names)
6. Saves new tokens
7. Retries original request
8. If refresh fails, clears tokens and logs out

**Manual Refresh:**
```dart
AuthProvider.refreshSessionFromBackend()
  ↓
AuthService.getCurrentUser()
  ↓
GET /auth/me (with Authorization header)
  ↓
Updates session with current user data
```

#### **Device Token Registration**

**Firebase Cloud Messaging (FCM) Integration:**
```dart
// In AuthProvider after login success
FirebaseMessaging messaging = FirebaseMessaging.instance;

// Request permission
NotificationSettings settings = await messaging.requestPermission(
  alert: true,
  badge: true,
  sound: true,
);

// Get FCM token
String token = await messaging.getToken();

// Register with backend
POST /devices/register {
  deviceToken: token,
  platform: 'android' | 'ios',
  deviceName: Platform.localHostname,
  manufacturer: 'Android' | 'Apple',
  model: Platform.localHostname,
}
```

**Token Refresh Listener:**
```dart
FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
  if (_isLoggedIn) {
    await _handleTokenRefresh(newToken);  // Re-register new token
  }
});
```

#### **Firebase Authentication Service**

**GoogleSignIn + Firebase + Backend Integration:**

```dart
class FirebaseAuthService {
  loginWithGoogle() {
    1. GoogleSignIn.signIn()
    2. Get Google authentication credentials
    3. FirebaseAuth.signInWithCredential(googleCredential)
    4. Get Firebase ID token via firebaseUser.getIdToken()
    5. POST /auth/firebase { idToken: firebaseIdToken }
    6. Backend validates and returns access/refresh tokens
    7. Save tokens locally
  }
}
```

**Firebase Setup:** [lib/firebase_options.dart]
- Platform-specific Firebase configuration
- Auto-generated from `firebase_core` setup

---

## 7. CURRENT CONNECTIVITY HANDLING

### Connectivity Features

#### **Basic Connection Status**
- No explicit connectivity package found
- Relies on Dio timeout and error handling
- Network errors caught as NetworkException

#### **Fallback Data Strategy**

Many services include fallback/mock data:

1. **NewsService**: No explicit fallback
2. **DashboardService**: 
   ```dart
   final DashboardModel fallbackDashboard = DashboardModel(
     firstName: 'Germain',
     matricule: 'ETU-2026-00124',
     quickStats: [...],  // Mock data
     menu: [...],
   );
   ```
3. **NotificationService**:
   ```dart
   final List<NotificationModel> fallbackNotifications = [...]
   ```

#### **Error Handling in Services**

```dart
Future<DashboardModel> getDashboard() async {
  try {
    final response = await http.get(Uri.parse(endpoint));
    if (response.statusCode == 200) {
      return DashboardModel.fromJson(jsonDecode(response.body));
    }
    return fallbackDashboard;  // On non-200 status
  } catch (_) {
    return fallbackDashboard;  // On network error
  }
}
```

#### **HTTP Status Code Handling**

```dart
// Dio validation
validateStatus: (status) => status != null && status >= 200 && status < 300;

// Services manually check:
if (response.statusCode != 200) {
  throw Exception('...');
}
```

### Potential Improvements Needed

- No dependency injection of http.Client in all services
- No explicit connectivity_plus package usage
- No offline-first caching strategy
- Limited retry mechanisms
- Some services use http.Client, others use Dio (inconsistency)

---

## 8. EXISTING LOCAL STORAGE USAGE

### Storage Solutions Used

#### **1. Flutter Secure Storage** [ios/Android/web]

**Usage:**
- **Access Tokens**: Private authentication tokens
- **Refresh Tokens**: For token renewal
- **Device Tokens**: FCM tokens
- **Device IDs**: Device identification

**Implementation:**
```dart
const FlutterSecureStorage()
  .write(key: 'key_name', value: 'value')
  .read(key: 'key_name')
  .delete(key: 'key_name')
  .deleteAll()
```

**Platform Implementation:**
- **iOS**: Keychain
- **Android**: EncryptedSharedPreferences
- **Web**: localStorage or equivalent

#### **2. SharedPreferences** [pubspec.yaml includes dependency]

**Potential Usage:**
- Non-sensitive user preferences
- App settings
- Cache metadata
- *Note: Not heavily used in current codebase*

#### **3. In-Memory Storage**

**UserSessionService:**
- Stores current user object in memory
- Stores current profile (STUDENT/USER)
- Non-persistent, cleared on app exit

**AuthProvider:**
- Caches login state
- Caches user data
- Notifies listeners on state changes

### Storage Architecture

```
┌─────────────────────────────────────┐
│        Flutter App State            │
│  (Providers, UserSessionService)    │
└──────────────────┬──────────────────┘
                   │
        ┌──────────┴────────────┐
        ↓                       ↓
   ┌─────────────┐    ┌──────────────────┐
   │  Provider   │    │  User Session    │
   │  State      │    │  Service         │
   │ (In-Memory) │    │  (In-Memory)     │
   └─────────────┘    └──────────────────┘
        │                      │
        └──────────┬───────────┘
                   ↓
        ┌──────────────────────┐
        │  Secure Storage      │
        │  (TokenStorage,      │
        │   DeviceStorage)     │
        └──────────────────────┘
                   ↓
        ┌──────────────────────┐
        │  Platform-Native     │
        │  (Keychain/Prefs)    │
        └──────────────────────┘
```

### Storage Classes

#### **TokenStorage** [lib/core/storage/token_storage.dart]
```dart
class TokenStorage {
  Future<void> saveAccessToken(String token)
  Future<void> saveRefreshToken(String token)
  Future<String?> getAccessToken()
  Future<String?> getRefreshToken()
  Future<void> deleteTokens()
  Future<bool> isLoggedIn()
  Future<void> clear()
}
```

#### **DeviceStorage** [lib/core/storage/device_storage.dart]
```dart
class DeviceStorage {
  Future<void> saveDeviceToken(String token)
  Future<String?> getDeviceToken()
  Future<void> saveDeviceId(String id)
  Future<String?> getDeviceId()
  Future<void> clear()
}
```

### Local Storage Patterns

1. **Lazy Initialization**: Services cache storage instances via getters
2. **Singleton Caching**: TokenStorage and DeviceStorage used as singletons
3. **Async Operations**: All storage operations are async/Future-based
4. **Secure by Default**: No sensitive data in SharedPreferences
5. **Cleanup**: logout() and deleteTokens() clear storage completely

---

## 9. ROUTING & NAVIGATION

### Route Configuration

**Routes:** [lib/routes/app_routes.dart]
- Static route names as constants
- Example: `/login`, `/dashboard`, `/admission`, etc.

**Pages:** [lib/routes/app_pages.dart]
- Route definitions mapping route names to screens
- Named route configuration

**Entry Point:** [lib/main.dart]
- Material app with named route support
- Firebase initialization before route setup

---

## 10. KEY DEPENDENCIES

```yaml
dependencies:
  flutter: sdk: flutter
  provider: ^6.1.2           # State management
  dio: ^5.8.0               # HTTP client with interceptors
  http: ^1.5.0              # Alternative HTTP
  flutter_secure_storage: ^9.2.2  # Secure token storage
  shared_preferences: ^2.5.3      # App preferences
  firebase_core: ^2.27.0    # Firebase base
  firebase_messaging: ^14.9.4     # Push notifications
  firebase_auth: ^4.18.0    # Firebase auth
  google_sign_in: ^6.2.0    # Google auth
  flutter_local_notifications: ^19.2.0  # Local notifications
  intl: ^0.20.2            # Internationalization
  file_picker: ^8.0.7      # File selection
  image_picker: ^1.2.3     # Image selection
  pdf: ^3.11.0             # PDF generation
  url_launcher: ^6.3.2     # URL launching
  carousel_slider: ^5.1.1  # Carousel widget
  flutter_svg: ^2.2.0      # SVG rendering
```

---

## SUMMARY TABLE

| Aspect | Implementation | Key Features |
|--------|---|---|
| **Architecture** | Clean MVVM | Services → Providers → Screens |
| **State Mgmt** | Provider (ChangeNotifier) | Centralized, observable state |
| **HTTP** | Dio + Interceptors | JWT refresh, error handling, logging |
| **Auth** | JWT + Refresh Token | 2FA, Firebase integration, token rotation |
| **Storage** | Secure Storage | Encrypted tokens, device IDs |
| **Connectivity** | Try/Catch + Fallback Data | Graceful degradation, mock data |
| **Models** | Type-safe, JSON serialization | Flexible API parsing, immutability |
| **Notifications** | Firebase Cloud Messaging | Device registration, preferences |
| **Database** | None (API-driven) | All data from backend |

---

## ARCHITECTURAL STRENGTHS

✅ Separation of Concerns (Services, Providers, Models)
✅ Centralized API Configuration
✅ Automatic JWT Token Refresh
✅ Comprehensive Error Handling
✅ Secure Token Storage
✅ Fallback/Mock Data for Offline
✅ Firebase Integration for Push Notifications
✅ Multi-step Workflow Support (Registration, Admission)
✅ Flexible JSON Parsing (Multiple API response formats)
✅ Provider-based State Management (scalable)

---

## ARCHITECTURAL GAPS & RECOMMENDATIONS

⚠️ **Missing Connectivity Package**: Should use `connectivity_plus` for offline detection
⚠️ **Inconsistent HTTP Clients**: Mix of `http` and `dio` - standardize on Dio
⚠️ **No Local Caching**: Consider Hive or SQLite for persistent app cache
⚠️ **Limited Retry Logic**: No exponential backoff on network failures
⚠️ **No Request Cancellation**: Could implement CancelToken for better UX
⚠️ **Scattered Error Handling**: Centralize error handling logic
⚠️ **Service-level Testing**: Limited dependency injection in some services
⚠️ **No Request/Response Interceptor Standardization**: Mix of patterns
