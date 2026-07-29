class ApiEndpoints {
  static const String baseUrl = 'http://localhost:9090/api/v1';

  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refresh = '/auth/refresh';
  static const String me = '/auth/me';
  static const String verify2fa = '/auth/2fa/check';
  static const String resend2fa = '/auth/2fa/resend';
  static const String googleAuth = '/auth/google';
  static const String googleCallback = '/auth/google/callback';
}
