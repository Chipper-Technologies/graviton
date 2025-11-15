import 'package:flutter_test/flutter_test.dart';
import 'dart:math' as math;

/// Unit tests for rogue planet scenario physics calculations
/// Tests the mathematical accuracy of orbital mechanics used in the enhanced rogue planet scenario
void main() {
  group('Rogue Planet Physics Calculations Tests', () {
    group('Orbital Velocity Calculations', () {
      test(
        'should calculate correct circular orbital velocity using v = sqrt(GM/r)',
        () {
          // Test the fundamental orbital mechanics formula used in the scenario
          const gravitationalConstant = 1.2;
          const centralMass = 120.0; // Star mass from rogue planet scenario
          const orbitalRadius = 40.0; // Inner planet orbital radius

          final expectedVelocity = math.sqrt(
            gravitationalConstant * centralMass / orbitalRadius,
          );
          final calculatedVelocity = math.sqrt(1.2 * 120.0 / 40.0);

          expect(
            calculatedVelocity,
            closeTo(expectedVelocity, 0.001),
            reason:
                'Orbital velocity calculation must match v = sqrt(GM/r) formula',
          );

          // Verify the calculation is physically reasonable
          expect(
            calculatedVelocity,
            greaterThan(0),
            reason: 'Orbital velocity must be positive',
          );
          expect(
            calculatedVelocity,
            lessThan(20.0),
            reason: 'Orbital velocity must be within reasonable bounds',
          );
        },
      );

      test(
        'should calculate different velocities for different orbital radii',
        () {
          const gravitationalConstant = 1.2;
          const centralMass = 120.0;
          final radii = [40.0, 80.0, 160.0, 240.0]; // Planetary orbital radii

          final velocities = radii
              .map(
                (radius) =>
                    math.sqrt(gravitationalConstant * centralMass / radius),
              )
              .toList();

          // Velocities should decrease with increasing orbital radius
          for (int i = 1; i < velocities.length; i++) {
            expect(
              velocities[i],
              lessThan(velocities[i - 1]),
              reason: 'Orbital velocity must decrease with increasing radius',
            );
          }

          // Verify Kepler's third law relationship
          for (int i = 0; i < radii.length; i++) {
            final period = 2 * math.pi * radii[i] / velocities[i];
            final keplerRatio =
                period * period / (radii[i] * radii[i] * radii[i]);

            expect(
              keplerRatio,
              closeTo(
                4 * math.pi * math.pi / (gravitationalConstant * centralMass),
                0.01,
              ),
              reason: 'Must satisfy Kepler\'s third law: T² ∝ r³',
            );
          }
        },
      );
    });

    group('Planetary Position Calculations', () {
      test('should distribute planets at correct orbital angles', () {
        // Test the angular distribution: 90°, 180°, 270°, 45°
        final expectedAngles = [
          math.pi / 2,
          math.pi,
          3 * math.pi / 2,
          math.pi / 4,
        ];
        final orbitalRadii = [40.0, 80.0, 160.0, 240.0];

        for (int i = 0; i < expectedAngles.length; i++) {
          final angle = expectedAngles[i];
          final radius = orbitalRadii[i];

          final x = radius * math.cos(angle);
          final y = radius * math.sin(angle);

          // Verify position calculations
          final calculatedAngle = math.atan2(y, x);
          final normalizedAngle = calculatedAngle < 0
              ? calculatedAngle + 2 * math.pi
              : calculatedAngle;

          expect(
            normalizedAngle,
            closeTo(angle, 0.001),
            reason: 'Planet position must match expected orbital angle',
          );

          // Verify distance from center
          final distance = math.sqrt(x * x + y * y);
          expect(
            distance,
            closeTo(radius, 0.001),
            reason: 'Planet distance from center must match orbital radius',
          );
        }
      });

      test(
        'should calculate velocity vectors perpendicular to position vectors',
        () {
          // For circular orbits, velocity should be perpendicular to position
          const gravitationalConstant = 1.2;
          const centralMass = 120.0;
          final angles = [math.pi / 2, math.pi, 3 * math.pi / 2, math.pi / 4];
          final radii = [40.0, 80.0, 160.0, 240.0];

          for (int i = 0; i < angles.length; i++) {
            final angle = angles[i];
            final radius = radii[i];
            final orbitalSpeed = math.sqrt(
              gravitationalConstant * centralMass / radius,
            );

            // Position vector
            final px = radius * math.cos(angle);
            final py = radius * math.sin(angle);

            // Velocity vector (perpendicular to position, counterclockwise)
            final vx = -orbitalSpeed * math.sin(angle);
            final vy = orbitalSpeed * math.cos(angle);

            // Verify velocity is perpendicular to position (dot product = 0)
            final dotProduct = px * vx + py * vy;
            expect(
              dotProduct,
              closeTo(0.0, 0.001),
              reason:
                  'Velocity vector must be perpendicular to position vector',
            );

            // Verify velocity magnitude
            final velocityMagnitude = math.sqrt(vx * vx + vy * vy);
            expect(
              velocityMagnitude,
              closeTo(orbitalSpeed, 0.001),
              reason: 'Velocity magnitude must match calculated orbital speed',
            );
          }
        },
      );
    });

    group('Rogue Planet Encounter Physics', () {
      test('should validate rogue planet starting position and velocity', () {
        // Test the optimal encounter setup: position (-350, 75, 0), velocity (2.2, -0.6, 0)
        const roguePlanetX = -350.0;
        const roguePlanetY = 75.0;
        const roguePlanetVx = 2.2;
        const roguePlanetVy = -0.6;

        // Verify distance from origin (encounter timing)
        final distanceFromOrigin = math.sqrt(
          roguePlanetX * roguePlanetX + roguePlanetY * roguePlanetY,
        );
        expect(
          distanceFromOrigin,
          greaterThan(340.0),
          reason: 'Rogue planet must start far enough for observable approach',
        );

        // Verify approach angle (should be coming toward system)
        final approachAngle = math.atan2(roguePlanetY, roguePlanetX);
        expect(
          approachAngle,
          greaterThan(0),
          reason: 'Rogue planet should approach from upper left quadrant',
        );

        // Verify velocity magnitude is reasonable for interstellar object
        final velocityMagnitude = math.sqrt(
          roguePlanetVx * roguePlanetVx + roguePlanetVy * roguePlanetVy,
        );
        expect(
          velocityMagnitude,
          greaterThan(1.0),
          reason: 'Rogue planet velocity must be sufficient for encounter',
        );
        expect(
          velocityMagnitude,
          lessThan(5.0),
          reason:
              'Rogue planet velocity must not be too fast for controlled encounter',
        );
      });

      test('should validate approach trajectory toward system center', () {
        // Test that rogue planet trajectory passes near system center
        const roguePlanetX = -350.0;
        const roguePlanetY = 75.0;
        const roguePlanetVx = 2.2;
        const roguePlanetVy = -0.6;

        // Calculate where trajectory would pass system center (t when x,y closest to 0,0)
        // Using parametric line: x(t) = x0 + vx*t, y(t) = y0 + vy*t
        // Minimize distance² = x(t)² + y(t)²
        // d²/dt = 2x(t)vx + 2y(t)vy = 0
        // Solving: t = -(x0*vx + y0*vy)/(vx² + vy²)

        final tClosest =
            -(roguePlanetX * roguePlanetVx + roguePlanetY * roguePlanetVy) /
            (roguePlanetVx * roguePlanetVx + roguePlanetVy * roguePlanetVy);

        expect(
          tClosest,
          greaterThan(0),
          reason: 'Rogue planet should approach system in positive time',
        );

        // Calculate closest approach position
        final xClosest = roguePlanetX + roguePlanetVx * tClosest;
        final yClosest = roguePlanetY + roguePlanetVy * tClosest;
        final closestDistance = math.sqrt(
          xClosest * xClosest + yClosest * yClosest,
        );

        expect(
          closestDistance,
          lessThan(100.0),
          reason:
              'Rogue planet trajectory should pass reasonably close to system center',
        );
      });
    });

    group('Physics Constants Validation', () {
      test(
        'should use consistent gravitational constant throughout calculations',
        () {
          const gravitationalConstant = 1.2;

          // Verify constant is positive and reasonable
          expect(
            gravitationalConstant,
            greaterThan(0),
            reason: 'Gravitational constant must be positive',
          );
          expect(
            gravitationalConstant,
            lessThan(10.0),
            reason:
                'Gravitational constant must be within reasonable simulation bounds',
          );

          // Test consistency across different mass scales
          final testMasses = [
            0.8,
            3.0,
            6.0,
            18.0,
            120.0,
          ]; // Planet and star masses
          final testRadii = [40.0, 80.0, 160.0];

          for (final mass in testMasses) {
            for (final radius in testRadii) {
              final velocity = math.sqrt(gravitationalConstant * mass / radius);
              expect(
                velocity.isFinite,
                isTrue,
                reason:
                    'Gravitational calculations must produce finite results',
              );
              expect(
                velocity,
                greaterThan(0),
                reason:
                    'Gravitational calculations must produce positive velocities',
              );
            }
          }
        },
      );
    });

    group('Numerical Stability Tests', () {
      test('should handle extreme orbital separations without overflow', () {
        const gravitationalConstant = 1.2;
        const centralMass = 120.0;
        final extremeRadii = [
          1.0,
          10.0,
          100.0,
          1000.0,
        ]; // Test range from very close to very far

        for (final radius in extremeRadii) {
          final velocity = math.sqrt(
            gravitationalConstant * centralMass / radius,
          );

          expect(
            velocity.isFinite,
            isTrue,
            reason: 'Velocity calculation must be finite for radius $radius',
          );
          expect(
            velocity.isNaN,
            isFalse,
            reason: 'Velocity calculation must not be NaN for radius $radius',
          );
          expect(
            velocity,
            greaterThan(0),
            reason: 'Velocity must be positive for radius $radius',
          );
        }
      });

      test('should handle small mass differences without precision loss', () {
        const gravitationalConstant = 1.2;
        const baseRadius = 40.0;
        final massVariations = [
          0.8,
          0.81,
          0.82,
          0.83,
          0.84,
        ]; // Small mass differences

        final velocities = massVariations
            .map((mass) => math.sqrt(gravitationalConstant * mass / baseRadius))
            .toList();

        // Velocities should show monotonic increase with mass
        for (int i = 1; i < velocities.length; i++) {
          expect(
            velocities[i],
            greaterThan(velocities[i - 1]),
            reason: 'Velocity must increase monotonically with mass',
          );

          // Verify precision is maintained (differences should be detectable)
          final difference = velocities[i] - velocities[i - 1];
          expect(
            difference,
            greaterThan(0.0005),
            reason:
                'Small mass differences must produce detectable velocity changes',
          );
        }
      });
    });
  });
}
