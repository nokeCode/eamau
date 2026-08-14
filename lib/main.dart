import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'providers/admission_tracking_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/registration/registration_provider.dart';
import 'providers/student/dashboard_provider.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Ensure background handler is registered before Firebase initialization
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

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

    debugPrint("Permission : ${settings.authorizationStatus}");

    String? token = await messaging.getToken();

    debugPrint("======================================");
    debugPrint("FCM TOKEN :");
    debugPrint(token ?? 'null');
    debugPrint("======================================");

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const channel = AndroidNotificationChannel(
      'eamau_channel',
      'EAMAU Notifications',
      description: 'Channel for EAMAU push notifications',
      importance: Importance.max,
    );
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings();

    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
    );

    // Foreground messages: show a local notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint("Notification reçue (foreground)");
      debugPrint(message.notification?.title ?? '');
      debugPrint(message.notification?.body ?? '');

      final notification = message.notification;
      final payloadData = {
        'type': _notificationStringValue(
          message.data,
          ['type', 'notificationType', 'notification_type'],
        ),
        'notificationId': _notificationStringValue(
          message.data,
          ['notificationId', 'notification_id', 'notificationid'],
        ),
        'entityId': _notificationStringValue(
          message.data,
          ['entityId', 'entity_id', 'entityid', 'id', 'resource_id', 'slug'],
        ),
        'route': _notificationStringValue(
          message.data,
          ['route', 'deepLink', 'deeplink'],
        ),
        'raw': message.data,
      };

      if (notification != null) {
        final androidDetails = AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          importance: Importance.max,
          priority: Priority.high,
        );

        final details = NotificationDetails(
          android: androidDetails,
          iOS: const DarwinNotificationDetails(),
        );

        await flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          details,
          payload: jsonEncode(payloadData),
        );
      }
    });

    // When the app is opened from a notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('onMessageOpenedApp: ${message.messageId}');
      _handleNavigationFromMessage(message);
    });

    // If the app was completely terminated and opened from a notification
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleNavigationFromMessage(initialMessage);
    }
  } catch (e, st) {
    // If Firebase cannot initialize (e.g. on unsupported desktop platforms
    // or temporary channel errors), log and continue so the app can still run.
    // This prevents a hard crash / white screen during development.
    // Consider reporting this to your error monitoring or handling differently
    // for production builds.
    debugPrint('Firebase initialization error: $e');
    debugPrint(st.toString());
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

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (_) {}

  // Keep background handling minimal; rely on system notification when provided.
  // Log for debugging.
  debugPrint('Background message received: ${message.messageId}');
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

String _notificationStringValue(
  Map<String, dynamic> data,
  List<String> keys, {
  String fallback = '',
}) {
  for (final key in keys) {
    final value = data[key];
    if (value != null && value.toString().trim().isNotEmpty) {
      return value.toString();
    }
  }
  return fallback;
}

void _handleNavigationFromMessage(RemoteMessage message) {
  final data = message.data;

  final type = _notificationStringValue(
    data,
    ['type', 'notificationType', 'notification_type'],
  ).toUpperCase();
  final route = _notificationStringValue(
    data,
    ['route', 'deepLink', 'deeplink'],
  );
  final notificationId = _notificationStringValue(
    data,
    ['notificationId', 'notification_id', 'notificationid'],
  );
  final entityId = _notificationStringValue(
    data,
    ['entityId', 'entity_id', 'entityid', 'id', 'resource_id', 'slug'],
  );

  final nav = navigatorKey.currentState;
  if (nav == null) return;

  final normalizedRoute = route.trim();
  final normalizedType = type.trim();

  if (normalizedRoute.isNotEmpty) {
    final routeName = normalizedRoute.replaceFirst(RegExp(r'^/'), '').split('?').first;
    final routeValue = routeName.trim().toLowerCase().replaceAll('_', '-');

    if (routeValue == 'news-detail' ||
        routeValue == 'news' ||
        routeValue.startsWith('news-') ||
        routeValue.contains('news')) {
      nav.pushNamed(
        AppRoutes.newsDetail,
        arguments: entityId.isNotEmpty ? entityId : 'news',
      );
      return;
    }

    if (routeValue == 'concours' ||
        routeValue == 'contest' ||
        routeValue == 'concours-detail' ||
        routeValue.contains('concours')) {
      nav.pushNamed(AppRoutes.concours);
      return;
    }

    if (routeValue == 'admission' ||
        routeValue == 'admission-tracking' ||
        routeValue == 'admissiontracking' ||
        routeValue.startsWith('admission') ||
        routeValue.contains('admission')) {
      final requestId = int.tryParse(entityId) ?? 0;
      nav.pushNamed(AppRoutes.admissionTracking, arguments: requestId);
      return;
    }

    if (routeValue == 'registration' ||
        routeValue == 'inscription' ||
        routeValue.contains('registration') ||
        routeValue.contains('inscription')) {
      nav.pushNamed(AppRoutes.registration);
      return;
    }

    if (routeValue == 'notifications' ||
        routeValue == 'notification' ||
        routeValue.contains('notification')) {
      nav.pushNamed('/notifications');
      return;
    }
  }

  switch (normalizedType) {
    case 'NEWS':
      nav.pushNamed(
        AppRoutes.newsDetail,
        arguments: entityId.isNotEmpty ? entityId : 'news',
      );
      return;
    case 'CONCOURS':
      nav.pushNamed(AppRoutes.concours);
      return;
    case 'ADMISSION':
    case 'ADMISSION_DECISION':
      final requestId = int.tryParse(entityId) ?? 0;
      nav.pushNamed(AppRoutes.admissionTracking, arguments: requestId);
      return;
    case 'INSCRIPTION':
      nav.pushNamed(AppRoutes.registration);
      return;
    case 'SYSTEM':
      nav.pushNamed('/notifications');
      return;
  }

  if (notificationId.isNotEmpty || entityId.isNotEmpty) {
    nav.pushNamed('/notifications');
    return;
  }

  nav.pushNamed('/notifications');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EAMAU',
      navigatorKey: navigatorKey,
      //home: const DetailConcoursScreen(concoursId: 1),
      //home: const SuiviCandidatureScreen(candidatureId: 1)
      //home: const AdmissionScreen(),
      initialRoute: AppRoutes.splash,
      routes: AppPages.routes,
    );
  }
}
