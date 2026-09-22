import 'package:flutter/material.dart';

import '../../core/ui/auto_refresh_mixin.dart';
import '../../data/local/admission_local_datasource.dart';
import '../../data/local/postulation_local_datasource.dart';
import '../../data/remote/admission_remote_datasource.dart';
import '../../data/repositories/admission_repository.dart';
import '../../routes/app_routes.dart';
import '../../screens/concours/suivi_candidature_screen.dart';
import '../../services/admission/admission_request_service.dart';
import '../../services/concours/suivi_candidature_service.dart';

/// Shows "track my request" shortcuts on a dashboard screen when the user
/// has a submitted admission request and/or a submitted concours
/// postulation. Renders nothing when there's neither.
///
/// Tries the authoritative server-side "my requests"/"my postulations"
/// lists first (`GET /admission/requests`, `GET /postulations` — both
/// scoped to the authenticated user). Falls back to this device's local
/// SQLite drafts (AdmissionDrafts / PostulationDrafts) when offline, the
/// call fails, or nothing comes back from the server — so a submission
/// made moments ago and not yet synced still shows up immediately.
class TrackingShortcutsBanner extends StatefulWidget {
  const TrackingShortcutsBanner({super.key});

  @override
  State<TrackingShortcutsBanner> createState() => _TrackingShortcutsBannerState();
}

class _TrackingShortcutsBannerState extends State<TrackingShortcutsBanner>
    with AutoRefreshMixin<TrackingShortcutsBanner> {
  int? _admissionRequestId;
  String? _postulationReference;

  @override
  void initState() {
    super.initState();
    _load();
    startAutoRefresh();
  }

  @override
  void dispose() {
    stopAutoRefresh();
    super.dispose();
  }

  @override
  Future<void> onAutoRefresh() => _load();

  Future<void> _load() async {
    final admissionRequestId = await _loadLatestAdmissionRequestId();
    final postulationReference = await _loadLatestPostulationReference();

    if (!mounted) return;
    setState(() {
      _admissionRequestId = admissionRequestId;
      _postulationReference = postulationReference;
    });
  }

  Future<int?> _loadLatestAdmissionRequestId() async {
    try {
      final remote = await AdmissionRequestService().listMyRequests();
      final submitted = remote.where((r) => r.isSubmitted).toList()
        ..sort((a, b) => (b.submittedAt ?? '').compareTo(a.submittedAt ?? ''));
      if (submitted.isNotEmpty) return submitted.first.id;
    } catch (_) {
      // fall through to the local check below
    }

    final admissionRepo = AdmissionRepository(
      local: AdmissionLocalDatasource(),
      remote: AdmissionRemoteDatasource(),
    );
    final drafts = await admissionRepo.getLocalDrafts();
    final submittedLocal = drafts
        .where((d) => d.status == 'submitted' && d.remoteId != null)
        .toList()
      ..sort((a, b) => (b.updatedAt ?? DateTime(0)).compareTo(a.updatedAt ?? DateTime(0)));
    return submittedLocal.isNotEmpty ? submittedLocal.first.remoteId : null;
  }

  Future<String?> _loadLatestPostulationReference() async {
    try {
      final remote = await SuiviCandidatureService().listMine();
      final submitted = remote.where((p) => p.isSubmitted).toList()
        ..sort((a, b) => (b.submittedAt ?? '').compareTo(a.submittedAt ?? ''));
      if (submitted.isNotEmpty) return submitted.first.reference;
    } catch (_) {
      // fall through to the local check below
    }

    final drafts = await PostulationLocalDatasource().getAllDrafts();
    final submittedLocal = drafts
        .where((d) => d.status == 'submitted' && (d.reference ?? '').isNotEmpty)
        .toList()
      ..sort((a, b) => (b.updatedAt ?? DateTime(0)).compareTo(a.updatedAt ?? DateTime(0)));
    return submittedLocal.isNotEmpty ? submittedLocal.first.reference : null;
  }

  @override
  Widget build(BuildContext context) {
    if (_admissionRequestId == null && _postulationReference == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Vos démarches en cours',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 10),
          if (_admissionRequestId != null)
            _TrackingButton(
              icon: Icons.assignment_turned_in_outlined,
              label: 'Suivre ma demande d’admission',
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.admissionTracking,
                  arguments: _admissionRequestId,
                );
              },
            ),
          if (_admissionRequestId != null && _postulationReference != null)
            const SizedBox(height: 10),
          if (_postulationReference != null)
            _TrackingButton(
              icon: Icons.fact_check_outlined,
              label: 'Suivre ma candidature au concours',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SuiviCandidatureScreen(reference: _postulationReference!),
                  ),
                );
              },
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _TrackingButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _TrackingButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: const Color(0xFF0D4B9C)),
        label: Text(label, style: const TextStyle(color: Color(0xFF0D4B9C))),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          side: const BorderSide(color: Color(0xFFBFDBFE)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
