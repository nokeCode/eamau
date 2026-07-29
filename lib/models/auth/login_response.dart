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
    return LoginResponse(
      accessToken: json['data']?['access_token'] as String?,
      refreshToken: json['data']?['refresh_token'] as String?,
      requires2fa: json['data']?['requires_2fa'] ?? false,
      email: json['email'] as String?,
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

