import 'package:eamau/providers/admission_provider.dart';
import 'package:eamau/providers/admission_tracking_provider.dart';
import 'package:eamau/providers/auth_provider.dart';
import 'package:eamau/providers/notification_provider.dart';
import 'package:eamau/providers/registration/registration_provider.dart';
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
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/verify_2fa_screen.dart';
import 'screens/news_screen.dart';
import 'screens/news_detail_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    final messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // ignore: avoid_print
    print("Permission : ${settings.authorizationStatus}");

    String? token = await messaging.getToken();

    print("======================================");
    print("FCM TOKEN :");
    print(token);
    print("======================================");

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings();

    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // ignore: avoid_print
      print("Notification reçue");
      // ignore: avoid_print
      print(message.notification?.title);
      // ignore: avoid_print
      print(message.notification?.body);
    });
  } catch (e, st) {
    // If Firebase cannot initialize (e.g. on unsupported desktop platforms
    // or temporary channel errors), log and continue so the app can still run.
    // This prevents a hard crash / white screen during development.
    // Consider reporting this to your error monitoring or handling differently
    // for production builds.
    // ignore: avoid_print
    print('Firebase initialization error: $e');
    // ignore: avoid_print
    print(st);
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => AdmissionTrackingProvider()),
        ChangeNotifierProvider(create: (_) => RegistrationProvider()),
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
      //home: const AdmissionScreen(),
      initialRoute: AppRoutes.splash,
      routes: AppPages.routes,
    );
  }
}
