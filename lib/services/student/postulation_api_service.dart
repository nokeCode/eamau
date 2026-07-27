import '../api_client.dart';

class PostulationService {
  final ApiClient _apiClient = ApiClient();

  // Récupérer le détail d'une postulation
  Future<Map<String, dynamic>> getPostulationDetail(String reference) async {
    try {
      final response = await _apiClient.get(
        '/postulations/$reference',
        requireAuth: true,
      );

      if (response['success'] == true) {
        return response['data'] ?? {};
      } else {
        throw ApiException(response['message'] ?? 'Postulation non trouvée');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Télécharger un document
  Future<Map<String, dynamic>> uploadDocument({
    required String postulationId,
    required String fileName,
  }) async {
    try {
      final response = await _apiClient.post(
        '/postulations/$postulationId/documents',
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
    required String postulationId,
    required String documentId,
  }) async {
    try {
      final response = await _apiClient.delete(
        '/postulations/$postulationId/documents/$documentId',
        requireAuth: true,
      );

      if (response['success'] != true) {
        throw ApiException(response['message'] ?? 'Erreur lors de la suppression du document');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Soumettre une postulation
  Future<Map<String, dynamic>> submitPostulation(String postulationId) async {
    try {
      final response = await _apiClient.post(
        '/postulations/$postulationId/submit',
        body: {},
        requireAuth: true,
      );

      if (response['success'] == true) {
        return response['data'] ?? {};
      } else {
        throw ApiException(response['message'] ?? 'Erreur lors de la soumission de la postulation');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Récupérer l'attestation
  Future<String> getAttestation(String reference) async {
    try {
      final response = await _apiClient.get(
        '/postulations/$reference/attestation',
        requireAuth: true,
      );

      if (response['success'] == true) {
        final data = response['data'];
        if (data is Map && data['url'] != null) {
          return data['url'];
        }
      }

      throw ApiException('Erreur lors de la récupération de l\'attestation');
    } catch (e) {
      rethrow;
    }
  }

  // Récupérer l'historique
  Future<List<dynamic>> getHistory(String reference) async {
    try {
      final response = await _apiClient.get(
        '/postulations/$reference/history',
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

  // Récupérer le suivi
  Future<Map<String, dynamic>> getTracking(String reference) async {
    try {
      final response = await _apiClient.get(
        '/postulations/$reference/tracking',
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

