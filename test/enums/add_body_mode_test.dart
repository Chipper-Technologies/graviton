import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/add_body_mode.dart';

void main() {
  group('AddBodyMode Tests', () {
    test('should have correct enum values', () {
      expect(AddBodyMode.values.length, equals(2));
      expect(AddBodyMode.values, contains(AddBodyMode.inactive));
      expect(AddBodyMode.values, contains(AddBodyMode.active));
    });

    test('isActive should return true for active mode', () {
      expect(AddBodyMode.active.isActive, isTrue);
      expect(AddBodyMode.inactive.isActive, isFalse);
    });

    test('isInactive should return true for inactive mode', () {
      expect(AddBodyMode.inactive.isInactive, isTrue);
      expect(AddBodyMode.active.isInactive, isFalse);
    });

    test('should have correct names', () {
      expect(AddBodyMode.active.name, equals('active'));
      expect(AddBodyMode.inactive.name, equals('inactive'));
    });

    test('should support equality comparison', () {
      const mode1 = AddBodyMode.active;
      const mode2 = AddBodyMode.active;
      const mode3 = AddBodyMode.inactive;

      expect(mode1 == mode2, isTrue);
      expect(mode1 == mode3, isFalse);
    });

    test('should support switching between modes', () {
      var mode = AddBodyMode.inactive;
      expect(mode.isInactive, isTrue);

      mode = AddBodyMode.active;
      expect(mode.isActive, isTrue);
    });
  });
}
