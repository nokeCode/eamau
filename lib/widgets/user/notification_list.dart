import 'package:flutter/material.dart';

import '../../models/user/notification_preview_model.dart';
import 'notification_preview_card.dart';

class NotificationList extends StatelessWidget {
  final List<NotificationPreviewModel> notifications;
  final VoidCallback? onSeeAll;
  final ValueChanged<NotificationPreviewModel>? onNotificationTap;

  const NotificationList({
    super.key,
    required this.notifications,
    this.onSeeAll,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF202124),
                  ),
                ),
              ),
              TextButton(
                onPressed: onSeeAll,
                child: const Text(
                  'Voir tout',
                  style: TextStyle(
                    color: Color(0xFF0D47A1),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          if (notifications.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.notifications_none_outlined,
                    size: 42,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Aucune notification',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          else
            ListView.separated(
              itemCount: notifications.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (_, __) =>
              const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final notification = notifications[index];

                return NotificationPreviewCard(
                  notification: notification,
                  onTap: () => onNotificationTap?.call(notification),
                );
              },
            ),
        ],
      ),
    );
  }
}