import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import '../../models/registration/registration_referential_model.dart';
import '../../models/registration/registration_status_model.dart';
import '../../services/registration/registration_service.dart';

enum RegistrationFlowStatus { idle, loading, submitting, success, error }

class RegistrationProvider extends ChangeNotifier {
  final RegistrationService _service = RegistrationService();

  RegistrationFlowStatus status = RegistrationFlowStatus.idle;
  String? message;
  RegistrationReferentialCollection? referentials;
  RegistrationStatus? registrationStatus;
  bool isRegistrationStatusLoading = false;
  String? registrationStatusError;
  RegistrationDraft draft = const RegistrationDraft();
  final List<RegistrationDocument> documents = [];
  int currentStep = 1;

  Future<void> loadReferentials() async {
    status = RegistrationFlowStatus.loading;
    message = null;
    notifyListeners();

    try {
      referentials = await _service.getReferentials();
      status = RegistrationFlowStatus.idle;
    } catch (error) {
      status = RegistrationFlowStatus.error;
      message = 'Impossible de charger les référentiels depuis l’API.';
    }

    notifyListeners();
  }

  Future<void> loadRegistrationStatus() async {
    isRegistrationStatusLoading = true;
    registrationStatusError = null;
    notifyListeners();

    try {
      final status = await _service.getRegistrationStatus();
      registrationStatus = status;
      if (status.activeSchoolYear != null && draft.schoolYear == null) {
        draft = draft.copyWith(schoolYear: status.activeSchoolYear);
      }
    } catch (error) {
      registrationStatusError =
          'Impossible de vérifier l’état des inscriptions.';
    }

    isRegistrationStatusLoading = false;
    notifyListeners();
  }

  void updateDraft(RegistrationDraft newDraft) {
    draft = newDraft;
    notifyListeners();
  }

  void updateField(String field, String value) {
    switch (field) {
      case 'firstName':
        draft = draft.copyWith(firstName: value);
        break;
      case 'lastName':
        draft = draft.copyWith(lastName: value);
        break;
      case 'email':
        draft = draft.copyWith(email: value);
        break;
      case 'phone':
        draft = draft.copyWith(phone: value);
        break;
      case 'matricule':
        draft = draft.copyWith(matricule: value);
        break;
      case 'author':
        draft = draft.copyWith(author: value);
        break;
    }
    notifyListeners();
  }

  void toggleAlreadyRegistered(bool value) {
    draft = draft.copyWith(alreadyRegistered: value);
    notifyListeners();
  }

  void selectOption(String field, RegistrationOption? option) {
    switch (field) {
      case 'schoolYear':
        draft = draft.copyWith(schoolYear: option);
        break;
      case 'status':
        draft = draft.copyWith(status: option);
        break;
      case 'filiere':
        draft = draft.copyWith(filiere: option);
        break;
      case 'grade':
        draft = draft.copyWith(grade: option);
        _applyDefaultSemestersForGrade(option);
        break;
      case 'group':
        draft = draft.copyWith(group: option);
        break;
    }
    notifyListeners();
  }

  void _applyDefaultSemestersForGrade(RegistrationOption? gradeOption) {
    if (gradeOption == null) return;
    if (referentials == null) return;

    // If user already added semesters manually, don't override.
    if (draft.semesters.isNotEmpty) return;

    final label = gradeOption.label.toLowerCase();
    int? level;
    bool isLicence = false;
    bool isMaster = false;

    final licenceMatch = RegExp(r'licen?ce\s*(\d+)', caseSensitive: false).firstMatch(label);
    final masterMatch = RegExp(r'master\s*(\d+)', caseSensitive: false).firstMatch(label);

    if (licenceMatch != null) {
      level = int.tryParse(licenceMatch.group(1) ?? '');
      isLicence = true;
    } else if (masterMatch != null) {
      level = int.tryParse(masterMatch.group(1) ?? '');
      isMaster = true;
    }

    if (level == null) return;

    int startSemester;
    if (isLicence) {
      startSemester = 1 + (level - 1) * 2;
    } else if (isMaster) {
      startSemester = 7 + (level - 1) * 2;
    } else {
      return;
    }

    final s1 = _findSemesterOptionByNumber(startSemester);
    final s2 = _findSemesterOptionByNumber(startSemester + 1);

    final entries = <RegistrationSemesterEntry>[];
    if (s1 != null) entries.add(RegistrationSemesterEntry(semester: s1));
    if (s2 != null) entries.add(RegistrationSemesterEntry(semester: s2));

    if (entries.isNotEmpty) {
      draft = draft.copyWith(semesters: entries);
      notifyListeners();
    }
  }

  RegistrationOption? _findSemesterOptionByNumber(int number) {
    final sems = referentials?.semesters ?? [];
    for (final opt in sems) {
      final label = opt.label.toLowerCase();
      // match exact number occurrence
      if (RegExp(r'\b' + number.toString() + r'\b').hasMatch(label)) {
        return opt;
      }
      // try value if contains number
      if (opt.value.toLowerCase().contains(number.toString())) return opt;
      if (opt.id.toString() == number.toString()) return opt;
    }
    return null;
  }

  void addSemester() {
    final semesters = List<RegistrationSemesterEntry>.from(draft.semesters)
      ..add(const RegistrationSemesterEntry());
    draft = draft.copyWith(semesters: semesters);
    notifyListeners();
  }

  void removeSemester(int index) {
    final semesters = List<RegistrationSemesterEntry>.from(draft.semesters);
    if (index < semesters.length) {
      semesters.removeAt(index);
      draft = draft.copyWith(semesters: semesters);
      notifyListeners();
    }
  }

  void updateSemester(
    int index, {
    RegistrationOption? semester,
    RegistrationOption? status,
  }) {
    final semesters = List<RegistrationSemesterEntry>.from(draft.semesters);
    if (index < semesters.length) {
      semesters[index] = semesters[index].copyWith(
        semester: semester,
        status: status,
      );
      draft = draft.copyWith(semesters: semesters);
      notifyListeners();
    }
  }

  Future<void> pickDocument(String type) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'pdf',
          'doc',
          'docx',
          'jpg',
          'jpeg',
          'png',
          'gif',
          'webp',
        ],
      );

      if (result == null || result.files.isEmpty) {
        return;
      }

      final file = result.files.first;
      if (file.size > 5 * 1024 * 1024) {
        status = RegistrationFlowStatus.error;
        message = 'La taille maximale autorisée est de 5 Mo.';
        notifyListeners();
        return;
      }

      final platformFile = file;
      final document = RegistrationDocument(
        fileName: platformFile.name,
        filePath: platformFile.path ?? '',
        type: type,
        sizeBytes: platformFile.size,
      );

      documents.add(document);
      status = RegistrationFlowStatus.success;
      message = 'Pièce ajoutée avec succès.';
      notifyListeners();
    } catch (error) {
      status = RegistrationFlowStatus.error;
      message = 'Impossible de sélectionner le fichier.';
      notifyListeners();
    }
  }

  /// Add a picked file (already on device) as a registration document.
  void addDocumentFromFilePath({
    required String filePath,
    required String fileName,
    required String type,
  }) {
    try {
      final file = File(filePath);
      final size = file.existsSync() ? file.lengthSync() : 0;
      final document = RegistrationDocument(
        fileName: fileName,
        filePath: filePath,
        type: type,
        sizeBytes: size,
      );

      documents.add(document);
      status = RegistrationFlowStatus.success;
      message = 'Pièce ajoutée avec succès.';
      notifyListeners();
    } catch (e) {
      status = RegistrationFlowStatus.error;
      message = 'Impossible d’ajouter la pièce.';
      notifyListeners();
    }
  }

  void removeDocument(int index) {
    if (index < documents.length) {
      documents.removeAt(index);
      notifyListeners();
    }
  }

  Future<bool> submitRegistration() async {
    status = RegistrationFlowStatus.submitting;
    message = null;
    notifyListeners();

    try {
      final success = await _service.submitRegistration(draft, documents);
      if (!success) {
        status = RegistrationFlowStatus.error;
        message = 'Échec de la soumission. Veuillez réessayer.';
        notifyListeners();
        return false;
      }

      status = RegistrationFlowStatus.success;
      message = 'Inscription académique soumise avec succès.';
      notifyListeners();
      return true;
    } catch (error) {
      status = RegistrationFlowStatus.error;
      message = 'Une erreur est survenue pendant la soumission.';
      notifyListeners();
      return false;
    }
  }

  void nextStep() {
    if (currentStep < 4) {
      currentStep += 1;
      notifyListeners();
    }
  }

  void previousStep() {
    if (currentStep > 1) {
      currentStep -= 1;
      notifyListeners();
    }
  }

  void reset() {
    draft = const RegistrationDraft();
    documents.clear();
    currentStep = 1;
    status = RegistrationFlowStatus.idle;
    message = null;
    notifyListeners();
  }
}
