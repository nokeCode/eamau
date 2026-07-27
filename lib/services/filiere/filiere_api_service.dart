import '../api_client.dart';

class FiliereService {
  final ApiClient _apiClient = ApiClient();

  // Récupérer la liste des filières
  Future<Map<String, dynamic>> getFilieres({
    int page = 1,
    int perPage = 10,
    String? parcours,
    String? niveau,
    String? cycle,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'perPage': perPage.toString(),
        if (parcours != null) 'parcours': parcours,
        if (niveau != null) 'niveau': niveau,
        if (cycle != null) 'cycle': cycle,
      };

      final response = await _apiClient.get(
        '/filieres',
        queryParams: queryParams,
      );

      if (response['success'] == true) {
        return response['data'] ?? {};
      } else {
        throw ApiException(response['message'] ?? 'Erreur lors de la récupération des filières');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Rechercher des filières
  Future<Map<String, dynamic>> searchFilieres({
    required String query,
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final queryParams = {
        'q': query,
        'page': page.toString(),
        'perPage': perPage.toString(),
      };

      final response = await _apiClient.get(
        '/filieres/search',
        queryParams: queryParams,
      );

      if (response['success'] == true) {
        return response['data'] ?? {};
      } else {
        throw ApiException(response['message'] ?? 'Erreur lors de la recherche des filières');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Récupérer le détail d'une filière
  Future<Map<String, dynamic>> getFiliereDetail(String slug) async {
    try {
      final response = await _apiClient.get('/filieres/$slug');

      if (response['success'] == true) {
        return response['data'] ?? {};
      } else {
        throw ApiException(response['message'] ?? 'Filière non trouvée');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Récupérer les parcours d'une filière
  Future<List<dynamic>> getFilieureParcours(String slug) async {
    try {
      final response = await _apiClient.get('/filieres/$slug/parcours');

      if (response['success'] == true) {
        final data = response['data'];
        if (data is List) {
          return data;
        } else if (data is Map && data['parcours'] is List) {
          return data['parcours'];
        }
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }

  // Récupérer tous les parcours
  Future<List<dynamic>> getParcours() async {
    try {
      final response = await _apiClient.get('/parcours');

      if (response['success'] == true) {
        final data = response['data'];
        if (data is List) {
          return data;
        } else if (data is Map && data['parcours'] is List) {
          return data['parcours'];
        }
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }
}

