import 'account_status_model.dart';
import 'notification_preview_model.dart';
import 'profile_completion_model.dart';

class DashboardUserModel {
  final String firstName;
  final String lastName;
  final String avatar;
  final String program;
  final String academicYear;

  final ProfileCompletionModel profileCompletion;
  final List<AccountStatusModel> statuses;
  final List<NotificationPreviewModel> notifications;

  const DashboardUserModel({
    required this.firstName,
    required this.lastName,
    required this.avatar,
    required this.program,
    required this.academicYear,
    required this.profileCompletion,
    required this.statuses,
    required this.notifications,
  });

  factory DashboardUserModel.fromJson(Map<String, dynamic> json) {
    return DashboardUserModel(
      firstName: json['firstName'] ?? 'Jean',
      lastName: json['lastName'] ?? 'Bakary',
      avatar: json['avatar'] ?? '',
      program: json['program'] ?? 'Gestion urbaine',
      academicYear: json['academicYear'] ?? 'Licence 2 • 2024-2025',
      profileCompletion: ProfileCompletionModel.fromJson(
        json['profileCompletion'] ?? {},
      ),
      statuses: (json['statuses'] as List? ?? [])
          .map((e) => AccountStatusModel.fromJson(e))
          .toList(),
      notifications: (json['notifications'] as List? ?? [])
          .map((e) => NotificationPreviewModel.fromJson(e))
          .toList(),
    );
  }

  static DashboardUserModel fallback() {
    return DashboardUserModel(
      firstName: 'Jean',
      lastName: 'Bakary',
      avatar: '',
      program: 'Gestion urbaine',
      academicYear: 'Licence 2 • 2024-2025',
      profileCompletion: ProfileCompletionModel.fallback(),
      statuses: AccountStatusModel.fallback(),
      notifications: NotificationPreviewModel.fallback(),
    );
  }
}