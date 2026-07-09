import 'package:eamau/screens/concours/suivi_candidature_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../services/concours/confirmation_candidature_service.dart';
import '../../models/concours/confirmation_candidature_model.dart';
import '../../widgets/concours/confirmation_action_button.dart';
import '../../widgets/concours/confirmation_success_widget.dart';

class ConfirmationCandidatureScreen extends StatefulWidget {
  final int candidatureId;

  const ConfirmationCandidatureScreen({
    super.key,
    required this.candidatureId,
  });

  @override
  State<ConfirmationCandidatureScreen> createState() =>
      _ConfirmationCandidatureScreenState();
}

class _ConfirmationCandidatureScreenState
    extends State<ConfirmationCandidatureScreen> {
  final ConfirmationCandidatureService _service =
  ConfirmationCandidatureService();

  late Future<ConfirmationCandidatureModel> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.getConfirmation(widget.candidatureId);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0xff1565C0),
          elevation: 0,
          automaticallyImplyLeading: false,
          toolbarHeight: 85,
          title: Row(
            children: [
              Image.asset(
                "assets/logos/eamau_logo.gif",
                width: 55,
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  "EAMAU",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Icon(
                Icons.menu,
                color: Colors.white,
                size: 34,
              ),
            ],
          ),
        ),
        body: FutureBuilder<ConfirmationCandidatureModel>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final data = snapshot.data ?? fallbackConfirmation;

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                ),
                child: Column(
                  children: [
                    const Spacer(),

                    ConfirmationSuccessWidget(
                      title: "Candidature enregistrée",
                      message: data.message,
                    ),

                    const SizedBox(height: 60),

                    ConfirmationActionButton(
                      text: "Télécharger l'attestation",
                      icon: Icons.download_outlined,
                      onPressed: () {
                        // téléchargement attestation
                      },
                    ),

                    const SizedBox(height: 18),

                    ConfirmationActionButton(
                      text: "Consulter le statut",
                      icon: Icons.alt_route,
                      outlined: true,
                      onPressed: () {
                        // Aller vers SuiviCandidatureScreen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                            const SuiviCandidatureScreen(
                              candidatureId: 1,
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 18),

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          const Color(0xffEEF2FF),
                          foregroundColor:
                          const Color(0xff1E4DB7),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.popUntil(
                            context,
                                (route) => route.isFirst,
                          );
                        },
                        icon: const Icon(
                          Icons.home_outlined,
                        ),
                        label: const Text(
                          "Retour à l'accueil",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),

                    const Spacer(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}