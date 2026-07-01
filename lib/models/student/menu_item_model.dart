class MenuItemModel {
  final String title;
  final String subtitle;
  final String icon;
  final String route;

  const MenuItemModel({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      icon: json['icon'] ?? '',
      route: json['route'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'icon': icon,
      'route': route,
    };
  }
}