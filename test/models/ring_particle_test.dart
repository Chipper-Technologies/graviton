import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/models/ring_particle.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void main() {
  group('RingParticle', () {
    group('constructor and properties', () {
      test('creates particle with required parameters', () {
        const testColor = Colors.blue;
        final particle = RingParticle(
          orbitRadius: 100.0,
          orbitSpeed: 0.5,
          orbitPhase: 0.0,
          inclination: 0.1,
          color: testColor,
          size: 2.0,
        );

        expect(particle.orbitRadius, equals(100.0));
        expect(particle.orbitSpeed, equals(0.5));
        expect(particle.orbitPhase, equals(0.0));
        expect(particle.inclination, equals(0.1));
        expect(particle.color, equals(testColor));
        expect(particle.size, equals(2.0));
        expect(particle.useXZPlane, isFalse);
        expect(particle.position, equals(vm.Vector3.zero()));
      });

      test('creates particle with custom coordinate system', () {
        final particle = RingParticle(
          orbitRadius: 50.0,
          orbitSpeed: 1.0,
          orbitPhase: math.pi,
          inclination: 0.2,
          color: Colors.red,
          size: 3.0,
          useXZPlane: true,
        );

        expect(particle.useXZPlane, isTrue);
        expect(particle.orbitRadius, equals(50.0));
        expect(particle.orbitSpeed, equals(1.0));
        expect(particle.orbitPhase, equals(math.pi));
        expect(particle.inclination, equals(0.2));
        expect(particle.size, equals(3.0));
      });

      test('handles edge case values', () {
        final particle = RingParticle(
          orbitRadius: 0.0,
          orbitSpeed: 0.0,
          orbitPhase: 0.0,
          inclination: 0.0,
          color: Colors.transparent,
          size: 0.0,
        );

        expect(particle.orbitRadius, equals(0.0));
        expect(particle.orbitSpeed, equals(0.0));
        expect(particle.orbitPhase, equals(0.0));
        expect(particle.inclination, equals(0.0));
        expect(particle.color, equals(Colors.transparent));
        expect(particle.size, equals(0.0));
      });

      test('handles very large values', () {
        final particle = RingParticle(
          orbitRadius: 1e6,
          orbitSpeed: 100.0,
          orbitPhase: 10 * math.pi,
          inclination: math.pi / 2,
          color: Colors.white,
          size: 100.0,
        );

        expect(particle.orbitRadius, equals(1e6));
        expect(particle.orbitSpeed, equals(100.0));
        expect(particle.orbitPhase, equals(10 * math.pi));
        expect(particle.inclination, equals(math.pi / 2));
        expect(particle.size, equals(100.0));
      });
    });

    group('update method', () {
      test('updates position correctly in default coordinate system', () {
        final particle = RingParticle(
          orbitRadius: 100.0,
          orbitSpeed: 0.1,
          orbitPhase: 0.0,
          inclination: 0.0,
          color: Colors.blue,
          size: 1.0,
        );

        // Initial position should be at zero
        expect(particle.position, equals(vm.Vector3.zero()));

        // Update with deltaTime = 10 seconds
        particle.update(10.0);

        // Orbital phase should have advanced by orbitSpeed * deltaTime
        expect(particle.orbitPhase, equals(0.1 * 10.0));
        expect(particle.orbitPhase, equals(1.0));

        // Position should be calculated correctly (x = r*cos(phase), y = r*sin(phase))
        final expectedX = 100.0 * math.cos(1.0);
        final expectedY = 100.0 * math.sin(1.0);
        final expectedZ = 100.0 * math.sin(0.0); // inclination = 0

        expect(particle.position.x, closeTo(expectedX, 1e-10));
        expect(particle.position.y, closeTo(expectedY, 1e-10));
        expect(particle.position.z, closeTo(expectedZ, 1e-10));
      });

      test('updates position correctly in XZ plane coordinate system', () {
        final particle = RingParticle(
          orbitRadius: 50.0,
          orbitSpeed: 0.2,
          orbitPhase: 0.0,
          inclination: 0.1,
          color: Colors.green,
          size: 1.0,
          useXZPlane: true,
        );

        // Update with deltaTime = 5 seconds
        particle.update(5.0);

        // Orbital phase should advance
        expect(particle.orbitPhase, equals(0.2 * 5.0));

        // In XZ plane mode: position = (x, z, y) instead of (x, y, z)
        final phase = 1.0; // 0.2 * 5.0
        final expectedX = 50.0 * math.cos(phase);
        final expectedY = 50.0 * math.sin(phase); // Original Y becomes new Z
        final expectedZ = 50.0 * math.sin(0.1); // Original Z becomes new Y

        expect(particle.position.x, closeTo(expectedX, 1e-10));
        expect(particle.position.y, closeTo(expectedZ, 1e-10)); // z mapping
        expect(particle.position.z, closeTo(expectedY, 1e-10)); // y mapping
      });

      test('handles multiple updates correctly', () {
        final particle = RingParticle(
          orbitRadius: 100.0,
          orbitSpeed: 0.1,
          orbitPhase: 0.0,
          inclination: 0.0,
          color: Colors.purple,
          size: 2.0,
        );

        // Update twice with same deltaTime
        particle.update(5.0);
        final firstPhase = particle.orbitPhase;
        final firstPosition = vm.Vector3.copy(particle.position);

        particle.update(5.0);
        final secondPhase = particle.orbitPhase;

        // Phase should accumulate
        expect(firstPhase, equals(0.5));
        expect(secondPhase, equals(1.0));
        expect(secondPhase, equals(firstPhase + 0.5));

        // Position should change
        expect(particle.position, isNot(equals(firstPosition)));
      });

      test('handles zero deltaTime', () {
        final particle = RingParticle(
          orbitRadius: 100.0,
          orbitSpeed: 0.5,
          orbitPhase: math.pi / 4,
          inclination: 0.2,
          color: Colors.orange,
          size: 1.5,
        );

        // First update to establish initial position
        particle.update(0.1);
        final initialPhase = particle.orbitPhase;
        final initialPosition = vm.Vector3.copy(particle.position);

        // Update with zero deltaTime
        particle.update(0.0);

        // Nothing should change
        expect(particle.orbitPhase, equals(initialPhase));
        expect(particle.position, equals(initialPosition));
      });

      test('handles negative deltaTime', () {
        final particle = RingParticle(
          orbitRadius: 80.0,
          orbitSpeed: 0.3,
          orbitPhase: math.pi,
          inclination: 0.1,
          color: Colors.cyan,
          size: 2.5,
        );

        final initialPhase = particle.orbitPhase;

        // Update with negative deltaTime (reverse time)
        particle.update(-10.0);

        // Phase should decrease
        expect(particle.orbitPhase, equals(initialPhase - 0.3 * 10.0));
        expect(particle.orbitPhase, equals(math.pi - 3.0));

        // Position should be calculated correctly for negative phase
        final expectedX = 80.0 * math.cos(math.pi - 3.0);
        final expectedY = 80.0 * math.sin(math.pi - 3.0);
        final expectedZ = 80.0 * math.sin(0.1);

        expect(particle.position.x, closeTo(expectedX, 1e-10));
        expect(particle.position.y, closeTo(expectedY, 1e-10));
        expect(particle.position.z, closeTo(expectedZ, 1e-10));
      });

      test('correctly handles inclination effects', () {
        final particle = RingParticle(
          orbitRadius: 100.0,
          orbitSpeed: 0.0, // No orbital motion to isolate inclination effect
          orbitPhase: 0.0,
          inclination: math.pi / 6, // 30 degrees
          color: Colors.yellow,
          size: 1.0,
        );

        particle.update(1.0); // Small update to calculate position

        // At phase 0, x = radius, y = 0
        expect(particle.position.x, closeTo(100.0, 1e-10));
        expect(particle.position.y, closeTo(0.0, 1e-10));

        // Z should reflect inclination: radius * sin(inclination)
        final expectedZ = 100.0 * math.sin(math.pi / 6);
        expect(particle.position.z, closeTo(expectedZ, 1e-10));
        expect(particle.position.z, closeTo(50.0, 1e-10)); // sin(30°) = 0.5
      });

      test('orbital motion follows circular path', () {
        final particle = RingParticle(
          orbitRadius: 60.0,
          orbitSpeed: 0.1,
          orbitPhase: 0.0,
          inclination: 0.0, // No inclination for simple circular motion
          color: Colors.indigo,
          size: 1.0,
        );

        final positions = <vm.Vector3>[];

        // Collect positions over one full orbit
        for (int i = 0; i < 20; i++) {
          particle.update(math.pi / 10); // Small time steps
          positions.add(vm.Vector3.copy(particle.position));
        }

        // All positions should be at the same distance from origin (circular orbit)
        for (final position in positions) {
          final distance = position.length;
          expect(distance, closeTo(60.0, 1e-8));
        }

        // After full orbit (2π), should return close to starting position
        // Total phase change: 20 * (π/10) * 0.1 = 2π * 0.1 = 0.2π
        // This is not a full orbit, but we can test the pattern
        expect(positions.first.x, greaterThan(0)); // Starts on positive X
      });
    });

    group('realistic ring scenarios', () {
      test('creates Saturn-like ring particle', () {
        final saturnRingParticle = RingParticle(
          orbitRadius: 120000.0, // km from Saturn's center
          orbitSpeed: 0.0001, // Slow orbital speed
          orbitPhase: math.pi / 3,
          inclination: 0.01, // Very slight inclination
          color: const Color(0xFFD4C5A9), // Saturn ring color
          size: 0.5,
          useXZPlane: true, // Horizontal view
        );

        expect(saturnRingParticle.orbitRadius, equals(120000.0));
        expect(saturnRingParticle.color, equals(const Color(0xFFD4C5A9)));
        expect(saturnRingParticle.useXZPlane, isTrue);
      });

      test('creates asteroid belt particle', () {
        final asteroidParticle = RingParticle(
          orbitRadius: 2.7 * 149597870.7, // 2.7 AU in km
          orbitSpeed: 0.00001, // Very slow for distant orbit
          orbitPhase: math.pi * 1.5,
          inclination: 0.05, // 5% inclination
          color: const Color(0xFF8C7853), // Rocky asteroid color
          size: 1.2,
        );

        expect(asteroidParticle.orbitRadius, equals(2.7 * 149597870.7));
        expect(asteroidParticle.color, equals(const Color(0xFF8C7853)));
        expect(asteroidParticle.useXZPlane, isFalse); // Default orbital plane
      });

      test('creates debris ring around planet', () {
        final debrisParticle = RingParticle(
          orbitRadius: 15000.0, // Close to planet surface
          orbitSpeed: 0.01, // Fast orbital speed due to proximity
          orbitPhase: 0.0,
          inclination: 0.0, // Equatorial orbit
          color: Colors.grey.shade300,
          size: 0.3,
        );

        expect(debrisParticle.orbitRadius, equals(15000.0));
        expect(debrisParticle.orbitSpeed, equals(0.01));
        expect(debrisParticle.inclination, equals(0.0));
      });
    });

    group('edge cases and error conditions', () {
      test('handles extremely small orbit radius', () {
        final tinyParticle = RingParticle(
          orbitRadius: 1e-10,
          orbitSpeed: 1.0,
          orbitPhase: 0.0,
          inclination: 0.0,
          color: Colors.red,
          size: 0.1,
        );

        tinyParticle.update(1.0);

        // Should not cause numerical issues
        expect(tinyParticle.position.x.isFinite, isTrue);
        expect(tinyParticle.position.y.isFinite, isTrue);
        expect(tinyParticle.position.z.isFinite, isTrue);
      });

      test('handles extremely large orbit radius', () {
        final hugeParticle = RingParticle(
          orbitRadius: 1e12,
          orbitSpeed: 1e-6,
          orbitPhase: 0.0,
          inclination: 0.0,
          color: Colors.blue,
          size: 10.0,
        );

        hugeParticle.update(1000.0);

        // Should handle large numbers without overflow
        expect(hugeParticle.position.x.isFinite, isTrue);
        expect(hugeParticle.position.y.isFinite, isTrue);
        expect(hugeParticle.position.z.isFinite, isTrue);
      });

      test('handles extreme orbital speed', () {
        final fastParticle = RingParticle(
          orbitRadius: 100.0,
          orbitSpeed: 1000.0,
          orbitPhase: 0.0,
          inclination: 0.0,
          color: Colors.green,
          size: 1.0,
        );

        fastParticle.update(0.1);

        // Should handle rapid orbital motion
        expect(fastParticle.orbitPhase, equals(100.0));
        expect(fastParticle.position.x.isFinite, isTrue);
        expect(fastParticle.position.y.isFinite, isTrue);
      });

      test('handles extreme inclination values', () {
        final inclinedParticle = RingParticle(
          orbitRadius: 100.0,
          orbitSpeed: 0.1,
          orbitPhase: 0.0,
          inclination: math.pi, // 180 degree inclination
          color: Colors.purple,
          size: 1.0,
        );

        inclinedParticle.update(1.0);

        // Should handle extreme inclination
        expect(inclinedParticle.position.x.isFinite, isTrue);
        expect(inclinedParticle.position.y.isFinite, isTrue);
        expect(inclinedParticle.position.z.isFinite, isTrue);

        // Z component should reflect extreme inclination
        final expectedZ = 100.0 * math.sin(math.pi);
        expect(inclinedParticle.position.z, closeTo(expectedZ, 1e-10));
        expect(inclinedParticle.position.z, closeTo(0.0, 1e-10)); // sin(π) ≈ 0
      });
    });

    group('coordinate system transformations', () {
      test('produces different positions in different coordinate systems', () {
        final standardParticle = RingParticle(
          orbitRadius: 100.0,
          orbitSpeed: 0.1,
          orbitPhase: math.pi / 4, // 45 degrees
          inclination: 0.1,
          color: Colors.red,
          size: 1.0,
          useXZPlane: false,
        );

        final xzParticle = RingParticle(
          orbitRadius: 100.0,
          orbitSpeed: 0.1,
          orbitPhase: math.pi / 4, // 45 degrees
          inclination: 0.1,
          color: Colors.red,
          size: 1.0,
          useXZPlane: true,
        );

        standardParticle.update(1.0);
        xzParticle.update(1.0);

        // X components should be the same
        expect(standardParticle.position.x, equals(xzParticle.position.x));

        // Y and Z should be swapped
        expect(standardParticle.position.y, equals(xzParticle.position.z));
        expect(standardParticle.position.z, equals(xzParticle.position.y));
      });
    });
  });
}
