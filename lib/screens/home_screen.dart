import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/registration/registration_provider.dart';
import '../models/registration/registration_status_model.dart';
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

class _HomeScreenState extends State<HomeScreen> {
  bool _showAdmissionOptions = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RegistrationProvider>().loadRegistrationStatus();
    });
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
                  ),

                  MenuCard(
                    icon: Icons.calendar_month,
                    title: 'Date Clés',
                    subtitle: 'Calendrier académique et échéances.',
                    color: Color(0xFF0D4B9C),
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

              Container(
                padding: const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),

                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),

                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.account_balance, size: 40),

                    SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "À propos d'EAMAU",
                            style: TextStyle(
                              color: Color(0xFF1682F8),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),

                          SizedBox(height: 4),

                          Text(
                            "Une institution d'excellence engagée pour la formation de leaders responsables et innovants.",
                          ),
                        ],
                      ),
                    ),

                    Icon(Icons.chevron_right),
                  ],
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
              ? () {
                  Navigator.pushNamed(context, AppRoutes.registration);
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
