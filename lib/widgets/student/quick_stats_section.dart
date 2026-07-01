import 'package:flutter/material.dart';


import '../../models/student/quick_stat_model.dart';
import 'quick_stat_card.dart';

class QuickStatsSection extends StatelessWidget {
  final List<QuickStatModel> stats;

  const QuickStatsSection({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Aperçu rapide',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 16),

        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: stats.length,
            itemBuilder: (context, index) {
              return QuickStatCard(
                stat: stats[index],
              );
            },
          ),
        ),
      ],
    );
  }
}