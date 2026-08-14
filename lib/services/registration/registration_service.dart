import 'package:dio/dio.dart';
import '../../core/api/dio_client.dart';
import '../../models/registration/registration_referential_model.dart';
import '../../models/registration/registration_status_model.dart';

class RegistrationService {
  final Dio _dio = DioClient().dio;

  Future<RegistrationReferentialCollection> getReferentials() async {
    final filieres = await _getOptions('/filieres');
    final grades = await _getOptions('/grades');
    final groups = await _getOptions('/groupes');
    final schoolYears = await _getOptions('/annees-scolaires');
    final documentTypes = await _getOptions('/inscriptions/pieces');
    // Provide a sensible local fallback if the backend returns no pieces so
    // the UI remains usable while diagnosing API issues.
    final documentTypesWithFallback = documentTypes.isNotEmpty
      ? documentTypes
      : [
        RegistrationOption(id: '1', value: 'Demande manuscrites', label: 'Demande manuscrites'),
        RegistrationOption(id: '2', value: 'Certificat Médical', label: 'Certificat Médical'),
        RegistrationOption(id: '3', value: 'Extrait de naissance', label: 'Extrait de naissance'),
        RegistrationOption(id: '4', value: 'Certificat de nationalité', label: 'Certificat de nationalité'),
        RegistrationOption(id: '5', value: 'Copie certifié conforme de diplôme', label: 'Copie certifié conforme de diplôme'),
        RegistrationOption(id: '6', value: "Preuve de versement frais d'inscription", label: "Preuve de versement frais d'inscription"),
        RegistrationOption(id: '7', value: 'Preuve de versement frais de scolarité', label: 'Preuve de versement frais de scolarité'),
        RegistrationOption(id: '8', value: "Preuve d'attestation de bourse ou liste collective de boursiers", label: "Preuve d'attestation de bourse ou liste collective de boursiers"),
        ];
    final statuses = await _getOptions('/inscriptions/status');
    final semesters = await _getOptions('/semestres');

    if (filieres.isEmpty && grades.isEmpty && groups.isEmpty &&
        schoolYears.isEmpty && documentTypes.isEmpty &&
        statuses.isEmpty && semesters.isEmpty) {
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

  Future<bool> submitRegistration(
    RegistrationDraft draft,
    List<RegistrationDocument> documents,
  ) async {
    final creationResult = await _createRegistration(draft);
    if (creationResult == null) {
      return false;
    }

    if (creationResult.alreadyExisting) {
      return true;
    }

    for (final document in documents) {
      final uploaded = await _uploadDocument(creationResult.registrationId, document);
      if (!uploaded) {
        return false;
      }
    }

    return await _finalizeRegistration(creationResult.registrationId);
  }

  Future<_RegistrationCreationResult?> _createRegistration(RegistrationDraft draft) async {
    try {
      final response = await _dio.post('/inscriptions', data: draft.toJson());
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
        return id != null ? _RegistrationCreationResult(registrationId: id) : null;
      }
    } on DioException catch (e) {
      final response = e.response;
      if (response?.statusCode == 400 &&
          _isAlreadyExistingRegistrationError(response?.data)) {
        final schoolYearId = int.tryParse(draft.schoolYear?.id ?? '5') ?? 5;
        final existingId = await _findExistingRegistrationId(schoolYearId);
        if (existingId != null) {
          return _RegistrationCreationResult(
            registrationId: existingId,
            alreadyExisting: true,
          );
        }
      }
    }
    return null;
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

  Future<bool> _uploadDocument(
    int registrationId,
    RegistrationDocument document,
  ) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          document.filePath,
          filename: document.fileName,
        ),
        'documentType': document.type,
      });

      final response = await _dio.post(
        '/inscriptions/$registrationId/documents',
        data: formData,
      );

      return response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300;
    } catch (_) {}
    return false;
  }

  Future<bool> _finalizeRegistration(int registrationId) async {
    try {
      final response = await _dio.post('/inscriptions/$registrationId/submit');
      return response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300;
    } catch (_) {}
    return false;
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
      final fullUrl = (_dio.options.baseUrl ?? '') + endpoint;
      print('RegistrationService: GET $fullUrl');
      final response = await _dio.get(endpoint);
      print('RegistrationService: RESPONSE ${response.statusCode} for $fullUrl');
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final parsed = _parseOptionList(response.data);
        print('RegistrationService: parsed ${parsed.length} items from $fullUrl');
        return parsed;
      }
    } catch (e) {
      try {
        print('RegistrationService: error for endpoint $endpoint -> $e');
        if (e is DioException) {
          final resp = e.response;
          if (resp != null) {
            print('RegistrationService: dio response data: ${resp.data}');
            print('RegistrationService: dio status code: ${resp.statusCode}');
          }
        }
      } catch (_) {}
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

class _RegistrationCreationResult {
  final int registrationId;
  final bool alreadyExisting;

  const _RegistrationCreationResult({
    required this.registrationId,
    this.alreadyExisting = false,
  });
}
