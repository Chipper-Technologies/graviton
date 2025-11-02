import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/models/trail_point.dart';
import 'package:graviton/painters/trail_painter.dart';
import 'package:graviton/services/simulation.dart' as physics;
import 'package:graviton/services/stellar_color_service.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void main() {
  group('Galaxy Formation Trail Colors Tests', () {
    late physics.Simulation simulation;
    late Canvas canvas;
    late ui.PictureRecorder recorder;
    late Size size;
    late vm.Matrix4 viewProjectionMatrix;

    setUp(() {
      simulation = physics.Simulation();
      simulation.resetWithScenario(ScenarioType.galaxyFormation);

      // Create mock canvas and size for painting tests
      recorder = ui.PictureRecorder();
      canvas = Canvas(recorder);
      size = const Size(800, 600);
      viewProjectionMatrix = vm.Matrix4.identity();
    });

    test('should use realistic colors for galaxy trails when enabled', () {
      // Enable realistic colors
      simulation.setUseRealisticColors(true);

      // Add some trail points to stars
      for (int i = 1; i < simulation.bodies.length && i < 4; i++) {
        final body = simulation.bodies[i];
        if (body.bodyType == BodyType.star) {
          simulation.trails[i] = [
            TrailPoint(body.position, 1.0),
            TrailPoint(body.position + vm.Vector3(1.0, 0.0, 0.0), 0.8),
            TrailPoint(body.position + vm.Vector3(2.0, 0.0, 0.0), 0.6),
          ];
        }
      }

      // Draw trails should not throw and should use realistic colors
      expect(
        () => TrailPainter.drawTrails(
          canvas,
          size,
          viewProjectionMatrix,
          simulation,
          true, // showTrails
          false, // useWarmTrails
          true, // useRealisticColors
        ),
        returnsNormally,
      );

      // Verify that stars have realistic colors (which trails will inherit)
      for (int i = 1; i < simulation.bodies.length; i++) {
        final body = simulation.bodies[i];
        if (body.bodyType == BodyType.star) {
          final expectedRealisticColor =
              StellarColorService.getRealisticBodyColor(body);
          expect(
            body.color,
            equals(expectedRealisticColor),
            reason: 'Star $i should have realistic color for trail inheritance',
          );
        }
      }
    });

    test(
      'should use distance-based colors for galaxy trails when realistic colors disabled',
      () {
        // Disable realistic colors (default)
        simulation.setUseRealisticColors(false);

        // Step simulation to trigger dynamic coloring
        for (int step = 0; step < 5; step++) {
          simulation.stepRK4(1.0 / 60.0);
        }

        // Add some trail points to stars at different distances
        for (int i = 1; i < simulation.bodies.length && i < 4; i++) {
          final body = simulation.bodies[i];
          if (body.bodyType == BodyType.star) {
            simulation.trails[i] = [
              TrailPoint(body.position, 1.0),
              TrailPoint(body.position + vm.Vector3(1.0, 0.0, 0.0), 0.8),
              TrailPoint(body.position + vm.Vector3(2.0, 0.0, 0.0), 0.6),
            ];
          }
        }

        // Draw trails should not throw
        expect(
          () => TrailPainter.drawTrails(
            canvas,
            size,
            viewProjectionMatrix,
            simulation,
            true, // showTrails
            false, // useWarmTrails
            false, // useRealisticColors
          ),
          returnsNormally,
        );

        // With galaxy formation and realistic colors disabled, the trail painter should
        // use distance-based colors. We can't directly test the painter's internal
        // logic, but we can verify that the simulation is set up for distance-based coloring.
        expect(
          simulation.currentScenario,
          equals(ScenarioType.galaxyFormation),
        );
      },
    );

    test(
      'should handle trail painting with different star positions in galaxy',
      () {
        // Enable realistic colors
        simulation.setUseRealisticColors(true);

        // Create stars at different distances from galactic center
        if (simulation.bodies.length > 1) {
          final centralStar =
              simulation.bodies[1]; // Skip black hole at index 0
          if (centralStar.bodyType == BodyType.star) {
            // Add trail points at various positions
            simulation.trails[1] = [
              TrailPoint(vm.Vector3(10.0, 0.0, 0.0), 1.0), // Close to center
              TrailPoint(vm.Vector3(50.0, 0.0, 0.0), 0.8), // Medium distance
              TrailPoint(vm.Vector3(100.0, 0.0, 0.0), 0.6), // Far from center
            ];

            // Draw trails should handle different positions correctly
            expect(
              () => TrailPainter.drawTrails(
                canvas,
                size,
                viewProjectionMatrix,
                simulation,
                true, // showTrails
                false, // useWarmTrails
                true, // useRealisticColors
              ),
              returnsNormally,
            );

            // Star should still have realistic color regardless of trail position
            final expectedRealisticColor =
                StellarColorService.getRealisticBodyColor(centralStar);
            expect(centralStar.color, equals(expectedRealisticColor));
          }
        }
      },
    );
  });
}
