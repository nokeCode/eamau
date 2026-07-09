import 'package:flutter/material.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;

  const StepIndicator({
    super.key,
    required this.currentStep,
  });

  Color _color(int step) {
    if (step <= currentStep) {
      return const Color(0xff1E4DB7);
    }
    return Colors.grey.shade400;
  }

  Widget _circle(int step) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: _color(step),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          "$step",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _line(int step) {
    return Expanded(
      child: Container(
        height: 2,
        color: step < currentStep
            ? const Color(0xff1E4DB7)
            : Colors.grey.shade400,
      ),
    );
  }

  Widget _label(
      String text,
      int step,
      ) {
    return Expanded(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          fontWeight:
          step == currentStep ? FontWeight.bold : FontWeight.w500,
          color:
          step == currentStep ? const Color(0xff1E4DB7) : Colors.grey,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 18,
      ),
      child: Column(
        children: [
          Row(
            children: [
              _circle(1),
              _line(1),
              _circle(2),
              _line(2),
              _circle(3),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              _label("Informations", 1),
              _label("Documents", 2),
              _label("Validation", 3),
            ],
          ),
        ],
      ),
    );
  }
}