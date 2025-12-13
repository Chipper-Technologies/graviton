import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/core/enums/accessibility_physics_parameter.dart';

void main() {
  group('AccessibilityPhysicsParameter', () {
    test('should have correct string values', () {
      expect(AccessibilityPhysicsParameter.speed.value, 'speed');
      expect(AccessibilityPhysicsParameter.gravity.value, 'gravity');
      expect(
        AccessibilityPhysicsParameter.collisionRadius.value,
        'collisionradius',
      );
    });

    test('fromString should return correct enum values', () {
      expect(
        AccessibilityPhysicsParameter.fromString('speed'),
        AccessibilityPhysicsParameter.speed,
      );
      expect(
        AccessibilityPhysicsParameter.fromString('SPEED'),
        AccessibilityPhysicsParameter.speed,
      );
      expect(
        AccessibilityPhysicsParameter.fromString('gravity'),
        AccessibilityPhysicsParameter.gravity,
      );
      expect(
        AccessibilityPhysicsParameter.fromString('GRAVITY'),
        AccessibilityPhysicsParameter.gravity,
      );
      expect(
        AccessibilityPhysicsParameter.fromString('collisionradius'),
        AccessibilityPhysicsParameter.collisionRadius,
      );
      expect(
        AccessibilityPhysicsParameter.fromString('COLLISIONRADIUS'),
        AccessibilityPhysicsParameter.collisionRadius,
      );
    });

    test('fromString should return speed as default for unknown values', () {
      expect(
        AccessibilityPhysicsParameter.fromString('unknown'),
        AccessibilityPhysicsParameter.speed,
      );
      expect(
        AccessibilityPhysicsParameter.fromString(''),
        AccessibilityPhysicsParameter.speed,
      );
      expect(
        AccessibilityPhysicsParameter.fromString('invalid_param'),
        AccessibilityPhysicsParameter.speed,
      );
    });

    test('should handle case insensitive matching', () {
      expect(
        AccessibilityPhysicsParameter.fromString('Speed'),
        AccessibilityPhysicsParameter.speed,
      );
      expect(
        AccessibilityPhysicsParameter.fromString('Gravity'),
        AccessibilityPhysicsParameter.gravity,
      );
      expect(
        AccessibilityPhysicsParameter.fromString('CollisionRadius'),
        AccessibilityPhysicsParameter.collisionRadius,
      );
    });
  });
}
