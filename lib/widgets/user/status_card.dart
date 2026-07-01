import 'package:flutter/material.dart';

import '../../models/user/account_status_model.dart';

class StatusCard extends StatelessWidget {
  final AccountStatusModel status;
  final VoidCallback? onTap;

  const StatusCard({
    super.key,
    required this.status,
    this.onTap,
  });

  IconData _getIcon(String icon) {
    switch (icon) {
      case 'shield':
        return Icons.verified_user_rounded;
      case 'document':
        return Icons.description_outlined;
      case 'school':
        return Icons.school_outlined;
      case 'calendar':
        return Icons.calendar_month_outlined;
      default:
        return Icons.info_outline;
    }
  }

  Color _getBadgeColor(String badge) {
    switch (badge) {
      case 'verified':
        return const Color(0xFF2E7D32);
      case 'pending':
        return const Color(0xFFFF9800);
      case 'rejected':
        return Colors.red;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final badgeColor = _getBadgeColor(status.badge);

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF2FF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                _getIcon(status.icon),
                color: const Color(0xFF0D47A1),
                size: 28,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: badgeColor.withOpacity(.12),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      status.status,
                      style: TextStyle(
                        color: badgeColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    status.description,
                    style: const TextStyle(
                      color: Color(0xFF6D6D6D),
                      fontSize: 14,
                      height: 1.45,
                    ),
                  ),

                  if (status.action.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    Text(
                      status.action,
                      style: const TextStyle(
                        color: Color(0xFF0D47A1),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}