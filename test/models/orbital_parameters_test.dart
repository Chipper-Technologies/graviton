import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/models/orbital_parameters.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void main() {
  group('OrbitalParameters Tests', () {
    test('should create orbital parameters with valid values', () {
      final params = OrbitalParameters(
        center: vm.Vector3(0.0, 0.0, 0.0),
        semiMajorAxis: 1.0,
        semiMinorAxis: 0.8,
        eccentricity: 0.5,
        inclination: 0.0,
        argumentOfPeriapsis: 0.0,
      );

      expect(params.center, equals(vm.Vector3(0.0, 0.0, 0.0)));
      expect(params.semiMajorAxis, equals(1.0));
      expect(params.semiMinorAxis, equals(0.8));
      expect(params.eccentricity, equals(0.5));
      expect(params.inclination, equals(0.0));
      expect(params.argumentOfPeriapsis, equals(0.0));
    });

    test('should handle edge case values', () {
      final params = OrbitalParameters(
        center: vm.Vector3(100.0, -50.0, 25.0),
        semiMajorAxis: 0.1,
        semiMinorAxis: 0.05,
        eccentricity: 1.0,
        inclination: 180.0,
        argumentOfPeriapsis: 360.0,
      );

      expect(params.center.x, equals(100.0));
      expect(params.center.y, equals(-50.0));
      expect(params.center.z, equals(25.0));
      expect(params.semiMajorAxis, equals(0.1));
      expect(params.eccentricity, equals(1.0));
      expect(params.inclination, equals(180.0));
    });

    test('should handle negative values', () {
      final params = OrbitalParameters(
        center: vm.Vector3(-10.0, -20.0, -30.0),
        semiMajorAxis: 0.5,
        semiMinorAxis: 0.3,
        eccentricity: 0.8,
        inclination: -90.0,
        argumentOfPeriapsis: -180.0,
      );

      expect(params.center.x, equals(-10.0));
      expect(params.center.y, equals(-20.0));
      expect(params.center.z, equals(-30.0));
      expect(params.semiMajorAxis, equals(0.5));
      expect(params.eccentricity, equals(0.8));
    });

    test('should create circular orbit parameters', () {
      final params = OrbitalParameters(
        center: vm.Vector3.zero(),
        semiMajorAxis: 2.0,
        semiMinorAxis: 2.0,
        eccentricity: 0.0,
        inclination: 0.0,
        argumentOfPeriapsis: 0.0,
      );

      // Test that circular orbit parameters work
      expect(params.eccentricity, equals(0.0));
      expect(params.semiMajorAxis, equals(params.semiMinorAxis));
      expect(params.semiMajorAxis, greaterThan(0.0));
    });

    test('should handle very large orbital parameters', () {
      final params = OrbitalParameters(
        center: vm.Vector3(1000000.0, 2000000.0, 3000000.0),
        semiMajorAxis: 1000000.0,
        semiMinorAxis: 800000.0,
        eccentricity: 0.99,
        inclination: 45.0,
        argumentOfPeriapsis: 270.0,
      );

      expect(params.center.x, equals(1000000.0));
      expect(params.semiMajorAxis, equals(1000000.0));
      expect(params.eccentricity, equals(0.99));
      expect(params.inclination, equals(45.0));
    });

    test('should handle zero center vector', () {
      final params = OrbitalParameters(
        center: vm.Vector3.zero(),
        semiMajorAxis: 1.0,
        semiMinorAxis: 0.7,
        eccentricity: 0.2,
        inclination: 30.0,
        argumentOfPeriapsis: 90.0,
      );

      expect(params.center.x, equals(0.0));
      expect(params.center.y, equals(0.0));
      expect(params.center.z, equals(0.0));
      expect(params.center.length, equals(0.0));
    });

    test('should handle extreme eccentricity values', () {
      // Parabolic orbit (e = 1.0)
      final parabolic = OrbitalParameters(
        center: vm.Vector3.zero(),
        semiMajorAxis: 1.0,
        semiMinorAxis: 0.0,
        eccentricity: 1.0,
        inclination: 0.0,
        argumentOfPeriapsis: 0.0,
      );

      expect(parabolic.eccentricity, equals(1.0));
      expect(parabolic.semiMinorAxis, equals(0.0));

      // Hyperbolic orbit (e > 1.0)
      final hyperbolic = OrbitalParameters(
        center: vm.Vector3.zero(),
        semiMajorAxis: 1.0,
        semiMinorAxis: 0.0,
        eccentricity: 1.5,
        inclination: 0.0,
        argumentOfPeriapsis: 0.0,
      );

      expect(hyperbolic.eccentricity, greaterThan(1.0));
    });

    test('should handle different inclination angles', () {
      final equatorial = OrbitalParameters(
        center: vm.Vector3.zero(),
        semiMajorAxis: 1.0,
        semiMinorAxis: 0.8,
        eccentricity: 0.3,
        inclination: 0.0,
        argumentOfPeriapsis: 0.0,
      );

      final polar = OrbitalParameters(
        center: vm.Vector3.zero(),
        semiMajorAxis: 1.0,
        semiMinorAxis: 0.8,
        eccentricity: 0.3,
        inclination: 90.0,
        argumentOfPeriapsis: 0.0,
      );

      expect(equatorial.inclination, equals(0.0));
      expect(polar.inclination, equals(90.0));
    });

    test('should preserve vector3 properties', () {
      final center = vm.Vector3(5.0, 10.0, 15.0);
      final params = OrbitalParameters(
        center: center,
        semiMajorAxis: 2.0,
        semiMinorAxis: 1.5,
        eccentricity: 0.4,
        inclination: 60.0,
        argumentOfPeriapsis: 120.0,
      );

      // Test that the vector is properly stored
      expect(params.center.x, equals(5.0));
      expect(params.center.y, equals(10.0));
      expect(params.center.z, equals(15.0));
      expect(params.center.length, closeTo(18.708, 0.001));
    });
  });
}
