import 'package:flutter/material.dart';

import '../models/notification/notification_model.dart';
import '../services/notification/notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationService _service = NotificationService();

  List<NotificationModel> _notifications = [];

  bool _isLoading = false;
  bool _showUnreadOnly = false;

  List<NotificationModel> get notifications {
    if (_showUnreadOnly) {
      return _notifications.where((e) => !e.isRead).toList();
    }

    return _notifications;
  }

  bool get isLoading => _isLoading;

  bool get showUnreadOnly => _showUnreadOnly;

  int get unreadCount =>
      _notifications.where((e) => !e.isRead).length;

  Future<void> loadNotifications() async {
    _isLoading = true;
    notifyListeners();

    _notifications = await _service.getNotifications();

    _notifications.sort(
          (a, b) => b.createdAt.compareTo(a.createdAt),
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    await loadNotifications();
  }

  void showAll() {
    _showUnreadOnly = false;
    notifyListeners();
  }

  void showUnread() {
    _showUnreadOnly = true;
    notifyListeners();
  }

  Future<void> markAsRead(int id) async {
    final index =
    _notifications.indexWhere((e) => e.id == id);

    if (index == -1) return;

    if (_notifications[index].isRead) return;

    _notifications[index] = _notifications[index].copyWith(
      isRead: true,
    );

    notifyListeners();

    await _service.markAsRead(id);
  }

  Future<void> markAllAsRead() async {
    _notifications = _notifications
        .map(
          (e) => e.copyWith(
        isRead: true,
      ),
    )
        .toList();

    notifyListeners();

    await _service.markAllAsRead();
  }

  List<NotificationModel> get todayNotifications {
    final now = DateTime.now();

    return notifications.where((notification) {
      return notification.createdAt.year == now.year &&
          notification.createdAt.month == now.month &&
          notification.createdAt.day == now.day;
    }).toList();
  }

  List<NotificationModel> get weekNotifications {
    final now = DateTime.now();

    return notifications.where((notification) {
      final difference =
          now.difference(notification.createdAt).inDays;

      return difference > 0 && difference <= 7;
    }).toList();
  }
}