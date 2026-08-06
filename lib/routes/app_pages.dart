import 'package:eamau/screens/admission/admission_request_screen.dart';
import 'package:eamau/screens/admission/admission_screen.dart';
import 'package:eamau/screens/admission/admission_tracking_screen.dart';
import 'package:eamau/screens/concours/concours_list_screen.dart';
import 'package:eamau/screens/register_screen.dart';
import 'package:eamau/screens/registration/registration_screen.dart';
import 'package:flutter/material.dart';

import 'package:eamau/screens/student_screen.dart';
import 'package:eamau/screens/user_screen.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/news_detail_screen.dart';
import '../screens/news_screen.dart';
import '../screens/publication_detail_screen.dart';
import '../screens/publication_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/verify_2fa_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/filiere_screen.dart';

import 'app_routes.dart';

class AppPages {
  static Map<String, WidgetBuilder> routes = {
    AppRoutes.splash: (_) => const SplashScreen(),
    AppRoutes.home: (_) => const HomeScreen(),
    AppRoutes.login: (_) => const LoginScreen(),
    AppRoutes.register: (_) => const RegisterScreen(),
    AppRoutes.registration: (_) => const RegistrationScreen(),
    AppRoutes.verify2fa: (_) => const VerificationScreen(),
    AppRoutes.news: (_) => const NewsScreen(),
    AppRoutes.newsDetail: (context) {
      final slug = ModalRoute.of(context)?.settings.arguments as String?;
      return NewsDetailScreen(slug: slug);
    },
    AppRoutes.publications: (_) => const PublicationScreen(),
    AppRoutes.publicationDetail: (context) {
      final slug = ModalRoute.of(context)?.settings.arguments as String?;
      return PublicationDetailScreen(slug: slug);
    },
    AppRoutes.profile: (_) => const ProfileScreen(),
    AppRoutes.user: (_) => const DashboardScreen(),
    AppRoutes.student: (_) => const StudentScreen(),
    AppRoutes.concours: (_) => const ConcoursListScreen(),
    AppRoutes.filiere: (_) => const FiliereScreen(),
    AppRoutes.admission: (_) => const AdmissionScreen(),
    AppRoutes.admissionRequest: (context) {
      final campaignId =
          ModalRoute.of(context)?.settings.arguments as int? ?? 0;
      return AdmissionRequestScreen(campaignId: campaignId);
    },
    AppRoutes.admissionTracking: (context) {
      final requestId = ModalRoute.of(context)?.settings.arguments as int?;
      if (requestId == null) {
        return const AdmissionTrackingScreen(requestId: 0);
      }
      return AdmissionTrackingScreen(requestId: requestId);
    },
  };
}
