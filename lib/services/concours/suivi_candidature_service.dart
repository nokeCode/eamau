import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/api/api_config.dart';
import '../../core/storage/token_storage.dart';
import '../../models/concours/my_postulation_model.dart';
import '../../models/concours/suivi_candidature_model.dart';

class SuiviCandidatureService {
  static final String endpoint = '${ApiConfig.fullBaseUrl}/postulations';
  final http.Client? client;
  final TokenStorage _tokenStorage = TokenStorage();

  SuiviCandidatureService({this.client});

  static const Map<String, String> headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  /// The authenticated user's own postulations, across every concours —
  /// `GET /postulations` (`PostulationService::listForCurrentUser`, route
  /// `api_postulation_list_mine`, requires ROLE_USER). Unlike [getSuivi],
  /// this needs the logged-in user's Bearer token, not a per-postulation
  /// `X-Postulation-Token`. Returns an empty list on any failure (offline,
  /// unauthenticated, server error) rather than throwing.
  Future<List<MyPostulationModel>> listMine() async {
    try {
      final token = await _tokenStorage.getAccessToken();
      final authHeaders = <String, String>{
        ...headers,
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      };

      final response = await (client ?? http.Client()).get(
        Uri.parse(endpoint),
        headers: authHeaders,
      );

      final body = _decodeBody(response.body);
      if (response.statusCode != 200 || body['success'] != true) {
        return [];
      }

      final data = body['data'];
      final list = data is List
          ? data
          : (data is Map && data['items'] is List ? data['items'] as List : const []);

      return list
          .whereType<Map>()
          .map((e) => MyPostulationModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (_) {
      return [];
    }
  }

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
