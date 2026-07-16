import 'package:flutter/material.dart';

class TrackingHeader extends StatelessWidget {
  final VoidCallback? onNotification;

  const TrackingHeader({
    super.key,
    this.onNotification,
  });

  @override
  Widget build(BuildContext context) {
    final statusBar = MediaQuery.of(context).padding.top;

    return SizedBox(
      height: 120 + statusBar,
      child: Stack(
        children: [
          Container(
            height: 120 + statusBar,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff0F5BD7),
                  Color(0xff0B4EA2),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 14,
              ),
              child: Row(
                children: [
                  Image.asset(
                    "assets/logos/eamau_logo.gif",
                    width: 46,
                  ),

                  const SizedBox(width: 12),

                  const Expanded(
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          "EAMAU",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "École Africaine des Métiers\nde l'Architecture et de l'Urbanisme",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ),

                  IconButton(
                    onPressed: onNotification,
                    icon: const Icon(
                      Icons.notifications_none,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}