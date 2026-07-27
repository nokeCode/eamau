import '../api_client.dart';

class ConcoursService {
  final ApiClient _apiClient = ApiClient();

  // Récupérer la liste des concours
  Future<Map<String, dynamic>> getConcours() async {
    try {
      final response = await _apiClient.get('/concours');

      if (response['success'] == true) {
        return response['data'] ?? {};
      } else {
        throw ApiException(response['message'] ?? 'Erreur lors de la récupération des concours');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Rechercher des concours
  Future<Map<String, dynamic>> searchConcours({
    String? query,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        if (query != null) 'q': query,
      };

      final response = await _apiClient.get(
        '/concours/search',
        queryParams: queryParams,
      );

      if (response['success'] == true) {
        return response['data'] ?? {};
      } else {
        throw ApiException(response['message'] ?? 'Erreur lors de la recherche des concours');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Récupérer le détail d'un concours
  Future<Map<String, dynamic>> getConcoursDetail(String slug) async {
    try {
      final response = await _apiClient.get('/concours/$slug');

      if (response['success'] == true) {
        return response['data'] ?? {};
      } else {
        throw ApiException(response['message'] ?? 'Concours non trouvé');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Postuler à un concours
  Future<Map<String, dynamic>> applyToConcours(String concoursId) async {
    try {
      final response = await _apiClient.post(
        '/concours/$concoursId/postulation',
        body: {},
        requireAuth: true,
      );

      if (response['success'] == true) {
        return response['data'] ?? {};
      } else {
        throw ApiException(response['message'] ?? 'Erreur lors de la postulation');
      }
    } catch (e) {
      rethrow;
    }
  }
}

