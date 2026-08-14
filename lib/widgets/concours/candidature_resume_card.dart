import 'package:flutter/material.dart';

class CandidatureResumeCard extends StatelessWidget {
  final String nomComplet;
  final String programme;
  final String dateSoumission;
  final String dateExamen;
  final String statut;

  const CandidatureResumeCard({
    super.key,
    required this.nomComplet,
    required this.programme,
    required this.dateSoumission,
    required this.dateExamen,
    required this.statut,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Résumé de la candidature",
            style: TextStyle(
              color: Color(0xff1565C0),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 24),

          _buildRow("Nom complet", nomComplet),

          const Divider(height: 32),

          _buildRow("Programme", programme),

          const Divider(height: 32),

          _buildRow(
            "Date de soumission",
            dateSoumission,
          ),

          if (dateExamen.isNotEmpty) ...[
            const Divider(height: 32),
            _buildRow("Date d'examen", dateExamen),
          ],

          const Divider(height: 32),

          Row(
            children: [
              const Expanded(
                child: Text(
                  "Statut actuel",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xffE8F1FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statut,
                  style: const TextStyle(
                    color: Color(0xff1E4DB7),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRow(
      String label,
      String value,
      ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
