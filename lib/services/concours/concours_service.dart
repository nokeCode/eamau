import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/api/api_config.dart';
import '../../models/concours/concours_model.dart';

class ConcoursService {
  static const String _baseUrl = '${ApiConfig.fullBaseUrl}/concours';

  Future<List<ConcoursModel>> getConcours({int page = 1, int limit = 10, String? query}) async {
    final uri = Uri.parse(query == null || query.trim().isEmpty
        ? '$_baseUrl?page=$page&limit=$limit'
        : '$_baseUrl/search?q=${Uri.encodeComponent(query.trim())}&page=$page&limit=$limit');

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      final message = _extractMessage(response.body);
      throw Exception(message ?? 'Impossible de charger les concours');
    }

    final decoded = json.decode(response.body) as Map<String, dynamic>;
    final data = decoded['data'];

    if (data is List) {
      return data.map((e) => ConcoursModel.fromJson(Map<String, dynamic>.from(e))).toList();
    }

    return [];
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