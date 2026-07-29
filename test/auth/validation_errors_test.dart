import 'package:flutter_test/flutter_test.dart';
import 'package:eamau/providers/auth_provider.dart';

void main() {
  group('AuthProvider validation error formatting', () {
    test('formats backend validation errors into a readable message', () {
      final errors = {
        'password': ['Le mot de passe doit contenir au moins 8 caractères'],
        'email': ['Cet email est déjà utilisé'],
      };

      final message = AuthProvider.formatValidationErrors(errors);

      expect(
        message,
        contains(
          'password: Le mot de passe doit contenir au moins 8 caractères',
        ),
      );
      expect(message, contains('email: Cet email est déjà utilisé'));
    });
  });
}
