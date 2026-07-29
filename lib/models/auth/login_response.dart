class LoginResponse {
  final String? accessToken;
  final String? refreshToken;
  final bool requires2fa;
  final String? email;

  LoginResponse({
    this.accessToken,
    this.refreshToken,
    required this.requires2fa,
    this.email,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    String? email = json['email'] as String?;

    if (email == null && data != null) {
      final user = data['user'] as Map<String, dynamic>?;
      email = user?['email'] as String?;
    }

    return LoginResponse(
      accessToken: data?['access_token'] as String?,
      refreshToken: data?['refresh_token'] as String?,
      requires2fa: data?['requires_2fa'] ?? false,
      email: email,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'requires_2fa': requires2fa,
      'email': email,
    };
  }
}

