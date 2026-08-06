import 'package:flutter/material.dart';

class RegistrationStepper extends StatelessWidget {
  final int currentStep;

  const RegistrationStepper({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: List.generate(4, (index) {
          final step = index + 1;
          final isActive = step <= currentStep;
          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: isActive
                          ? const Color(0xFF0F4DA8)
                          : const Color(0xFFE6EDF7),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                if (index < 3) const SizedBox(width: 8),
              ],
            ),
          );
        }),
      ),
    );
  }
}
