import 'dart:io';

import '../../models/registration/registration_referential_model.dart';
import '../../models/registration/registration_status_model.dart';
import '../../services/registration/registration_service.dart';

class RegistrationRemoteDatasource {
  final RegistrationService _service;

  RegistrationRemoteDatasource({RegistrationService? service})
      : _service = service ?? RegistrationService();

  int? get lastStatusCode => _service.lastStatusCode;
  String? get lastErrorMessage => _service.lastErrorMessage;

  Future<RegistrationReferentialCollection> getReferentials() {
    return _service.getReferentials();
  }

  Future<RegistrationStatus> getRegistrationStatus() {
    return _service.getRegistrationStatus();
  }

  Future<RegistrationCreationResult?> createRegistration(
    RegistrationDraft draft, {
    String? idempotencyKey,
  }) {
    return _service.createRegistration(draft, idempotencyKey: idempotencyKey);
  }

  Future<bool> uploadDocument(
    int registrationId,
    String documentType,
    File file, {
    String? fileName,
    String? idempotencyKey,
  }) {
    return _service.uploadDocumentFile(
      registrationId,
      documentType,
      file,
      fileName: fileName,
      idempotencyKey: idempotencyKey,
    );
  }

  Future<bool> finalizeRegistration(
    int registrationId, {
    String? idempotencyKey,
  }) {
    return _service.finalizeRegistration(
      registrationId,
      idempotencyKey: idempotencyKey,
    );
  }
}
