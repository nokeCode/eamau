import 'package:flutter/material.dart';
import '../../models/admission/admission_campaign_detail_model.dart';
import '../../services/admission/admission_service.dart';
import '../../widgets/admission/admission_request_button.dart';
import '../../widgets/admission/conditions_header.dart';
import '../../widgets/admission/conditions_intro.dart';
import '../../widgets/admission/conditions_section_card.dart';
import 'admission_request_screen.dart';

class AdmissionConditionsScreen extends StatefulWidget {
  final int campaignId;

  const AdmissionConditionsScreen({super.key, required this.campaignId});

  @override
  State<AdmissionConditionsScreen> createState() => _AdmissionConditionsScreenState();
}

class _AdmissionConditionsScreenState extends State<AdmissionConditionsScreen> {
  final AdmissionService _service = AdmissionService();
  late Future<AdmissionCampaignDetailModel?> _campaignDetailFuture;

  @override
  void initState() {
    super.initState();
    _campaignDetailFuture = _service.getCampaignDetail(widget.campaignId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: SafeArea(
        child: FutureBuilder<AdmissionCampaignDetailModel?>(
          future: _campaignDetailFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Column(
                children: [
                  const ConditionsHeader(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                  height: 18,
                                  width: 180,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                const SizedBox(height: 14),
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
                                  width: MediaQuery.of(context).size.width * 0.65,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                const SizedBox(height: 18),
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
                    ),
                  ),
                ],
              );
            }

            final detail = snapshot.data;
            if (detail == null) {
              return Column(
                children: [
                  const ConditionsHeader(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                  height: 18,
                                  width: 180,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                const SizedBox(height: 14),
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
                                  width: MediaQuery.of(context).size.width * 0.65,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                const SizedBox(height: 18),
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
                    ),
                  ),
                ],
              );
            }

            return Column(
              children: [
                const ConditionsHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const ConditionsIntro(),
                        ConditionsSectionCard(
                          icon: Icons.school_outlined,
                          title: 'Conditions d’admission',
                          subtitle: detail.conditions.isNotEmpty
                              ? detail.conditions.join('\n')
                              : 'Aucune condition spécifique fournie.',
                        ),
                        ConditionsSectionCard(
                          icon: Icons.menu_book_outlined,
                          title: 'Domaines proposés',
                          subtitle: detail.fields.isNotEmpty
                              ? detail.fields.join('\n')
                              : 'Aucune information sur les domaines disponibles.',
                        ),
                        ConditionsSectionCard(
                          icon: Icons.description_outlined,
                          title: 'Documents requis',
                          subtitle: detail.requiredDocuments.isNotEmpty
                              ? detail.requiredDocuments.join('\n')
                              : 'Aucune liste de documents fournie.',
                          initiallyExpanded: true,
                        ),
                        ConditionsSectionCard(
                          icon: Icons.verified_user_outlined,
                          title: 'Critères de sélection',
                          subtitle: detail.criteria.isNotEmpty
                              ? detail.criteria.join('\n')
                              : 'Aucun critère spécifique fourni.',
                        ),
                        AdmissionRequestButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AdmissionRequestScreen(
                                  campaignId: widget.campaignId,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
