class DashboardNotificationModel {
  final String title;
  final String message;
  final String icon;
  final String time;
  final bool unread;

  const DashboardNotificationModel({
    required this.title,
    required this.message,
    required this.icon,
    required this.time,
    required this.unread,
  });

  factory DashboardNotificationModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return DashboardNotificationModel(
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      icon: json['icon'] ?? '',
      time: json['time'] ?? '',
      unread: json['unread'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'message': message,
      'icon': icon,
      'time': time,
      'unread': unread,
    };
  }
}