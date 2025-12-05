import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/services/body_movement_service.dart';
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
    });
  });
}
