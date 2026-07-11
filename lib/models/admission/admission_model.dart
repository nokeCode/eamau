class AdmissionModel {
  final int id;
  final String title;
  final String description;
  final String eligibility;
  final String image;
  final bool isOpen;

  const AdmissionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.eligibility,
    required this.image,
    required this.isOpen,
  });

  factory AdmissionModel.fromJson(Map<String, dynamic> json) {
    return AdmissionModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      eligibility: json['eligibility'] ?? '',
      image: json['image'] ?? '',
      isOpen: json['is_open'] ?? true,
    );
  }
}