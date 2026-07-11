import 'package:flutter/material.dart';
import '../../widgets/admission/admission_request_button.dart';
import '../../widgets/admission/admission_request_button.dart';
import '../../widgets/admission/conditions_documents_list.dart';
import '../../widgets/admission/conditions_header.dart';
import '../../widgets/admission/conditions_intro.dart';
import '../../widgets/admission/conditions_section_card.dart';

class AdmissionConditionsScreen extends StatelessWidget {
  const AdmissionConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      body: SafeArea(
        child: Column(
          children: [
            const ConditionsHeader(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ConditionsIntro(),

                    const ConditionsSectionCard(
                      icon: Icons.school_outlined,
                      title: "Diplômes éligibles",
                      subtitle:
                      "Consultez la liste des diplômes autorisés pour chaque programme.",
                    ),

                    const ConditionsSectionCard(
                      icon: Icons.menu_book_outlined,
                      title: "Programmes disponibles",
                      subtitle:
                      "Explorez les programmes disponibles à l'EAMAU.",
                    ),

                    const ConditionsSectionCard(
                      icon: Icons.description_outlined,
                      title: "Document requis",
                      subtitle:
                      "Préparez les documents nécessaires à votre candidature.",
                      initiallyExpanded: true,
                      children: [
                        ConditionsDocumentsList(),
                      ],
                    ),

                    const ConditionsSectionCard(
                      icon: Icons.verified_user_outlined,
                      title: "Critères de sélection",
                      subtitle:
                      "Informez-vous sur les critères d'évaluation des candidatures.",
                    ),

                    AdmissionRequestButton(
                      onPressed: () {
                        // Navigator.pushNamed(
                        //   context,
                        //   AppRoutes.admissionRequest,
                        // );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}