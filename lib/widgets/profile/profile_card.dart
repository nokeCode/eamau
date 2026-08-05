import 'package:flutter/material.dart';

import '../../constants/profile_colors.dart';
import '../../constants/profile_sizes.dart';

import '../../models/profile/user_model.dart';
import 'profile_avatar.dart';
import 'profile_button.dart';
import 'profile_status_badge.dart';

class ProfileCard extends StatelessWidget {
  final UserModel user;
  final VoidCallback onEdit;

  const ProfileCard({
    super.key,
    required this.user,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [

        Container(
          margin: const EdgeInsets.only(top: 50),
          padding: const EdgeInsets.fromLTRB(
            22,
            60,
            22,
            22,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              ProfileSizes.cardRadius,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.06),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [

              Text(
                user.fullName.isNotEmpty
                    ? user.fullName
                    : user.email.isNotEmpty
                        ? user.email
                        : (user.username.isNotEmpty ? user.username : 'Utilisateur'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: ProfileColors.text,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                user.department.isNotEmpty
                    ? user.department
                    : user.username.isNotEmpty
                        ? user.username
                        : 'Profil utilisateur',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  color: ProfileColors.subtitle,
                ),
              ),

              const SizedBox(height: 18),

              ProfileStatusBadge(
                active: user.active,
              ),

              const SizedBox(height: 25),

              ProfileButton(
                onPressed: onEdit,
              ),
            ],
          ),
        ),

        Positioned(
          top: 0,
          child: ProfileAvatar(
            imageUrl: user.avatar,
          ),
        ),
      ],
    );
  }
}