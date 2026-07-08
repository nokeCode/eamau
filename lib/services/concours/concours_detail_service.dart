import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/concours/concours_detail_model.dart';

class ConcoursDetailService {
  static const String baseUrl = 'api/eamau/concours';

  Future<ConcoursDetailModel> getConcoursDetail(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$id'),
      );

      if (response.statusCode == 200) {
        return ConcoursDetailModel.fromJson(
          json.decode(response.body),
        );
      }
    } catch (_) {}

    return fallbackConcoursDetail;
  }
}

const ConcoursDetailModel fallbackConcoursDetail = ConcoursDetailModel(
  id: 1,
  titre: "Concours d’entrée",
  description: "Intégrez l'excellence académique à l'EAMAU",
  image:
  "https://www.eamau.org/wp-content/uploads/2025/05/concours-2025.jpg",
  anneeAcademique: "2025 - 2026",
  periodeInscription: "01 mai - 30 juin 2025",
  dateExamen: "15 juillet 2025",
  filieres: "Architecture, Urbanisme,\nGestion Urbaine",
  diplome: "----",
  conditions:
  "Le candidat doit être âgé de moins de 25 ans, être titulaire du Baccalauréat ou en classe de Terminale et satisfaire aux critères d'éligibilité définis par l'EAMAU.",
  piecesAFournir: [
    "Copie de l'acte de naissance",
    "Copie du certificat de nationalité",
    "Copie du relevé de notes ou du BAC",
    "Photo d'identité récente",
    "Reçu de paiement des frais d'inscription",
  ],
);