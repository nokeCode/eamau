import 'package:flutter/material.dart';

class NewsCategoryTabs extends StatelessWidget {
  const NewsCategoryTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      "Toutes",
      "Université",
      "Recherche",
      "Etudiant",
      "Evenement",
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          bool selected = category == "Toutes";

          return Padding(
            padding: const EdgeInsets.only(right: 24),
            child: Column(
              children: [
                Text(
                  category,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: selected
                        ? FontWeight.w700
                        : FontWeight.w500,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 6),

                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: selected ? 45 : 0,
                  height: 3,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}