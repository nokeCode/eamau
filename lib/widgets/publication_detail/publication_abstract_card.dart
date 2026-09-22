import 'package:flutter/material.dart';

class PublicationAbstractCard extends StatelessWidget {
  final String abstractText;

  const PublicationAbstractCard({
    super.key,
    required this.abstractText,
  });

  @override
  Widget build(BuildContext context) {
    if (abstractText.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: const Border(
          left: BorderSide(
            color: Color(0xFF162D6B),
            width: 4,
          ),
          top: BorderSide(color: Color(0xFFE2E8F0)),
          right: BorderSide(color: Color(0xFFE2E8F0)),
          bottom: BorderSide(color: Color(0xFFE2E8F0)),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF162D6B).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.article_outlined,
                  color: Color(0xFF162D6B),
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'RÉSUMÉ / ABSTRACT',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.1,
                  color: Color(0xFF162D6B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            abstractText,
            textAlign: TextAlign.justify,
            style: const TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Color(0xFF334155),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
