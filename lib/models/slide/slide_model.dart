class SlideModel {
  final String id;
  final String titre;
  final String? contenu;
  final String? imageName;
  final bool enabled;
  final String? imageUrl;

  SlideModel({
    required this.id,
    required this.titre,
    this.contenu,
    this.imageName,
    this.enabled = false,
    this.imageUrl,
  });

  factory SlideModel.fromJson(Map<String, dynamic> json) {
    return SlideModel(
      id: json['id']?.toString() ?? '',
      titre: json['titre'] ?? json['title'] ?? '',
      contenu: json['contenu'] ?? json['description'] ?? json['content'],
      imageName: json['imageName'] ?? json['image'],
      enabled: json['enabled'] ?? false,
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titre': titre,
      'contenu': contenu,
      'imageName': imageName,
      'enabled': enabled,
      'imageUrl': imageUrl,
    };
  }
}
