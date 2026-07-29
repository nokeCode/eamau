// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:eamau/main.dart';
import 'package:provider/provider.dart';
import 'package:eamau/providers/auth_provider.dart';
import 'package:eamau/providers/notification_provider.dart';
import 'package:eamau/providers/student/dashboard_provider.dart';
import 'package:eamau/providers/admission_tracking_provider.dart';

void main() {
  testWidgets('App builds and shows splash', (WidgetTester tester) async {
    // Build our app with the same providers as in main and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => NotificationProvider()),
          ChangeNotifierProvider(create: (_) => DashboardProvider()),
          ChangeNotifierProvider(create: (_) => AdmissionTrackingProvider()),
        ],
        child: const MyApp(),
      ),
    );

    // Splash screen contains the app title
    expect(find.text('EAMAU'), findsOneWidget);

    // Let the splash timer complete to avoid pending timers
    await tester.pump(const Duration(seconds: 3));
  });
}
