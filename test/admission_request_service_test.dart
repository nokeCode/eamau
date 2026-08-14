import 'dart:async';

import 'package:eamau/core/storage/token_storage.dart';
import 'package:eamau/models/admission/admission_request_model.dart';
import 'package:eamau/services/admission/admission_request_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

class _SlowClient extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    await Future<void>.delayed(const Duration(milliseconds: 50));
    throw TimeoutException('slow response');
  }
}

class _FakeTokenStorage extends TokenStorage {
  @override
  Future<String?> getAccessToken() async => null;

  @override
  Future<String?> getRefreshToken() async => null;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'createAdmissionRequest reports a timeout clearly when the server is slow',
    () async {
      final service = AdmissionRequestService(
        client: _SlowClient(),
        tokenStorage: _FakeTokenStorage(),
      );

      final model = AdmissionRequestModel(
        firstName: 'Jean',
        lastName: 'Dupont',
        email: 'jean.dupont@example.com',
        phone: '0612345678',
        birthDate: DateTime(1999, 1, 1),
        nationality: 'Maroc',
        profession: 'Étudiant',
        address: 'Rue de Test',
        universityOrigin: 'Université Test',
        currentLevel: 'L2',
        requestedLevel: 'L3',
        currentField: 'Informatique',
        requestedField: 'Développement',
        documents: const {},
      );

      final response = await service.createAdmissionRequest(42, model);

      expect(response, isNull);
      expect(service.lastErrorMessage, contains('trop de temps'));
    },
  );
}
