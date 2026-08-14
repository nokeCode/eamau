import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/api/api_config.dart';
import '../../models/concours/suivi_candidature_model.dart';

class SuiviCandidatureService {
  static final String endpoint = '${ApiConfig.fullBaseUrl}/postulations';
  final http.Client? client;

  SuiviCandidatureService({this.client});

  static const Map<String, String> headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  Future<SuiviCandidatureModel> getSuivi(String reference) async {
    final response = await (client ?? http.Client()).get(
      Uri.parse('$endpoint/$reference/tracking'),
      headers: headers,
    );

    final body = _decodeBody(response.body);
    if (response.statusCode != 200 || body['success'] != true) {
      throw Exception(
        body['message']?.toString() ??
            'Impossible de charger le suivi de la candidature.',
      );
    }

    final data = body['data'];
    if (data is! Map) {
      throw Exception('Les données de suivi reçues sont invalides.');
    }

    return SuiviCandidatureModel.fromJson(Map<String, dynamic>.from(data));
  }

  Map<String, dynamic> _decodeBody(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } on FormatException {}
    return <String, dynamic>{};
  }
}
