import 'package:flutter/material.dart';

class ConditionsDocumentsList extends StatelessWidget {
  const ConditionsDocumentsList({super.key});

  static const List<String> documents = [
    "Copie certifiée du diplôme le plus élevé",
    "Relevés de notes officiels",
    "Pièce d'identité valide",
    "Lettre de motivation",
    "Curriculum vitæ à jour",
    "Attestation ou certificats (si applicables)",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: documents
          .map(
            (document) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 2),
                child: Icon(
                  Icons.description_outlined,
                  color: Color(0xFF1E73E8),
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  document,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF333333),
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        ),
      )
          .toList(),
    );
  }
}