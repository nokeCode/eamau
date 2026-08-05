import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../routes/app_routes.dart';

class MainBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const MainBottomNavigationBar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: (index) async {
        switch (index) {
          case 0:
            if (currentIndex != 0) {
              navigator.pushReplacementNamed(AppRoutes.home);
            }
            break;
          case 1:
            navigator.pushNamed(AppRoutes.news);
            break;
          case 2:
            if (currentIndex == 2) {
              return;
            }

            if (!authProvider.isLoggedIn) {
              messenger.showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.red,
                  content: Text('Connexion requise pour accéder au dashboard.'),
                ),
              );
              return;
            }

            await authProvider.loadCurrentUser();

            if (!context.mounted) return;

            if (authProvider.isUser) {
              navigator.pushReplacementNamed(AppRoutes.user);
            } else if (authProvider.isStudent) {
              navigator.pushReplacementNamed(AppRoutes.student);
            } else {
              messenger.showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.orange,
                  content: Text('Accès au dashboard indisponible pour ce compte.'),
                ),
              );
            }
            break;
          case 3:
            navigator.pushNamed(AppRoutes.concours);
            break;
          case 4:
            navigator.pushNamed(AppRoutes.profile);
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
        BottomNavigationBarItem(icon: Icon(Icons.newspaper_outlined), label: 'Actualités'),
        BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: 'Dashboard'),
        BottomNavigationBarItem(icon: Icon(Icons.emoji_events_outlined), label: 'Concours'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profil'),
      ],
    );
  }
}
