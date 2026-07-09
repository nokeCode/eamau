class SuiviEtapeModel {
  final String titre;
  final String description;
  final String date;
  final bool completed;

  const SuiviEtapeModel({
    required this.titre,
    required this.description,
    required this.date,
    required this.completed,
  });

  factory SuiviEtapeModel.fromJson(Map<String, dynamic> json) {
    return SuiviEtapeModel(
      titre: json['titre'] ?? '',
      description: json['description'] ?? '',
      date: json['date'] ?? '',
      completed: json['completed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'titre': titre,
      'description': description,
      'date': date,
      'completed': completed,
    };
  }
}

class SuiviCandidatureModel {
  final int id;
  final String nomComplet;
  final String programme;
  final String dateSoumission;
  final String statutActuel;
  final List<SuiviEtapeModel> etapes;

  const SuiviCandidatureModel({
    required this.id,
    required this.nomComplet,
    required this.programme,
    required this.dateSoumission,
    required this.statutActuel,
    required this.etapes,
  });

  factory SuiviCandidatureModel.fromJson(
      Map<String, dynamic> json) {
    return SuiviCandidatureModel(
      id: json['id'] ?? 0,
      nomComplet: json['nom_complet'] ?? '',
      programme: json['programme'] ?? '',
      dateSoumission: json['date_soumission'] ?? '',
      statutActuel: json['statut_actuel'] ?? '',
      etapes: (json['etapes'] as List<dynamic>?)
          ?.map(
            (e) => SuiviEtapeModel.fromJson(e),
      )
          .toList() ??
          [],
    );
  }
}