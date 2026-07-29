import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import '../../services/auth/auth_service.dart';
import '../../services/profile/profile_service.dart';
import '../../widgets/profile/profile_header.dart';
import '../../widgets/profile/profile_card.dart';
import '../../widgets/profile/profile_section.dart';
import '../models/profile/user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  final ProfileService _profileService = ProfileService();

  UserModel _user = UserModel.fallback();
  bool _loading = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final logged = await _authService.isLoggedIn();

    if (!mounted) return;

    setState(() {
      _isLoggedIn = logged;
      _loading = false;
    });

    if (!logged) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Vous n'êtes pas encore connecté."),
            duration: Duration(seconds: 3),
          ),
        );
      });
      return;
    }

    final profile = await _profileService.getProfile();

    if (!mounted) return;

    setState(() {
      _user = profile;
    });
  }

  Widget _buildGuestView() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const ProfileHeader(),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.lock_outline,
                    size: 64,
                    color: const Color(0xFF1682F8),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Profil privé',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Vous n\'êtes pas encore connecté. Connectez-vous pour accéder à votre profil et à vos informations.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.login);
                      },
                      icon: const Icon(Icons.login),
                      label: const Text('Se connecter'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1682F8),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _isLoggedIn
              ? RefreshIndicator(
                  onRefresh: () async {
                    final p = await _profileService.getProfile();
                    if (mounted) {
                      setState(() => _user = p);
                    }
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        const ProfileHeader(),
                        Transform.translate(
                          offset: const Offset(0, -55),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                ProfileCard(
                                  user: _user,
                                  onEdit: () {},
                                ),
                                const SizedBox(height: 24),
                                ProfileSection(user: _user),
                                const SizedBox(height: 40),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : _buildGuestView(),
    );
  }
}
