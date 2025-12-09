import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/models/ui/indicator_data.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/models/celestial/body.dart';
import 'package:graviton/core/enums/body_type.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void main() {
  group('IndicatorData Tests', () {
    late Body testBody;
    late IndicatorData testIndicator;

    setUp(() {
      testBody = Body(
        name: 'Test Body',
        mass: 1.0,
        radius: 5.0,
        position: vm.Vector3(100, 200, 300),
        velocity: vm.Vector3(10, 20, 30),
        bodyType: BodyType.planet,
        color: AppColors.planetEarth,
      );

      testIndicator = IndicatorData(
        bodyIndex: 0,
        body: testBody,
        position: const Offset(50, 100),
        direction: vm.Vector2(1.0, 0.0),
      );
    });

    group('Constructor and Properties', () {
      test('should create indicator data with correct properties', () {
        expect(testIndicator.bodyIndex, 0);
        expect(testIndicator.body, testBody);
        expect(testIndicator.position, const Offset(50, 100));
        expect(testIndicator.direction.x, 1.0);
        expect(testIndicator.direction.y, 0.0);
      });

      test('should handle different body types', () {
        final moonBody = Body(
          name: 'Moon',
          mass: 0.5,
          radius: 2.0,
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          bodyType: BodyType.moon,
          color: AppColors.uiTextGrey,
        );

        final moonIndicator = IndicatorData(
          bodyIndex: 1,
          body: moonBody,
          position: const Offset(75, 125),
          direction: vm.Vector2(0.0, 1.0),
        );

        expect(moonIndicator.body.bodyType, BodyType.moon);
        expect(moonIndicator.body.name, 'Moon');
      });
    });

    group('CopyWith Method', () {
      test('should create copy with updated bodyIndex', () {
        final copy = testIndicator.copyWith(bodyIndex: 5);

        expect(copy.bodyIndex, 5);
        expect(copy.body, testIndicator.body);
        expect(copy.position, testIndicator.position);
        expect(copy.direction, testIndicator.direction);
      });

      test('should create copy with updated position', () {
        const newPosition = Offset(200, 300);
        final copy = testIndicator.copyWith(position: newPosition);

        expect(copy.bodyIndex, testIndicator.bodyIndex);
        expect(copy.body, testIndicator.body);
        expect(copy.position, newPosition);
        expect(copy.direction, testIndicator.direction);
      });

      test('should create copy with updated direction', () {
        final newDirection = vm.Vector2(-1.0, 0.5);
        final copy = testIndicator.copyWith(direction: newDirection);

        expect(copy.bodyIndex, testIndicator.bodyIndex);
        expect(copy.body, testIndicator.body);
        expect(copy.position, testIndicator.position);
        expect(copy.direction.x, -1.0);
        expect(copy.direction.y, 0.5);
      });

      test('should create copy with multiple updates', () {
        final newBody = Body(
          name: 'New Body',
          mass: 2.0,
          radius: 10.0,
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          bodyType: BodyType.star,
          color: AppColors.stellarGType,
        );

        final copy = testIndicator.copyWith(
          bodyIndex: 10,
          body: newBody,
          position: const Offset(400, 500),
        );

        expect(copy.bodyIndex, 10);
        expect(copy.body, newBody);
        expect(copy.position, const Offset(400, 500));
        expect(copy.direction, testIndicator.direction);
      });

      test('should create identical copy when no parameters provided', () {
        final copy = testIndicator.copyWith();

        expect(copy.bodyIndex, testIndicator.bodyIndex);
        expect(copy.body, testIndicator.body);
        expect(copy.position, testIndicator.position);
        expect(copy.direction, testIndicator.direction);
      });
    });

    group('Equality and HashCode', () {
      test('should be equal to indicator with same properties', () {
        final other = IndicatorData(
          bodyIndex: testIndicator.bodyIndex,
          body: testIndicator.body,
          position: testIndicator.position,
          direction: testIndicator.direction,
        );

        expect(testIndicator, equals(other));
        expect(testIndicator.hashCode, equals(other.hashCode));
      });

      test('should not be equal to indicator with different bodyIndex', () {
        final other = testIndicator.copyWith(bodyIndex: 99);

        expect(testIndicator, isNot(equals(other)));
        expect(testIndicator.hashCode, isNot(equals(other.hashCode)));
      });

      test('should not be equal to indicator with different position', () {
        final other = testIndicator.copyWith(position: const Offset(999, 888));

        expect(testIndicator, isNot(equals(other)));
      });

      test('should not be equal to indicator with different direction', () {
        final other = testIndicator.copyWith(direction: vm.Vector2(-0.5, 0.8));

        expect(testIndicator, isNot(equals(other)));
      });

      test('should handle identical reference', () {
        expect(testIndicator, equals(testIndicator));
        expect(testIndicator.hashCode, equals(testIndicator.hashCode));
      });

      test('should not be equal to different type', () {
        expect(testIndicator, isNot(equals('string')));
        expect(testIndicator, isNot(equals(42)));
        expect(testIndicator, isNot(equals(testBody)));
      });
    });

    group('ToString', () {
      test('should provide meaningful string representation', () {
        final string = testIndicator.toString();

        expect(string, contains('IndicatorData'));
        expect(string, contains('bodyIndex: 0'));
        expect(string, contains('body: Test Body'));
        expect(string, contains('position: Offset(50.0, 100.0)'));
        expect(string, contains('direction:'));
      });

      test('should handle different body names', () {
        final specialBody = Body(
          name: 'Special-Body_123',
          mass: 1.0,
          radius: 5.0,
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          bodyType: BodyType.asteroid,
          color: AppColors.asteroidRockyBrown,
        );

        final indicator = IndicatorData(
          bodyIndex: 5,
          body: specialBody,
          position: const Offset(0, 0),
          direction: vm.Vector2.zero(),
        );

        final string = indicator.toString();
        expect(string, contains('Special-Body_123'));
        expect(string, contains('bodyIndex: 5'));
      });
    });

    group('Edge Cases', () {
      test('should handle zero vector direction', () {
        final indicator = IndicatorData(
          bodyIndex: 0,
          body: testBody,
          position: Offset.zero,
          direction: vm.Vector2.zero(),
        );

        expect(indicator.direction.x, 0.0);
        expect(indicator.direction.y, 0.0);
      });

      test('should handle negative coordinates', () {
        final indicator = IndicatorData(
          bodyIndex: -1,
          body: testBody,
          position: const Offset(-50, -100),
          direction: vm.Vector2(-1.0, -1.0),
        );

        expect(indicator.bodyIndex, -1);
        expect(indicator.position.dx, -50);
        expect(indicator.position.dy, -100);
        expect(indicator.direction.x, -1.0);
        expect(indicator.direction.y, -1.0);
      });

      test('should handle large coordinate values', () {
        const largePosition = Offset(1e6, 1e6);
        final largeDirection = vm.Vector2(1e3, 1e3);

        final indicator = IndicatorData(
          bodyIndex: 999999,
          body: testBody,
          position: largePosition,
          direction: largeDirection,
        );

        expect(indicator.bodyIndex, 999999);
        expect(indicator.position, largePosition);
        expect(indicator.direction.x, 1e3);
        expect(indicator.direction.y, 1e3);
      });
    });
  });
}
