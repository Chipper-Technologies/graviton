import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/models/camera_movement.dart';
import 'package:graviton/enums/camera_movement_type.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void main() {
  group('CameraMovement', () {
    test('should create instance with all required fields', () {
      final startPosition = vm.Vector3(100.0, 200.0, 300.0);
      final endPosition = vm.Vector3(150.0, 250.0, 350.0);
      final startTarget = vm.Vector3(0.0, 0.0, 0.0);
      final endTarget = vm.Vector3(50.0, 50.0, 50.0);

      final cameraMovement = CameraMovement(
        startPosition: startPosition,
        endPosition: endPosition,
        startTarget: startTarget,
        endTarget: endTarget,
        duration: 5.0,
        type: CameraMovementType.linear,
      );

      expect(cameraMovement.startPosition, equals(startPosition));
      expect(cameraMovement.endPosition, equals(endPosition));
      expect(cameraMovement.startTarget, equals(startTarget));
      expect(cameraMovement.endTarget, equals(endTarget));
      expect(cameraMovement.duration, equals(5.0));
      expect(cameraMovement.type, equals(CameraMovementType.linear));
    });

    test('should handle different movement types', () {
      final startPos = vm.Vector3(0.0, 0.0, 0.0);
      final endPos = vm.Vector3(100.0, 100.0, 100.0);
      final startTarget = vm.Vector3.zero();
      final endTarget = vm.Vector3(10.0, 10.0, 10.0);

      for (final movementType in CameraMovementType.values) {
        final cameraMovement = CameraMovement(
          startPosition: startPos,
          endPosition: endPos,
          startTarget: startTarget,
          endTarget: endTarget,
          duration: 3.0,
          type: movementType,
        );

        expect(cameraMovement.type, equals(movementType));
        expect(cameraMovement.duration, equals(3.0));
      }
    });

    test('should handle zero duration', () {
      final cameraMovement = CameraMovement(
        startPosition: vm.Vector3(1.0, 2.0, 3.0),
        endPosition: vm.Vector3(1.0, 2.0, 3.0),
        startTarget: vm.Vector3.zero(),
        endTarget: vm.Vector3.zero(),
        duration: 0.0,
        type: CameraMovementType.linear,
      );

      expect(cameraMovement.duration, equals(0.0));
      expect(cameraMovement.type, equals(CameraMovementType.linear));
    });

    test('should handle very large duration', () {
      final cameraMovement = CameraMovement(
        startPosition: vm.Vector3(0.0, 0.0, 0.0),
        endPosition: vm.Vector3(1000.0, 1000.0, 1000.0),
        startTarget: vm.Vector3.zero(),
        endTarget: vm.Vector3(100.0, 100.0, 100.0),
        duration: 1000.0,
        type: CameraMovementType.bezier,
      );

      expect(cameraMovement.duration, equals(1000.0));
      expect(cameraMovement.type, equals(CameraMovementType.bezier));
    });

    test('should handle negative coordinates', () {
      final cameraMovement = CameraMovement(
        startPosition: vm.Vector3(-100.0, -200.0, -300.0),
        endPosition: vm.Vector3(-50.0, -100.0, -150.0),
        startTarget: vm.Vector3(-10.0, -20.0, -30.0),
        endTarget: vm.Vector3(-5.0, -10.0, -15.0),
        duration: 2.5,
        type: CameraMovementType.easeInOut,
      );

      expect(cameraMovement.startPosition.x, equals(-100.0));
      expect(cameraMovement.startPosition.y, equals(-200.0));
      expect(cameraMovement.startPosition.z, equals(-300.0));
      expect(cameraMovement.endPosition.x, equals(-50.0));
      expect(cameraMovement.endPosition.y, equals(-100.0));
      expect(cameraMovement.endPosition.z, equals(-150.0));
      expect(cameraMovement.startTarget.x, equals(-10.0));
      expect(cameraMovement.startTarget.y, equals(-20.0));
      expect(cameraMovement.startTarget.z, equals(-30.0));
      expect(cameraMovement.endTarget.x, equals(-5.0));
      expect(cameraMovement.endTarget.y, equals(-10.0));
      expect(cameraMovement.endTarget.z, equals(-15.0));
      expect(cameraMovement.type, equals(CameraMovementType.easeInOut));
    });

    test('should handle same start and end positions (no movement)', () {
      final position = vm.Vector3(42.0, 84.0, 126.0);
      final target = vm.Vector3(5.0, 10.0, 15.0);

      final cameraMovement = CameraMovement(
        startPosition: position.clone(),
        endPosition: position.clone(),
        startTarget: target.clone(),
        endTarget: target.clone(),
        duration: 1.0,
        type: CameraMovementType.linear,
      );

      expect(cameraMovement.startPosition, equals(cameraMovement.endPosition));
      expect(cameraMovement.startTarget, equals(cameraMovement.endTarget));
      expect(cameraMovement.type, equals(CameraMovementType.linear));
    });

    test('should handle orbital tracking scenario', () {
      // Camera following a planet around the sun
      final cameraMovement = CameraMovement(
        startPosition: vm.Vector3(150000000.0, 0.0, 50000000.0), // Behind Earth
        endPosition: vm.Vector3(0.0, 150000000.0, 50000000.0), // Side view
        startTarget: vm.Vector3(150000000.0, 0.0, 0.0), // Looking at Earth
        endTarget: vm.Vector3(0.0, 150000000.0, 0.0), // Earth's new position
        duration: 10.0,
        type: CameraMovementType.easeInOut,
      );

      expect(cameraMovement.startPosition.x, equals(150000000.0));
      expect(cameraMovement.endPosition.y, equals(150000000.0));
      expect(cameraMovement.duration, equals(10.0));
      expect(cameraMovement.type, equals(CameraMovementType.easeInOut));
    });

    test('should handle zoom movement', () {
      final target = vm.Vector3(0.0, 0.0, 0.0); // Focus point

      final cameraMovement = CameraMovement(
        startPosition: vm.Vector3(1000.0, 1000.0, 1000.0), // Far away
        endPosition: vm.Vector3(100.0, 100.0, 100.0), // Close up
        startTarget: target.clone(),
        endTarget: target.clone(), // Same target
        duration: 3.0,
        type: CameraMovementType.easeInOut,
      );

      // Both should target the same point
      expect(cameraMovement.startTarget, equals(cameraMovement.endTarget));
      expect(cameraMovement.type, equals(CameraMovementType.easeInOut));
    });

    test('should handle banking turn movement', () {
      final cameraMovement = CameraMovement(
        startPosition: vm.Vector3(100.0, 0.0, 0.0),
        endPosition: vm.Vector3(0.0, 100.0, 0.0),
        startTarget: vm.Vector3.zero(),
        endTarget: vm.Vector3.zero(),
        duration: 5.0,
        type: CameraMovementType.banking,
      );

      expect(cameraMovement.type, equals(CameraMovementType.banking));
      expect(cameraMovement.duration, equals(5.0));
    });

    test('should handle bezier curve movement', () {
      final cameraMovement = CameraMovement(
        startPosition: vm.Vector3(0.0, 0.0, 100.0),
        endPosition: vm.Vector3(100.0, 100.0, 0.0),
        startTarget: vm.Vector3(50.0, 50.0, 50.0),
        endTarget: vm.Vector3(75.0, 25.0, 25.0),
        duration: 8.0,
        type: CameraMovementType.bezier,
      );

      expect(cameraMovement.type, equals(CameraMovementType.bezier));
      expect(cameraMovement.duration, equals(8.0));
    });

    test('should handle very small movements', () {
      final cameraMovement = CameraMovement(
        startPosition: vm.Vector3(1.0, 1.0, 1.0),
        endPosition: vm.Vector3(1.001, 1.001, 1.001),
        startTarget: vm.Vector3.zero(),
        endTarget: vm.Vector3(0.001, 0.001, 0.001),
        duration: 0.1,
        type: CameraMovementType.linear,
      );

      expect(
        cameraMovement.startPosition.distanceTo(cameraMovement.endPosition),
        closeTo(0.001732, 0.0001),
      ); // √(0.001² * 3)
      expect(cameraMovement.duration, equals(0.1));
    });
  });
}
