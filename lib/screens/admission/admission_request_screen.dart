
import 'package:flutter/material.dart';

import '../../widgets/admission/admission_request_header.dart';
import '../../models/admission/admission_request_model.dart';
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
  const AdmissionRequestScreen({super.key});

  @override
  State<AdmissionRequestScreen> createState() => _AdmissionRequestScreenState();
}

class _AdmissionRequestScreenState extends State<AdmissionRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = AdmissionRequestService();

  bool loading = true;
  bool submitting = false;
  Map<String, dynamic> formData = {};

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final birthController = TextEditingController();
  final graduationYearController = TextEditingController();
  final schoolController = TextEditingController();

  String? nationality;
  String? diploma;
  String? country;
  String? level;
  String? program;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    formData = await _service.getAdmissionForm();
    if (mounted) {
      setState(() => loading = false);
    }
  }

  Future<void> submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => submitting = true);

    final model = AdmissionRequestModel(
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
      birthDate: birthController.text.isEmpty
          ? null
          : DateTime.tryParse(
          birthController.text.split('/').reversed.join('-')),
      nationality: nationality ?? '',
      diploma: diploma ?? '',
      graduationYear: graduationYearController.text.trim(),
      previousSchool: schoolController.text.trim(),
      previousCountry: country ?? '',
      level: level ?? '',
      program: program ?? '',
      documents: const {},
    );

    final ok = await _service.submitAdmission(model);

    if (!mounted) return;

    setState(() => submitting = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: ok ? Colors.green : Colors.red,
        content: Text(ok
            ? 'Demande enregistrée avec succès.'
            : "Erreur lors de l'enregistrement."),
      ),
    );

    if (ok) {
      // Navigator.pushNamed(context, AppRoutes.admissionTracking);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            const AdmissionRequestHeader(),
            const AdmissionStepper(currentStep: 1),
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    children: [
                      const AdmissionSectionTitle(title: "Informations personnelles"),
                      AdmissionTextField(controller: firstNameController,hint: "Prénom",icon: Icons.person_outline),
                      AdmissionTextField(controller: lastNameController,hint: "Nom",icon: Icons.person),
                      AdmissionDateField(controller: birthController,hint: "Date de naissance"),
                      AdmissionDropdownField<String>(
                        hint: "Nationalité",
                        icon: Icons.flag_outlined,
                        value: nationality,
                        items: List<String>.from(formData["nationalities"]),
                        onChanged: (v)=>setState(()=>nationality=v),
                      ),
                      AdmissionPhoneField(controller: phoneController),
                      AdmissionTextField(controller: emailController,hint: "Adresse email",icon: Icons.email_outlined,keyboardType: TextInputType.emailAddress),

                      const AdmissionSectionTitle(title: "Parcours académique"),
                      AdmissionDropdownField<String>(
                        hint: "Dernier diplôme",
                        icon: Icons.school_outlined,
                        value: diploma,
                        items: List<String>.from(formData["diplomas"]),
                        onChanged: (v)=>setState(()=>diploma=v),
                      ),
                      AdmissionTextField(controller: graduationYearController,hint: "Année d'obtention",icon: Icons.calendar_today,keyboardType: TextInputType.number),

                      const AdmissionSectionTitle(title: "Établissement précédent"),
                      AdmissionTextField(controller: schoolController,hint: "Nom de l'établissement",icon: Icons.account_balance),
                      AdmissionDropdownField<String>(
                        hint: "Pays",
                        icon: Icons.public,
                        value: country,
                        items: List<String>.from(formData["countries"]),
                        onChanged: (v)=>setState(()=>country=v),
                      ),

                      const AdmissionSectionTitle(title: "Niveau souhaité"),
                      AdmissionDropdownField<String>(
                        hint: "Niveau",
                        icon: Icons.layers_outlined,
                        value: level,
                        items: List<String>.from(formData["levels"]),
                        onChanged: (v)=>setState(()=>level=v),
                      ),
                      AdmissionDropdownField<String>(
                        hint: "Programme",
                        icon: Icons.menu_book_outlined,
                        value: program,
                        items: List<String>.from(formData["programs"]),
                        onChanged: (v)=>setState(()=>program=v),
                      ),

                      const AdmissionSectionTitle(title: "Pièces à joindre"),
                      const AdmissionUploadSection(),

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

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    birthController.dispose();
    graduationYearController.dispose();
    schoolController.dispose();
    super.dispose();
  }
}
