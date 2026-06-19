import 'package:flutter/material.dart';

import '../widgets/home_header.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/admission_banner.dart';
import '../widgets/menu_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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

                children: const [

                  MenuCard(
                    icon: Icons.article,
                    title: 'Actualité',
                    subtitle: 'Restez informé des dernières nouvelles et événements.',
                    color: Color(0xFF1682F8),
                  ),

                  MenuCard(
                    icon: Icons.school,
                    title: 'Filière',
                    subtitle: 'Découvrez nos formations et nos parcours.',
                    color: Color(0xFF1682F8),
                  ),

                  MenuCard(
                    icon: Icons.groups,
                    title: 'Concours',
                    subtitle: 'Toutes les informations sur les concours.',
                    color: Color(0xFF1682F8),
                  ),

                  MenuCard(
                    icon: Icons.assignment,
                    title: 'Admission',
                    subtitle: 'Procédures et dossiers pour rejoindre EAMAU.',
                    color: Color(0xFF1682F8),
                  ),

                  MenuCard(
                    icon: Icons.help,
                    title: 'FAQ',
                    subtitle: 'Trouvez rapidement les réponses à vos questions.',
                    color: Color(0xFF1682F8),
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

              Container(
                padding: const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                    ),
                  ],
                ),

                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Icon(
                      Icons.account_balance,
                      size: 40,
                    ),

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

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,

        currentIndex: 0,

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Recherche',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            label: 'Ajouter',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: 'Notification',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}