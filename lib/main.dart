import 'package:eamau/providers/notification_provider.dart';
import 'package:eamau/routes/app_pages.dart';
import 'package:eamau/routes/app_routes.dart';
import 'package:eamau/screens/notification_screen.dart';
import 'package:eamau/screens/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/verify_2fa_screen.dart';
import 'screens/news_screen.dart';
import 'screens/news_detail_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => NotificationProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EAMAU',
      home: const DashboardScreen(),
      //initialRoute: AppRoutes.splash,
      //routes: AppPages.routes,
    );
  }
}