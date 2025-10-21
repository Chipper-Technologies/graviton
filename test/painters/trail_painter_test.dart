import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/models/trail_point.dart';
import 'package:graviton/painters/trail_painter.dart';
import 'package:graviton/services/simulation.dart' as physics;
import 'package:vector_math/vector_math_64.dart' as vm;
import 'package:graviton/theme/app_colors.dart';

void main() {
  group('TrailPainter', () {
    late Canvas canvas;
    late ui.PictureRecorder recorder;
    late Size canvasSize;
    late vm.Matrix4 viewProjectionMatrix;
    late physics.Simulation simulation;

    setUp(() {
      recorder = ui.PictureRecorder();
      canvas = Canvas(recorder);
      canvasSize = const Size(800, 600);
      viewProjectionMatrix = vm.Matrix4.identity();
      simulation = physics.Simulation();

      // Add some test bodies and trails
      simulation.bodies.add(
        Body(
          position: vm.Vector3(0, 0, -10),
          velocity: vm.Vector3(1, 0, 0),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicRed,
          name: 'Test Body 1',
        ),
      );

      simulation.bodies.add(
        Body(
          position: vm.Vector3(5, 5, -15),
          velocity: vm.Vector3(-1, 1, 0),
          mass: 2.0,
          radius: 1.5,
          color: AppColors.basicBlue,
          name: 'Test Body 2',
        ),
      );

      // Add corresponding trails
      simulation.trails.add([
        TrailPoint(vm.Vector3(-2, 0, -10), 1.0),
        TrailPoint(vm.Vector3(-1, 0, -10), 0.8),
        TrailPoint(vm.Vector3(0, 0, -10), 0.6),
      ]);

      simulation.trails.add([
        TrailPoint(vm.Vector3(7, 3, -15), 1.0),
        TrailPoint(vm.Vector3(6, 4, -15), 0.8),
        TrailPoint(vm.Vector3(5, 5, -15), 0.6),
      ]);
    });

    group('drawTrails', () {
      test('should draw trails when showTrails is true', () {
        expect(
          () => TrailPainter.drawTrails(
            canvas,
            canvasSize,
            viewProjectionMatrix,
            simulation,
            true, // showTrails
            false, // useWarmTrails
          ),
          returnsNormally,
        );
      });

      test('should not draw trails when showTrails is false', () {
        expect(
          () => TrailPainter.drawTrails(
            canvas,
            canvasSize,
            viewProjectionMatrix,
            simulation,
            false, // showTrails
            false, // useWarmTrails
          ),
          returnsNormally,
        );
      });

      test('should handle warm trails setting', () {
        expect(
          () => TrailPainter.drawTrails(
            canvas,
            canvasSize,
            viewProjectionMatrix,
            simulation,
            true, // showTrails
            true, // useWarmTrails
          ),
          returnsNormally,
        );
      });

      test('should handle cold trails setting', () {
        expect(
          () => TrailPainter.drawTrails(
            canvas,
            canvasSize,
            viewProjectionMatrix,
            simulation,
            true, // showTrails
            false, // useWarmTrails
          ),
          returnsNormally,
        );
      });
    });

    group('Edge Cases', () {
      test('should handle empty simulation', () {
        final emptySimulation = physics.Simulation();

        expect(
          () => TrailPainter.drawTrails(
            canvas,
            canvasSize,
            viewProjectionMatrix,
            emptySimulation,
            true,
            false,
          ),
          returnsNormally,
        );
      });

      test('should handle simulation with bodies but no trails', () {
        final bodyOnlySimulation = physics.Simulation();
        bodyOnlySimulation.bodies.add(
          Body(
            position: vm.Vector3.zero(),
            velocity: vm.Vector3.zero(),
            mass: 1.0,
            radius: 1.0,
            color: AppColors.basicGreen,
            name: 'Lonely Body',
          ),
        );

        expect(
          () => TrailPainter.drawTrails(
            canvas,
            canvasSize,
            viewProjectionMatrix,
            bodyOnlySimulation,
            true,
            false,
          ),
          returnsNormally,
        );
      });

      test('should handle trails behind camera', () {
        final behindSimulation = physics.Simulation();
        behindSimulation.bodies.add(
          Body(
            position: vm.Vector3(0, 0, 10), // Positive Z (behind camera)
            velocity: vm.Vector3.zero(),
            mass: 1.0,
            radius: 1.0,
            color: AppColors.basicPurple,
            name: 'Behind Body',
          ),
        );

        behindSimulation.trails.add([
          TrailPoint(vm.Vector3(0, 0, 8), 1.0),
          TrailPoint(vm.Vector3(0, 0, 9), 0.8),
          TrailPoint(vm.Vector3(0, 0, 10), 0.6),
        ]);

        expect(
          () => TrailPainter.drawTrails(
            canvas,
            canvasSize,
            viewProjectionMatrix,
            behindSimulation,
            true,
            false,
          ),
          returnsNormally,
        );
      });

      test('should handle very long trails', () {
        final longTrailSimulation = physics.Simulation();
        longTrailSimulation.bodies.add(
          Body(
            position: vm.Vector3.zero(),
            velocity: vm.Vector3.zero(),
            mass: 1.0,
            radius: 1.0,
            color: AppColors.basicOrange,
            name: 'Long Trail Body',
          ),
        );

        // Create a very long trail
        final longTrail = <TrailPoint>[];
        for (int i = 0; i < 1000; i++) {
          longTrail.add(
            TrailPoint(vm.Vector3(i.toDouble(), 0, -10), 1.0 - (i / 1000.0)),
          );
        }
        longTrailSimulation.trails.add(longTrail);

        expect(
          () => TrailPainter.drawTrails(
            canvas,
            canvasSize,
            viewProjectionMatrix,
            longTrailSimulation,
            true,
            false,
          ),
          returnsNormally,
        );
      });

      test('should handle zero-size canvas', () {
        expect(
          () => TrailPainter.drawTrails(
            canvas,
            Size.zero,
            viewProjectionMatrix,
            simulation,
            true,
            false,
          ),
          returnsNormally,
        );
      });

      test('should handle extreme view transformations', () {
        final extremeView = vm.Matrix4.identity()
          ..translateByVector3(vm.Vector3(1000, 1000, 1000))
          ..rotateX(3.14159)
          ..scaleByVector3(vm.Vector3(0.001, 0.001, 0.001));

        expect(
          () => TrailPainter.drawTrails(
            canvas,
            canvasSize,
            extremeView,
            simulation,
            true,
            false,
          ),
          returnsNormally,
        );
      });
    });

    tearDown(() {
      recorder.endRecording();
    });
  });
}
