import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:graviton/features/auth/data/auth_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthService Email Verification', () {
    late AuthService authService;

    setUp(() {
      authService = AuthService.instance;

      // Reset SharedPreferences for each test
      SharedPreferences.setMockInitialValues({});
    });

    group('sendEmailVerification', () {
      test('throws exception when no user logged in', () async {
        // Act & Assert
        expect(() => authService.sendEmailVerification(), throwsException);
      });

      test(
        'method exists and can be called (integration test would verify full behavior)',
        () async {
          // This test validates the method signature exists
          // Full testing would require Firebase emulator or actual auth state
          expect(() => authService.sendEmailVerification(), throwsException);
        },
      );
    });

    group('checkEmailVerified', () {
      test('returns false when no user is logged in', () async {
        // Act
        final result = await authService.checkEmailVerified();

        // Assert
        expect(result, isFalse);
      });

      test(
        'method exists and returns bool (integration test would verify full behavior)',
        () async {
          // This test validates the method signature and return type
          final result = await authService.checkEmailVerified();
          expect(result, isA<bool>());
        },
      );
    });

    group('isEmailVerified getter', () {
      test('returns false when no user is logged in', () {
        // Act
        final result = authService.isEmailVerified;

        // Assert
        expect(result, isFalse);
      });

      test('getter exists and returns bool', () {
        final result = authService.isEmailVerified;
        expect(result, isA<bool>());
      });
    });
  });
}
