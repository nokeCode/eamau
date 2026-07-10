import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/filiere/filiere_model.dart';

class FiliereService {
// Remplacer par ton URL réelle
static const String baseUrl = 'https://example.com/api';
Future<List<Filiere>> getFilieres() async {
try {
final response = await http.get(
Uri.parse('$baseUrl/filieres'),
);

if (response.statusCode == 200) {
final List data = jsonDecode(response.body);

return data
.map((e) => Filiere.fromJson(e))
.toList();
}
} catch (_) {}

return _fallbackFilieres;
}
Future<Filiere> getFiliereDetail(int id) async {
try {
final response = await http.get(
Uri.parse('$baseUrl/filieres/$id'),
);

if (response.statusCode == 200) {
return Filiere.fromJson(
jsonDecode(response.body),
);
}
} catch (_) {}

return _fallbackDetails.firstWhere(
(e) => e.id == id,
orElse: () => _fallbackDetails.first,
);
}
static final List<Filiere> _fallbackFilieres = [
Filiere(
id: 1,
nom: 'Architecture',
niveau: 'Licence',
description:
"La licence en architecture peut conduire à un emploi de cadre d'exécution au sein des cabinets d'architecture.",
image:
'https://images.unsplash.com/photo-1511818966892-d7d671e672a2',
),
Filiere(
id: 2,
nom: 'Urbanisme',
niveau: 'Licence',
description:
"La licence en urbanisme peut conduire à un emploi de cadre d'exécution dans les bureaux d'études.",
image:
'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab',
),
Filiere(
id: 3,
nom: 'Gestion Urbaine',
niveau: 'Licence',
description:
"La licence en gestion urbaine prépare aux métiers des collectivités et agences urbaines.",
image:
'https://images.unsplash.com/photo-1460317442991-0ec209397118',
),
];
static final List<Filiere> _fallbackDetails = [
  Filiere(
    id: 1,
    nom: 'Architecture',
    niveau: 'Licence',
    description:
    "La licence en architecture peut conduire à un emploi de cadre d'exécution au sein des cabinets d'architecture, des bureaux d'études, des entreprises de bâtiments et travaux publics ou des collectivités locales. Elle permet également de poursuivre en master.",
    image:
    'https://images.unsplash.com/photo-1511818966892-d7d671e672a2',
    images: [
      'https://images.unsplash.com/photo-1511818966892-d7d671e672a2',
      'https://images.unsplash.com/photo-1503387762-592deb58ef4e',
      'https://images.unsplash.com/photo-1494526585095-c41746248156',
      'https://images.unsplash.com/photo-1460317442991-0ec209397118',
    ],
    parcours: [
      Parcours(
        id: 1,
        nom: 'Licence en Architecture',
        description:
        "La licence est obtenue après trois années de formation correspondant à six semestres et 180 crédits.",
        image:
        'https://cdn-icons-png.flaticon.com/512/3135/3135755.png',
        details:
        "La licence comprend des enseignements théoriques, des ateliers de conception, des stages et un projet de fin de cycle.",
      ),
      Parcours(
        id: 2,
        nom: 'Master en Architecture',
        description:
        "Le master permet d'acquérir une expertise avancée en architecture et en urbanisme.",
        image:
        'https://cdn-icons-png.flaticon.com/512/3135/3135789.png',
        details:
        "Le master est orienté vers les projets complexes, la recherche et la spécialisation professionnelle.",
      ),
    ],
  ),

  Filiere(
    id: 2,
    nom: 'Urbanisme',
    niveau: 'Licence',
    description:
    "La licence en urbanisme prépare aux métiers de l'aménagement du territoire.",
    image:
    'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab',
    images: [],
    parcours: [],
  ),

  Filiere(
    id: 3,
    nom: 'Gestion Urbaine',
    niveau: 'Licence',
    description:
    "Formation axée sur la gestion des villes et collectivités.",
    image:
    'https://images.unsplash.com/photo-1460317442991-0ec209397118',
    images: [],
    parcours: [],
  ),
];
}