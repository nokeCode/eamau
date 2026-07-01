import 'package:flutter/material.dart';

import '../notification/notification_bell.dart';

class DashboardHeader extends StatelessWidget {
  final String logoPath;
  final int notificationCount;
  final VoidCallback? onNotificationTap;

  const DashboardHeader({
    super.key,
    required this.logoPath,
    this.notificationCount = 0,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
      child: Row(
        children: [
          Image.asset(
            logoPath,
            height: 48,
            fit: BoxFit.contain,
          ),

          const Spacer(),

          Stack(
            clipBehavior: Clip.none,
            children: [
              InkWell(
                onTap: onNotificationTap,
                borderRadius: BorderRadius.circular(20),
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: NotificationBell(
                    iconColor: Colors.white,
                    iconSize: 28,
                  ),
                ),
              ),

              if (notificationCount > 0)
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: const BoxDecoration(
                      color: Color(0xFF1E88E5),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      notificationCount > 99
                          ? '99+'
                          : notificationCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}