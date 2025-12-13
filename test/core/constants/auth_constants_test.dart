import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/core/constants/auth_constants.dart';

void main() {
  group('AuthConstants', () {
    test('has correct maxFailedAttempts value', () {
      expect(AuthConstants.maxFailedAttempts, 5);
    });

    test('has correct rateLimitDurationMinutes value', () {
      expect(AuthConstants.rateLimitDurationMinutes, 15);
    });

    test('maxFailedAttempts is positive', () {
      expect(AuthConstants.maxFailedAttempts, greaterThan(0));
    });

    test('rateLimitDurationMinutes is positive', () {
      expect(AuthConstants.rateLimitDurationMinutes, greaterThan(0));
    });
  });
}
