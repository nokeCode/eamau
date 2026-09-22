import 'package:flutter/material.dart';

import '../../models/notification/notification_model.dart';
import '../../models/student/dashboard_model.dart';
import '../../models/student/dashboard_notification_model.dart';
import '../../models/student/menu_item_model.dart';
import '../../models/student/quick_stat_model.dart';
import '../../routes/app_routes.dart';
import '../../services/notification/notification_service.dart';
import '../../services/profile/profile_service.dart';
import '../../services/registration/registration_service.dart';

/// Builds the student dashboard from real, already-working backend calls
/// (profile, registrations, notifications) instead of the previous
/// `DashboardService.getDashboard()`, which hit a bare relative URL with no
/// base configured (`http.get(Uri.parse('api/user/dashboard'))`) and always
/// silently fell back to hardcoded mock data.
///
/// The menu only lists items that genuinely go somewhere real today
/// ("Actualités" → NewsScreen). "Mes résultats" and "Calendrier académique"
/// have no backend or screen at all yet; "Évaluation des enseignants" has a
/// built screen but no registered route and a mock-only service (a
/// hardcoded placeholder domain). None of those are faked here — they're
/// simply left out until there's something real behind them.
class DashboardProvider extends ChangeNotifier {
  final ProfileService _profileService = ProfileService();
  final RegistrationService _registrationService = RegistrationService();
  final NotificationService _notificationService = NotificationService();

  DashboardModel? _dashboard;
  bool _isLoading = false;
  String? _error;

  DashboardModel? get dashboard => _dashboard;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadDashboard() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Started concurrently (each call begins executing up to its own
      // first `await` immediately), then awaited in turn — no need for
      // `Future.wait` across mismatched return types just to run them
      // in parallel.
      final profileFuture = _profileService.getProfile();
      final registrationsFuture = _registrationService.listMyRegistrations();
      final unreadCountFuture = _notificationService.getUnreadCount();
      final notificationsFuture = _notificationService.getNotifications(limit: 5);

      final profile = await profileFuture;
      final registrations = await registrationsFuture;
      final unreadCount = await unreadCountFuture;
      final notifications = await notificationsFuture;

      _dashboard = DashboardModel(
        firstName: profile.firstName.isNotEmpty ? profile.firstName : profile.fullName,
        matricule: profile.matricule,
        quickStats: [
          QuickStatModel(
            title: 'Inscriptions',
            subtitle: 'au total',
            count: registrations.length,
            icon: 'description',
            color: '#DCEEFF',
          ),
          QuickStatModel(
            title: 'Notifications',
            subtitle: 'non lues',
            count: unreadCount,
            icon: 'notifications',
            color: '#FFF7C9',
          ),
        ],
        menu: const [
          MenuItemModel(
            title: 'Actualités',
            subtitle: 'Nouvelles et\nannonces',
            icon: 'article',
            route: AppRoutes.news,
          ),
        ],
        notifications: notifications.map(_toDashboardNotification).toList(),
      );
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  DashboardNotificationModel _toDashboardNotification(NotificationModel notification) {
    return DashboardNotificationModel(
      title: notification.title,
      message: notification.message,
      icon: notification.icon,
      time: _relativeTime(notification.createdAt),
      unread: !notification.isRead,
    );
  }

  String _relativeTime(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 1) return "À l'instant";
    if (diff.inMinutes < 60) return 'Il y a ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Il y a ${diff.inHours} h';
    if (diff.inDays < 7) return 'Il y a ${diff.inDays} j';
    return 'Il y a ${(diff.inDays / 7).floor()} sem';
  }

  Future<void> refresh() async {
    await loadDashboard();
  }
}
