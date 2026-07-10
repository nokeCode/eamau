class Parcours {
  final int id;
  final String nom;
  final String description;
  final String image;
  final String details;

  const Parcours({
    required this.id,
    required this.nom,
    required this.description,
    required this.image,
    required this.details,
  });

  factory Parcours.fromJson(Map<String, dynamic> json) {
    return Parcours(
      id: json['id'] ?? 0,
      nom: json['nom'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      details: json['details'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nom': nom,
    'description': description,
    'image': image,
    'details': details,
  };
}

class Filiere {
  final int id;
  final String nom;
  final String niveau;
  final String description;
  final String image;

  /// uniquement disponible sur la page détail
  final List<String> images;
  final List<Parcours> parcours;

  const Filiere({
    required this.id,
    required this.nom,
    required this.niveau,
    required this.description,
    required this.image,
    this.images = const [],
    this.parcours = const [],
  });

  factory Filiere.fromJson(Map<String, dynamic> json) {
    return Filiere(
      id: json['id'] ?? 0,
      nom: json['nom'] ?? '',
      niveau: json['niveau'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      parcours: (json['parcours'] as List<dynamic>?)
          ?.map((e) => Parcours.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nom': nom,
    'niveau': niveau,
    'description': description,
    'image': image,
    'images': images,
    'parcours': parcours.map((e) => e.toJson()).toList(),
  };
}