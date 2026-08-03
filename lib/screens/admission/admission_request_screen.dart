
import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';
import '../../models/admission/admission_campaign_detail_model.dart';
import '../../models/admission/admission_request_model.dart';
import '../../models/admission/admission_request_summary_model.dart';
import '../../services/admission/admission_request_service.dart';
import '../../widgets/admission/admission_request_header.dart';
import '../../widgets/admission/admission_stepper.dart';
import '../../widgets/admission/admission_section_title.dart';
import '../../widgets/admission/admission_text_field.dart';
import '../../widgets/admission/admission_dropdown_field.dart';
import '../../widgets/admission/admission_date_field.dart';
import '../../widgets/admission/admission_phone_field.dart';
import '../../widgets/admission/admission_upload_section.dart';
import '../../widgets/admission/admission_submit_button.dart';

class AdmissionRequestScreen extends StatefulWidget {
  final int campaignId;

  const AdmissionRequestScreen({super.key, required this.campaignId});

  @override
  State<AdmissionRequestScreen> createState() => _AdmissionRequestScreenState();
}

class _AdmissionRequestScreenState extends State<AdmissionRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = AdmissionRequestService();

  bool loading = true;
  bool submitting = false;
  Map<String, dynamic> formData = {};
  AdmissionCampaignDetailModel? campaignDetail;
  AdmissionRequestSummaryModel? _requestSummary;
  int? _requestId;
  bool _summaryLoading = false;
  String? _summaryError;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final birthController = TextEditingController();
  final professionController = TextEditingController();
  final addressController = TextEditingController();
  final currentFieldController = TextEditingController();
  final graduationYearController = TextEditingController();
  final schoolController = TextEditingController();

  final firstNameFocus = FocusNode();
  final lastNameFocus = FocusNode();
  final birthFocus = FocusNode();
  final emailFocus = FocusNode();
  final phoneFocus = FocusNode();
  final professionFocus = FocusNode();
  final addressFocus = FocusNode();
  final currentFieldFocus = FocusNode();
  final graduationYearFocus = FocusNode();
  final schoolFocus = FocusNode();
  final nationalityFocus = FocusNode();
  final diplomaFocus = FocusNode();
  final countryFocus = FocusNode();
  final levelFocus = FocusNode();
  final programFocus = FocusNode();

  dynamic nationality;
  dynamic diploma;
  dynamic country;
  dynamic level;
  dynamic program;
  String? _formErrorMessage;

  String _extractValue(dynamic item) {
    if (item == null) return '';
    if (item is Map) {
      if (item.containsKey('id')) return item['id'].toString();
      if (item.containsKey('value')) return item['value'].toString();
      if (item.containsKey('code')) return item['code'].toString();
      if (item.containsKey('name')) return item['name'].toString();
      if (item.containsKey('label')) return item['label'].toString();
    }
    return item.toString();
  }

  String _normalizeAcademicLevel(dynamic value) {
    final text = _extractValue(value).trim().toLowerCase();
    if (text.isEmpty) return '';
    if (text.startsWith('l')) {
      return text.toUpperCase();
    }

    if (text.contains('baccalauréat') || text.contains('baccalaureat')) {
      return 'L1';
    }
    if (text.contains('bts') || text.contains('dut') || text.contains('deug')) {
      return 'L2';
    }
    if (text.contains('licence')) {
      return 'L3';
    }
    if (text.contains('master')) {
      return 'L4';
    }
    return text.toUpperCase();
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    birthController.dispose();
    professionController.dispose();
    addressController.dispose();
    currentFieldController.dispose();
    graduationYearController.dispose();
    schoolController.dispose();

    firstNameFocus.dispose();
    lastNameFocus.dispose();
    birthFocus.dispose();
    emailFocus.dispose();
    phoneFocus.dispose();
    professionFocus.dispose();
    addressFocus.dispose();
    currentFieldFocus.dispose();
    graduationYearFocus.dispose();
    schoolFocus.dispose();
    nationalityFocus.dispose();
    diplomaFocus.dispose();
    countryFocus.dispose();
    levelFocus.dispose();
    programFocus.dispose();

    super.dispose();
  }

  void _focusFirstInvalidField() {
    if (firstNameController.text.trim().isEmpty) {
      firstNameFocus.requestFocus();
      return;
    }
    if (lastNameController.text.trim().isEmpty) {
      lastNameFocus.requestFocus();
      return;
    }
    if (birthController.text.trim().isEmpty) {
      birthFocus.requestFocus();
      return;
    }
    if (nationality == null || nationality.toString().isEmpty) {
      nationalityFocus.requestFocus();
      return;
    }
    if (phoneController.text.trim().isEmpty) {
      phoneFocus.requestFocus();
      return;
    }
    if (emailController.text.trim().isEmpty) {
      emailFocus.requestFocus();
      return;
    }
    if (professionController.text.trim().isEmpty) {
      professionFocus.requestFocus();
      return;
    }
    if (addressController.text.trim().isEmpty) {
      addressFocus.requestFocus();
      return;
    }
    if (diploma == null || diploma.toString().isEmpty) {
      diplomaFocus.requestFocus();
      return;
    }
    if (currentFieldController.text.trim().isEmpty) {
      currentFieldFocus.requestFocus();
      return;
    }
    if (graduationYearController.text.trim().isEmpty) {
      graduationYearFocus.requestFocus();
      return;
    }
    if (schoolController.text.trim().isEmpty) {
      schoolFocus.requestFocus();
      return;
    }
    if (country == null || country.toString().isEmpty) {
      countryFocus.requestFocus();
      return;
    }
    if (level == null || level.toString().isEmpty) {
      levelFocus.requestFocus();
      return;
    }
    if (program == null || program.toString().isEmpty) {
      programFocus.requestFocus();
    }
  }

  Future<void> loadData() async {
    final fetchedFormData = await _service.getAdmissionForm();
    final fetchedCampaign = await _service.getCampaignDetail(widget.campaignId);

    if (!mounted) return;

    setState(() {
      formData = fetchedFormData;
      campaignDetail = fetchedCampaign;

      if (campaignDetail != null) {
        if (campaignDetail!.level.isNotEmpty) {
          formData['levels'] = [campaignDetail!.level];
          level = campaignDetail!.level;
        }
        if (campaignDetail!.fields.isNotEmpty) {
          formData['programs'] = campaignDetail!.fields;
        }
      }

      loading = false;
    });
  }

  Future<void> _loadRequestSummary(int requestId) async {
    setState(() {
      _summaryLoading = true;
      _summaryError = null;
    });

    final summary = await _service.getAdmissionSummary(requestId);
    if (!mounted) return;

    setState(() {
      _summaryLoading = false;
      _requestId = requestId;
      _requestSummary = summary;
      if (summary == null) {
        _summaryError = _service.lastStatusCode == 401
            ? 'Veuillez vous connecter pour consulter le récapitulatif.'
            : 'Impossible de charger le récapitulatif de la demande.';
      }
    });
  }

  Future<void> _uploadPendingDocumentsIfNeeded() async {
    if (_requestId == null) return;
    final uploadState = context.findAncestorStateOfType<AdmissionUploadSectionState>();
    if (uploadState == null) return;
    await uploadState.uploadPendingDocuments();
  }

  Future<void> submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      setState(() => _formErrorMessage = 'Veuillez corriger les champs en rouge.');
      _focusFirstInvalidField();
      return;
    }

    setState(() {
      submitting = true;
      _formErrorMessage = null;
    });

    final model = AdmissionRequestModel(
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
      birthDate: birthController.text.isEmpty
          ? null
          : DateTime.tryParse(
              birthController.text.split('/').reversed.join('-')),
      nationality: _extractValue(nationality),
      profession: professionController.text.trim(),
      address: addressController.text.trim(),
      universityOrigin: schoolController.text.trim(),
      currentLevel: _normalizeAcademicLevel(diploma),
      requestedLevel: campaignDetail?.level.isNotEmpty == true
          ? campaignDetail!.level
          : _normalizeAcademicLevel(level),
      currentField: currentFieldController.text.trim(),
      requestedField: _extractValue(program),
      documents: const {},
    );

    final response = await _service.createAdmissionRequest(widget.campaignId, model);

    if (!mounted) return;

    setState(() => submitting = false);

    if (response == null) {
      final message = _service.lastStatusCode == 401
          ? 'Veuillez vous connecter pour continuer.'
          : 'Erreur lors de l’enregistrement${_service.lastStatusCode != null ? ' (${_service.lastStatusCode})' : ''}.';
      final details = _service.lastErrorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(details != null && details.isNotEmpty
              ? '$message\n$details'
              : message),
          duration: const Duration(seconds: 5),
        ),
      );
      if (_service.lastStatusCode == 401) {
        Navigator.pushNamed(context, AppRoutes.login);
      }
      return;
    }

    if (response.id <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Le serveur n’a pas renvoyé d’identifiant de demande valide.'),
        ),
      );
      return;
    }

    setState(() {
      _requestId = response.id;
    });

    await _uploadPendingDocumentsIfNeeded();
    await _loadRequestSummary(response.id);
    if (!mounted) return;
    if (_requestSummary == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Impossible de charger le récapitulatif.'),
        ),
      );
    }
  }

  Future<void> submitRequest() async {
    if (_requestId == null) return;

    setState(() => submitting = true);
    final response = await _service.submitAdmissionRequest(_requestId!);
    if (!mounted) return;
    setState(() => submitting = false);

    if (response == null) {
      final message = _service.lastStatusCode == 401
          ? 'Veuillez vous connecter pour soumettre la demande.'
          : 'Impossible de soumettre la demande.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(message),
        ),
      );
      if (_service.lastStatusCode == 401) {
        Navigator.pushNamed(context, AppRoutes.login);
      }
      return;
    }

    if (!response.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Échec de la soumission : ${response.status}.'),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Text('Demande soumise avec succès.'),
      ),
    );
    Navigator.pushNamed(
      context,
      AppRoutes.admissionTracking,
      arguments: _requestId,
    );
  }

  int get _currentStep {
    if (_requestSummary != null || _summaryLoading || _summaryError != null) {
      return 3;
    }
    return 1;
  }

  void _continueToCompleteDossier() {
    setState(() {
      _requestSummary = null;
    });
  }

  Widget _buildRequestSummary() {
    if (_summaryLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_summaryError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            _summaryError!,
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final summary = _requestSummary!;
    final informationEntries = summary.information.entries.toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AdmissionSectionTitle(title: 'Récapitulatif de la demande'),
          const SizedBox(height: 12),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xffDCE5F2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Statut de la demande',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    Chip(
                      label: Text(summary.status),
                      backgroundColor: summary.status.toLowerCase() == 'brouillon'
                          ? const Color(0xffF1F6FF)
                          : const Color(0xffE8F5E9),
                      labelStyle: TextStyle(
                        color: summary.status.toLowerCase() == 'brouillon'
                            ? const Color(0xff0B4EA2)
                            : const Color(0xff2E7D32),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                ...informationEntries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${entry.key}: ',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            entry.value?.toString() ?? '-',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xffDCE5F2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Documents uploadés',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                if (summary.documents.isEmpty)
                  const Text(
                    'Aucun document uploadé.',
                    style: TextStyle(color: Colors.grey),
                  )
                else
                  ...summary.documents.map(
                    (document) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              document.originalFilename,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                          Icon(
                            document.validated ? Icons.check_circle : Icons.error_outline,
                            color: document.validated ? const Color(0xff2E7D32) : Colors.orange,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xffDCE5F2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pièces manquantes',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                if (summary.missingDocuments.isEmpty)
                  const Text(
                    'Aucune pièce manquante.',
                    style: TextStyle(color: Colors.grey),
                  )
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: summary.missingDocuments
                        .map(
                          (missing) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xffFEF3C7),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              missing,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xffA16207),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: AdmissionSubmitButton(
              text: summary.isComplete ? 'Soumettre la demande' : 'Compléter le dossier',
              loading: submitting,
              onPressed: summary.isComplete ? () => submitRequest() : _continueToCompleteDossier,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_requestSummary != null || _summaryLoading || _summaryError != null) {
      return Scaffold(
        backgroundColor: const Color(0xffF5F7FA),
        body: SafeArea(
          child: Column(
            children: [
              const AdmissionRequestHeader(),
              AdmissionStepper(currentStep: _currentStep),
              Expanded(child: _buildRequestSummary()),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            const AdmissionRequestHeader(),
            const AdmissionStepper(currentStep: 2),
            Expanded(
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    children: [
                      const AdmissionSectionTitle(title: "Informations personnelles"),
                      if (_formErrorMessage != null)
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF1F0),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFFFC2B3)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline, color: Color(0xFFB00020)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  _formErrorMessage!,
                                  style: const TextStyle(
                                    color: Color(0xFFB00020),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      AdmissionTextField(
                        controller: firstNameController,
                        hint: "Prénom",
                        icon: Icons.person_outline,
                        focusNode: firstNameFocus,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Le prénom est requis.';
                          }
                          return null;
                        },
                      ),
                      AdmissionTextField(
                        controller: lastNameController,
                        hint: "Nom",
                        icon: Icons.person,
                        focusNode: lastNameFocus,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Le nom est requis.';
                          }
                          return null;
                        },
                      ),
                      AdmissionDateField(
                        controller: birthController,
                        hint: "Date de naissance",
                        focusNode: birthFocus,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'La date de naissance est requise.';
                          }
                          return null;
                        },
                      ),
                      AdmissionDropdownField<dynamic>(
                        hint: "Nationalité",
                        icon: Icons.flag_outlined,
                        value: nationality,
                        items: List<dynamic>.from(formData["nationalities"]),
                        itemLabel: (item) => item is Map
                            ? (item['label'] ?? item['name'] ?? item['value'] ?? item['title'] ?? item.toString()).toString()
                            : item.toString(),
                        onChanged: (v) => setState(() => nationality = v),
                        focusNode: nationalityFocus,
                        validator: (value) {
                          if (value == null || value.toString().trim().isEmpty) {
                            return 'Veuillez choisir une nationalité.';
                          }
                          return null;
                        },
                      ),
                      AdmissionPhoneField(
                        controller: phoneController,
                        focusNode: phoneFocus,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Le téléphone est requis.';
                          }
                          return null;
                        },
                      ),
                      AdmissionTextField(
                        controller: emailController,
                        hint: "Adresse email",
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        focusNode: emailFocus,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'L’email est requis.';
                          }
                          if (!RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+$").hasMatch(value.trim())) {
                            return 'Veuillez saisir une adresse email valide.';
                          }
                          return null;
                        },
                      ),
                      AdmissionTextField(
                        controller: professionController,
                        hint: "Profession actuelle",
                        icon: Icons.work_outline,
                        focusNode: professionFocus,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'La profession est requise.';
                          }
                          return null;
                        },
                      ),
                      AdmissionTextField(
                        controller: addressController,
                        hint: "Adresse",
                        icon: Icons.location_on_outlined,
                        focusNode: addressFocus,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'L’adresse est requise.';
                          }
                          return null;
                        },
                      ),

                      const AdmissionSectionTitle(title: "Parcours académique"),
                      AdmissionDropdownField<dynamic>(
                        hint: "Dernier diplôme",
                        icon: Icons.school_outlined,
                        value: diploma,
                        items: List<dynamic>.from(formData["diplomas"]),
                        itemLabel: (item) => item is Map
                            ? (item['label'] ?? item['name'] ?? item['value'] ?? item['title'] ?? item.toString()).toString()
                            : item.toString(),
                        onChanged: (v) => setState(() => diploma = v),
                        focusNode: diplomaFocus,
                        validator: (value) {
                          if (value == null || value.toString().trim().isEmpty) {
                            return 'Le diplôme est requis.';
                          }
                          return null;
                        },
                      ),
                      AdmissionTextField(
                        controller: currentFieldController,
                        hint: "Domaine actuel",
                        icon: Icons.menu_book_outlined,
                        focusNode: currentFieldFocus,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Le domaine actuel est requis.';
                          }
                          return null;
                        },
                      ),
                      AdmissionTextField(
                        controller: graduationYearController,
                        hint: "Année d'obtention",
                        icon: Icons.calendar_today,
                        keyboardType: TextInputType.number,
                        focusNode: graduationYearFocus,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'L’année d’obtention est requise.';
                          }
                          return null;
                        },
                      ),

                      const AdmissionSectionTitle(title: "Établissement précédent"),
                      AdmissionTextField(
                        controller: schoolController,
                        hint: "Nom de l'établissement",
                        icon: Icons.account_balance,
                        focusNode: schoolFocus,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Le nom de l’établissement est requis.';
                          }
                          return null;
                        },
                      ),
                      AdmissionDropdownField<dynamic>(
                        hint: "Pays",
                        icon: Icons.public,
                        value: country,
                        items: List<dynamic>.from(formData["countries"]),
                        itemLabel: (item) => item is Map
                            ? (item['label'] ?? item['name'] ?? item['value'] ?? item['title'] ?? item.toString()).toString()
                            : item.toString(),
                        onChanged: (v) => setState(() => country = v),
                        focusNode: countryFocus,
                        validator: (value) {
                          if (value == null || value.toString().trim().isEmpty) {
                            return 'Veuillez choisir un pays.';
                          }
                          return null;
                        },
                      ),

                      const AdmissionSectionTitle(title: "Niveau souhaité"),
                      AdmissionDropdownField<dynamic>(
                        hint: "Niveau",
                        icon: Icons.layers_outlined,
                        value: level,
                        items: List<dynamic>.from(formData["levels"]),
                        itemLabel: (item) => item is Map
                            ? (item['label'] ?? item['name'] ?? item['value'] ?? item['title'] ?? item.toString()).toString()
                            : item.toString(),
                        onChanged: (v) => setState(() => level = v),
                        focusNode: levelFocus,
                        validator: (value) {
                          if (value == null || value.toString().trim().isEmpty) {
                            return 'Veuillez choisir un niveau.';
                          }
                          return null;
                        },
                      ),
                      AdmissionDropdownField<dynamic>(
                        hint: "Programme",
                        icon: Icons.menu_book_outlined,
                        value: program,
                        items: List<dynamic>.from(formData["programs"]),
                        itemLabel: (item) => item is Map
                            ? (item['label'] ?? item['name'] ?? item['value'] ?? item['title'] ?? item.toString()).toString()
                            : item.toString(),
                        onChanged: (v) => setState(() => program = v),
                        focusNode: programFocus,
                        validator: (value) {
                          if (value == null || value.toString().trim().isEmpty) {
                            return 'Veuillez choisir un programme.';
                          }
                          return null;
                        },
                      ),

                      const AdmissionSectionTitle(title: "Pièces à joindre"),
                      AdmissionUploadSection(
                        requestId: _requestId,
                        service: _service,
                      ),

                      AdmissionSubmitButton(
                        text: "Continuer",
                        loading: submitting,
                        onPressed: submitForm,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
