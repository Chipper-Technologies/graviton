import 'dart:ui';
import 'package:vector_math/vector_math_64.dart' as vm;

/// Service for handling body movement and repositioning in 3D space
class BodyMovementService {
  BodyMovementService._();

  /// Convert screen drag delta to world space movement
  ///
  /// Moves the body perpendicular to the view direction, maintaining
  /// its distance from the camera.
  ///
  /// Parameters:
  /// - [dragDelta]: The change in screen position from the drag gesture
  /// - [screenSize]: The size of the screen/viewport
  /// - [viewMatrix]: The camera view matrix
  /// - [projectionMatrix]: The camera projection matrix
  /// - [currentPosition]: The body's current world position
  /// - [cameraPosition]: The camera's eye position
  ///
  /// Returns the new world position after applying the drag movement
  static vm.Vector3 applyScreenDrag({
    required Offset dragDelta,
    required Size screenSize,
    required vm.Matrix4 viewMatrix,
    required vm.Matrix4 projectionMatrix,
    required vm.Vector3 currentPosition,
    required vm.Vector3 cameraPosition,
  }) {
    // Calculate the view direction and perpendicular axes
    final toCamera = (cameraPosition - currentPosition).normalized();
    final worldUp = vm.Vector3(0, 1, 0);
    final right = worldUp.cross(toCamera).normalized();
    final up = toCamera.cross(right).normalized();

    // Calculate distance from camera to body
    final distanceFromCamera = (currentPosition - cameraPosition).length;

    // Convert screen delta to NDC delta
    final ndcDeltaX = (dragDelta.dx / screenSize.width) * 2.0;
    final ndcDeltaY = -(dragDelta.dy / screenSize.height) * 2.0; // Flip Y

    // Scale the movement based on distance from camera
    // Further objects move more per screen pixel
    final scaleFactor = distanceFromCamera * 0.001;

    // Apply movement in the right and up directions
    final movement = (right * ndcDeltaX + up * ndcDeltaY) * scaleFactor;

    return currentPosition + movement;
  }

  /// Calculate the screen position of a world point
  ///
  /// Used to track where the body appears on screen during movement
  ///
  /// Parameters:
  /// - [worldPosition]: The 3D world position to project
  /// - [viewMatrix]: The camera view matrix
  /// - [projectionMatrix]: The camera projection matrix
  /// - [screenSize]: The size of the screen/viewport
  ///
  /// Returns the screen coordinates, or null if behind camera
  static Offset? worldToScreen({
    required vm.Vector3 worldPosition,
    required vm.Matrix4 viewMatrix,
    required vm.Matrix4 projectionMatrix,
    required Size screenSize,
  }) {
    // Transform to homogeneous coordinates
    final homogeneousPos = vm.Vector4(
      worldPosition.x,
      worldPosition.y,
      worldPosition.z,
      1.0,
    );

    // Transform to clip space
    final clipPos = projectionMatrix * viewMatrix * homogeneousPos;

    // Check if behind camera
    if (clipPos.w <= 0) return null;

    // Convert to NDC
    final ndcX = clipPos.x / clipPos.w;
    final ndcY = clipPos.y / clipPos.w;
    final ndcZ = clipPos.z / clipPos.w;

    // Check if within frustum
    if (ndcZ > 1.0 || ndcZ < -1.0) return null;

    // Convert to screen coordinates
    final screenX = (ndcX + 1.0) * 0.5 * screenSize.width;
    final screenY = (1.0 - ndcY) * 0.5 * screenSize.height;

    return Offset(screenX, screenY);
  }
}
