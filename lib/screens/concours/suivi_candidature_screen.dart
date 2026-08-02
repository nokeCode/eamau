import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/concours/suivi_candidature_model.dart';
import '../../services/concours/suivi_candidature_service.dart';
import '../../widgets/concours/candidature_resume_card.dart';
import '../../widgets/concours/candidature_timeline.dart';

class SuiviCandidatureScreen extends StatefulWidget {
  final String reference;

  const SuiviCandidatureScreen({super.key, required this.reference});

  @override
  State<SuiviCandidatureScreen> createState() => _SuiviCandidatureScreenState();
}

class _SuiviCandidatureScreenState extends State<SuiviCandidatureScreen> {
  final SuiviCandidatureService _service = SuiviCandidatureService();

  late Future<SuiviCandidatureModel> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.getSuivi(widget.reference);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: const Color(0xffF4F7FC),
        body: FutureBuilder<SuiviCandidatureModel>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final suivi = snapshot.data ?? fallbackSuivi;

            return Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/building_bg.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(
                      20,
                      MediaQuery.of(context).padding.top + 20,
                      20,
                      22,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(30, 77, 183, 0.82),
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(30),
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(23),
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        const SizedBox(width: 18),

                        const Expanded(
                          child: Text(
                            "Suivi de candidature",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                            ),
                          ),
                        ),

                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(23),
                          ),
                          child: const Icon(
                            Icons.notifications_none,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      children: [
                        CandidatureTimeline(etapes: suivi.etapes),
                        const SizedBox(height: 20),
                        CandidatureResumeCard(
                          nomComplet: suivi.nomComplet,
                          programme: suivi.programme,
                          dateSoumission: suivi.dateSoumission,
                          statut: suivi.statutActuel,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff1565C0),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () async {
                              final messenger = ScaffoldMessenger.of(context);
                              final attestationUrl =
                                  suivi.attestationUrl.isNotEmpty
                                  ? suivi.attestationUrl
                                  : 'https://www.eamau.org/attestation.pdf';
                              final uri = Uri.parse(attestationUrl);
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(
                                  uri,
                                  mode: LaunchMode.externalApplication,
                                );
                              } else {
                                if (!mounted) return;
                                messenger.showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Impossible d\'ouvrir le lien de l\'attestation.',
                                    ),
                                  ),
                                );
                              }
                            },
                            icon: const Icon(Icons.download_outlined),
                            label: const Text(
                              'Télécharger l\'attestation',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 2,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xff1E4DB7),
          unselectedItemColor: Colors.black54,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: "Accueil",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.work_outline),
              label: "Emplois",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.alt_route),
              label: "Suivi",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school_outlined),
              label: "Mes études",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: "Profil",
            ),
          ],
          onTap: (index) {
            // Navigation
          },
        ),
      ),
    );
  }
}
