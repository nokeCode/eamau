import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/ui/auto_refresh_mixin.dart';
import '../providers/auth_provider.dart';
import '../providers/registration/registration_provider.dart';
import '../models/registration/registration_status_model.dart';
import '../core/database/app_database.dart' as adb;
import '../data/local/admission_local_datasource.dart';
import '../data/remote/admission_remote_datasource.dart';
import '../data/repositories/admission_repository.dart';
import '../screens/admission/admission_request_screen.dart';
import '../screens/login_screen.dart';
import '../widgets/common/main_bottom_navigation.dart';
import '../widgets/home/home_header.dart';
import '../widgets/home/search_bar_widget.dart';
import '../widgets/home/admission_banner.dart';
import '../widgets/home/menu_card.dart';
import '../routes/app_routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutoRefreshMixin<HomeScreen> {
  bool _showAdmissionOptions = false;
  adb.AdmissionDraft? _pendingAdmissionDraft;
  int? _pendingAdmissionCampaignId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RegistrationProvider>().loadRegistrationStatus();
      // AuthProvider.user (role, account status...) is only ever refreshed
      // from the backend at login/2FA/register/app-cold-start, or by
      // tapping the bottom nav's "Dashboard" tab — nothing on this screen
      // used to trigger it. That's exactly why an account validated on the
      // admin side mid-session (no re-login) kept showing as unvalidated
      // here: `needsAccountValidation` was reading a stale in-memory value.
      // This is opportunistic (ignored if it fails, e.g. offline); the
      // registration-card tap below does its own authoritative refresh
      // right before deciding, so this alone isn't load-bearing for
      // correctness — it just makes the common case feel current already.
      context.read<AuthProvider>().loadCurrentUser();
    });
    _loadPendingAdmissionDraft();
    startAutoRefresh();
  }

  @override
  void dispose() {
    stopAutoRefresh();
    super.dispose();
  }

  @override
  Future<void> onAutoRefresh() async {
    await context.read<RegistrationProvider>().loadRegistrationStatus();
    if (!mounted) return;
    await context.read<AuthProvider>().loadCurrentUser();
    if (!mounted) return;
    await _loadPendingAdmissionDraft();
  }

  /// Looks for a local admission draft that was never actually submitted
  /// (the "submitted" status is only reached once admission.submit truly
  /// succeeds — see SyncEngine). Runs every time the home screen loads, i.e.
  /// every app reopen, so the reminder to finish it is never tied to a
  /// specific screen/navigation path: fill it partway, close the app,
  /// come back whenever — it's still there. Also re-run periodically (see
  /// onAutoRefresh) so the banner clears itself once that draft actually
  /// gets submitted in the background, instead of lingering until the next
  /// full app restart.
  Future<void> _loadPendingAdmissionDraft() async {
    final repository = AdmissionRepository(
      local: AdmissionLocalDatasource(),
      remote: AdmissionRemoteDatasource(),
    );
    final drafts = await repository.getLocalDrafts();
    final pending = drafts.where((d) => d.status != 'submitted').toList()
      ..sort(
        (a, b) => (b.updatedAt ?? DateTime(0)).compareTo(a.updatedAt ?? DateTime(0)),
      );
    if (!mounted) return;

    if (pending.isEmpty) {
      if (_pendingAdmissionDraft != null) {
        setState(() {
          _pendingAdmissionDraft = null;
          _pendingAdmissionCampaignId = null;
        });
      }
      return;
    }

    final draft = pending.first;
    int? campaignId;
    try {
      final decoded = jsonDecode(draft.dataJson);
      if (decoded is Map && decoded['campaignId'] is int) {
        campaignId = decoded['campaignId'] as int;
      }
    } catch (_) {
      // corrupt/legacy draft data: nothing to resume it with, skip silently
    }
    if (campaignId == null || !mounted) return;

    setState(() {
      _pendingAdmissionDraft = draft;
      _pendingAdmissionCampaignId = campaignId;
    });
  }

  Widget _buildAdmissionResumeBanner() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.assignment_outlined, color: Color(0xFF0D4B9C)),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Continuer votre demande d’admission',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Vous avez une demande en cours. Vous pouvez la laisser de côté '
            'et la reprendre quand vous le souhaitez.',
            style: TextStyle(color: Colors.black54, fontSize: 13),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AdmissionRequestScreen(
                      campaignId: _pendingAdmissionCampaignId!,
                      resumeDraftId: _pendingAdmissionDraft!.id,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D4B9C),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text(
                'Continuer ma demande d’admission',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final registrationProvider = context.watch<RegistrationProvider>();
    final registrationStatus = registrationProvider.registrationStatus;
    final showRegistrationButton =
        registrationStatus?.open == true &&
        registrationStatus?.canCreate == true;

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),

          child: Column(
            children: [
              const HomeHeader(),

              const SizedBox(height: 20),

              if (_pendingAdmissionDraft != null && _pendingAdmissionCampaignId != null)
                _buildAdmissionResumeBanner(),

              const SearchBarWidget(),

              const SizedBox(height: 20),

              const AdmissionBanner(),

              const SizedBox(height: 20),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),

                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.7,

                children: [
                  if (registrationProvider.isRegistrationStatusLoading)
                    _buildRegistrationSkeletonCard()
                  else
                    _buildRegistrationMenuCard(
                      showRegistrationButton,
                      registrationStatus,
                    ),
                  MenuCard(
                    icon: Icons.newspaper_outlined,
                    title: 'Actualité',
                    subtitle:
                        'Restez informé des dernières nouvelles et événements.',
                    color: const Color(0xFF1682F8),
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.news);
                    },
                  ),

                  MenuCard(
                    icon: Icons.school,
                    title: 'Filière',
                    subtitle: 'Découvrez nos formations et nos parcours.',
                    color: const Color(0xFF1682F8),
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.filiere);
                    },
                  ),

                  MenuCard(
                    icon: Icons.assignment,
                    title: 'Admission',
                    subtitle: 'Procédures et dossiers pour rejoindre EAMAU.',
                    color: const Color(0xFF1682F8),
                    onTap: () {
                      setState(() {
                        _showAdmissionOptions = !_showAdmissionOptions;
                      });
                    },
                  ),

                  MenuCard(
                    icon: Icons.help,
                    title: 'FAQ',
                    subtitle:
                        'Trouvez rapidement les réponses à vos questions.',
                    color: const Color(0xFF1682F8),
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.faq);
                    },
                  ),

                  MenuCard(
                    icon: Icons.calendar_month,
                    title: 'Dates Clés',
                    subtitle: 'Calendrier académique et échéances.',
                    color: const Color(0xFF0D4B9C),
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.keyDates);
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),
              if (_showAdmissionOptions)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F7FF),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFB6D1FF),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Options Admission',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0D4B9C),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 190,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: MenuCard(
                                icon: Icons.school,
                                title: 'Admission par Concours',
                                subtitle:
                                    'Accéder aux procédures et candidatures de concours.',
                                color: const Color(0xFF1682F8),
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.concours,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: MenuCard(
                                icon: Icons.swap_horiz,
                                title: 'Admission par passerelle',
                                subtitle:
                                    'Suivez la procédure pour l’admission par passerelle.',
                                color: const Color(0xFF1682F8),
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.admission,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 20),

              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.about);
                },
                child: Container(
                  padding: const EdgeInsets.all(16),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),

                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                  ),

                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.account_balance, size: 40),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "À propos d'EAMAU",
                              style: TextStyle(
                                color: const Color(0xFF1682F8),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              "Une institution d'excellence engagée pour la formation de leaders responsables et innovants.",
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),

                      Icon(Icons.chevron_right, color: const Color(0xFF1682F8)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),

      bottomNavigationBar: MainBottomNavigationBar(currentIndex: 0),
    );
  }


  Widget _buildRegistrationSkeletonCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            height: 16,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 140,
            height: 14,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const Spacer(),
          Container(
            width: double.infinity,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegistrationMenuCard(
    bool showRegistrationButton,
    RegistrationStatus? registrationStatus,
  ) {
    final isOpen = showRegistrationButton;
    return Container(
      decoration: BoxDecoration(
        color: isOpen ? const Color(0xFF0D4B9C) : const Color(0xFF64748B),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isOpen
              ? () async {
                  final authProvider = context.read<AuthProvider>();
                  if (!authProvider.isLoggedIn) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Color(0xFFD97706),
                        content: Text("Vous n'êtes pas connecté"),
                      ),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LoginScreen(
                          redirectRoute: AppRoutes.registration,
                          infoMessage: "Vous n'êtes pas connecté",
                        ),
                      ),
                    );
                    return;
                  }

                  // AuthProvider.user is only refreshed at login/2FA/
                  // register/cold-start otherwise, so it can easily be
                  // stale by the time this is tapped (e.g. an admin
                  // validated the account minutes ago, mid-session). Refresh
                  // right before deciding instead of trusting whatever's
                  // already in memory, so a just-validated account isn't
                  // blocked by data that's simply out of date.
                  await authProvider.loadCurrentUser();
                  if (!mounted) return;

                  if (authProvider.user?.needsAccountValidation == true) {
                    // A validated account is required before requesting a
                    // registration — mirrors ProfileScreen's own "Demande de
                    // validation" card, which is where the user needs to go.
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Color(0xFFD97706),
                        content: Text(
                          "Votre compte n'est pas validé. Demandez une validation de compte depuis votre profil.",
                        ),
                        duration: Duration(seconds: 5),
                      ),
                    );
                  } else {
                    Navigator.pushNamed(context, AppRoutes.registration);
                  }
                }
              : null,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.app_registration_outlined,
                  color: Colors.white,
                  size: 30,
                ),
                const SizedBox(height: 8),
                Text(
                  isOpen ? 'Demander une inscription' : 'Inscriptions fermées',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isOpen
                      ? 'Démarrez votre demande…'
                      : registrationStatus?.message ??
                          'Les inscriptions ne sont pas disponibles.',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, color: Colors.white70),
                ),
                const Spacer(),
                const Align(
                  alignment: Alignment.bottomRight,
                  child: Icon(Icons.chevron_right, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
