import 'package:flutter_test/flutter_test.dart';
import 'package:cicd_poc/login_logic.dart';

void main() {
  group('validateLogin() - pure unit tests', () {
    test('returns failure when username is empty', () {
      final result = validateLogin('', 'test123');

      expect(result.success, false);
      expect(result.message, 'Username and password required');
    });

    test('returns failure when password is empty', () {
      final result = validateLogin('Sandeep', '');

      expect(result.success, false);
      expect(result.message, 'Username and password required');
    });

    test('returns failure when both fields are empty', () {
      final result = validateLogin('', '');

      expect(result.success, false);
      expect(result.message, 'Username and password required');
    });

    test('returns failure when password is wrong', () {
      final result = validateLogin('Sandeep', 'wrongpass');

      expect(result.success, false);
      expect(result.message, 'Invalid credentials');
    });

    test('returns failure when username is wrong', () {
      final result = validateLogin('someone_else', 'test123');

      expect(result.success, false);
      expect(result.message, 'Invalid credentials');
    });

    test('returns success when credentials are correct', () {
      final result = validateLogin('Sandeep', 'test123');

      expect(result.success, true);
      expect(result.message, 'Login successful');
    });

    test('trims whitespace before checking empty fields', () {
      final result = validateLogin('   ', '   ');

      expect(result.success, false);
      expect(result.message, 'Username and password required');
    });
  });
}
