import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/api/api_config.dart';
import '../../models/concours/concours_detail_model.dart';

class ConcoursDetailService {
  static const String _baseUrl = '${ApiConfig.fullBaseUrl}/concours';

  Future<ConcoursDetailModel> getConcoursDetail(String slug) async {
    final response = await http.get(Uri.parse('$_baseUrl/$slug'));

    if (response.statusCode != 200) {
      final message = _extractMessage(response.body);
      throw Exception(message ?? 'Impossible de charger le concours');
    }

    final decoded = json.decode(response.body) as Map<String, dynamic>;
    final data = decoded['data'];

    if (data is Map<String, dynamic>) {
      return ConcoursDetailModel.fromJson(data);
    }

    throw Exception('Aucune donnée reçue pour ce concours');
  }

  String? _extractMessage(String body) {
    try {
      final decoded = json.decode(body) as Map<String, dynamic>;
      return decoded['message']?.toString();
    } catch (_) {
      return null;
    }
  }
}