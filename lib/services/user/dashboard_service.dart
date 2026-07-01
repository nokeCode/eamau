import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/user/account_status_model.dart';
import '../../models/user/dashboard_user_model.dart';
import '../../models/user/notification_preview_model.dart';
import '../../models/user/profile_completion_model.dart';

class DashboardService {
  DashboardService();

  /// À remplacer plus tard
  static const String baseUrl = 'https://your-api.com/api';

  static const String endpoint = '$baseUrl/user';

  Future<DashboardUserModel> getDashboard() async {
    try {
      final response = await http.get(
        Uri.parse(endpoint),
        headers: const {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer \$token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> json =
        jsonDecode(response.body) as Map<String, dynamic>;

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

      return DashboardUserModel.fallback();
    } catch (_) {
      return DashboardUserModel.fallback();
    }
  }
}