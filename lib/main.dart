import 'package:eamau/providers/admission_provider.dart';
import 'package:eamau/providers/admission_tracking_provider.dart';
import 'package:eamau/providers/notification_provider.dart';
import 'package:eamau/providers/student/dashboard_provider.dart';
import 'package:eamau/routes/app_pages.dart';
import 'package:eamau/routes/app_routes.dart';
import 'package:eamau/screens/admission/admission_conditions_screen.dart';
import 'package:eamau/screens/admission/admission_request_screen.dart';
import 'package:eamau/screens/admission/admission_screen.dart';
import 'package:eamau/screens/admission/admission_tracking_screen.dart';
import 'package:eamau/screens/concours/application_form_screen.dart';
import 'package:eamau/screens/concours/concours_list_screen.dart';
import 'package:eamau/screens/concours/confirmation_candidature_screen.dart';
import 'package:eamau/screens/concours/detail_concours_screen.dart';
import 'package:eamau/screens/concours/suivi_candidature_screen.dart';
import 'package:eamau/screens/contact_screen.dart';
import 'package:eamau/screens/filiere_screen.dart';
import 'package:eamau/screens/notification_screen.dart';
import 'package:eamau/screens/register_screen.dart';
import 'package:eamau/screens/student_screen.dart';
import 'package:eamau/screens/teacher_evaluation_screen.dart';
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
        ChangeNotifierProvider(
          create: (_) => DashboardProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => AdmissionTrackingProvider(),
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
      //home: const DetailConcoursScreen(concoursId: 1),
      //home: const SuiviCandidatureScreen(candidatureId: 1)
      home: const AdmissionScreen(),
      //initialRoute: AppRoutes.splash,
      //routes: AppPages.routes,
    );
  }
}