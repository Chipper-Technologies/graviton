import 'dart:math' as math;
import 'dart:ui';
import 'package:vector_math/vector_math_64.dart' as vm;

/// Service for converting screen coordinates to 3D world space for body placement
class BodyPlacementService {
  BodyPlacementService._();

  /// Convert screen tap position to 3D world coordinates
  ///
  /// Uses a very simple approach: places the body at the camera target,
  /// with offsets based on where you tapped on screen. The camera target
  /// is already where the user is looking, so this provides intuitive placement.
  ///
  /// Parameters:
  /// - [screenPosition]: The tap position in screen coordinates
  /// - [screenSize]: The size of the screen/viewport
  /// - [viewMatrix]: The camera view matrix (unused but kept for API consistency)
  /// - [projectionMatrix]: The camera projection matrix (unused but kept for API consistency)
  /// - [cameraPosition]: The camera's eye position
  /// - [cameraTarget]: The camera's current target point
  /// - [cameraDistance]: The distance from camera to target
  ///
  /// Returns the 3D world position where the body should be placed
  static vm.Vector3 screenToWorld({
    required Offset screenPosition,
    required Size screenSize,
    required vm.Matrix4 viewMatrix,
    required vm.Matrix4 projectionMatrix,
    required vm.Vector3 cameraPosition,
    required vm.Vector3 cameraTarget,
    required double cameraDistance,
  }) {
    // Calculate normalized screen position (-1 to 1)
    final normalizedX = (screenPosition.dx / screenSize.width) * 2.0 - 1.0;
    final normalizedY = 1.0 - (screenPosition.dy / screenSize.height) * 2.0;

    // Calculate camera's right and up vectors
    final viewDir = (cameraTarget - cameraPosition).normalized();
    final worldUp = vm.Vector3(0, 1, 0);
    final right = worldUp.cross(viewDir).normalized();
    final up = viewDir.cross(right).normalized();

    // Scale based on distance - further away = larger offsets
    final offsetScale = cameraDistance * 0.5;

    // Apply offsets from camera target
    final offset = (right * normalizedX + up * normalizedY) * offsetScale;

    return cameraTarget + offset;
  }

  /// Calculate a reasonable initial velocity for a newly placed body
  ///
  /// If there are nearby bodies, calculate an orbital velocity
  /// Otherwise, return zero velocity
  ///
  /// Parameters:
  /// - [position]: The position of the new body
  /// - [existingBodies]: List of existing bodies in the simulation
  /// - [gravitationalConstant]: The simulation's gravitational constant
  ///
  /// Returns the initial velocity vector
  static vm.Vector3 calculateInitialVelocity({
    required vm.Vector3 position,
    required List<vm.Vector3> existingBodyPositions,
    required List<double> existingBodyMasses,
    required double gravitationalConstant,
  }) {
    if (existingBodyPositions.isEmpty) {
      return vm.Vector3.zero();
    }

    // Find the nearest massive body
    double closestDistance = double.infinity;
    int closestIndex = -1;

    for (int i = 0; i < existingBodyPositions.length; i++) {
      final distance = (existingBodyPositions[i] - position).length;
      if (distance < closestDistance && distance > 1e-6) {
        closestDistance = distance;
        closestIndex = i;
      }
    }

    // If no nearby body found, return zero velocity
    if (closestIndex == -1) {
      return vm.Vector3.zero();
    }

    // Calculate orbital velocity perpendicular to the radial direction
    final centralBodyPos = existingBodyPositions[closestIndex];
    final centralBodyMass = existingBodyMasses[closestIndex];

    final radialVector = position - centralBodyPos;
    final distance = radialVector.length;

    if (distance < 1e-6) {
      return vm.Vector3.zero();
    }

    // Orbital velocity magnitude: v = sqrt(G * M / r)
    final orbitalSpeed = math.sqrt(
      (gravitationalConstant * centralBodyMass / distance).abs(),
    );

    // Get perpendicular direction for circular orbit
    // Use cross product with up vector to get perpendicular direction
    final up = vm.Vector3(0, 1, 0);
    final perpendicular = radialVector.cross(up);

    // If perpendicular is too small, use another axis
    if (perpendicular.length < 1e-6) {
      final alternate = vm.Vector3(1, 0, 0);
      final altPerpendicular = radialVector.cross(alternate);
      return altPerpendicular.normalized() * orbitalSpeed;
    }

    return perpendicular.normalized() * orbitalSpeed;
  }

  /// Validate that a body can be placed at the given position
  ///
  /// Checks for collision risks with existing bodies
  ///
  /// Parameters:
  /// - [position]: The proposed position for the new body
  /// - [radius]: The radius of the new body
  /// - [existingBodies]: List of existing bodies in the simulation
  /// - [existingRadii]: List of radii for existing bodies
  /// - [minimumSeparation]: Minimum safe distance multiplier (default 1.5)
  ///
  /// Returns true if the position is safe, false otherwise
  static bool validatePlacement({
    required vm.Vector3 position,
    required double radius,
    required List<vm.Vector3> existingBodyPositions,
    required List<double> existingRadii,
    double minimumSeparation = 1.5,
  }) {
    for (int i = 0; i < existingBodyPositions.length; i++) {
      final distance = (existingBodyPositions[i] - position).length;
      final combinedRadius = (radius + existingRadii[i]) * minimumSeparation;

      if (distance < combinedRadius) {
        return false; // Too close to existing body
      }
    }

    return true;
  }
}
