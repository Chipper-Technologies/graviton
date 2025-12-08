import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/ui_action.dart';

void main() {
  group('UIAction Enum', () {
    test('should have all expected UI actions', () {
      expect(UIAction.values.length, equals(112));
      expect(UIAction.values, contains(UIAction.tap));
      expect(UIAction.values, contains(UIAction.doubleTap));
      expect(UIAction.values, contains(UIAction.dialogOpened));
      expect(UIAction.values, contains(UIAction.scenarioSelected));
      expect(UIAction.values, contains(UIAction.buttonPressed));
      expect(UIAction.values, contains(UIAction.gestureStart));
      expect(UIAction.values, contains(UIAction.bodySelected));
      expect(UIAction.values, contains(UIAction.cameraFocus));
      expect(UIAction.values, contains(UIAction.followModeEnabled));
      expect(UIAction.values, contains(UIAction.followModeDisabled));
      expect(UIAction.values, contains(UIAction.cameraReset));
      expect(UIAction.values, contains(UIAction.cameraAutoZoom));
      expect(UIAction.values, contains(UIAction.autoRotateToggle));
      expect(UIAction.values, contains(UIAction.invertPitchToggle));
      expect(UIAction.values, contains(UIAction.galacticPlaneModeToggle));
      expect(UIAction.values, contains(UIAction.cameraCenter));
      expect(UIAction.values, contains(UIAction.followToggle));
      expect(UIAction.values, contains(UIAction.tutorialStarted));
      expect(UIAction.values, contains(UIAction.tutorialCompleted));
      expect(UIAction.values, contains(UIAction.changelogShown));
      expect(UIAction.values, contains(UIAction.changelogCompleted));
    });

    test('should have correct string values', () {
      expect(UIAction.tap.value, equals('tap'));
      expect(UIAction.doubleTap.value, equals('double_tap'));
      expect(UIAction.dialogOpened.value, equals('dialog_opened'));
      expect(UIAction.scenarioSelected.value, equals('scenario_selected'));
      expect(UIAction.buttonPressed.value, equals('button_pressed'));
      expect(UIAction.gestureStart.value, equals('gesture_start'));
      expect(UIAction.bodySelected.value, equals('body_selected'));
      expect(UIAction.cameraFocus.value, equals('camera_focus'));
      expect(UIAction.followModeEnabled.value, equals('follow_mode_enabled'));
      expect(UIAction.followModeDisabled.value, equals('follow_mode_disabled'));
      expect(UIAction.cameraReset.value, equals('camera_reset'));
      expect(UIAction.cameraAutoZoom.value, equals('camera_auto_zoom'));
      expect(UIAction.autoRotateToggle.value, equals('auto_rotate_toggle'));
      expect(UIAction.invertPitchToggle.value, equals('invert_pitch_toggle'));
      expect(
        UIAction.galacticPlaneModeToggle.value,
        equals('galactic_plane_mode_toggle'),
      );
      expect(UIAction.cameraCenter.value, equals('camera_center'));
      expect(UIAction.followToggle.value, equals('follow_toggle'));
      expect(UIAction.tutorialStarted.value, equals('tutorial_started'));
      expect(UIAction.tutorialCompleted.value, equals('tutorial_completed'));
      expect(UIAction.changelogShown.value, equals('changelog_shown'));
      expect(UIAction.changelogCompleted.value, equals('changelog_completed'));
    });

    test('should have unique string values', () {
      final values = UIAction.values.map((action) => action.value).toSet();
      expect(
        values.length,
        equals(UIAction.values.length),
        reason: 'All UI actions should have unique string values',
      );
    });

    test('should follow snake_case convention for string values', () {
      for (final action in UIAction.values) {
        expect(
          action.value,
          matches(RegExp(r'^[a-z]+(_[a-z]+)*$')),
          reason: '${action.value} should follow snake_case convention',
        );
      }
    });

    test('should group related actions logically', () {
      // Camera-related actions
      final cameraActions = UIAction.values
          .where(
            (action) =>
                action.value.contains('camera') ||
                action.value.contains('focus'),
          )
          .toList();
      expect(
        cameraActions,
        isNotEmpty,
        reason: 'Should have camera-related actions',
      );

      // Follow mode actions
      final followActions = UIAction.values
          .where((action) => action.value.contains('follow'))
          .toList();
      expect(
        followActions,
        isNotEmpty,
        reason: 'Should have follow-related actions',
      );

      // Tutorial/help actions
      final tutorialActions = UIAction.values
          .where(
            (action) =>
                action.value.contains('tutorial') ||
                action.value.contains('changelog'),
          )
          .toList();
      expect(
        tutorialActions,
        isNotEmpty,
        reason: 'Should have tutorial/help-related actions',
      );
    });

    test('should have paired actions where appropriate', () {
      // Follow mode should have enable/disable pair
      expect(UIAction.values, contains(UIAction.followModeEnabled));
      expect(UIAction.values, contains(UIAction.followModeDisabled));

      // Tutorial should have start/complete pair
      expect(UIAction.values, contains(UIAction.tutorialStarted));
      expect(UIAction.values, contains(UIAction.tutorialCompleted));

      // Changelog should have show/complete pair
      expect(UIAction.values, contains(UIAction.changelogShown));
      expect(UIAction.values, contains(UIAction.changelogCompleted));
    });

    test('should include visual effect toggle action', () {
      expect(UIAction.values, contains(UIAction.visualEffectToggle));
      expect(UIAction.visualEffectToggle.value, equals('visual_effect_toggle'));
    });

    test('should include physics controls actions', () {
      expect(UIAction.values, contains(UIAction.gravityFieldsToggle));
      expect(UIAction.values, contains(UIAction.equipotentialSurfacesToggle));
      expect(UIAction.values, contains(UIAction.gravityFieldIndicatorsToggle));
      expect(
        UIAction.values,
        contains(UIAction.gravityFieldColorSchemeChanged),
      );
      expect(UIAction.values, contains(UIAction.physicsSettingAdjusted));
    });

    test('should include visual controls actions', () {
      expect(UIAction.values, contains(UIAction.trailDisplayToggle));
      expect(UIAction.values, contains(UIAction.labelDisplayToggle));
      expect(UIAction.values, contains(UIAction.realisticColorsToggle));
      expect(UIAction.values, contains(UIAction.habitableZonesToggle));
      expect(UIAction.values, contains(UIAction.habitabilityIndicatorsToggle));
      expect(UIAction.values, contains(UIAction.orbitalPathsToggle));
      expect(UIAction.values, contains(UIAction.dualOrbitalPathsToggle));
      expect(UIAction.values, contains(UIAction.offscreenIndicatorsToggle));
    });

    test('should include simulation control actions', () {
      expect(UIAction.values, contains(UIAction.simulationStarted));
      expect(UIAction.values, contains(UIAction.simulationStopped));
      expect(UIAction.values, contains(UIAction.simulationPaused));
      expect(UIAction.values, contains(UIAction.simulationResumed));
      expect(UIAction.values, contains(UIAction.simulationReset));
      expect(UIAction.values, contains(UIAction.timeScaleAdjusted));
    });

    test('should include scenario management actions', () {
      expect(UIAction.values, contains(UIAction.scenarioCreationStarted));
      expect(UIAction.values, contains(UIAction.scenarioCreationCompleted));
      expect(UIAction.values, contains(UIAction.scenarioCreationCanceled));
      expect(UIAction.values, contains(UIAction.scenarioEditingStarted));
      expect(UIAction.values, contains(UIAction.scenarioEditingCompleted));
      expect(UIAction.values, contains(UIAction.bodyAdded));
      expect(UIAction.values, contains(UIAction.bodyRemoved));
      expect(UIAction.values, contains(UIAction.bodyEdited));
    });

    test('should include performance analytics actions', () {
      expect(UIAction.values, contains(UIAction.frameRateDegradation));
      expect(UIAction.values, contains(UIAction.memoryUsageSpike));
      expect(UIAction.values, contains(UIAction.renderingPerformanceIssue));
      expect(UIAction.values, contains(UIAction.physicsCalculationSlowdown));
    });

    test('should include fullscreen actions', () {
      expect(UIAction.values, contains(UIAction.fullscreenEntered));
      expect(UIAction.values, contains(UIAction.fullscreenExited));
      expect(UIAction.values, contains(UIAction.fullscreenToggled));
    });
  });
}
