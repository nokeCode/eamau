import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/concours/suivi_candidature_model.dart';

class SuiviCandidatureService {
  static const String endpoint =
      "api/eamau/concours/suivi";

  Future<SuiviCandidatureModel> getSuivi(
      int candidatureId) async {
    try {
      final response = await http.get(
        Uri.parse("$endpoint/$candidatureId"),
      );

      if (response.statusCode == 200) {
        return SuiviCandidatureModel.fromJson(
          jsonDecode(response.body),
        );
      }
    } catch (_) {}

    return fallbackSuivi;
  }
}

const fallbackSuivi = SuiviCandidatureModel(
  id: 1,
  nomComplet: "AHME Mohamed",
  programme: "Entrée générale",
  dateSoumission: "12 mai 2025",
  statutActuel: "Dossier en vérification",
  etapes: [
    SuiviEtapeModel(
      titre: "Candidature reçue",
      description:
      "Votre candidature a été reçue avec succès.",
      date: "12 mai 2025",
      completed: true,
    ),
    SuiviEtapeModel(
      titre: "Dossier en vérification",
      description:
      "Votre dossier est en cours d'examen par la commission.",
      date: "14 mai 2025",
      completed: true,
    ),
    SuiviEtapeModel(
      titre: "Examen écrit",
      description:
      "Vous serez notifié pour l'examen écrit.",
      date: "",
      completed: false,
    ),
    SuiviEtapeModel(
      titre: "Résultat publié",
      description:
      "Les résultats seront publiés sur votre espace candidat.",
      date: "",
      completed: false,
    ),
  ],
);