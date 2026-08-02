import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/concours/dynamic_form_model.dart';
import '../../models/filiere/filiere_model.dart';
import '../../services/concours/concours_form_service.dart';
import '../../services/filiere/filiere_service.dart';
import '../../widgets/concours/candidature_header.dart';
import '../../widgets/concours/step_indicator.dart';
import '../../widgets/concours/upload_document_card.dart';
import 'confirmation_candidature_screen.dart';

class ApplicationFormScreen extends StatefulWidget {
  final String concoursSlug;

  const ApplicationFormScreen({super.key, required this.concoursSlug});

  @override
  State<ApplicationFormScreen> createState() => _ApplicationFormScreenState();
}

class _ApplicationFormScreenState extends State<ApplicationFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ConcoursFormService _service = ConcoursFormService();
  final FiliereService _filiereService = FiliereService();
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _fieldKeys = {};
  final Map<String, FocusNode> _focusNodes = {};

  ConcoursFormModel? _form;
  List<Filiere> _filiereOptions = [];
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, dynamic> _values = {};
  final Map<String, File> _attachedFiles = {};
  final Map<String, String> _uploadedDocumentIds = {};
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  String? _selectedCandidateTypeId;
  String? _postulationId;
  String? _postulationToken;
  int _currentStage = 1;
  bool _isLoading = true;
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadForm();
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    for (final controller in _otpControllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes.values) {
      focusNode.dispose();
    }
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadForm() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final form = await _service.loadForm(widget.concoursSlug);
      final filieres = await _filiereService.getFilieresPage(perPage: 100);

      if (!mounted) return;

      setState(() {
        _form = form;
        _filiereOptions = filieres.items;
        if (form.candidateTypes.length == 1) {
          _selectedCandidateTypeId = form.candidateTypes.first.id;
        }
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = error.toString();
      });
    }
  }

  Future<void> _submit() async {
    if (_form == null) {
      return;
    }

    if (_selectedCandidateTypeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez choisir un type de candidat.')),
      );
      return;
    }

    switch (_currentStage) {
      case 1:
        await _createDraftAndRequestCode();
        break;
      case 2:
        await _verifyOtpCode();
        break;
      case 3:
      default:
        await _submitApplication();
        break;
    }
  }

  Future<void> _createDraftAndRequestCode() async {
    if (!_formKey.currentState!.validate()) {
      await _scrollToFirstInvalidField();
      return;
    }

    final email = _values['email']?.toString().trim() ?? '';
    if (email.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Veuillez renseigner votre email pour continuer la candidature.',
          ),
        ),
      );
      await _scrollToField('email');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final draft = await _service.createPostulation(
        concoursSlugOrId: widget.concoursSlug,
        email: email,
        candidateTypeId: _selectedCandidateTypeId!,
      );
      _postulationId = draft.id;
      setState(() {
        _currentStage = 2;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Code OTP envoyé à votre email.')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<void> _verifyOtpCode() async {
    final code = _otpCode;
    if (code.length != 6) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez entrer le code OTP à 6 chiffres.'),
        ),
      );
      return;
    }

    if (_postulationId == null || _postulationId!.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Aucune candidature en cours. Recommencez la procédure.',
          ),
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final verification = await _service.verifyPostulationCode(
        postulationId: _postulationId!,
        code: code,
      );
      _postulationToken = verification.postulationToken;
      _postulationId = verification.postulation.id;
      setState(() {
        _currentStage = 3;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Code vérifié. Vous pouvez maintenant compléter votre candidature.',
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<void> _submitApplication() async {
    if (_postulationToken == null || _postulationToken!.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Veuillez vérifier d’abord votre email avec le code OTP.',
          ),
        ),
      );
      return;
    }

    final missing = _getMissingRequiredAttributes();
    if (!_formKey.currentState!.validate() || missing.isNotEmpty) {
      await _scrollToFirstInvalidField();
      if (!mounted) return;
      final names = missing
          .map((a) => a.name.isNotEmpty ? a.name : a.slug)
          .take(5)
          .join(', ');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Champs obligatoires manquants : $names')),
      );
      return;
    }

    if (_postulationId == null || _postulationId!.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aucune candidature active. Recommencez la procédure.'),
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final postulationId = _postulationId!;
      final visibleAttributes = _visibleSections()
          .expand((section) => section.attributes)
          .toList();

      final values = <String, dynamic>{};
      for (final attribute in visibleAttributes) {
        final type = attribute.type.toLowerCase();
        if (type == 'image' || type == 'document') {
          continue;
        }
        final value = _values[attribute.slug];
        if (value != null && value.toString().trim().isNotEmpty) {
          values[attribute.slug] = value.toString();
        }
      }

      if (values.isNotEmpty) {
        await _service.saveValues(
          postulationId,
          values,
          postulationToken: _postulationToken,
        );
      }

      for (final entry in _attachedFiles.entries) {
        final slug = entry.key;
        final attribute = visibleAttributes.firstWhere(
          (attribute) => attribute.slug == slug,
          orElse: () => throw StateError('Attribut non trouvé pour $slug'),
        );
        if (!_attributeHasValue(attribute)) {
          continue;
        }

        final document = await _service.uploadDocument(
          postulationId: postulationId,
          attributeSlug: slug,
          file: entry.value,
          postulationToken: _postulationToken,
        );
        _uploadedDocumentIds[slug] = document.id;
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Données enregistrées. Passez à la confirmation.'),
        ),
      );

      Future<void> navigateToConfirmation() async {
        try {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ConfirmationCandidatureScreen(
                candidatureId: postulationId,
                postulationToken: _postulationToken!,
              ),
            ),
          );
        } catch (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Échec de navigation: ${e.toString()}')),
          );
        }
      }

      if (_hasPhone()) {
        await navigateToConfirmation();
      } else {
        final proceed = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Téléphone manquant'),
            content: const Text(
              'Le champ de téléphone (Cellulaire ou Téléphone) est vide. Sans numéro, le backend ne pourra pas envoyer de SMS. Voulez-vous continuer ?',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: const Text('Remplir le téléphone'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: const Text('Continuer quand même'),
              ),
            ],
          ),
        );

        if (proceed == true) {
          await navigateToConfirmation();
        } else {
          // try to scroll to possible phone fields
          if (_fieldKeys.containsKey('cellulaire')) {
            await _scrollToField('cellulaire');
          } else if (_fieldKeys.containsKey('telephone')) {
            await _scrollToField('telephone');
          }
        }
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  String get _otpCode {
    return _otpControllers.map((controller) => controller.text.trim()).join();
  }

  Future<void> _resendOtpCode() async {
    if (_postulationId == null || _postulationId!.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aucune candidature en cours pour renvoyer le code.'),
        ),
      );
      return;
    }

    try {
      await _service.resendVerificationCode(postulationId: _postulationId!);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Nouveau code OTP envoyé.')));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  Future<void> _pickDate(String slug) async {
    final initialDate =
        DateTime.tryParse(_values[slug]?.toString() ?? '') ?? DateTime(2000);
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      final value =
          '${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      _updateValue(slug, value);
      _controllers[slug]?.text = value;
    }
  }

  void _updateValue(String slug, dynamic value) {
    setState(() {
      _values[slug] = value;
    });
  }

  List<ConcoursFormAttributeModel> _getMissingRequiredAttributes() {
    final missing = <ConcoursFormAttributeModel>[];
    final visibleAttributes = _visibleSections()
        .expand((s) => s.attributes)
        .toList();
    for (final attribute in visibleAttributes) {
      if (!attribute.required) continue;
      if (!_attributeHasValue(attribute)) {
        missing.add(attribute);
      }
    }
    return missing;
  }

  bool _hasPhone() {
    for (final key in _values.keys) {
      final low = key.toLowerCase();
      if (low.contains('cell') ||
          low.contains('telephone') ||
          low.contains('tel') ||
          low.contains('phone') ||
          low.contains('mobile')) {
        final v = _values[key];
        if (v != null && v.toString().trim().isNotEmpty) {
          return true;
        }
      }
    }
    return false;
  }

  bool _attributeHasValue(ConcoursFormAttributeModel attribute) {
    final type = attribute.type.toLowerCase();
    if (type == 'image' || type == 'document') {
      return _attachedFiles.containsKey(attribute.slug);
    }
    final value = _values[attribute.slug];
    return value != null && value.toString().trim().isNotEmpty;
  }

  GlobalKey _fieldKeyFor(String slug) {
    return _fieldKeys.putIfAbsent(slug, () => GlobalKey());
  }

  FocusNode _focusNodeFor(String slug) {
    return _focusNodes.putIfAbsent(slug, () => FocusNode());
  }

  Future<void> _scrollToField(String slug) async {
    final key = _fieldKeys[slug];
    final fieldContext = key?.currentContext;
    if (fieldContext != null) {
      await Scrollable.ensureVisible(
        fieldContext,
        duration: const Duration(milliseconds: 400),
        alignment: 0.1,
      );
    }
  }

  Future<void> _scrollToFirstInvalidField() async {
    for (final attribute in _visibleSections().expand(
      (section) => section.attributes,
    )) {
      if (!attribute.required) {
        continue;
      }
      if (!_attributeHasValue(attribute)) {
        final key = _fieldKeys[attribute.slug];
        final fieldContext = key?.currentContext;
        if (fieldContext != null) {
          await Scrollable.ensureVisible(
            fieldContext,
            duration: const Duration(milliseconds: 400),
            alignment: 0.1,
          );
          if (!mounted) {
            return;
          }
          if (_focusNodes.containsKey(attribute.slug)) {
            FocusScope.of(context).requestFocus(_focusNodes[attribute.slug]);
          }
        }
        return;
      }
    }
  }

  TextEditingController _controllerFor(String slug) {
    if (!_controllers.containsKey(slug)) {
      _controllers[slug] = TextEditingController(
        text: _values[slug]?.toString() ?? '',
      );
    }
    return _controllers[slug]!;
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

  bool _isAttributeApplicable(ConcoursFormAttributeModel attribute) {
    final selectedCandidateTypeId = _selectedCandidateTypeId;
    if (selectedCandidateTypeId == null) {
      return false;
    }
    return attribute.candidateTypeIds.isEmpty ||
        attribute.candidateTypeIds.contains(selectedCandidateTypeId);
  }

  List<ConcoursFormSectionModel> _visibleSections() {
    if (_form == null) {
      return [];
    }

    final selectedCandidateTypeId = _selectedCandidateTypeId;
    if (selectedCandidateTypeId == null) {
      return [];
    }

    return _form!.sections
        .map((section) {
          final visibleAttributes = section.attributes
              .where(_isAttributeApplicable)
              .toList();
          if (visibleAttributes.isEmpty) {
            return null;
          }
          return ConcoursFormSectionModel(
            id: section.id,
            code: section.code,
            name: section.name,
            orderNumber: section.orderNumber,
            attributes: visibleAttributes,
          );
        })
        .whereType<ConcoursFormSectionModel>()
        .toList();
  }

  Widget _buildField(ConcoursFormAttributeModel attribute) {
    final label = attribute.name.trim().isEmpty
        ? attribute.slug
        : attribute.name;

    switch (attribute.type.toLowerCase()) {
      case 'text':
        return TextFormField(
          focusNode: _focusNodeFor(attribute.slug),
          controller: _controllerFor(attribute.slug),
          maxLines: 4,
          decoration: _inputDecoration(label, Icons.notes_outlined),
          onChanged: (value) => _updateValue(attribute.slug, value),
          validator: (value) {
            if (attribute.required && (value == null || value.trim().isEmpty)) {
              return 'Champ obligatoire';
            }
            return null;
          },
        );
      case 'date':
        return TextFormField(
          focusNode: _focusNodeFor(attribute.slug),
          controller: _controllerFor(attribute.slug),
          readOnly: true,
          onTap: () => _pickDate(attribute.slug),
          decoration: _inputDecoration(label, Icons.calendar_today_outlined)
              .copyWith(
                suffixIcon: const Icon(
                  Icons.calendar_month,
                  color: Color(0xff1E4DB7),
                ),
              ),
          onChanged: (value) => _updateValue(attribute.slug, value),
          validator: (value) {
            if (attribute.required && (value == null || value.trim().isEmpty)) {
              return 'Champ obligatoire';
            }
            return null;
          },
        );
      case 'country':
        return TextFormField(
          focusNode: _focusNodeFor(attribute.slug),
          controller: _controllerFor(attribute.slug),
          decoration: _inputDecoration(
            label,
            Icons.flag_outlined,
          ).copyWith(hintText: 'ID numérique ou nom exact du pays'),
          onChanged: (value) => _updateValue(attribute.slug, value),
          validator: (value) {
            if (attribute.required && (value == null || value.trim().isEmpty)) {
              return 'Champ obligatoire';
            }
            return null;
          },
        );
      case 'sexe':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['Homme', 'Femme'].map((value) {
                final selected = _values[attribute.slug] == value;
                return ChoiceChip(
                  label: Text(value),
                  selected: selected,
                  onSelected: (_) => _updateValue(attribute.slug, value),
                );
              }).toList(),
            ),
          ],
        );
      case 'field':
        return DropdownButtonFormField<String>(
          focusNode: _focusNodeFor(attribute.slug),
          initialValue: _values[attribute.slug]?.toString(),
          decoration: _inputDecoration(label, Icons.school_outlined),
          items: _filiereOptions
              .map(
                (filiere) => DropdownMenuItem<String>(
                  value: filiere.id.toString(),
                  child: Text(filiere.nom),
                ),
              )
              .toList(),
          onChanged: (value) => _updateValue(attribute.slug, value),
          validator: (value) {
            if (attribute.required && (value == null || value.isEmpty)) {
              return 'Champ obligatoire';
            }
            return null;
          },
        );
      case 'image':
      case 'document':
        return UploadDocumentCard(
          icon: attribute.type.toLowerCase() == 'image'
              ? Icons.photo_camera_outlined
              : Icons.description_outlined,
          title: label,
          subtitle: attribute.type.toLowerCase() == 'image'
              ? 'Prendre une photo ou choisir une image'
              : 'Prendre une photo, choisir une image ou sélectionner un document',
          isImageField: attribute.type.toLowerCase() == 'image',
          onFileSelected: (file) {
            if (file != null) {
              setState(() {
                _attachedFiles[attribute.slug] = file;
                _values[attribute.slug] = file.path;
              });
            }
          },
        );
      case 'varchar':
      default:
        return TextFormField(
          focusNode: _focusNodeFor(attribute.slug),
          controller: _controllerFor(attribute.slug),
          decoration: _inputDecoration(label, Icons.edit_outlined),
          onChanged: (value) => _updateValue(attribute.slug, value),
          validator: (value) {
            if (attribute.required && (value == null || value.trim().isEmpty)) {
              return 'Champ obligatoire';
            }
            return null;
          },
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final visibleSections = _visibleSections();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xffF5F7FA),
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              CandidatureHeader(onBack: () => Navigator.pop(context)),
              StepIndicator(currentStep: _currentStage),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        controller: _scrollController,
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (_errorMessage != null)
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    _errorMessage!,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ),
                              const SizedBox(height: 12),
                              const Text(
                                'Formulaire de candidature',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Complétez uniquement les champs visibles pour votre type de candidat.',
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                              const SizedBox(height: 20),
                              const SizedBox(height: 20),
                              if (_currentStage == 1) ...[
                                if (_form != null &&
                                    _form!.candidateTypes.length > 1)
                                  DropdownButtonFormField<String>(
                                    initialValue: _selectedCandidateTypeId,
                                    decoration: _inputDecoration(
                                      'Type de candidat',
                                      Icons.school_outlined,
                                    ),
                                    items: _form!.candidateTypes
                                        .map(
                                          (type) => DropdownMenuItem<String>(
                                            value: type.id,
                                            child: Text(type.name),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedCandidateTypeId = value;
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Veuillez sélectionner un type';
                                      }
                                      return null;
                                    },
                                  ),
                                if (_form != null &&
                                    _form!.candidateTypes.length == 1)
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'Type de candidat : ${_form!.candidateTypes.first.name}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 20),
                                Padding(
                                  key: _fieldKeyFor('email'),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4.0,
                                  ),
                                  child: TextFormField(
                                    focusNode: _focusNodeFor('email'),
                                    controller: _controllerFor('email'),
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: _inputDecoration(
                                      'Email',
                                      Icons.email_outlined,
                                    ),
                                    onChanged: (value) =>
                                        _updateValue('email', value),
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'Champ obligatoire';
                                      }
                                      final email = value.trim();
                                      if (!RegExp(
                                        r"^[^@\s]+@[^@\s]+\.[^@\s]+",
                                      ).hasMatch(email)) {
                                        return 'Adresse email invalide';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Un code OTP sera envoyé à cette adresse pour vérifier votre email avant de compléter la candidature.',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ] else if (_currentStage == 2) ...[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton.icon(
                                      onPressed: _isSubmitting
                                          ? null
                                          : () {
                                              setState(() {
                                                _currentStage = 1;
                                                for (final controller
                                                    in _otpControllers) {
                                                  controller.clear();
                                                }
                                              });
                                            },
                                      icon: const Icon(Icons.arrow_back),
                                      label: const Text('Retour'),
                                    ),
                                    Chip(
                                      label: const Text('Étape 2 sur 3'),
                                      backgroundColor: Colors.blue.shade50,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                if (_selectedCandidateTypeId != null)
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (_form != null)
                                          Text(
                                            'Type de candidat : ${_form!.candidateTypes.firstWhere((type) => type.id == _selectedCandidateTypeId).name}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        const SizedBox(height: 8),
                                        if (_values['email'] != null)
                                          Text(
                                            'Email : ${_values['email']}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                const SizedBox(height: 24),
                                const Text(
                                  'Entrez le code à 6 chiffres envoyé à votre email.',
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: List.generate(6, (index) {
                                    return Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          right: index < 5 ? 10 : 0,
                                        ),
                                        child: TextFormField(
                                          controller: _otpControllers[index],
                                          keyboardType: TextInputType.number,
                                          textAlign: TextAlign.center,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            LengthLimitingTextInputFormatter(1),
                                          ],
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          onChanged: (value) {
                                            if (value.length == 1 &&
                                                index < 5) {
                                              FocusScope.of(
                                                context,
                                              ).nextFocus();
                                            }
                                            if (value.isEmpty && index > 0) {
                                              FocusScope.of(
                                                context,
                                              ).previousFocus();
                                            }
                                          },
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                                const SizedBox(height: 16),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: _isSubmitting
                                        ? null
                                        : _resendOtpCode,
                                    child: const Text('Renvoyer le code'),
                                  ),
                                ),
                              ] else ...[
                                if (visibleSections.isEmpty)
                                  const Text(
                                    'Aucun champ disponible pour ce candidat.',
                                  )
                                else
                                  for (final section in visibleSections)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 20,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            section.name,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          for (final attribute
                                              in section.attributes.where((
                                                attribute,
                                              ) {
                                                return (attribute
                                                            .candidateTypeIds
                                                            .isEmpty ||
                                                        attribute
                                                            .candidateTypeIds
                                                            .contains(
                                                              _selectedCandidateTypeId,
                                                            )) &&
                                                    attribute.slug != 'email';
                                              }).toList())
                                            Padding(
                                              key: _fieldKeyFor(attribute.slug),
                                              padding: const EdgeInsets.only(
                                                bottom: 14,
                                              ),
                                              child: _buildField(attribute),
                                            ),
                                        ],
                                      ),
                                    ),
                              ],
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                height: 55,
                                child: ElevatedButton(
                                  onPressed: _isSubmitting ? null : _submit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff1565C0),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: _isSubmitting
                                      ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Text(
                                          _currentStage == 1
                                              ? 'Envoyer le code'
                                              : _currentStage == 2
                                              ? 'Vérifier le code'
                                              : 'Passer à la confirmation',
                                          style: const TextStyle(
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
