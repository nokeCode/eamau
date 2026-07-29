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
    return Verify2FAResponse(
      accessToken: json['data']['access_token'] as String,
      refreshToken: json['data']['refresh_token'] as String,
      user: User.fromJson(json['data']['user'] as Map<String, dynamic>),
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

