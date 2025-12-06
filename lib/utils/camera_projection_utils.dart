import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:graviton/constants/rendering_constants.dart';
import 'package:graviton/state/camera_state.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// Utility functions for camera projection and coordinate transformation
class CameraProjectionUtils {
  CameraProjectionUtils._(); // Private constructor to prevent instantiation

  /// Project a 3D world position to 2D screen coordinates
  ///
  /// Returns null if the point is behind the camera or outside the viewing frustum.
  ///
  /// Parameters:
  /// - [worldPos]: 3D position in world space
  /// - [view]: View matrix (camera transformation)
  /// - [proj]: Projection matrix (perspective transformation)
  /// - [screenSize]: Size of the screen/viewport
  static Offset? projectToScreen(
    vm.Vector3 worldPos,
    vm.Matrix4 view,
    vm.Matrix4 proj,
    Size screenSize,
  ) {
    // Transform world position to homogeneous coordinates
    final homogeneousPos = vm.Vector4(worldPos.x, worldPos.y, worldPos.z, 1.0);

    // Transform to camera space then to clip space
    final clipPos = proj * view * homogeneousPos;

    // Check if point is in front of camera (w should be positive)
    if (clipPos.w <= 0) return null;

    // Convert to normalized device coordinates (NDC)
    final ndc = vm.Vector3(
      clipPos.x / clipPos.w,
      clipPos.y / clipPos.w,
      clipPos.z / clipPos.w,
    );

    // Check if point is within the viewing frustum
    if (ndc.z > 1.0 || ndc.z < -1.0) return null;

    // Convert NDC to screen coordinates
    final screenX = (ndc.x + 1.0) * 0.5 * screenSize.width;
    final screenY = (1.0 - ndc.y) * 0.5 * screenSize.height; // Flip Y axis

    return Offset(screenX, screenY);
  }

  /// Build the view matrix from camera state
  ///
  /// The view matrix transforms world coordinates to camera space,
  /// taking into account the camera's position, target, and roll angle.
  ///
  /// Parameters:
  /// - [camera]: The camera state containing position, target, and roll information
  static vm.Matrix4 buildViewMatrix(CameraState camera) {
    final eye = camera.eyePosition;
    final target = camera.target;

    // Calculate the forward vector (from eye to target)
    final forward = (target - eye).normalized();

    // Calculate the right vector (cross product of forward and world up)
    final right = forward.cross(RenderingConstants.worldUp).normalized();

    // Calculate the up vector (cross product of right and forward)
    final up = right.cross(forward).normalized();

    // Apply roll rotation around the forward vector (Z-axis in camera space)
    final roll = camera.roll;
    final cosRoll = math.cos(roll);
    final sinRoll = math.sin(roll);

    // Rotate the up vector by the roll angle
    final rolledUp = up * cosRoll - right * sinRoll;

    return vm.makeViewMatrix(eye, target, rolledUp);
  }

  /// Build the projection matrix for perspective rendering
  ///
  /// Creates a perspective projection matrix that transforms camera space
  /// coordinates to clip space, with proper field of view and clipping planes.
  ///
  /// Parameters:
  /// - [camera]: The camera state containing field of view
  /// - [aspectRatio]: The aspect ratio of the viewport (width / height)
  static vm.Matrix4 buildProjectionMatrix(
    CameraState camera,
    double aspectRatio,
  ) {
    return vm.makePerspectiveMatrix(
      vm.radians(camera.fieldOfView),
      aspectRatio,
      0.1,
      4000.0,
    );
  }
}
