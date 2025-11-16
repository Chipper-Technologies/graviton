import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/models/sunspot_data.dart';

void main() {
  group('SunspotData', () {
    group('constructor and properties', () {
      test('creates sunspot data with all required properties', () {
        const testCenter = Offset(100.0, 50.0);
        const testRadius = 25.0;

        const penumbraGradient = RadialGradient(
          colors: [Colors.orange, Colors.red],
          stops: [0.0, 1.0],
        );

        const umbraGradient = RadialGradient(
          colors: [Colors.black, Colors.brown],
          stops: [0.0, 1.0],
        );

        const penumbraRect = Rect.fromLTRB(75.0, 25.0, 125.0, 75.0);
        const umbraRect = Rect.fromLTRB(87.5, 37.5, 112.5, 62.5);

        const sunspotData = SunspotData(
          center: testCenter,
          radius: testRadius,
          penumbraGradient: penumbraGradient,
          umbraGradient: umbraGradient,
          penumbraRect: penumbraRect,
          umbraRect: umbraRect,
        );

        expect(sunspotData.center, equals(testCenter));
        expect(sunspotData.radius, equals(testRadius));
        expect(sunspotData.penumbraGradient, equals(penumbraGradient));
        expect(sunspotData.umbraGradient, equals(umbraGradient));
        expect(sunspotData.penumbraRect, equals(penumbraRect));
        expect(sunspotData.umbraRect, equals(umbraRect));
      });

      test('handles zero-sized sunspot', () {
        const zeroSunspot = SunspotData(
          center: Offset.zero,
          radius: 0.0,
          penumbraGradient: RadialGradient(colors: [Colors.transparent]),
          umbraGradient: RadialGradient(colors: [Colors.transparent]),
          penumbraRect: Rect.zero,
          umbraRect: Rect.zero,
        );

        expect(zeroSunspot.center, equals(Offset.zero));
        expect(zeroSunspot.radius, equals(0.0));
        expect(zeroSunspot.penumbraRect, equals(Rect.zero));
        expect(zeroSunspot.umbraRect, equals(Rect.zero));
      });

      test('handles negative center coordinates', () {
        const negativeCenter = Offset(-50.0, -75.0);
        const testRadius = 30.0;

        const sunspotData = SunspotData(
          center: negativeCenter,
          radius: testRadius,
          penumbraGradient: RadialGradient(colors: [Colors.orange]),
          umbraGradient: RadialGradient(colors: [Colors.black]),
          penumbraRect: Rect.fromLTRB(-80.0, -105.0, -20.0, -45.0),
          umbraRect: Rect.fromLTRB(-65.0, -90.0, -35.0, -60.0),
        );

        expect(sunspotData.center, equals(negativeCenter));
        expect(sunspotData.radius, equals(testRadius));
        expect(sunspotData.penumbraRect.left, equals(-80.0));
        expect(sunspotData.umbraRect.left, equals(-65.0));
      });

      test('handles large radius values', () {
        const bigSunspot = SunspotData(
          center: Offset(500.0, 400.0),
          radius: 1000.0,
          penumbraGradient: RadialGradient(
            colors: [Colors.yellow, Colors.red],
            stops: [0.0, 1.0],
          ),
          umbraGradient: RadialGradient(
            colors: [Colors.black, Colors.grey],
            stops: [0.0, 1.0],
          ),
          penumbraRect: Rect.fromLTRB(-500.0, -600.0, 1500.0, 1400.0),
          umbraRect: Rect.fromLTRB(0.0, -100.0, 1000.0, 900.0),
        );

        expect(bigSunspot.center, equals(const Offset(500.0, 400.0)));
        expect(bigSunspot.radius, equals(1000.0));
        expect(bigSunspot.penumbraRect.width, equals(2000.0));
        expect(bigSunspot.umbraRect.width, equals(1000.0));
      });
    });

    group('gradient properties', () {
      test('verifies penumbra gradient configuration', () {
        const penumbraGradient = RadialGradient(
          center: Alignment.center,
          colors: [
            Color(0xFFFFA500), // Orange
            Color(0xFFFF4500), // Red-orange
            Color(0xFFDC143C), // Crimson
          ],
          stops: [0.0, 0.6, 1.0],
          radius: 0.8,
        );

        const sunspotData = SunspotData(
          center: Offset(100.0, 100.0),
          radius: 50.0,
          penumbraGradient: penumbraGradient,
          umbraGradient: RadialGradient(colors: [Colors.black]),
          penumbraRect: Rect.fromLTRB(50.0, 50.0, 150.0, 150.0),
          umbraRect: Rect.fromLTRB(75.0, 75.0, 125.0, 125.0),
        );

        expect(sunspotData.penumbraGradient.colors.length, equals(3));
        expect(
          sunspotData.penumbraGradient.colors[0],
          equals(const Color(0xFFFFA500)),
        );
        expect(
          sunspotData.penumbraGradient.colors[2],
          equals(const Color(0xFFDC143C)),
        );
        expect(sunspotData.penumbraGradient.stops, equals([0.0, 0.6, 1.0]));
        expect(sunspotData.penumbraGradient.radius, equals(0.8));
      });

      test('verifies umbra gradient configuration', () {
        const umbraGradient = RadialGradient(
          center: Alignment.topLeft,
          colors: [
            Colors.black,
            Color(0xFF2F2F2F), // Dark grey
            Color(0xFF4A4A4A), // Medium grey
          ],
          stops: [0.0, 0.4, 1.0],
          radius: 0.5,
        );

        const sunspotData = SunspotData(
          center: Offset(200.0, 150.0),
          radius: 75.0,
          penumbraGradient: RadialGradient(colors: [Colors.orange]),
          umbraGradient: umbraGradient,
          penumbraRect: Rect.fromLTRB(125.0, 75.0, 275.0, 225.0),
          umbraRect: Rect.fromLTRB(162.5, 112.5, 237.5, 187.5),
        );

        expect(sunspotData.umbraGradient.colors.length, equals(3));
        expect(sunspotData.umbraGradient.colors[0], equals(Colors.black));
        expect(
          sunspotData.umbraGradient.colors[1],
          equals(const Color(0xFF2F2F2F)),
        );
        expect(
          sunspotData.umbraGradient.colors[2],
          equals(const Color(0xFF4A4A4A)),
        );
        expect(sunspotData.umbraGradient.stops, equals([0.0, 0.4, 1.0]));
        expect(sunspotData.umbraGradient.center, equals(Alignment.topLeft));
      });
    });

    group('rectangle properties', () {
      test('verifies penumbra rectangle dimensions', () {
        const center = Offset(300.0, 200.0);
        const radius = 60.0;

        // Rectangle should encompass the full penumbra area
        final penumbraRect = Rect.fromCircle(center: center, radius: radius);

        final sunspotData = SunspotData(
          center: center,
          radius: radius,
          penumbraGradient: const RadialGradient(colors: [Colors.orange]),
          umbraGradient: const RadialGradient(colors: [Colors.black]),
          penumbraRect: penumbraRect,
          umbraRect: Rect.fromCircle(center: center, radius: radius * 0.5),
        );

        expect(sunspotData.penumbraRect.center, equals(center));
        expect(sunspotData.penumbraRect.width, equals(radius * 2));
        expect(sunspotData.penumbraRect.height, equals(radius * 2));
        expect(sunspotData.penumbraRect.left, equals(center.dx - radius));
        expect(sunspotData.penumbraRect.top, equals(center.dy - radius));
        expect(sunspotData.penumbraRect.right, equals(center.dx + radius));
        expect(sunspotData.penumbraRect.bottom, equals(center.dy + radius));
      });

      test('verifies umbra rectangle dimensions', () {
        const center = Offset(150.0, 250.0);
        const radius = 40.0;
        const umbraRadius = radius * 0.6; // Umbra is typically smaller

        final umbraRect = Rect.fromCircle(center: center, radius: umbraRadius);

        final sunspotData = SunspotData(
          center: center,
          radius: radius,
          penumbraGradient: const RadialGradient(colors: [Colors.orange]),
          umbraGradient: const RadialGradient(colors: [Colors.black]),
          penumbraRect: Rect.fromCircle(center: center, radius: radius),
          umbraRect: umbraRect,
        );

        expect(sunspotData.umbraRect.center, equals(center));
        expect(sunspotData.umbraRect.width, equals(umbraRadius * 2));
        expect(sunspotData.umbraRect.height, equals(umbraRadius * 2));
        expect(sunspotData.umbraRect.left, equals(center.dx - umbraRadius));
        expect(sunspotData.umbraRect.top, equals(center.dy - umbraRadius));
      });

      test('handles rectangular (non-circular) bounding boxes', () {
        const sunspotData = SunspotData(
          center: Offset(100.0, 100.0),
          radius: 25.0,
          penumbraGradient: RadialGradient(colors: [Colors.orange]),
          umbraGradient: RadialGradient(colors: [Colors.black]),
          penumbraRect: Rect.fromLTWH(80.0, 90.0, 40.0, 30.0), // Elliptical
          umbraRect: Rect.fromLTWH(
            90.0,
            95.0,
            20.0,
            15.0,
          ), // Smaller elliptical
        );

        // Penumbra rectangle
        expect(sunspotData.penumbraRect.left, equals(80.0));
        expect(sunspotData.penumbraRect.top, equals(90.0));
        expect(sunspotData.penumbraRect.width, equals(40.0));
        expect(sunspotData.penumbraRect.height, equals(30.0));

        // Umbra rectangle
        expect(sunspotData.umbraRect.left, equals(90.0));
        expect(sunspotData.umbraRect.top, equals(95.0));
        expect(sunspotData.umbraRect.width, equals(20.0));
        expect(sunspotData.umbraRect.height, equals(15.0));
      });
    });

    group('realistic sunspot scenarios', () {
      test('small sunspot typical of solar minimum', () {
        const smallSunspot = SunspotData(
          center: Offset(400.0, 300.0),
          radius: 8.0, // Small radius for solar minimum
          penumbraGradient: RadialGradient(
            colors: [
              Color(0xFFFFA500), // Orange
              Color(0xFFFF6347), // Tomato red
            ],
            stops: [0.0, 1.0],
          ),
          umbraGradient: RadialGradient(
            colors: [
              Colors.black,
              Color(0xFF1A1A1A), // Very dark grey
            ],
            stops: [0.0, 1.0],
          ),
          penumbraRect: Rect.fromLTWH(392.0, 292.0, 16.0, 16.0),
          umbraRect: Rect.fromLTWH(396.0, 296.0, 8.0, 8.0),
        );

        expect(smallSunspot.radius, equals(8.0));
        expect(smallSunspot.penumbraRect.width, equals(16.0));
        expect(smallSunspot.umbraRect.width, equals(8.0));
      });

      test('large sunspot group typical of solar maximum', () {
        const largeSunspot = SunspotData(
          center: Offset(500.0, 400.0),
          radius: 120.0, // Large radius for solar maximum
          penumbraGradient: RadialGradient(
            colors: [
              Color(0xFFFFA500), // Orange
              Color(0xFFFF4500), // Red-orange
              Color(0xFFDC143C), // Crimson
              Color(0xFF8B0000), // Dark red
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
          umbraGradient: RadialGradient(
            colors: [
              Colors.black,
              Color(0xFF0A0A0A), // Nearly black
              Color(0xFF1A1A1A), // Dark grey
            ],
            stops: [0.0, 0.5, 1.0],
          ),
          penumbraRect: Rect.fromLTWH(380.0, 280.0, 240.0, 240.0),
          umbraRect: Rect.fromLTWH(440.0, 340.0, 120.0, 120.0),
        );

        expect(largeSunspot.radius, equals(120.0));
        expect(largeSunspot.penumbraGradient.colors.length, equals(4));
        expect(largeSunspot.umbraGradient.colors.length, equals(3));
        expect(largeSunspot.penumbraRect.width, equals(240.0));
        expect(largeSunspot.umbraRect.width, equals(120.0));
      });

      test('irregular sunspot with complex structure', () {
        const irregularSunspot = SunspotData(
          center: Offset(250.0, 180.0),
          radius: 45.0,
          penumbraGradient: RadialGradient(
            center: Alignment(-0.2, 0.3), // Off-center gradient
            colors: [
              Color(0xFFFFA500), // Orange
              Color(0xFFFF7F50), // Coral
              Color(0xFFCD5C5C), // Indian red
            ],
            stops: [0.0, 0.6, 1.0],
            radius: 1.2, // Extends beyond normal bounds
          ),
          umbraGradient: RadialGradient(
            center: Alignment(0.1, -0.1), // Slightly off-center
            colors: [Colors.black, Color(0xFF0F0F0F), Color(0xFF2F2F2F)],
            stops: [0.0, 0.3, 1.0],
            radius: 0.8,
          ),
          // Irregular, non-circular bounding boxes
          penumbraRect: Rect.fromLTWH(200.0, 130.0, 100.0, 80.0),
          umbraRect: Rect.fromLTWH(220.0, 155.0, 40.0, 35.0),
        );

        expect(irregularSunspot.center, equals(const Offset(250.0, 180.0)));
        expect(
          irregularSunspot.penumbraGradient.center,
          equals(const Alignment(-0.2, 0.3)),
        );
        expect(
          irregularSunspot.umbraGradient.center,
          equals(const Alignment(0.1, -0.1)),
        );

        // Non-square rectangles
        expect(
          irregularSunspot.penumbraRect.width,
          isNot(equals(irregularSunspot.penumbraRect.height)),
        );
        expect(
          irregularSunspot.umbraRect.width,
          isNot(equals(irregularSunspot.umbraRect.height)),
        );
      });

      test('sunspot near stellar limb (edge)', () {
        const limbSunspot = SunspotData(
          center: Offset(750.0, 100.0), // Near edge of star
          radius: 30.0,
          penumbraGradient: RadialGradient(
            colors: [Color(0xFFFFA500), Color(0xFFFF4500)],
            stops: [0.0, 1.0],
            // Gradient might be more elliptical near limb due to perspective
            transform: GradientRotation(0.3),
          ),
          umbraGradient: RadialGradient(
            colors: [Colors.black, Color(0xFF1A1A1A)],
            stops: [0.0, 1.0],
            transform: GradientRotation(0.3),
          ),
          // Foreshortened due to perspective
          penumbraRect: Rect.fromLTWH(725.0, 85.0, 50.0, 30.0),
          umbraRect: Rect.fromLTWH(735.0, 90.0, 25.0, 15.0),
        );

        expect(limbSunspot.center.dx, equals(750.0));
        expect(
          limbSunspot.penumbraRect.width,
          greaterThan(limbSunspot.penumbraRect.height),
        );
        expect(
          limbSunspot.umbraRect.width,
          greaterThan(limbSunspot.umbraRect.height),
        );
      });
    });

    group('performance and caching scenarios', () {
      test('demonstrates high-frequency sunspot data', () {
        // Simulate multiple small sunspots for active solar surface
        final sunspots = List.generate(10, (index) {
          final centerX = 100.0 + (index % 5) * 80.0;
          final centerY = 100.0 + (index ~/ 5) * 80.0;

          return SunspotData(
            center: Offset(centerX, centerY),
            radius: 15.0 + (index * 2.0), // Varying sizes
            penumbraGradient: RadialGradient(
              colors: [
                Color(
                  0xFFFFA500 - (index * 0x001100),
                ), // Slight color variation
                Color(0xFFFF4500 - (index * 0x001100)),
              ],
              stops: const [0.0, 1.0],
            ),
            umbraGradient: const RadialGradient(
              colors: [Colors.black, Color(0xFF1A1A1A)],
              stops: [0.0, 1.0],
            ),
            penumbraRect: Rect.fromCircle(
              center: Offset(centerX, centerY),
              radius: 15.0 + (index * 2.0),
            ),
            umbraRect: Rect.fromCircle(
              center: Offset(centerX, centerY),
              radius: (15.0 + (index * 2.0)) * 0.5,
            ),
          );
        });

        expect(sunspots.length, equals(10));
        expect(sunspots.first.radius, equals(15.0));
        expect(sunspots.last.radius, equals(33.0)); // 15 + (9 * 2)

        // Verify each sunspot has proper data structure
        for (final sunspot in sunspots) {
          expect(sunspot.center.dx, greaterThanOrEqualTo(100.0));
          expect(sunspot.center.dx, lessThanOrEqualTo(420.0));
          expect(sunspot.penumbraGradient.colors.length, equals(2));
          expect(sunspot.umbraGradient.colors.length, equals(2));
        }
      });
    });

    group('immutability', () {
      test('all properties should be final and immutable', () {
        const sunspotData = SunspotData(
          center: Offset(100.0, 100.0),
          radius: 25.0,
          penumbraGradient: RadialGradient(colors: [Colors.orange]),
          umbraGradient: RadialGradient(colors: [Colors.black]),
          penumbraRect: Rect.fromLTWH(75.0, 75.0, 50.0, 50.0),
          umbraRect: Rect.fromLTWH(87.5, 87.5, 25.0, 25.0),
        );

        // Verify the object was created successfully with const constructor
        expect(sunspotData.center, isNotNull);
        expect(sunspotData.radius, isNotNull);
        expect(sunspotData.penumbraGradient, isNotNull);
        expect(sunspotData.umbraGradient, isNotNull);
        expect(sunspotData.penumbraRect, isNotNull);
        expect(sunspotData.umbraRect, isNotNull);

        // All fields should maintain their values
        final originalCenter = sunspotData.center;
        final originalRadius = sunspotData.radius;

        expect(sunspotData.center, equals(originalCenter));
        expect(sunspotData.radius, equals(originalRadius));
      });
    });
  });
}
