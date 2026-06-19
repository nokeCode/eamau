import 'package:flutter/material.dart';

class AdmissionBanner extends StatelessWidget {
  const AdmissionBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              'assets/images/building.jpg',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFF173B7A),
                  Color(0xAA173B7A),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'ADMISSIONS 2025-2026',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                const Text(
                  'Construisez\nvotre avenir\navec EAMAU',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Excellence académique,\nleadership de demain.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),

                const Spacer(),

                ElevatedButton(
                  onPressed: () {},

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),

                  child: const Text(
                    'En savoir plus',
                  ),
                ),
              ],
            ),
          ),

          const Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                CircleAvatar(
                  radius: 3,
                  backgroundColor: Colors.white,
                ),

                SizedBox(width: 5),

                CircleAvatar(
                  radius: 3,
                  backgroundColor: Colors.white54,
                ),

                SizedBox(width: 5),

                CircleAvatar(
                  radius: 3,
                  backgroundColor: Colors.white54,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}