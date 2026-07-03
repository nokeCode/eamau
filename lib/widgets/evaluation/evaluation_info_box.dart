import 'package:flutter/material.dart';

class EvaluationInfoBox extends StatelessWidget {
  const EvaluationInfoBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xffEDF6FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xffD6E9FF),
        ),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            color: Color(0xff19A7E0),
            size: 24,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "Cette évaluation est anonyme et contribue à l'amélioration de la qualité de l'enseignement.",
              style: TextStyle(
                fontSize: 13,
                color: Color(0xff6B7A90),
              ),
            ),
          ),
        ],
      ),
    );
  }
}