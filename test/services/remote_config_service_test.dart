import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/ab_test_group.dart';
import 'package:graviton/enums/custom_message_type.dart';
import 'package:graviton/enums/user_behavior_tracking_mode.dart';
import 'package:graviton/services/remote_config_service.dart';

import '../test_utils.dart';

void main() {
  group('RemoteConfigService Tests', () {
    late RemoteConfigService service;

    setUp(() {
      service = RemoteConfigService.instance;
    });

    test('Should be singleton', () {
      final service1 = RemoteConfigService.instance;
      final service2 = RemoteConfigService.instance;
      expect(identical(service1, service2), isTrue);
    });

    test('Should have default values before initialization', () {
      final mockL10n = TestUtils.createMockAppLocalizations();

      // Analytics & A/B Testing defaults
      expect(service.analyticsSamplingRate, equals(0.1));
      expect(service.crashReportingEnabled, isTrue);
      expect(service.performanceMonitoringEnabled, isTrue);
      expect(service.userBehaviorTracking, UserBehaviorTrackingMode.essential);
      expect(service.abTestGroup, ABTestGroup.control);

      // Maintenance & Communication defaults
      expect(service.maintenanceMode, isFalse);
      expect(
        service.getMaintenanceMessage(mockL10n),
        equals('Scheduled maintenance in progress'),
      );
      expect(service.newsBannerEnabled, isFalse);
      expect(service.newsBannerText, isEmpty);
      expect(service.emergencyNotification, isEmpty);
    });

    test('Should handle behavioral tracking flags correctly', () {
      expect(
        service.isUserBehaviorTrackingEnabled,
        isTrue,
      ); // 'standard' != 'disabled'
      expect(
        service.isEnhancedTrackingEnabled,
        isFalse,
      ); // 'standard' != 'enhanced'
    });

    test('Should handle notification state correctly', () {
      expect(
        service.hasActiveNotification,
        isFalse,
      ); // No emergency or news banner
      expect(
        service.isEmergencyNotification,
        isFalse,
      ); // Empty emergency notification
      expect(
        service.activeNotificationText,
        isEmpty,
      ); // No active notifications
    });

    test('Should provide enum-based active notification type', () {
      // Test the new activeNotificationTypeEnum method
      expect(service.activeNotificationTypeEnum, isA<CustomMessageType>());

      // Default should be info type when no specific notification type is set
      expect(
        service.activeNotificationTypeEnum,
        equals(CustomMessageType.info),
      );
    });

    test('Should handle different notification type values', () {
      // Test that all CustomMessageType values are supported by the fromString extension
      for (final type in CustomMessageType.values) {
        final configValue = type.configValue;
        final parsed = CustomMessageTypeExtension.fromString(configValue);
        expect(
          parsed,
          equals(type),
          reason: 'Failed to parse notification type: $configValue',
        );
      }
    });

    test('Should provide localization keys for notification types', () {
      // Test that all types have proper localization keys
      for (final type in CustomMessageType.values) {
        final localizationKey = type.localizationKey;
        expect(
          localizationKey,
          isNotEmpty,
          reason: 'Missing localization key for $type',
        );
      }
    });

    test('Should initialize without throwing', () async {
      // This should not throw even if Firebase Remote Config is not available
      expect(() async => await service.initialize(), returnsNormally);
    });

    test('Should handle refresh without throwing', () async {
      // This should not throw even if Firebase Remote Config is not available
      expect(() async => await service.refresh(), returnsNormally);
    });

    test('Should validate analytics sampling rate bounds', () {
      // Sampling rate should be between 0.0 and 1.0
      expect(service.analyticsSamplingRate, greaterThanOrEqualTo(0.0));
      expect(service.analyticsSamplingRate, lessThanOrEqualTo(1.0));
    });

    test('Should validate A/B test group values', () {
      final validGroups = [
        ABTestGroup.control,
        ABTestGroup.experimental,
        ABTestGroup.variantA,
        ABTestGroup.variantB,
      ];
      expect(validGroups, contains(service.abTestGroup));
    });

    test('Should validate user behavior tracking values', () {
      final validTrackingModes = [
        UserBehaviorTrackingMode.none,
        UserBehaviorTrackingMode.essential,
        UserBehaviorTrackingMode.limited,
        UserBehaviorTrackingMode.full,
      ];
      expect(validTrackingModes, contains(service.userBehaviorTracking));
    });

    test('Should handle emergency notifications safely', () {
      // Emergency notifications should be strings (can be empty)
      expect(service.emergencyNotification, isA<String>());
      expect(service.maintenanceMessage, isA<String>());
      expect(service.newsBannerText, isA<String>());
    });

    test('Should provide consistent feature flag access', () {
      // Test that feature flags return consistent types
      expect(service.crashReportingEnabled, isA<bool>());
      expect(service.performanceMonitoringEnabled, isA<bool>());
      expect(service.maintenanceMode, isA<bool>());
      expect(service.newsBannerEnabled, isA<bool>());
      expect(service.isUserBehaviorTrackingEnabled, isA<bool>());
      expect(service.isEnhancedTrackingEnabled, isA<bool>());
      expect(service.hasActiveNotification, isA<bool>());
      expect(service.isEmergencyNotification, isA<bool>());
    });

    test('Should handle maintenance mode state', () {
      if (service.maintenanceMode) {
        expect(service.maintenanceMessage, isNotEmpty);
      }
    });

    test('Should handle news banner state', () {
      if (service.newsBannerEnabled) {
        expect(service.newsBannerText, isNotEmpty);
      }
    });

    test('Should handle notification priority correctly', () {
      // Emergency notifications take priority over news banners
      final activeText = service.activeNotificationText;

      if (service.isEmergencyNotification) {
        expect(activeText, equals(service.emergencyNotification));
      } else if (service.newsBannerEnabled) {
        expect(activeText, equals(service.newsBannerText));
      } else {
        expect(activeText, isEmpty);
      }
    });

    test('Should validate enhanced tracking logic', () {
      // Enhanced tracking should only be true for 'enhanced' mode
      if (service.isEnhancedTrackingEnabled) {
        expect(service.userBehaviorTracking, equals('enhanced'));
      }
    });

    test('Should validate disabled tracking logic', () {
      // User behavior tracking should be disabled only for 'disabled' mode
      if (!service.isUserBehaviorTrackingEnabled) {
        expect(service.userBehaviorTracking, equals('disabled'));
      }
    });

    test('Should handle service state consistency', () {
      // All properties should be accessible without throwing
      expect(() => service.analyticsSamplingRate, returnsNormally);
      expect(() => service.crashReportingEnabled, returnsNormally);
      expect(() => service.performanceMonitoringEnabled, returnsNormally);
      expect(() => service.userBehaviorTracking, returnsNormally);
      expect(() => service.abTestGroup, returnsNormally);
      expect(() => service.maintenanceMode, returnsNormally);
      expect(() => service.maintenanceMessage, returnsNormally);
      expect(() => service.newsBannerEnabled, returnsNormally);
      expect(() => service.newsBannerText, returnsNormally);
      expect(() => service.emergencyNotification, returnsNormally);
    });
  });
}
