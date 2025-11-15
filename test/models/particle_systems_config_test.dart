import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/models/particle_systems_config.dart';
import 'package:graviton/models/particle_system_data.dart';

void main() {
  group('ParticleSystemsConfig', () {
    late ParticleSystemData testAsteroidBelt;
    late ParticleSystemData testKuiperBelt;

    setUp(() {
      testAsteroidBelt = const ParticleSystemData(
        enabled: true,
        innerRadius: 2.2,
        outerRadius: 3.2,
        particleCount: 10000,
        centralMass: 1.989e30,
        gravitationalConstant: 6.67430e-11,
        baseColor: '#8B4513',
        colorVariation: 0.3,
        useXZPlane: true,
        minSize: 0.5,
        maxSize: 2.0,
      );

      testKuiperBelt = const ParticleSystemData(
        enabled: false,
        innerRadius: 30.0,
        outerRadius: 50.0,
        particleCount: 15000,
        centralMass: 1.989e30,
        gravitationalConstant: 6.67430e-11,
        baseColor: '#A0A0A0',
        colorVariation: 0.2,
        useXZPlane: true,
        minSize: 1.0,
        maxSize: 3.0,
      );
    });

    group('constructor and properties', () {
      test('creates instance with both particle systems', () {
        final config = ParticleSystemsConfig(
          asteroidBelt: testAsteroidBelt,
          kuiperBelt: testKuiperBelt,
        );

        expect(config.asteroidBelt, equals(testAsteroidBelt));
        expect(config.kuiperBelt, equals(testKuiperBelt));
      });

      test('creates instance with only asteroid belt', () {
        const config = ParticleSystemsConfig(
          asteroidBelt: ParticleSystemData(
            enabled: true,
            innerRadius: 2.0,
            outerRadius: 4.0,
            particleCount: 5000,
            centralMass: 1e30,
            gravitationalConstant: 6.67e-11,
            baseColor: '#654321',
            colorVariation: 0.1,
            useXZPlane: false,
            minSize: 0.3,
            maxSize: 1.5,
          ),
        );

        expect(config.asteroidBelt?.enabled, isTrue);
        expect(config.asteroidBelt?.particleCount, equals(5000));
        expect(config.kuiperBelt, isNull);
      });

      test('creates instance with only kuiper belt', () {
        const config = ParticleSystemsConfig(
          kuiperBelt: ParticleSystemData(
            enabled: true,
            innerRadius: 35.0,
            outerRadius: 45.0,
            particleCount: 8000,
            centralMass: 1.5e30,
            gravitationalConstant: 6.67e-11,
            baseColor: '#808080',
            colorVariation: 0.25,
            useXZPlane: true,
            minSize: 0.8,
            maxSize: 2.5,
          ),
        );

        expect(config.asteroidBelt, isNull);
        expect(config.kuiperBelt?.enabled, isTrue);
        expect(config.kuiperBelt?.particleCount, equals(8000));
      });

      test('creates instance with no particle systems', () {
        const config = ParticleSystemsConfig();

        expect(config.asteroidBelt, isNull);
        expect(config.kuiperBelt, isNull);
      });

      test('handles disabled particle systems', () {
        const config = ParticleSystemsConfig(
          asteroidBelt: ParticleSystemData(
            enabled: false,
            innerRadius: 2.0,
            outerRadius: 4.0,
            particleCount: 0,
            centralMass: 1e30,
            gravitationalConstant: 6.67e-11,
            baseColor: '#000000',
            colorVariation: 0.0,
            useXZPlane: false,
            minSize: 0.1,
            maxSize: 0.1,
          ),
          kuiperBelt: ParticleSystemData(
            enabled: false,
            innerRadius: 30.0,
            outerRadius: 50.0,
            particleCount: 0,
            centralMass: 1e30,
            gravitationalConstant: 6.67e-11,
            baseColor: '#000000',
            colorVariation: 0.0,
            useXZPlane: false,
            minSize: 0.1,
            maxSize: 0.1,
          ),
        );

        expect(config.asteroidBelt?.enabled, isFalse);
        expect(config.kuiperBelt?.enabled, isFalse);
        expect(config.asteroidBelt?.particleCount, equals(0));
        expect(config.kuiperBelt?.particleCount, equals(0));
      });
    });

    group('fromJson factory constructor', () {
      test('creates from complete JSON map', () {
        final json = {
          'asteroidBelt': testAsteroidBelt.toJson(),
          'kuiperBelt': testKuiperBelt.toJson(),
        };

        final config = ParticleSystemsConfig.fromJson(json);

        expect(config.asteroidBelt?.enabled, equals(testAsteroidBelt.enabled));
        expect(
          config.asteroidBelt?.innerRadius,
          equals(testAsteroidBelt.innerRadius),
        );
        expect(
          config.asteroidBelt?.particleCount,
          equals(testAsteroidBelt.particleCount),
        );
        expect(config.kuiperBelt?.enabled, equals(testKuiperBelt.enabled));
        expect(
          config.kuiperBelt?.outerRadius,
          equals(testKuiperBelt.outerRadius),
        );
        expect(
          config.kuiperBelt?.particleCount,
          equals(testKuiperBelt.particleCount),
        );
      });

      test('creates from JSON with only asteroid belt', () {
        final json = {'asteroidBelt': testAsteroidBelt.toJson()};

        final config = ParticleSystemsConfig.fromJson(json);

        expect(config.asteroidBelt?.enabled, isTrue);
        expect(config.asteroidBelt?.particleCount, equals(10000));
        expect(config.kuiperBelt, isNull);
      });

      test('creates from JSON with only kuiper belt', () {
        final json = {'kuiperBelt': testKuiperBelt.toJson()};

        final config = ParticleSystemsConfig.fromJson(json);

        expect(config.asteroidBelt, isNull);
        expect(config.kuiperBelt?.enabled, isFalse);
        expect(config.kuiperBelt?.particleCount, equals(15000));
      });

      test('creates from empty JSON map', () {
        final json = <String, dynamic>{};

        final config = ParticleSystemsConfig.fromJson(json);

        expect(config.asteroidBelt, isNull);
        expect(config.kuiperBelt, isNull);
      });

      test('handles null values in JSON', () {
        final json = {'asteroidBelt': null, 'kuiperBelt': null};

        final config = ParticleSystemsConfig.fromJson(json);

        expect(config.asteroidBelt, isNull);
        expect(config.kuiperBelt, isNull);
      });
    });

    group('toJson method', () {
      test('converts to JSON with both particle systems', () {
        final config = ParticleSystemsConfig(
          asteroidBelt: testAsteroidBelt,
          kuiperBelt: testKuiperBelt,
        );

        final json = config.toJson();

        expect(json['asteroidBelt'], isA<Map<String, dynamic>>());
        expect(json['kuiperBelt'], isA<Map<String, dynamic>>());
        expect(json['asteroidBelt']['enabled'], isTrue);
        expect(json['kuiperBelt']['enabled'], isFalse);
        expect(json['asteroidBelt']['particleCount'], equals(10000));
        expect(json['kuiperBelt']['particleCount'], equals(15000));
      });

      test('converts to JSON with only asteroid belt', () {
        const config = ParticleSystemsConfig(
          asteroidBelt: ParticleSystemData(
            enabled: true,
            innerRadius: 2.5,
            outerRadius: 3.5,
            particleCount: 7500,
            centralMass: 1.2e30,
            gravitationalConstant: 6.67e-11,
            baseColor: '#654321',
            colorVariation: 0.15,
            useXZPlane: true,
            minSize: 0.4,
            maxSize: 1.8,
          ),
        );

        final json = config.toJson();

        expect(json['asteroidBelt'], isA<Map<String, dynamic>>());
        expect(json.containsKey('kuiperBelt'), isFalse);
        expect(json['asteroidBelt']['particleCount'], equals(7500));
      });

      test('converts to JSON with only kuiper belt', () {
        const config = ParticleSystemsConfig(
          kuiperBelt: ParticleSystemData(
            enabled: true,
            innerRadius: 32.0,
            outerRadius: 48.0,
            particleCount: 12000,
            centralMass: 1.8e30,
            gravitationalConstant: 6.67e-11,
            baseColor: '#909090',
            colorVariation: 0.18,
            useXZPlane: false,
            minSize: 0.9,
            maxSize: 2.8,
          ),
        );

        final json = config.toJson();

        expect(json.containsKey('asteroidBelt'), isFalse);
        expect(json['kuiperBelt'], isA<Map<String, dynamic>>());
        expect(json['kuiperBelt']['particleCount'], equals(12000));
      });

      test('converts to JSON with no particle systems', () {
        const config = ParticleSystemsConfig();

        final json = config.toJson();

        expect(json.containsKey('asteroidBelt'), isFalse);
        expect(json.containsKey('kuiperBelt'), isFalse);
        expect(json, isEmpty);
      });
    });

    group('round-trip serialization', () {
      test('maintains data integrity through fromJson/toJson cycle', () {
        final original = ParticleSystemsConfig(
          asteroidBelt: testAsteroidBelt,
          kuiperBelt: testKuiperBelt,
        );

        final json = original.toJson();
        final restored = ParticleSystemsConfig.fromJson(json);

        expect(
          restored.asteroidBelt?.enabled,
          equals(original.asteroidBelt?.enabled),
        );
        expect(
          restored.asteroidBelt?.innerRadius,
          equals(original.asteroidBelt?.innerRadius),
        );
        expect(
          restored.asteroidBelt?.outerRadius,
          equals(original.asteroidBelt?.outerRadius),
        );
        expect(
          restored.asteroidBelt?.particleCount,
          equals(original.asteroidBelt?.particleCount),
        );
        expect(
          restored.kuiperBelt?.enabled,
          equals(original.kuiperBelt?.enabled),
        );
        expect(
          restored.kuiperBelt?.innerRadius,
          equals(original.kuiperBelt?.innerRadius),
        );
        expect(
          restored.kuiperBelt?.outerRadius,
          equals(original.kuiperBelt?.outerRadius),
        );
        expect(
          restored.kuiperBelt?.particleCount,
          equals(original.kuiperBelt?.particleCount),
        );
      });

      test('handles null particle systems in round-trip', () {
        const original = ParticleSystemsConfig();

        final json = original.toJson();
        final restored = ParticleSystemsConfig.fromJson(json);

        expect(restored.asteroidBelt, isNull);
        expect(restored.kuiperBelt, isNull);
      });

      test('handles mixed null and non-null systems in round-trip', () {
        final original = ParticleSystemsConfig(asteroidBelt: testAsteroidBelt);

        final json = original.toJson();
        final restored = ParticleSystemsConfig.fromJson(json);

        expect(
          restored.asteroidBelt?.enabled,
          equals(original.asteroidBelt?.enabled),
        );
        expect(
          restored.asteroidBelt?.particleCount,
          equals(original.asteroidBelt?.particleCount),
        );
        expect(restored.kuiperBelt, isNull);
      });
    });

    group('realistic scenario examples', () {
      test('solar system asteroid belt configuration', () {
        const config = ParticleSystemsConfig(
          asteroidBelt: ParticleSystemData(
            enabled: true,
            innerRadius: 2.2, // AU from Sun (inner edge)
            outerRadius: 3.2, // AU from Sun (outer edge)
            particleCount: 50000,
            centralMass: 1.989e30, // Solar mass
            gravitationalConstant: 6.67430e-11,
            baseColor: '#8B4513', // Saddle brown
            colorVariation: 0.3,
            useXZPlane: true, // Solar system plane
            minSize: 0.1, // km
            maxSize: 10.0, // km
          ),
        );

        expect(config.asteroidBelt?.enabled, isTrue);
        expect(config.asteroidBelt?.innerRadius, equals(2.2));
        expect(config.asteroidBelt?.outerRadius, equals(3.2));
        expect(config.asteroidBelt?.particleCount, equals(50000));
        expect(config.asteroidBelt?.centralMass, equals(1.989e30));
        expect(config.asteroidBelt?.useXZPlane, isTrue);
      });

      test('complete solar system with both belts', () {
        const config = ParticleSystemsConfig(
          asteroidBelt: ParticleSystemData(
            enabled: true,
            innerRadius: 2.1,
            outerRadius: 3.3,
            particleCount: 25000,
            centralMass: 1.989e30,
            gravitationalConstant: 6.67430e-11,
            baseColor: '#A0522D',
            colorVariation: 0.4,
            useXZPlane: true,
            minSize: 0.05,
            maxSize: 5.0,
          ),
          kuiperBelt: ParticleSystemData(
            enabled: true,
            innerRadius: 30.0, // AU from Sun
            outerRadius: 50.0, // AU from Sun
            particleCount: 75000,
            centralMass: 1.989e30,
            gravitationalConstant: 6.67430e-11,
            baseColor: '#B0C4DE', // Light steel blue
            colorVariation: 0.2,
            useXZPlane: true,
            minSize: 0.5, // km
            maxSize: 2000.0, // km (Pluto-sized objects)
          ),
        );

        expect(config.asteroidBelt?.enabled, isTrue);
        expect(config.kuiperBelt?.enabled, isTrue);
        expect(
          config.asteroidBelt?.outerRadius,
          lessThan(config.kuiperBelt!.innerRadius),
        );
        expect(
          config.kuiperBelt?.particleCount,
          greaterThan(config.asteroidBelt!.particleCount),
        );
        expect(
          config.kuiperBelt?.maxSize,
          greaterThan(config.asteroidBelt!.maxSize),
        );
      });

      test('binary star system with dual asteroid belts', () {
        const config = ParticleSystemsConfig(
          asteroidBelt: ParticleSystemData(
            enabled: true,
            innerRadius: 1.5,
            outerRadius: 2.8,
            particleCount: 30000,
            centralMass: 3.0e30, // Binary system combined mass
            gravitationalConstant: 6.67430e-11,
            baseColor: '#CD853F',
            colorVariation: 0.5,
            useXZPlane: false, // Different orbital plane
            minSize: 0.2,
            maxSize: 8.0,
          ),
        );

        expect(config.asteroidBelt?.centralMass, equals(3.0e30));
        expect(config.asteroidBelt?.useXZPlane, isFalse);
        expect(config.asteroidBelt?.colorVariation, equals(0.5));
        expect(config.kuiperBelt, isNull);
      });
    });

    group('edge cases and validation', () {
      test('handles extreme particle counts', () {
        const config = ParticleSystemsConfig(
          asteroidBelt: ParticleSystemData(
            enabled: true,
            innerRadius: 2.0,
            outerRadius: 4.0,
            particleCount: 1000000, // One million particles
            centralMass: 1e30,
            gravitationalConstant: 6.67e-11,
            baseColor: '#808080',
            colorVariation: 0.1,
            useXZPlane: true,
            minSize: 0.01,
            maxSize: 100.0,
          ),
          kuiperBelt: ParticleSystemData(
            enabled: false,
            innerRadius: 30.0,
            outerRadius: 50.0,
            particleCount: 0, // No particles when disabled
            centralMass: 1e30,
            gravitationalConstant: 6.67e-11,
            baseColor: '#000000',
            colorVariation: 0.0,
            useXZPlane: true,
            minSize: 0.0,
            maxSize: 0.0,
          ),
        );

        expect(config.asteroidBelt?.particleCount, equals(1000000));
        expect(config.kuiperBelt?.particleCount, equals(0));
        expect(config.kuiperBelt?.enabled, isFalse);
      });

      test('handles very large orbital radii', () {
        const config = ParticleSystemsConfig(
          kuiperBelt: ParticleSystemData(
            enabled: true,
            innerRadius: 100.0, // 100 AU
            outerRadius: 1000.0, // 1000 AU (Oort cloud distances)
            particleCount: 500000,
            centralMass: 2e30,
            gravitationalConstant: 6.67430e-11,
            baseColor: '#E6E6FA', // Lavender
            colorVariation: 0.8,
            useXZPlane: false,
            minSize: 1.0,
            maxSize: 10000.0,
          ),
        );

        expect(config.kuiperBelt?.outerRadius, equals(1000.0));
        expect(config.kuiperBelt?.maxSize, equals(10000.0));
        expect(config.kuiperBelt?.colorVariation, equals(0.8));
      });

      test('validates system relationships', () {
        final config = ParticleSystemsConfig(
          asteroidBelt: testAsteroidBelt,
          kuiperBelt: testKuiperBelt,
        );

        // Asteroid belt should be closer than Kuiper belt
        expect(
          config.asteroidBelt!.outerRadius,
          lessThan(config.kuiperBelt!.innerRadius),
        );

        // Both should have same central mass for same star system
        expect(
          config.asteroidBelt!.centralMass,
          equals(config.kuiperBelt!.centralMass),
        );

        // Both should have same gravitational constant
        expect(
          config.asteroidBelt!.gravitationalConstant,
          equals(config.kuiperBelt!.gravitationalConstant),
        );
      });
    });
  });
}
