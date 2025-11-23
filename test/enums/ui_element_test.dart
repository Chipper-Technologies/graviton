import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/ui_element.dart';

void main() {
  group('UIElement Enum', () {
    test('should have all expected UI elements', () {
      expect(UIElement.values.length, equals(63));
      expect(UIElement.values, contains(UIElement.simulationViewport));
      expect(UIElement.values, contains(UIElement.scenarioSelection));
      expect(UIElement.values, contains(UIElement.scenarioDialog));
      expect(UIElement.values, contains(UIElement.settings));
      expect(UIElement.values, contains(UIElement.simulationControl));
      expect(UIElement.values, contains(UIElement.cameraControls));
      expect(UIElement.values, contains(UIElement.camera));
      expect(UIElement.values, contains(UIElement.body));
      expect(UIElement.values, contains(UIElement.scenario));
      expect(UIElement.values, contains(UIElement.help));
      expect(UIElement.values, contains(UIElement.tutorial));
      expect(UIElement.values, contains(UIElement.bodyProperties));
      expect(UIElement.values, contains(UIElement.physicsSettings));
      expect(UIElement.values, contains(UIElement.changelog));
      expect(UIElement.values, contains(UIElement.accountManagement));
    });

    test('should have correct string values', () {
      expect(UIElement.simulationViewport.value, equals('simulation_viewport'));
      expect(UIElement.scenarioSelection.value, equals('scenario_selection'));
      expect(UIElement.scenarioDialog.value, equals('scenario_dialog'));
      expect(UIElement.settings.value, equals('settings'));
      expect(UIElement.simulationControl.value, equals('simulation_control'));
      expect(UIElement.cameraControls.value, equals('camera_controls'));
      expect(UIElement.camera.value, equals('camera'));
      expect(UIElement.body.value, equals('body'));
      expect(UIElement.scenario.value, equals('scenario'));
      expect(UIElement.help.value, equals('help'));
      expect(UIElement.tutorial.value, equals('tutorial'));
      expect(UIElement.bodyProperties.value, equals('body_properties'));
      expect(UIElement.physicsSettings.value, equals('physics_settings'));
      expect(UIElement.changelog.value, equals('changelog'));
      expect(UIElement.accountManagement.value, equals('account_management'));
      expect(UIElement.about.value, equals('about'));
      expect(UIElement.bodySelection.value, equals('body_selection'));
    });

    test('should have unique string values', () {
      final values = UIElement.values.map((element) => element.value).toSet();
      expect(
        values.length,
        equals(UIElement.values.length),
        reason: 'All UI elements should have unique string values',
      );
    });

    test('should follow snake_case convention for string values', () {
      final snakeCasePattern = RegExp(r'^[a-z][a-z0-9]*(_[a-z0-9]+)*$');
      for (final element in UIElement.values) {
        expect(
          snakeCasePattern.hasMatch(element.value),
          isTrue,
          reason: '${element.value} should follow snake_case convention',
        );
      }
    });

    test('should group related elements logically', () {
      // Simulation-related elements
      final simulationElements = UIElement.values
          .where((element) => element.value.contains('simulation'))
          .toList();
      expect(
        simulationElements,
        isNotEmpty,
        reason: 'Should have simulation-related elements',
      );

      // Camera-related elements
      final cameraElements = UIElement.values
          .where((element) => element.value.contains('camera'))
          .toList();
      expect(
        cameraElements,
        isNotEmpty,
        reason: 'Should have camera-related elements',
      );

      // Dialog/settings elements
      final dialogElements = UIElement.values
          .where(
            (element) =>
                element.value.contains('dialog') ||
                element.value.contains('settings'),
          )
          .toList();
      expect(
        dialogElements,
        isNotEmpty,
        reason: 'Should have dialog/settings elements',
      );

      // Body-related elements
      final bodyElements = UIElement.values
          .where((element) => element.value.contains('body'))
          .toList();
      expect(
        bodyElements,
        isNotEmpty,
        reason: 'Should have body-related elements',
      );
    });

    test('should cover all major UI areas', () {
      // Core simulation elements
      expect(UIElement.values, contains(UIElement.simulationViewport));
      expect(UIElement.values, contains(UIElement.simulationControl));

      // Navigation and selection
      expect(UIElement.values, contains(UIElement.scenarioSelection));
      expect(UIElement.values, contains(UIElement.scenarioDialog));

      // Configuration
      expect(UIElement.values, contains(UIElement.settings));
      expect(UIElement.values, contains(UIElement.physicsSettings));

      // Help and guidance
      expect(UIElement.values, contains(UIElement.help));
      expect(UIElement.values, contains(UIElement.tutorial));
      expect(UIElement.values, contains(UIElement.changelog));

      // Interactive elements
      expect(UIElement.values, contains(UIElement.body));
      expect(UIElement.values, contains(UIElement.camera));
      expect(UIElement.values, contains(UIElement.cameraControls));
    });

    test('should have analytics-friendly naming', () {
      for (final element in UIElement.values) {
        // Should not contain spaces or special characters
        expect(element.value, isNot(contains(' ')));
        expect(element.value, isNot(contains('-')));
        expect(element.value, isNot(contains('.')));

        // Should be descriptive enough for analytics
        expect(
          element.value.length,
          greaterThan(3),
          reason: '${element.value} should be descriptive for analytics',
        );
      }
    });
  });
}
