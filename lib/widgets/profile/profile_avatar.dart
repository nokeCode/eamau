import 'package:flutter/material.dart';

import '../../constants/profile_colors.dart';
import '../../constants/profile_sizes.dart';

class ProfileAvatar extends StatelessWidget {
  final String imageUrl;

  const ProfileAvatar({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ProfileSizes.avatar,
      height: ProfileSizes.avatar,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 4,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.12),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipOval(
        child: imageUrl.isNotEmpty
            ? Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) {
            return _fallbackAvatar();
          },
        )
            : _fallbackAvatar(),
      ),
    );
  }

  Widget _fallbackAvatar() {
    return Container(
      color: ProfileColors.primary.withOpacity(.08),
      child: const Icon(
        Icons.person,
        size: 55,
        color: ProfileColors.primary,
      ),
    );
  }
}