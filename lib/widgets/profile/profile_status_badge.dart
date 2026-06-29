import 'package:flutter/material.dart';

import '../../constants/profile_colors.dart';

class ProfileStatusBadge extends StatelessWidget {
  final bool active;

  const ProfileStatusBadge({
    super.key,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: active
            ? ProfileColors.activeBg
            : Colors.red.shade50,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.circle,
            size: 10,
            color: active
                ? ProfileColors.active
                : Colors.red,
          ),
          const SizedBox(width: 8),
          Text(
            active
                ? "Compte actif"
                : "Compte inactif",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: active
                  ? ProfileColors.active
                  : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}