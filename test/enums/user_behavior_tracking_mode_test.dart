import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/user_behavior_tracking_mode.dart';

void main() {
  group('UserBehaviorTrackingMode Enum', () {
    test('should have all expected tracking modes', () {
      expect(UserBehaviorTrackingMode.values.length, equals(4));
      expect(
        UserBehaviorTrackingMode.values,
        contains(UserBehaviorTrackingMode.full),
      );
      expect(
        UserBehaviorTrackingMode.values,
        contains(UserBehaviorTrackingMode.essential),
      );
      expect(
        UserBehaviorTrackingMode.values,
        contains(UserBehaviorTrackingMode.none),
      );
      expect(
        UserBehaviorTrackingMode.values,
        contains(UserBehaviorTrackingMode.limited),
      );
    });

    group('configValue extension', () {
      test('should return correct config values', () {
        expect(UserBehaviorTrackingMode.full.configValue, equals('full'));
        expect(
          UserBehaviorTrackingMode.essential.configValue,
          equals('essential'),
        );
        expect(UserBehaviorTrackingMode.none.configValue, equals('none'));
        expect(UserBehaviorTrackingMode.limited.configValue, equals('limited'));
      });

      test('should have unique config values', () {
        final values = UserBehaviorTrackingMode.values
            .map((mode) => mode.configValue)
            .toSet();
        expect(
          values.length,
          equals(UserBehaviorTrackingMode.values.length),
          reason: 'All tracking modes should have unique config values',
        );
      });
    });

    group('fromString static method', () {
      test('should parse correct values', () {
        expect(
          UserBehaviorTrackingModeExtension.fromString('full'),
          equals(UserBehaviorTrackingMode.full),
        );
        expect(
          UserBehaviorTrackingModeExtension.fromString('essential'),
          equals(UserBehaviorTrackingMode.essential),
        );
        expect(
          UserBehaviorTrackingModeExtension.fromString('none'),
          equals(UserBehaviorTrackingMode.none),
        );
        expect(
          UserBehaviorTrackingModeExtension.fromString('limited'),
          equals(UserBehaviorTrackingMode.limited),
        );
      });

      test('should be case insensitive', () {
        expect(
          UserBehaviorTrackingModeExtension.fromString('FULL'),
          equals(UserBehaviorTrackingMode.full),
        );
        expect(
          UserBehaviorTrackingModeExtension.fromString('Essential'),
          equals(UserBehaviorTrackingMode.essential),
        );
        expect(
          UserBehaviorTrackingModeExtension.fromString('NONE'),
          equals(UserBehaviorTrackingMode.none),
        );
        expect(
          UserBehaviorTrackingModeExtension.fromString('Limited'),
          equals(UserBehaviorTrackingMode.limited),
        );
      });

      test('should return safe default for unknown values', () {
        expect(
          UserBehaviorTrackingModeExtension.fromString('unknown'),
          equals(UserBehaviorTrackingMode.essential),
        );
        expect(
          UserBehaviorTrackingModeExtension.fromString('invalid'),
          equals(UserBehaviorTrackingMode.essential),
        );
        expect(
          UserBehaviorTrackingModeExtension.fromString(''),
          equals(UserBehaviorTrackingMode.essential),
        );
      });

      test('should round-trip with configValue', () {
        for (final mode in UserBehaviorTrackingMode.values) {
          final recreated = UserBehaviorTrackingModeExtension.fromString(
            mode.configValue,
          );
          expect(
            recreated,
            equals(mode),
            reason: 'fromString should round-trip with configValue',
          );
        }
      });
    });

    group('privacy controls', () {
      test('allowsAnalytics should be correct', () {
        expect(UserBehaviorTrackingMode.full.allowsAnalytics, isTrue);
        expect(UserBehaviorTrackingMode.essential.allowsAnalytics, isTrue);
        expect(UserBehaviorTrackingMode.limited.allowsAnalytics, isTrue);
        expect(UserBehaviorTrackingMode.none.allowsAnalytics, isFalse);
      });

      test('allowsCrashReporting should be correct', () {
        expect(UserBehaviorTrackingMode.full.allowsCrashReporting, isTrue);
        expect(UserBehaviorTrackingMode.essential.allowsCrashReporting, isTrue);
        expect(UserBehaviorTrackingMode.limited.allowsCrashReporting, isFalse);
        expect(UserBehaviorTrackingMode.none.allowsCrashReporting, isFalse);
      });

      test('allowsPerformanceMonitoring should be correct', () {
        expect(
          UserBehaviorTrackingMode.full.allowsPerformanceMonitoring,
          isTrue,
        );
        expect(
          UserBehaviorTrackingMode.essential.allowsPerformanceMonitoring,
          isFalse,
        );
        expect(
          UserBehaviorTrackingMode.limited.allowsPerformanceMonitoring,
          isFalse,
        );
        expect(
          UserBehaviorTrackingMode.none.allowsPerformanceMonitoring,
          isFalse,
        );
      });

      test('allowsInteractionTracking should be correct', () {
        expect(UserBehaviorTrackingMode.full.allowsInteractionTracking, isTrue);
        expect(
          UserBehaviorTrackingMode.essential.allowsInteractionTracking,
          isFalse,
        );
        expect(
          UserBehaviorTrackingMode.limited.allowsInteractionTracking,
          isTrue,
        );
        expect(
          UserBehaviorTrackingMode.none.allowsInteractionTracking,
          isFalse,
        );
      });
    });

    group('localization keys', () {
      test('localizationKey should return appropriate keys', () {
        expect(
          UserBehaviorTrackingMode.full.localizationKey,
          equals('trackingModeFull'),
        );
        expect(
          UserBehaviorTrackingMode.essential.localizationKey,
          equals('trackingModeEssential'),
        );
        expect(
          UserBehaviorTrackingMode.none.localizationKey,
          equals('trackingModeNone'),
        );
        expect(
          UserBehaviorTrackingMode.limited.localizationKey,
          equals('trackingModeLimited'),
        );
      });

      test('descriptionKey should return appropriate keys', () {
        expect(
          UserBehaviorTrackingMode.full.descriptionKey,
          equals('trackingModeFullDescription'),
        );
        expect(
          UserBehaviorTrackingMode.essential.descriptionKey,
          equals('trackingModeEssentialDescription'),
        );
        expect(
          UserBehaviorTrackingMode.none.descriptionKey,
          equals('trackingModeNoneDescription'),
        );
        expect(
          UserBehaviorTrackingMode.limited.descriptionKey,
          equals('trackingModeLimitedDescription'),
        );
      });

      test('should have unique localization keys', () {
        final keys = UserBehaviorTrackingMode.values
            .map((mode) => mode.localizationKey)
            .toSet();
        expect(
          keys.length,
          equals(UserBehaviorTrackingMode.values.length),
          reason: 'All tracking modes should have unique localization keys',
        );
      });

      test('should have unique description keys', () {
        final descriptionKeys = UserBehaviorTrackingMode.values
            .map((mode) => mode.descriptionKey)
            .toSet();
        expect(
          descriptionKeys.length,
          equals(UserBehaviorTrackingMode.values.length),
          reason: 'All tracking modes should have unique description keys',
        );
      });
    });

    test('should cover comprehensive privacy spectrum', () {
      // Should have full tracking option
      expect(
        UserBehaviorTrackingMode.values,
        contains(UserBehaviorTrackingMode.full),
        reason: 'Should support full analytics tracking',
      );

      // Should have privacy-focused option
      expect(
        UserBehaviorTrackingMode.values,
        contains(UserBehaviorTrackingMode.none),
        reason: 'Should support complete privacy/no tracking',
      );

      // Should have balanced options
      expect(
        UserBehaviorTrackingMode.values,
        contains(UserBehaviorTrackingMode.essential),
        reason: 'Should support essential-only tracking',
      );
      expect(
        UserBehaviorTrackingMode.values,
        contains(UserBehaviorTrackingMode.limited),
        reason: 'Should support user-controlled limited tracking',
      );
    });

    test('should have logical privacy progression', () {
      // None should allow the least
      expect(UserBehaviorTrackingMode.none.allowsAnalytics, isFalse);
      expect(UserBehaviorTrackingMode.none.allowsCrashReporting, isFalse);
      expect(
        UserBehaviorTrackingMode.none.allowsPerformanceMonitoring,
        isFalse,
      );
      expect(UserBehaviorTrackingMode.none.allowsInteractionTracking, isFalse);

      // Full should allow the most
      expect(UserBehaviorTrackingMode.full.allowsAnalytics, isTrue);
      expect(UserBehaviorTrackingMode.full.allowsCrashReporting, isTrue);
      expect(UserBehaviorTrackingMode.full.allowsPerformanceMonitoring, isTrue);
      expect(UserBehaviorTrackingMode.full.allowsInteractionTracking, isTrue);

      // Essential should allow critical features
      expect(UserBehaviorTrackingMode.essential.allowsAnalytics, isTrue);
      expect(UserBehaviorTrackingMode.essential.allowsCrashReporting, isTrue);

      // Limited should allow user interactions but not performance
      expect(
        UserBehaviorTrackingMode.limited.allowsInteractionTracking,
        isTrue,
      );
      expect(
        UserBehaviorTrackingMode.limited.allowsPerformanceMonitoring,
        isFalse,
      );
    });

    test('should use safe default in fromString', () {
      final defaultMode = UserBehaviorTrackingModeExtension.fromString(
        'invalid',
      );
      expect(
        defaultMode,
        equals(UserBehaviorTrackingMode.essential),
        reason: 'Should default to essential tracking for safety',
      );

      // Essential should allow critical crash reporting but not extensive tracking
      expect(defaultMode.allowsCrashReporting, isTrue);
      expect(defaultMode.allowsPerformanceMonitoring, isFalse);
    });

    test('should handle all permission combinations logically', () {
      for (final mode in UserBehaviorTrackingMode.values) {
        // If no analytics, should also not allow other specific tracking
        if (!mode.allowsAnalytics) {
          expect(
            mode.allowsCrashReporting,
            isFalse,
            reason:
                '${mode.name} should not allow crash reporting without analytics',
          );
          expect(
            mode.allowsPerformanceMonitoring,
            isFalse,
            reason:
                '${mode.name} should not allow performance monitoring without analytics',
          );
          expect(
            mode.allowsInteractionTracking,
            isFalse,
            reason:
                '${mode.name} should not allow interaction tracking without analytics',
          );
        }

        // Performance monitoring should imply crash reporting (full featured)
        if (mode.allowsPerformanceMonitoring) {
          expect(
            mode.allowsCrashReporting,
            isTrue,
            reason:
                '${mode.name} should allow crash reporting if performance monitoring is enabled',
          );
        }
      }
    });
  });
}
