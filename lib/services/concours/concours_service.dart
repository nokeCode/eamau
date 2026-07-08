import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/concours/concours_model.dart';

class ConcoursService {
  static const String endpoint = 'api/eamau/concours';

  Future<List<ConcoursModel>> getConcours() async {
    try {
      final response = await http.get(
        Uri.parse(endpoint),
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);

        return data
            .map((e) => ConcoursModel.fromJson(e))
            .toList();
      }
    } catch (_) {}

    return fallbackConcours;
  }
}

///
/// Données utilisées si l'API n'est pas disponible.
///
const List<ConcoursModel> fallbackConcours = [
  ConcoursModel(
    id: 1,
    titre: 'Licence Design graphique',
    niveau: 'Licence',
    image:
    'https://www.eamau.org/wp-content/uploads/2025/05/concours-2025.jpg',
    statut: 'Ouvert',
    dateLimite: '15 juin 2025',
    joursRestants: 24,
  ),
  ConcoursModel(
    id: 2,
    titre: 'Licence Design graphique',
    niveau: 'Licence',
    image:
    'https://www.eamau.org/wp-content/uploads/2025/05/concours-2025.jpg',
    statut: 'Ouvert',
    dateLimite: '15 juin 2025',
    joursRestants: 24,
  ),
  ConcoursModel(
    id: 3,
    titre: 'Licence Design graphique',
    niveau: 'Licence',
    image:
    'https://www.eamau.org/wp-content/uploads/2025/05/concours-2025.jpg',
    statut: 'Ouvert',
    dateLimite: '15 juin 2025',
    joursRestants: 24,
  ),
  ConcoursModel(
    id: 4,
    titre: 'Licence Design graphique',
    niveau: 'Licence',
    image:
    'https://www.eamau.org/wp-content/uploads/2025/05/concours-2025.jpg',
    statut: 'Ouvert',
    dateLimite: '15 juin 2025',
    joursRestants: 24,
  ),
];