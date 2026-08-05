class NotificationModel {
  final int id;
  final String title;
  final String message;
  final String icon;
  final bool isRead;
  final DateTime createdAt;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.icon,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final title = (json['title'] ?? '').toString();
    final message = (json['body'] ?? json['message'] ?? '').toString();
    final createdAtRaw = json['createdAt'] ?? json['created_at'] ?? json['sentAt'];
    final readAtRaw = json['readAt'];
    final type = (json['type'] ?? json['icon'] ?? 'notification').toString();
    final status = (json['status'] ?? '').toString().toUpperCase();

    return NotificationModel(
      id: json['id'] ?? 0,
      title: title,
      message: message,
      icon: _normalizeIcon(type),
      isRead: readAtRaw != null || status == 'READ',
      createdAt: DateTime.tryParse(createdAtRaw?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  static String _normalizeIcon(String value) {
    final normalized = value.trim().toLowerCase();

    switch (normalized) {
      case 'publication':
      case 'publications':
        return 'document';
      case 'admission':
      case 'concours':
        return 'calendar';
      case 'system':
      case 'notification':
        return 'info';
      case 'marketing':
        return 'community';
      default:
        return normalized.isEmpty ? 'notification' : normalized;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'icon': icon,
      'isRead': isRead,
      'created_at': createdAt.toIso8601String(),
    };
  }

  NotificationModel copyWith({
    int? id,
    String? title,
    String? message,
    String? icon,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      icon: icon ?? this.icon,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

final List<NotificationModel> fallbackNotifications = [
  NotificationModel(
    id: 1,
    title: 'Nouveau résultat disponible',
    message:
    'Vos résultats du semestre Spring 2024 sont maintenant disponibles.',
    icon: 'graduation',
    isRead: false,
    createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
  ),
  NotificationModel(
    id: 2,
    title: 'Nouveau résultat disponible',
    message:
    'Vos résultats du semestre Spring 2024 sont maintenant disponibles.',
    icon: 'document',
    isRead: false,
    createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
  ),
  NotificationModel(
    id: 3,
    title: 'Nouveau résultat disponible',
    message:
    'Vos résultats du semestre Spring 2024 sont maintenant disponibles.',
    icon: 'calendar',
    isRead: false,
    createdAt: DateTime.now().subtract(const Duration(hours: 1)),
  ),
  NotificationModel(
    id: 4,
    title: 'Nouveau résultat disponible',
    message:
    'Vos résultats du semestre Spring 2024 sont maintenant disponibles.',
    icon: 'info',
    isRead: false,
    createdAt: DateTime.now().subtract(const Duration(hours: 2)),
  ),
  NotificationModel(
    id: 5,
    title: 'Nouveau résultat disponible',
    message:
    'Vos résultats du semestre Spring 2024 sont maintenant disponibles.',
    icon: 'community',
    isRead: true,
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
  ),
  NotificationModel(
    id: 6,
    title: 'Nouveau résultat disponible',
    message:
    'Vos résultats du semestre Spring 2024 sont maintenant disponibles.',
    icon: 'file',
    isRead: true,
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
  ),
];