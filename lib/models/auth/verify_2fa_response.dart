import 'auth_response.dart';
import 'user.dart';

class Verify2FAResponse {
  final String accessToken;
  final String refreshToken;
  final User user;

  Verify2FAResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory Verify2FAResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return Verify2FAResponse(
      accessToken: (data['access_token'] ?? data['token']) as String,
      refreshToken: data['refresh_token'] as String,
      user: User.fromJson(data['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'user': user.toJson(),
    };
  }
}
