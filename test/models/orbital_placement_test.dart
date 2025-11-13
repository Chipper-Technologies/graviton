import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/models/orbital_placement.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void main() {
  group('OrbitalPlacement', () {
    late OrbitalPlacement testPlacement;

    setUp(() {
      testPlacement = OrbitalPlacement(
        position: vm.Vector3(1.0, 2.0, 3.0),
        velocity: vm.Vector3(0.5, 0.7, 0.1),
        orbitRadius: 10.0,
        orbitalPeriod: 86400.0, // 1 day in seconds
        eccentricity: 0.1,
        inclination: 0.2,
      );
    });

    group('constructor and properties', () {
      test('creates instance with all required properties', () {
        expect(testPlacement.position.x, equals(1.0));
        expect(testPlacement.position.y, equals(2.0));
        expect(testPlacement.position.z, equals(3.0));
        expect(testPlacement.velocity.x, equals(0.5));
        expect(testPlacement.velocity.y, equals(0.7));
        expect(testPlacement.velocity.z, equals(0.1));
        expect(testPlacement.orbitRadius, equals(10.0));
        expect(testPlacement.orbitalPeriod, equals(86400.0));
        expect(testPlacement.eccentricity, equals(0.1));
        expect(testPlacement.inclination, equals(0.2));
      });

      test('handles zero position vector', () {
        final placement = OrbitalPlacement(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3(1.0, 0.0, 0.0),
          orbitRadius: 5.0,
          orbitalPeriod: 1000.0,
          eccentricity: 0.0,
          inclination: 0.0,
        );

        expect(placement.position.x, equals(0.0));
        expect(placement.position.y, equals(0.0));
        expect(placement.position.z, equals(0.0));
      });

      test('handles zero velocity vector', () {
        final placement = OrbitalPlacement(
          position: vm.Vector3(1.0, 0.0, 0.0),
          velocity: vm.Vector3.zero(),
          orbitRadius: 5.0,
          orbitalPeriod: 1000.0,
          eccentricity: 0.0,
          inclination: 0.0,
        );

        expect(placement.velocity.x, equals(0.0));
        expect(placement.velocity.y, equals(0.0));
        expect(placement.velocity.z, equals(0.0));
      });

      test('handles large coordinate values', () {
        final placement = OrbitalPlacement(
          position: vm.Vector3(1e6, 1e6, 1e6),
          velocity: vm.Vector3(1e3, 1e3, 1e3),
          orbitRadius: 1e8,
          orbitalPeriod: 1e6,
          eccentricity: 0.5,
          inclination: 90.0,
        );

        expect(placement.position.x, equals(1e6));
        expect(placement.velocity.x, equals(1e3));
        expect(placement.orbitRadius, equals(1e8));
        expect(placement.orbitalPeriod, equals(1e6));
      });
    });

    group('orbital mechanics properties', () {
      test('handles circular orbit (zero eccentricity)', () {
        final placement = OrbitalPlacement(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          orbitRadius: 1.0,
          orbitalPeriod: 100.0,
          eccentricity: 0.0,
          inclination: 0.0,
        );

        expect(placement.eccentricity, equals(0.0));
        expect(placement.isCircular, isTrue);
      });

      test('detects highly eccentric orbit', () {
        final placement = OrbitalPlacement(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          orbitRadius: 1.0,
          orbitalPeriod: 100.0,
          eccentricity: 0.9,
          inclination: 0.0,
        );

        expect(placement.eccentricity, equals(0.9));
        expect(placement.isHighlyEccentric, isTrue);
      });

      test('orbital period in days conversion', () {
        final placement = OrbitalPlacement(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          orbitRadius: 1.0,
          orbitalPeriod: 86400.0, // 1 day in seconds
          eccentricity: 0.1,
          inclination: 0.0,
        );

        expect(placement.orbitalPeriodInDays, closeTo(1.0, 1e-10));
      });

      test('orbital period in days for year-long orbit', () {
        final placement = OrbitalPlacement(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          orbitRadius: 1.0,
          orbitalPeriod: 86400.0 * 365.25, // 1 year in seconds
          eccentricity: 0.017, // Earth's eccentricity
          inclination: 23.44, // Earth's axial tilt
        );

        expect(placement.orbitalPeriodInDays, closeTo(365.25, 1e-10));
      });

      test('handles extreme orbital periods', () {
        final placement = OrbitalPlacement(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          orbitRadius: 1.0,
          orbitalPeriod: 1e10, // Very long period
          eccentricity: 0.1,
          inclination: 0.0,
        );

        expect(placement.orbitalPeriodInDays.isFinite, isTrue);
        expect(placement.orbitalPeriodInDays, greaterThan(0));
      });
    });

    group('realistic orbital scenarios', () {
      test('Earth-like orbital parameters', () {
        final placement = OrbitalPlacement(
          position: vm.Vector3(149597870.7, 0.0, 0.0), // 1 AU in km
          velocity: vm.Vector3(0.0, 29780.0, 0.0), // Earth orbital velocity m/s
          orbitRadius: 149597870.7, // 1 AU
          orbitalPeriod: 86400.0 * 365.25, // 1 year
          eccentricity: 0.0167, // Earth's actual eccentricity
          inclination: 0.0, // Ecliptic plane
        );

        expect(
          placement.isCircular,
          isFalse,
        ); // Earth orbit is slightly elliptical
        expect(placement.isHighlyEccentric, isFalse);
        expect(placement.orbitalPeriodInDays, closeTo(365.25, 1e-10));
        expect(placement.eccentricity, closeTo(0.0167, 1e-4));
      });

      test('Mars-like orbital parameters', () {
        final placement = OrbitalPlacement(
          position: vm.Vector3(227943824.0, 0.0, 0.0), // Mars average distance
          velocity: vm.Vector3(0.0, 24007.0, 0.0), // Mars orbital velocity m/s
          orbitRadius: 227943824.0, // Mars semi-major axis
          orbitalPeriod: 86400.0 * 686.98, // Mars orbital period
          eccentricity: 0.0934, // Mars eccentricity
          inclination: 1.85, // Mars orbital inclination
        );

        expect(placement.isCircular, isFalse);
        expect(placement.isHighlyEccentric, isFalse);
        expect(placement.orbitalPeriodInDays, closeTo(686.98, 1e-10));
        expect(placement.eccentricity, closeTo(0.0934, 1e-4));
      });

      test('Halley comet-like highly eccentric orbit', () {
        final placement = OrbitalPlacement(
          position: vm.Vector3(5906376200.0, 0.0, 0.0), // Aphelion distance
          velocity: vm.Vector3(0.0, 544.0, 0.0), // Very slow at aphelion
          orbitRadius: 2667950000.0, // Semi-major axis
          orbitalPeriod: 86400.0 * 365.25 * 75.3, // ~75 years
          eccentricity: 0.967, // Very eccentric
          inclination: 162.3, // Retrograde orbit
        );

        expect(placement.isHighlyEccentric, isTrue);
        expect(placement.isCircular, isFalse);
        expect(placement.eccentricity, greaterThan(0.9));
      });
    });
  });
}
