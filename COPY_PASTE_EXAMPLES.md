# 🔧 Exemples Copy-Paste - Intégration Rapide

Utilisez ces exemples comme base pour intégrer les API dans vos écrans.

---

## 1️⃣ Écran Simple - NewsScreen

```dart
import 'package:flutter/material.dart';
import '../services/news/news_service.dart';
import '../models/news/news_model.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final NewsService _newsService = NewsService();
  List<NewsModel> news = [];
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  Future<void> _loadNews() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    
    try {
      final result = await _newsService.getNews();
      setState(() {
        news = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Actualités')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Erreur: $errorMessage'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadNews,
                        child: const Text('Réessayer'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: news.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(news[index].title),
                    subtitle: Text(news[index].date ?? ''),
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        '/news-detail',
                        arguments: news[index].id,
                      );
                    },
                  ),
                ),
    );
  }
}
```

---

## 2️⃣ Écran avec Authentification - ProfileScreen

```dart
import 'package:flutter/material.dart';
import '../services/profile/profile_api_service.dart';
import '../services/auth/auth_service.dart';
import '../services/api_client.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileService _profileService = ProfileService();
  final AuthService _authService = AuthService();
  
  Map<String, dynamic>? userProfile;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await _profileService.getProfile();
      setState(() {
        userProfile = profile;
        isLoading = false;
      });
    } on UnauthorizedException {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    try {
      await _authService.logout();
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur déconnexion: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text('Erreur: $errorMessage'))
              : userProfile == null
                  ? const Center(child: Text('Profil non chargé'))
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        Text(
                          'Email: ${userProfile!['email'] ?? 'N/A'}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Nom: ${userProfile!['first_name'] ?? ''} ${userProfile!['last_name'] ?? ''}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            // Naviguer vers l'écran d'édition
                          },
                          child: const Text('Éditer le profil'),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            // Naviguer vers changement mot de passe
                          },
                          child: const Text('Changer le mot de passe'),
                        ),
                      ],
                    ),
    );
  }
}
```

---

## 3️⃣ Écran avec Liste Paginée - AdmissionScreen

```dart
import 'package:flutter/material.dart';
import '../services/admission/admission_api_service.dart';
import '../services/api_client.dart';

class AdmissionScreen extends StatefulWidget {
  const AdmissionScreen({super.key});

  @override
  State<AdmissionScreen> createState() => _AdmissionScreenState();
}

class _AdmissionScreenState extends State<AdmissionScreen> {
  final AdmissionService _admissionService = AdmissionService();
  
  List<dynamic> admissions = [];
  bool isLoading = false;
  int currentPage = 1;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadAdmissions();
  }

  Future<void> _loadAdmissions({int page = 1}) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final result = await _admissionService.getAdmissions(page: page);
      setState(() {
        admissions = result['items'] ?? [];
        currentPage = page;
        isLoading = false;
      });
    } on UnauthorizedException {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _createAdmission() async {
    try {
      await _admissionService.createAdmission();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Admission créée!')),
      );
      _loadAdmissions();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Admissions'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createAdmission,
        child: const Icon(Icons.add),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Erreur: $errorMessage'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => _loadAdmissions(),
                        child: const Text('Réessayer'),
                      ),
                    ],
                  ),
                )
              : admissions.isEmpty
                  ? const Center(child: Text('Aucune admission'))
                  : ListView.builder(
                      itemCount: admissions.length,
                      itemBuilder: (context, index) => ListTile(
                        title: Text(admissions[index]['title'] ?? 'Admission'),
                        subtitle: Text(admissions[index]['status'] ?? 'En cours'),
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            '/admission-detail',
                            arguments: admissions[index]['uuid'],
                          );
                        },
                      ),
                    ),
    );
  }
}
```

---

## 4️⃣ Formulaire de Connexion - LoginScreen

```dart
import 'package:flutter/material.dart';
import '../services/auth/auth_service.dart';
import '../services/api_client.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  bool isLoading = false;
  String? errorMessage;

  Future<void> _login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      setState(() => errorMessage = 'Veuillez remplir tous les champs');
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final result = await _authService.login(
        email: emailController.text,
        password: passwordController.text,
      );

      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } on UnauthorizedException {
      setState(() => errorMessage = 'Identifiants invalides');
    } on ApiException catch (e) {
      setState(() => errorMessage = e.message);
    } catch (e) {
      setState(() => errorMessage = 'Erreur: $e');
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connexion')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Mot de passe',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            if (errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  errorMessage!,
                  style: TextStyle(color: Colors.red.shade900),
                ),
              ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: isLoading ? null : _login,
                child: isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Se connecter'),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/register');
              },
              child: const Text('Pas encore de compte? S\'inscrire'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 5️⃣ Écran avec FutureBuilder - NewsDetailScreen

```dart
import 'package:flutter/material.dart';
import '../services/news/news_service.dart';
import '../models/news/news_model.dart';

class NewsDetailScreen extends StatefulWidget {
  final String slug;

  const NewsDetailScreen({
    super.key,
    required this.slug,
  });

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
    return Scaffold(
      appBar: AppBar(title: const Text('Actualité')),
      body: FutureBuilder<NewsModel?>(
        future: _newsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Erreur: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => setState(() {
                      _newsFuture = _newsService.getNewsBySlug(widget.slug);
                    }),
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Actualité non trouvée'));
          }

          final news = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (news.image != null)
                  Image.network(
                    news.image!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        news.title,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        news.date ?? '',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        news.description ?? '',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
```

---

## 6️⃣ Écran avec Recherche - ConcoursSearchScreen

```dart
import 'package:flutter/material.dart';
import '../services/concours/concours_api_service.dart';

class ConcoursSearchScreen extends StatefulWidget {
  const ConcoursSearchScreen({super.key});

  @override
  State<ConcoursSearchScreen> createState() => _ConcoursSearchScreenState();
}

class _ConcoursSearchScreenState extends State<ConcoursSearchScreen> {
  final ConcoursService _concoursService = ConcoursService();
  final searchController = TextEditingController();
  
  List<dynamic> searchResults = [];
  bool isSearching = false;
  String? errorMessage;

  Future<void> _search(String query) async {
    if (query.isEmpty) {
      setState(() => searchResults = []);
      return;
    }

    setState(() {
      isSearching = true;
      errorMessage = null;
    });

    try {
      final result = await _concoursService.searchConcours(query: query);
      setState(() {
        searchResults = result['items'] ?? [];
        isSearching = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isSearching = false;
      });
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rechercher des concours')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: _search,
            ),
          ),
          if (errorMessage != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Erreur: $errorMessage',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          Expanded(
            child: isSearching
                ? const Center(child: CircularProgressIndicator())
                : searchResults.isEmpty
                    ? const Center(
                        child: Text('Aucun résultat trouvé'),
                      )
                    : ListView.builder(
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) => ListTile(
                          title: Text(searchResults[index]['title'] ?? ''),
                          subtitle: Text(
                            searchResults[index]['description'] ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              '/concours-detail',
                              arguments: searchResults[index]['slug'],
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
```

---

## 💡 Astuces Importantes

### 1. Gérer les erreurs d'authentification
```dart
try {
  // Appel API
} on UnauthorizedException {
  // Rediriger vers login
  Navigator.pushReplacementNamed(context, '/login');
} catch (e) {
  // Gérer les autres erreurs
}
```

### 2. Afficher des messages de succès
```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('Succès!'),
    backgroundColor: Colors.green,
  ),
);
```

### 3. Désactiver les boutons pendant le chargement
```dart
ElevatedButton(
  onPressed: isLoading ? null : _handleAction,
  child: isLoading
      ? const CircularProgressIndicator()
      : const Text('Action'),
)
```

### 4. Utiliser RefreshIndicator
```dart
RefreshIndicator(
  onRefresh: () => _loadData(),
  child: ListView(...),
)
```

---

**Utilisez ces exemples comme base et adaptez-les selon vos besoins!**

