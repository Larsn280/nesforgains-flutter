import 'package:flutter_test/flutter_test.dart';
import 'package:nes_for_gains/service/auth_service.dart';

void main() {
  group('AuthState Tests', () {
    test('Login sets isLoggedIn to true', () {
      final authState = AuthState();
      authState.login(1, 'test_user');
      expect(authState.isLoggedIn, true);
    });

    test('Logout sets isLoggedIn to false', () {
      final authState = AuthState();
      authState.login(1, 'test_user');
      authState.logout();
      expect(authState.isLoggedIn, false);
    });

    test('CheckLoginStatus returns correct status', () {
      final authState = AuthState();
      expect(authState.checkLoginStatus(), false);

      authState.login(1, 'test_user');
      expect(authState.checkLoginStatus(), true);

      authState.logout();
      expect(authState.checkLoginStatus(), false);
    });
  });
}
