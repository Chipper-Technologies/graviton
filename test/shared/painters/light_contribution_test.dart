import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/core/enums/body_type.dart';
import 'package:graviton/models/celestial/body.dart';
import 'package:graviton/shared/painters/light_contribution.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void main() {
  group('LightContribution', () {
    late Body testStar;

    setUp(() {
      testStar = Body(
        name: 'Test Star',
        bodyType: BodyType.star,
        mass: 1.0,
        radius: 10.0,
        position: vm.Vector3(100, 0, 0),
        velocity: vm.Vector3.zero(),
        color: AppColors.basicYellow,
      );
    });

    test('should create instance with all required parameters', () {
      const intensity = 0.75;
      final direction = vm.Vector3(1, 0, 0);

      final contribution = LightContribution(
        star: testStar,
        intensity: intensity,
        direction: direction,
      );

      expect(contribution.star, equals(testStar));
      expect(contribution.intensity, equals(intensity));
      expect(contribution.direction, equals(direction));
    });

    test('should handle zero intensity', () {
      final direction = vm.Vector3(0, 1, 0);

      final contribution = LightContribution(
        star: testStar,
        intensity: 0.0,
        direction: direction,
      );

      expect(contribution.intensity, equals(0.0));
    });

    test('should handle full intensity', () {
      final direction = vm.Vector3(0, 0, 1);

      final contribution = LightContribution(
        star: testStar,
        intensity: 1.0,
        direction: direction,
      );

      expect(contribution.intensity, equals(1.0));
    });

    test('should handle normalized direction vectors', () {
      // Normalized vector pointing at 45 degrees
      final direction = vm.Vector3(1, 1, 0).normalized();

      final contribution = LightContribution(
        star: testStar,
        intensity: 0.5,
        direction: direction,
      );

      expect(contribution.direction.length, closeTo(1.0, 0.0001));
    });

    test('should handle arbitrary direction vectors', () {
      final direction = vm.Vector3(3, 4, 0);

      final contribution = LightContribution(
        star: testStar,
        intensity: 0.8,
        direction: direction,
      );

      // Should preserve the direction as provided (not auto-normalize)
      expect(contribution.direction.x, equals(3.0));
      expect(contribution.direction.y, equals(4.0));
      expect(contribution.direction.z, equals(0.0));
    });

    test('should handle negative direction components', () {
      final direction = vm.Vector3(-1, -1, -1);

      final contribution = LightContribution(
        star: testStar,
        intensity: 0.3,
        direction: direction,
      );

      expect(contribution.direction.x, lessThan(0));
      expect(contribution.direction.y, lessThan(0));
      expect(contribution.direction.z, lessThan(0));
    });

    test('should allow intensity values between 0 and 1', () {
      final testIntensities = [0.0, 0.25, 0.5, 0.75, 1.0];

      for (final intensity in testIntensities) {
        final contribution = LightContribution(
          star: testStar,
          intensity: intensity,
          direction: vm.Vector3(1, 0, 0),
        );

        expect(contribution.intensity, equals(intensity));
      }
    });

    test('should maintain reference to the same star body', () {
      final contribution = LightContribution(
        star: testStar,
        intensity: 0.6,
        direction: vm.Vector3(1, 0, 0),
      );

      expect(identical(contribution.star, testStar), isTrue);
    });
  });
}
