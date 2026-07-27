import '../api_client.dart';

class InscriptionService {
  final ApiClient _apiClient = ApiClient();

  // Récupérer la liste des demandes d'inscription
  Future<List<dynamic>> getInscriptions() async {
    try {
      final response = await _apiClient.get(
        '/inscriptions',
        requireAuth: true,
      );

      if (response['success'] == true) {
        final data = response['data'];
        if (data is List) {
          return data;
        } else if (data is Map && data['inscriptions'] is List) {
          return data['inscriptions'];
        }
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }

  // Créer une nouvelle demande d'inscription
  Future<Map<String, dynamic>> createInscription() async {
    try {
      final response = await _apiClient.post(
        '/inscriptions',
        body: {},
        requireAuth: true,
      );

      if (response['success'] == true) {
        return response['data'] ?? {};
      } else {
        throw ApiException(response['message'] ?? 'Erreur lors de la création de l\'inscription');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Récupérer les pièces requises
  Future<List<dynamic>> getRequiredDocuments() async {
    try {
      final response = await _apiClient.get(
        '/inscriptions/pieces',
        requireAuth: true,
      );

      if (response['success'] == true) {
        final data = response['data'];
        if (data is List) {
          return data;
        } else if (data is Map && data['pieces'] is List) {
          return data['pieces'];
        }
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }

  // Récupérer le détail d'une inscription
  Future<Map<String, dynamic>> getInscriptionDetail(String id) async {
    try {
      final response = await _apiClient.get(
        '/inscriptions/$id',
        requireAuth: true,
      );

      if (response['success'] == true) {
        return response['data'] ?? {};
      } else {
        throw ApiException(response['message'] ?? 'Inscription non trouvée');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Mettre à jour une inscription
  Future<Map<String, dynamic>> updateInscription({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await _apiClient.put(
        '/inscriptions/$id',
        body: data,
        requireAuth: true,
      );

      if (response['success'] == true) {
        return response['data'] ?? {};
      } else {
        throw ApiException(response['message'] ?? 'Erreur lors de la mise à jour de l\'inscription');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Télécharger un document
  Future<Map<String, dynamic>> uploadDocument({
    required String inscriptionId,
    required String fileName,
  }) async {
    try {
      final response = await _apiClient.post(
        '/inscriptions/$inscriptionId/documents',
        body: {
          'file': fileName,
        },
        requireAuth: true,
      );

      if (response['success'] == true) {
        return response['data'] ?? {};
      } else {
        throw ApiException(response['message'] ?? 'Erreur lors du téléchargement du document');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Supprimer un document
  Future<void> deleteDocument({
    required String inscriptionId,
    required String documentId,
  }) async {
    try {
      final response = await _apiClient.delete(
        '/inscriptions/$inscriptionId/documents/$documentId',
        requireAuth: true,
      );

      if (response['success'] != true) {
        throw ApiException(response['message'] ?? 'Erreur lors de la suppression du document');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Télécharger la fiche d'inscription
  Future<String> downloadInscriptionSheet(String id) async {
    try {
      final response = await _apiClient.get(
        '/inscriptions/$id/download',
        requireAuth: true,
      );

      if (response['success'] == true) {
        final data = response['data'];
        if (data is Map && data['url'] != null) {
          return data['url'];
        }
      }

      throw ApiException('Erreur lors du téléchargement de la fiche');
    } catch (e) {
      rethrow;
    }
  }

  // Récupérer l'historique d'une inscription
  Future<List<dynamic>> getInscriptionHistory(String id) async {
    try {
      final response = await _apiClient.get(
        '/inscriptions/$id/history',
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

  // Soumettre une inscription
  Future<Map<String, dynamic>> submitInscription(String id) async {
    try {
      final response = await _apiClient.post(
        '/inscriptions/$id/submit',
        body: {},
        requireAuth: true,
      );

      if (response['success'] == true) {
        return response['data'] ?? {};
      } else {
        throw ApiException(response['message'] ?? 'Erreur lors de la soumission de l\'inscription');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Récupérer le suivi d'une inscription
  Future<Map<String, dynamic>> getInscriptionTracking(String id) async {
    try {
      final response = await _apiClient.get(
        '/inscriptions/$id/tracking',
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
}

