import 'package:flutter/material.dart';

class AdmissionSectionTitle extends StatelessWidget {
  final String title;

  const AdmissionSectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 18,
        bottom: 10,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            color: Color(0xff0B4EA2),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}