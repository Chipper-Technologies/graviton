import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/core/enums/camera_movement_type.dart';

void main() {
  group('CameraMovementType', () {
    test('should have all expected values', () {
      const expectedValues = {
        CameraMovementType.linear,
        CameraMovementType.easeInOut,
        CameraMovementType.bezier,
        CameraMovementType.banking,
      };

      expect(Set.from(CameraMovementType.values), equals(expectedValues));
      expect(CameraMovementType.values.length, equals(4));
    });

    test('should have correct enum names', () {
      expect(CameraMovementType.linear.name, equals('linear'));
      expect(CameraMovementType.easeInOut.name, equals('easeInOut'));
      expect(CameraMovementType.bezier.name, equals('bezier'));
      expect(CameraMovementType.banking.name, equals('banking'));
    });

    test('should be convertible to string and back', () {
      for (final movementType in CameraMovementType.values) {
        final stringValue = movementType.name;
        final backToEnum = CameraMovementType.values.firstWhere(
          (e) => e.name == stringValue,
        );
        expect(backToEnum, equals(movementType));
      }
    });

    test('should be usable in switch statements', () {
      String getMovementDescription(CameraMovementType movementType) {
        switch (movementType) {
          case CameraMovementType.linear:
            return 'Linear interpolation';
          case CameraMovementType.easeInOut:
            return 'Smooth ease-in-out curve';
          case CameraMovementType.bezier:
            return 'Bezier curve for complex paths';
          case CameraMovementType.banking:
            return 'Banking turn with roll';
        }
      }

      expect(
        getMovementDescription(CameraMovementType.linear),
        equals('Linear interpolation'),
      );
      expect(
        getMovementDescription(CameraMovementType.easeInOut),
        equals('Smooth ease-in-out curve'),
      );
      expect(
        getMovementDescription(CameraMovementType.bezier),
        equals('Bezier curve for complex paths'),
      );
      expect(
        getMovementDescription(CameraMovementType.banking),
        equals('Banking turn with roll'),
      );
    });

    test('should provide different movement characteristics', () {
      // Test that each movement type has distinct properties
      final types = CameraMovementType.values;

      // All should be different
      expect(types.toSet().length, equals(types.length));

      // Should include both simple and complex movement types
      expect(types, contains(CameraMovementType.linear)); // Simple
      expect(types, contains(CameraMovementType.bezier)); // Complex
      expect(types, contains(CameraMovementType.banking)); // Cinematic
      expect(types, contains(CameraMovementType.easeInOut)); // Smooth
    });
  });
}
