import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/body_movement_mode.dart';

void main() {
  group('BodyMovementMode Tests', () {
    test('should have correct enum values', () {
      expect(BodyMovementMode.values.length, 2);
      expect(BodyMovementMode.values, contains(BodyMovementMode.inactive));
      expect(BodyMovementMode.values, contains(BodyMovementMode.active));
    });

    test('isActive should return true only for active', () {
      expect(BodyMovementMode.active.isActive, isTrue);
      expect(BodyMovementMode.inactive.isActive, isFalse);
    });

    test('isInactive should return true only for inactive', () {
      expect(BodyMovementMode.inactive.isInactive, isTrue);
      expect(BodyMovementMode.active.isInactive, isFalse);
    });
  });
}
