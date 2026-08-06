import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNav({super.key, this.currentIndex = 2});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF0066FF),
      unselectedItemColor: Colors.black54,

      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushNamed(
              context,
              AppRoutes.home,
            );
            break;

          case 2:
            Navigator.pushNamed(
              context,
              AppRoutes.news,
            );
            break;

          case 3:
            Navigator.pushNamed(context, AppRoutes.publications);
            break;

          case 4: //profile
            Navigator.pushNamed(context, AppRoutes.profile);
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
          icon: Icon(Icons.menu_book_outlined),
          label: "Publication Scientifique",
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: "Profil",
        ),
      ],
    );
  }
}