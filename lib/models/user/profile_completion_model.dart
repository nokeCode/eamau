class ProfileCompletionModel {
  final int percentage;
  final String title;
  final String description;
  final String buttonText;

  const ProfileCompletionModel({
    required this.percentage,
    required this.title,
    required this.description,
    required this.buttonText,
  });

  factory ProfileCompletionModel.fromJson(Map<String, dynamic> json) {
    return ProfileCompletionModel(
      percentage: json['percentage'] ?? 75,
      title: json['title'] ?? 'Complétion du profil',
      description: json['description'] ??
          'Complétez les informations restantes pour accéder à tous les services.',
      buttonText: json['buttonText'] ?? 'Compléter mon profil',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'percentage': percentage,
      'title': title,
      'description': description,
      'buttonText': buttonText,
    };
  }

  static ProfileCompletionModel fallback() {
    return const ProfileCompletionModel(
      percentage: 75,
      title: 'Complétion du profil',
      description:
      'Complétez les informations restantes pour accéder à tous les services.',
      buttonText: 'Compléter mon profil',
    );
  }
}