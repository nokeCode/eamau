import 'package:flutter/material.dart';

import '../../models/user/dashboard_user_model.dart';
import 'profile_completion_card.dart';

class WelcomeCard extends StatelessWidget {
  final DashboardUserModel user;
  final VoidCallback? onCompleteProfile;

  const WelcomeCard({
    super.key,
    required this.user,
    this.onCompleteProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0D2E87),
            Color(0xFF1E4BB8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  backgroundImage: user.avatar.isNotEmpty
                      ? NetworkImage(user.avatar)
                      : null,
                  child: user.avatar.isEmpty
                      ? const Icon(
                    Icons.person,
                    size: 35,
                    color: Colors.grey,
                  )
                      : null,
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bienvenue,',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),

                      Text(
                        '${user.firstName} ${user.lastName}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        'Étudiant en ${user.program}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 2),

                      Text(
                        user.academicYear,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          ProfileCompletionCard(
            profile: user.profileCompletion,
            onPressed: onCompleteProfile,
          ),
        ],
      ),
    );
  }
}