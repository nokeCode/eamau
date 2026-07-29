import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/admission/admission_condition_model.dart';

class AdmissionConditionService {
  static const String apiUrl =
      "https://votre-api.com/api/admission/conditions";

  Future<List<AdmissionConditionModel>> getConditions() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);

        return data
            .map((e) => AdmissionConditionModel.fromJson(e))
            .toList();
      }
    } catch (_) {}

    return fallbackConditions;
  }
}

const List<AdmissionConditionModel> fallbackConditions = [
  AdmissionConditionModel(
    id: 1,
    title: "Diplômes éligibles",
    subtitle:
    "Consultez la liste des diplômes autorisés pour chaque programme.",
    icon: "school",
    items: [],
  ),
  AdmissionConditionModel(
    id: 2,
    title: "Programmes disponibles",
    subtitle:
    "Explorez les programmes disponibles à l'EAMAU.",
    icon: "book",
    items: [],
  ),
  AdmissionConditionModel(
    id: 3,
    title: "Document requis",
    subtitle:
    "Préparez les documents nécessaires à votre candidature.",
    icon: "description",
    expanded: true,
    items: [
      "Copie certifiée du diplôme le plus élevé",
      "Relevés de notes officiels",
      "Pièce d'identité valide",
      "Lettre de motivation",
      "Curriculum vitæ à jour",
      "Attestations ou certificats (si applicables)",
    ],
  ),
  AdmissionConditionModel(
    id: 4,
    title: "Critères de sélection",
    subtitle:
    "Informez-vous sur les critères d'évaluation des candidatures.",
    icon: "verified",
    items: [],
  ),
];