import 'package:flutter/material.dart';

class TrackingInfoCard extends StatelessWidget {
  final String reference;
  final String date;
  final String status;

  const TrackingInfoCard({
    super.key,
    required this.reference,
    required this.date,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xffEEF4FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Color(0xffDCEAFF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.assignment,
                  color: Color(0xff0B4EA2),
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Numéro de dossier",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      reference,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Date de soumission",
                    ),
                    Text(
                      date,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),

          const SizedBox(height: 24),

          const Text(
            "Statut actuel",
            style: TextStyle(
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 28,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: const Color(0xff0B4EA2),
              borderRadius:
              BorderRadius.circular(30),
            ),
            child: Text(
              status,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}