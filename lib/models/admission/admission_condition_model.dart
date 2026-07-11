class AdmissionConditionModel {
  final int id;
  final String title;
  final String subtitle;
  final String icon;
  final List<String> items;
  final bool expanded;

  const AdmissionConditionModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.items,
    this.expanded = false,
  });

  factory AdmissionConditionModel.fromJson(
      Map<String, dynamic> json) {
    return AdmissionConditionModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      icon: json['icon'] ?? '',
      items: List<String>.from(json['items'] ?? []),
      expanded: json['expanded'] ?? false,
    );
  }
}