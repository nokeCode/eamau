import 'package:eamau/routes/app_pages.dart';
import 'package:eamau/routes/app_routes.dart';
import 'package:eamau/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/verify_2fa_screen.dart';
import 'screens/news_screen.dart';
import 'screens/news_detail_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EAMAU',
      home: const ProfileScreen(),
      //initialRoute: AppRoutes.splash,
      //routes: AppPages.routes,
    );
  }
}