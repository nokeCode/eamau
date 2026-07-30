import 'package:eamau/core/api/api_client.dart';
import 'package:eamau/providers/auth_provider.dart';
import 'package:eamau/services/auth/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeAuthService extends AuthService {
  final Future<void> Function({required String email})?
  requestPasswordResetHandler;
  final Future<void> Function({
    required String token,
    required String password,
  })?
  resetPasswordHandler;

  FakeAuthService({
    this.requestPasswordResetHandler,
    this.resetPasswordHandler,
  });

  @override
  Future<void> requestPasswordReset({required String email}) async {
    if (requestPasswordResetHandler != null) {
      await requestPasswordResetHandler!(email: email);
      return;
    }
    return super.requestPasswordReset(email: email);
  }

  @override
  Future<void> resetPassword({
    required String token,
    required String password,
  }) async {
    if (resetPasswordHandler != null) {
      await resetPasswordHandler!(token: token, password: password);
      return;
    }
    return super.resetPassword(token: token, password: password);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthProvider password reset flow', () {
    test('surfaces validation errors from forgot password requests', () async {
      final fakeService = FakeAuthService(
        requestPasswordResetHandler: ({required String email}) async {
          throw ValidationException(
            message: 'Email invalide',
            errors: {
              'email': ['Cet email n\'existe pas'],
            },
          );
        },
      );

      final provider = AuthProvider(
        authService: fakeService,
        checkLoginStatus: false,
      );

      final success = await provider.requestPasswordReset(
        email: 'bad@example.com',
      );

      expect(success, isFalse);
      expect(provider.error, contains('email:'));
    });

    test('returns true when password reset succeeds', () async {
      final fakeService = FakeAuthService(
        resetPasswordHandler:
            ({required String token, required String password}) async {},
      );

      final provider = AuthProvider(
        authService: fakeService,
        checkLoginStatus: false,
      );

      final success = await provider.resetPassword(
        token: 'abc123',
        password: 'NewPassword123',
      );

      expect(success, isTrue);
      expect(provider.error, isNull);
    });
  });
}
