import 'package:dio/dio.dart';
import '../../core/api/dio_client.dart';
import '../../models/registration/registration_referential_model.dart';

class RegistrationService {
  final Dio _dio = DioClient().dio;

  Future<RegistrationReferentialCollection> getReferentials() async {
    final endpoints = <String>[
      '/registration/referentials',
      '/registrations/referentials',
      '/academic-registrations/referentials',
      '/academic/registration/referentials',
    ];

    for (final endpoint in endpoints) {
      try {
        final response = await _dio.get(endpoint);
        if (response.statusCode != null &&
            response.statusCode! >= 200 &&
            response.statusCode! < 300) {
          return RegistrationReferentialCollection.fromJson(response.data);
        }
      } catch (_) {}
    }

    return const RegistrationReferentialCollection();
  }

  Future<Map<String, dynamic>> submitRegistration(
    RegistrationDraft draft,
    List<RegistrationDocument> documents,
  ) async {
    final endpoints = <String>[
      '/registration/submissions',
      '/registrations',
      '/academic-registrations',
    ];

    for (final endpoint in endpoints) {
      try {
        final formData = {
          ...draft.toJson(),
          'documents': documents.map((item) => item.toJson()).toList(),
        };
        final response = await _dio.post(endpoint, data: formData);
        if (response.statusCode != null &&
            response.statusCode! >= 200 &&
            response.statusCode! < 300) {
          return response.data is Map
              ? Map<String, dynamic>.from(response.data as Map)
              : {};
        }
      } catch (_) {}
    }

    return {};
  }

  Future<Map<String, dynamic>> uploadDocument(
    RegistrationDocument document,
  ) async {
    final endpoints = <String>[
      '/registration/documents',
      '/registrations/documents',
      '/academic-registrations/documents',
    ];

    for (final endpoint in endpoints) {
      try {
        final formData = FormData.fromMap({
          'file': await MultipartFile.fromFile(
            document.filePath,
            filename: document.fileName,
          ),
          'documentType': document.type,
        });
        final response = await _dio.post(endpoint, data: formData);
        if (response.statusCode != null &&
            response.statusCode! >= 200 &&
            response.statusCode! < 300) {
          return response.data is Map
              ? Map<String, dynamic>.from(response.data as Map)
              : {};
        }
      } catch (_) {}
    }

    return {};
  }
}
