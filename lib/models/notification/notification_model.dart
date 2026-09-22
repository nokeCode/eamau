class NotificationModel {
  final int id;
  final String title;
  final String message;
  final String icon;
  final bool isRead;
  final DateTime createdAt;

  /// Raw type/route/entity fields, kept around (unlike before, where only
  /// `type` survived parsing and only to compute `icon`) so tapping a
  /// notification in the list can be routed the same way a tapped push
  /// notification already is — see `navigateToNotificationTarget`. Field
  /// names are read defensively, mirroring what the FCM `data` payload
  /// parsing in main.dart already tries, since there's no confirmed sample
  /// of this REST endpoint's exact per-item shape for these fields.
  final String type;
  final String entityId;
  final String route;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.icon,
    required this.isRead,
    required this.createdAt,
    this.type = '',
    this.entityId = '',
    this.route = '',
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final title = (json['title'] ?? '').toString();
    final message = (json['body'] ?? json['message'] ?? '').toString();
    final createdAtRaw = json['createdAt'] ?? json['created_at'] ?? json['sentAt'];
    final readAtRaw = json['readAt'];
    final type = (json['type'] ?? json['icon'] ?? 'notification').toString();
    final status = (json['status'] ?? '').toString().toUpperCase();
    final entityId = (json['entityId'] ??
            json['entity_id'] ??
            json['resourceId'] ??
            json['resource_id'] ??
            json['slug'] ??
            '')
        .toString();
    final route = (json['route'] ?? json['deepLink'] ?? json['deeplink'] ?? '').toString();

    return NotificationModel(
      id: json['id'] ?? 0,
      title: title,
      message: message,
      icon: _normalizeIcon(type),
      isRead: readAtRaw != null || status == 'READ',
      createdAt: DateTime.tryParse(createdAtRaw?.toString() ?? '') ??
          DateTime.now(),
      type: type,
      entityId: entityId,
      route: route,
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
      'type': type,
      'entityId': entityId,
      'route': route,
    };
  }

  NotificationModel copyWith({
    int? id,
    String? title,
    String? message,
    String? icon,
    bool? isRead,
    DateTime? createdAt,
    String? type,
    String? entityId,
    String? route,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      icon: icon ?? this.icon,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
      entityId: entityId ?? this.entityId,
      route: route ?? this.route,
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