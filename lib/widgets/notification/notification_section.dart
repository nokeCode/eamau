import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/notification/notification_model.dart';
import '../../providers/notification_provider.dart';
import 'notification_card.dart';

class NotificationSection extends StatelessWidget {
  final String title;
  final List<NotificationModel> notifications;

  const NotificationSection({
    super.key,
    required this.title,
    required this.notifications,
  });

  @override
  Widget build(BuildContext context) {
    if (notifications.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: 12,
          ),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E1E1E),
            ),
          ),
        ),

        ListView.builder(
          itemCount: notifications.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemBuilder: (context, index) {
            final notification = notifications[index];

            return NotificationCard(
              notification: notification,
              onTap: () async {
                await context
                    .read<NotificationProvider>()
                    .markAsRead(notification.id);

                // Ici tu pourras ajouter plus tard
                // une navigation vers un détail
                // selon le type de notification.
              },
            );
          },
        ),
      ],
    );
  }
}