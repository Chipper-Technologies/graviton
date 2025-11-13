import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/models/platform_version_config.dart';

void main() {
  group('PlatformVersionConfig', () {
    group('constructor and properties', () {
      test('creates instance with all required properties', () {
        final config = PlatformVersionConfig(
          currentVersion: '2.1.0',
          minimumEnforcedVersion: '1.0.0',
          minimumPreferredVersion: '2.0.0',
          storeUrl:
              'https://play.google.com/store/apps/details?id=com.graviton',
        );

        expect(config.currentVersion, equals('2.1.0'));
        expect(config.minimumEnforcedVersion, equals('1.0.0'));
        expect(config.minimumPreferredVersion, equals('2.0.0'));
        expect(
          config.storeUrl,
          equals('https://play.google.com/store/apps/details?id=com.graviton'),
        );
      });

      test('handles empty strings', () {
        final config = PlatformVersionConfig(
          currentVersion: '',
          minimumEnforcedVersion: '',
          minimumPreferredVersion: '',
          storeUrl: '',
        );

        expect(config.currentVersion, equals(''));
        expect(config.minimumEnforcedVersion, equals(''));
        expect(config.minimumPreferredVersion, equals(''));
        expect(config.storeUrl, equals(''));
      });

      test('handles complex version strings', () {
        final config = PlatformVersionConfig(
          currentVersion: '3.2.1-beta.4+build.567',
          minimumEnforcedVersion: '3.0.0-alpha.1',
          minimumPreferredVersion: '3.1.0-rc.2',
          storeUrl: 'https://apps.apple.com/app/graviton/id1234567890',
        );

        expect(config.currentVersion, equals('3.2.1-beta.4+build.567'));
        expect(config.minimumEnforcedVersion, equals('3.0.0-alpha.1'));
        expect(config.minimumPreferredVersion, equals('3.1.0-rc.2'));
      });
    });

    group('empty constructor', () {
      test('creates empty configuration', () {
        final config = PlatformVersionConfig.empty();

        expect(config.currentVersion, equals(''));
        expect(config.minimumEnforcedVersion, equals(''));
        expect(config.minimumPreferredVersion, equals(''));
        expect(config.storeUrl, equals(''));
        expect(config.isEmpty, isTrue);
        expect(config.isValid, isFalse);
      });
    });

    group('legacy constructor', () {
      test('creates configuration from legacy values', () {
        final config = PlatformVersionConfig.legacy(
          currentVersion: '1.5.2',
          minimumEnforcedVersion: '1.0.0',
          minimumPreferredVersion: '1.4.0',
          storeUrl: 'https://store.example.com/app',
        );

        expect(config.currentVersion, equals('1.5.2'));
        expect(config.minimumEnforcedVersion, equals('1.0.0'));
        expect(config.minimumPreferredVersion, equals('1.4.0'));
        expect(config.storeUrl, equals('https://store.example.com/app'));
      });
    });

    group('fromJson factory constructor', () {
      test('creates from complete JSON map', () {
        final json = {
          'current_version': '2.0.1',
          'minimum_enforced_version': '1.5.0',
          'minimum_preferred_version': '1.9.0',
          'store_url': 'https://example.com/app',
        };

        final config = PlatformVersionConfig.fromJson(json);

        expect(config.currentVersion, equals('2.0.1'));
        expect(config.minimumEnforcedVersion, equals('1.5.0'));
        expect(config.minimumPreferredVersion, equals('1.9.0'));
        expect(config.storeUrl, equals('https://example.com/app'));
      });

      test('handles missing fields with defaults', () {
        final json = {
          'current_version': '1.0.0',
          // Other fields missing
        };

        final config = PlatformVersionConfig.fromJson(json);

        expect(config.currentVersion, equals('1.0.0'));
        expect(config.minimumEnforcedVersion, equals(''));
        expect(config.minimumPreferredVersion, equals(''));
        expect(config.storeUrl, equals(''));
      });

      test('handles null values with defaults', () {
        final json = {
          'current_version': null,
          'minimum_enforced_version': null,
          'minimum_preferred_version': null,
          'store_url': null,
        };

        final config = PlatformVersionConfig.fromJson(json);

        expect(config.currentVersion, equals(''));
        expect(config.minimumEnforcedVersion, equals(''));
        expect(config.minimumPreferredVersion, equals(''));
        expect(config.storeUrl, equals(''));
      });

      test('handles empty JSON map', () {
        final config = PlatformVersionConfig.fromJson({});

        expect(config.currentVersion, equals(''));
        expect(config.minimumEnforcedVersion, equals(''));
        expect(config.minimumPreferredVersion, equals(''));
        expect(config.storeUrl, equals(''));
        expect(config.isEmpty, isTrue);
      });

      test('handles complex version format in JSON', () {
        final json = {
          'current_version': '2.1.0-alpha.3+build.123',
          'minimum_enforced_version': '1.0.0-beta',
          'minimum_preferred_version': '2.0.0-rc.1',
          'store_url': 'https://store.app.com/details?id=com.example.app&hl=en',
        };

        final config = PlatformVersionConfig.fromJson(json);

        expect(config.currentVersion, equals('2.1.0-alpha.3+build.123'));
        expect(config.minimumEnforcedVersion, equals('1.0.0-beta'));
        expect(config.minimumPreferredVersion, equals('2.0.0-rc.1'));
        expect(config.storeUrl, contains('store.app.com'));
      });
    });

    group('toJson method', () {
      test('converts to JSON correctly', () {
        final config = PlatformVersionConfig(
          currentVersion: '1.2.3',
          minimumEnforcedVersion: '1.0.0',
          minimumPreferredVersion: '1.1.0',
          storeUrl: 'https://store.example.com',
        );

        final json = config.toJson();

        expect(json['current_version'], equals('1.2.3'));
        expect(json['minimum_enforced_version'], equals('1.0.0'));
        expect(json['minimum_preferred_version'], equals('1.1.0'));
        expect(json['store_url'], equals('https://store.example.com'));
      });

      test('converts empty values to JSON', () {
        final config = PlatformVersionConfig.empty();

        final json = config.toJson();

        expect(json['current_version'], equals(''));
        expect(json['minimum_enforced_version'], equals(''));
        expect(json['minimum_preferred_version'], equals(''));
        expect(json['store_url'], equals(''));
      });

      test('returns map with correct keys', () {
        final config = PlatformVersionConfig.empty();

        final json = config.toJson();

        expect(
          json.keys,
          containsAll([
            'current_version',
            'minimum_enforced_version',
            'minimum_preferred_version',
            'store_url',
          ]),
        );
        expect(json.keys.length, equals(4));
      });
    });

    group('toJsonString method', () {
      test('converts to JSON string', () {
        final config = PlatformVersionConfig(
          currentVersion: '1.0.0',
          minimumEnforcedVersion: '0.9.0',
          minimumPreferredVersion: '1.0.0',
          storeUrl: 'https://example.com',
        );

        final jsonString = config.toJsonString();

        expect(jsonString, isA<String>());
        expect(jsonString, contains('"current_version":"1.0.0"'));
        expect(jsonString, contains('"store_url":"https://example.com"'));
      });

      test('handles special characters in JSON string', () {
        final config = PlatformVersionConfig(
          currentVersion: '1.0.0-β+测试',
          minimumEnforcedVersion: '0.9.0',
          minimumPreferredVersion: '1.0.0',
          storeUrl: 'https://example.com/app?param=value&other=test',
        );

        final jsonString = config.toJsonString();

        expect(jsonString, isA<String>());
        expect(jsonString, contains('β'));
        expect(jsonString, contains('测试'));
      });
    });

    group('validation properties', () {
      test('hasEnforcedVersion returns correct values', () {
        final configWithEnforced = PlatformVersionConfig(
          currentVersion: '1.0.0',
          minimumEnforcedVersion: '0.9.0',
          minimumPreferredVersion: '',
          storeUrl: '',
        );

        final configWithoutEnforced = PlatformVersionConfig(
          currentVersion: '1.0.0',
          minimumEnforcedVersion: '',
          minimumPreferredVersion: '0.9.0',
          storeUrl: '',
        );

        expect(configWithEnforced.hasEnforcedVersion, isTrue);
        expect(configWithoutEnforced.hasEnforcedVersion, isFalse);
      });

      test('hasPreferredVersion returns correct values', () {
        final configWithPreferred = PlatformVersionConfig(
          currentVersion: '1.0.0',
          minimumEnforcedVersion: '',
          minimumPreferredVersion: '0.9.0',
          storeUrl: '',
        );

        final configWithoutPreferred = PlatformVersionConfig(
          currentVersion: '1.0.0',
          minimumEnforcedVersion: '0.9.0',
          minimumPreferredVersion: '',
          storeUrl: '',
        );

        expect(configWithPreferred.hasPreferredVersion, isTrue);
        expect(configWithoutPreferred.hasPreferredVersion, isFalse);
      });

      test('hasStoreUrl returns correct values', () {
        final configWithUrl = PlatformVersionConfig(
          currentVersion: '',
          minimumEnforcedVersion: '',
          minimumPreferredVersion: '',
          storeUrl: 'https://example.com',
        );

        final configWithoutUrl = PlatformVersionConfig(
          currentVersion: '1.0.0',
          minimumEnforcedVersion: '',
          minimumPreferredVersion: '',
          storeUrl: '',
        );

        expect(configWithUrl.hasStoreUrl, isTrue);
        expect(configWithoutUrl.hasStoreUrl, isFalse);
      });

      test('isValid returns correct values', () {
        final validConfigs = [
          PlatformVersionConfig(
            currentVersion: '1.0.0',
            minimumEnforcedVersion: '',
            minimumPreferredVersion: '',
            storeUrl: '',
          ),
          PlatformVersionConfig(
            currentVersion: '',
            minimumEnforcedVersion: '0.9.0',
            minimumPreferredVersion: '',
            storeUrl: '',
          ),
          PlatformVersionConfig(
            currentVersion: '',
            minimumEnforcedVersion: '',
            minimumPreferredVersion: '1.0.0',
            storeUrl: '',
          ),
        ];

        for (final config in validConfigs) {
          expect(config.isValid, isTrue);
        }

        final invalidConfig = PlatformVersionConfig.empty();
        expect(invalidConfig.isValid, isFalse);
      });

      test('isEmpty returns correct values', () {
        final emptyConfig = PlatformVersionConfig.empty();
        expect(emptyConfig.isEmpty, isTrue);

        final nonEmptyConfig = PlatformVersionConfig(
          currentVersion: '1.0.0',
          minimumEnforcedVersion: '',
          minimumPreferredVersion: '',
          storeUrl: '',
        );
        expect(nonEmptyConfig.isEmpty, isFalse);
      });
    });

    group('equality and hashCode', () {
      test('equal configurations have same equality result', () {
        final config1 = PlatformVersionConfig(
          currentVersion: '1.0.0',
          minimumEnforcedVersion: '0.9.0',
          minimumPreferredVersion: '1.0.0',
          storeUrl: 'https://example.com',
        );

        final config2 = PlatformVersionConfig(
          currentVersion: '1.0.0',
          minimumEnforcedVersion: '0.9.0',
          minimumPreferredVersion: '1.0.0',
          storeUrl: 'https://example.com',
        );

        expect(config1, equals(config2));
        expect(config1.hashCode, equals(config2.hashCode));
      });

      test('different configurations have different equality result', () {
        final config1 = PlatformVersionConfig(
          currentVersion: '1.0.0',
          minimumEnforcedVersion: '0.9.0',
          minimumPreferredVersion: '1.0.0',
          storeUrl: 'https://example.com',
        );

        final config2 = PlatformVersionConfig(
          currentVersion: '1.0.1', // Different version
          minimumEnforcedVersion: '0.9.0',
          minimumPreferredVersion: '1.0.0',
          storeUrl: 'https://example.com',
        );

        expect(config1, isNot(equals(config2)));
        expect(config1.hashCode, isNot(equals(config2.hashCode)));
      });

      test('handles identity equality', () {
        final config = PlatformVersionConfig.empty();
        expect(config, equals(config));
      });
    });

    group('toString method', () {
      test('provides meaningful string representation', () {
        final config = PlatformVersionConfig(
          currentVersion: '1.2.3',
          minimumEnforcedVersion: '1.0.0',
          minimumPreferredVersion: '1.2.0',
          storeUrl: 'https://store.example.com',
        );

        final stringRep = config.toString();
        expect(stringRep, contains('PlatformVersionConfig'));
        expect(stringRep, contains('1.2.3'));
        expect(stringRep, contains('1.0.0'));
        expect(stringRep, contains('1.2.0'));
        expect(stringRep, contains('https://store.example.com'));
      });

      test('handles empty values in toString', () {
        final config = PlatformVersionConfig.empty();

        final stringRep = config.toString();
        expect(stringRep, contains('PlatformVersionConfig'));
        expect(stringRep, contains('current: '));
        expect(stringRep, contains('enforced: '));
        expect(stringRep, contains('preferred: '));
        expect(stringRep, contains('storeUrl: '));
      });
    });

    group('round-trip serialization', () {
      test('maintains data integrity through fromJson/toJson cycle', () {
        final originalConfig = PlatformVersionConfig(
          currentVersion: '2.1.0-beta.3+build.456',
          minimumEnforcedVersion: '1.5.0',
          minimumPreferredVersion: '2.0.0-rc.1',
          storeUrl:
              'https://play.google.com/store/apps/details?id=com.example.graviton&hl=en&gl=US',
        );

        final json = originalConfig.toJson();
        final reconstructedConfig = PlatformVersionConfig.fromJson(json);

        expect(
          reconstructedConfig.currentVersion,
          equals(originalConfig.currentVersion),
        );
        expect(
          reconstructedConfig.minimumEnforcedVersion,
          equals(originalConfig.minimumEnforcedVersion),
        );
        expect(
          reconstructedConfig.minimumPreferredVersion,
          equals(originalConfig.minimumPreferredVersion),
        );
        expect(reconstructedConfig.storeUrl, equals(originalConfig.storeUrl));
        expect(reconstructedConfig, equals(originalConfig));
      });

      test('handles empty configuration in round-trip', () {
        final originalConfig = PlatformVersionConfig.empty();

        final json = originalConfig.toJson();
        final reconstructedConfig = PlatformVersionConfig.fromJson(json);

        expect(reconstructedConfig, equals(originalConfig));
        expect(reconstructedConfig.isEmpty, isTrue);
      });
    });

    group('realistic platform scenarios', () {
      test('Android Play Store configuration', () {
        final androidConfig = PlatformVersionConfig(
          currentVersion: '2.1.0',
          minimumEnforcedVersion: '1.8.0',
          minimumPreferredVersion: '2.0.0',
          storeUrl:
              'https://play.google.com/store/apps/details?id=com.graviton.app',
        );

        expect(androidConfig.isValid, isTrue);
        expect(androidConfig.hasStoreUrl, isTrue);
        expect(androidConfig.storeUrl, contains('play.google.com'));
      });

      test('iOS App Store configuration', () {
        final iosConfig = PlatformVersionConfig(
          currentVersion: '2.1.0',
          minimumEnforcedVersion: '1.8.0',
          minimumPreferredVersion: '2.0.0',
          storeUrl: 'https://apps.apple.com/app/graviton/id1234567890',
        );

        expect(iosConfig.isValid, isTrue);
        expect(iosConfig.hasStoreUrl, isTrue);
        expect(iosConfig.storeUrl, contains('apps.apple.com'));
      });

      test('development configuration', () {
        final devConfig = PlatformVersionConfig(
          currentVersion: '3.0.0-dev.1+commit.abcdef',
          minimumEnforcedVersion: '2.9.0',
          minimumPreferredVersion: '2.9.5',
          storeUrl: '',
        );

        expect(devConfig.isValid, isTrue);
        expect(devConfig.hasStoreUrl, isFalse);
        expect(devConfig.currentVersion, contains('dev'));
      });

      test('legacy beta configuration', () {
        final betaConfig = PlatformVersionConfig.legacy(
          currentVersion: '1.0.0-beta.1',
          minimumEnforcedVersion: '0.9.0',
          minimumPreferredVersion: '0.9.5',
          storeUrl: 'https://testflight.apple.com/join/12345678',
        );

        expect(betaConfig.isValid, isTrue);
        expect(betaConfig.storeUrl, contains('testflight'));
      });
    });
  });
}
