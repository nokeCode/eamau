import 'package:eamau/models/auth/user.dart';
import 'package:eamau/routes/app_routes.dart';

class UserSessionService {
  User? currentUser;
  String? currentProfile;

  bool get isStudent => _normalizedProfile(currentProfile) == 'STUDENT';
  bool get isUser => _normalizedProfile(currentProfile) == 'USER';
  String? get profileRouteName {
    if (isStudent) return AppRoutes.student;
    if (isUser) return AppRoutes.user;
    return null;
  }

  void updateSession({User? user, String? profile}) {
    currentUser = user;
    currentProfile = _normalizedProfile(profile ?? user?.profile);
  }

  void clearSession() {
    currentUser = null;
    currentProfile = null;
  }

  String? _normalizedProfile(String? rawProfile) {
    if (rawProfile == null) return null;
    final normalized = rawProfile.trim().toUpperCase();
    if (normalized == 'USER' || normalized == 'STUDENT') {
      return normalized;
    }
    return null;
  }
}
