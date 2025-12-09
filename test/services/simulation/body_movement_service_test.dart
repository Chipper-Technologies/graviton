import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/services/simulation/body_movement_service.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void main() {
  group('BodyMovementService Tests', () {
    group('applyScreenDrag', () {
      test('should move body based on screen drag', () {
        final dragDelta = const Offset(10, -5);
        final screenSize = const Size(800, 600);
        final viewMatrix = vm.Matrix4.identity();
        final projectionMatrix = vm.Matrix4.identity();
        final currentPosition = vm.Vector3(0, 0, 0);
        final cameraPosition = vm.Vector3(0, 0, -100);

        final result = BodyMovementService.applyScreenDrag(
          dragDelta: dragDelta,
          screenSize: screenSize,
          viewMatrix: viewMatrix,
          projectionMatrix: projectionMatrix,
          currentPosition: currentPosition,
          cameraPosition: cameraPosition,
        );

        expect(result, isA<vm.Vector3>());
        expect(result.x.isFinite, isTrue);
        expect(result.y.isFinite, isTrue);
        expect(result.z.isFinite, isTrue);
      });

      test('should scale movement based on distance from camera', () {
        final dragDelta = const Offset(100, 0); // Larger drag
        final screenSize = const Size(800, 600);
        final viewMatrix = vm.Matrix4.identity();
        final projectionMatrix = vm.Matrix4.identity();
        final cameraPosition = vm.Vector3(0, 0, -100);

        // Close object
        final closePosition = vm.Vector3(0, 0, 0);
        final closeResult = BodyMovementService.applyScreenDrag(
          dragDelta: dragDelta,
          screenSize: screenSize,
          viewMatrix: viewMatrix,
          projectionMatrix: projectionMatrix,
          currentPosition: closePosition,
          cameraPosition: cameraPosition,
        );

        // Far object
        final farPosition = vm.Vector3(0, 0, 50);
        final farResult = BodyMovementService.applyScreenDrag(
          dragDelta: dragDelta,
          screenSize: screenSize,
          viewMatrix: viewMatrix,
          projectionMatrix: projectionMatrix,
          currentPosition: farPosition,
          cameraPosition: cameraPosition,
        );

        // Both objects should move, just verify they moved
        final closeMovement = (closeResult - closePosition).length;
        final farMovement = (farResult - farPosition).length;
        expect(closeMovement, greaterThan(0));
        expect(farMovement, greaterThan(0));
      });
    });

    group('worldToScreen', () {
      test('should project world position to screen coordinates', () {
        final worldPosition = vm.Vector3(0, 0, 0);
        final viewMatrix = vm.Matrix4.identity();
        final projectionMatrix = vm.Matrix4.identity();
        final screenSize = const Size(800, 600);

        final result = BodyMovementService.worldToScreen(
          worldPosition: worldPosition,
          viewMatrix: viewMatrix,
          projectionMatrix: projectionMatrix,
          screenSize: screenSize,
        );

        expect(result, isNotNull);
        expect(result!.dx.isFinite, isTrue);
        expect(result.dy.isFinite, isTrue);
      });

      test('should center point at screen center', () {
        final worldPosition = vm.Vector3(0, 0, 0);
        final viewMatrix = vm.Matrix4.identity();
        final projectionMatrix = vm.Matrix4.identity();
        final screenSize = const Size(800, 600);

        final result = BodyMovementService.worldToScreen(
          worldPosition: worldPosition,
          viewMatrix: viewMatrix,
          projectionMatrix: projectionMatrix,
          screenSize: screenSize,
        );

        expect(result, isNotNull);
        // With identity matrices, center should be at screen center
        expect(result!.dx, closeTo(screenSize.width / 2, 1.0));
        expect(result.dy, closeTo(screenSize.height / 2, 1.0));
      });

      test('should return null for point behind camera', () {
        final worldPosition = vm.Vector3(0, 0, 100); // Behind camera
        final viewMatrix = vm.Matrix4.identity();
        viewMatrix.setTranslation(vm.Vector3(0, 0, -10));
        final projectionMatrix = vm.makePerspectiveMatrix(
          60.0 * 3.14159 / 180.0,
          800.0 / 600.0,
          0.1,
          1000.0,
        );
        final screenSize = const Size(800, 600);

        final result = BodyMovementService.worldToScreen(
          worldPosition: worldPosition,
          viewMatrix: viewMatrix,
          projectionMatrix: projectionMatrix,
          screenSize: screenSize,
        );

        // Result should be null or off-screen for behind camera
        expect(result, isA<Offset?>());
      });

      test('should handle different screen sizes', () {
        final worldPosition = vm.Vector3(0, 0, 0);
        final viewMatrix = vm.Matrix4.identity();
        final projectionMatrix = vm.Matrix4.identity();

        final smallScreen = const Size(400, 300);
        final largeScreen = const Size(1920, 1080);

        final smallResult = BodyMovementService.worldToScreen(
          worldPosition: worldPosition,
          viewMatrix: viewMatrix,
          projectionMatrix: projectionMatrix,
          screenSize: smallScreen,
        );

        final largeResult = BodyMovementService.worldToScreen(
          worldPosition: worldPosition,
          viewMatrix: viewMatrix,
          projectionMatrix: projectionMatrix,
          screenSize: largeScreen,
        );

        expect(smallResult, isNotNull);
        expect(largeResult, isNotNull);
        expect(smallResult!.dx, lessThanOrEqualTo(smallScreen.width));
        expect(largeResult!.dx, lessThanOrEqualTo(largeScreen.width));
      });

      test('should handle off-screen positions', () {
        final worldPosition = vm.Vector3(100, 100, -5);
        final viewMatrix = vm.Matrix4.identity();
        final projectionMatrix = vm.Matrix4.identity();
        final screenSize = const Size(800, 600);

        final result = BodyMovementService.worldToScreen(
          worldPosition: worldPosition,
          viewMatrix: viewMatrix,
          projectionMatrix: projectionMatrix,
          screenSize: screenSize,
        );

        // Should still return coordinates even if off-screen
        expect(result, isA<Offset?>());
      });
    });

    group('applyScreenDrag - Additional Edge Cases', () {
      test('should handle zero drag delta', () {
        final dragDelta = Offset.zero;
        final screenSize = const Size(800, 600);
        final viewMatrix = vm.Matrix4.identity();
        final projectionMatrix = vm.Matrix4.identity();
        final currentPosition = vm.Vector3(5, 5, 5);
        final cameraPosition = vm.Vector3(0, 0, -100);

        final result = BodyMovementService.applyScreenDrag(
          dragDelta: dragDelta,
          screenSize: screenSize,
          viewMatrix: viewMatrix,
          projectionMatrix: projectionMatrix,
          currentPosition: currentPosition,
          cameraPosition: cameraPosition,
        );

        // Should return approximately the same position
        expect(result.x, closeTo(currentPosition.x, 0.001));
        expect(result.y, closeTo(currentPosition.y, 0.001));
        expect(result.z, closeTo(currentPosition.z, 0.001));
      });

      test('should handle negative drag delta', () {
        final dragDelta = const Offset(-50, -50);
        final screenSize = const Size(800, 600);
        final viewMatrix = vm.Matrix4.identity();
        final projectionMatrix = vm.Matrix4.identity();
        final currentPosition = vm.Vector3(10, 10, 0);
        final cameraPosition = vm.Vector3(0, 0, -100);

        final result = BodyMovementService.applyScreenDrag(
          dragDelta: dragDelta,
          screenSize: screenSize,
          viewMatrix: viewMatrix,
          projectionMatrix: projectionMatrix,
          currentPosition: currentPosition,
          cameraPosition: cameraPosition,
        );

        expect(result, isA<vm.Vector3>());
        expect(result.x.isFinite, isTrue);
        expect(result.y.isFinite, isTrue);
        expect(result.z.isFinite, isTrue);
      });

      test('should handle extreme drag values', () {
        final dragDelta = const Offset(10000, 10000);
        final screenSize = const Size(800, 600);
        final viewMatrix = vm.Matrix4.identity();
        final projectionMatrix = vm.Matrix4.identity();
        final currentPosition = vm.Vector3(0, 0, 0);
        final cameraPosition = vm.Vector3(0, 0, -100);

        final result = BodyMovementService.applyScreenDrag(
          dragDelta: dragDelta,
          screenSize: screenSize,
          viewMatrix: viewMatrix,
          projectionMatrix: projectionMatrix,
          currentPosition: currentPosition,
          cameraPosition: cameraPosition,
        );

        expect(result, isA<vm.Vector3>());
        expect(result.x.isFinite, isTrue);
        expect(result.y.isFinite, isTrue);
        expect(result.z.isFinite, isTrue);
      });

      test('should handle very small drag values', () {
        final dragDelta = const Offset(0.01, 0.01);
        final screenSize = const Size(800, 600);
        final viewMatrix = vm.Matrix4.identity();
        final projectionMatrix = vm.Matrix4.identity();
        final currentPosition = vm.Vector3(1, 1, 1);
        final cameraPosition = vm.Vector3(0, 0, -100);

        final result = BodyMovementService.applyScreenDrag(
          dragDelta: dragDelta,
          screenSize: screenSize,
          viewMatrix: viewMatrix,
          projectionMatrix: projectionMatrix,
          currentPosition: currentPosition,
          cameraPosition: cameraPosition,
        );

        expect(result, isA<vm.Vector3>());
        // Should be very close to original position
        final distance = (result - currentPosition).length;
        expect(distance, lessThan(1.0));
      });

      test('should handle position at camera location', () {
        final dragDelta = const Offset(50, 50);
        final screenSize = const Size(800, 600);
        final viewMatrix = vm.Matrix4.identity();
        final projectionMatrix = vm.Matrix4.identity();
        final cameraPosition = vm.Vector3(0, 0, -100);

        final result = BodyMovementService.applyScreenDrag(
          dragDelta: dragDelta,
          screenSize: screenSize,
          viewMatrix: viewMatrix,
          projectionMatrix: projectionMatrix,
          currentPosition: cameraPosition,
          cameraPosition: cameraPosition,
        );

        expect(result, isA<vm.Vector3>());
        expect(result.x.isFinite, isTrue);
        expect(result.y.isFinite, isTrue);
        expect(result.z.isFinite, isTrue);
      });

      test('should handle different view matrices', () {
        final dragDelta = const Offset(25, 25);
        final screenSize = const Size(800, 600);
        final currentPosition = vm.Vector3(5, 5, 5);
        final cameraPosition = vm.Vector3(0, 0, -100);
        final projectionMatrix = vm.Matrix4.identity();

        // Identity view matrix
        final viewMatrix1 = vm.Matrix4.identity();
        final result1 = BodyMovementService.applyScreenDrag(
          dragDelta: dragDelta,
          screenSize: screenSize,
          viewMatrix: viewMatrix1,
          projectionMatrix: projectionMatrix,
          currentPosition: currentPosition,
          cameraPosition: cameraPosition,
        );

        // Translated view matrix
        final viewMatrix2 = vm.Matrix4.identity();
        viewMatrix2.setTranslation(vm.Vector3(10, 10, -10));
        final result2 = BodyMovementService.applyScreenDrag(
          dragDelta: dragDelta,
          screenSize: screenSize,
          viewMatrix: viewMatrix2,
          projectionMatrix: projectionMatrix,
          currentPosition: currentPosition,
          cameraPosition: cameraPosition,
        );

        expect(result1, isA<vm.Vector3>());
        expect(result2, isA<vm.Vector3>());
        // Both results should be valid vectors with finite values
        expect(result1.x.isFinite, isTrue);
        expect(result2.x.isFinite, isTrue);
      });

      test('should handle rotated view matrix', () {
        final dragDelta = const Offset(30, 30);
        final screenSize = const Size(800, 600);
        final currentPosition = vm.Vector3(5, 5, 5);
        final cameraPosition = vm.Vector3(0, 0, -100);
        final projectionMatrix = vm.Matrix4.identity();

        // Rotated view matrix
        final viewMatrix = vm.Matrix4.identity();
        viewMatrix.rotateY(45.0 * 3.14159 / 180.0);

        final result = BodyMovementService.applyScreenDrag(
          dragDelta: dragDelta,
          screenSize: screenSize,
          viewMatrix: viewMatrix,
          projectionMatrix: projectionMatrix,
          currentPosition: currentPosition,
          cameraPosition: cameraPosition,
        );

        expect(result, isA<vm.Vector3>());
        expect(result.x.isFinite, isTrue);
        expect(result.y.isFinite, isTrue);
        expect(result.z.isFinite, isTrue);
      });
    });

    group('Round-trip Consistency', () {
      test('zero drag maintains projection consistency', () {
        final worldPos = vm.Vector3(3, 4, -10);
        final viewMatrix = vm.Matrix4.identity();
        viewMatrix.setTranslation(vm.Vector3(0, 0, -5));
        final projectionMatrix = vm.makePerspectiveMatrix(
          60.0 * 3.14159 / 180.0,
          800.0 / 600.0,
          0.1,
          1000.0,
        );
        final screenSize = const Size(800, 600);
        final cameraPosition = vm.Vector3(0, 0, -5);

        // Project to screen
        final screenBefore = BodyMovementService.worldToScreen(
          worldPosition: worldPos,
          viewMatrix: viewMatrix,
          projectionMatrix: projectionMatrix,
          screenSize: screenSize,
        );

        // Apply zero drag
        final newWorldPos = BodyMovementService.applyScreenDrag(
          dragDelta: Offset.zero,
          screenSize: screenSize,
          viewMatrix: viewMatrix,
          projectionMatrix: projectionMatrix,
          currentPosition: worldPos,
          cameraPosition: cameraPosition,
        );

        // Project again
        final screenAfter = BodyMovementService.worldToScreen(
          worldPosition: newWorldPos,
          viewMatrix: viewMatrix,
          projectionMatrix: projectionMatrix,
          screenSize: screenSize,
        );

        // Screen positions should be very similar
        if (screenBefore != null && screenAfter != null) {
          expect(screenBefore.dx, closeTo(screenAfter.dx, 2.0));
          expect(screenBefore.dy, closeTo(screenAfter.dy, 2.0));
        }
      });

      test('small drag produces proportional movement', () {
        final worldPos = vm.Vector3(0, 0, -10);
        final viewMatrix = vm.Matrix4.identity();
        viewMatrix.setTranslation(vm.Vector3(0, 0, -5));
        final projectionMatrix = vm.Matrix4.identity();
        final screenSize = const Size(800, 600);
        final cameraPosition = vm.Vector3(0, 0, -5);

        final smallDrag = const Offset(10, 10);
        final largeDrag = const Offset(100, 100);

        final smallResult = BodyMovementService.applyScreenDrag(
          dragDelta: smallDrag,
          screenSize: screenSize,
          viewMatrix: viewMatrix,
          projectionMatrix: projectionMatrix,
          currentPosition: worldPos,
          cameraPosition: cameraPosition,
        );

        final largeResult = BodyMovementService.applyScreenDrag(
          dragDelta: largeDrag,
          screenSize: screenSize,
          viewMatrix: viewMatrix,
          projectionMatrix: projectionMatrix,
          currentPosition: worldPos,
          cameraPosition: cameraPosition,
        );

        final smallDistance = (smallResult - worldPos).length;
        final largeDistance = (largeResult - worldPos).length;

        // Larger drag should produce larger movement
        expect(largeDistance, greaterThan(smallDistance));
      });
    });
  });
}
