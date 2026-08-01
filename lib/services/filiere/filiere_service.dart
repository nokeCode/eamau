import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/api/api_config.dart';
import '../../models/filiere/filiere_model.dart';

class FiliereService {
  final http.Client _client;

  FiliereService({http.Client? client}) : _client = client ?? http.Client();

  static const String _baseUrl = '${ApiConfig.fullBaseUrl}/filieres';

  Future<FilierePageResult> getFilieresPage({
    int page = 1,
    int perPage = 10,
    String? query,
  }) async {
    final uri = Uri.parse(query == null || query.trim().isEmpty
        ? '$_baseUrl?page=$page&perPage=$perPage'
        : '$_baseUrl/search?q=${Uri.encodeComponent(query.trim())}&page=$page&perPage=$perPage');

    final response = await _client.get(uri);

    if (response.statusCode != 200) {
      final message = _extractMessage(response.body);
      throw Exception(message ?? 'Impossible de charger les filières');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final data = decoded['data'];
    final metaJson = decoded['meta'] as Map<String, dynamic>? ?? {};

    final items = <Filiere>[];
    if (data is List) {
      items.addAll(data.map((e) => Filiere.fromJson(Map<String, dynamic>.from(e))).toList());
    } else if (data is Map<String, dynamic>) {
      items.add(Filiere.fromJson(data));
    }

    return FilierePageResult(
      items: items,
      meta: FiliereMeta.fromJson(metaJson),
    );
  }

  Future<Filiere> getFiliereBySlug(String slug) async {
    final response = await _client.get(Uri.parse('$_baseUrl/$slug'));

    if (response.statusCode != 200) {
      final message = _extractMessage(response.body);
      throw Exception(message ?? 'Impossible de charger cette filière');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final data = decoded['data'];
    if (data is Map<String, dynamic>) {
      return Filiere.fromJson(data);
    }
    if (data is List && data.isNotEmpty) {
      return Filiere.fromJson(Map<String, dynamic>.from(data.first));
    }
    throw Exception('Aucune donnée reçue pour cette filière');
  }

  String? _extractMessage(String body) {
    try {
      final decoded = jsonDecode(body) as Map<String, dynamic>;
      return decoded['message']?.toString();
    } catch (_) {
      return null;
    }
  }
}
