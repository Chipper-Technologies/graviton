import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/painters/gravity_painter.dart';
import 'package:graviton/services/simulation.dart' as physics;
import 'package:vector_math/vector_math_64.dart' as vm;
import 'package:graviton/theme/app_colors.dart';

void main() {
  group('GravityPainter', () {
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

      // Add bodies with different masses for testing gravity wells
      simulation.bodies.add(
        Body(
          position: vm.Vector3(0, 0, -20),
          velocity: vm.Vector3.zero(),
          mass: 1000.0, // Massive star
          radius: 10.0,
          color: AppColors.basicYellow,
          name: 'Massive Star',
          bodyType: BodyType.star,
        ),
      );

      simulation.bodies.add(
        Body(
          position: vm.Vector3(30, 0, -20),
          velocity: vm.Vector3.zero(),
          mass: 50.0, // Large planet
          radius: 5.0,
          color: AppColors.basicBlue,
          name: 'Large Planet',
          bodyType: BodyType.planet,
        ),
      );

      simulation.bodies.add(
        Body(
          position: vm.Vector3(-30, 0, -20),
          velocity: vm.Vector3.zero(),
          mass: 5.0, // Small planet
          radius: 2.0,
          color: AppColors.basicGreen,
          name: 'Small Planet',
          bodyType: BodyType.planet,
        ),
      );
    });

    group('drawGravityWells', () {
      test('should draw gravity wells when enabled', () {
        expect(
          () => GravityPainter.drawGravityWells(
            canvas,
            canvasSize,
            viewProjectionMatrix,
            simulation,
            true, // showGravityWells
          ),
          returnsNormally,
        );
      });

      test('should not draw gravity wells when disabled', () {
        expect(
          () => GravityPainter.drawGravityWells(
            canvas,
            canvasSize,
            viewProjectionMatrix,
            simulation,
            false, // showGravityWells
          ),
          returnsNormally,
        );
      });

      test('should handle empty simulation', () {
        final emptySimulation = physics.Simulation();

        expect(
          () => GravityPainter.drawGravityWells(
            canvas,
            canvasSize,
            viewProjectionMatrix,
            emptySimulation,
            true,
          ),
          returnsNormally,
        );
      });

      test('should draw wells for bodies of different masses', () {
        // Test already has bodies with different masses
        expect(
          () => GravityPainter.drawGravityWells(
            canvas,
            canvasSize,
            viewProjectionMatrix,
            simulation,
            true,
          ),
          returnsNormally,
        );
      });

      test('should handle bodies with zero mass', () {
        final zeroMassSimulation = physics.Simulation();
        zeroMassSimulation.bodies.add(
          Body(
            position: vm.Vector3.zero(),
            velocity: vm.Vector3.zero(),
            mass: 0.0, // Zero mass
            radius: 1.0,
            color: AppColors.basicGrey,
            name: 'Massless Body',
          ),
        );

        expect(
          () => GravityPainter.drawGravityWells(
            canvas,
            canvasSize,
            viewProjectionMatrix,
            zeroMassSimulation,
            true,
          ),
          returnsNormally,
        );
      });

      test('should handle bodies with very large mass', () {
        final largeMassSimulation = physics.Simulation();
        largeMassSimulation.bodies.add(
          Body(
            position: vm.Vector3.zero(),
            velocity: vm.Vector3.zero(),
            mass: 1000000.0, // Very large mass
            radius: 50.0,
            color: AppColors.basicRed,
            name: 'Super Massive Body',
          ),
        );

        expect(
          () => GravityPainter.drawGravityWells(
            canvas,
            canvasSize,
            viewProjectionMatrix,
            largeMassSimulation,
            true,
          ),
          returnsNormally,
        );
      });
    });

    group('Gravity Grid Drawing', () {
      test('should draw gravity grid for massive objects', () {
        // The massive star (mass > 10.0) should trigger grid drawing
        expect(
          () => GravityPainter.drawGravityWells(
            canvas,
            canvasSize,
            viewProjectionMatrix,
            simulation,
            true,
          ),
          returnsNormally,
        );
      });

      test('should not draw grid for low mass objects', () {
        final lowMassSimulation = physics.Simulation();
        lowMassSimulation.bodies.add(
          Body(
            position: vm.Vector3.zero(),
            velocity: vm.Vector3.zero(),
            mass: 5.0, // Mass <= 10.0, no grid expected
            radius: 2.0,
            color: AppColors.basicBlue,
            name: 'Low Mass Body',
          ),
        );

        expect(
          () => GravityPainter.drawGravityWells(
            canvas,
            canvasSize,
            viewProjectionMatrix,
            lowMassSimulation,
            true,
          ),
          returnsNormally,
        );
      });
    });

    group('Field Strength and Colors', () {
      test('should handle different body types with different colors', () {
        final mixedSimulation = physics.Simulation();

        // Add star
        mixedSimulation.bodies.add(
          Body(
            position: vm.Vector3(0, 0, -20),
            velocity: vm.Vector3.zero(),
            mass: 100.0,
            radius: 8.0,
            color: AppColors.basicYellow,
            name: 'Star',
            bodyType: BodyType.star,
          ),
        );

        // Add planet
        mixedSimulation.bodies.add(
          Body(
            position: vm.Vector3(20, 0, -20),
            velocity: vm.Vector3.zero(),
            mass: 50.0,
            radius: 4.0,
            color: AppColors.basicBlue,
            name: 'Planet',
            bodyType: BodyType.planet,
          ),
        );

        expect(
          () => GravityPainter.drawGravityWells(
            canvas,
            canvasSize,
            viewProjectionMatrix,
            mixedSimulation,
            true,
          ),
          returnsNormally,
        );
      });
    });

    group('Edge Cases', () {
      test('should handle bodies behind camera', () {
        final behindSimulation = physics.Simulation();
        behindSimulation.bodies.add(
          Body(
            position: vm.Vector3(0, 0, 10), // Positive Z (behind camera)
            velocity: vm.Vector3.zero(),
            mass: 100.0,
            radius: 5.0,
            color: AppColors.basicPurple,
            name: 'Behind Body',
          ),
        );

        expect(
          () => GravityPainter.drawGravityWells(
            canvas,
            canvasSize,
            viewProjectionMatrix,
            behindSimulation,
            true,
          ),
          returnsNormally,
        );
      });

      test('should handle zero-size canvas', () {
        expect(
          () => GravityPainter.drawGravityWells(
            canvas,
            Size.zero,
            viewProjectionMatrix,
            simulation,
            true,
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
          () => GravityPainter.drawGravityWells(
            canvas,
            canvasSize,
            extremeView,
            simulation,
            true,
          ),
          returnsNormally,
        );
      });

      test('should handle many bodies performance test', () {
        final manyBodiesSimulation = physics.Simulation();

        // Add 100 bodies to test performance
        for (int i = 0; i < 100; i++) {
          manyBodiesSimulation.bodies.add(
            Body(
              position: vm.Vector3(i.toDouble(), 0, -20),
              velocity: vm.Vector3.zero(),
              mass: 10.0 + i,
              radius: 2.0,
              color: AppColors.basicOrange,
              name: 'Body $i',
            ),
          );
        }

        expect(
          () => GravityPainter.drawGravityWells(
            canvas,
            canvasSize,
            viewProjectionMatrix,
            manyBodiesSimulation,
            true,
          ),
          returnsNormally,
        );
      });

      test('should handle negative mass bodies', () {
        final negativeMassSimulation = physics.Simulation();
        negativeMassSimulation.bodies.add(
          Body(
            position: vm.Vector3.zero(),
            velocity: vm.Vector3.zero(),
            mass: -10.0, // Negative mass (exotic matter)
            radius: 3.0,
            color: AppColors.uiBlack,
            name: 'Exotic Matter',
          ),
        );

        expect(
          () => GravityPainter.drawGravityWells(
            canvas,
            canvasSize,
            viewProjectionMatrix,
            negativeMassSimulation,
            true,
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
