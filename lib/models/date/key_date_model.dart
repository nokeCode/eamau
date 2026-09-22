class KeyDateModel {
  final String id;
  final String title;
  final String? description;
  final DateTime date;
  final bool isImportant;
  final String? category;

  KeyDateModel({
    required this.id,
    required this.title,
    this.description,
    required this.date,
    this.isImportant = false,
    this.category,
  });

  factory KeyDateModel.fromJson(Map<String, dynamic> json) {
    return KeyDateModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? json['titre'] ?? '',
      description: json['description'] ?? json['contenu'],
      date: json['date'] != null 
          ? DateTime.tryParse(json['date'].toString()) ?? DateTime.now()
          : DateTime.now(),
      isImportant: json['isImportant'] ?? json['important'] ?? false,
      category: json['category'] ?? json['categorie'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'isImportant': isImportant,
      'category': category,
    };
  }
}
