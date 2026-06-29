class AccountStatusModel {
  final String title;
  final String status;
  final String description;
  final String icon;
  final String badge;
  final String action;

  const AccountStatusModel({
    required this.title,
    required this.status,
    required this.description,
    required this.icon,
    required this.badge,
    required this.action,
  });

  factory AccountStatusModel.fromJson(Map<String, dynamic> json) {
    return AccountStatusModel(
      title: json['title'] ?? '',
      status: json['status'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] ?? '',
      badge: json['badge'] ?? '',
      action: json['action'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'status': status,
      'description': description,
      'icon': icon,
      'badge': badge,
      'action': action,
    };
  }

  static List<AccountStatusModel> fallback() {
    return const [
      AccountStatusModel(
        title: 'Validation de compte',
        status: 'Vérifié',
        description:
        'Votre compte est validé. Vous avez accès à tous les services de l’université.',
        icon: 'shield',
        badge: 'verified',
        action: '',
      ),
      AccountStatusModel(
        title: 'Ma demande d’inscription',
        status: 'En cours',
        description:
        'Votre demande est en cours de traitement.',
        icon: 'document',
        badge: 'pending',
        action: '',
      ),
    ];
  }
}