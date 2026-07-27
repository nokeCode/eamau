import '../api_client.dart';

class PublicationService {
  final ApiClient _apiClient = ApiClient();

  // Récupérer la liste des publications
  Future<Map<String, dynamic>> getPublications({
    int page = 1,
    int limit = 12,
    String? sort,
    String? order,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        if (sort != null) 'sort': sort,
        if (order != null) 'order': order,
      };

      final response = await _apiClient.get(
        '/publications',
        queryParams: queryParams,
        requireAuth: true,
      );

      if (response['success'] == true) {
        return response['data'] ?? {};
      } else {
        throw ApiException(response['message'] ?? 'Erreur lors de la récupération des publications');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Créer une publication
  Future<Map<String, dynamic>> createPublication(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _apiClient.post(
        '/publications',
        body: data,
        requireAuth: true,
      );

      if (response['success'] == true) {
        return response['data'] ?? {};
      } else {
        throw ApiException(response['message'] ?? 'Erreur lors de la création de la publication');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Récupérer les auteurs
  Future<List<dynamic>> getAuthors() async {
    try {
      final response = await _apiClient.get(
        '/publications/authors',
        requireAuth: true,
      );

      if (response['success'] == true) {
        final data = response['data'];
        if (data is List) {
          return data;
        } else if (data is Map && data['authors'] is List) {
          return data['authors'];
        }
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }

  // Récupérer les catégories
  Future<List<dynamic>> getCategories() async {
    try {
      final response = await _apiClient.get(
        '/publications/categories',
        requireAuth: true,
      );

      if (response['success'] == true) {
        final data = response['data'];
        if (data is List) {
          return data;
        } else if (data is Map && data['categories'] is List) {
          return data['categories'];
        }
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }

  // Récupérer les publications favorites
  Future<List<dynamic>> getFavorites() async {
    try {
      final response = await _apiClient.get(
        '/publications/favorites',
        requireAuth: true,
      );

      if (response['success'] == true) {
        final data = response['data'];
        if (data is List) {
          return data;
        } else if (data is Map && data['favorites'] is List) {
          return data['favorites'];
        }
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }

  // Rechercher des publications
  Future<Map<String, dynamic>> searchPublications(
    Map<String, dynamic> searchData,
  ) async {
    try {
      final response = await _apiClient.post(
        '/publications/search',
        body: searchData,
        requireAuth: true,
      );

      if (response['success'] == true) {
        return response['data'] ?? {};
      } else {
        throw ApiException(response['message'] ?? 'Erreur lors de la recherche');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Récupérer les types
  Future<List<dynamic>> getTypes() async {
    try {
      final response = await _apiClient.get(
        '/publications/types',
        requireAuth: true,
      );

      if (response['success'] == true) {
        final data = response['data'];
        if (data is List) {
          return data;
        } else if (data is Map && data['types'] is List) {
          return data['types'];
        }
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }

  // Récupérer le détail d'une publication par slug
  Future<Map<String, dynamic>> getPublicationBySlug(String slug) async {
    try {
      final response = await _apiClient.get(
        '/publications/$slug',
        requireAuth: true,
      );

      if (response['success'] == true) {
        return response['data'] ?? {};
      } else {
        throw ApiException(response['message'] ?? 'Publication non trouvée');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Mettre à jour une publication
  Future<Map<String, dynamic>> updatePublication({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await _apiClient.patch(
        '/publications/$id',
        body: data,
        requireAuth: true,
      );

      if (response['success'] == true) {
        return response['data'] ?? {};
      } else {
        throw ApiException(response['message'] ?? 'Erreur lors de la mise à jour');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Ajouter aux favoris
  Future<void> addToFavorites(String id) async {
    try {
      final response = await _apiClient.post(
        '/publications/$id/favorite',
        body: {},
        requireAuth: true,
      );

      if (response['success'] != true) {
        throw ApiException(response['message'] ?? 'Erreur lors de l\'ajout aux favoris');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Retirer des favoris
  Future<void> removeFromFavorites(String id) async {
    try {
      final response = await _apiClient.delete(
        '/publications/$id/favorite',
        requireAuth: true,
      );

      if (response['success'] != true) {
        throw ApiException(response['message'] ?? 'Erreur lors du retrait des favoris');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Télécharger une publication
  Future<String> downloadPublication(String id) async {
    try {
      final response = await _apiClient.post(
        '/publications/$id/download',
        body: {},
        requireAuth: true,
      );

      if (response['success'] == true) {
        final data = response['data'];
        if (data is Map && data['url'] != null) {
          return data['url'];
        }
      }

      throw ApiException('Erreur lors du téléchargement');
    } catch (e) {
      rethrow;
    }
  }

  // Télécharger un fichier spécifique
  Future<String> downloadFile({
    required String publicationId,
    required String fileId,
  }) async {
    try {
      final response = await _apiClient.get(
        '/publications/$publicationId/download/file/$fileId',
        requireAuth: true,
      );

      if (response['success'] == true) {
        final data = response['data'];
        if (data is Map && data['url'] != null) {
          return data['url'];
        }
      }

      throw ApiException('Erreur lors du téléchargement du fichier');
    } catch (e) {
      rethrow;
    }
  }

  // Récupérer l'historique d'une publication
  Future<List<dynamic>> getHistory(String id) async {
    try {
      final response = await _apiClient.get(
        '/publications/$id/history',
        requireAuth: true,
      );

      if (response['success'] == true) {
        final data = response['data'];
        if (data is List) {
          return data;
        } else if (data is Map && data['history'] is List) {
          return data['history'];
        }
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }

  // Enregistrer une vue
  Future<void> recordView(String id) async {
    try {
      await _apiClient.post(
        '/publications/$id/view',
        body: {},
        requireAuth: true,
      );
    } catch (e) {
      // Silencieusement échouer pour l'enregistrement de vue
    }
  }
}

