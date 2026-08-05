import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:eamau/core/api/api_endpoints.dart';
import 'package:eamau/services/profile/profile_service.dart';
import 'package:flutter_test/flutter_test.dart';

class _MockHttpClientAdapter implements HttpClientAdapter {
  final List<String> requestedPaths = [];
  final List<String> requestedMethods = [];
  final List<dynamic> requestedData = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requestedPaths.add(options.path);
    requestedMethods.add(options.method);
    requestedData.add(options.data);

    if (options.method == 'POST' && options.path == ApiEndpoints.requestVerification) {
      return ResponseBody.fromString(
        jsonEncode({'data': {}}),
        200,
        headers: {'content-type': ['application/json']},
      );
    }

    if ((options.method == 'POST' || options.method == 'PUT') && options.path == ApiEndpoints.profile) {
      return ResponseBody.fromString(
        jsonEncode({
          'data': {
            'id': 1,
            'firstname': 'Ada',
            'lastname': 'Lovelace',
            'email': 'ada@example.com',
            'username': 'ada',
            'matricule': '12345',
            'phone': '+22890000000',
          },
        }),
        200,
        headers: {'content-type': ['application/json']},
      );
    }

    if (options.method == 'GET' && options.path == ApiEndpoints.profile) {
      return ResponseBody.fromString(
        jsonEncode({
          'data': {
            'id': 1,
            'firstname': 'Ada',
            'lastname': 'Lovelace',
            'email': 'ada@example.com',
            'username': 'ada',
            'matricule': '12345',
            'phone': '+22890000000',
          },
        }),
        200,
        headers: {'content-type': ['application/json']},
      );
    }

    return ResponseBody.fromString(jsonEncode({}), 404, headers: {'content-type': ['application/json']});
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  test('saveValidationProfile requests verification and refreshes profile', () async {
    final adapter = _MockHttpClientAdapter();
    final dio = Dio();
    dio.httpClientAdapter = adapter;

    final profileService = ProfileService(dio: dio);
    final payload = {
      'first_name': 'Ada',
      'last_name': 'Lovelace',
      'email': 'ada@example.com',
      'username': 'ada',
      'matricule': '12345',
      'phone': '+22890000000',
      'country': 'Togo',
      'nationalite': 'Togo',
      'contry_id': 768,
    };

    final result = await profileService.saveValidationProfile(payload: payload);

    expect(result.firstName, 'Ada');
    expect(adapter.requestedPaths, contains(ApiEndpoints.requestVerification));
    expect(adapter.requestedMethods, contains('POST'));
    final requestPayloadBodies = adapter.requestedData.whereType<Map<String, dynamic>>();
    expect(
      requestPayloadBodies.any(
        (entry) =>
            entry['first_name'] == payload['first_name'] &&
            entry['last_name'] == payload['last_name'] &&
            entry['email'] == payload['email'] &&
            entry['username'] == payload['username'] &&
            entry['matricule'] == payload['matricule'] &&
            entry['phone'] == payload['phone'] &&
            entry['country'] == payload['country'] &&
            entry['nationalite'] == payload['nationalite'] &&
            entry['contry_id'] == payload['contry_id'],
      ),
      isTrue,
    );
  });

  test('updateProfile uses exact backend keys', () async {
    final adapter = _MockHttpClientAdapter();
    final dio = Dio();
    dio.httpClientAdapter = adapter;

    final profileService = ProfileService(dio: dio);

    final result = await profileService.updateProfile(
      firstname: 'Jean',
      lastname: 'Dupont',
      email: 'jean.dupont@example.com',
      username: 'jean123',
      matricule: '20240001',
      phone: '+22890123456',
    );

    expect(result.firstName, 'Ada');
    expect(adapter.requestedPaths, contains(ApiEndpoints.profile));
    expect(adapter.requestedMethods, contains('PUT'));
    expect(adapter.requestedData, isNotEmpty);
    expect(adapter.requestedData.first, {
      'firstname': 'Jean',
      'lastname': 'Dupont',
      'email': 'jean.dupont@example.com',
      'username': 'jean123',
      'matricule': '20240001',
      'phone': '+22890123456',
    });
  });
}
