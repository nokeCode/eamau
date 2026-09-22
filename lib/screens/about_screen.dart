import 'package:flutter/material.dart';

import '../widgets/common/app_bar.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: 'À propos d\'EAMAU'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F7FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/logos/eamau_logo.gif',
                      height: 80,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'EAMAU',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0D4B9C),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'École Africaine des Métiers de l\'Architecture et de l\'Urbanisme',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0D4B9C),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              Text(
                'Bienvenue à l\'EAMAU',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0D4B9C),
                ),
              ),
              const SizedBox(height: 12),
              
              Text(
                'L\'École Africaine des Métiers de l\'Architecture et de l\'Urbanisme (EAMAU) est une institution d\'excellence dédiée à la formation de leaders responsables et innovants dans les domaines de l\'architecture, de l\'urbanisme et des métiers connexes.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                  height: 1.6,
                ),
              ),
              
              const SizedBox(height: 20),
              
              Text(
                'Notre Mission',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0D4B9C),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Notre mission est de former des professionnels compétents, capables de relever les défis du développement urbain en Afrique. Nous nous engageons à fournir une éducation de qualité, basée sur l\'excellence académique, l\'innovation et les valeurs éthiques.',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[700],
                  height: 1.6,
                ),
              ),
              
              const SizedBox(height: 20),
              
              Text(
                'Nos Valeurs',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0D4B9C),
                ),
              ),
              const SizedBox(height: 10),
              
              _buildValueItem(context, 'Excellence', 'Nous visons l\'excellence dans tout ce que nous faisons, de l\'enseignement à la recherche.'),
              _buildValueItem(context, 'Innovation', 'Nous encourageons la créativité et l\'innovation pour répondre aux besoins changeants de notre société.'),
              _buildValueItem(context, 'Responsabilité', 'Nous formons des leaders responsables, conscients de leur impact sur la société et l\'environnement.'),
              _buildValueItem(context, 'Collaboration', 'Nous croyons en la puissance de la collaboration et du travail d\'équipe.'),
              
              const SizedBox(height: 20),
              
              Text(
                'Nos Objectifs',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0D4B9C),
                ),
              ),
              const SizedBox(height: 10),
              
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F7FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFB6D1FF)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildObjectiveItem(Icons.school, 'Formation de qualité', 'Offrir une formation académique de haute qualité.'),
                    _buildObjectiveItem(Icons.architecture, 'Recherche innovante', 'Promouvoir la recherche et l\'innovation.'),
                    _buildObjectiveItem(Icons.people, 'Développement professionnel', 'Préparer les étudiants à des carrières réussies.'),
                    _buildObjectiveItem(Icons.public, 'Engagement social', 'Contribuer au développement durable.'),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              Text(
                'Contactez-nous',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0D4B9C),
                ),
              ),
              const SizedBox(height: 12),
              
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F7FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildContactItem(Icons.email, 'Email', 'contact@eamau.tg'),
                    const SizedBox(height: 8),
                    _buildContactItem(Icons.phone, 'Téléphone', '+228 90 00 00 00'),
                    const SizedBox(height: 8),
                    _buildContactItem(Icons.location_on, 'Adresse', 'Lomé, Togo'),
                  ],
                ),
              ),
              
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),

    );
  }

  Widget _buildValueItem(BuildContext context, String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1682F8),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildObjectiveItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: const Color(0xFF0D4B9C),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0D4B9C),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFF0D4B9C),
          size: 20,
        ),
        const SizedBox(width: 12),
        Text(
          '$title: ',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF0D4B9C),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}
