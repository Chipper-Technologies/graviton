import 'dart:math' as math;
import 'package:flutter_test/flutter_test.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

import 'package:graviton/services/orbital_mechanics_service.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/enums/habitability_status.dart';
import 'package:graviton/constants/simulation_constants.dart';
import 'package:flutter/material.dart';

void main() {
  group('OrbitalMechanicsService', () {
    late Body centralSun;
    late Body testPlanet;

    setUp(() {
      // Create a Sun-like central body at origin
      centralSun = Body(
        name: 'Central Sun',
        position: vm.Vector3.zero(),
        velocity: vm.Vector3.zero(),
        mass: 10.0, // Use simulation mass units
        radius: 1.5,
        color: Colors.yellow,
        bodyType: BodyType.star,
        stellarLuminosity: 1.0,
        temperature: 5778.0,
        habitabilityStatus: HabitabilityStatus.unknown,
      );

      // Create an Earth-like test planet
      testPlanet = Body(
        name: 'Test Planet',
        position: vm.Vector3(1.0, 0.0, 0.0),
        velocity: vm.Vector3(0.0, 0.0, 1.0),
        mass: 1.0, // Use simulation mass units
        radius: 0.5,
        color: Colors.blue,
        bodyType: BodyType.planet,
        temperature: 288.0,
        habitabilityStatus: HabitabilityStatus.habitable,
      );
    });

    group('calculateCircularOrbit', () {
      test('calculates correct orbital velocity for circular orbit', () {
        const double orbitRadius = 20.0; // Simulation units
        const double orbitPhase = 0.0; // Start at positive X-axis

        final placement = OrbitalMechanicsService.calculateCircularOrbit(
          centralBody: centralSun,
          orbitRadius: orbitRadius,
          orbitPhase: orbitPhase,
        );

        // Calculate expected orbital speed: v = sqrt(GM/r)
        final expectedSpeed = math.sqrt(
          SimulationConstants.gravitationalConstant *
              centralSun.mass /
              orbitRadius,
        );

        expect(placement.position.x, closeTo(orbitRadius, 1e-6));
        expect(placement.position.y, closeTo(0.0, 1e-6));
        expect(placement.position.z, closeTo(0.0, 1e-6));

        // Velocity should be perpendicular to position (tangential)
        expect(placement.velocity.x, closeTo(0.0, 1e-6));
        expect(placement.velocity.z, closeTo(expectedSpeed, 1e-3));

        // Test orbital period calculation
        final calculatedPeriod = placement.orbitalPeriod;
        final expectedPeriod =
            2 *
            math.pi *
            math.sqrt(
              math.pow(orbitRadius, 3) /
                  (SimulationConstants.gravitationalConstant * centralSun.mass),
            );

        expect(calculatedPeriod, closeTo(expectedPeriod, 0.1));
      });

      test('calculates correct position for different orbital phases', () {
        const double orbitRadius = 10.0;

        // Test at 0 degrees (positive X-axis)
        var placement = OrbitalMechanicsService.calculateCircularOrbit(
          centralBody: centralSun,
          orbitRadius: orbitRadius,
          orbitPhase: 0.0,
        );
        expect(placement.position.x, closeTo(orbitRadius, 1e-6));
        expect(placement.position.z, closeTo(0.0, 1e-6));

        // Test at 90 degrees (positive Z-axis)
        placement = OrbitalMechanicsService.calculateCircularOrbit(
          centralBody: centralSun,
          orbitRadius: orbitRadius,
          orbitPhase: math.pi / 2,
        );
        expect(placement.position.x, closeTo(0.0, 1e-6));
        expect(placement.position.z, closeTo(orbitRadius, 1e-6));

        // Test at 180 degrees (negative X-axis)
        placement = OrbitalMechanicsService.calculateCircularOrbit(
          centralBody: centralSun,
          orbitRadius: orbitRadius,
          orbitPhase: math.pi,
        );
        expect(placement.position.x, closeTo(-orbitRadius, 1e-6));
        expect(placement.position.z, closeTo(0.0, 1e-6));
      });

      test('applies orbital inclination correctly', () {
        const double orbitRadius = 10.0;
        const double inclination = math.pi / 4; // 45 degrees

        final placement = OrbitalMechanicsService.calculateCircularOrbit(
          centralBody: centralSun,
          orbitRadius: orbitRadius,
          orbitPhase: math.pi / 2, // Start at positive Z in orbital plane
          inclination: inclination,
        );

        // At 45 degree inclination, Z component should be split between Y and Z
        final expectedY = -orbitRadius * math.sin(inclination);
        final expectedZ = orbitRadius * math.cos(inclination);

        expect(placement.position.y, closeTo(expectedY, 1e-6));
        expect(placement.position.z, closeTo(expectedZ, 1e-6));
      });

      test('maintains orbital energy conservation', () {
        const double orbitRadius = 20.0;

        final placement = OrbitalMechanicsService.calculateCircularOrbit(
          centralBody: centralSun,
          orbitRadius: orbitRadius,
          orbitPhase: 0.0,
        );

        // Calculate orbital energy: E = -GMm/(2r) for circular orbits
        final kineticEnergy =
            0.5 * testPlanet.mass * placement.velocity.length2;
        final potentialEnergy =
            -SimulationConstants.gravitationalConstant *
            centralSun.mass *
            testPlanet.mass /
            orbitRadius;
        final totalEnergy = kineticEnergy + potentialEnergy;

        // For circular orbits: E = -GMm/(2r)
        final expectedEnergy =
            -SimulationConstants.gravitationalConstant *
            centralSun.mass *
            testPlanet.mass /
            (2 * orbitRadius);

        // Use appropriate tolerance for floating-point precision
        // Allow for small numerical errors in calculations
        expect(totalEnergy, closeTo(expectedEnergy, 1e-10));
      });

      test('handles central body with non-zero position', () {
        // Move central body away from origin
        final offsetCentralBody = Body(
          name: 'Offset Sun',
          position: vm.Vector3(5.0, 2.5, -3.0),
          velocity: vm.Vector3(0.5, 0.0, 0.2),
          mass: centralSun.mass,
          radius: centralSun.radius,
          color: centralSun.color,
          bodyType: centralSun.bodyType,
          stellarLuminosity: centralSun.stellarLuminosity,
          temperature: centralSun.temperature,
          habitabilityStatus: centralSun.habitabilityStatus,
        );

        const double orbitRadius = 10.0;

        final placement = OrbitalMechanicsService.calculateCircularOrbit(
          centralBody: offsetCentralBody,
          orbitRadius: orbitRadius,
          orbitPhase: 0.0,
        );

        // Position should be offset by central body's position
        expect(
          placement.position.x,
          closeTo(offsetCentralBody.position.x + orbitRadius, 1e-6),
        );
        expect(
          placement.position.y,
          closeTo(offsetCentralBody.position.y, 1e-6),
        );
        expect(
          placement.position.z,
          closeTo(offsetCentralBody.position.z, 1e-6),
        );

        // Velocity should include central body's velocity
        expect(
          placement.velocity.x,
          closeTo(offsetCentralBody.velocity.x, 1e-6),
        );
      });

      test('calculates safe orbit radius correctly', () {
        final safeRadius = OrbitalMechanicsService.calculateSafeOrbitRadius(
          centralSun,
          testPlanet,
        );

        // Safe radius should be significantly larger than both bodies
        expect(safeRadius, greaterThan(centralSun.radius + testPlanet.radius));
        expect(safeRadius, greaterThan(centralSun.radius * 2));
      });

      test('throws error for invalid parameters', () {
        expect(
          () => OrbitalMechanicsService.calculateCircularOrbit(
            centralBody: centralSun,
            orbitRadius: -1.0, // Negative radius
            orbitPhase: 0.0,
          ),
          throwsArgumentError,
        );

        expect(
          () => OrbitalMechanicsService.calculateCircularOrbit(
            centralBody: centralSun,
            orbitRadius: centralSun.radius * 0.5, // Inside central body
            orbitPhase: 0.0,
          ),
          throwsArgumentError,
        );
      });
    });

    group('calculateEllipticalOrbit', () {
      test('calculates correct elliptical orbit parameters', () {
        const double semiMajorAxis = 20.0;
        const double eccentricity = 0.2;
        const double trueAnomaly = 0.0;

        final placement = OrbitalMechanicsService.calculateEllipticalOrbit(
          centralBody: centralSun,
          semiMajorAxis: semiMajorAxis,
          eccentricity: eccentricity,
          orbitPhase: trueAnomaly,
        );

        // At perihelion (trueAnomaly = 0), distance should be a(1-e)
        final expectedDistance = semiMajorAxis * (1 - eccentricity);
        final actualDistance = placement.position.length;

        expect(actualDistance, closeTo(expectedDistance, 1e-3));
      });

      test('reduces to circular orbit when eccentricity is zero', () {
        const double orbitRadius = 15.0;

        final ellipticalPlacement =
            OrbitalMechanicsService.calculateEllipticalOrbit(
              centralBody: centralSun,
              semiMajorAxis: orbitRadius,
              eccentricity: 0.0,
              orbitPhase: 0.0,
            );

        final circularPlacement =
            OrbitalMechanicsService.calculateCircularOrbit(
              centralBody: centralSun,
              orbitRadius: orbitRadius,
              orbitPhase: 0.0,
            );

        expect(
          ellipticalPlacement.position.length,
          closeTo(circularPlacement.position.length, 1e-6),
        );
        expect(
          ellipticalPlacement.velocity.length,
          closeTo(circularPlacement.velocity.length, 1e-3),
        );
      });
    });

    group('OrbitalPlacement', () {
      test('calculates orbital period correctly', () {
        const double orbitRadius = 20.0;

        final placement = OrbitalMechanicsService.calculateCircularOrbit(
          centralBody: centralSun,
          orbitRadius: orbitRadius,
          orbitPhase: 0.0,
        );

        final expectedPeriod =
            2 *
            math.pi *
            math.sqrt(
              math.pow(orbitRadius, 3) /
                  (SimulationConstants.gravitationalConstant * centralSun.mass),
            );

        expect(placement.orbitalPeriod, closeTo(expectedPeriod, 0.1));
      });

      test('provides orbital period in days correctly', () {
        const double orbitRadius = 20.0;

        final placement = OrbitalMechanicsService.calculateCircularOrbit(
          centralBody: centralSun,
          orbitRadius: orbitRadius,
          orbitPhase: 0.0,
        );

        expect(placement.orbitalPeriodInDays, greaterThan(0));
      });

      test('identifies circular vs eccentric orbits', () {
        // Test circular orbit
        final circularPlacement =
            OrbitalMechanicsService.calculateCircularOrbit(
              centralBody: centralSun,
              orbitRadius: 15.0,
              orbitPhase: 0.0,
            );

        expect(circularPlacement.isCircular, isTrue);
        expect(circularPlacement.isHighlyEccentric, isFalse);

        // Test eccentric orbit
        final eccentricPlacement =
            OrbitalMechanicsService.calculateEllipticalOrbit(
              centralBody: centralSun,
              semiMajorAxis: 15.0,
              eccentricity: 0.7,
              orbitPhase: 0.0,
            );

        expect(eccentricPlacement.isCircular, isFalse);
        expect(eccentricPlacement.isHighlyEccentric, isTrue);
      });
    });
  });
}
