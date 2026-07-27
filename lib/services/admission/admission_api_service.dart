import '../api_client.dart';

class AdmissionService {
  final ApiClient _apiClient = ApiClient();

  // Récupérer les conditions d'admission
  Future<List<dynamic>> getAdmissionConditions() async {
    try {
      final response = await _apiClient.get('/admission-conditions');

      if (response['success'] == true) {
        final data = response['data'];
        if (data is List) {
          return data;
        } else if (data is Map && data['conditions'] is List) {
          return data['conditions'];
        }
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }

  // Récupérer les niveaux d'admission
  Future<List<dynamic>> getAdmissionLevels() async {
    try {
      final response = await _apiClient.get('/admission-levels');

      if (response['success'] == true) {
        final data = response['data'];
        if (data is List) {
          return data;
        } else if (data is Map && data['levels'] is List) {
          return data['levels'];
        }
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }

  // Récupérer la liste des admissions
  Future<Map<String, dynamic>> getAdmissions({
    int page = 1,
    int limit = 10,
    String? status,
    String? search,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        if (status != null) 'status': status,
        if (search != null) 'search': search,
      };

      final response = await _apiClient.get(
        '/admissions',
        queryParams: queryParams,
        requireAuth: true,
      );

      if (response['success'] == true) {
        return response['data'] ?? {};
      } else {
        throw ApiException(response['message'] ?? 'Erreur lors de la récupération des admissions');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Créer une nouvelle admission
  Future<Map<String, dynamic>> createAdmission() async {
    try {
      final response = await _apiClient.post(
        '/admissions',
        body: {},
        requireAuth: true,
      );

      if (response['success'] == true) {
        return response['data'] ?? {};
      } else {
        throw ApiException(response['message'] ?? 'Erreur lors de la création de l\'admission');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Récupérer les statistiques des admissions
  Future<Map<String, dynamic>> getAdmissionsStatistics() async {
    try {
      final response = await _apiClient.get(
        '/admissions/statistics',
        requireAuth: true,
      );

      if (response['success'] == true) {
        return response['data'] ?? {};
      } else {
        throw ApiException(response['message'] ?? 'Erreur lors de la récupération des statistiques');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Récupérer les détails d'une admission
  Future<Map<String, dynamic>> getAdmissionDetail(String uuid) async {
    try {
      final response = await _apiClient.get(
        '/admissions/$uuid',
        requireAuth: true,
      );

      if (response['success'] == true) {
        return response['data'] ?? {};
      } else {
        throw ApiException(response['message'] ?? 'Admission non trouvée');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Mettre à jour une admission
  Future<Map<String, dynamic>> updateAdmission({
    required String uuid,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await _apiClient.put(
        '/admissions/$uuid',
        body: data,
        requireAuth: true,
      );

      if (response['success'] == true) {
        return response['data'] ?? {};
      } else {
        throw ApiException(response['message'] ?? 'Erreur lors de la mise à jour de l\'admission');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Supprimer une admission
  Future<void> deleteAdmission(String uuid) async {
    try {
      final response = await _apiClient.delete(
        '/admissions/$uuid',
        requireAuth: true,
      );

      if (response['success'] != true) {
        throw ApiException(response['message'] ?? 'Erreur lors de la suppression de l\'admission');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Récupérer l'historique d'une admission
  Future<List<dynamic>> getAdmissionHistory(String uuid) async {
    try {
      final response = await _apiClient.get(
        '/admissions/$uuid/history',
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

  // Récupérer le suivi d'une admission
  Future<Map<String, dynamic>> getAdmissionTracking(String uuid) async {
    try {
      final response = await _apiClient.get(
        '/admissions/$uuid/tracking',
        requireAuth: true,
      );

      if (response['success'] == true) {
        return response['data'] ?? {};
      } else {
        throw ApiException(response['message'] ?? 'Erreur lors de la récupération du suivi');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Récupérer les documents d'une admission
  Future<List<dynamic>> getAdmissionDocuments(String uuid) async {
    try {
      final response = await _apiClient.get(
        '/admissions/$uuid/documents',
        requireAuth: true,
      );

      if (response['success'] == true) {
        final data = response['data'];
        if (data is List) {
          return data;
        } else if (data is Map && data['documents'] is List) {
          return data['documents'];
        }
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }

  // Ajouter un document à une admission
  Future<Map<String, dynamic>> addAdmissionDocument({
    required String uuid,
    required String fileName,
    required String documentType,
  }) async {
    try {
      final response = await _apiClient.post(
        '/admissions/$uuid/documents',
        body: {
          'file': fileName,
          'attachmentType': documentType,
        },
        requireAuth: true,
      );

      if (response['success'] == true) {
        return response['data'] ?? {};
      } else {
        throw ApiException(response['message'] ?? 'Erreur lors de l\'ajout du document');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Supprimer un document d'une admission
  Future<void> deleteAdmissionDocument({
    required String uuid,
    required String documentUuid,
  }) async {
    try {
      final response = await _apiClient.delete(
        '/admissions/$uuid/documents/$documentUuid',
        requireAuth: true,
      );

      if (response['success'] != true) {
        throw ApiException(response['message'] ?? 'Erreur lors de la suppression du document');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Soumettre une admission
  Future<Map<String, dynamic>> submitAdmission(String uuid) async {
    try {
      final response = await _apiClient.post(
        '/admissions/$uuid/submit',
        body: {},
        requireAuth: true,
      );

      if (response['success'] == true) {
        return response['data'] ?? {};
      } else {
        throw ApiException(response['message'] ?? 'Erreur lors de la soumission de l\'admission');
      }
    } catch (e) {
      rethrow;
    }
  }
}

