import 'package:flutter/material.dart';
import '../../models/admission/admission_model.dart';
import '../../services/admission/admission_service.dart';
import '../../widgets/admission/admission_card.dart';
import '../../widgets/admission/admission_header.dart';
import '../../widgets/admission/admission_intro.dart';
import '../../widgets/admission/admission_bottom_nav.dart';
import '../registration/registration_screen.dart';
import 'admission_conditions_screen.dart';

class AdmissionScreen extends StatefulWidget {
  const AdmissionScreen({super.key});

  @override
  State<AdmissionScreen> createState() => _AdmissionScreenState();
}

class _AdmissionScreenState extends State<AdmissionScreen> {
  final AdmissionService _service = AdmissionService();
  bool loading = true;
  List<AdmissionModel> campaigns = [];

  @override
  void initState() {
    super.initState();
    _loadCampaigns();
  }

  Future<void> _loadCampaigns() async {
    final result = await _service.getAdmissions();
    if (mounted) {
      setState(() {
        campaigns = result;
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: Column(
        children: [
          AdmissionHeader(onNotification: () {}),
          Expanded(
            child: Container(
              transform: Matrix4.translationValues(0, -45, 0),
              decoration: const BoxDecoration(
                color: Color(0xFFF7F9FC),
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: loading
                  ? SingleChildScrollView(
                      child: Column(
                        children: List.generate(
                          3,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                const BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.04),
                                  blurRadius: 12,
                                  offset: Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 22,
                                  width: 180,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  height: 14,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  height: 14,
                                  width:
                                      MediaQuery.of(context).size.width * 0.65,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  height: 36,
                                  width: 140,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          const AdmissionIntro(),
                          ...campaigns.map(
                            (campaign) => AdmissionCard(
                              title: campaign.title,
                              description: campaign.description,
                              eligibility: campaign.eligibility,
                              image: campaign.image,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AdmissionConditionsScreen(
                                      campaignId: campaign.id,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: ListTile(
                                leading: const CircleAvatar(
                                  backgroundColor: Color(0xFF0F4DA8),
                                  child: Icon(
                                    Icons.school_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                                title: const Text('Inscription académique'),
                                subtitle: const Text(
                                  'Ouvrir le wizard d’inscription en 4 étapes',
                                ),
                                trailing: const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 16,
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const RegistrationScreen(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AdmissionBottomNav(),
    );
  }
}
