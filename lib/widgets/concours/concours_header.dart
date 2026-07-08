import 'package:flutter/material.dart';

class ConcoursHeader extends StatelessWidget {
  final VoidCallback? onBackPressed;
  final VoidCallback? onNotificationPressed;

  const ConcoursHeader({
    super.key,
    this.onBackPressed,
    this.onNotificationPressed,
  });

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return SizedBox(
      height: 175 + statusBarHeight,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/building_bg.jpg',
            fit: BoxFit.cover,
          ),

          Container(
            color: const Color(0xFF1565C0).withOpacity(0.82),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              statusBarHeight + 16,
              20,
              20,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: onBackPressed,
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    const Expanded(
                      child: Text(
                        "Concours",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: onNotificationPressed,
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.notifications_none_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Découvrez les concours disponibles pour intégrer\nl'EAMAU",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}