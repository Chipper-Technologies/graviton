import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/screenshot_presets.dart';

void main() {
  group('ScreenshotPresets Tests', () {
    testWidgets('Should have all 12 predefined presets', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (BuildContext context) {
              final l10n = AppLocalizations.of(context)!;
              final presets = ScreenshotPresets.getPresets(l10n);
              expect(presets.length, equals(12));
              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('Should use ScenarioType enum values', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (BuildContext context) {
              final l10n = AppLocalizations.of(context)!;
              final presets = ScreenshotPresets.getPresets(l10n);

              // Test that all presets use ScenarioType enum values
              for (final preset in presets) {
                expect(preset.scenarioType, isA<ScenarioType>());
              }

              // Test specific scenario types are used
              final scenarioTypes = presets.map((p) => p.scenarioType).toSet();
              expect(scenarioTypes, contains(ScenarioType.galaxyFormation));
              expect(scenarioTypes, contains(ScenarioType.solarSystem));
              expect(scenarioTypes, contains(ScenarioType.earthMoonSun));
              expect(scenarioTypes, contains(ScenarioType.binaryStars));
              expect(scenarioTypes, contains(ScenarioType.asteroidBelt));
              expect(scenarioTypes, contains(ScenarioType.threeBodyClassic));

              return Container();
            },
          ),
        ),
      );
    });

    test('ScenarioType enum should have string conversion methods', () {
      // Test stringValue method
      expect(ScenarioType.galaxyFormation.stringValue, equals('galaxy_formation'));
      expect(ScenarioType.solarSystem.stringValue, equals('solar_system'));
      expect(ScenarioType.earthMoonSun.stringValue, equals('earth_moon_sun'));
      expect(ScenarioType.binaryStars.stringValue, equals('binary_star'));
      expect(ScenarioType.asteroidBelt.stringValue, equals('asteroid_belt'));
      expect(ScenarioType.threeBodyClassic.stringValue, equals('three_body_classic'));
      expect(ScenarioType.collisionDemo.stringValue, equals('collision_demo'));
      expect(ScenarioType.deepSpace.stringValue, equals('deep_space'));

      // Test fromString method
      expect(ScenarioType.fromString('galaxy_formation'), equals(ScenarioType.galaxyFormation));
      expect(ScenarioType.fromString('solar_system'), equals(ScenarioType.solarSystem));
      expect(ScenarioType.fromString('earth_moon_sun'), equals(ScenarioType.earthMoonSun));
      expect(ScenarioType.fromString('binary_star'), equals(ScenarioType.binaryStars));
      expect(ScenarioType.fromString('asteroid_belt'), equals(ScenarioType.asteroidBelt));
      expect(ScenarioType.fromString('three_body_classic'), equals(ScenarioType.threeBodyClassic));
      expect(ScenarioType.fromString('collision_demo'), equals(ScenarioType.collisionDemo));
      expect(ScenarioType.fromString('deep_space'), equals(ScenarioType.deepSpace));

      // Test error case
      expect(() => ScenarioType.fromString('invalid_scenario'), throwsArgumentError);
    });
  });
}
