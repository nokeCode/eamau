import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../core/api/api_config.dart';
import '../../core/storage/token_storage.dart';
import '../../models/admission/admission_tracking_model.dart';

class AdmissionTrackingService {
  static const String baseUrl = ApiConfig.fullBaseUrl;
  final TokenStorage _tokenStorage = TokenStorage();

  Future<Map<String, String>> _headers() async {
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    final token = await _tokenStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<AdmissionTrackingModel> getTracking(int requestId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/admission/requests/$requestId/tracking'),
        headers: await _headers(),
      );
      if (response.statusCode == 200) {
        return AdmissionTrackingModel.fromJson(
          Map<String, dynamic>.from(jsonDecode(response.body)),
        );
      }
    } catch (_) {}

    return AdmissionTrackingModel.fromJson(fallbackTrackingData);
  }

  Future<bool> refreshTracking(int requestId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/admission/requests/$requestId/tracking'),
        headers: await _headers(),
      );
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<bool> cancelAdmission() async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/admission/request'),
        headers: await _headers(),
      );
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}

const Map<String, dynamic> fallbackTrackingData = {
  'requestId': 45,
  'status': 'BROUILLON',
  'information': {
    'firstName': 'Jane',
    'lastName': 'Doe',
    'email': 'jane@example.com',
    'phone': '+33700000000',
    'profession': 'Étudiante',
    'address': '1 rue de la Paix',
    'universityOrigin': 'Université de Paris',
    'currentLevel': 'L2',
    'requestedLevel': 'L3',
    'currentField': 'Informatique',
    'requestedField': 'Génie logiciel'
  },
  'documents': [
    {
      'uuid': 'a1b2c3d4',
      'originalFilename': 'cv.pdf',
      'attachmentType': 'Curriculum vitae',
      'validated': false
    }
  ],
  'missingDocuments': ['Pièce d’identité', 'Relevé de notes'],
  'isComplete': false,
  'timeline': [
    {
      'step': 'created',
      'label': 'Demande créée',
      'status': 'BROUILLON',
      'date': '2026-08-02T10:00:00+00:00'
    },
    {
      'step': 'documents_received',
      'label': 'Documents reçus',
      'status': 'BROUILLON',
      'date': '2026-08-02T10:10:00+00:00'
    }
  ]
};