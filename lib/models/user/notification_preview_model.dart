class NotificationPreviewModel {
  final String title;
  final String subtitle;
  final String icon;
  final bool unread;

  const NotificationPreviewModel({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.unread,
  });

  factory NotificationPreviewModel.fromJson(Map<String, dynamic> json) {
    return NotificationPreviewModel(
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      icon: json['icon'] ?? '',
      unread: json['unread'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'icon': icon,
      'unread': unread,
    };
  }

  static List<NotificationPreviewModel> fallback() {
    return const [
      NotificationPreviewModel(
        title: 'Votre dossier est en cours d’examen.',
        subtitle: 'il y a 2 heures',
        icon: 'school',
        unread: true,
      ),
      NotificationPreviewModel(
        title: 'Rentrée Universitaire 2026-2027.',
        subtitle: 'il y a 1 jour',
        icon: 'description',
        unread: true,
      ),
      NotificationPreviewModel(
        title: 'Votre dossier est en cours d’examen.',
        subtitle: 'il y a 2 jours',
        icon: 'calendar',
        unread: true,
      ),
    ];
  }
}