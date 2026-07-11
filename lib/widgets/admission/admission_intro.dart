import 'package:flutter/material.dart';

class AdmissionIntro extends StatelessWidget {
  const AdmissionIntro({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Admission",
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: Color(0xFF123D7A),
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Découvrez les différentes voies d'admission à\nl'EAMAU et vérifiez votre éligibilité",
            style: TextStyle(
              fontSize: 15,
              height: 1.4,
              color: Color(0xFF9A9A9A),
            ),
          ),
        ],
      ),
    );
  }
}