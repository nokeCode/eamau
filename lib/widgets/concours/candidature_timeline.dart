import 'package:flutter/material.dart';

import '../../models/concours/suivi_candidature_model.dart';

class CandidatureTimeline extends StatelessWidget {
  final List<SuiviEtapeModel> etapes;

  const CandidatureTimeline({
    super.key,
    required this.etapes,
  });

  String _formatDate(BuildContext context, String value) {
    final date = DateTime.tryParse(value);
    if (date == null) return value;
    return MaterialLocalizations.of(context).formatMediumDate(date.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
        children: List.generate(
          etapes.length,
              (index) {
            final etape = etapes[index];
            final isLast = index == etapes.length - 1;

            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: etape.completed
                              ? const Color(0xff1E4DB7)
                              : Colors.white,
                          border: Border.all(
                            color: etape.completed
                                ? const Color(0xff1E4DB7)
                                : Colors.grey.shade400,
                            width: 2,
                          ),
                        ),
                        child: etape.completed
                            ? const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 18,
                        )
                            : null,
                      ),
                      if (!isLast)
                        Expanded(
                          child: Container(
                            width: 2,
                            color: etape.completed
                                ? const Color(0xff1E4DB7)
                                : Colors.grey.shade300,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            etape.titre,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff1B315E),
                            ),
                          ),
                          if (etape.description.isNotEmpty) ...[
                            const SizedBox(height: 5),
                            Text(
                              etape.description,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                          if (etape.date.isNotEmpty) ...[
                            const SizedBox(height: 5),
                            Text(
                              _formatDate(context, etape.date),
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
