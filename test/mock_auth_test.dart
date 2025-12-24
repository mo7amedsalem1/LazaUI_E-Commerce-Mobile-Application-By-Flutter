import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:laza/services/mock_auth_service.dart';

void main() {
  group('MockAuthService Tests', () {
    late MockAuthService authService;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      authService = MockAuthService();
    });

    test('Initial user should be null', () {
      expect(authService.currentUser, isNull);
    });

    test('SignUp should create a new user and persist it', () async {
      const email = 'test@example.com';
      const password = 'password123';

      final user = await authService.signUp(email, password);

      expect(user, isNotNull);
      expect(user?.email, email);
      expect(authService.currentUser?.email, email);
    });

    test('SignUp should throw error if user already exists', () async {
      const email = 'test@example.com';
      const password = 'password123';

      await authService.signUp(email, password);

      expect(
        () => authService.signUp(email, password),
        throwsA(isA<Exception>()),
      );
    });

    test('SignIn should work for existing user', () async {
      const email = 'test@example.com';
      const password = 'password123';

      await authService.signUp(email, password);
      
      // Sign out current session to test fresh login
      await authService.signOut();
      expect(authService.currentUser, isNull);

      final loggedInUser = await authService.signIn(email, password);

      expect(loggedInUser, isNotNull);
      expect(loggedInUser?.email, email);
      expect(authService.currentUser?.email, email);
    });

    test('SignIn should fail with wrong password', () async {
      const email = 'test@example.com';
      const password = 'password123';

      await authService.signUp(email, password);

      expect(
        () => authService.signIn(email, 'wrongpassword'),
        throwsA(isA<Exception>()),
      );
    });

    test('SignIn should fail for non-existent user', () async {
      expect(
        () => authService.signIn('nonexistent@example.com', 'password123'),
        throwsA(isA<Exception>()),
      );
    });
  });
}
