import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/services/body_placement_service.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void main() {
  group('BodyPlacementService Tests', () {
    group('screenToWorld', () {
      test('should convert screen coordinates to world space', () {
        final screenPosition = const Offset(100, 100);
        final screenSize = const Size(800, 600);
        final viewMatrix = vm.Matrix4.identity();
        final projectionMatrix = vm.Matrix4.identity();
        final cameraPosition = vm.Vector3(0, 0, -100);
        final cameraTarget = vm.Vector3(0, 0, 0);
        const cameraDistance = 100.0;

        final result = BodyPlacementService.screenToWorld(
          screenPosition: screenPosition,
          screenSize: screenSize,
          viewMatrix: viewMatrix,
          projectionMatrix: projectionMatrix,
          cameraPosition: cameraPosition,
          cameraTarget: cameraTarget,
          cameraDistance: cameraDistance,
        );

        expect(result, isA<vm.Vector3>());
        expect(result.x.isFinite, isTrue);
        expect(result.y.isFinite, isTrue);
        expect(result.z.isFinite, isTrue);
      });

      test('should handle center screen position', () {
        final screenPosition = const Offset(400, 300);
        final screenSize = const Size(800, 600);
        final viewMatrix = vm.Matrix4.identity();
        final projectionMatrix = vm.Matrix4.identity();
        final cameraPosition = vm.Vector3(10, 20, -120);
        final cameraTarget = vm.Vector3(10, 20, 30);
        const cameraDistance = 150.0;

        final result = BodyPlacementService.screenToWorld(
          screenPosition: screenPosition,
          screenSize: screenSize,
          viewMatrix: viewMatrix,
          projectionMatrix: projectionMatrix,
          cameraPosition: cameraPosition,
          cameraTarget: cameraTarget,
          cameraDistance: cameraDistance,
        );

        expect(result.x.isFinite, isTrue);
        expect(result.y.isFinite, isTrue);
        expect(result.z.isFinite, isTrue);
      });

      test('should handle corner screen positions', () {
        final screenSize = const Size(1920, 1080);
        final viewMatrix = vm.Matrix4.identity();
        final projectionMatrix = vm.Matrix4.identity();
        final cameraPosition = vm.Vector3(0, 0, -200);
        final cameraTarget = vm.Vector3(0, 0, 0);
        const cameraDistance = 200.0;

        final corners = [
          const Offset(0, 0), // Top-left
          Offset(screenSize.width, 0), // Top-right
          Offset(0, screenSize.height), // Bottom-left
          Offset(screenSize.width, screenSize.height), // Bottom-right
        ];

        for (final corner in corners) {
          final result = BodyPlacementService.screenToWorld(
            screenPosition: corner,
            screenSize: screenSize,
            viewMatrix: viewMatrix,
            projectionMatrix: projectionMatrix,
            cameraPosition: cameraPosition,
            cameraTarget: cameraTarget,
            cameraDistance: cameraDistance,
          );

          expect(result.x.isFinite, isTrue);
          expect(result.y.isFinite, isTrue);
          expect(result.z.isFinite, isTrue);
        }
      });
    });

    group('calculateInitialVelocity', () {
      test('should return zero velocity when no existing bodies', () {
        final position = vm.Vector3(10, 0, 0);
        final existingPositions = <vm.Vector3>[];
        final existingMasses = <double>[];
        const gravitationalConstant = 1.2;

        final result = BodyPlacementService.calculateInitialVelocity(
          position: position,
          existingBodyPositions: existingPositions,
          existingBodyMasses: existingMasses,
          gravitationalConstant: gravitationalConstant,
        );

        expect(result, equals(vm.Vector3.zero()));
      });

      test('should calculate orbital velocity for nearby body', () {
        final position = vm.Vector3(10, 0, 0);
        final existingPositions = [vm.Vector3(0, 0, 0)];
        final existingMasses = [100.0];
        const gravitationalConstant = 1.2;

        final result = BodyPlacementService.calculateInitialVelocity(
          position: position,
          existingBodyPositions: existingPositions,
          existingBodyMasses: existingMasses,
          gravitationalConstant: gravitationalConstant,
        );

        expect(result.length, greaterThan(0));
        expect(result.x.isFinite, isTrue);
        expect(result.y.isFinite, isTrue);
        expect(result.z.isFinite, isTrue);
      });

      test('should find nearest body when multiple exist', () {
        final position = vm.Vector3(15, 0, 0);
        final existingPositions = [
          vm.Vector3(0, 0, 0), // Distance: 15
          vm.Vector3(10, 0, 0), // Distance: 5 (nearest)
          vm.Vector3(50, 0, 0), // Distance: 35
        ];
        final existingMasses = [100.0, 50.0, 200.0];
        const gravitationalConstant = 1.2;

        final result = BodyPlacementService.calculateInitialVelocity(
          position: position,
          existingBodyPositions: existingPositions,
          existingBodyMasses: existingMasses,
          gravitationalConstant: gravitationalConstant,
        );

        // Should calculate velocity based on nearest body (index 1)
        expect(result.length, greaterThan(0));
      });

      test('should handle position at same location as existing body', () {
        final position = vm.Vector3(0, 0, 0);
        final existingPositions = [vm.Vector3(0, 0, 0)];
        final existingMasses = [100.0];
        const gravitationalConstant = 1.2;

        final result = BodyPlacementService.calculateInitialVelocity(
          position: position,
          existingBodyPositions: existingPositions,
          existingBodyMasses: existingMasses,
          gravitationalConstant: gravitationalConstant,
        );

        // Should return zero velocity for same position
        expect(result, equals(vm.Vector3.zero()));
      });
    });

    group('validatePlacement', () {
      test('should return true for safe placement', () {
        final position = vm.Vector3(100, 0, 0);
        const radius = 5.0;
        final existingPositions = [vm.Vector3(0, 0, 0)];
        final existingRadii = [10.0];

        final result = BodyPlacementService.validatePlacement(
          position: position,
          radius: radius,
          existingBodyPositions: existingPositions,
          existingRadii: existingRadii,
        );

        expect(result, isTrue);
      });

      test('should return false for too close placement', () {
        final position = vm.Vector3(10, 0, 0);
        const radius = 5.0;
        final existingPositions = [vm.Vector3(0, 0, 0)];
        final existingRadii = [10.0];

        final result = BodyPlacementService.validatePlacement(
          position: position,
          radius: radius,
          existingBodyPositions: existingPositions,
          existingRadii: existingRadii,
        );

        expect(result, isFalse);
      });

      test('should return true when no existing bodies', () {
        final position = vm.Vector3(10, 0, 0);
        const radius = 5.0;
        final existingPositions = <vm.Vector3>[];
        final existingRadii = <double>[];

        final result = BodyPlacementService.validatePlacement(
          position: position,
          radius: radius,
          existingBodyPositions: existingPositions,
          existingRadii: existingRadii,
        );

        expect(result, isTrue);
      });

      test('should respect custom minimum separation', () {
        final position = vm.Vector3(50, 0, 0);
        const radius = 5.0;
        final existingPositions = [vm.Vector3(0, 0, 0)];
        final existingRadii = [10.0];

        // Test with default separation (3.0)
        final result1 = BodyPlacementService.validatePlacement(
          position: position,
          radius: radius,
          existingBodyPositions: existingPositions,
          existingRadii: existingRadii,
          minimumSeparation: 3.0,
        );
        expect(result1, isTrue);

        // Test with very high separation
        final result2 = BodyPlacementService.validatePlacement(
          position: position,
          radius: radius,
          existingBodyPositions: existingPositions,
          existingRadii: existingRadii,
          minimumSeparation: 10.0,
        );
        expect(result2, isFalse);
      });

      test('should check all existing bodies', () {
        final position = vm.Vector3(25, 0, 0);
        const radius = 5.0;
        final existingPositions = [
          vm.Vector3(0, 0, 0), // Far enough
          vm.Vector3(20, 0, 0), // Too close
          vm.Vector3(100, 0, 0), // Far enough
        ];
        final existingRadii = [10.0, 5.0, 15.0];

        final result = BodyPlacementService.validatePlacement(
          position: position,
          radius: radius,
          existingBodyPositions: existingPositions,
          existingRadii: existingRadii,
        );

        // Should return false because body at position[1] is too close
        expect(result, isFalse);
      });
    });
  });
}
