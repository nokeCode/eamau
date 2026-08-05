import 'api_config.dart';

class ApiEndpoints {
  static const String baseUrl = ApiConfig.fullBaseUrl;

  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refresh = '/auth/refresh';
  static const String me = '/auth/me';
  static const String verify2fa = '/auth/2fa/check';
  static const String resend2fa = '/auth/2fa/resend';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String googleAuth = '/auth/google';
  static const String googleCallback = '/auth/google/callback';

  // Notification endpoints
  static const String notifications = '/notifications';
  static const String notificationsPreferences = '/notifications/preferences';
  static const String devicesRegister = '/devices/register';

  // Profile endpoints
  static const String profile = '/profile';
  static const String profilePhoto = '/profile/photo';
  static const String profilePassword = '/profile/password';
  static const String profileAcademic = '/profile/academic';
  static const String profileValidation = '/profile/validation';
  static const String requestVerification = '/profile/request-verification';
}
