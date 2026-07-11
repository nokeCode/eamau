import 'package:flutter/material.dart';

class AdmissionHeader extends StatelessWidget {
  final VoidCallback? onBack;
  final VoidCallback? onNotification;

  const AdmissionHeader({
    super.key,
    this.onBack,
    this.onNotification,
  });

  @override
  Widget build(BuildContext context) {
    final double statusBar = MediaQuery.of(context).padding.top;

    return SizedBox(
      height: 180 + statusBar,
      child: Stack(
        children: [
          // Fond bleu
          Container(
            height: 180 + statusBar,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF2E5CB8),
                  Color(0xFF3F6ED4),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Image de fond
          Positioned.fill(
            child: Opacity(
              opacity: 0.12,
              child: Image.asset(
                'assets/images/building_bg.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Overlay
          Container(
            height: 180 + statusBar,
            color: Colors.blue.withOpacity(.15),
          ),

          // Boutons
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 14,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _circleButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: onBack ??
                            () {
                          Navigator.pop(context);
                        },
                  ),
                  _circleButton(
                    icon: Icons.notifications_none_rounded,
                    onTap: onNotification,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleButton({
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(40),
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFF1D4DB5).withOpacity(.85),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 22,
        ),
      ),
    );
  }
}