import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import '../../models/registration/registration_referential_model.dart';
import '../../services/registration/registration_service.dart';

enum RegistrationFlowStatus { idle, loading, submitting, success, error }

class RegistrationProvider extends ChangeNotifier {
  final RegistrationService _service = RegistrationService();

  RegistrationFlowStatus status = RegistrationFlowStatus.idle;
  String? message;
  RegistrationReferentialCollection? referentials;
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
        break;
      case 'group':
        draft = draft.copyWith(group: option);
        break;
    }
    notifyListeners();
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
      for (final document in documents) {
        await _service.uploadDocument(document);
      }

      final payload = await _service.submitRegistration(draft, documents);
      if (payload.isEmpty) {
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
