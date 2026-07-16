import 'package:eamau/screens/admission/admission_request_screen.dart';
import 'package:eamau/screens/admission/admission_tracking_screen.dart';
import 'package:eamau/screens/concours/concours_list_screen.dart';
import 'package:eamau/screens/register_screen.dart';
import 'package:flutter/material.dart';

import 'package:eamau/screens/student_screen.dart';
import 'package:eamau/screens/user_screen.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/news_detail_screen.dart';
import '../screens/news_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/verify_2fa_screen.dart';
import '../screens/profile_screen.dart';

import 'app_routes.dart';

class AppPages {
  static Map<String, WidgetBuilder> routes = {
    AppRoutes.splash: (_) => const SplashScreen(),
    AppRoutes.home: (_) => const HomeScreen(),
    AppRoutes.login: (_) => const LoginScreen(),
    AppRoutes.register: (_) => const RegisterScreen(),
    AppRoutes.verify2fa: (_) => const VerificationScreen(),
    AppRoutes.news: (_) => const NewsScreen(),
    AppRoutes.newsDetail: (_) => const NewsDetailScreen(),
    AppRoutes.profile: (_) => const ProfileScreen(),
    AppRoutes.user: (_) => const DashboardScreen(),
    AppRoutes.student: (_) => const StudentScreen(),
    AppRoutes.concours: (_) => const ConcoursListScreen(),
    AppRoutes.admissionRequest: (_) => const AdmissionRequestScreen(),
    AppRoutes.admissionTracking: (_) => const AdmissionTrackingScreen(),
  };
}