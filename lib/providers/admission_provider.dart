import 'dart:io';

import 'package:flutter/foundation.dart';

import '../core/database/app_database.dart' as adb;
import '../data/local/admission_local_datasource.dart';
import '../data/remote/admission_remote_datasource.dart';
import '../data/repositories/admission_repository.dart';

enum AdmissionFlowStatus { idle, loading, saving, submitting, success, error }

class AdmissionProvider extends ChangeNotifier {
  final AdmissionRepository _repository;

  AdmissionProvider({AdmissionRepository? repository})
      : _repository = repository ??
            AdmissionRepository(
              local: AdmissionLocalDatasource(),
              remote: AdmissionRemoteDatasource(),
            );

  AdmissionFlowStatus status = AdmissionFlowStatus.idle;
  String? message;
  List<adb.AdmissionDraft> _drafts = [];

  List<adb.AdmissionDraft> get drafts => _drafts;

  Future<void> loadDrafts() async {
    status = AdmissionFlowStatus.loading;
    message = null;
    notifyListeners();

    try {
      _drafts = await _repository.getLocalDrafts();
      status = AdmissionFlowStatus.idle;
    } catch (error) {
      status = AdmissionFlowStatus.error;
      message = 'Impossible de charger les dossiers d’admission locaux.';
    }

    notifyListeners();
  }

  Future<int> saveDraft(
    Map<String, dynamic> draftData, {
    String statusValue = 'draft',
  }) async {
    status = AdmissionFlowStatus.saving;
    message = null;
    notifyListeners();

    try {
      final draftId = await _repository.saveDraftLocally(
        draftData: draftData,
        status: statusValue,
      );
      await loadDrafts();
      status = AdmissionFlowStatus.success;
      message = 'Brouillon enregistré localement.';
      notifyListeners();
      return draftId;
    } catch (error) {
      status = AdmissionFlowStatus.error;
      message = 'L’enregistrement du brouillon a échoué.';
      notifyListeners();
      rethrow;
    }
  }

  Future<int> attachDocumentToDraft({
    required int draftId,
    required File file,
    required String fileName,
    required String mimeType,
    String? attachmentType,
  }) async {
    status = AdmissionFlowStatus.saving;
    message = null;
    notifyListeners();

    try {
      final docId = await _repository.attachDocumentToDraft(
        draftId: draftId,
        file: file,
        fileName: fileName,
        mimeType: mimeType,
        attachmentType: attachmentType,
      );
      status = AdmissionFlowStatus.success;
      message = 'Pièce jointe enregistrée localement.';
      notifyListeners();
      return docId;
    } catch (error) {
      status = AdmissionFlowStatus.error;
      message = 'Impossible d’ajouter la pièce jointe.';
      notifyListeners();
      rethrow;
    }
  }

  Future<bool> submitDraft(int draftId) async {
    status = AdmissionFlowStatus.submitting;
    message = null;
    notifyListeners();

    try {
      final success = await _repository.submitDraft(draftId);
      if (!success) {
        status = AdmissionFlowStatus.error;
        message = 'La soumission a échoué.';
        notifyListeners();
        return false;
      }

      await loadDrafts();
      status = AdmissionFlowStatus.success;
      message = 'Demande d’admission soumise avec succès.';
      notifyListeners();
      return true;
    } catch (error) {
      status = AdmissionFlowStatus.error;
      message = 'Une erreur est survenue pendant la soumission.';
      notifyListeners();
      return false;
    }
  }

  Future<void> deleteDraft(int draftId) async {
    try {
      await _repository.deleteDraft(draftId);
      await loadDrafts();
      message = 'Brouillon supprimé.';
      status = AdmissionFlowStatus.success;
      notifyListeners();
    } catch (error) {
      status = AdmissionFlowStatus.error;
      message = 'Impossible de supprimer le brouillon.';
      notifyListeners();
    }
  }

  Future<void> removeDocument(int documentId) async {
    try {
      await _repository.removeDocument(documentId);
      status = AdmissionFlowStatus.success;
      message = 'Pièce supprimée.';
      notifyListeners();
    } catch (error) {
      status = AdmissionFlowStatus.error;
      message = 'Impossible de supprimer la pièce.';
      notifyListeners();
    }
  }
}
