import 'package:flutter/material.dart';
import '../widgets/home/home_header.dart';
import '../widgets/home/search_bar_widget.dart';
import '../widgets/home/admission_banner.dart';
import '../widgets/home/menu_card.dart';
import '../routes/app_routes.dart';
import '../services/news/news_service.dart';
import '../services/concours/concours_api_service.dart';
import '../services/notification/notification_api_service.dart';
import '../services/api_client.dart';

/// HomeScreen - Page d'accueil de l'application
///
/// Cette page intègre les services API suivants:
/// - NewsService: pour charger les actualités en avant
/// - ConcoursService: pour charger les concours à venir
/// - NotificationService: pour afficher le nombre de notifications non lues
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Services
  final NewsService _newsService = NewsService();
  final ConcoursService _concoursService = ConcoursService();
  final NotificationService _notificationService = NotificationService();

  // État de l'écran
  List<dynamic> _featuredNews = [];
  List<dynamic> _upcomingConcours = [];
  int _unreadNotifications = 0;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadHomeData();
  }

  /// Charge toutes les données nécessaires pour la page d'accueil
  Future<void> _loadHomeData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Charger les actualités en avant
      final news = await _newsService.getFeaturedNews();

      // Charger les concours
      final concours = await _concoursService.getConcours();

      // Charger le nombre de notifications non lues
      final unreadCount = await _notificationService.getUnreadCount();

      if (mounted) {
        setState(() {
          _featuredNews = news is List ? news : (news is Map ? news['items'] ?? [] : []);
          _upcomingConcours = concours is Map ? (concours['items'] ?? []) : [];
          _unreadNotifications = unreadCount;
          _isLoading = false;
        });
      }
    } on UnauthorizedException catch (e) {
      // Gérer la non-authentification
      if (mounted) {
        setState(() {
          _errorMessage = 'Veuillez vous connecter';
          _isLoading = false;
        });

        // Rediriger vers la page de connexion
        Future.delayed(Duration(seconds: 2), () {
          if (mounted) {
            Navigator.of(context).pushReplacementNamed('/login');
          }
        });
      }
    } on NotFoundException catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Ressource non trouvée';
          _isLoading = false;
        });
      }
    } on ValidationException catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.message;
          _isLoading = false;
        });
      }
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.message;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Erreur lors du chargement des données: $e';
          _isLoading = false;
        });
      }
    }
  }

  /// Rafraîchit les données de la page
  Future<void> _refreshData() async {
    await _loadHomeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _isLoading
            ? _buildLoadingState()
            : _errorMessage != null
                ? _buildErrorState()
                : _buildSuccessState(),
      ),
    );
  }

  /// État de chargement
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Chargement en cours...'),
        ],
      ),
    );
  }

  /// État d'erreur
  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red),
          SizedBox(height: 16),
          Text(
            _errorMessage ?? 'Une erreur est survenue',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadHomeData,
            child: Text('Réessayer'),
          ),
        ],
      ),
    );
  }

  /// État de succès
  Widget _buildSuccessState() {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            // En-tête avec notifications
            _buildHeader(),
            const SizedBox(height: 20),

            // Barre de recherche
            const SearchBarWidget(),
            const SizedBox(height: 20),

            // Banner d'admission
            const AdmissionBanner(),
            const SizedBox(height: 20),

            // Actualités en avant
            if (_featuredNews.isNotEmpty) ...[
              _buildFeaturedNewsSection(),
              const SizedBox(height: 20),
            ],

            // Concours à venir
            if (_upcomingConcours.isNotEmpty) ...[
              _buildUpcomingConcoursSection(),
              const SizedBox(height: 20),
            ],

            // Menu principal
            _buildMainMenu(),
          ],
        ),
      ),
    );
  }

  /// En-tête avec badge notifications
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const HomeHeader(),
        Stack(
          children: [
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                Navigator.of(context).pushNamed('/notifications');
              },
            ),
            if (_unreadNotifications > 0)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  constraints: BoxConstraints(minWidth: 24, minHeight: 24),
                  child: Text(
                    _unreadNotifications.toString(),
                    style: TextStyle(color: Colors.white, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  /// Section des actualités en avant
  Widget _buildFeaturedNewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Actualités en avant',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/news');
              },
              child: Text('Voir plus'),
            ),
          ],
        ),
        SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _featuredNews.length,
            itemBuilder: (context, index) {
              final news = _featuredNews[index];
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    '/news-detail',
                    arguments: news['slug'] ?? '',
                  );
                },
                child: Container(
                  width: 280,
                  margin: EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[200],
                  ),
                  child: Stack(
                    children: [
                      // Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: news['image'] != null
                            ? Image.network(
                                news['image'],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[300],
                                    child: Center(
                                      child: Icon(Icons.image_not_supported),
                                    ),
                                  );
                                },
                              )
                            : Container(
                                color: Colors.grey[300],
                                child: Center(
                                  child: Icon(Icons.image),
                                ),
                              ),
                      ),
                      // Gradient overlay
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black87,
                            ],
                          ),
                        ),
                      ),
                      // Titre
                      Positioned(
                        bottom: 12,
                        left: 12,
                        right: 12,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              news['title'] ?? 'Sans titre',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              news['date'] ?? '',
                              style: TextStyle(
                                color: Colors.grey[300],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Section des concours à venir
  Widget _buildUpcomingConcoursSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Concours à venir',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/concours');
              },
              child: Text('Voir plus'),
            ),
          ],
        ),
        SizedBox(height: 12),
        ..._upcomingConcours.take(3).map((concours) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                '/concours-detail',
                arguments: concours['slug'] ?? '',
              );
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 12),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300] ?? Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    concours['title'] ?? 'Sans titre',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    concours['description'] ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  /// Menu principal
  Widget _buildMainMenu() {
    return Column(
      children: [
        Text(
          'Services',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.7,
          children: [
            MenuCard(
              icon: Icons.newspaper_outlined,
              title: 'Actualité',
              subtitle: 'Restez informé',
              onTap: () {
                Navigator.of(context).pushNamed('/news');
              },
            ),
            MenuCard(
              icon: Icons.school_outlined,
              title: 'Filières',
              subtitle: 'Parcours disponibles',
              onTap: () {
                Navigator.of(context).pushNamed('/filieres');
              },
            ),
            MenuCard(
              icon: Icons.assignment_outlined,
              title: 'Concours',
              subtitle: 'Candidatez maintenant',
              onTap: () {
                Navigator.of(context).pushNamed('/concours');
              },
            ),
            MenuCard(
              icon: Icons.person_outlined,
              title: 'Profil',
              subtitle: 'Mes informations',
              onTap: () {
                Navigator.of(context).pushNamed('/profile');
              },
            ),
            MenuCard(
              icon: Icons.book_outlined,
              title: 'Admissions',
              subtitle: 'Suivi candidature',
              onTap: () {
                Navigator.of(context).pushNamed('/admission');
              },
            ),
            MenuCard(
              icon: Icons.contact_mail_outlined,
              title: 'Contact',
              subtitle: 'Nous contacter',
              onTap: () {
                Navigator.of(context).pushNamed('/contact');
              },
            ),
          ],
        ),
      ],
    );
  }
}

