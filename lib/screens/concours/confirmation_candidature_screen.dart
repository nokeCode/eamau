import 'package:eamau/screens/concours/suivi_candidature_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../services/concours/concours_form_service.dart';
import '../../core/connectivity/connectivity_service.dart';
import '../../data/local/postulation_local_datasource.dart';
import '../../core/sync/sync_engine.dart';
import '../../core/sync/sync_queue.dart' as sq;
import '../../core/database/app_database.dart';
import 'package:uuid/uuid.dart';
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
  final ConcoursFormService _concoursFormService = ConcoursFormService();

  bool _isSubmitting = false;

  Future<void> _confirmSubmission() async {
    if (_isSubmitting) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final online = await (ConnectivityService().isOnline());
      if (!online) {
        // Enqueue submission and mark draft pending_sync
        try {
          final dbLocal = PostulationLocalDatasource();
          // find local draft by remoteId
          // attempt to find a draft matching this remote id
            final all = await dbLocal.getAllDrafts();
            PostulationDraft? draft;
            if (all.isNotEmpty) {
              draft = all.firstWhere(
                (d) => d.remoteId == widget.candidatureId,
                orElse: () => all.first,
              );
            } else {
              draft = null;
            }
            if (draft != null) {
              final opId = const Uuid().v4();
              final op = sq.SyncOperation(
                clientOperationId: opId,
                type: 'postulation.submit',
                payload: {'draftId': draft.id},
              );
              await SyncEngine().enqueueOperation(op);
              await dbLocal.updateDraftStatus(draft.id, 'pending_sync');
            }
        } catch (_) {}

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Candidature mise en attente et sera soumise à la reconnexion.'),
        ));
        Navigator.pop(context);
        return;
      }

      // Online: perform immediate submission
      final result = await _concoursFormService.submit(
        widget.candidatureId,
        postulationToken: widget.postulationToken,
      );

      final data = result['data'];
      if (data is! Map) {
        throw Exception('La réponse de soumission est invalide.');
      }

      final reference = data['reference']?.toString() ?? '';
      if (reference.isEmpty) {
        throw Exception('La référence de candidature est absente.');
      }

      final message = result['message']?.toString() ??
          'Candidature confirmée avec succès.';

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => SuiviCandidatureScreen(reference: reference),
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
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                const Spacer(),

                const ConfirmationSuccessWidget(
                  title: "Candidature enregistrée",
                  message:
                      "Votre dossier est prêt. Confirmez sa soumission pour obtenir votre référence.",
                ),

                const SizedBox(height: 60),

                ConfirmationActionButton(
                  text: "Confirmer ma candidature",
                  icon: Icons.check_circle_outline,
                  onPressed: _isSubmitting ? null : _confirmSubmission,
                ),

                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
