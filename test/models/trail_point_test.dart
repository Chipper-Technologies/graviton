import 'package:flutter_test/flutter_test.dart';
import 'package:vector_math/vector_math_64.dart' as vm;
import 'package:graviton/models/trail_point.dart';
import 'package:graviton/constants/test_constants.dart';

void main() {
  group('TrailPoint Model Tests', () {
    test('TrailPoint constructor should initialize with correct values', () {
      final position = vm.Vector3(
        TestConstants.testValue1,
        TestConstants.testValue2,
        TestConstants.testValue3,
      );
      const alpha = TestConstants.testAlphaEighty;

      final trailPoint = TrailPoint(position, alpha);

      expect(trailPoint.pos, equals(position));
      expect(trailPoint.alpha, equals(alpha));
    });

    test('TrailPoint should handle zero alpha', () {
      final trailPoint = TrailPoint(
        vm.Vector3.zero(),
        TestConstants.testAlphaZero,
      );
      expect(trailPoint.alpha, equals(TestConstants.testAlphaZero));
    });

    test('TrailPoint should handle full alpha', () {
      final trailPoint = TrailPoint(
        vm.Vector3.zero(),
        TestConstants.testAlphaFull,
      );
      expect(trailPoint.alpha, equals(TestConstants.testAlphaFull));
    });

    test('TrailPoint position should be mutable', () {
      final position = vm.Vector3(
        TestConstants.testValue1,
        TestConstants.testValue1,
        TestConstants.testValue1,
      );
      final trailPoint = TrailPoint(position, TestConstants.testAlphaHalf);

      // Modify position
      trailPoint.pos.setValues(
        TestConstants.testValue2,
        TestConstants.testValue3,
        TestConstants.testValue4,
      );
      expect(trailPoint.pos.x, equals(TestConstants.testValue2));
      expect(trailPoint.pos.y, equals(TestConstants.testValue3));
      expect(trailPoint.pos.z, equals(TestConstants.testValue4));
    });

    test('TrailPoint alpha should be mutable', () {
      final trailPoint = TrailPoint(
        vm.Vector3.zero(),
        TestConstants.testAlphaHalf,
      );

      trailPoint.alpha = TestConstants.testAlphaPartial;
      expect(trailPoint.alpha, equals(TestConstants.testAlphaPartial));
    });

    test('TrailPoint should handle negative positions', () {
      final position = vm.Vector3(-5.0, -10.0, -15.0);
      final trailPoint = TrailPoint(position, 0.7);

      expect(trailPoint.pos.x, equals(-5.0));
      expect(trailPoint.pos.y, equals(-10.0));
      expect(trailPoint.pos.z, equals(-15.0));
    });

    test('TrailPoint should handle alpha values outside normal range', () {
      // Test negative alpha
      final trailPoint1 = TrailPoint(vm.Vector3.zero(), -0.5);
      expect(trailPoint1.alpha, equals(-0.5));

      // Test alpha greater than 1
      final trailPoint2 = TrailPoint(vm.Vector3.zero(), 1.5);
      expect(trailPoint2.alpha, equals(1.5));
    });
  });
}
