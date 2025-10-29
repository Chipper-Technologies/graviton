import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/version_status.dart';
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
}
