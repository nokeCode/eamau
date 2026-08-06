import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/registration/registration_referential_model.dart';
import '../../providers/registration/registration_provider.dart';
import '../../widgets/registration/confirmation_card.dart';
import '../../widgets/registration/enum_dropdown.dart';
import '../../widgets/registration/registration_card.dart';
import '../../widgets/registration/registration_stepper.dart';
import '../../widgets/registration/summary_tile.dart';
import '../../widgets/registration/upload_card.dart';
import '../../widgets/registration/upload_preview.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String? _selectedDocumentType;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RegistrationProvider>().loadReferentials();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RegistrationProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('Inscription académique'),
        backgroundColor: const Color(0xFF0F4DA8),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            RegistrationStepper(currentStep: provider.currentStep),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _buildStepContent(provider),
              ),
            ),
            _buildNavigationBar(provider),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent(RegistrationProvider provider) {
    switch (provider.currentStep) {
      case 1:
        return _buildStepOne(provider);
      case 2:
        return _buildStepTwo(provider);
      case 3:
        return _buildStepThree(provider);
      default:
        return _buildStepFour(provider);
    }
  }

  Widget _buildStepOne(RegistrationProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RegistrationCard(
            title: 'Informations personnelles',
            subtitle: 'Les référentiels sont chargés depuis l’API Symfony.',
            child: Column(
              children: [
                _buildTextField(
                  label: 'Prénom',
                  value: provider.draft.firstName,
                  field: 'firstName',
                  provider: provider,
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  label: 'Nom',
                  value: provider.draft.lastName,
                  field: 'lastName',
                  provider: provider,
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  label: 'Email',
                  value: provider.draft.email,
                  field: 'email',
                  provider: provider,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  label: 'Téléphone',
                  value: provider.draft.phone,
                  field: 'phone',
                  provider: provider,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                CheckboxListTile(
                  value: provider.draft.alreadyRegistered,
                  onChanged: (value) =>
                      provider.toggleAlreadyRegistered(value ?? false),
                  title: const Text('Déjà inscrit ?'),
                  contentPadding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: provider.draft.alreadyRegistered
                      ? Padding(
                          key: const ValueKey('matricule'),
                          padding: const EdgeInsets.only(top: 4),
                          child: _buildTextField(
                            label: 'Matricule',
                            value: provider.draft.matricule,
                            field: 'matricule',
                            provider: provider,
                          ),
                        )
                      : const SizedBox.shrink(key: ValueKey('empty')),
                ),
                const SizedBox(height: 10),
                EnumDropdown<RegistrationOption>(
                  label: 'Année scolaire',
                  value: provider.draft.schoolYear,
                  items: provider.referentials?.schoolYears ?? [],
                  labelBuilder: (option) =>
                      option.label.isEmpty ? option.value : option.label,
                  onChanged: (value) =>
                      provider.selectOption('schoolYear', value),
                  icon: Icons.calendar_today_outlined,
                ),
                const SizedBox(height: 10),
                EnumDropdown<RegistrationOption>(
                  label: 'Statut',
                  value: provider.draft.status,
                  items: provider.referentials?.statuses ?? [],
                  labelBuilder: (option) =>
                      option.label.isEmpty ? option.value : option.label,
                  onChanged: (value) => provider.selectOption('status', value),
                  icon: Icons.verified_user_outlined,
                ),
                const SizedBox(height: 10),
                EnumDropdown<RegistrationOption>(
                  label: 'Filière',
                  value: provider.draft.filiere,
                  items: provider.referentials?.filieres ?? [],
                  labelBuilder: (option) =>
                      option.label.isEmpty ? option.value : option.label,
                  onChanged: (value) => provider.selectOption('filiere', value),
                  icon: Icons.school_outlined,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (provider.status == RegistrationFlowStatus.loading)
            const Center(child: CircularProgressIndicator()),
          if (provider.status == RegistrationFlowStatus.error &&
              provider.message != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF1F0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                provider.message!,
                style: const TextStyle(color: Color(0xFFB00020)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStepTwo(RegistrationProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: RegistrationCard(
        title: 'Détails académiques',
        subtitle: 'Choisissez le grade, le groupe et l’auteur du dossier.',
        child: Column(
          children: [
            EnumDropdown<RegistrationOption>(
              label: 'Grade',
              value: provider.draft.grade,
              items: provider.referentials?.grades ?? [],
              labelBuilder: (option) =>
                  option.label.isEmpty ? option.value : option.label,
              onChanged: (value) => provider.selectOption('grade', value),
              icon: Icons.workspace_premium_outlined,
            ),
            const SizedBox(height: 10),
            EnumDropdown<RegistrationOption>(
              label: 'Groupe',
              value: provider.draft.group,
              items: provider.referentials?.groups ?? [],
              labelBuilder: (option) =>
                  option.label.isEmpty ? option.value : option.label,
              onChanged: (value) => provider.selectOption('group', value),
              icon: Icons.groups_outlined,
            ),
            const SizedBox(height: 10),
            _buildTextField(
              label: 'Auteur',
              value: provider.draft.author,
              field: 'author',
              provider: provider,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepThree(RegistrationProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RegistrationCard(
            title: 'Semestres',
            subtitle:
                'Ajoutez autant de semestres que nécessaire et validez-les.',
            child: Column(
              children: [
                for (
                  var index = 0;
                  index < provider.draft.semesters.length;
                  index++
                )
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFF),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFDBE7FF)),
                    ),
                    child: Column(
                      children: [
                        EnumDropdown<RegistrationOption>(
                          label: 'Semestre',
                          value: provider.draft.semesters[index].semester,
                          items: provider.referentials?.semesters ?? [],
                          labelBuilder: (option) => option.label.isEmpty
                              ? option.value
                              : option.label,
                          onChanged: (value) =>
                              provider.updateSemester(index, semester: value),
                          icon: Icons.menu_book_outlined,
                        ),
                        const SizedBox(height: 10),
                        EnumDropdown<RegistrationOption>(
                          label: 'Statut du semestre',
                          value: provider.draft.semesters[index].status,
                          items: provider.referentials?.statuses ?? [],
                          labelBuilder: (option) => option.label.isEmpty
                              ? option.value
                              : option.label,
                          onChanged: (value) =>
                              provider.updateSemester(index, status: value),
                          icon: Icons.toggle_on_outlined,
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: () => provider.removeSemester(index),
                            icon: const Icon(Icons.delete_outline),
                            label: const Text('Supprimer'),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 6),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: provider.addSemester,
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text('Ajouter semestre'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F4DA8),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepFour(RegistrationProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConfirmationCard(
            title: 'Confirmation',
            content:
                'Vérifiez le résumé et téléversez les pièces justificatives avant de valider.',
            icon: Icons.fact_check_outlined,
          ),
          const SizedBox(height: 12),
          RegistrationCard(
            title: 'Résumé',
            child: Column(
              children: [
                SummaryTile(label: 'Prénom', value: provider.draft.firstName),
                SummaryTile(label: 'Nom', value: provider.draft.lastName),
                SummaryTile(label: 'Email', value: provider.draft.email),
                SummaryTile(label: 'Téléphone', value: provider.draft.phone),
                SummaryTile(
                  label: 'Déjà inscrit',
                  value: provider.draft.alreadyRegistered ? 'Oui' : 'Non',
                ),
                SummaryTile(
                  label: 'Matricule',
                  value: provider.draft.matricule,
                ),
                SummaryTile(
                  label: 'Année scolaire',
                  value: provider.draft.schoolYear?.label ?? '',
                ),
                SummaryTile(
                  label: 'Statut',
                  value: provider.draft.status?.label ?? '',
                ),
                SummaryTile(
                  label: 'Filière',
                  value: provider.draft.filiere?.label ?? '',
                ),
                SummaryTile(
                  label: 'Grade',
                  value: provider.draft.grade?.label ?? '',
                ),
                SummaryTile(
                  label: 'Groupe',
                  value: provider.draft.group?.label ?? '',
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          RegistrationCard(
            title: 'Pièces justificatives',
            subtitle: 'PDF, DOC, DOCX et images sont acceptés jusqu’à 5 Mo.',
            child: Column(
              children: [
                UploadCard(
                  label: 'Ajouter une pièce',
                  selectedType: _selectedDocumentType,
                  options:
                      provider.referentials?.documentTypes
                          .map(
                            (item) =>
                                item.label.isEmpty ? item.value : item.label,
                          )
                          .toList() ??
                      const [],
                  onPick: () {
                    if (_selectedDocumentType == null ||
                        _selectedDocumentType!.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Sélectionnez d’abord un type de pièce.',
                          ),
                        ),
                      );
                      return;
                    }
                    provider.pickDocument(_selectedDocumentType!);
                  },
                  onTypeChanged: (value) {
                    setState(() {
                      _selectedDocumentType = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                UploadPreview(
                  documents: provider.documents,
                  onRemove: (index) => provider.removeDocument(index),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          if (provider.status == RegistrationFlowStatus.error &&
              provider.message != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF1F0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                provider.message!,
                style: const TextStyle(color: Color(0xFFB00020)),
              ),
            ),
          if (provider.status == RegistrationFlowStatus.success &&
              provider.message != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                provider.message!,
                style: const TextStyle(color: Color(0xFF2E7D32)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNavigationBar(RegistrationProvider provider) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        children: [
          if (provider.currentStep > 1)
            Expanded(
              child: OutlinedButton(
                onPressed: provider.previousStep,
                child: const Text('Précédent'),
              ),
            ),
          if (provider.currentStep > 1) const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: provider.currentStep == 4
                  ? () async {
                      final submitted = await provider.submitRegistration();
                      if (submitted && mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Inscription académique enregistrée.',
                            ),
                          ),
                        );
                      }
                    }
                  : provider.nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F4DA8),
                foregroundColor: Colors.white,
              ),
              child: provider.status == RegistrationFlowStatus.submitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(provider.currentStep == 4 ? 'Valider' : 'Suivant'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String value,
    required String field,
    required RegistrationProvider provider,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      initialValue: value,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xFFF5F7FB),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: (newValue) => provider.updateField(field, newValue),
    );
  }
}
