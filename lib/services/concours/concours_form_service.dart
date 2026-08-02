import 'dart:io';

import 'package:dio/dio.dart';

import '../../core/api/dio_client.dart';
import '../../models/concours/dynamic_form_model.dart';

class ConcoursFormService {
  final DioClient _dioClient = DioClient();

  Options _postulationOptions({String? token, bool skipAuth = false}) {
    final headers = <String, dynamic>{};
    if (token != null && token.isNotEmpty) {
      headers['X-Postulation-Token'] = token;
    }
    return Options(
      extra: {'skipAuth': skipAuth},
      headers: headers.isEmpty ? null : headers,
    );
  }

  Future<ConcoursFormModel> loadForm(String concoursSlugOrId) async {
    final response = await _dioClient.dio.get('/concours/$concoursSlugOrId');
    final data = response.data['data'] as Map<String, dynamic>? ?? {};
    return ConcoursFormModel.fromJson(data);
  }

  Future<PostulationDraftModel> createPostulation({
    required String concoursSlugOrId,
    required String email,
    required String candidateTypeId,
  }) async {
    final response = await _dioClient.dio.post(
      '/concours/$concoursSlugOrId/postulation',
      data: {'email': email, 'candidatTypeId': candidateTypeId},
      options: _postulationOptions(skipAuth: true),
    );

    final data = response.data['data'] as Map<String, dynamic>? ?? {};
    final postulationData =
        data['postulation'] as Map<String, dynamic>? ?? data;
    return PostulationDraftModel.fromJson(postulationData);
  }

  Future<void> saveValues(
    String postulationId,
    Map<String, dynamic> values, {
    String? postulationToken,
  }) async {
    await _dioClient.dio.patch(
      '/postulations/$postulationId/data',
      data: {'values': values},
      options: _postulationOptions(token: postulationToken),
    );
  }

  Future<PostulationDocumentModel> uploadDocument({
    required String postulationId,
    required String attributeSlug,
    required File file,
    String? postulationToken,
  }) async {
    final formData = FormData.fromMap({
      'documentType': attributeSlug,
      'file': await MultipartFile.fromFile(file.path),
    });

    final options = _postulationOptions(token: postulationToken);
    options.contentType = Headers.multipartFormDataContentType;

    final response = await _dioClient.dio.post(
      '/postulations/$postulationId/documents',
      data: formData,
      options: options,
    );

    final data = response.data['data'] as Map<String, dynamic>? ?? {};
    final documentData = data['document'] as Map<String, dynamic>? ?? {};
    return PostulationDocumentModel.fromJson(documentData);
  }

  Future<void> deleteDocument({
    required String postulationId,
    required String documentId,
    String? postulationToken,
  }) async {
    await _dioClient.dio.delete(
      '/postulations/$postulationId/documents/$documentId',
      options: _postulationOptions(token: postulationToken),
    );
  }

  Future<Map<String, dynamic>> submit(
    String postulationId, {
    String? postulationToken,
  }) async {
    final response = await _dioClient.dio.post(
      '/postulations/$postulationId/submit',
      options: _postulationOptions(token: postulationToken),
    );

    // Try to return the full response body as a Map so the caller can show messages
    return (response.data as Map<String, dynamic>?) ?? <String, dynamic>{};
  }

  Future<PostulationVerificationResult> verifyPostulationCode({
    required String postulationId,
    required String code,
  }) async {
    final response = await _dioClient.dio.post(
      '/postulations/$postulationId/verify-code',
      data: {'code': code},
      options: _postulationOptions(skipAuth: true),
    );

    final data = response.data['data'] as Map<String, dynamic>? ?? {};
    final postulationData = data['postulation'] as Map<String, dynamic>? ?? {};
    return PostulationVerificationResult.fromJson({
      'postulation': postulationData,
      'postulationToken': data['postulationToken'],
      'expiresAt': data['expiresAt'],
    });
  }

  Future<void> resendVerificationCode({required String postulationId}) async {
    await _dioClient.dio.post(
      '/postulations/$postulationId/resend-code',
      options: _postulationOptions(skipAuth: true),
    );
  }

  Future<PostulationDraftModel> getDraft({
    required String postulationId,
    required String postulationToken,
  }) async {
    final response = await _dioClient.dio.get(
      '/postulations/$postulationId/draft',
      options: _postulationOptions(token: postulationToken),
    );

    final data = response.data['data'] as Map<String, dynamic>? ?? {};
    return PostulationDraftModel.fromJson(
      data['postulation'] as Map<String, dynamic>? ?? {},
    );
  }
}
