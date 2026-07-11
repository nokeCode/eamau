import 'package:flutter/material.dart';
import '../../widgets/admission/admission_card.dart';
import '../../widgets/admission/admission_header.dart';
import '../../widgets/admission/admission_intro.dart';
import '../../widgets/admission/admission_bottom_nav.dart';

class AdmissionScreen extends StatelessWidget {
  const AdmissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final admissions = [
      {
        "title": "Admission en\npremière année",
        "description":
        "Cette voie s'adresse aux bacheliers souhaitant intégrer l'EAMAU en première année de formation.",
        "eligibility":
        "Être titulaire d'un baccalauréat ou d'un diplôme équivalent reconnu.",
        "image": "assets/images/admission1.png",
      },
      {
        "title": "Admission par passerelle\n(à partir de L2,...)",
        "description":
        "Cette voie permet aux étudiants d'intégrer l'EAMAU à un niveau avancé selon leur parcours académique.",
        "eligibility":
        "Être titulaire d'un diplôme universitaire (DEUG, Licence, etc.) ou équivalent.",
        "image": "assets/images/admission2.png",
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),

      body: Column(
        children: [
          AdmissionHeader(
            onNotification: () {},
          ),
          Expanded(
            child: Container(
              transform: Matrix4.translationValues(0, -45, 0),
              decoration: const BoxDecoration(
                color: Color(0xFFF7F9FC),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const AdmissionIntro(),

                    ...admissions.map(
                          (item) => AdmissionCard(
                        title: item["title"]!,
                        description: item["description"]!,
                        eligibility: item["eligibility"]!,
                        image: item["image"]!,
                        onTap: () {},
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: const AdmissionBottomNav(),
    );
  }
}