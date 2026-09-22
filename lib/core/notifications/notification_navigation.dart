import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';

/// Returns the first non-empty value found in [data] for any of [keys],
/// trying each in order — field naming isn't consistent across the
/// notification payloads this app receives (FCM data, REST notification
/// list...), so callers pass every plausible spelling instead of guessing
/// a single one.
String notificationStringValue(
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

/// Where a notification (from either a tapped push notification or a tap in
/// the in-app notification list — same routing either way, so this is the
/// single place both paths defer to) should take the user, based on its
/// `type`/`route`/`entityId`. Falls back to the notification list itself
/// when nothing more specific is known.
void navigateToNotificationTarget(
  NavigatorState nav, {
  required String type,
  required String route,
  required String entityId,
  required String notificationId,
}) {
  final normalizedRoute = route.trim();
  final normalizedType = type.trim().toUpperCase();

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
