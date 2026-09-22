import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import '../../data/local/registration_local_datasource.dart';
import '../../data/remote/registration_remote_datasource.dart';
import '../../data/repositories/registration_repository.dart';
import '../../models/profile/user_model.dart';
import '../../models/registration/registration_referential_model.dart';
import '../../models/registration/registration_status_model.dart';
import '../../models/registration/registration_submit_outcome.dart';
import '../../services/profile/profile_service.dart';

enum RegistrationFlowStatus { idle, loading, saving, submitting, success, error }

class RegistrationProvider extends ChangeNotifier {
  final RegistrationRepository _repository;
  final ProfileService _profileService;

  RegistrationProvider({
    RegistrationRepository? repository,
    ProfileService? profileService,
  })  : _repository = repository ??
            RegistrationRepository(
              local: RegistrationLocalDatasource(),
              remote: RegistrationRemoteDatasource(),
            ),
        _profileService = profileService ?? ProfileService();

  RegistrationFlowStatus status = RegistrationFlowStatus.idle;
  RegistrationSubmitOutcome? lastSubmitOutcome;
  String? message;
  int? localDraftId;
  RegistrationReferentialCollection? referentials;
  RegistrationStatus? registrationStatus;
  bool isRegistrationStatusLoading = false;
  String? registrationStatusError;
  UserModel? userProfile;
  RegistrationDraft draft = const RegistrationDraft();
  final List<RegistrationDocument> documents = [];
  int currentStep = 1;

  Future<void> loadReferentials() async {
    status = RegistrationFlowStatus.loading;
    message = null;
    notifyListeners();

    try {
      await _loadUserProfile();
      referentials = await _repository.getReferentials();
      registrationStatus = await _repository.getRegistrationStatus();
      if (registrationStatus?.activeSchoolYear != null && draft.schoolYear == null) {
        draft = draft.copyWith(schoolYear: registrationStatus!.activeSchoolYear);
      }
      status = RegistrationFlowStatus.idle;
    } catch (error) {
      status = RegistrationFlowStatus.error;
      message = "Impossible de charger les référentiels.";
    }

    notifyListeners();
  }

  Future<void> _loadUserProfile() async {
    try {
      userProfile = await _profileService.getProfile();
      if (userProfile != null && userProfile!.firstName.isNotEmpty) {
        draft = draft.copyWith(
          firstName: draft.firstName.isEmpty ? userProfile!.firstName : draft.firstName,
          lastName: draft.lastName.isEmpty ? userProfile!.lastName : draft.lastName,
          email: draft.email.isEmpty ? userProfile!.email : draft.email,
          phone: draft.phone.isEmpty ? userProfile!.phone : draft.phone,
          matricule: draft.matricule.isEmpty ? userProfile!.matricule : draft.matricule,
        );
      }
    } catch (_) {
      // Continue seamlessly if profile cannot be fetched
    }
  }

  Future<void> loadRegistrationStatus() async {
    isRegistrationStatusLoading = true;
    registrationStatusError = null;
    notifyListeners();

    try {
      final stat = await _repository.getRegistrationStatus();
      registrationStatus = stat;
      if (stat.activeSchoolYear != null && draft.schoolYear == null) {
        draft = draft.copyWith(schoolYear: stat.activeSchoolYear);
      }
    } catch (error) {
      registrationStatusError = 'Impossible de vérifier l’état des inscriptions.';
    }

    isRegistrationStatusLoading = false;
    notifyListeners();
  }

  /// Resume and restore an existing local draft
  Future<void> resumeDraft(int draftId) async {
    try {
      final draftRow = await _repository.getDraft(draftId);
      if (draftRow != null) {
        localDraftId = draftId;
        final decoded = jsonDecode(draftRow.dataJson);
        draft = RegistrationDraft.fromJson(decoded);

        // Load existing attached documents
        final docRows = await _repository.getDocumentsForDraft(draftId);
        documents.clear();
        for (final doc in docRows) {
          documents.add(RegistrationDocument(
            fileName: doc.fileName ?? doc.localPath.split('/').last,
            filePath: doc.localPath,
            type: doc.documentType ?? doc.mimeType ?? 'OTHER',
            sizeBytes: doc.size ?? 0,
          ));
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('[REGISTRATION_PROVIDER] Error resuming draft: $e');
    }
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
      if (RegExp(r'\b' + number.toString() + r'\b').hasMatch(label)) {
        return opt;
      }
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
      message = 'Pièce ajoutée.';
      notifyListeners();
    } catch (error) {
      status = RegistrationFlowStatus.error;
      message = 'Impossible de sélectionner le fichier.';
      notifyListeners();
    }
  }

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
      message = 'Pièce ajoutée.';
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

  /// Persist draft and documents locally, then submit through offline queue
  Future<RegistrationSubmitOutcome> submitRegistration() async {
    status = RegistrationFlowStatus.submitting;
    message = null;
    notifyListeners();

    try {
      // 1. Save or update draft locally
      final int draftId;
      if (localDraftId != null) {
        draftId = localDraftId!;
        await _repository.updateDraftLocally(draftId: draftId, draft: draft);
      } else {
        draftId = await _repository.saveDraftLocally(draft: draft, status: 'draft');
        localDraftId = draftId;
      }

      // 2. Attach and permanently persist all selected documents
      for (final doc in documents) {
        final file = File(doc.filePath);
        if (await file.exists()) {
          await _repository.attachDocumentToDraft(
            draftId: draftId,
            file: file,
            fileName: doc.fileName,
            mimeType: doc.type,
            documentType: doc.type,
          );
        }
      }

      // 3. Submit draft through repository
      final outcome = await _repository.submitDraft(draftId);
      lastSubmitOutcome = outcome;

      switch (outcome) {
        case RegistrationSubmitOutcome.submittedOnline:
          status = RegistrationFlowStatus.success;
          message = 'Inscription académique soumise avec succès.';
          break;
        case RegistrationSubmitOutcome.queuedOffline:
          status = RegistrationFlowStatus.success;
          message = 'Votre demande est enregistrée localement et sera synchronisée dès le retour de la connexion.';
          break;
        case RegistrationSubmitOutcome.queuedAfterError:
          status = RegistrationFlowStatus.success;
          message = 'Votre demande est enregistrée localement. La synchronisation se poursuit en arrière-plan.';
          break;
        case RegistrationSubmitOutcome.requiresAuthentication:
          status = RegistrationFlowStatus.error;
          message = 'Vous devez vous connecter pour continuer votre inscription.';
          break;
        case RegistrationSubmitOutcome.alreadySubmittedElsewhere:
          status = RegistrationFlowStatus.error;
          message = 'Une demande est déjà soumise via cet email. Consultez-la sur votre tableau de bord.';
          break;
        case RegistrationSubmitOutcome.failed:
          status = RegistrationFlowStatus.error;
          message = 'Une erreur est survenue lors de l’enregistrement.';
          break;
      }

      notifyListeners();
      return outcome;
    } catch (error) {
      status = RegistrationFlowStatus.error;
      message = 'Une erreur inattendue est survenue.';
      lastSubmitOutcome = RegistrationSubmitOutcome.failed;
      notifyListeners();
      return RegistrationSubmitOutcome.failed;
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
    localDraftId = null;
    currentStep = 1;
    status = RegistrationFlowStatus.idle;
    message = null;
    lastSubmitOutcome = null;
    notifyListeners();
  }
}
