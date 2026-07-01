import 'package:flutter/material.dart';

import '../../models/student/quick_stat_model.dart';

class QuickStatCard extends StatelessWidget {
  final QuickStatModel stat;

  const QuickStatCard({
    super.key,
    required this.stat,
  });

  IconData _getIcon(String icon) {
    switch (icon) {
      case 'description':
        return Icons.description_outlined;
      case 'notifications':
        return Icons.notifications_none_rounded;
      case 'edit_square':
        return Icons.edit_square;
      default:
        return Icons.info_outline;
    }
  }

  Color _getColor(String color) {
    switch (color) {
      case '#DCEEFF':
        return const Color(0xFFDCEEFF);
      case '#FFF7C9':
        return const Color(0xFFFFF7C9);
      case '#DDF8DD':
        return const Color(0xFFDDF8DD);
      default:
        return Colors.grey.shade100;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 115,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _getColor(stat.color),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white,
            child: Icon(
              _getIcon(stat.icon),
              color: const Color(0xFF1546B0),
              size: 20,
            ),
          ),

          const Spacer(),

          Text(
            stat.count.toString(),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            stat.title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            stat.subtitle,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}