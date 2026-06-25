import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class CustomBottomNav extends StatelessWidget {
  const CustomBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 2,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF0066FF),
      unselectedItemColor: Colors.black54,

      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(
              context,
              AppRoutes.home,
            );
            break;

          case 2:
            Navigator.pushReplacementNamed(
              context,
              AppRoutes.news,
            );
            break;

          case 4: //profile
            Navigator.pushReplacementNamed(context, AppRoutes.profile,);
            break;
        }
      },

      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: "Accueil",
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month_outlined),
          label: "Calendrier",
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.article_outlined),
          label: "Actualité",
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.school_outlined),
          label: "Mes Études",
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: "Profil",
        ),
      ],
    );
  }
}