import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  void _reload() {
    setState(() {
      _future = _service.getSuivi(widget.reference);
    });
  }

  String _formatDate(BuildContext context, String value) {
    final date = DateTime.tryParse(value);
    if (date == null) return value;
    return MaterialLocalizations.of(context).formatMediumDate(date.toLocal());
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

            if (snapshot.hasError || !snapshot.hasData) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline, size: 48),
                      const SizedBox(height: 16),
                      Text(
                        snapshot.error?.toString() ??
                            'Aucune donnée de suivi disponible.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        onPressed: _reload,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Réessayer'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final suivi = snapshot.data!;

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
                          dateSoumission:
                              _formatDate(context, suivi.dateSoumission),
                          dateExamen: _formatDate(context, suivi.dateExamen),
                          statut: suivi.statutActuel,
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
