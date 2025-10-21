import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/utils/star_generator.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void main() {
  group('StarGenerator Enhanced Tests', () {
    test('Should generate correct number of enhanced stars', () {
      const count = 100;
      final stars = StarGenerator.generateStars(count);

      expect(stars, hasLength(count));
      expect(stars.first, isA<StarData>());
    });

    test('Should generate stars within default radius', () {
      const count = 50;
      final stars = StarGenerator.generateStars(count);

      for (final star in stars) {
        expect(
          star.position.length,
          lessThanOrEqualTo(3000.0 + 1e-10),
        ); // default radius with tolerance
      }
    });

    test('Should generate stars within custom radius', () {
      const count = 30;
      const radius = 200.0;
      final stars = StarGenerator.generateStars(count, radius: radius);

      for (final star in stars) {
        expect(
          star.position.length,
          lessThanOrEqualTo(radius + 1e-10),
        ); // tolerance for floating point
      }
    });

    test('Should generate stars with varied properties', () {
      const count = 100;
      final stars = StarGenerator.generateStars(count);

      // Check size variation
      final sizes = stars.map((s) => s.size).toSet();
      expect(sizes.length, greaterThan(10)); // Should have variety in sizes

      // Check brightness variation
      final brightnesses = stars.map((s) => s.brightness).toSet();
      expect(
        brightnesses.length,
        greaterThan(10),
      ); // Should have variety in brightness

      // Check color variation
      final colors = stars.map((s) => s.color).toSet();
      expect(colors.length, greaterThan(1)); // Should have variety in colors
    });

    test('Should generate stars with valid property ranges', () {
      const count = 50;
      final stars = StarGenerator.generateStars(count);

      for (final star in stars) {
        // Size should be within reasonable range
        expect(star.size, greaterThan(0.0));
        expect(star.size, lessThan(10.0));

        // Brightness should be between 0.3 and 1.0
        expect(star.brightness, greaterThanOrEqualTo(0.3));
        expect(star.brightness, lessThanOrEqualTo(1.0));

        // Color should be a valid color value
        expect(star.color, greaterThan(0));
      }
    });

    test('Should generate stars in 3D space', () {
      const count = 100;
      final stars = StarGenerator.generateStars(count);

      bool hasNonZeroX = false;
      bool hasNonZeroY = false;
      bool hasNonZeroZ = false;

      for (final star in stars) {
        if (star.position.x.abs() > 0.1) hasNonZeroX = true;
        if (star.position.y.abs() > 0.1) hasNonZeroY = true;
        if (star.position.z.abs() > 0.1) hasNonZeroZ = true;
      }

      expect(hasNonZeroX, isTrue);
      expect(hasNonZeroY, isTrue);
      expect(hasNonZeroZ, isTrue);
    });

    test('Should handle zero count', () {
      final stars = StarGenerator.generateStars(0);
      expect(stars, isEmpty);
    });

    test('Multiple calls should generate different star fields', () {
      const count = 10;
      final stars1 = StarGenerator.generateStars(count);
      final stars2 = StarGenerator.generateStars(count);

      bool foundDifference = false;
      for (int i = 0; i < count; i++) {
        if ((stars1[i].position - stars2[i].position).length > 1e-10) {
          foundDifference = true;
          break;
        }
      }
      expect(foundDifference, isTrue);
    });
  });

  group('StarGenerator Backward Compatibility Tests', () {
    test('Should generate simple stars with generateSimpleStars', () {
      const count = 50;
      final stars = StarGenerator.generateSimpleStars(count);

      expect(stars, hasLength(count));
      expect(stars.first, isA<vm.Vector3>());
    });

    test('Simple stars should be within radius', () {
      const count = 30;
      const radius = 500.0;
      final stars = StarGenerator.generateSimpleStars(count, radius: radius);

      for (final star in stars) {
        expect(star.length, lessThanOrEqualTo(radius + 1e-10));
      }
    });
  });
}
