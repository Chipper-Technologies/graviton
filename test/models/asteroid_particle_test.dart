import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/models/asteroid_particle.dart';

void main() {
  group('AsteroidParticle', () {
    group('constructor and properties', () {
      test('creates instance with required properties', () {
        final particle = AsteroidParticle(
          orbitRadius: 100.0,
          orbitSpeed: 0.5,
          orbitPhase: math.pi / 4,
          inclination: 0.1,
          color: Colors.grey,
          size: 2.0,
        );

        expect(particle.orbitRadius, equals(100.0));
        expect(particle.orbitSpeed, equals(0.5));
        expect(particle.orbitPhase, equals(math.pi / 4));
        expect(particle.inclination, equals(0.1));
        expect(particle.color, equals(Colors.grey));
        expect(particle.size, equals(2.0));
        expect(particle.eccentricity, equals(0.0)); // Default value
        expect(particle.useXZPlane, isFalse); // Default value
        expect(
          particle.currentAngle,
          equals(math.pi / 4),
        ); // Initialized to phase
      });

      test('creates instance with all optional properties', () {
        final particle = AsteroidParticle(
          orbitRadius: 150.0,
          orbitSpeed: 1.2,
          orbitPhase: math.pi / 2,
          inclination: 0.2,
          color: Colors.orange,
          size: 5.0,
          eccentricity: 0.3,
          useXZPlane: true,
        );

        expect(particle.eccentricity, equals(0.3));
        expect(particle.useXZPlane, isTrue);
      });

      test('handles zero values correctly', () {
        final particle = AsteroidParticle(
          orbitRadius: 0.0,
          orbitSpeed: 0.0,
          orbitPhase: 0.0,
          inclination: 0.0,
          color: Colors.black,
          size: 0.0,
        );

        expect(particle.orbitRadius, equals(0.0));
        expect(particle.orbitSpeed, equals(0.0));
        expect(particle.orbitPhase, equals(0.0));
        expect(particle.inclination, equals(0.0));
        expect(particle.currentAngle, equals(0.0));
      });

      test('handles large values correctly', () {
        final particle = AsteroidParticle(
          orbitRadius: 1e6,
          orbitSpeed: 100.0,
          orbitPhase: 10 * math.pi,
          inclination: math.pi,
          color: Colors.white,
          size: 1000.0,
          eccentricity: 0.99,
        );

        expect(particle.orbitRadius, equals(1e6));
        expect(particle.orbitSpeed, equals(100.0));
        expect(particle.eccentricity, equals(0.99));
      });
    });

    group('position calculation', () {
      test('calculates correct position for circular orbit in XY plane', () {
        final particle = AsteroidParticle(
          orbitRadius: 100.0,
          orbitSpeed: 0.0, // No movement for static test
          orbitPhase: 0.0, // Start at angle 0
          inclination: 0.0,
          color: Colors.grey,
          size: 1.0,
          eccentricity: 0.0,
          useXZPlane: false, // XY plane
        );

        final position = particle.position;
        expect(position.x, closeTo(100.0, 1e-10));
        expect(position.y, closeTo(0.0, 1e-10));
        expect(position.z, closeTo(0.0, 1e-10));
      });

      test('calculates correct position for circular orbit in XZ plane', () {
        final particle = AsteroidParticle(
          orbitRadius: 100.0,
          orbitSpeed: 0.0,
          orbitPhase: 0.0,
          inclination: 0.0,
          color: Colors.grey,
          size: 1.0,
          eccentricity: 0.0,
          useXZPlane: true, // XZ plane
        );

        final position = particle.position;
        expect(position.x, closeTo(100.0, 1e-10));
        expect(position.y, closeTo(0.0, 1e-10));
        expect(position.z, closeTo(0.0, 1e-10));
      });

      test('calculates correct position for different orbital phases', () {
        // Test at 90 degrees (π/2)
        final particle = AsteroidParticle(
          orbitRadius: 100.0,
          orbitSpeed: 0.0,
          orbitPhase: math.pi / 2,
          inclination: 0.0,
          color: Colors.grey,
          size: 1.0,
          useXZPlane: false, // XY plane
        );

        final position = particle.position;
        expect(position.x, closeTo(0.0, 1e-10));
        expect(position.y, closeTo(100.0, 1e-10));
        expect(position.z, closeTo(0.0, 1e-10));
      });

      test('calculates correct elliptical orbit positions', () {
        final particle = AsteroidParticle(
          orbitRadius: 100.0,
          orbitSpeed: 0.0,
          orbitPhase: 0.0,
          inclination: 0.0,
          color: Colors.grey,
          size: 1.0,
          eccentricity: 0.5, // Elliptical orbit
          useXZPlane: false,
        );

        final position = particle.position;
        // At angle 0, radius = orbitRadius * (1 - eccentricity * cos(0))
        // = 100 * (1 - 0.5 * 1) = 100 * 0.5 = 50
        expect(position.x, closeTo(50.0, 1e-10));
        expect(position.y, closeTo(0.0, 1e-10));
        expect(position.z, closeTo(0.0, 1e-10));
      });

      test('applies inclination correctly for XY plane', () {
        final inclination = math.pi / 4; // 45 degrees
        final particle = AsteroidParticle(
          orbitRadius: 100.0,
          orbitSpeed: 0.0,
          orbitPhase: math.pi / 2, // Start at Y position
          inclination: inclination,
          color: Colors.grey,
          size: 1.0,
          useXZPlane: false, // XY plane
        );

        final position = particle.position;
        expect(position.x, closeTo(0.0, 1e-10)); // X unchanged
        // Y and Z rotated by inclination
        expect(position.y, closeTo(100.0 * math.cos(inclination), 1e-10));
        expect(position.z, closeTo(100.0 * math.sin(inclination), 1e-10));
      });

      test('applies inclination correctly for XZ plane', () {
        final inclination = math.pi / 4; // 45 degrees
        final particle = AsteroidParticle(
          orbitRadius: 100.0,
          orbitSpeed: 0.0,
          orbitPhase: math.pi / 2, // Start at Z position
          inclination: inclination,
          color: Colors.grey,
          size: 1.0,
          useXZPlane: true, // XZ plane
        );

        final position = particle.position;
        expect(position.x, closeTo(0.0, 1e-10)); // X unchanged
        expect(position.y, closeTo(100.0 * math.sin(inclination), 1e-10));
        expect(position.z, closeTo(100.0 * math.cos(inclination), 1e-10));
      });
    });

    group('update method', () {
      test('updates angle correctly with positive delta time', () {
        final particle = AsteroidParticle(
          orbitRadius: 100.0,
          orbitSpeed: 1.0, // 1 radian per time unit
          orbitPhase: 0.0,
          inclination: 0.0,
          color: Colors.grey,
          size: 1.0,
        );

        expect(particle.currentAngle, equals(0.0));

        particle.update(1.0); // 1 time unit
        expect(particle.currentAngle, closeTo(1.0, 1e-10));

        particle.update(0.5); // 0.5 time units
        expect(particle.currentAngle, closeTo(1.5, 1e-10));
      });

      test('handles angle wrapping correctly', () {
        final particle = AsteroidParticle(
          orbitRadius: 100.0,
          orbitSpeed: 1.0,
          orbitPhase: 2 * math.pi - 0.1, // Near 2π
          inclination: 0.0,
          color: Colors.grey,
          size: 1.0,
        );

        particle.update(0.2); // Should wrap around
        expect(particle.currentAngle, closeTo(0.1, 1e-10));
      });

      test('handles multiple complete revolutions', () {
        final particle = AsteroidParticle(
          orbitRadius: 100.0,
          orbitSpeed: 1.0,
          orbitPhase: 0.0,
          inclination: 0.0,
          color: Colors.grey,
          size: 1.0,
        );

        particle.update(4 * math.pi); // Two complete revolutions
        expect(particle.currentAngle, closeTo(0.0, 1e-10));
      });

      test('handles zero delta time', () {
        final particle = AsteroidParticle(
          orbitRadius: 100.0,
          orbitSpeed: 1.0,
          orbitPhase: 1.0,
          inclination: 0.0,
          color: Colors.grey,
          size: 1.0,
        );

        final initialAngle = particle.currentAngle;
        particle.update(0.0);
        expect(particle.currentAngle, equals(initialAngle));
      });

      test('handles negative delta time', () {
        final particle = AsteroidParticle(
          orbitRadius: 100.0,
          orbitSpeed: 1.0,
          orbitPhase: 1.0,
          inclination: 0.0,
          color: Colors.grey,
          size: 1.0,
        );

        particle.update(-0.5); // Negative time
        expect(particle.currentAngle, closeTo(0.5, 1e-10));
      });

      test('changes position correctly over time', () {
        final particle = AsteroidParticle(
          orbitRadius: 100.0,
          orbitSpeed: 1.0,
          orbitPhase: 0.0,
          inclination: 0.0,
          color: Colors.grey,
          size: 1.0,
          useXZPlane: false,
        );

        final initialPosition = particle.position;
        expect(initialPosition.x, closeTo(100.0, 1e-10));
        expect(initialPosition.y, closeTo(0.0, 1e-10));

        particle.update(math.pi / 2); // Quarter revolution
        final quarterPosition = particle.position;
        expect(quarterPosition.x, closeTo(0.0, 1e-10));
        expect(quarterPosition.y, closeTo(100.0, 1e-10));
      });
    });

    group('orbit mechanics', () {
      test('maintains consistent orbital radius for circular orbit', () {
        final particle = AsteroidParticle(
          orbitRadius: 150.0,
          orbitSpeed: 0.5,
          orbitPhase: 0.0,
          inclination: 0.0,
          color: Colors.grey,
          size: 1.0,
          eccentricity: 0.0, // Circular
          useXZPlane: false,
        );

        // Test at multiple points in orbit
        final angles = [
          0.0,
          math.pi / 4,
          math.pi / 2,
          math.pi,
          3 * math.pi / 2,
        ];
        for (final targetAngle in angles) {
          particle.update(targetAngle - particle.currentAngle);
          final position = particle.position;
          final distance = position.length;
          expect(
            distance,
            closeTo(150.0, 1e-10),
            reason:
                'Distance should be constant for circular orbit at angle $targetAngle',
          );
        }
      });

      test('varies radius correctly for elliptical orbit', () {
        final particle = AsteroidParticle(
          orbitRadius: 100.0,
          orbitSpeed: 1.0, // 1 radian per time unit
          orbitPhase: 0.0,
          inclination: 0.0,
          color: Colors.grey,
          size: 1.0,
          eccentricity: 0.5, // Elliptical
          useXZPlane: false,
        );

        // At angle = 0: r = a(1 - e*cos(0)) = 100(1 - 0.5*1) = 50
        expect(particle.position.length, closeTo(50.0, 1e-10));

        // Update by π radians to get to angle = π
        // At angle = π: r = a(1 - e*cos(π)) = 100(1 - 0.5*(-1)) = 150
        particle.update(math.pi);
        expect(particle.position.length, closeTo(150.0, 1e-10));
      });

      test('handles high eccentricity values', () {
        final particle = AsteroidParticle(
          orbitRadius: 100.0,
          orbitSpeed: 1.0, // 1 radian per time unit
          orbitPhase: 0.0,
          inclination: 0.0,
          color: Colors.grey,
          size: 1.0,
          eccentricity: 0.99, // Very elliptical
          useXZPlane: false,
        );

        // At angle = 0: r = a(1 - e*cos(0)) = 100(1 - 0.99*1) = 1.0
        expect(particle.position.length, closeTo(1.0, 1e-10));

        // Update by π radians to get to angle = π
        // At angle = π: r = a(1 - e*cos(π)) = 100(1 - 0.99*(-1)) = 199.0
        particle.update(math.pi);
        expect(particle.position.length, closeTo(199.0, 1e-10));
      });
    });

    group('edge cases and validation', () {
      test('handles very small orbit radius', () {
        final particle = AsteroidParticle(
          orbitRadius: 1e-10,
          orbitSpeed: 1.0,
          orbitPhase: 0.0,
          inclination: 0.0,
          color: Colors.grey,
          size: 1.0,
        );

        final position = particle.position;
        expect(position.length, closeTo(1e-10, 1e-15));
        expect(position.x.isFinite, isTrue);
        expect(position.y.isFinite, isTrue);
        expect(position.z.isFinite, isTrue);
      });

      test('handles very large orbit radius', () {
        final particle = AsteroidParticle(
          orbitRadius: 1e10,
          orbitSpeed: 1.0,
          orbitPhase: 0.0,
          inclination: 0.0,
          color: Colors.grey,
          size: 1.0,
        );

        final position = particle.position;
        expect(position.length, closeTo(1e10, 1e5));
        expect(position.x.isFinite, isTrue);
        expect(position.y.isFinite, isTrue);
        expect(position.z.isFinite, isTrue);
      });

      test('handles extreme inclination values', () {
        final particle = AsteroidParticle(
          orbitRadius: 100.0,
          orbitSpeed: 0.0,
          orbitPhase: math.pi / 2,
          inclination: math.pi, // 180 degrees
          color: Colors.grey,
          size: 1.0,
          useXZPlane: false,
        );

        final position = particle.position;
        expect(position.x, closeTo(0.0, 1e-10));
        expect(position.y, closeTo(-100.0, 1e-10)); // Flipped
        expect(position.z, closeTo(0.0, 1e-10));
      });

      test('validates all components are finite', () {
        final particle = AsteroidParticle(
          orbitRadius: 100.0,
          orbitSpeed: 1.0,
          orbitPhase: 0.0,
          inclination: 0.1,
          color: Colors.grey,
          size: 1.0,
          eccentricity: 0.3,
        );

        particle.update(1.5);
        final position = particle.position;

        expect(position.x.isFinite, isTrue);
        expect(position.y.isFinite, isTrue);
        expect(position.z.isFinite, isTrue);
        expect(particle.currentAngle.isFinite, isTrue);
      });
    });

    group('realistic asteroid scenarios', () {
      test('main belt asteroid particle', () {
        // Typical main belt asteroid parameters
        final particle = AsteroidParticle(
          orbitRadius: 2.7 * 149597870.7, // 2.7 AU in km
          orbitSpeed: 0.000018, // ~5 year orbital period
          orbitPhase: 0.5 * 2 * math.pi, // Random-ish phase
          inclination: 0.087, // ~5 degrees typical inclination
          color: Colors.grey[600]!,
          size: 1.5,
          eccentricity: 0.15, // Moderate eccentricity
          useXZPlane: true, // Solar system view
        );

        // Test realistic behavior
        final initialPosition = particle.position;
        expect(initialPosition.length, greaterThan(2.0 * 149597870.7));
        expect(initialPosition.length, lessThan(3.5 * 149597870.7));

        // Simulate one day of motion
        particle.update(86400.0); // 1 day in seconds
        final updatedPosition = particle.position;

        expect(updatedPosition.x.isFinite, isTrue);
        expect(updatedPosition.y.isFinite, isTrue);
        expect(updatedPosition.z.isFinite, isTrue);
      });

      test('trojan asteroid particle', () {
        // Jupiter trojan at L4/L5 point
        final particle = AsteroidParticle(
          orbitRadius: 5.2 * 149597870.7, // Jupiter's distance
          orbitSpeed: 0.000005, // ~12 year orbital period
          orbitPhase: math.pi / 3, // 60 degrees offset (L4)
          inclination: 0.262, // ~15 degrees higher inclination
          color: Colors.brown[400]!,
          size: 2.0,
          eccentricity: 0.05, // Low eccentricity
          useXZPlane: true,
        );

        final position = particle.position;
        final expectedRadius = 5.2 * 149597870.7;
        // Expected radius with eccentricity at 60 degrees: r = a(1 - e*cos(π/3)) = a(1 - 0.05*0.5)
        final adjustedRadius =
            expectedRadius * (1 - 0.05 * math.cos(math.pi / 3));
        expect(position.length, closeTo(adjustedRadius, 1e6));
      });
    });
  });
}
