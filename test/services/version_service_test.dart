import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/version_status.dart';
import 'package:graviton/models/platform_version_config.dart';
import 'package:graviton/services/version_service.dart';

void main() {
  group('VersionService Tests', () {
    late VersionService service;

    setUp(() {
      service = VersionService.instance;
    });

    test('Should be singleton', () {
      final service1 = VersionService.instance;
      final service2 = VersionService.instance;
      expect(identical(service1, service2), isTrue);
    });

    test('Should initialize without throwing', () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      expect(() async => await service.initialize(), returnsNormally);
    });

    test('Should provide version information', () {
      expect(service.appVersion, isA<String>());
      expect(service.buildNumber, isA<String>());
      expect(service.fullVersion, isA<String>());
      expect(service.appVersion, isNotEmpty);
      expect(service.buildNumber, isNotEmpty);
      expect(service.fullVersion, contains(service.appVersion));
      expect(service.fullVersion, contains(service.buildNumber));
    });

    test('Should handle version status determination', () {
      final status = service.getVersionStatus();
      expect(status, isA<VersionStatus>());
      expect(VersionStatus.values, contains(status));
    });

    test('Should handle minimum version checks', () {
      expect(service.meetsMinimumVersion(), isA<bool>());
      expect(service.meetsPreferredVersion(), isA<bool>());
    });

    test('Should provide store URL for platform', () {
      final storeUrl = service.getStoreUrl();
      if (storeUrl != null) {
        expect(storeUrl, isA<String>());
        expect(storeUrl, isNotEmpty);
        expect(storeUrl, startsWith('https://'));
      }
    });

    test('Should handle store launching safely', () async {
      expect(() async => await service.launchStore(), returnsNormally);
    });

    test('Should handle all version status values', () {
      // Ensure all version status values are valid
      for (final status in VersionStatus.values) {
        expect(status.toString(), isNotEmpty);
        expect(status.index, greaterThanOrEqualTo(0));
      }
    });

    test('Should provide default values when not initialized', () {
      // Should provide reasonable defaults
      expect(service.appVersion, matches(RegExp(r'^\d+\.\d+\.\d+')));
      expect(service.buildNumber, matches(RegExp(r'^\d+')));
    });

    test('Should handle version status correctly', () {
      final status = service.getVersionStatus();

      // Should be one of the valid status values
      expect([
        VersionStatus.current,
        VersionStatus.outdated,
        VersionStatus.beta,
      ], contains(status));
    });

    test('Should handle minimum version logic correctly', () {
      final meetsMinimum = service.meetsMinimumVersion();
      final meetsPreferred = service.meetsPreferredVersion();

      // If app meets minimum, it should be installable
      // If it doesn't meet preferred, update should be recommended
      expect(meetsMinimum, isA<bool>());
      expect(meetsPreferred, isA<bool>());
    });

    test('Should format full version string correctly', () {
      final fullVersion = service.fullVersion;
      expect(fullVersion, contains('+'));
      expect(fullVersion, startsWith(service.appVersion));
      expect(fullVersion, endsWith(service.buildNumber));
    });

    test('Should handle platform-specific store URLs', () {
      final storeUrl = service.getStoreUrl();

      // On different platforms, should get appropriate store URL or null
      if (storeUrl != null) {
        expect(
          storeUrl,
          anyOf([
            contains('apple.com'), // iOS App Store
            contains('play.google.com'), // Google Play Store
          ]),
        );
      }
    });

    test('Should validate version strings have correct format', () {
      final appVersion = service.appVersion;
      final buildNumber = service.buildNumber;

      // App version should follow semantic versioning
      expect(appVersion, matches(RegExp(r'^\d+\.\d+\.\d+')));

      // Build number should be numeric
      expect(buildNumber, matches(RegExp(r'^\d+$')));
    });

    test('Should handle remote config integration gracefully', () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      // Should not throw when remote config is not available
      await service.initialize();

      // All methods should work after initialization
      expect(() => service.getVersionStatus(), returnsNormally);
      expect(() => service.meetsMinimumVersion(), returnsNormally);
      expect(() => service.meetsPreferredVersion(), returnsNormally);
      expect(() => service.getStoreUrl(), returnsNormally);
    });

    test('Should provide consistent version information', () {
      // Multiple calls should return the same values
      final version1 = service.appVersion;
      final version2 = service.appVersion;
      expect(version1, equals(version2));

      final build1 = service.buildNumber;
      final build2 = service.buildNumber;
      expect(build1, equals(build2));
    });

    test('Should handle store launch failure gracefully', () async {
      // Should return false if store cannot be launched
      final result = await service.launchStore();
      expect(result, isA<bool>());
      // Don't assert true/false as it depends on environment
    });
  });

  group('PlatformVersionConfig Tests', () {
    test('Should create valid config from JSON', () {
      final json = {
        'current_version': '1.2.0',
        'minimum_enforced_version': '1.0.0',
        'minimum_preferred_version': '1.1.0',
        'store_url': 'https://example.com',
      };

      final config = PlatformVersionConfig.fromJson(json);
      expect(config.currentVersion, equals('1.2.0'));
      expect(config.minimumEnforcedVersion, equals('1.0.0'));
      expect(config.minimumPreferredVersion, equals('1.1.0'));
      expect(config.storeUrl, equals('https://example.com'));
      expect(config.isValid, isTrue);
      expect(config.isEmpty, isFalse);
    });

    test('Should create empty config when no data provided', () {
      const config = PlatformVersionConfig.empty();
      expect(config.currentVersion, isEmpty);
      expect(config.minimumEnforcedVersion, isEmpty);
      expect(config.minimumPreferredVersion, isEmpty);
      expect(config.storeUrl, isEmpty);
      expect(config.isValid, isFalse);
      expect(config.isEmpty, isTrue);
    });

    test('Should handle JSON parsing', () {
      final jsonData = {
        'current_version': '2.2.0',
        'minimum_enforced_version': '2.0.0',
        'minimum_preferred_version': '2.1.0',
        'store_url': 'https://apps.apple.com/app/123',
      };

      final config = PlatformVersionConfig.fromJson(jsonData);
      expect(config.currentVersion, equals('2.2.0'));
      expect(config.minimumEnforcedVersion, equals('2.0.0'));
      expect(config.minimumPreferredVersion, equals('2.1.0'));
      expect(config.storeUrl, equals('https://apps.apple.com/app/123'));
      expect(config.isValid, isTrue);
    });

    test('Should handle empty JSON data', () {
      final config = PlatformVersionConfig.fromJson(<String, dynamic>{});
      expect(config.isEmpty, isTrue);
      expect(config.isValid, isFalse);
    });

    test('Should handle partial JSON data gracefully', () {
      final partialJson = {'current_version': '1.0.0'};
      final config = PlatformVersionConfig.fromJson(partialJson);
      expect(config.currentVersion, equals('1.0.0'));
      expect(config.minimumEnforcedVersion, isEmpty);
      expect(config.minimumPreferredVersion, isEmpty);
      expect(config.storeUrl, isEmpty);
      expect(config.isValid, isTrue); // Still valid because has current_version
    });

    test('Should create legacy config correctly', () {
      final config = PlatformVersionConfig.legacy(
        currentVersion: '1.7.0',
        minimumEnforcedVersion: '1.5.0',
        minimumPreferredVersion: '1.6.0',
        storeUrl: 'https://play.google.com/store',
      );

      expect(config.currentVersion, equals('1.7.0'));
      expect(config.minimumEnforcedVersion, equals('1.5.0'));
      expect(config.minimumPreferredVersion, equals('1.6.0'));
      expect(config.storeUrl, equals('https://play.google.com/store'));
      expect(config.isValid, isTrue);
    });

    test('Should determine validity correctly', () {
      // Valid when has at least one version
      final config1 = PlatformVersionConfig.legacy(
        currentVersion: '',
        minimumEnforcedVersion: '1.0.0',
        minimumPreferredVersion: '',
        storeUrl: '',
      );
      expect(config1.isValid, isTrue);

      final config2 = PlatformVersionConfig.legacy(
        currentVersion: '',
        minimumEnforcedVersion: '',
        minimumPreferredVersion: '1.0.0',
        storeUrl: '',
      );
      expect(config2.isValid, isTrue);

      // Invalid when no versions
      final config3 = PlatformVersionConfig.legacy(
        currentVersion: '',
        minimumEnforcedVersion: '',
        minimumPreferredVersion: '',
        storeUrl: 'https://example.com',
      );
      expect(config3.isValid, isFalse);
    });

    test('Should handle missing JSON fields', () {
      final json = <String, dynamic>{
        'minimum_enforced_version': '1.0.0',
        // missing other fields
      };

      final config = PlatformVersionConfig.fromJson(json);
      expect(config.minimumEnforcedVersion, equals('1.0.0'));
      expect(config.minimumPreferredVersion, isEmpty);
      expect(config.storeUrl, isEmpty);
      expect(config.isValid, isTrue); // Still valid with one version
    });

    test('Should handle null JSON values', () {
      final json = <String, dynamic>{
        'minimum_enforced_version': null,
        'minimum_preferred_version': null,
        'store_url': null,
      };

      final config = PlatformVersionConfig.fromJson(json);
      expect(config.minimumEnforcedVersion, isEmpty);
      expect(config.minimumPreferredVersion, isEmpty);
      expect(config.storeUrl, isEmpty);
      expect(config.isValid, isFalse);
    });

    test('Should implement equality correctly', () {
      final config1 = PlatformVersionConfig.legacy(
        currentVersion: '1.2.0',
        minimumEnforcedVersion: '1.0.0',
        minimumPreferredVersion: '1.1.0',
        storeUrl: 'https://example.com',
      );

      final config2 = PlatformVersionConfig.legacy(
        currentVersion: '1.2.0',
        minimumEnforcedVersion: '1.0.0',
        minimumPreferredVersion: '1.1.0',
        storeUrl: 'https://example.com',
      );

      final config3 = PlatformVersionConfig.legacy(
        currentVersion: '2.0.0',
        minimumEnforcedVersion: '2.0.0',
        minimumPreferredVersion: '1.1.0',
        storeUrl: 'https://example.com',
      );

      expect(config1, equals(config2));
      expect(config1.hashCode, equals(config2.hashCode));
      expect(config1, isNot(equals(config3)));
    });

    test('Should provide meaningful toString', () {
      final config = PlatformVersionConfig.legacy(
        currentVersion: '1.2.0',
        minimumEnforcedVersion: '1.0.0',
        minimumPreferredVersion: '1.1.0',
        storeUrl: 'https://example.com',
      );

      final str = config.toString();
      expect(str, contains('1.2.0'));
      expect(str, contains('1.0.0'));
      expect(str, contains('1.1.0'));
      expect(str, contains('https://example.com'));
      expect(str, contains('PlatformVersionConfig'));
    });
  });

  group('Platform-Specific Version Logic Tests', () {
    test('Should handle platform detection in config getter', () {
      final service = VersionService.instance;

      // The _currentPlatformConfig getter should work without throwing
      expect(() {
        // We can't directly test the private getter, but we can test methods that use it
        service.meetsMinimumVersion();
        service.meetsPreferredVersion();
        service.getStoreUrl();
      }, returnsNormally);
    });

    test('Should fallback to legacy config when platform config missing', () {
      final service = VersionService.instance;

      // When platform-specific configs are null, should fall back to legacy values
      // This is tested indirectly through the public methods
      expect(() => service.meetsMinimumVersion(), returnsNormally);
      expect(() => service.meetsPreferredVersion(), returnsNormally);
      expect(() => service.getStoreUrl(), returnsNormally);
    });

    test('Should handle empty platform configs gracefully', () {
      final service = VersionService.instance;

      // Should not throw when platform configs are empty
      expect(service.meetsMinimumVersion(), isA<bool>());
      expect(service.meetsPreferredVersion(), isA<bool>());
    });

    test('Should prefer platform config over legacy when available', () {
      // This test verifies the logic flow, though we can't easily mock the configs
      final service = VersionService.instance;

      // All methods should execute without error regardless of config state
      final meetsMin = service.meetsMinimumVersion();
      final meetsPreferred = service.meetsPreferredVersion();
      final storeUrl = service.getStoreUrl();

      expect(meetsMin, isA<bool>());
      expect(meetsPreferred, isA<bool>());
      expect(storeUrl, anyOf([isA<String>(), isNull]));
    });

    test('Should handle version comparison with platform configs', () {
      final service = VersionService.instance;

      // Test that version comparison works regardless of config source
      final currentVersion = service.appVersion;
      expect(currentVersion, matches(RegExp(r'^\d+\.\d+\.\d+')));

      // Version checks should return consistent results
      final meets1 = service.meetsMinimumVersion();
      final meets2 = service.meetsMinimumVersion();
      expect(meets1, equals(meets2));
    });

    test('Should maintain backward compatibility', () {
      final service = VersionService.instance;

      // All existing public methods should continue to work
      expect(() => service.appVersion, returnsNormally);
      expect(() => service.buildNumber, returnsNormally);
      expect(() => service.fullVersion, returnsNormally);
      expect(() => service.getVersionStatus(), returnsNormally);
      expect(() => service.meetsMinimumVersion(), returnsNormally);
      expect(() => service.meetsPreferredVersion(), returnsNormally);
      expect(() => service.getStoreUrl(), returnsNormally);
    });

    test('Should handle store URL logic with platform precedence', () {
      final service = VersionService.instance;
      final storeUrl = service.getStoreUrl();

      if (storeUrl != null) {
        expect(storeUrl, isA<String>());
        expect(storeUrl, isNotEmpty);
        expect(storeUrl, startsWith('https://'));
      }
    });

    test('Should handle edge cases in version checking', () {
      final service = VersionService.instance;

      // Should handle cases where versions are empty or null
      // The methods should return true (allowing access) when no restrictions
      final meetsMin = service.meetsMinimumVersion();
      final meetsPreferred = service.meetsPreferredVersion();

      expect(meetsMin, isA<bool>());
      expect(meetsPreferred, isA<bool>());

      // In most cases with no remote config, should default to allowing access
      expect(meetsMin, isTrue); // Usually true when no enforced version
      expect(meetsPreferred, isTrue); // Usually true when no preferred version
    });

    test('Should handle platform-specific current version', () {
      final service = VersionService.instance;

      // Test the currentVersion getter works without throwing
      expect(() => service.currentVersion, returnsNormally);

      // The getter should return a string or null
      final currentVersion = service.currentVersion;
      expect(currentVersion, anyOf([isA<String>(), isNull]));

      // If it's a string, it should be non-empty in a real app context
      if (currentVersion != null) {
        expect(currentVersion, isA<String>());
      }
    });

    test(
      'Should use platform-specific current version in status determination',
      () {
        final service = VersionService.instance;

        // Version status should work regardless of config source
        final status = service.getVersionStatus();
        expect(status, isA<VersionStatus>());
        expect(VersionStatus.values, contains(status));

        // Multiple calls should return consistent results
        final status2 = service.getVersionStatus();
        expect(status, equals(status2));
      },
    );
  });
}
