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
      id: int.tryParse('${json['id']}') ?? 0,
      nom: '${json['nom'] ?? json['name'] ?? ''}',
      description: '${json['description'] ?? ''}',
      image: '${json['image'] ?? ''}',
      details: '${json['details'] ?? ''}',
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

class FiliereMeta {
  final int page;
  final int perPage;
  final int total;
  final int lastPage;

  const FiliereMeta({
    required this.page,
    required this.perPage,
    required this.total,
    required this.lastPage,
  });

  factory FiliereMeta.fromJson(Map<String, dynamic> json) {
    return FiliereMeta(
      page: int.tryParse('${json['page']}') ?? 1,
      perPage: int.tryParse('${json['perPage']}') ?? 10,
      total: int.tryParse('${json['total']}') ?? 0,
      lastPage: int.tryParse('${json['lastPage']}') ?? 1,
    );
  }
}

class FilierePageResult {
  final List<Filiere> items;
  final FiliereMeta meta;

  const FilierePageResult({required this.items, required this.meta});
}

class Filiere {
  final int id;
  final String nom;
  final String slug;
  final String niveau;
  final String description;
  final String presentation;
  final String image;
  final int parcoursCount;
  final List<String> images;
  final List<Parcours> parcours;
  final String? diplomes;
  final String? duree;
  final String? debouches;

  const Filiere({
    required this.id,
    required this.nom,
    required this.slug,
    this.niveau = '',
    required this.description,
    this.presentation = '',
    required this.image,
    this.parcoursCount = 0,
    this.images = const [],
    this.parcours = const [],
    this.diplomes,
    this.duree,
    this.debouches,
  });

  factory Filiere.fromJson(Map<String, dynamic> json) {
    return Filiere(
      id: int.tryParse('${json['id']}') ?? 0,
      nom: '${json['name'] ?? json['nom'] ?? ''}',
      slug: '${json['slug'] ?? ''}',
      niveau: '${json['niveau'] ?? ''}',
      description: '${json['description'] ?? ''}',
      presentation: '${json['presentation'] ?? ''}',
      image: '${json['image'] ?? ''}',
      parcoursCount: int.tryParse('${json['parcoursCount']}') ?? 0,
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      parcours: (json['parcours'] as List<dynamic>?)
              ?.map((e) => Parcours.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
      diplomes: json['diplomes']?.toString(),
      duree: json['duree']?.toString(),
      debouches: json['debouches']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nom': nom,
        'slug': slug,
        'niveau': niveau,
        'description': description,
        'presentation': presentation,
        'image': image,
        'parcoursCount': parcoursCount,
        'images': images,
        'parcours': parcours.map((e) => e.toJson()).toList(),
        'diplomes': diplomes,
        'duree': duree,
        'debouches': debouches,
      };
}