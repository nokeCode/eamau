import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  const CustomBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 2,
      type: BottomNavigationBarType.fixed,
      selectedItemColor:
      const Color(0xFF0066FF),
      unselectedItemColor: Colors.black54,
      items: const [

        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: "Accueil",
        ),

        BottomNavigationBarItem(
          icon: Icon(
            Icons.calendar_month_outlined,
          ),
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