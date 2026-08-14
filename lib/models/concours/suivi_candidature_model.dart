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
    final date = json['date']?.toString() ?? '';
    return SuiviEtapeModel(
      titre: json['titre']?.toString() ?? json['label']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      date: date,
      completed: json['completed'] as bool? ?? date.isNotEmpty,
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
  final String reference;
  final String nomComplet;
  final String programme;
  final String dateSoumission;
  final String dateExamen;
  final String statutActuel;
  final List<SuiviEtapeModel> etapes;

  const SuiviCandidatureModel({
    required this.reference,
    required this.nomComplet,
    required this.programme,
    required this.dateSoumission,
    required this.dateExamen,
    required this.statutActuel,
    required this.etapes,
  });

  factory SuiviCandidatureModel.fromJson(Map<String, dynamic> json) {
    final rawStatus =
        json['status']?.toString() ?? json['statut']?.toString() ?? '';
    return SuiviCandidatureModel(
      reference: json['reference']?.toString() ?? '',
      nomComplet: json['candidateFullName']?.toString() ?? '',
      programme: json['program']?.toString() ?? '',
      dateSoumission: json['submittedAt']?.toString() ?? '',
      dateExamen: json['examDate']?.toString() ?? '',
      statutActuel: _mapStatusToLabel(rawStatus),
      etapes:
          (json['timeline'] as List<dynamic>?)
              ?.map((e) => SuiviEtapeModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          (json['etapes'] as List<dynamic>?)
              ?.map((e) => SuiviEtapeModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  static String _mapStatusToLabel(String status) {
    final normalized = status.toLowerCase().trim();
    switch (normalized) {
      case 'submitted':
      case 'soumis':
        return 'Vérification';
      case 'verification':
      case 'en vérification':
      case 'dossier en vérification':
        return 'Dossier en vérification';
      case 'accepted':
      case 'acceptée':
      case 'accepté':
        return 'Acceptée';
      case 'rejected':
      case 'rejetée':
      case 'rejeté':
        return 'Rejetée';
      default:
        return status.isNotEmpty ? status : 'Statut inconnu';
    }
  }
}
