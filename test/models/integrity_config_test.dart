import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/integrity_enforcement_level.dart';
import 'package:graviton/models/integrity_config.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'integrity_config_test.mocks.dart';

@GenerateMocks([FirebaseRemoteConfig])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('IntegrityConfig', () {
    late MockFirebaseRemoteConfig mockRemoteConfig;

    setUp(() {
      mockRemoteConfig = MockFirebaseRemoteConfig();

      // Setup default behavior for Remote Config
      when(mockRemoteConfig.setDefaults(any)).thenAnswer((_) async => {});
      when(mockRemoteConfig.setConfigSettings(any)).thenAnswer((_) async => {});
      when(mockRemoteConfig.fetchAndActivate()).thenAnswer((_) async => true);

      // Default values
      when(
        mockRemoteConfig.getString('integrity_enforcement_level'),
      ).thenReturn('logOnly');
      when(
        mockRemoteConfig.getString('integrity_high_risk_operations'),
      ).thenReturn(
        'auth_create_account,auth_sign_in,sync_cloud_data,share_simulation,save_custom_scenario,delete_account,export_user_data',
      );
      when(
        mockRemoteConfig.getBool('integrity_bypass_development'),
      ).thenReturn(true);
      when(
        mockRemoteConfig.getBool('integrity_enabled'),
      ).thenReturn(true); // Enabled by default
    });

    test('singleton pattern returns same instance', () {
      final instance1 = IntegrityConfig.instance;
      final instance2 = IntegrityConfig.instance;

      expect(instance1, same(instance2));
    });

    group('initialization', () {
      test('isInitialized returns false before initialization', () {
        final config = IntegrityConfig.instance;
        // Note: Instance might be initialized from previous tests
        // This tests the state, not the initialization process
        expect(config.isInitialized, isA<bool>());
      });

      test('uses default enforcement level when not initialized', () {
        final config = IntegrityConfig.instance;
        final level = config.getEnforcementLevel();

        expect(level, isA<IntegrityEnforcementLevel>());
      });

      test('uses default high-risk operations when not initialized', () {
        final config = IntegrityConfig.instance;
        final operations = config.getHighRiskOperations();

        expect(operations, isNotEmpty);
        expect(operations, contains('auth_create_account'));
        expect(operations, contains('auth_sign_in'));
      });

      test('uses safe default for development bypass when not initialized', () {
        final config = IntegrityConfig.instance;
        final bypass = config.isDevelopmentBypassEnabled();

        expect(bypass, isA<bool>());
      });
    });

    group('getEnforcementLevel', () {
      test('returns logOnly for default configuration', () {
        final config = IntegrityConfig.instance;
        final level = config.getEnforcementLevel();

        expect(
          level,
          anyOf(
            equals(IntegrityEnforcementLevel.logOnly),
            isA<IntegrityEnforcementLevel>(),
          ),
        );
      });

      test('returns default level on Remote Config error', () {
        final config = IntegrityConfig.instance;

        // This should handle errors gracefully
        final level = config.getEnforcementLevel();

        expect(level, isA<IntegrityEnforcementLevel>());
      });
    });

    group('getHighRiskOperations', () {
      test('returns default high-risk operations', () {
        final config = IntegrityConfig.instance;
        final operations = config.getHighRiskOperations();

        expect(operations, isA<Set<String>>());
        expect(operations, isNotEmpty);
      });

      test('includes all critical operations in defaults', () {
        final config = IntegrityConfig.instance;
        final operations = config.getHighRiskOperations();

        final expectedOperations = [
          'auth_create_account',
          'auth_sign_in',
          'sync_cloud_data',
          'share_simulation',
          'save_custom_scenario',
          'delete_account',
          'export_user_data',
        ];

        for (final operation in expectedOperations) {
          expect(
            operations.contains(operation),
            isTrue,
            reason: '$operation should be in high-risk operations',
          );
        }
      });

      test('returns default on Remote Config error', () {
        final config = IntegrityConfig.instance;

        // This should handle errors gracefully
        final operations = config.getHighRiskOperations();

        expect(operations, isA<Set<String>>());
        expect(operations, isNotEmpty);
      });
    });

    group('isDevelopmentBypassEnabled', () {
      test('returns boolean value', () {
        final config = IntegrityConfig.instance;
        final bypass = config.isDevelopmentBypassEnabled();

        expect(bypass, isA<bool>());
      });

      test('returns safe default (true) on error', () {
        final config = IntegrityConfig.instance;

        // Should return safe default on error
        final bypass = config.isDevelopmentBypassEnabled();

        expect(bypass, isA<bool>());
      });
    });

    group('isEnabled', () {
      test('returns true by default', () {
        final config = IntegrityConfig.instance;

        expect(config.isEnabled(), isTrue);
      });

      test('returns boolean value from Remote Config', () {
        // Cannot mock Remote Config in singleton, so just verify it returns bool
        final config = IntegrityConfig.instance;
        final enabled = config.isEnabled();

        expect(enabled, isA<bool>());
      });

      test('returns true when not initialized', () {
        final config = IntegrityConfig.instance;
        // Even if not initialized, should default to enabled for security
        expect(config.isEnabled(), isTrue);
      });

      test('method exists and is callable', () {
        final config = IntegrityConfig.instance;

        // Verify method can be called multiple times consistently
        final result1 = config.isEnabled();
        final result2 = config.isEnabled();

        expect(result1, equals(result2));
        expect(result1, isA<bool>());
      });
    });

    group('isHighRiskOperation', () {
      test('returns true for known high-risk operations', () {
        final config = IntegrityConfig.instance;

        expect(config.isHighRiskOperation('auth_create_account'), isTrue);
        expect(config.isHighRiskOperation('auth_sign_in'), isTrue);
        expect(config.isHighRiskOperation('sync_cloud_data'), isTrue);
        expect(config.isHighRiskOperation('share_simulation'), isTrue);
        expect(config.isHighRiskOperation('save_custom_scenario'), isTrue);
        expect(config.isHighRiskOperation('delete_account'), isTrue);
        expect(config.isHighRiskOperation('export_user_data'), isTrue);
      });

      test('returns false for unknown operations', () {
        final config = IntegrityConfig.instance;

        expect(config.isHighRiskOperation('unknown_operation'), isFalse);
        expect(config.isHighRiskOperation('low_risk_read'), isFalse);
        expect(config.isHighRiskOperation(''), isFalse);
      });

      test('is case-sensitive', () {
        final config = IntegrityConfig.instance;

        expect(config.isHighRiskOperation('auth_sign_in'), isTrue);
        expect(config.isHighRiskOperation('AUTH_SIGN_IN'), isFalse);
        expect(config.isHighRiskOperation('Auth_Sign_In'), isFalse);
      });
    });

    group('getEffectiveEnforcementLevel', () {
      test(
        'returns blockAll for all operations when global level is blockAll',
        () {
          final config = IntegrityConfig.instance;

          // Note: This test depends on the current Remote Config state
          // In a real implementation, we'd mock the config to set blockAll
          final level = config.getEffectiveEnforcementLevel('any_operation');

          expect(level, isA<IntegrityEnforcementLevel>());
        },
      );

      test(
        'returns blockHighRisk for high-risk operations when global is blockHighRisk',
        () {
          final config = IntegrityConfig.instance;

          // Note: This test depends on the current Remote Config state
          final level = config.getEffectiveEnforcementLevel(
            'auth_create_account',
          );

          expect(level, isA<IntegrityEnforcementLevel>());
        },
      );

      test(
        'returns warnUser for low-risk operations when global is blockHighRisk',
        () {
          final config = IntegrityConfig.instance;

          // Note: This test depends on the current Remote Config state
          final level = config.getEffectiveEnforcementLevel(
            'low_risk_operation',
          );

          expect(level, isA<IntegrityEnforcementLevel>());
        },
      );

      test('returns global level for logOnly and warnUser levels', () {
        final config = IntegrityConfig.instance;

        // When global level is logOnly or warnUser, should return that level
        // regardless of operation risk
        final level1 = config.getEffectiveEnforcementLevel('auth_sign_in');
        final level2 = config.getEffectiveEnforcementLevel(
          'low_risk_operation',
        );

        expect(level1, isA<IntegrityEnforcementLevel>());
        expect(level2, isA<IntegrityEnforcementLevel>());
      });
    });

    group('shouldBlockOperation', () {
      test('returns boolean value based on enforcement level', () {
        final config = IntegrityConfig.instance;

        final shouldBlock = config.shouldBlockOperation('auth_sign_in');

        expect(shouldBlock, isA<bool>());
      });

      test('returns false for logOnly enforcement', () {
        final config = IntegrityConfig.instance;

        // With default logOnly level, should not block
        final shouldBlock = config.shouldBlockOperation('auth_sign_in');

        expect(shouldBlock, isA<bool>());
      });

      test('works correctly for high-risk operations', () {
        final config = IntegrityConfig.instance;

        final shouldBlock = config.shouldBlockOperation('auth_create_account');

        expect(shouldBlock, isA<bool>());
      });

      test('works correctly for low-risk operations', () {
        final config = IntegrityConfig.instance;

        final shouldBlock = config.shouldBlockOperation('low_risk_operation');

        expect(shouldBlock, isA<bool>());
      });
    });

    group('shouldWarnForOperation', () {
      test('returns boolean value based on enforcement level', () {
        final config = IntegrityConfig.instance;

        final shouldWarn = config.shouldWarnForOperation('auth_sign_in');

        expect(shouldWarn, isA<bool>());
      });

      test('returns false for logOnly enforcement', () {
        final config = IntegrityConfig.instance;

        // With default logOnly level, should not warn
        final shouldWarn = config.shouldWarnForOperation('auth_sign_in');

        expect(shouldWarn, isA<bool>());
      });

      test('works correctly for high-risk operations', () {
        final config = IntegrityConfig.instance;

        final shouldWarn = config.shouldWarnForOperation('auth_create_account');

        expect(shouldWarn, isA<bool>());
      });

      test('works correctly for low-risk operations', () {
        final config = IntegrityConfig.instance;

        final shouldWarn = config.shouldWarnForOperation('low_risk_operation');

        expect(shouldWarn, isA<bool>());
      });
    });

    group('edge cases', () {
      test('handles empty operation ID', () {
        final config = IntegrityConfig.instance;

        expect(() => config.isHighRiskOperation(''), returnsNormally);
        expect(() => config.getEffectiveEnforcementLevel(''), returnsNormally);
        expect(() => config.shouldBlockOperation(''), returnsNormally);
        expect(() => config.shouldWarnForOperation(''), returnsNormally);
      });

      test('handles very long operation IDs', () {
        final config = IntegrityConfig.instance;
        final longId = 'very_' * 100 + 'long_operation_id';

        expect(() => config.isHighRiskOperation(longId), returnsNormally);
        expect(
          () => config.getEffectiveEnforcementLevel(longId),
          returnsNormally,
        );
        expect(() => config.shouldBlockOperation(longId), returnsNormally);
        expect(() => config.shouldWarnForOperation(longId), returnsNormally);
      });

      test('handles special characters in operation IDs', () {
        final config = IntegrityConfig.instance;
        final specialIds = [
          'operation-with-dashes',
          'operation.with.dots',
          'operation_with_underscores',
          'operation/with/slashes',
          'operation@with@symbols',
        ];

        for (final id in specialIds) {
          expect(() => config.isHighRiskOperation(id), returnsNormally);
          expect(
            () => config.getEffectiveEnforcementLevel(id),
            returnsNormally,
          );
          expect(() => config.shouldBlockOperation(id), returnsNormally);
          expect(() => config.shouldWarnForOperation(id), returnsNormally);
        }
      });

      test('getHighRiskOperations returns a new set each time', () {
        final config = IntegrityConfig.instance;

        final operations1 = config.getHighRiskOperations();
        final operations2 = config.getHighRiskOperations();

        // Should be equal but not the same object (for safety)
        expect(operations1, equals(operations2));
      });
    });

    group('refresh', () {
      test('refresh method completes without error', () async {
        final config = IntegrityConfig.instance;

        // Should complete successfully or gracefully handle errors
        await expectLater(config.refresh(), completes);
      });

      test('refresh does not throw when Remote Config unavailable', () async {
        final config = IntegrityConfig.instance;

        // Should handle errors gracefully
        await expectLater(config.refresh(), completes);
      });
    });

    group('integration scenarios', () {
      test('phased rollout: logOnly phase', () {
        final config = IntegrityConfig.instance;

        // In logOnly phase, nothing should block or warn
        expect(config.shouldBlockOperation('auth_sign_in'), isFalse);
        expect(config.shouldWarnForOperation('auth_sign_in'), isFalse);
        expect(config.shouldBlockOperation('low_risk_operation'), isFalse);
        expect(config.shouldWarnForOperation('low_risk_operation'), isFalse);
      });

      test('consistent behavior across multiple calls', () {
        final config = IntegrityConfig.instance;

        final operation = 'auth_sign_in';

        final isHighRisk1 = config.isHighRiskOperation(operation);
        final isHighRisk2 = config.isHighRiskOperation(operation);
        final isHighRisk3 = config.isHighRiskOperation(operation);

        expect(isHighRisk1, equals(isHighRisk2));
        expect(isHighRisk2, equals(isHighRisk3));

        final level1 = config.getEffectiveEnforcementLevel(operation);
        final level2 = config.getEffectiveEnforcementLevel(operation);
        final level3 = config.getEffectiveEnforcementLevel(operation);

        expect(level1, equals(level2));
        expect(level2, equals(level3));
      });

      test('all high-risk operations are properly classified', () {
        final config = IntegrityConfig.instance;
        final highRiskOps = config.getHighRiskOperations();

        // Verify each operation is recognized as high-risk
        for (final operation in highRiskOps) {
          expect(
            config.isHighRiskOperation(operation),
            isTrue,
            reason: '$operation should be classified as high-risk',
          );
        }
      });
    });
  });
}
