import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/api/api_config.dart';
import '../../core/storage/token_storage.dart';

class AdmissionConditionService {
  static const String baseUrl = '${ApiConfig.fullBaseUrl}/admission-conditions';
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

  Future<List<String>> getConditions({String? level}) async {
    try {
      final uri = Uri.parse(baseUrl).replace(
        queryParameters: level != null && level.isNotEmpty ? {'level': level} : null,
      );
      final response = await http.get(uri, headers: await _headers());

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return List<String>.from(data);
      }
    } catch (_) {}

    return fallbackConditions;
  }
}

const List<String> fallbackConditions = [
  "Avoir validé le semestre 4",
  "Niveau de français B2",
  "Dossier académique solide",
];