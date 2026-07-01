import 'package:flutter/material.dart';

import '../../models/user/notification_preview_model.dart';

class NotificationPreviewCard extends StatelessWidget {
  final NotificationPreviewModel notification;
  final VoidCallback? onTap;

  const NotificationPreviewCard({
    super.key,
    required this.notification,
    this.onTap,
  });

  IconData _getIcon(String icon) {
    switch (icon) {
      case 'school':
        return Icons.school_outlined;
      case 'description':
        return Icons.description_outlined;
      case 'calendar':
        return Icons.calendar_month_outlined;
      case 'person':
        return Icons.person_outline;
      default:
        return Icons.notifications_none_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF2FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getIcon(notification.icon),
                color: const Color(0xFF0D47A1),
                size: 24,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF202124),
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    notification.subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF8A8A8A),
                    ),
                  ),
                ],
              ),
            ),

            if (notification.unread)
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Color(0xFF0D47A1),
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}