import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/integrity_enforcement_level.dart';
import 'package:graviton/models/play_integrity_exception.dart';

void main() {
  group('PlayIntegrityException', () {
    test('toString includes message', () {
      final exception = PlayIntegrityException('Test error');
      expect(exception.toString(), contains('Test error'));
    });

    test('toString includes code when provided', () {
      final exception = PlayIntegrityException('Test error', code: 'TEST_CODE');
      expect(exception.toString(), contains('TEST_CODE'));
      expect(exception.toString(), contains('Test error'));
    });

    test('includes details', () {
      final exception = PlayIntegrityException(
        'Test error',
        details: {'key': 'value'},
      );
      expect(exception.details, equals({'key': 'value'}));
    });
  });

  group('IntegrityVerificationFailedException', () {
    test('toString includes enforcement level', () {
      final exception = IntegrityVerificationFailedException(
        message: 'Verification failed',
        enforcementLevel: IntegrityEnforcementLevel.blockAll,
        operationId: 'test_operation',
      );
      expect(exception.toString(), contains('block_all'));
    });

    test('toString includes operation ID', () {
      final exception = IntegrityVerificationFailedException(
        message: 'Verification failed',
        enforcementLevel: IntegrityEnforcementLevel.blockHighRisk,
        operationId: 'auth_sign_in',
      );
      expect(exception.toString(), contains('auth_sign_in'));
    });

    test('includes all properties', () {
      final exception = IntegrityVerificationFailedException(
        message: 'Test failure',
        enforcementLevel: IntegrityEnforcementLevel.warnUser,
        operationId: 'test_op',
        code: 'FAIL_CODE',
        details: 'Extra details',
      );
      expect(exception.message, equals('Test failure'));
      expect(
        exception.enforcementLevel,
        equals(IntegrityEnforcementLevel.warnUser),
      );
      expect(exception.operationId, equals('test_op'));
      expect(exception.code, equals('FAIL_CODE'));
      expect(exception.details, equals('Extra details'));
    });
  });

  group('IntegrityNotAvailableException', () {
    test('has default message', () {
      final exception = IntegrityNotAvailableException();
      expect(
        exception.message,
        equals('Play Integrity API is not available on this platform'),
      );
    });

    test('can override message', () {
      final exception = IntegrityNotAvailableException(
        message: 'Custom unavailable message',
      );
      expect(exception.message, equals('Custom unavailable message'));
    });

    test('includes code and details', () {
      final exception = IntegrityNotAvailableException(
        code: 'NOT_AVAILABLE',
        details: 'iOS platform',
      );
      expect(exception.code, equals('NOT_AVAILABLE'));
      expect(exception.details, equals('iOS platform'));
    });
  });

  group('IntegrityTokenRequestException', () {
    test('includes message', () {
      final exception = IntegrityTokenRequestException(
        message: 'Token request failed',
      );
      expect(exception.message, equals('Token request failed'));
    });

    test('includes code and details', () {
      final exception = IntegrityTokenRequestException(
        message: 'Request error',
        code: 'NETWORK_ERROR',
        details: 'Connection timeout',
      );
      expect(exception.code, equals('NETWORK_ERROR'));
      expect(exception.details, equals('Connection timeout'));
    });
  });
}
