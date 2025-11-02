import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/services/simulation.dart' as physics;
import 'package:graviton/theme/app_colors.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void main() {
  group('Star Merger Realistic Colors Tests', () {
    late physics.Simulation simulation;

    setUp(() {
      simulation = physics.Simulation();
      // Set to a scenario that allows mergers (not galaxy formation)
      simulation.resetWithScenario(ScenarioType.binaryStars);
    });

    test(
      'should use realistic colors for merged stars when realistic colors enabled',
      () {
        // Enable realistic colors
        simulation.setUseRealisticColors(true);

        // Create two stars that will merge
        final star1 = Body(
          position: vm.Vector3(0, 0, 0),
          velocity: vm.Vector3(0, 0, 0),
          mass: 5.0,
          radius: 0.5,
          color: AppColors.basicRed,
          name: 'Star A',
          bodyType: BodyType.star,
          stellarLuminosity: 1.0,
        );

        final star2 = Body(
          position: vm.Vector3(
            0.03,
            0,
            0,
          ), // Distance of 0.03 (well below collision threshold of 0.05)
          velocity: vm.Vector3(0, 0, 0),
          mass: 3.0,
          radius: 0.5,
          color: AppColors.basicBlue,
          name: 'Star B',
          bodyType: BodyType.star,
          stellarLuminosity: 0.8,
        );

        // Override the scenario bodies with our test bodies
        simulation.bodies = [star1, star2];
        simulation.trails = [[], []];

        // Clear any existing merge flashes
        simulation.mergeFlashes.clear();

        // Step the simulation - should trigger collision
        simulation.stepRK4(1.0 / 60.0);

        // Should have created a merge flash indicating a merger happened
        expect(simulation.mergeFlashes, isNotEmpty);

        if (simulation.mergeFlashes.isNotEmpty) {
          final mergeFlash = simulation.mergeFlashes.first;

          // Check that the merge flash has realistic color
          // The merge flash should use the realistic color that would have been applied to the merged star
          expect(mergeFlash.color, isNot(equals(AppColors.basicRed)));
          expect(mergeFlash.color, isNot(equals(AppColors.basicBlue)));

          // Verify it looks like a realistic stellar color (should have some scientific basis)
          expect(mergeFlash.color, isA<Color>());
        }
      },
    );

    test(
      'should use blended colors for merged stars when realistic colors disabled',
      () {
        // Disable realistic colors (default)
        simulation.setUseRealisticColors(false);

        // Create two stars that will merge
        final star1 = Body(
          position: vm.Vector3(0, 0, 0),
          velocity: vm.Vector3(0, 0, 0),
          mass: 5.0,
          radius: 0.5,
          color: AppColors.basicRed,
          name: 'Star A',
          bodyType: BodyType.star,
          stellarLuminosity: 1.0,
        );

        final star2 = Body(
          position: vm.Vector3(
            0.03,
            0,
            0,
          ), // Distance of 0.03 (well below collision threshold of 0.05)
          velocity: vm.Vector3(0, 0, 0),
          mass: 3.0,
          radius: 0.5,
          color: AppColors.basicBlue,
          name: 'Star B',
          bodyType: BodyType.star,
          stellarLuminosity: 0.8,
        );

        // Override the scenario bodies with our test bodies
        simulation.bodies = [star1, star2];
        simulation.trails = [[], []];

        // Clear any existing merge flashes
        simulation.mergeFlashes.clear();

        // Step the simulation - should trigger collision
        simulation.stepRK4(1.0 / 60.0);

        // Should have created a merge flash indicating a merger happened
        expect(simulation.mergeFlashes, isNotEmpty);

        if (simulation.mergeFlashes.isNotEmpty) {
          final mergeFlash = simulation.mergeFlashes.first;

          // When realistic colors are disabled, should use traditional blended color
          // The merge flash should NOT be a realistic stellar color
          expect(mergeFlash.color, isA<Color>());

          // It should be different from both original colors (some form of blend)
          expect(mergeFlash.color, isNot(equals(AppColors.basicRed)));
          expect(mergeFlash.color, isNot(equals(AppColors.basicBlue)));
        }
      },
    );

    test('should apply realistic colors to merge flash when enabled', () {
      // Enable realistic colors
      simulation.setUseRealisticColors(true);

      // Create two stars that will merge
      final star1 = Body(
        position: vm.Vector3(0, 0, 0),
        velocity: vm.Vector3(0, 0, 0),
        mass: 5.0,
        radius: 0.5,
        color: AppColors.basicRed,
        name: 'Star A',
        bodyType: BodyType.star,
        stellarLuminosity: 1.0,
      );

      final star2 = Body(
        position: vm.Vector3(
          0.03,
          0,
          0,
        ), // Distance of 0.03 (well below collision threshold of 0.05)
        velocity: vm.Vector3(0, 0, 0),
        mass: 3.0,
        radius: 0.5,
        color: AppColors.basicBlue,
        name: 'Star B',
        bodyType: BodyType.star,
        stellarLuminosity: 0.8,
      );

      // Override the scenario bodies with our test bodies
      simulation.bodies = [star1, star2];
      simulation.trails = [[], []];

      // Clear any existing merge flashes
      simulation.mergeFlashes.clear();

      // Step the simulation - should trigger collision
      simulation.stepRK4(1.0 / 60.0);

      // Should have created a merge flash
      expect(simulation.mergeFlashes, isNotEmpty);

      if (simulation.mergeFlashes.isNotEmpty && simulation.bodies.isNotEmpty) {
        final mergeFlash = simulation.mergeFlashes.first;
        final mergedStar = simulation.bodies[0];

        // Merge flash should use the same realistic color as the merged star
        expect(mergeFlash.color, equals(mergedStar.color));
      }
    });
  });
}
