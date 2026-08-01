class ConcoursDetailModel {
  final String id;
  final String titre;
  final String slug;
  final String description;
  final String image;
  final String conditions;
  final String periodeInscription;
  final String dateExamen;
  final List<String> piecesAFournir;
  final List<String> attributes;
  final bool published;
  final bool active;

  const ConcoursDetailModel({
    required this.id,
    required this.titre,
    required this.slug,
    required this.description,
    required this.image,
    required this.conditions,
    required this.periodeInscription,
    required this.dateExamen,
    required this.piecesAFournir,
    required this.attributes,
    required this.published,
    required this.active,
  });

  factory ConcoursDetailModel.fromJson(Map<String, dynamic> json) {
    final dates = json['dates'] as Map<String, dynamic>? ?? {};
    final conditionsJson = json['conditions'] as Map<String, dynamic>? ?? {};
    final attributes = (json['attributes'] as List<dynamic>?)
            ?.map((e) => e is String ? e : '${e['name'] ?? e['slug'] ?? ''}')
            .toList() ??
        [];
    final pieces = (json['pieces'] as List<dynamic>?)
            ?.map((e) => e is String ? e : '${e['name'] ?? e['slug'] ?? ''}')
            .toList() ??
        [];

    return ConcoursDetailModel(
      id: '${json['id'] ?? ''}',
      titre: '${json['title'] ?? json['titre'] ?? ''}',
      slug: '${json['slug'] ?? ''}',
      description: '${json['description'] ?? ''}',
      image: '${json['image'] ?? ''}',
      conditions:
          '${conditionsJson['published'] ?? ''} / ${conditionsJson['active'] ?? ''}',
      periodeInscription:
          '${dates['startingAt'] ?? ''} — ${dates['endingAt'] ?? ''}',
      dateExamen: '${dates['endingAt'] ?? ''}',
      piecesAFournir: pieces,
      attributes: attributes,
      published: conditionsJson['published'] == true,
      active: conditionsJson['active'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titre': titre,
      'slug': slug,
      'description': description,
      'image': image,
      'conditions': conditions,
      'periodeInscription': periodeInscription,
      'dateExamen': dateExamen,
      'piecesAFournir': piecesAFournir,
      'attributes': attributes,
      'published': published,
      'active': active,
    };
  }
}