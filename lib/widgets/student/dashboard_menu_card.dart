import 'package:flutter/material.dart';

import '../../models/student/menu_item_model.dart';



class DashboardMenuCard extends StatelessWidget {
  final MenuItemModel item;
  final VoidCallback? onTap;

  const DashboardMenuCard({
    super.key,
    required this.item,
    this.onTap,
  });

  IconData _getIcon(String icon) {
    switch (icon) {
      case 'description':
        return Icons.description_outlined;
      case 'bar_chart':
        return Icons.bar_chart_rounded;
      case 'calendar_month':
        return Icons.calendar_month_outlined;
      case 'groups':
        return Icons.groups_outlined;
      case 'article':
        return Icons.article_outlined;
      default:
        return Icons.grid_view_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.grey.shade200,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: const Color(0xFFEAF2FF),
              child: Icon(
                _getIcon(item.icon),
                color: const Color(0xFF1546B0),
                size: 24,
              ),
            ),

            const Spacer(),

            Text(
              item.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              item.subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}