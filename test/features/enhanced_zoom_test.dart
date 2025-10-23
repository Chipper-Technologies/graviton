import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/state/camera_state.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void main() {
  group('Enhanced Zoom Tests', () {
    late CameraState cameraState;
    late List<Body> testBodies;

    setUp(() {
      cameraState = CameraState();

      // Create test bodies at different positions
      testBodies = [
        Body(
          position: vm.Vector3(0.0, 0.0, 0.0),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicRed,
          name: 'Body 0',
        ),
        Body(
          position: vm.Vector3(100.0, 0.0, 0.0),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Body 1',
        ),
        Body(
          position: vm.Vector3(-50.0, 50.0, 0.0),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicGreen,
          name: 'Body 2',
        ),
      ];
    });

    test('Should zoom normally when no body is selected', () {
      // Initial state - no body selected
      expect(cameraState.selectedBody, isNull);

      final initialDistance = cameraState.distance;
      final initialTarget = cameraState.target.clone();

      // Zoom in
      cameraState.zoomTowardBody(-0.1, testBodies);

      // Distance should change, target should remain the same
      expect(cameraState.distance, lessThan(initialDistance));
      expect(cameraState.target.x, equals(initialTarget.x));
      expect(cameraState.target.y, equals(initialTarget.y));
      expect(cameraState.target.z, equals(initialTarget.z));
    });

    test('Should zoom toward selected body', () {
      // Select the first body (at origin)
      cameraState.selectBody(0);
      cameraState.focusOnBody(0, testBodies);

      // Set camera target away from selected body
      cameraState.setTarget(vm.Vector3(50.0, 50.0, 0.0));
      final initialTarget = cameraState.target.clone();
      final selectedBodyPosition = testBodies[0].position;

      // Zoom in toward selected body
      cameraState.zoomTowardBody(-0.1, testBodies);

      // Target should move toward selected body
      final targetMovement = (cameraState.target - initialTarget).length;
      expect(targetMovement, greaterThan(0.0));

      // Target should be closer to selected body than before
      final distanceToBodyBefore =
          (initialTarget - selectedBodyPosition).length;
      final distanceToBodyAfter =
          (cameraState.target - selectedBodyPosition).length;
      expect(distanceToBodyAfter, lessThan(distanceToBodyBefore));
    });

    test('Should focus more aggressively when zooming in vs out', () {
      // Select body at position (100, 0, 0)
      cameraState.selectBody(1);
      cameraState.setTarget(vm.Vector3(0.0, 0.0, 0.0)); // Start at origin

      final initialTarget = cameraState.target.clone();

      // Zoom in (negative delta)
      cameraState.zoomTowardBody(-0.1, testBodies);
      final targetAfterZoomIn = cameraState.target.clone();

      // Reset target and zoom out (positive delta)
      cameraState.setTarget(initialTarget);
      cameraState.zoomTowardBody(0.1, testBodies);
      final targetAfterZoomOut = cameraState.target.clone();

      // Movement toward body should be greater when zooming in
      final movementZoomIn = (targetAfterZoomIn - initialTarget).length;
      final movementZoomOut = (targetAfterZoomOut - initialTarget).length;

      expect(movementZoomIn, greaterThan(movementZoomOut));
    });

    test('focusOnNearestBody should select closest body', () {
      // Set camera target near the third body (-50, 50, 0)
      cameraState.setTarget(vm.Vector3(-45.0, 55.0, 0.0));

      // Focus on nearest body
      cameraState.focusOnNearestBody(testBodies);

      // Should select body index 2 (the closest one)
      expect(cameraState.selectedBody, equals(2));
      expect(cameraState.target.x, equals(-50.0));
      expect(cameraState.target.y, equals(50.0));
      expect(cameraState.target.z, equals(0.0));
    });

    test('Should handle empty body list gracefully', () {
      cameraState.selectBody(0);
      final initialTarget = cameraState.target.clone();

      // Try to zoom with empty body list
      cameraState.zoomTowardBody(-0.1, []);

      // Should not crash and target should remain unchanged
      expect(cameraState.target.x, equals(initialTarget.x));
      expect(cameraState.target.y, equals(initialTarget.y));
      expect(cameraState.target.z, equals(initialTarget.z));
    });
  });
}
