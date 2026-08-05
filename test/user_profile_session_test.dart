import 'package:eamau/models/auth/user.dart';
import 'package:eamau/models/user/dashboard_user_model.dart';
import 'package:eamau/routes/app_routes.dart';
import 'package:eamau/services/auth/user_session_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('User.fromJson', () {
    test('reads backend profile field as the source of truth', () {
      final user = User.fromJson({
        'id': 7,
        'email': 'student@example.com',
        'first_name': 'Student',
        'last_name': 'Test',
        'profile': 'STUDENT',
      });

      expect(user.profile, 'STUDENT');
      expect(user.role, isNull);
    });

    test('keeps role fallback when profile is missing', () {
      final user = User.fromJson({
        'id': 8,
        'email': 'user@example.com',
        'first_name': 'User',
        'last_name': 'Test',
        'role': 'USER',
      });

      expect(user.profile, isNull);
      expect(user.role, 'USER');
    });

    test('resolves backend profile to the canonical app route from session state', () {
      final session = UserSessionService();

      session.updateSession(
        user: User(id: 1, email: 'user@example.com', profile: 'USER'),
        profile: 'USER',
      );
      expect(session.isUser, isTrue);
      expect(session.profileRouteName, AppRoutes.user);

      session.updateSession(
        user: User(
          id: 2,
          email: 'student@example.com',
          profile: 'STUDENT',
        ),
        profile: 'STUDENT',
      );
      expect(session.isStudent, isTrue);
      expect(session.profileRouteName, AppRoutes.student);
    });

    test('hydrates dashboard info from the connected auth user', () {
      final connectedUser = User(
        id: 99,
        uuid: 'uuid-1',
        email: 'connected@example.com',
        firstName: 'Marie',
        lastName: 'Dupont',
        phone: '+221700000000',
        avatar: 'https://example.com/avatar.png',
        role: 'USER',
        profile: 'USER',
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 2),
      );

      final dashboard = DashboardUserModel.fromConnectedUser(connectedUser);

      expect(dashboard.firstName, 'Marie');
      expect(dashboard.lastName, 'Dupont');
      expect(dashboard.avatar, 'https://example.com/avatar.png');
      expect(dashboard.profileCompletion.percentage, 100);
    });
  });
}
