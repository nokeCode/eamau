class QuickStatModel {
  final String title;
  final String subtitle;
  final int count;
  final String icon;
  final String color;

  const QuickStatModel({
    required this.title,
    required this.subtitle,
    required this.count,
    required this.icon,
    required this.color,
  });

  factory QuickStatModel.fromJson(Map<String, dynamic> json) {
    return QuickStatModel(
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      count: json['count'] ?? 0,
      icon: json['icon'] ?? '',
      color: json['color'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'count': count,
      'icon': icon,
      'color': color,
    };
  }
}