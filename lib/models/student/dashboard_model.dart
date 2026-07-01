import 'dashboard_notification_model.dart';
import 'menu_item_model.dart';
import 'quick_stat_model.dart';

class DashboardModel {
  final String firstName;
  final String matricule;

  final List<QuickStatModel> quickStats;
  final List<MenuItemModel> menu;
  final List<DashboardNotificationModel> notifications;

  const DashboardModel({
    required this.firstName,
    required this.matricule,
    required this.quickStats,
    required this.menu,
    required this.notifications,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      firstName: json['firstName'] ?? '',
      matricule: json['matricule'] ?? '',
      quickStats:
      (json['quickStats'] as List<dynamic>? ?? [])
          .map(
            (e) => QuickStatModel.fromJson(
          e as Map<String, dynamic>,
        ),
      )
          .toList(),
      menu:
      (json['menu'] as List<dynamic>? ?? [])
          .map(
            (e) => MenuItemModel.fromJson(
          e as Map<String, dynamic>,
        ),
      )
          .toList(),
      notifications:
      (json['notifications'] as List<dynamic>? ?? [])
          .map(
            (e) => DashboardNotificationModel.fromJson(
          e as Map<String, dynamic>,
        ),
      )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'matricule': matricule,
      'quickStats': quickStats.map((e) => e.toJson()).toList(),
      'menu': menu.map((e) => e.toJson()).toList(),
      'notifications':
      notifications.map((e) => e.toJson()).toList(),
    };
  }
}