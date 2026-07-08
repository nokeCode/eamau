class ConcoursDetailModel {
  final int id;
  final String titre;
  final String description;
  final String image;

  final String anneeAcademique;
  final String periodeInscription;
  final String dateExamen;
  final String filieres;
  final String diplome;

  final String conditions;
  final List<String> piecesAFournir;

  const ConcoursDetailModel({
    required this.id,
    required this.titre,
    required this.description,
    required this.image,
    required this.anneeAcademique,
    required this.periodeInscription,
    required this.dateExamen,
    required this.filieres,
    required this.diplome,
    required this.conditions,
    required this.piecesAFournir,
  });

  factory ConcoursDetailModel.fromJson(Map<String, dynamic> json) {
    return ConcoursDetailModel(
      id: json['id'] ?? 0,
      titre: json['titre'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      anneeAcademique: json['annee_academique'] ?? '',
      periodeInscription: json['periode_inscription'] ?? '',
      dateExamen: json['date_examen'] ?? '',
      filieres: json['filieres'] ?? '',
      diplome: json['diplome'] ?? '',
      conditions: json['conditions'] ?? '',
      piecesAFournir:
      (json['pieces_a_fournir'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titre': titre,
      'description': description,
      'image': image,
      'annee_academique': anneeAcademique,
      'periode_inscription': periodeInscription,
      'date_examen': dateExamen,
      'filieres': filieres,
      'diplome': diplome,
      'conditions': conditions,
      'pieces_a_fournir': piecesAFournir,
    };
  }
}