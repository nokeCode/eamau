class ConcoursModel {
  final int id;
  final String titre;
  final String niveau;
  final String image;
  final String statut;
  final String dateLimite;
  final int joursRestants;

  const ConcoursModel({
    required this.id,
    required this.titre,
    required this.niveau,
    required this.image,
    required this.statut,
    required this.dateLimite,
    required this.joursRestants,
  });

  factory ConcoursModel.fromJson(Map<String, dynamic> json) {
    return ConcoursModel(
      id: json['id'] ?? 0,
      titre: json['titre'] ?? '',
      niveau: json['niveau'] ?? '',
      image: json['image'] ?? '',
      statut: json['statut'] ?? 'Ouvert',
      dateLimite: json['date_limite'] ?? '',
      joursRestants: json['jours_restants'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titre': titre,
      'niveau': niveau,
      'image': image,
      'statut': statut,
      'date_limite': dateLimite,
      'jours_restants': joursRestants,
    };
  }
}