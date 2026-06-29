import 'package:flutter/material.dart';

import 'notification_bell.dart';

class NotificationAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const NotificationAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      centerTitle: false,
      automaticallyImplyLeading: false,
      toolbarHeight: 70,

      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.black87,
          size: 22,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),

      titleSpacing: 0,

      title: Row(
        children: [
          Image.asset(
            'assets/logos/eamau_logo.gif',
            height: 42,
            fit: BoxFit.contain,
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