import 'package:flutter/material.dart';

class EvaluationCommentField extends StatelessWidget {
  final TextEditingController controller;

  const EvaluationCommentField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Commentaire',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Color(0xff1C2C5B),
          ),
        ),

        const SizedBox(height: 8),

        TextField(
          controller: controller,
          maxLines: 5,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            hintText: 'Votre avis ...',
            hintStyle: const TextStyle(
              color: Colors.grey,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
              ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(14),
              ),
              borderSide: BorderSide(
                color: Color(0xff174A97),
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}