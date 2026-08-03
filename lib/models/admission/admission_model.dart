class AdmissionModel {
  final int id;
  final String title;
  final String description;
  final DateTime? deadline;
  final String status;
  final String eligibility;
  final String image;
  final bool isOpen;

  const AdmissionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.deadline,
    required this.status,
    required this.eligibility,
    required this.image,
    required this.isOpen,
  });

  factory AdmissionModel.fromJson(Map<String, dynamic> json) {
    final status = (json['status'] ?? '').toString();
    return AdmissionModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      deadline: json['deadline'] != null && json['deadline'].toString().isNotEmpty
          ? DateTime.tryParse(json['deadline'])
          : null,
      status: status,
      eligibility: json['eligibility'] ??
          (status.toLowerCase() == 'published'
              ? 'Campagne ouverte'
              : 'Campagne fermée'),
      image: json['image'] ?? 'assets/images/admission1.png',
      isOpen: status.toLowerCase() == 'published',
    );
  }

  String get deadlineLabel {
    if (deadline == null) return 'Date limite inconnue';
    return '${deadline!.day.toString().padLeft(2, '0')}/${deadline!.month.toString().padLeft(2, '0')}/${deadline!.year}';
  }
}