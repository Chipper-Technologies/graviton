import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/state/simulation_state.dart';
import 'package:graviton/enums/scenario_type.dart';
import '../test_utils.dart';

void main() {
  group('Gravity Well Reset Preservation Tests', () {
    late SimulationState simulationState;

    setUp(() async {
      simulationState = SimulationState();
      final mockL10n = TestUtils.createMockAppLocalizations();
      simulationState.updateLocalization(mockL10n);
      await simulationState.initialize();
    });

    tearDown(() {
      simulationState.dispose();
    });

    test('reset should preserve gravity well settings', () async {
      // Set up initial scenario
      simulationState.resetWithScenario(ScenarioType.solarSystem);

      // Enable gravity wells for some bodies
      final bodies = simulationState.bodies;
      expect(bodies.length, greaterThan(0));

      // Enable gravity wells for specific bodies
      if (bodies.isNotEmpty) {
        bodies[0].showGravityWell = true;
      }
      if (bodies.length > 1) {
        bodies[1].showGravityWell = false;
      }
      if (bodies.length > 2) {
        bodies[2].showGravityWell = true;
      }

      // Store the original settings
      final originalSettings = bodies
          .map((body) => body.showGravityWell)
          .toList();

      // Reset the simulation
      simulationState.reset();

      // Check that gravity well settings are preserved
      final newBodies = simulationState.bodies;
      expect(newBodies.length, equals(bodies.length));

      for (
        int i = 0;
        i < newBodies.length && i < originalSettings.length;
        i++
      ) {
        expect(
          newBodies[i].showGravityWell,
          equals(originalSettings[i]),
          reason:
              'Body $i gravity well setting should be preserved after reset',
        );
      }
    });

    test(
      'resetWithScenario with preserveCustomSettings should preserve settings',
      () async {
        // Set up initial scenario
        simulationState.resetWithScenario(ScenarioType.threeBodyClassic);

        // Enable gravity wells for some bodies
        final bodies = simulationState.bodies;
        expect(bodies.length, greaterThan(0));

        // Set specific gravity well configurations
        if (bodies.isNotEmpty) {
          bodies[0].showGravityWell = true;
        }
        if (bodies.length > 1) {
          bodies[1].showGravityWell = false;
        }
        if (bodies.length > 2) {
          bodies[2].showGravityWell = true;
        }

        // Store the original settings
        final originalSettings = bodies
            .map((body) => body.showGravityWell)
            .toList();

        // Reset with the same scenario preserving custom settings
        simulationState.resetWithScenario(
          ScenarioType.threeBodyClassic,
          preserveCustomSettings: true,
        );

        // Check that gravity well settings are preserved
        final newBodies = simulationState.bodies;
        expect(newBodies.length, equals(bodies.length));

        for (
          int i = 0;
          i < newBodies.length && i < originalSettings.length;
          i++
        ) {
          expect(
            newBodies[i].showGravityWell,
            equals(originalSettings[i]),
            reason:
                'Body $i gravity well setting should be preserved with preserveCustomSettings=true',
          );
        }
      },
    );

    test(
      'resetWithScenario without preserveCustomSettings should not preserve settings',
      () async {
        // Set up initial scenario
        simulationState.resetWithScenario(ScenarioType.binaryStars);

        // Enable gravity wells for some bodies
        final bodies = simulationState.bodies;
        expect(bodies.length, greaterThan(0));

        // Set specific gravity well configurations
        if (bodies.isNotEmpty) {
          bodies[0].showGravityWell = true;
        }
        if (bodies.length > 1) {
          bodies[1].showGravityWell = true;
        }

        // Reset with the same scenario without preserving custom settings
        simulationState.resetWithScenario(
          ScenarioType.binaryStars,
          preserveCustomSettings: false,
        );

        // Check that gravity well settings are NOT preserved (reset to defaults)
        final newBodies = simulationState.bodies;
        for (final body in newBodies) {
          expect(
            body.showGravityWell,
            isFalse,
            reason:
                'Gravity well settings should be reset to default (false) when preserveCustomSettings=false',
          );
        }
      },
    );

    test(
      'changing scenario should reset gravity well settings by default',
      () async {
        // Set up initial scenario
        simulationState.resetWithScenario(ScenarioType.solarSystem);

        // Enable gravity wells for all bodies
        final bodies = simulationState.bodies;
        for (final body in bodies) {
          body.showGravityWell = true;
        }

        // Switch to different scenario
        simulationState.resetWithScenario(ScenarioType.threeBodyClassic);

        // Check that gravity well settings are reset to defaults for this scenario
        final newBodies = simulationState.bodies;
        for (final body in newBodies) {
          expect(
            body.showGravityWell,
            isFalse,
            reason:
                'Gravity well settings should be reset to default when changing scenarios',
          );
        }
      },
    );

    test(
      'some scenarios have default gravity wells enabled for educational purposes',
      () async {
        // Test solar system scenario - Sun should have gravity well enabled by default
        simulationState.resetWithScenario(ScenarioType.solarSystem);
        final solarBodies = simulationState.bodies;
        final sun = solarBodies
            .where((body) => body.name.contains('Sun'))
            .firstOrNull;

        if (sun != null) {
          expect(
            sun.showGravityWell,
            isTrue,
            reason:
                'Solar system Sun should have gravity well enabled by default',
          );
        }

        // Test earth-moon-sun scenario - Sun should have gravity well enabled by default
        simulationState.resetWithScenario(ScenarioType.earthMoonSun);
        final emsBodies = simulationState.bodies;
        final emsSun = emsBodies
            .where((body) => body.name.contains('Sun'))
            .firstOrNull;

        if (emsSun != null) {
          expect(
            emsSun.showGravityWell,
            isTrue,
            reason:
                'Earth-Moon-Sun Sun should have gravity well enabled by default',
          );
        }
      },
    );
  });
}
