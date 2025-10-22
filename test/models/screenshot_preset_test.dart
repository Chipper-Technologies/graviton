import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/models/camera_position.dart';
import 'package:graviton/models/screenshot_preset.dart';

void main() {
  group('ScreenshotPreset Tests', () {
    const testCameraPosition = CameraPosition(distance: 1000.0, yaw: 0.5);

    test('Should create ScreenshotPreset with required parameters', () {
      const preset = ScreenshotPreset(
        name: 'Test Preset',
        description: 'A test preset for unit testing',
        scenarioType: ScenarioType.solarSystem,
        configuration: {'testKey': 'testValue'},
        camera: testCameraPosition,
      );

      expect(preset.name, equals('Test Preset'));
      expect(preset.description, equals('A test preset for unit testing'));
      expect(preset.scenarioType, equals(ScenarioType.solarSystem));
      expect(preset.configuration, equals({'testKey': 'testValue'}));
      expect(preset.camera, equals(testCameraPosition));
      expect(preset.showUI, isFalse); // Default value
      expect(preset.showTrails, isTrue); // Default value
      expect(preset.trailType, equals('warm')); // Default value
    });

    test('Should create ScreenshotPreset with all parameters', () {
      const preset = ScreenshotPreset(
        name: 'Full Test Preset',
        description: 'A complete preset for testing',
        scenarioType: ScenarioType.galaxyFormation,
        configuration: {
          'bodyCount': 500,
          'centralMass': 50000.0,
          'diskRadius': 3000.0,
        },
        camera: testCameraPosition,
        showUI: true,
        showTrails: false,
        trailType: 'cool',
      );

      expect(preset.name, equals('Full Test Preset'));
      expect(preset.description, equals('A complete preset for testing'));
      expect(preset.scenarioType, equals(ScenarioType.galaxyFormation));
      expect(preset.configuration['bodyCount'], equals(500));
      expect(preset.configuration['centralMass'], equals(50000.0));
      expect(preset.configuration['diskRadius'], equals(3000.0));
      expect(preset.camera, equals(testCameraPosition));
      expect(preset.showUI, isTrue);
      expect(preset.showTrails, isFalse);
      expect(preset.trailType, equals('cool'));
    });

    test('Should handle complex configuration objects', () {
      const complexConfig = {
        'numbers': [1, 2, 3, 4, 5],
        'nested': {'innerKey': 'innerValue', 'innerNumber': 42},
        'boolean': true,
        'nullValue': null,
      };

      const preset = ScreenshotPreset(
        name: 'Complex Config Preset',
        description: 'Testing complex configuration',
        scenarioType: ScenarioType.threeBodyClassic,
        configuration: complexConfig,
        camera: testCameraPosition,
      );

      expect(preset.configuration['numbers'], equals([1, 2, 3, 4, 5]));
      expect(preset.configuration['nested']['innerKey'], equals('innerValue'));
      expect(preset.configuration['nested']['innerNumber'], equals(42));
      expect(preset.configuration['boolean'], isTrue);
      expect(preset.configuration['nullValue'], isNull);
    });

    test('Should handle empty configuration', () {
      const preset = ScreenshotPreset(
        name: 'Empty Config',
        description: 'Preset with empty configuration',
        scenarioType: ScenarioType.random,
        configuration: {},
        camera: testCameraPosition,
      );

      expect(preset.configuration, isEmpty);
      expect(preset.configuration, isA<Map<String, dynamic>>());
    });

    test('Should handle various camera positions', () {
      const extremeCamera = CameraPosition(
        distance: 99999.0,
        yaw: -3.14159,
        pitch: 1.5708,
        roll: -1.0472,
        targetX: -1000.0,
        targetY: 2000.0,
        targetZ: -500.0,
      );

      const preset = ScreenshotPreset(
        name: 'Extreme Camera',
        description: 'Testing extreme camera values',
        scenarioType: ScenarioType.deepSpace,
        configuration: {'extreme': true},
        camera: extremeCamera,
      );

      expect(preset.camera.distance, equals(99999.0));
      expect(preset.camera.yaw, equals(-3.14159));
      expect(preset.camera.pitch, equals(1.5708));
      expect(preset.camera.roll, equals(-1.0472));
      expect(preset.camera.targetX, equals(-1000.0));
      expect(preset.camera.targetY, equals(2000.0));
      expect(preset.camera.targetZ, equals(-500.0));
    });

    test('Should handle different trail types', () {
      const warmPreset = ScreenshotPreset(
        name: 'Warm Trails',
        description: 'Testing warm trail type',
        scenarioType: ScenarioType.solarSystem,
        configuration: {},
        camera: testCameraPosition,
        trailType: 'warm',
      );

      const coolPreset = ScreenshotPreset(
        name: 'Cool Trails',
        description: 'Testing cool trail type',
        scenarioType: ScenarioType.binaryStars,
        configuration: {},
        camera: testCameraPosition,
        trailType: 'cool',
      );

      expect(warmPreset.trailType, equals('warm'));
      expect(coolPreset.trailType, equals('cool'));
    });

    test('Should validate scenario types', () {
      final scenarioTypes = [
        ScenarioType.galaxyFormation,
        ScenarioType.solarSystem,
        ScenarioType.earthMoonSun,
        ScenarioType.binaryStars,
        ScenarioType.asteroidBelt,
        ScenarioType.threeBodyClassic,
        ScenarioType.collisionDemo,
        ScenarioType.deepSpace,
      ];

      for (final scenarioType in scenarioTypes) {
        final preset = ScreenshotPreset(
          name: 'Scenario Test',
          description: 'Testing scenario type',
          scenarioType: scenarioType,
          configuration: const {},
          camera: testCameraPosition,
        );

        expect(preset.scenarioType, equals(scenarioType));
      }
    });
  });
}
