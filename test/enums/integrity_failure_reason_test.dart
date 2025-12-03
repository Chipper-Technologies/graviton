import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/integrity_failure_reason.dart';

void main() {
  group('IntegrityFailureReason', () {
    test('displayName returns correct values', () {
      expect(
        IntegrityFailureReason.deviceIntegrity.displayName,
        equals('device_integrity'),
      );
      expect(
        IntegrityFailureReason.appIntegrity.displayName,
        equals('app_integrity'),
      );
      expect(
        IntegrityFailureReason.networkError.displayName,
        equals('network_error'),
      );
      expect(
        IntegrityFailureReason.backendVerificationFailed.displayName,
        equals('backend_verification_failed'),
      );
      expect(
        IntegrityFailureReason.tokenRequestFailed.displayName,
        equals('token_request_failed'),
      );
      expect(IntegrityFailureReason.unknown.displayName, equals('unknown'));
    });

    test('localizationKey returns correct keys', () {
      expect(
        IntegrityFailureReason.deviceIntegrity.localizationKey,
        equals('integrityErrorDeviceIntegrity'),
      );
      expect(
        IntegrityFailureReason.appIntegrity.localizationKey,
        equals('integrityErrorAppIntegrity'),
      );
      expect(
        IntegrityFailureReason.networkError.localizationKey,
        equals('integrityErrorNetwork'),
      );
      expect(
        IntegrityFailureReason.backendVerificationFailed.localizationKey,
        equals('integrityErrorBackendVerification'),
      );
      expect(
        IntegrityFailureReason.tokenRequestFailed.localizationKey,
        equals('integrityErrorTokenRequest'),
      );
      expect(
        IntegrityFailureReason.unknown.localizationKey,
        equals('integrityErrorUnknown'),
      );
    });

    test('titleKey returns correct keys', () {
      expect(
        IntegrityFailureReason.deviceIntegrity.titleKey,
        equals('integrityErrorDeviceIntegrityTitle'),
      );
      expect(
        IntegrityFailureReason.appIntegrity.titleKey,
        equals('integrityErrorAppIntegrityTitle'),
      );
      expect(
        IntegrityFailureReason.networkError.titleKey,
        equals('integrityErrorNetworkTitle'),
      );
      expect(
        IntegrityFailureReason.backendVerificationFailed.titleKey,
        equals('integrityErrorBackendVerificationTitle'),
      );
      expect(
        IntegrityFailureReason.tokenRequestFailed.titleKey,
        equals('integrityErrorTokenRequestTitle'),
      );
      expect(
        IntegrityFailureReason.unknown.titleKey,
        equals('integrityErrorUnknownTitle'),
      );
    });

    test('guidanceKey returns correct keys', () {
      expect(
        IntegrityFailureReason.deviceIntegrity.guidanceKey,
        equals('integrityGuidanceDeviceIntegrity'),
      );
      expect(
        IntegrityFailureReason.appIntegrity.guidanceKey,
        equals('integrityGuidanceAppIntegrity'),
      );
      expect(
        IntegrityFailureReason.networkError.guidanceKey,
        equals('integrityGuidanceNetwork'),
      );
      expect(
        IntegrityFailureReason.backendVerificationFailed.guidanceKey,
        equals('integrityGuidanceBackendVerification'),
      );
      expect(
        IntegrityFailureReason.tokenRequestFailed.guidanceKey,
        equals('integrityGuidanceTokenRequest'),
      );
      expect(
        IntegrityFailureReason.unknown.guidanceKey,
        equals('integrityGuidanceUnknown'),
      );
    });

    test('all enum values are distinct', () {
      final allValues = IntegrityFailureReason.values;
      expect(allValues.length, equals(6));
      expect(allValues.toSet().length, equals(6));
    });

    test('displayName has no duplicates', () {
      final displayNames = IntegrityFailureReason.values
          .map((e) => e.displayName)
          .toSet();
      expect(displayNames.length, equals(IntegrityFailureReason.values.length));
    });

    test('localizationKey has no duplicates', () {
      final localizationKeys = IntegrityFailureReason.values
          .map((e) => e.localizationKey)
          .toSet();
      expect(
        localizationKeys.length,
        equals(IntegrityFailureReason.values.length),
      );
    });

    test('titleKey has no duplicates', () {
      final titleKeys = IntegrityFailureReason.values
          .map((e) => e.titleKey)
          .toSet();
      expect(titleKeys.length, equals(IntegrityFailureReason.values.length));
    });

    test('guidanceKey has no duplicates', () {
      final guidanceKeys = IntegrityFailureReason.values
          .map((e) => e.guidanceKey)
          .toSet();
      expect(guidanceKeys.length, equals(IntegrityFailureReason.values.length));
    });

    test('all keys follow naming convention', () {
      for (final reason in IntegrityFailureReason.values) {
        // localizationKey should start with 'integrityError'
        expect(reason.localizationKey, startsWith('integrityError'));

        // titleKey should end with 'Title'
        expect(reason.titleKey, endsWith('Title'));
        expect(reason.titleKey, startsWith('integrityError'));

        // guidanceKey should start with 'integrityGuidance'
        expect(reason.guidanceKey, startsWith('integrityGuidance'));

        // displayName should use snake_case (lowercase with underscores)
        expect(
          reason.displayName,
          matches(RegExp(r'^[a-z][a-z0-9_]*$')),
          reason: 'displayName should be snake_case',
        );
      }
    });

    group('fromError', () {
      test('detects network errors', () {
        expect(
          IntegrityFailureReasonExtension.fromError(null, 'network timeout'),
          equals(IntegrityFailureReason.networkError),
        );
        expect(
          IntegrityFailureReasonExtension.fromError(
            'NETWORK_ERROR',
            'connection failed',
          ),
          equals(IntegrityFailureReason.networkError),
        );
        expect(
          IntegrityFailureReasonExtension.fromError(null, 'timeout error'),
          equals(IntegrityFailureReason.networkError),
        );
      });

      test('detects token request failures', () {
        expect(
          IntegrityFailureReasonExtension.fromError(
            null,
            'failed to request token',
          ),
          equals(IntegrityFailureReason.tokenRequestFailed),
        );
        expect(
          IntegrityFailureReasonExtension.fromError(
            'TOKEN_REQUEST_ERROR',
            null,
          ),
          equals(IntegrityFailureReason.tokenRequestFailed),
        );
      });

      test('detects backend verification failures', () {
        expect(
          IntegrityFailureReasonExtension.fromError(
            null,
            'backend verification failed',
          ),
          equals(IntegrityFailureReason.backendVerificationFailed),
        );
        expect(
          IntegrityFailureReasonExtension.fromError(null, 'invalid token'),
          equals(IntegrityFailureReason.backendVerificationFailed),
        );
        expect(
          IntegrityFailureReasonExtension.fromError(null, 'verification error'),
          equals(IntegrityFailureReason.backendVerificationFailed),
        );
      });

      test('detects device integrity issues', () {
        expect(
          IntegrityFailureReasonExtension.fromError(null, 'device not trusted'),
          equals(IntegrityFailureReason.deviceIntegrity),
        );
        expect(
          IntegrityFailureReasonExtension.fromError(null, 'rooted device'),
          equals(IntegrityFailureReason.deviceIntegrity),
        );
        expect(
          IntegrityFailureReasonExtension.fromError(
            null,
            'play protect failed',
          ),
          equals(IntegrityFailureReason.deviceIntegrity),
        );
      });

      test('detects app integrity issues', () {
        expect(
          IntegrityFailureReasonExtension.fromError(null, 'app modified'),
          equals(IntegrityFailureReason.appIntegrity),
        );
        expect(
          IntegrityFailureReasonExtension.fromError(null, 'sideloaded app'),
          equals(IntegrityFailureReason.appIntegrity),
        );
        expect(
          IntegrityFailureReasonExtension.fromError(
            null,
            'not from google play',
          ),
          equals(IntegrityFailureReason.appIntegrity),
        );
      });

      test('defaults to unknown for unrecognized errors', () {
        expect(
          IntegrityFailureReasonExtension.fromError(null, 'some random error'),
          equals(IntegrityFailureReason.unknown),
        );
        expect(
          IntegrityFailureReasonExtension.fromError(null, null),
          equals(IntegrityFailureReason.unknown),
        );
      });

      test('is case insensitive', () {
        expect(
          IntegrityFailureReasonExtension.fromError(null, 'NETWORK ERROR'),
          equals(IntegrityFailureReason.networkError),
        );
        expect(
          IntegrityFailureReasonExtension.fromError(null, 'Device Modified'),
          equals(IntegrityFailureReason.deviceIntegrity),
        );
      });

      test('handles combined code and message', () {
        expect(
          IntegrityFailureReasonExtension.fromError(
            'NETWORK_ERROR',
            'connection timeout',
          ),
          equals(IntegrityFailureReason.networkError),
        );
      });

      test('handles empty strings', () {
        expect(
          IntegrityFailureReasonExtension.fromError('', ''),
          equals(IntegrityFailureReason.unknown),
        );
      });

      test('handles whitespace only', () {
        expect(
          IntegrityFailureReasonExtension.fromError('  ', '  '),
          equals(IntegrityFailureReason.unknown),
        );
      });

      test('prioritizes network errors in combined messages', () {
        // Network keywords should be detected even if other keywords present
        expect(
          IntegrityFailureReasonExtension.fromError(
            null,
            'network connection failed for token request',
          ),
          equals(IntegrityFailureReason.networkError),
        );
      });

      test('prioritizes token request over backend verification', () {
        // When both "token" and "request" are present, should detect token request
        expect(
          IntegrityFailureReasonExtension.fromError(
            null,
            'token request failed during verification',
          ),
          equals(IntegrityFailureReason.tokenRequestFailed),
        );
      });

      test(
        'detects backend verification without explicit "backend" keyword',
        () {
          expect(
            IntegrityFailureReasonExtension.fromError(
              null,
              'verification failed',
            ),
            equals(IntegrityFailureReason.backendVerificationFailed),
          );
        },
      );

      test('handles various connection error keywords', () {
        expect(
          IntegrityFailureReasonExtension.fromError(null, 'connection refused'),
          equals(IntegrityFailureReason.networkError),
        );
        expect(
          IntegrityFailureReasonExtension.fromError(null, 'connection lost'),
          equals(IntegrityFailureReason.networkError),
        );
        expect(
          IntegrityFailureReasonExtension.fromError(
            null,
            'no network available',
          ),
          equals(IntegrityFailureReason.networkError),
        );
      });

      test('handles various device integrity keywords', () {
        expect(
          IntegrityFailureReasonExtension.fromError(null, 'device rooted'),
          equals(IntegrityFailureReason.deviceIntegrity),
        );
        expect(
          IntegrityFailureReasonExtension.fromError(null, 'device not trusted'),
          equals(IntegrityFailureReason.deviceIntegrity),
        );
        expect(
          IntegrityFailureReasonExtension.fromError(
            null,
            'play protect check failed',
          ),
          equals(IntegrityFailureReason.deviceIntegrity),
        );
      });

      test('handles various app integrity keywords', () {
        expect(
          IntegrityFailureReasonExtension.fromError(null, 'app not verified'),
          equals(IntegrityFailureReason.appIntegrity),
        );
        expect(
          IntegrityFailureReasonExtension.fromError(null, 'modified app'),
          equals(IntegrityFailureReason.appIntegrity),
        );
        expect(
          IntegrityFailureReasonExtension.fromError(null, 'app sideloaded'),
          equals(IntegrityFailureReason.appIntegrity),
        );
        expect(
          IntegrityFailureReasonExtension.fromError(
            null,
            'not from google play store',
          ),
          equals(IntegrityFailureReason.appIntegrity),
        );
      });

      test('code takes precedence over message', () {
        // The combined string uses both code and message
        expect(
          IntegrityFailureReasonExtension.fromError('network', 'app error'),
          equals(IntegrityFailureReason.networkError),
        );
      });

      test('handles partial keyword matches', () {
        expect(
          IntegrityFailureReasonExtension.fromError(null, 'networking issue'),
          equals(IntegrityFailureReason.networkError),
        );
        expect(
          IntegrityFailureReasonExtension.fromError(null, 'apps integrity'),
          equals(IntegrityFailureReason.appIntegrity),
        );
      });

      test('real-world error message examples', () {
        // Simulate real error messages from Play Integrity API
        expect(
          IntegrityFailureReasonExtension.fromError(
            'NETWORK_ERROR',
            'Unable to connect to integrity service',
          ),
          equals(IntegrityFailureReason.networkError),
        );

        expect(
          IntegrityFailureReasonExtension.fromError(
            'INTEGRITY_ERROR',
            'Device does not meet basic integrity',
          ),
          equals(IntegrityFailureReason.deviceIntegrity),
        );

        expect(
          IntegrityFailureReasonExtension.fromError(
            'APP_NOT_RECOGNIZED',
            'App not recognized or modified',
          ),
          equals(IntegrityFailureReason.appIntegrity),
        );

        expect(
          IntegrityFailureReasonExtension.fromError(
            'TOKEN_INVALID',
            'Backend token verification failed',
          ),
          equals(IntegrityFailureReason.backendVerificationFailed),
        );

        expect(
          IntegrityFailureReasonExtension.fromError(
            'REQUEST_FAILED',
            'Failed to request integrity token',
          ),
          equals(IntegrityFailureReason.tokenRequestFailed),
        );
      });
    });
  });
}
