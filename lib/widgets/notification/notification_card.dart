import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/notification/notification_model.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback? onTap;

  const NotificationCard({
    super.key,
    required this.notification,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFFEAEAEA),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: _backgroundColor(notification.icon),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                _icon(notification.icon),
                color: Colors.white,
                size: 26,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E1E1E),
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    notification.message,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      height: 1.4,
                      fontSize: 13,
                      color: Color(0xFF707070),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatTime(notification.createdAt),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF909090),
                  ),
                ),

                const SizedBox(height: 8),

                if (!notification.isRead)
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Color(0xFF1976D2),
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static String _formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  static IconData _icon(String icon) {
    switch (icon) {
      case 'graduation':
        return Icons.school_rounded;

      case 'document':
        return Icons.description_rounded;

      case 'calendar':
        return Icons.calendar_month_rounded;

      case 'info':
        return Icons.info_rounded;

      case 'community':
        return Icons.groups_rounded;

      case 'file':
        return Icons.folder_rounded;

      default:
        return Icons.notifications_rounded;
    }
  }

  static Color _backgroundColor(String icon) {
    switch (icon) {
      case 'graduation':
        return const Color(0xFF4F8EF7);

      case 'document':
        return const Color(0xFFF4B400);

      case 'calendar':
        return const Color(0xFF34A853);

      case 'info':
        return const Color(0xFFEA4335);

      case 'community':
        return const Color(0xFF8E44AD);

      case 'file':
        return const Color(0xFF16A085);

      default:
        return const Color(0xFF4F8EF7);
    }
  }
}