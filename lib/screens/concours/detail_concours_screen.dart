import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/concours/concours_detail_model.dart';
import '../../services/concours/concours_detail_service.dart';
import '../../widgets/concours/concours_banner.dart';
import '../../widgets/concours/concours_info_card.dart';
import 'application_form_screen.dart';

class DetailConcoursScreen extends StatefulWidget {
  final int concoursId;

  const DetailConcoursScreen({
    super.key,
    required this.concoursId,
  });

  @override
  State<DetailConcoursScreen> createState() => _DetailConcoursScreenState();
}

class _DetailConcoursScreenState extends State<DetailConcoursScreen> {
  final ConcoursDetailService _service = ConcoursDetailService();

  late Future<ConcoursDetailModel> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.getConcoursDetail(widget.concoursId);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xffF7F8FC),
        body: FutureBuilder<ConcoursDetailModel>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!snapshot.hasData) {
              return const Center(
                child: Text("Impossible de charger le concours."),
              );
            }

            final detail = snapshot.data!;

            return SafeArea(
              top: false,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 120),
                      child: Column(
                        children: [
                          ConcoursBanner(
                            image: detail.image,
                            titre: detail.titre,
                            description: detail.description,
                            onBack: () => Navigator.pop(context),
                          ),

                          const SizedBox(height: 20),

                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: ConcoursInfoCard(
                                        icon: Icons.calendar_month,
                                        title: "Année académique",
                                        value: detail.anneeAcademique,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: ConcoursInfoCard(
                                        icon: Icons.event,
                                        title: "Période d'inscription",
                                        value: detail.periodeInscription,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                Row(
                                  children: [
                                    Expanded(
                                      child: ConcoursInfoCard(
                                        icon: Icons.date_range,
                                        title: "Date de l'examen",
                                        value: detail.dateExamen,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: ConcoursInfoCard(
                                        icon: Icons.school,
                                        title: "Filières concernées",
                                        value: detail.filieres,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                ConcoursInfoCard(
                                  icon: Icons.workspace_premium,
                                  title: "Diplôme requis",
                                  value: detail.diplome,
                                ),

                                const SizedBox(height: 12),

                                ConcoursInfoCard(
                                  icon: Icons.rule,
                                  title: "Condition de participation",
                                  value:
                                  "Consulter les conditions et critères d'éligibilité",
                                  expandable: true,
                                  items: [detail.conditions],
                                ),

                                const SizedBox(height: 12),

                                ConcoursInfoCard(
                                  icon: Icons.description_outlined,
                                  title: "Pièce à fournir",
                                  value:
                                  "Liste des documents obligatoires à joindre",
                                  expandable: true,
                                  items: detail.piecesAFournir,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                      child: SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff1E4DB7),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          // Navigation vers l'ecran de candidature de concours
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ApplicationFormScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.upload_outlined),
                          label: const Text(
                            "Déposer une candidature",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
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