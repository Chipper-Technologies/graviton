import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/models/particle_system_data.dart';

void main() {
  group('ParticleSystemData', () {
    group('constructor and properties', () {
      test('creates particle system with required parameters', () {
        const particleSystem = ParticleSystemData(
          enabled: true,
          innerRadius: 100.0,
          outerRadius: 500.0,
          particleCount: 1000,
          centralMass: 1.989e30,
          gravitationalConstant: 6.67430e-11,
          baseColor: '#FFD700',
          colorVariation: 0.2,
          useXZPlane: false,
          minSize: 0.5,
          maxSize: 2.0,
        );

        expect(particleSystem.enabled, isTrue);
        expect(particleSystem.innerRadius, equals(100.0));
        expect(particleSystem.outerRadius, equals(500.0));
        expect(particleSystem.particleCount, equals(1000));
        expect(particleSystem.centralMass, equals(1.989e30));
        expect(particleSystem.gravitationalConstant, equals(6.67430e-11));
        expect(particleSystem.baseColor, equals('#FFD700'));
        expect(particleSystem.colorVariation, equals(0.2));
        expect(particleSystem.useXZPlane, isFalse);
        expect(particleSystem.minSize, equals(0.5));
        expect(particleSystem.maxSize, equals(2.0));
      });

      test('creates disabled particle system', () {
        const particleSystem = ParticleSystemData(
          enabled: false,
          innerRadius: 0.0,
          outerRadius: 0.0,
          particleCount: 0,
          centralMass: 0.0,
          gravitationalConstant: 0.0,
          baseColor: '#000000',
          colorVariation: 0.0,
          useXZPlane: false,
          minSize: 0.0,
          maxSize: 0.0,
        );

        expect(particleSystem.enabled, isFalse);
        expect(particleSystem.innerRadius, equals(0.0));
        expect(particleSystem.outerRadius, equals(0.0));
        expect(particleSystem.particleCount, equals(0));
        expect(particleSystem.centralMass, equals(0.0));
      });

      test('creates particle system with XZ plane configuration', () {
        const particleSystem = ParticleSystemData(
          enabled: true,
          innerRadius: 50.0,
          outerRadius: 200.0,
          particleCount: 500,
          centralMass: 5.972e24, // Earth mass
          gravitationalConstant: 1.0, // Normalized for simulation
          baseColor: '#8B4513',
          colorVariation: 0.3,
          useXZPlane: true,
          minSize: 1.0,
          maxSize: 3.0,
        );

        expect(particleSystem.useXZPlane, isTrue);
        expect(particleSystem.centralMass, equals(5.972e24));
        expect(particleSystem.gravitationalConstant, equals(1.0));
      });

      test('handles extreme radius values', () {
        const tinySystem = ParticleSystemData(
          enabled: true,
          innerRadius: 1e-10,
          outerRadius: 1e-5,
          particleCount: 10,
          centralMass: 1e20,
          gravitationalConstant: 1e-15,
          baseColor: '#FF0000',
          colorVariation: 1.0,
          useXZPlane: false,
          minSize: 1e-3,
          maxSize: 1e-2,
        );

        const hugeSystem = ParticleSystemData(
          enabled: true,
          innerRadius: 1e10,
          outerRadius: 1e15,
          particleCount: 1000000,
          centralMass: 1e40,
          gravitationalConstant: 1e10,
          baseColor: '#FFFFFF',
          colorVariation: 0.0,
          useXZPlane: true,
          minSize: 1000.0,
          maxSize: 10000.0,
        );

        expect(tinySystem.innerRadius, equals(1e-10));
        expect(tinySystem.outerRadius, equals(1e-5));
        expect(hugeSystem.innerRadius, equals(1e10));
        expect(hugeSystem.outerRadius, equals(1e15));
      });
    });

    group('fromJson factory constructor', () {
      test('creates from complete JSON map', () {
        final json = {
          'enabled': true,
          'innerRadius': 150.0,
          'outerRadius': 750.0,
          'particleCount': 2000,
          'centralMass': 2.5e30,
          'gravitationalConstant': 7.5e-11,
          'baseColor': '#00FFFF',
          'colorVariation': 0.4,
          'useXZPlane': true,
          'minSize': 0.8,
          'maxSize': 2.5,
        };

        final particleSystem = ParticleSystemData.fromJson(json);

        expect(particleSystem.enabled, isTrue);
        expect(particleSystem.innerRadius, equals(150.0));
        expect(particleSystem.outerRadius, equals(750.0));
        expect(particleSystem.particleCount, equals(2000));
        expect(particleSystem.centralMass, equals(2.5e30));
        expect(particleSystem.gravitationalConstant, equals(7.5e-11));
        expect(particleSystem.baseColor, equals('#00FFFF'));
        expect(particleSystem.colorVariation, equals(0.4));
        expect(particleSystem.useXZPlane, isTrue);
        expect(particleSystem.minSize, equals(0.8));
        expect(particleSystem.maxSize, equals(2.5));
      });

      test('creates from JSON with disabled state', () {
        final json = {
          'enabled': false,
          'innerRadius': 0.0,
          'outerRadius': 0.0,
          'particleCount': 0,
          'centralMass': 0.0,
          'gravitationalConstant': 0.0,
          'baseColor': '#000000',
          'colorVariation': 0.0,
          'useXZPlane': false,
          'minSize': 0.0,
          'maxSize': 0.0,
        };

        final particleSystem = ParticleSystemData.fromJson(json);

        expect(particleSystem.enabled, isFalse);
        expect(particleSystem.particleCount, equals(0));
        expect(particleSystem.centralMass, equals(0.0));
      });

      test('creates from JSON with scientific notation', () {
        final json = {
          'enabled': true,
          'innerRadius': 1.5e2,
          'outerRadius': 5.0e3,
          'particleCount': 1500,
          'centralMass': 1.989e30,
          'gravitationalConstant': 6.67430e-11,
          'baseColor': '#FFD700',
          'colorVariation': 0.15,
          'useXZPlane': false,
          'minSize': 5.0e-1,
          'maxSize': 2.0e0,
        };

        final particleSystem = ParticleSystemData.fromJson(json);

        expect(particleSystem.innerRadius, equals(1.5e2));
        expect(particleSystem.outerRadius, equals(5.0e3));
        expect(particleSystem.centralMass, equals(1.989e30));
        expect(particleSystem.gravitationalConstant, equals(6.67430e-11));
        expect(particleSystem.minSize, equals(5.0e-1));
        expect(particleSystem.maxSize, equals(2.0e0));
      });

      test('handles different color formats', () {
        final hexColor = {
          'enabled': true,
          'innerRadius': 100.0,
          'outerRadius': 200.0,
          'particleCount': 100,
          'centralMass': 1000.0,
          'gravitationalConstant': 1.0,
          'baseColor': '#FF5733',
          'colorVariation': 0.1,
          'useXZPlane': false,
          'minSize': 1.0,
          'maxSize': 1.0,
        };

        final rgbColor = {
          'enabled': true,
          'innerRadius': 100.0,
          'outerRadius': 200.0,
          'particleCount': 100,
          'centralMass': 1000.0,
          'gravitationalConstant': 1.0,
          'baseColor': 'rgb(255, 87, 51)',
          'colorVariation': 0.1,
          'useXZPlane': false,
          'minSize': 1.0,
          'maxSize': 1.0,
        };

        final namedColor = {
          'enabled': true,
          'innerRadius': 100.0,
          'outerRadius': 200.0,
          'particleCount': 100,
          'centralMass': 1000.0,
          'gravitationalConstant': 1.0,
          'baseColor': 'crimson',
          'colorVariation': 0.1,
          'useXZPlane': false,
          'minSize': 1.0,
          'maxSize': 1.0,
        };

        final hexSystem = ParticleSystemData.fromJson(hexColor);
        final rgbSystem = ParticleSystemData.fromJson(rgbColor);
        final namedSystem = ParticleSystemData.fromJson(namedColor);

        expect(hexSystem.baseColor, equals('#FF5733'));
        expect(rgbSystem.baseColor, equals('rgb(255, 87, 51)'));
        expect(namedSystem.baseColor, equals('crimson'));
      });
    });

    group('toJson method', () {
      test('converts to JSON correctly', () {
        const particleSystem = ParticleSystemData(
          enabled: true,
          innerRadius: 200.0,
          outerRadius: 800.0,
          particleCount: 1200,
          centralMass: 3.0e30,
          gravitationalConstant: 8.0e-11,
          baseColor: '#FF69B4',
          colorVariation: 0.25,
          useXZPlane: true,
          minSize: 0.75,
          maxSize: 2.25,
        );

        final json = particleSystem.toJson();

        expect(json['enabled'], isTrue);
        expect(json['innerRadius'], equals(200.0));
        expect(json['outerRadius'], equals(800.0));
        expect(json['particleCount'], equals(1200));
        expect(json['centralMass'], equals(3.0e30));
        expect(json['gravitationalConstant'], equals(8.0e-11));
        expect(json['baseColor'], equals('#FF69B4'));
        expect(json['colorVariation'], equals(0.25));
        expect(json['useXZPlane'], isTrue);
        expect(json['minSize'], equals(0.75));
        expect(json['maxSize'], equals(2.25));
      });

      test('converts disabled system to JSON', () {
        const particleSystem = ParticleSystemData(
          enabled: false,
          innerRadius: 0.0,
          outerRadius: 0.0,
          particleCount: 0,
          centralMass: 0.0,
          gravitationalConstant: 0.0,
          baseColor: '#000000',
          colorVariation: 0.0,
          useXZPlane: false,
          minSize: 0.0,
          maxSize: 0.0,
        );

        final json = particleSystem.toJson();

        expect(json['enabled'], isFalse);
        expect(json['particleCount'], equals(0));
        expect(json['centralMass'], equals(0.0));
        expect(json['baseColor'], equals('#000000'));
      });

      test('returns map with all required keys', () {
        const particleSystem = ParticleSystemData(
          enabled: true,
          innerRadius: 50.0,
          outerRadius: 100.0,
          particleCount: 50,
          centralMass: 1000.0,
          gravitationalConstant: 1.0,
          baseColor: '#FFFFFF',
          colorVariation: 0.0,
          useXZPlane: false,
          minSize: 1.0,
          maxSize: 1.0,
        );

        final json = particleSystem.toJson();

        expect(
          json.keys,
          containsAll([
            'enabled',
            'innerRadius',
            'outerRadius',
            'particleCount',
            'centralMass',
            'gravitationalConstant',
            'baseColor',
            'colorVariation',
            'useXZPlane',
            'minSize',
            'maxSize',
          ]),
        );
        expect(json.keys.length, equals(11));
      });

      test('handles extreme values in JSON output', () {
        const particleSystem = ParticleSystemData(
          enabled: true,
          innerRadius: 1e-15,
          outerRadius: 1e20,
          particleCount: 999999999,
          centralMass: 1e50,
          gravitationalConstant: 1e-50,
          baseColor: '#ABCDEF',
          colorVariation: 1.0,
          useXZPlane: true,
          minSize: 1e-10,
          maxSize: 1e10,
        );

        final json = particleSystem.toJson();

        expect(json['innerRadius'], equals(1e-15));
        expect(json['outerRadius'], equals(1e20));
        expect(json['particleCount'], equals(999999999));
        expect(json['centralMass'], equals(1e50));
        expect(json['gravitationalConstant'], equals(1e-50));
        expect(json['minSize'], equals(1e-10));
        expect(json['maxSize'], equals(1e10));
      });
    });

    group('round-trip serialization', () {
      test('maintains data integrity through fromJson/toJson cycle', () {
        const originalSystem = ParticleSystemData(
          enabled: true,
          innerRadius: 300.0,
          outerRadius: 1200.0,
          particleCount: 5000,
          centralMass: 4.5e30,
          gravitationalConstant: 9.2e-11,
          baseColor: '#32CD32',
          colorVariation: 0.35,
          useXZPlane: true,
          minSize: 0.9,
          maxSize: 3.1,
        );

        final json = originalSystem.toJson();
        final reconstructedSystem = ParticleSystemData.fromJson(json);

        expect(reconstructedSystem.enabled, equals(originalSystem.enabled));
        expect(
          reconstructedSystem.innerRadius,
          equals(originalSystem.innerRadius),
        );
        expect(
          reconstructedSystem.outerRadius,
          equals(originalSystem.outerRadius),
        );
        expect(
          reconstructedSystem.particleCount,
          equals(originalSystem.particleCount),
        );
        expect(
          reconstructedSystem.centralMass,
          equals(originalSystem.centralMass),
        );
        expect(
          reconstructedSystem.gravitationalConstant,
          equals(originalSystem.gravitationalConstant),
        );
        expect(reconstructedSystem.baseColor, equals(originalSystem.baseColor));
        expect(
          reconstructedSystem.colorVariation,
          equals(originalSystem.colorVariation),
        );
        expect(
          reconstructedSystem.useXZPlane,
          equals(originalSystem.useXZPlane),
        );
        expect(reconstructedSystem.minSize, equals(originalSystem.minSize));
        expect(reconstructedSystem.maxSize, equals(originalSystem.maxSize));
      });

      test('handles disabled state in round-trip', () {
        const originalSystem = ParticleSystemData(
          enabled: false,
          innerRadius: 0.0,
          outerRadius: 0.0,
          particleCount: 0,
          centralMass: 0.0,
          gravitationalConstant: 0.0,
          baseColor: '#000000',
          colorVariation: 0.0,
          useXZPlane: false,
          minSize: 0.0,
          maxSize: 0.0,
        );

        final json = originalSystem.toJson();
        final reconstructedSystem = ParticleSystemData.fromJson(json);

        expect(reconstructedSystem.enabled, equals(originalSystem.enabled));
        expect(
          reconstructedSystem.particleCount,
          equals(originalSystem.particleCount),
        );
        expect(
          reconstructedSystem.centralMass,
          equals(originalSystem.centralMass),
        );
      });
    });

    group('realistic particle system scenarios', () {
      test('Saturn ring system', () {
        const saturnRings = ParticleSystemData(
          enabled: true,
          innerRadius: 7000.0, // km from Saturn center
          outerRadius: 80000.0,
          particleCount: 10000,
          centralMass: 5.683e26, // Saturn mass in kg
          gravitationalConstant: 6.67430e-11,
          baseColor: '#FAD5A5', // Saturn's ring color
          colorVariation: 0.2,
          useXZPlane: true, // Horizontal ring system
          minSize: 0.1,
          maxSize: 1.0,
        );

        expect(saturnRings.enabled, isTrue);
        expect(saturnRings.innerRadius, equals(7000.0));
        expect(saturnRings.outerRadius, equals(80000.0));
        expect(saturnRings.centralMass, equals(5.683e26));
        expect(saturnRings.useXZPlane, isTrue);
        expect(saturnRings.baseColor, equals('#FAD5A5'));
      });

      test('asteroid belt system', () {
        const asteroidBelt = ParticleSystemData(
          enabled: true,
          innerRadius: 2.1 * 149597870.7, // 2.1 AU in km
          outerRadius: 3.3 * 149597870.7, // 3.3 AU in km
          particleCount: 50000,
          centralMass: 1.989e30, // Solar mass in kg
          gravitationalConstant: 6.67430e-11,
          baseColor: '#8C7853', // Rocky asteroid color
          colorVariation: 0.4,
          useXZPlane: false, // Orbital plane around sun
          minSize: 0.5,
          maxSize: 5.0,
        );

        expect(asteroidBelt.innerRadius, equals(2.1 * 149597870.7));
        expect(asteroidBelt.outerRadius, equals(3.3 * 149597870.7));
        expect(asteroidBelt.centralMass, equals(1.989e30));
        expect(asteroidBelt.particleCount, equals(50000));
        expect(asteroidBelt.useXZPlane, isFalse);
      });

      test('accretion disk around black hole', () {
        const accretionDisk = ParticleSystemData(
          enabled: true,
          innerRadius: 30000.0, // Close to event horizon
          outerRadius: 1000000.0,
          particleCount: 100000,
          centralMass: 10 * 1.989e30, // 10 solar mass black hole
          gravitationalConstant: 6.67430e-11,
          baseColor: '#FF4500', // Hot gas color
          colorVariation: 0.6,
          useXZPlane: true, // Disk around black hole
          minSize: 0.2,
          maxSize: 1.5,
        );

        expect(accretionDisk.centralMass, equals(10 * 1.989e30));
        expect(accretionDisk.innerRadius, equals(30000.0));
        expect(accretionDisk.particleCount, equals(100000));
        expect(accretionDisk.baseColor, equals('#FF4500'));
        expect(accretionDisk.colorVariation, equals(0.6));
      });

      test('protoplanetary disk', () {
        const protoDisk = ParticleSystemData(
          enabled: true,
          innerRadius: 0.1 * 149597870.7, // 0.1 AU
          outerRadius: 100 * 149597870.7, // 100 AU
          particleCount: 25000,
          centralMass: 0.8 * 1.989e30, // Young star mass
          gravitationalConstant: 6.67430e-11,
          baseColor: '#DDA0DD', // Dusty disk color
          colorVariation: 0.3,
          useXZPlane: true,
          minSize: 0.1,
          maxSize: 2.0,
        );

        expect(protoDisk.innerRadius, equals(0.1 * 149597870.7));
        expect(protoDisk.outerRadius, equals(100 * 149597870.7));
        expect(protoDisk.centralMass, equals(0.8 * 1.989e30));
        expect(protoDisk.baseColor, equals('#DDA0DD'));
      });

      test('Kuiper belt system', () {
        const kuiperBelt = ParticleSystemData(
          enabled: true,
          innerRadius: 30 * 149597870.7, // 30 AU
          outerRadius: 50 * 149597870.7, // 50 AU
          particleCount: 20000,
          centralMass: 1.989e30, // Solar mass
          gravitationalConstant: 6.67430e-11,
          baseColor: '#696969', // Icy object color
          colorVariation: 0.25,
          useXZPlane: false,
          minSize: 0.8,
          maxSize: 3.5,
        );

        expect(kuiperBelt.innerRadius, equals(30 * 149597870.7));
        expect(kuiperBelt.outerRadius, equals(50 * 149597870.7));
        expect(kuiperBelt.particleCount, equals(20000));
        expect(kuiperBelt.baseColor, equals('#696969'));
      });

      test('disabled particle system for clean simulation', () {
        const cleanSimulation = ParticleSystemData(
          enabled: false,
          innerRadius: 0.0,
          outerRadius: 0.0,
          particleCount: 0,
          centralMass: 0.0,
          gravitationalConstant: 0.0,
          baseColor: '#000000',
          colorVariation: 0.0,
          useXZPlane: false,
          minSize: 0.0,
          maxSize: 0.0,
        );

        expect(cleanSimulation.enabled, isFalse);
        expect(cleanSimulation.particleCount, equals(0));
      });
    });

    group('physics validation', () {
      test('validates orbital mechanics parameters', () {
        const realisticSystem = ParticleSystemData(
          enabled: true,
          innerRadius: 100.0,
          outerRadius: 500.0,
          particleCount: 1000,
          centralMass: 1.989e30,
          gravitationalConstant: 6.67430e-11,
          baseColor: '#FFFF00',
          colorVariation: 0.1,
          useXZPlane: false,
          minSize: 0.5,
          maxSize: 1.5,
        );

        // Verify that outer radius is greater than inner radius
        expect(
          realisticSystem.outerRadius,
          greaterThan(realisticSystem.innerRadius),
        );

        // Verify that max size is greater than or equal to min size
        expect(
          realisticSystem.maxSize,
          greaterThanOrEqualTo(realisticSystem.minSize),
        );

        // Verify positive particle count for enabled system
        if (realisticSystem.enabled) {
          expect(realisticSystem.particleCount, greaterThan(0));
          expect(realisticSystem.centralMass, greaterThan(0));
          expect(realisticSystem.gravitationalConstant, greaterThan(0));
        }
      });

      test('handles edge case where inner equals outer radius', () {
        const ringSystem = ParticleSystemData(
          enabled: true,
          innerRadius: 1000.0,
          outerRadius: 1000.0,
          particleCount: 100,
          centralMass: 1e24,
          gravitationalConstant: 1.0,
          baseColor: '#FF0000',
          colorVariation: 0.0,
          useXZPlane: false,
          minSize: 1.0,
          maxSize: 1.0,
        );

        expect(ringSystem.innerRadius, equals(ringSystem.outerRadius));
        expect(ringSystem.minSize, equals(ringSystem.maxSize));
      });
    });
  });
}
