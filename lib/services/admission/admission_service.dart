import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/api/api_config.dart';
import '../../core/storage/token_storage.dart';
import '../../models/admission/admission_campaign_detail_model.dart';
import '../../models/admission/admission_model.dart';

class AdmissionService {
  static const String baseUrl = ApiConfig.fullBaseUrl;
  final TokenStorage _tokenStorage = TokenStorage();

  Future<Map<String, String>> _headers({bool includeJson = true}) async {
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    if (includeJson) {
      headers['Content-Type'] = 'application/json';
    }
    final token = await _tokenStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<List<AdmissionModel>> getAdmissions() async {
    try {
      final uri = Uri.parse('$baseUrl/admission-campaigns');
      final response = await http.get(uri, headers: await _headers());
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List<dynamic>? listData;

        if (decoded is List) {
          listData = decoded;
        } else if (decoded is Map && decoded['data'] is List<dynamic>) {
          listData = decoded['data'] as List<dynamic>;
        } else {
          listData = null;
        }

        if (listData != null) {
          return listData
              .map((e) => AdmissionModel.fromJson(
                    Map<String, dynamic>.from(e as Map),
                  ))
              .toList();
        }
      }
    } catch (_) {}
    return [];
  }

  Future<AdmissionCampaignDetailModel?> getCampaignDetail(int id) async {
    try {
      final uri = Uri.parse('$baseUrl/admission-campaigns/$id');
      final response = await http.get(uri, headers: await _headers());
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final detail = decoded is Map && decoded['data'] is Map
            ? decoded['data'] as Map<String, dynamic>
            : decoded as Map<String, dynamic>;

        return AdmissionCampaignDetailModel.fromJson(
          Map<String, dynamic>.from(detail),
        );
      }
    } catch (_) {}
    return null;
  }
}

