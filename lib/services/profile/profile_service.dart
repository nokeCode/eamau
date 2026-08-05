import 'dart:io';

import 'package:dio/dio.dart';

import '../../core/api/api_endpoints.dart';
import '../../core/api/dio_client.dart';
import '../../models/profile/profile_academic_model.dart';
import '../../models/profile/user_model.dart';

class ProfileService {
  final Dio _dio;

  ProfileService({Dio? dio}) : _dio = dio ?? DioClient().dio;

  Map<String, dynamic>? _unwrapResponseData(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data['data'] is Map<String, dynamic>) {
        return _unwrapResponseData(data['data']);
      }
      if (data['user'] is Map<String, dynamic>) {
        return _unwrapResponseData(data['user']);
      }
      if (data['profile'] is Map<String, dynamic>) {
        return _unwrapResponseData(data['profile']);
      }
      return data;
    }
    return null;
  }

  UserModel _parseUserModel(dynamic data) {
    final userData = _unwrapResponseData(data);
    if (userData == null) {
      return UserModel.empty();
    }
    return UserModel.fromJson(Map<String, dynamic>.from(userData));
  }

  Future<UserModel> getProfile() async {
    try {
      final response = await _dio.get(ApiEndpoints.profile);
      return _parseUserModel(response.data);
    } on DioException catch (_) {
      return UserModel.empty();
    }
  }

  Future<UserModel> updateProfile({
    String? firstname,
    String? lastname,
    String? email,
    String? username,
    String? matricule,
    String? phone,
  }) async {
    final payload = <String, dynamic>{};

    if (firstname != null) payload['firstname'] = firstname;
    if (lastname != null) payload['lastname'] = lastname;
    if (email != null) payload['email'] = email;
    if (username != null) payload['username'] = username;
    if (matricule != null) payload['matricule'] = matricule;
    if (phone != null) payload['phone'] = phone;

    final response = await _dio.put(
      ApiEndpoints.profile,
      data: payload,
    );
    return _parseUserModel(response.data);
  }

  Future<UserModel> updateProfileWithPayload({
    required Map<String, dynamic> payload,
    File? identityFrontFile,
    File? identityBackFile,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.profile,
        data: await _buildIdentityFormData(
          payload: payload,
          identityFrontFile: identityFrontFile,
          identityBackFile: identityBackFile,
        ),
        options: _identityUploadOptions(identityFrontFile, identityBackFile),
      );
      return _parseUserModel(response.data);
    } on DioException catch (error) {
      if (error.response?.statusCode != 404 && error.response?.statusCode != 405) {
        rethrow;
      }
      final response = await _dio.put(
        ApiEndpoints.profile,
        data: await _buildIdentityFormData(
          payload: payload,
          identityFrontFile: identityFrontFile,
          identityBackFile: identityBackFile,
        ),
        options: _identityUploadOptions(identityFrontFile, identityBackFile),
      );
      return _parseUserModel(response.data);
    }
  }

  Future<UserModel> saveValidationProfile({
    required Map<String, dynamic> payload,
    File? identityFrontFile,
    File? identityBackFile,
  }) async {
    await requestVerification(
      payload: Map<String, dynamic>.from(payload),
      identityFrontFile: identityFrontFile,
      identityBackFile: identityBackFile,
    );
    return getProfile();
  }

  Future<UserModel> uploadPhoto({
    required List<int> bytes,
    required String filename,
  }) async {
    final formData = FormData.fromMap({
      'photo': MultipartFile.fromBytes(
        bytes,
        filename: filename,
      ),
    });

    final response = await _dio.post(
      ApiEndpoints.profilePhoto,
      data: formData,
      options: Options(
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      ),
    );

    final userData = response.data['data'] as Map<String, dynamic>?;
    return userData == null
        ? UserModel.empty()
        : UserModel.fromJson(userData);
  }

  Future<UserModel> deletePhoto() async {
    final response = await _dio.delete(ApiEndpoints.profilePhoto);
    final userData = response.data['data'] as Map<String, dynamic>?;
    return userData == null
        ? UserModel.empty()
        : UserModel.fromJson(userData);
  }

  Future<UserModel> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final response = await _dio.put(
      ApiEndpoints.profilePassword,
      data: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      },
    );
    final userData = response.data['data'] as Map<String, dynamic>?;
    return userData == null
        ? UserModel.empty()
        : UserModel.fromJson(userData);
  }

  Future<void> requestVerification({
    required Map<String, dynamic> payload,
    File? identityFrontFile,
    File? identityBackFile,
  }) async {
    final requestPayload = Map<String, dynamic>.from(payload);

    // The form controllers only contain the displayed file names.  Replace
    // them with the actual selected documents before sending the request.
    if (identityFrontFile != null && identityBackFile != null) {
      await _dio.post(
        ApiEndpoints.requestVerification,
        data: await _buildIdentityFormData(
          payload: requestPayload,
          identityFrontFile: identityFrontFile,
          identityBackFile: identityBackFile,
        ),
        options: _identityUploadOptions(identityFrontFile, identityBackFile),
      );
      return;
    }

    await _dio.post(
      ApiEndpoints.requestVerification,
      data: requestPayload,
    );
  }

  Options? _identityUploadOptions(File? identityFrontFile, File? identityBackFile) {
    if (identityFrontFile == null || identityBackFile == null) {
      return null;
    }
    return Options(contentType: Headers.multipartFormDataContentType);
  }

  Future<dynamic> _buildIdentityFormData({
    required Map<String, dynamic> payload,
    required File? identityFrontFile,
    required File? identityBackFile,
  }) async {
    if (identityFrontFile == null || identityBackFile == null) {
      return payload;
    }

    final formPayload = Map<String, dynamic>.from(payload)
      ..remove('identity_front')
      ..remove('identity_back');

    return FormData.fromMap({
      ...formPayload,
      'identity_front': await MultipartFile.fromFile(
        identityFrontFile.path,
        filename: identityFrontFile.uri.pathSegments.last,
      ),
      'identity_back': await MultipartFile.fromFile(
        identityBackFile.path,
        filename: identityBackFile.uri.pathSegments.last,
      ),
    });
  }

  Future<ProfileAcademicModel> getAcademicInfo() async {
    final response = await _dio.get(ApiEndpoints.profileAcademic);
    final academicData = response.data['data'] as Map<String, dynamic>?;
    return academicData == null
        ? ProfileAcademicModel.empty()
        : ProfileAcademicModel.fromJson(academicData);
  }
}
