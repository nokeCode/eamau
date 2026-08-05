class User {
  static const int _totalProfileFieldCount = 11;

  final int id;
  final String? uuid;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? avatar;
  final String? role;
  final String? profile;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    required this.id,
    this.uuid,
    required this.email,
    this.firstName,
    this.lastName,
    this.phone,
    this.avatar,
    this.role,
    this.profile,
    this.createdAt,
    this.updatedAt,
  });

  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();

  int get completedProfileFieldCount {
    int count = 0;

    if (id != 0) count++;
    if (uuid != null && uuid!.trim().isNotEmpty) count++;
    if (email.trim().isNotEmpty) count++;
    if (firstName != null && firstName!.trim().isNotEmpty) count++;
    if (lastName != null && lastName!.trim().isNotEmpty) count++;
    if (phone != null && phone!.trim().isNotEmpty) count++;
    if (avatar != null && avatar!.trim().isNotEmpty) count++;
    if (role != null && role!.trim().isNotEmpty) count++;
    if (profile != null && profile!.trim().isNotEmpty) count++;
    if (createdAt != null) count++;
    if (updatedAt != null) count++;

    return count;
  }

  double get profileCompletionRatio =>
      completedProfileFieldCount / _totalProfileFieldCount;

  int get profileCompletionPercentage =>
      (profileCompletionRatio * 100).round();

  factory User.fromJson(Map<String, dynamic> json) {
    // Some backends return a `role` string and others return `roles` array
    String? parsedRole;
    if (json['role'] != null) {
      parsedRole = json['role'] is String ? (json['role'] as String) : json['role'].toString();
    } else if (json['roles'] is List && (json['roles'] as List).isNotEmpty) {
      final roleList = json['roles'] as List;
      String? firstRole;
      for (final item in roleList) {
        if (item is String) {
          firstRole = item;
          break;
        }
        if (item is Map<String, dynamic>) {
          final name = item['name'] as String?;
          if (name != null && name.isNotEmpty) {
            firstRole = name;
            break;
          }
        }
      }
      parsedRole = firstRole ?? roleList.first.toString();
    } else {
      parsedRole = null;
    }

    final rawUuid = json['uuid'] ?? json['user_uuid'] ?? json['id'];
    final parsedProfile = json['profile'] is String
        ? (json['profile'] as String).trim().toUpperCase()
        : null;

    return User(
      id: json['id'] as int,
      uuid: rawUuid?.toString(),
      email: json['email'] as String,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      phone: json['phone'] as String?,
      avatar: json['avatar'] as String?,
      role: parsedRole,
      profile: parsedProfile,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'avatar': avatar,
      'role': role,
      'profile': profile,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

