import 'package:flutter/material.dart';

import '../../core/ui/auto_refresh_mixin.dart';
import '../../models/registration/registration_summary_model.dart';
import '../../services/registration/registration_service.dart';

/// Shows the authenticated user's own past registrations ("inscriptions")
/// on the student dashboard. Renders nothing when there are none, so it
/// doesn't clutter the dashboard for a student with no registration history.
class RegistrationHistorySection extends StatefulWidget {
  const RegistrationHistorySection({super.key});

  @override
  State<RegistrationHistorySection> createState() => _RegistrationHistorySectionState();
}

class _RegistrationHistorySectionState extends State<RegistrationHistorySection>
    with AutoRefreshMixin<RegistrationHistorySection> {
  List<RegistrationSummaryModel> _registrations = const [];
  bool _loading = true;

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
    final registrations = await RegistrationService().listMyRegistrations();
    if (!mounted) return;
    setState(() {
      _registrations = registrations;
      _loading = false;
    });
  }

  String _statusLabel(String? rawStatus) {
    final normalized = rawStatus?.toLowerCase().trim() ?? '';
    switch (normalized) {
      case 'draft':
      case 'brouillon':
        return 'Brouillon';
      case 'pending_sync':
        return 'Synchronisation en cours';
      case 'submitted':
      case 'soumise':
        return 'Soumise';
      case 'validated':
      case 'validee':
      case 'validée':
        return 'Validée';
      case 'rejected':
      case 'refusee':
      case 'refusée':
        return 'Refusée';
      default:
        return rawStatus?.isNotEmpty == true ? rawStatus! : 'Statut inconnu';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _registrations.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Historique de mes inscriptions',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 10),
          ..._registrations.map(
            (registration) => Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.description_outlined, color: Color(0xFF0D4B9C)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          registration.schoolYear != null
                              ? 'Année scolaire ${registration.schoolYear}'
                              : 'Inscription${registration.id != null ? ' #${registration.id}' : ''}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _statusLabel(registration.status),
                          style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
