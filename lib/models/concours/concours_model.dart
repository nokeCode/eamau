class ConcoursModel {
  final String id;
  final String titre;
  final String slug;
  final String year;
  final String description;
  final String image;
  final String statut;
  final String startingAt;
  final String endingAt;

  const ConcoursModel({
    required this.id,
    required this.titre,
    required this.slug,
    required this.year,
    required this.description,
    required this.image,
    required this.statut,
    required this.startingAt,
    required this.endingAt,
  });

  factory ConcoursModel.fromJson(Map<String, dynamic> json) {
    return ConcoursModel(
      id: '${json['id'] ?? ''}',
      titre: '${json['title'] ?? json['titre'] ?? ''}',
      slug: '${json['slug'] ?? ''}',
      year: '${json['year'] ?? ''}',
      description: '${json['description'] ?? ''}',
      image: '${json['image'] ?? ''}',
      statut: '${json['status'] ?? json['statut'] ?? 'Ouvert'}',
      startingAt: '${json['startingAt'] ?? json['starting_at'] ?? ''}',
      endingAt: '${json['endingAt'] ?? json['ending_at'] ?? ''}',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titre': titre,
      'slug': slug,
      'year': year,
      'description': description,
      'image': image,
      'statut': statut,
      'startingAt': startingAt,
      'endingAt': endingAt,
    };
  }
}