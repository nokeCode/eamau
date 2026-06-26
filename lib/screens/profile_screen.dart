import 'package:flutter/material.dart';
import '../../services/auth/auth_service.dart';
import '../../services/profile/profile_service.dart';
import '../../widgets/profile/profile_header.dart';
import '../../widgets/profile/profile_card.dart';
import '../../widgets/profile/profile_section.dart';
import '../models/profile/user_model.dart';
import 'login_screen.dart';

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

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final logged = await _authService.isLoggedIn();

    if (!logged) {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: const RouteSettings(arguments: "Vous n'êtes pas encore connecté."),
        ),
      );

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
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
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
      ),
    );
  }
}
