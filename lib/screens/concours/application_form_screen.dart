import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/concours/candidature_model.dart';
import '../../services/concours/candidature_service.dart';
import '../../widgets/concours/candidature_header.dart';
import '../../widgets/concours/step_indicator.dart';
import '../../widgets/concours/upload_document_card.dart';

class ApplicationFormScreen extends StatefulWidget {
  const ApplicationFormScreen({super.key});

  @override
  State<ApplicationFormScreen> createState() => _ApplicationFormScreenState();
}

class _ApplicationFormScreenState extends State<ApplicationFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final CandidatureService _service = CandidatureService();

  final TextEditingController _nomController = TextEditingController();

  final TextEditingController _prenomController = TextEditingController();

  final TextEditingController _dateController = TextEditingController();

  final TextEditingController _nationaliteController = TextEditingController();

  final TextEditingController _telephoneController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  String? _typeCandidat;

  bool _isLoading = false;

  File? _photo;

  File? _acte;

  File? _diplome;

  File? _releve;

  File? _carte;

  final List<String> _typesCandidat = [
    "Élève en Terminale",
    "Titulaire du BAC",
  ];

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _dateController.dispose();
    _nationaliteController.dispose();
    _telephoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2005),
      firstDate: DateTime(1980),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _dateController.text =
            "${picked.day.toString().padLeft(2, '0')}/"
            "${picked.month.toString().padLeft(2, '0')}/"
            "${picked.year}";
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_typeCandidat == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez choisir le type de candidat.")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final candidature = CandidatureModel(
      nom: _nomController.text.trim(),
      prenom: _prenomController.text.trim(),
      dateNaissance: _dateController.text.trim(),
      nationalite: _nationaliteController.text.trim(),
      telephone: _telephoneController.text.trim(),
      email: _emailController.text.trim(),
      typeCandidat: _typeCandidat!,
      photoIdentite: _photo,
      acteNaissance: _acte,
      diplome: _diplome,
      releveNotes: _releve,
      carteIdentite: _carte,
    );

    final success = await _service.submitCandidature(candidature);

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (success) {
      // Navigation vers ConfirmationCandidatureScreen
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Une erreur est survenue lors de l'envoi de la candidature.",
          ),
        ),
      );
    }
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: const Color(0xff1E4DB7)),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xffF5F7FA),
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              CandidatureHeader(onBack: () => Navigator.pop(context)),

              const StepIndicator(currentStep: 1),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Informations personnelles",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          "Veuillez renseigner les informations ci-dessous.",
                          style: TextStyle(color: Colors.grey.shade600),
                        ),

                        const SizedBox(height: 25),

                        TextFormField(
                          controller: _nomController,
                          decoration: _inputDecoration(
                            "Nom",
                            Icons.person_outline,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Champ obligatoire";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _prenomController,
                          decoration: _inputDecoration(
                            "Prénom",
                            Icons.badge_outlined,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Champ obligatoire";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _dateController,
                          readOnly: true,
                          onTap: _selectDate,
                          decoration:
                              _inputDecoration(
                                "Date de naissance",
                                Icons.calendar_today_outlined,
                              ).copyWith(
                                suffixIcon: const Icon(
                                  Icons.calendar_month,
                                  color: Color(0xff1E4DB7),
                                ),
                              ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Champ obligatoire";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _nationaliteController,
                          decoration: _inputDecoration(
                            "Nationalité",
                            Icons.flag_outlined,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Champ obligatoire";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _telephoneController,
                          keyboardType: TextInputType.phone,
                          decoration: _inputDecoration(
                            "Téléphone",
                            Icons.phone_outlined,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Champ obligatoire";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: _inputDecoration(
                            "Adresse e-mail",
                            Icons.email_outlined,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Champ obligatoire";
                            }

                            if (!value.contains("@")) {
                              return "Adresse e-mail invalide";
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        DropdownButtonFormField<String>(
                          value: _typeCandidat,
                          decoration: _inputDecoration(
                            "Type de candidat",
                            Icons.school_outlined,
                          ),
                          items: _typesCandidat
                              .map(
                                (type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(type),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _typeCandidat = value;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return "Veuillez sélectionner un type";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 28),

                        const Text(
                          "Pièces justificatives",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          "Téléversez les documents demandés.",
                          style: TextStyle(color: Colors.grey.shade600),
                        ),

                        const SizedBox(height: 20),
                        UploadDocumentCard(
                          icon: Icons.photo_camera_outlined,
                          title: "Photo d'identité",
                          subtitle: "Sélectionner une photo",
                          onFileSelected: (file) {
                            _photo = file;
                          },
                        ),

                        UploadDocumentCard(
                          icon: Icons.description_outlined,
                          title: "Acte de naissance",
                          subtitle: "Sélectionner le document",
                          onFileSelected: (file) {
                            _acte = file;
                          },
                        ),

                        UploadDocumentCard(
                          icon: Icons.school_outlined,
                          title: "Diplôme / BAC",
                          subtitle: "Sélectionner le document",
                          onFileSelected: (file) {
                            _diplome = file;
                          },
                        ),

                        UploadDocumentCard(
                          icon: Icons.menu_book_outlined,
                          title: "Relevé de notes",
                          subtitle: "Sélectionner le document",
                          onFileSelected: (file) {
                            _releve = file;
                          },
                        ),

                        UploadDocumentCard(
                          icon: Icons.badge_outlined,
                          title: "Carte nationale d'identité",
                          subtitle: "Sélectionner le document",
                          onFileSelected: (file) {
                            _carte = file;
                          },
                        ),

                        const SizedBox(height: 30),

                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff1565C0),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 0,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    "Continuer",
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
