import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'core/notifications/notification_navigation.dart';
import 'providers/admission_provider.dart';
import 'providers/admission_tracking_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/news_provider.dart';
import 'providers/registration/registration_provider.dart';
import 'providers/student/dashboard_provider.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'core/database/app_database.dart';
import 'core/sync/sync_engine.dart';

const _pushChannel = AndroidNotificationChannel(
  'eamau_channel',
  'EAMAU Notifications',
  description: 'Channel for EAMAU push notifications',
  importance: Importance.max,
);

/// FCM messages come in two shapes: a "notification message" (has a
/// `notification` block the OS/plugin can read directly) and a "data-only
/// message" (only `data`, no `notification` block — the app has to build
/// its own local notification from whatever fields the backend put in
/// `data`). The app only ever handled the first shape: both the foreground
/// listener and the background handler below used to silently do nothing
/// for a data-only push, since they only acted when `message.notification`
/// was non-null. That's exactly why a backend-sent notification could show
/// up in the in-app notification list (a separate REST fetch) while never
/// producing an actual system push. Field names are read defensively since
/// there's no confirmed sample of what the backend puts in `data` for this.
(String title, String body) _extractTitleAndBody(RemoteMessage message) {
  final notification = message.notification;
  final title = notification?.title?.trim().isNotEmpty == true
      ? notification!.title!
      : notificationStringValue(message.data, ['title', 'notificationTitle']);
  final body = notification?.body?.trim().isNotEmpty == true
      ? notification!.body!
      : notificationStringValue(message.data, ['body', 'message', 'notificationBody']);
  return (title, body);
}

Map<String, dynamic> _buildNotificationPayload(RemoteMessage message) {
  return {
    'type': notificationStringValue(
      message.data,
      ['type', 'notificationType', 'notification_type'],
    ),
    'notificationId': notificationStringValue(
      message.data,
      ['notificationId', 'notification_id', 'notificationid'],
    ),
    'entityId': notificationStringValue(
      message.data,
      ['entityId', 'entity_id', 'entityid', 'id', 'resource_id', 'slug'],
    ),
    'route': notificationStringValue(
      message.data,
      ['route', 'deepLink', 'deeplink'],
    ),
    'raw': message.data,
  };
}

Future<void> _showLocalNotification(
  RemoteMessage message,
  FlutterLocalNotificationsPlugin plugin,
) async {
  final (title, body) = _extractTitleAndBody(message);
  if (title.isEmpty && body.isEmpty) return;

  const androidDetails = AndroidNotificationDetails(
    'eamau_channel',
    'EAMAU Notifications',
    channelDescription: 'Channel for EAMAU push notifications',
    importance: Importance.max,
    priority: Priority.high,
  );
  const details = NotificationDetails(
    android: androidDetails,
    iOS: DarwinNotificationDetails(),
  );

  await plugin.show(
    message.hashCode,
    title.isNotEmpty ? title : null,
    body.isNotEmpty ? body : null,
    details,
    payload: jsonEncode(_buildNotificationPayload(message)),
  );
}

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
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings();

    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
    );
    final androidPlugin = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(_pushChannel);
    // Belt-and-suspenders alongside FirebaseMessaging.requestPermission()
    // above: explicitly ask for Android 13+'s POST_NOTIFICATIONS at the
    // plugin level too, since that's what actually gates whether
    // flutterLocalNotificationsPlugin.show() has any effect at all.
    final grantedNotifications = await androidPlugin?.requestNotificationsPermission();
    debugPrint('Android POST_NOTIFICATIONS granted: $grantedNotifications');

    // Foreground messages: show a local notification. Handles both a
    // "notification message" (message.notification present) and a
    // data-only message (title/body read from message.data instead) — see
    // _extractTitleAndBody for why this matters.
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint("Notification reçue (foreground): data=${message.data}");
      await _showLocalNotification(message, flutterLocalNotificationsPlugin);
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

  // Initialize local database before providers that may access it
  await AppDatabase.init();
  SyncEngine().start();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => NewsProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => AdmissionProvider()),
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

  debugPrint('Background message received: ${message.messageId} data=${message.data}');

  // A "notification message" (message.notification present) is already
  // auto-displayed by the OS/FCM SDK while the app isn't in the foreground —
  // showing it again here would duplicate it. This handler previously did
  // nothing beyond logging for EVERY message, on the assumption the system
  // always takes care of display ("rely on system notification when
  // provided") — true only for that case. A data-only message (no
  // `notification` block, e.g. what a backend event might send when it
  // wants the app to decide how to render it) is never auto-displayed by
  // anything, so it silently never appeared as a push at all.
  if (message.notification != null) return;

  final plugin = FlutterLocalNotificationsPlugin();
  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const iosSettings = DarwinInitializationSettings();
  await plugin.initialize(
    const InitializationSettings(android: androidSettings, iOS: iosSettings),
  );
  await plugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(_pushChannel);

  await _showLocalNotification(message, plugin);
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void _handleNavigationFromMessage(RemoteMessage message) {
  final nav = navigatorKey.currentState;
  if (nav == null) return;

  final data = message.data;
  navigateToNotificationTarget(
    nav,
    type: notificationStringValue(
      data,
      ['type', 'notificationType', 'notification_type'],
    ),
    route: notificationStringValue(
      data,
      ['route', 'deepLink', 'deeplink'],
    ),
    entityId: notificationStringValue(
      data,
      ['entityId', 'entity_id', 'entityid', 'id', 'resource_id', 'slug'],
    ),
    notificationId: notificationStringValue(
      data,
      ['notificationId', 'notification_id', 'notificationid'],
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
      navigatorKey: navigatorKey,
      //home: const DetailConcoursScreen(concoursId: 1),
      //home: const SuiviCandidatureScreen(candidatureId: 1)
      //home: const AdmissionScreen(),
      initialRoute: AppRoutes.splash,
      routes: AppPages.routes,
    );
  }
}
