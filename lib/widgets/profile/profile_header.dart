import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/profile_colors.dart';

class ProfileHeader extends StatelessWidget {
  final VoidCallback? onMenu;
  final VoidCallback? onNotification;

  const ProfileHeader({
    super.key,
    this.onMenu,
    this.onNotification,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: ProfileColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(35),
          bottomRight: Radius.circular(35),
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: .10,
              child: Image.asset(
                "assets/images/building_bg1.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),

          Positioned(
            top: 0,
            left: 0,
            child: IgnorePointer(
              child: SvgPicture.asset(
                "assets/images/login_waveshap_haut.svg",
                width: MediaQuery.of(context).size.width * .45,
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: onMenu,
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.menu,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      const Spacer(),

                      Image.asset(
                        "assets/logos/eamau_logo.gif",
                        height: 52,
                      ),

                      const Spacer(),

                      InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: onNotification,
                        child: Stack(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(.15),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.notifications_none,
                                color: Colors.white,
                              ),
                            ),
                            Positioned(
                              right: 7,
                              top: 7,
                              child: Container(
                                width: 9,
                                height: 9,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  const Text(
                    "Mon Profil",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Consultez et modifiez vos informations personnelles",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(.85),
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}