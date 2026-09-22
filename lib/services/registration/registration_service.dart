import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../core/api/dio_client.dart';
import '../../models/registration/registration_referential_model.dart';
import '../../models/registration/registration_status_model.dart';
import '../../models/registration/registration_summary_model.dart';

class RegistrationCreationResult {
  final int registrationId;
  final bool alreadyExisting;

  const RegistrationCreationResult({
    required this.registrationId,
    this.alreadyExisting = false,
  });
}

class RegistrationService {
  final Dio _dio;
  int? _lastStatusCode;
  String? _lastErrorMessage;
  bool _lastDocumentUploadRejectedFinal = false;

  RegistrationService({Dio? dio}) : _dio = dio ?? DioClient().dio;

  int? get lastStatusCode => _lastStatusCode;
  String? get lastErrorMessage => _lastErrorMessage;

  /// True after [uploadDocumentFile] fails specifically because the
  /// registration this document was for has already been finalized
  /// ("Cette demande ne peut plus recevoir de document.") — a permanent
  /// rejection, not a transient network/server error, so it shouldn't be
  /// retried and deserves a distinct message pointing the user at their
  /// existing request instead of a generic "queued, will retry".
  bool get lastDocumentUploadRejectedFinal => _lastDocumentUploadRejectedFinal;

  Future<RegistrationReferentialCollection> getReferentials() async {
    final filieres = await _getOptions('/filieres');
    final grades = await _getOptions('/grades');
    final groups = await _getOptions('/groupes');
    final schoolYears = await _getOptions('/annees-scolaires');
    final documentTypes = await _getOptions('/inscriptions/pieces');

    final documentTypesWithFallback = documentTypes.isNotEmpty
        ? documentTypes
        : [
            const RegistrationOption(id: '1', value: 'Demande manuscrites', label: 'Demande manuscrites'),
            const RegistrationOption(id: '2', value: 'Certificat Médical', label: 'Certificat Médical'),
            const RegistrationOption(id: '3', value: 'Extrait de naissance', label: 'Extrait de naissance'),
            const RegistrationOption(id: '4', value: 'Certificat de nationalité', label: 'Certificat de nationalité'),
            const RegistrationOption(id: '5', value: 'Copie certifié conforme de diplôme', label: 'Copie certifié conforme de diplôme'),
            const RegistrationOption(id: '6', value: "Preuve de versement frais d'inscription", label: "Preuve de versement frais d'inscription"),
            const RegistrationOption(id: '7', value: 'Preuve de versement frais de scolarité', label: 'Preuve de versement frais de scolarité'),
            const RegistrationOption(id: '8', value: "Preuve d'attestation de bourse ou liste collective de boursiers", label: "Preuve d'attestation de bourse ou liste collective de boursiers"),
          ];
    var statuses = await _getOptions('/statuts');
    if (statuses.isEmpty) {
      statuses = await _getOptions('/inscriptions/status');
    }
    final semesters = await _getOptions('/semestres');

    if (filieres.isEmpty &&
        grades.isEmpty &&
        groups.isEmpty &&
        schoolYears.isEmpty &&
        documentTypes.isEmpty &&
        statuses.isEmpty &&
        semesters.isEmpty) {
      return const RegistrationReferentialCollection();
    }

    return RegistrationReferentialCollection(
      filieres: filieres,
      grades: grades,
      groups: groups,
      schoolYears: schoolYears,
      documentTypes: documentTypesWithFallback,
      statuses: statuses,
      semesters: semesters,
    );
  }

  /// Create registration remotely (Step 1)
  Future<RegistrationCreationResult?> createRegistration(
    RegistrationDraft draft, {
    String? idempotencyKey,
  }) async {
    _lastStatusCode = null;
    _lastErrorMessage = null;
    try {
      final options = Options(
        headers: idempotencyKey != null ? {'Idempotency-Key': idempotencyKey} : null,
      );

      final response = await _dio.post(
        '/inscriptions',
        data: draft.toApiJson(),
        options: options,
      );

      _lastStatusCode = response.statusCode;
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final payload = <String, dynamic>{};
        if (response.data is Map) {
          final rawMap = response.data as Map;
          rawMap.forEach((key, value) {
            payload[key.toString()] = value;
          });
        }
        final id = _parseId(payload);
        return id != null ? RegistrationCreationResult(registrationId: id) : null;
      }
    } on DioException catch (e) {
      _lastStatusCode = e.response?.statusCode;
      _lastErrorMessage = e.message;
      final response = e.response;
      if (response?.statusCode == 400 &&
          _isAlreadyExistingRegistrationError(response?.data)) {
        final schoolYearId = int.tryParse(draft.schoolYear?.id ?? '5') ?? 5;
        final existingId = await _findExistingRegistrationId(schoolYearId);
        if (existingId != null) {
          return RegistrationCreationResult(
            registrationId: existingId,
            alreadyExisting: true,
          );
        }
      }
    } catch (e) {
      _lastErrorMessage = e.toString();
    }
    return null;
  }

  /// Upload a single document to an already-created registration (Step 2)
  Future<bool> uploadDocumentFile(
    int registrationId,
    String documentType,
    File file, {
    String? fileName,
    String? idempotencyKey,
  }) async {
    _lastStatusCode = null;
    _lastErrorMessage = null;
    _lastDocumentUploadRejectedFinal = false;
    try {
      final name = fileName ?? file.path.split('/').last;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: name,
        ),
        'documentType': documentType,
      });

      final options = Options(
        headers: idempotencyKey != null ? {'Idempotency-Key': idempotencyKey} : null,
      );

      final response = await _dio.post(
        '/inscriptions/$registrationId/documents',
        data: formData,
        options: options,
      );

      _lastStatusCode = response.statusCode;
      return response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300;
    } on DioException catch (e) {
      _lastStatusCode = e.response?.statusCode;
      // Dio's own `e.message` is a generic string like "Http status error
      // [400]" — read the actual server payload instead so the real reason
      // (e.g. "Cette demande ne peut plus recevoir de document.") survives.
      final serverMessage = _extractServerMessage(e.response?.data);
      _lastErrorMessage = serverMessage ?? e.message;
      _lastDocumentUploadRejectedFinal =
          serverMessage == 'Cette demande ne peut plus recevoir de document.';
    } catch (e) {
      _lastErrorMessage = e.toString();
    }
    return false;
  }

  String? _extractServerMessage(dynamic data) {
    if (data is String) return data;
    if (data is Map) return data['message']?.toString();
    return null;
  }

  /// Finalize and submit the registration on remote (Step 3)
  Future<bool> finalizeRegistration(
    int registrationId, {
    String? idempotencyKey,
  }) async {
    _lastStatusCode = null;
    _lastErrorMessage = null;
    try {
      final options = Options(
        headers: idempotencyKey != null ? {'Idempotency-Key': idempotencyKey} : null,
      );

      final response = await _dio.post(
        '/inscriptions/$registrationId/submit',
        options: options,
      );

      _lastStatusCode = response.statusCode;
      return response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300;
    } on DioException catch (e) {
      _lastStatusCode = e.response?.statusCode;
      _lastErrorMessage = e.message;
    } catch (e) {
      _lastErrorMessage = e.toString();
    }
    return false;
  }

  /// Composite helper for direct online execution
  Future<bool> submitRegistration(
    RegistrationDraft draft,
    List<RegistrationDocument> documents,
  ) async {
    final creationResult = await createRegistration(draft);
    if (creationResult == null) {
      return false;
    }

    if (!creationResult.alreadyExisting) {
      for (final document in documents) {
        final file = File(document.filePath);
        if (!await file.exists()) continue;
        final uploaded = await uploadDocumentFile(
          creationResult.registrationId,
          document.type,
          file,
          fileName: document.fileName,
        );
        if (!uploaded) {
          return false;
        }
      }
    }

    return await finalizeRegistration(creationResult.registrationId);
  }

  /// The authenticated user's own registrations ("inscriptions"), across
  /// every school year — `GET /inscriptions`. Returns an empty list on any
  /// failure (offline, unauthenticated, server error) rather than throwing.
  Future<List<RegistrationSummaryModel>> listMyRegistrations() async {
    try {
      final response = await _dio.get('/inscriptions');
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return _extractList(response.data)
            .whereType<Map>()
            .map((e) => RegistrationSummaryModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
    } catch (_) {}
    return [];
  }

  Future<int?> _findExistingRegistrationId(int schoolYearId) async {
    try {
      final response = await _dio.get('/inscriptions');
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final items = _extractList(response.data);
        for (final item in items) {
          if (item is Map) {
            final yearIdValue = item['anneeScolaireId'] ?? item['annee_scolaire_id'];
            final yearId = yearIdValue is int
                ? yearIdValue
                : int.tryParse(yearIdValue?.toString() ?? '');
            if (yearId == schoolYearId) {
              return _parseId(Map<String, dynamic>.from(item));
            }
          }
        }
      }
    } catch (_) {}
    return null;
  }

  bool _isAlreadyExistingRegistrationError(dynamic data) {
    final message = data is String
        ? data
        : data is Map
            ? data['message']?.toString() ?? data['error']?.toString() ?? ''
            : '';
    return message
        .contains("Une demande d'inscription existe déjà pour cette année scolaire.");
  }

  List<dynamic> _extractList(dynamic responseData) {
    if (responseData is List) {
      return responseData;
    }

    if (responseData is Map) {
      final list = responseData['data'] ?? responseData['items'] ?? responseData['results'];
      if (list is List) {
        return list;
      }
    }

    return const [];
  }

  int? _parseId(Map<String, dynamic> payload) {
    if (payload['data'] is Map) {
      final data = Map<String, dynamic>.from(payload['data'] as Map);
      return _parseId(data);
    }

    final idValue = payload['id'] ?? payload['inscriptionId'] ?? payload['registrationId'];
    if (idValue is int) {
      return idValue;
    }
    if (idValue is String) {
      return int.tryParse(idValue);
    }
    return null;
  }

  Future<List<RegistrationOption>> _getOptions(String endpoint) async {
    try {
      final response = await _dio.get(endpoint);
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return _parseOptionList(response.data);
      }
    } catch (e) {
      debugPrint('RegistrationService: error for endpoint $endpoint -> $e');
    }
    return const [];
  }

  List<RegistrationOption> _parseOptionList(dynamic responseData) {
    if (responseData is List) {
      return responseData.map((item) => RegistrationOption.fromJson(item)).toList();
    }

    if (responseData is Map) {
      final payload = Map<String, dynamic>.from(responseData);
      final list = payload['data'] ?? payload['items'] ?? payload['results'];
      if (list is List) {
        return list.map((item) => RegistrationOption.fromJson(item)).toList();
      }
    }

    return const [];
  }

  Future<RegistrationStatus> getRegistrationStatus() async {
    try {
      final response = await _dio.get('/inscriptions/status');
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return RegistrationStatus.fromJson(
          response.data['data'] ?? response.data,
        );
      }
    } catch (_) {}
    return const RegistrationStatus(
      open: false,
      canCreate: false,
      activeSchoolYear: null,
      message: 'Impossible de vérifier l’état des inscriptions.',
    );
  }
}
