import 'package:flutter/material.dart';

import 'rating_selector.dart';

class EvaluationCriterionCard extends StatelessWidget {
  final String title;
  final int rating;
  final ValueChanged<int> onRatingChanged;

  const EvaluationCriterionCard({
    super.key,
    required this.title,
    required this.rating,
    required this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Color(0xff1C2C5B),
              ),
            ),
          ),
          RatingSelector(
            selectedValue: rating,
            onChanged: onRatingChanged,
          ),
        ],
      ),
    );
  }
}