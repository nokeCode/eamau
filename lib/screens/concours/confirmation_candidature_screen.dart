import 'package:eamau/screens/concours/suivi_candidature_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../services/concours/confirmation_candidature_service.dart';
import '../../services/concours/concours_form_service.dart';
import '../../models/concours/confirmation_candidature_model.dart';
import '../../widgets/concours/confirmation_action_button.dart';
import '../../widgets/concours/confirmation_success_widget.dart';

class ConfirmationCandidatureScreen extends StatefulWidget {
  final String candidatureId;
  final String postulationToken;

  const ConfirmationCandidatureScreen({
    super.key,
    required this.candidatureId,
    required this.postulationToken,
  });

  @override
  State<ConfirmationCandidatureScreen> createState() =>
      _ConfirmationCandidatureScreenState();
}

class _ConfirmationCandidatureScreenState
    extends State<ConfirmationCandidatureScreen> {
  final ConfirmationCandidatureService _service =
      ConfirmationCandidatureService();
  final ConcoursFormService _concoursFormService = ConcoursFormService();

  late Future<ConfirmationCandidatureModel> _future;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _future = _service.getConfirmation(widget.candidatureId);
  }

  Future<void> _confirmSubmission() async {
    if (_isSubmitting) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await _concoursFormService.submit(
        widget.candidatureId,
        postulationToken: widget.postulationToken,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Candidature confirmée avec succès.')),
      );
      final candidatureId = int.tryParse(widget.candidatureId) ?? 0;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => SuiviCandidatureScreen(candidatureId: candidatureId),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
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
              Image.asset("assets/logos/eamau_logo.gif", width: 55),
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
              const Icon(Icons.menu, color: Colors.white, size: 34),
            ],
          ),
        ),
        body: FutureBuilder<ConfirmationCandidatureModel>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final data = snapshot.data ?? fallbackConfirmation;

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  children: [
                    const Spacer(),

                    ConfirmationSuccessWidget(
                      title: "Candidature enregistrée",
                      message: data.message,
                    ),

                    const SizedBox(height: 60),

                    ConfirmationActionButton(
                      text: "Confirmer ma candidature",
                      icon: Icons.check_circle_outline,
                      onPressed: _isSubmitting
                          ? null
                          : () {
                              _confirmSubmission();
                            },
                    ),

                    const SizedBox(height: 18),

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
                        final candidatureId =
                            int.tryParse(widget.candidatureId) ?? 0;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SuiviCandidatureScreen(
                              candidatureId: candidatureId,
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
                          backgroundColor: const Color(0xffEEF2FF),
                          foregroundColor: const Color(0xff1E4DB7),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.popUntil(context, (route) => route.isFirst);
                        },
                        icon: const Icon(Icons.home_outlined),
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
