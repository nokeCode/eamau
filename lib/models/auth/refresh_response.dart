class RefreshResponse {
  final String accessToken;
  final String refreshToken;

  RefreshResponse({required this.accessToken, required this.refreshToken});

  factory RefreshResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return RefreshResponse(
      accessToken: (data['access_token'] ?? data['token']) as String,
      refreshToken: data['refresh_token'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'access_token': accessToken, 'refresh_token': refreshToken};
  }
}
