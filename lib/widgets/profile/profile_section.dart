import 'package:flutter/material.dart';

import '../../constants/profile_colors.dart';
import '../../constants/profile_sizes.dart';
import '../../models/profile/user_model.dart';
import 'profile_info_tile.dart';

class ProfileSection extends StatelessWidget {
  final UserModel user;

  const ProfileSection({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(
        ProfileSizes.pagePadding,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          ProfileSizes.cardRadius,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.person_outline,
                color: ProfileColors.primary,
              ),
              SizedBox(width: 10),
              Text(
                "Informations Personnelles",
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: ProfileColors.text,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          ProfileInfoTile(
            icon: Icons.person_outline,
            title: "Nom complet",
            value: user.fullName,
          ),

          ProfileInfoTile(
            icon: Icons.cake_outlined,
            title: "Date de naissance",
            value: user.birthDate,
          ),

          ProfileInfoTile(
            icon: Icons.email_outlined,
            title: "Adresse e-mail",
            value: user.email,
          ),

          ProfileInfoTile(
            icon: Icons.phone_outlined,
            title: "Téléphone",
            value: user.phone,
          ),

          ProfileInfoTile(
            icon: Icons.location_on_outlined,
            title: "Adresse",
            value: user.address,
          ),

          ProfileInfoTile(
            icon: Icons.school_outlined,
            title: "Niveau d'étude",
            value: user.level,
          ),

          ProfileInfoTile(
            icon: Icons.architecture_outlined,
            title: "Filière",
            value: user.department,
            showDivider: false,
          ),
        ],
      ),
    );
  }
}