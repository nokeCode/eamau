// GUIDE D'INTÉGRATION DES SERVICES API AVEC LES ÉCRANS
// =====================================================

// 1. AUTHENTIFICATION (auth_screen.dart, login_screen.dart)
// ---------------------------------------------------------

import 'package:eamau/services/auth/auth_service.dart';
import 'package:eamau/services/register/register_api_service.dart';

// Dans LoginScreen
class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  bool isLoading = false;

  Future<void> _handleLogin() async {
    setState(() => isLoading = true);
    try {
      final result = await _authService.login(
        email: emailController.text,
        password: passwordController.text,
      );

      if (mounted && result.containsKey('token')) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } on UnauthorizedException catch (e) {
      _showError('Identifiants invalides');
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }
}

// Dans RegisterScreen
class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final RegisterService _registerService = RegisterService();

  Future<void> _handleRegister() async {
    try {
      await _registerService.register(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        email: emailController.text,
        password: passwordController.text,
        passwordConfirmation: confirmPasswordController.text,
        phone: phoneController.text,
      );

      _showSuccess('Inscription réussie! Veuillez vérifier votre email.');
      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pushReplacementNamed('/login');
      });
    } catch (e) {
      _showError(e.toString());
    }
  }
}

// 2. ACCUEIL (home_screen.dart)
// ------------------------------

import 'package:eamau/services/news/news_service.dart';
import 'package:eamau/services/concours/concours_api_service.dart';
import 'package:eamau/services/notification/notification_api_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NewsService _newsService = NewsService();
  final ConcoursService _concoursService = ConcoursService();
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // Charger les actualités
      final news = await _newsService.getNews(limit: 5);

      // Charger les concours
      final concours = await _concoursService.getConcours();

      // Charger le nombre de notifications non lues
      final unreadCount = await _notificationService.getUnreadCount();

      setState(() {
        // Mettre à jour l'état avec les données
      });
    } catch (e) {
      _showError('Erreur de chargement: $e');
    }
  }
}

// 3. ACTUALITÉS (news_screen.dart, news_detail_screen.dart)
// ----------------------------------------------------------

import 'package:eamau/services/news/news_service.dart';

class NewsScreen extends StatefulWidget {
  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final NewsService _newsService = NewsService();
  List<NewsModel> news = [];
  List<NewsCategoryModel> categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadNews();
  }

  Future<void> _loadNews({String? category}) async {
    try {
      final result = await _newsService.getNews(
        page: 1,
        limit: 20,
        category: category,
      );
      setState(() => news = result);
    } catch (e) {
      _showError(e.toString());
    }
  }

  Future<void> _loadCategories() async {
    try {
      final result = await _newsService.getCategories();
      setState(() => categories = result);
    } catch (e) {
      _showError(e.toString());
    }
  }

  void _onCategorySelected(String category) {
    _loadNews(category: category);
  }
}

class NewsDetailScreen extends StatefulWidget {
  final String slug;

  const NewsDetailScreen({required this.slug});

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  final NewsService _newsService = NewsService();
  late Future<NewsModel?> _newsFuture;

  @override
  void initState() {
    super.initState();
    _newsFuture = _newsService.getNewsBySlug(widget.slug);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<NewsModel?>(
      future: _newsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Erreur: ${snapshot.error}')),
          );
        }

        final newsItem = snapshot.data;
        if (newsItem == null) {
          return Scaffold(body: Center(child: Text('Actualité non trouvée')));
        }

        return Scaffold(
          appBar: AppBar(title: Text(newsItem.title)),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Image.network(newsItem.image ?? ''),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(newsItem.title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text(newsItem.date ?? '', style: TextStyle(color: Colors.grey)),
                      SizedBox(height: 16),
                      Text(newsItem.description ?? ''),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// 4. CONCOURS (concours_screen.dart, detail_concours_screen.dart)
// ---------------------------------------------------------------

import 'package:eamau/services/concours/concours_api_service.dart';

class ConcoursListScreen extends StatefulWidget {
  @override
  State<ConcoursListScreen> createState() => _ConcoursListScreenState();
}

class _ConcoursListScreenState extends State<ConcoursListScreen> {
  final ConcoursService _concoursService = ConcoursService();
  List<dynamic> concours = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadConcours();
  }

  Future<void> _loadConcours() async {
    setState(() => isLoading = true);
    try {
      final result = await _concoursService.getConcours();
      setState(() => concours = result['items'] ?? []);
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _applyConcours(String concoursId) async {
    try {
      await _concoursService.applyToConcours(concoursId);
      _showSuccess('Candidature enregistrée!');
    } on UnauthorizedException {
      _showError('Veuillez vous connecter');
      Navigator.of(context).pushNamed('/login');
    } catch (e) {
      _showError(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Concours')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: concours.length,
              itemBuilder: (context, index) {
                return ConcoursCard(
                  concours: concours[index],
                  onApply: () => _applyConcours(concours[index]['id']),
                );
              },
            ),
    );
  }
}

// 5. FILIÈRES (filiere_screen.dart, filiere_detail_screen.dart)
// ---------------------------------------------------------------

import 'package:eamau/services/filiere/filiere_api_service.dart';

class FiliereScreen extends StatefulWidget {
  @override
  State<FiliereScreen> createState() => _FiliereScreenState();
}

class _FiliereScreenState extends State<FiliereScreen> {
  final FiliereService _filiereService = FiliereService();
  List<dynamic> filieres = [];

  @override
  void initState() {
    super.initState();
    _loadFilieres();
  }

  Future<void> _loadFilieres() async {
    try {
      final result = await _filiereService.getFilieres();
      setState(() => filieres = result['items'] ?? []);
    } catch (e) {
      _showError(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Filières')),
      body: ListView.builder(
        itemCount: filieres.length,
        itemBuilder: (context, index) {
          return FiliereCard(
            filiere: filieres[index],
            onTap: () {
              Navigator.of(context).pushNamed(
                '/filiere-detail',
                arguments: filieres[index]['slug'],
              );
            },
          );
        },
      ),
    );
  }
}

// 6. PROFIL (profile_screen.dart)
// --------------------------------

import 'package:eamau/services/profile/profile_api_service.dart';
import 'package:eamau/services/auth/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileService _profileService = ProfileService();
  final AuthService _authService = AuthService();
  Map<String, dynamic>? userProfile;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await _profileService.getProfile();
      setState(() => userProfile = profile);
    } catch (e) {
      _showError(e.toString());
    }
  }

  Future<void> _updateProfile() async {
    try {
      await _profileService.updateProfile({
        'first_name': firstNameController.text,
        'last_name': lastNameController.text,
        'phone': phoneController.text,
      });
      _showSuccess('Profil mis à jour!');
    } catch (e) {
      _showError(e.toString());
    }
  }

  Future<void> _changePassword() async {
    try {
      await _profileService.updatePassword(
        currentPassword: currentPasswordController.text,
        newPassword: newPasswordController.text,
        confirmPassword: confirmPasswordController.text,
      );
      _showSuccess('Mot de passe changé!');
    } catch (e) {
      _showError(e.toString());
    }
  }

  Future<void> _logout() async {
    try {
      await _authService.logout();
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    } catch (e) {
      _showError(e.toString());
    }
  }
}

// 7. NOTIFICATIONS (notification_screen.dart)
// -----------------------------------------------

import 'package:eamau/services/notification/notification_api_service.dart';

class NotificationScreen extends StatefulWidget {
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationService _notificationService = NotificationService();
  List<dynamic> notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    try {
      final result = await _notificationService.getNotifications();
      setState(() => notifications = result);
    } catch (e) {
      _showError(e.toString());
    }
  }

  Future<void> _markAsRead(String notificationId) async {
    try {
      await _notificationService.markAsRead(notificationId);
      _loadNotifications(); // Recharger
    } catch (e) {
      _showError(e.toString());
    }
  }

  Future<void> _markAllAsRead() async {
    try {
      await _notificationService.markAllAsRead();
      _loadNotifications(); // Recharger
    } catch (e) {
      _showError(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        actions: [
          IconButton(
            icon: Icon(Icons.done_all),
            onPressed: _markAllAsRead,
            tooltip: 'Marquer tout comme lu',
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return NotificationTile(
            notification: notification,
            onTap: () => _markAsRead(notification['id']),
          );
        },
      ),
    );
  }
}

// 8. ADMISSION (admission_screen.dart)
// -----------------------------------

import 'package:eamau/services/admission/admission_api_service.dart';

class AdmissionScreen extends StatefulWidget {
  @override
  State<AdmissionScreen> createState() => _AdmissionScreenState();
}

class _AdmissionScreenState extends State<AdmissionScreen> {
  final AdmissionService _admissionService = AdmissionService();
  List<dynamic> admissions = [];

  @override
  void initState() {
    super.initState();
    _loadAdmissions();
  }

  Future<void> _loadAdmissions() async {
    try {
      final result = await _admissionService.getAdmissions();
      setState(() => admissions = result['items'] ?? []);
    } catch (e) {
      _showError(e.toString());
    }
  }

  Future<void> _createAdmission() async {
    try {
      final result = await _admissionService.createAdmission();
      _loadAdmissions();
      _showSuccess('Admission créée!');
    } catch (e) {
      _showError(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mes demandes d\'admission')),
      floatingActionButton: FloatingActionButton(
        onPressed: _createAdmission,
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: admissions.length,
        itemBuilder: (context, index) {
          return AdmissionCard(
            admission: admissions[index],
            onTap: () {
              Navigator.of(context).pushNamed(
                '/admission-detail',
                arguments: admissions[index]['uuid'],
              );
            },
          );
        },
      ),
    );
  }
}

// NOTES IMPORTANTES
// =================

// 1. N'oubliez pas d'ajouter les catches appropriés pour les exceptions:
//    - UnauthorizedException: gérer la réauthentification
//    - NotFoundException: afficher un message adapté
//    - ValidationException: afficher les erreurs de validation
//    - ApiException: erreur générale

// 2. Utilisez toujours try-catch pour les appels API

// 3. Gérez les états de chargement avec isLoading/isFetching

// 4. Utilisez setState() ou un StateManagement (Provider/Riverpod) pour mettre à jour l'UI

// 5. Pour les opérations longues, affichez un indicateur de progression

// 6. Testez toujours les appels API avec le serveur local:
//    Base URL: http://localhost:9090/api/v1

// 7. Assurez-vous que le token JWT est toujours passé pour les routes protégées
//    Le ApiClient le fait automatiquement quand requireAuth=true

