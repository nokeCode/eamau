import 'package:flutter/material.dart';


import '../../models/student/dashboard_notification_model.dart';
import 'notification_tile.dart';

class NotificationSection extends StatelessWidget {
  final List<DashboardNotificationModel> notifications;
  final VoidCallback? onSeeAll;
  final void Function(DashboardNotificationModel notification)? onTap;

  const NotificationSection({
    super.key,
    required this.notifications,
    this.onSeeAll,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: onSeeAll,
                child: const Text(
                  'Voir tout',
                  style: TextStyle(
                    color: Color(0xFF1546B0),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: notifications
                .map(
                  (notification) => NotificationTile(
                notification: notification,
                onTap: () => onTap?.call(notification),
              ),
            )
                .toList(),
          ),
        ),
      ],
    );
  }
}