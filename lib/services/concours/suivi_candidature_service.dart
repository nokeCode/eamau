import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/api/api_config.dart';
import '../../models/concours/suivi_candidature_model.dart';

class SuiviCandidatureService {
  static final String endpoint = '${ApiConfig.fullBaseUrl}/postulations';
  static const Map<String, String> headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  Future<SuiviCandidatureModel> getSuivi(String reference) async {
    try {
      final response = await http.get(
        Uri.parse('$endpoint/$reference/tracking'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return SuiviCandidatureModel.fromJson(jsonDecode(response.body));
      }
    } catch (_) {}

    return fallbackSuivi;
  }
}

const fallbackSuivi = SuiviCandidatureModel(
  reference: 'EAMAU-2025-000154',
  nomComplet: "AHME Mohamed",
  programme: "Entrée générale",
  dateSoumission: "12 mai 2025",
  statutActuel: "Dossier en vérification",
  attestationUrl: "https://www.eamau.org/attestation.pdf",
  etapes: [
    SuiviEtapeModel(
      titre: "Candidature reçue",
      description: "Votre candidature a été reçue avec succès.",
      date: "12 mai 2025",
      completed: true,
    ),
    SuiviEtapeModel(
      titre: "Dossier en vérification",
      description: "Votre dossier est en cours d'examen par la commission.",
      date: "14 mai 2025",
      completed: true,
    ),
    SuiviEtapeModel(
      titre: "Examen écrit",
      description: "Vous serez notifié pour l'examen écrit.",
      date: "",
      completed: false,
    ),
    SuiviEtapeModel(
      titre: "Résultat publié",
      description: "Les résultats seront publiés sur votre espace candidat.",
      date: "",
      completed: false,
    ),
  ],
);
