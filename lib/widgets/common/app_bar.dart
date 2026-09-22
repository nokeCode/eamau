import 'package:flutter/material.dart';

import '../notification/notification_bell.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final bool showLogo;
  final Color? backgroundColor;
  final Color? textColor;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.showLogo = false,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: backgroundColor ?? Colors.white,
      surfaceTintColor: backgroundColor ?? Colors.white,
      centerTitle: false,
      automaticallyImplyLeading: false,
      toolbarHeight: 70,
      
      leading: showBackButton
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black87,
                size: 22,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          : null,

      titleSpacing: 0,
      
      title: Row(
        children: [
          if (showLogo) ...[
            Image.asset(
              'assets/logos/eamau_logo.gif',
              height: 42,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 10),
          ],
          Text(
            title,
            style: TextStyle(
              color: textColor ?? const Color(0xFF0D4B9C),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),

      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 12),
          child: NotificationBell(
            iconColor: Colors.black87,
            iconSize: 28,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
