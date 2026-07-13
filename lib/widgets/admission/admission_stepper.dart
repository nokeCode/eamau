import 'package:flutter/material.dart';

class AdmissionStepper extends StatelessWidget {
  final int currentStep;

  const AdmissionStepper({
    super.key,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
      child: Row(
        children: [
          Expanded(
            child: _step(
              index: 1,
              title: "Informations",
              active: currentStep >= 1,
              completed: currentStep > 1,
            ),
          ),

          Expanded(
            child: _line(currentStep >= 2),
          ),

          Expanded(
            child: _step(
              index: 2,
              title: "Documents",
              active: currentStep >= 2,
              completed: currentStep > 2,
            ),
          ),

          Expanded(
            child: _line(currentStep >= 3),
          ),

          Expanded(
            child: _step(
              index: 3,
              title: "Validation",
              active: currentStep >= 3,
              completed: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _line(bool active) {
    return Container(
      height: 3,
      color: active
          ? const Color(0xff0B4EA2)
          : Colors.grey.shade300,
    );
  }

  Widget _step({
    required int index,
    required String title,
    required bool active,
    required bool completed,
  }) {
    return Column(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active
                ? const Color(0xff0B4EA2)
                : Colors.grey.shade400,
          ),
          child: Center(
            child: completed
                ? const Icon(
              Icons.check,
              color: Colors.white,
              size: 18,
            )
                : Text(
              "$index",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            color: active
                ? const Color(0xff0B4EA2)
                : Colors.grey,
            fontWeight:
            active ? FontWeight.w600 : FontWeight.normal,
          ),
        )
      ],
    );
  }
}