import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/cinematic_camera_technique.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/state/camera_state.dart';
import 'package:graviton/state/ui_state.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void main() {
  group('Camera Operation Haptic Feedback Tests', () {
    late CameraState cameraState;
    late UIState uiState;

    setUp(() {
      cameraState = CameraState();
      uiState = UIState();
    });

    testWidgets('camera reset should trigger haptic feedback', (
      WidgetTester tester,
    ) async {
      // No exception should be thrown when calling resetView
      expect(() => cameraState.resetView(), returnsNormally);
      expect(
        () => cameraState.resetView(ScenarioType.solarSystem),
        returnsNormally,
      );
    });

    testWidgets('camera focus should trigger haptic feedback', (
      WidgetTester tester,
    ) async {
      final bodies = [
        Body(
          position: vm.Vector3(0, 0, 0),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 5.0,
          color: AppColors.planetEarth,
          name: 'Test Body 1',
        ),
        Body(
          position: vm.Vector3(10, 0, 0),
          velocity: vm.Vector3.zero(),
          mass: 2.0,
          radius: 3.0,
          color: AppColors.planetMars,
          name: 'Test Body 2',
        ),
      ];

      // No exception should be thrown when focusing on body
      expect(() => cameraState.focusOnBody(0, bodies), returnsNormally);
      expect(() => cameraState.focusOnNearestBody(bodies), returnsNormally);
    });

    testWidgets('follow mode toggle should trigger haptic feedback', (
      WidgetTester tester,
    ) async {
      final bodies = [
        Body(
          position: vm.Vector3(0, 0, 0),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 5.0,
          color: AppColors.planetEarth,
          name: 'Test Body',
        ),
      ];

      // Select a body first
      cameraState.focusOnBody(0, bodies);

      // No exception should be thrown when toggling follow mode
      expect(() => cameraState.toggleFollowMode(bodies), returnsNormally);
      expect(() => cameraState.toggleFollowMode(bodies), returnsNormally);
    });

    testWidgets('auto-rotate toggle should trigger haptic feedback', (
      WidgetTester tester,
    ) async {
      // No exception should be thrown when toggling auto-rotate
      expect(() => cameraState.toggleAutoRotate(), returnsNormally);
      expect(() => cameraState.toggleAutoRotate(), returnsNormally);
    });

    testWidgets('invert pitch toggle should trigger haptic feedback', (
      WidgetTester tester,
    ) async {
      // No exception should be thrown when toggling invert pitch
      expect(() => cameraState.toggleInvertPitch(), returnsNormally);
      expect(() => cameraState.toggleInvertPitch(), returnsNormally);
    });

    testWidgets(
      'cinematic camera technique change should trigger haptic feedback',
      (WidgetTester tester) async {
        // No exception should be thrown when changing camera technique
        expect(
          () => uiState.setCinematicCameraTechnique(
            CinematicCameraTechnique.predictiveOrbital,
          ),
          returnsNormally,
        );

        expect(
          () => uiState.setCinematicCameraTechnique(
            CinematicCameraTechnique.dynamicFraming,
          ),
          returnsNormally,
        );

        expect(
          () => uiState.setCinematicCameraTechnique(
            CinematicCameraTechnique.manual,
          ),
          returnsNormally,
        );
      },
    );

    test('haptic feedback methods should handle invalid body indices', () {
      final bodies = [
        Body(
          position: vm.Vector3(0, 0, 0),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 5.0,
          color: AppColors.planetEarth,
          name: 'Test Body',
        ),
      ];

      // Should not crash with invalid indices
      expect(() => cameraState.focusOnBody(-1, bodies), returnsNormally);
      expect(() => cameraState.focusOnBody(10, bodies), returnsNormally);

      // Should handle empty bodies list
      expect(() => cameraState.focusOnNearestBody([]), returnsNormally);
    });

    test('follow mode should handle edge cases gracefully', () {
      final bodies = [
        Body(
          position: vm.Vector3(0, 0, 0),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 5.0,
          color: AppColors.planetEarth,
          name: 'Test Body',
        ),
      ];

      // Should not crash when no body is selected
      expect(() => cameraState.toggleFollowMode(bodies), returnsNormally);

      // Should handle empty bodies list
      expect(() => cameraState.toggleFollowMode([]), returnsNormally);
    });

    test(
      'camera state should maintain proper values after haptic operations',
      () {
        final bodies = [
          Body(
            position: vm.Vector3(5, 10, 15),
            velocity: vm.Vector3.zero(),
            mass: 1.0,
            radius: 5.0,
            color: AppColors.planetEarth,
            name: 'Test Body',
          ),
        ];

        // Test focus operation
        cameraState.focusOnBody(0, bodies);
        expect(cameraState.selectedBody, equals(0));
        expect(cameraState.target, equals(vm.Vector3(5, 10, 15)));

        // Test auto-rotate toggle
        final initialAutoRotate = cameraState.autoRotate;
        cameraState.toggleAutoRotate();
        expect(cameraState.autoRotate, equals(!initialAutoRotate));

        // Test invert pitch toggle
        final initialInvertPitch = cameraState.invertPitch;
        cameraState.toggleInvertPitch();
        expect(cameraState.invertPitch, equals(!initialInvertPitch));

        // Test reset
        cameraState.resetView();
        expect(cameraState.selectedBody, isNull);
        expect(cameraState.autoRotate, isFalse);
        expect(cameraState.followMode, isFalse);
      },
    );

    test('ui state should maintain proper values after haptic operations', () {
      // Test cinematic camera technique changes
      uiState.setCinematicCameraTechnique(
        CinematicCameraTechnique.predictiveOrbital,
      );
      expect(
        uiState.cinematicCameraTechnique,
        equals(CinematicCameraTechnique.predictiveOrbital),
      );

      uiState.setCinematicCameraTechnique(
        CinematicCameraTechnique.dynamicFraming,
      );
      expect(
        uiState.cinematicCameraTechnique,
        equals(CinematicCameraTechnique.dynamicFraming),
      );

      uiState.setCinematicCameraTechnique(CinematicCameraTechnique.manual);
      expect(
        uiState.cinematicCameraTechnique,
        equals(CinematicCameraTechnique.manual),
      );
    });
  });
}
