import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/enums/habitability_status.dart';
import 'package:graviton/painters/habitability_painter.dart';
import 'package:graviton/services/simulation.dart' as physics;
import 'package:vector_math/vector_math_64.dart' as vm;
import 'package:graviton/theme/app_colors.dart';

void main() {
  group('HabitabilityPainter', () {
    late Canvas canvas;
    late ui.PictureRecorder recorder;
    late Size canvasSize;
    late vm.Matrix4 viewProjectionMatrix;
    late vm.Matrix4 viewMatrix;
    late physics.Simulation simulation;
    late Offset center;
    late double bodyRadius;

    setUp(() {
      recorder = ui.PictureRecorder();
      canvas = Canvas(recorder);
      canvasSize = const Size(800, 600);
      viewProjectionMatrix = vm.Matrix4.identity();
      viewMatrix = vm.Matrix4.identity();
      simulation = physics.Simulation();
      center = const Offset(400, 300);
      bodyRadius = 20.0;

      // Add a star for habitable zones
      simulation.bodies.add(
        Body(
          position: vm.Vector3(0, 0, -50),
          velocity: vm.Vector3.zero(),
          mass: 1000.0,
          radius: 20.0,
          color: AppColors.basicYellow,
          name: 'Test Star',
          bodyType: BodyType.star,
        ),
      );
    });

    group('drawHabitableZones', () {
      test('should draw habitable zones when enabled', () {
        expect(
          () => HabitabilityPainter.drawHabitableZones(
            canvas,
            canvasSize,
            viewProjectionMatrix,
            viewMatrix,
            simulation,
            true, // showHabitableZones
          ),
          returnsNormally,
        );
      });

      test('should not draw habitable zones when disabled', () {
        expect(
          () => HabitabilityPainter.drawHabitableZones(
            canvas,
            canvasSize,
            viewProjectionMatrix,
            viewMatrix,
            simulation,
            false, // showHabitableZones
          ),
          returnsNormally,
        );
      });

      test('should handle empty simulation', () {
        final emptySimulation = physics.Simulation();

        expect(
          () => HabitabilityPainter.drawHabitableZones(
            canvas,
            canvasSize,
            viewProjectionMatrix,
            viewMatrix,
            emptySimulation,
            true,
          ),
          returnsNormally,
        );
      });

      test('should handle simulation with no stars', () {
        final noStarsSimulation = physics.Simulation();
        noStarsSimulation.bodies.add(
          Body(
            position: vm.Vector3.zero(),
            velocity: vm.Vector3.zero(),
            mass: 1.0,
            radius: 1.0,
            color: AppColors.basicBlue,
            name: 'Planet',
            bodyType: BodyType.planet,
          ),
        );

        expect(
          () => HabitabilityPainter.drawHabitableZones(
            canvas,
            canvasSize,
            viewProjectionMatrix,
            viewMatrix,
            noStarsSimulation,
            true,
          ),
          returnsNormally,
        );
      });
    });

    group('drawHabitabilityIndicator', () {
      test('should draw indicator for habitable planet when enabled', () {
        final habitablePlanet = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicGreen,
          name: 'Habitable Planet',
          bodyType: BodyType.planet,
          habitabilityStatus: HabitabilityStatus.habitable,
        );

        expect(
          () => HabitabilityPainter.drawHabitabilityIndicator(
            canvas,
            center,
            bodyRadius,
            habitablePlanet,
            true, // showHabitabilityIndicators
          ),
          returnsNormally,
        );
      });

      test('should draw indicator for too hot planet', () {
        final tooHotPlanet = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicRed,
          name: 'Too Hot Planet',
          bodyType: BodyType.planet,
          habitabilityStatus: HabitabilityStatus.tooHot,
        );

        expect(
          () => HabitabilityPainter.drawHabitabilityIndicator(
            canvas,
            center,
            bodyRadius,
            tooHotPlanet,
            true,
          ),
          returnsNormally,
        );
      });

      test('should draw indicator for too cold planet', () {
        final tooColdPlanet = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Too Cold Planet',
          bodyType: BodyType.planet,
          habitabilityStatus: HabitabilityStatus.tooCold,
        );

        expect(
          () => HabitabilityPainter.drawHabitabilityIndicator(
            canvas,
            center,
            bodyRadius,
            tooColdPlanet,
            true,
          ),
          returnsNormally,
        );
      });

      test('should not draw indicator when disabled', () {
        final habitablePlanet = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicGreen,
          name: 'Habitable Planet',
          bodyType: BodyType.planet,
          habitabilityStatus: HabitabilityStatus.habitable,
        );

        expect(
          () => HabitabilityPainter.drawHabitabilityIndicator(
            canvas,
            center,
            bodyRadius,
            habitablePlanet,
            false, // showHabitabilityIndicators
          ),
          returnsNormally,
        );
      });

      test('should not draw indicator for non-planet bodies', () {
        final star = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1000.0,
          radius: 20.0,
          color: AppColors.basicYellow,
          name: 'Star',
          bodyType: BodyType.star,
          habitabilityStatus: HabitabilityStatus.habitable,
        );

        expect(
          () => HabitabilityPainter.drawHabitabilityIndicator(
            canvas,
            center,
            bodyRadius,
            star,
            true,
          ),
          returnsNormally,
        );
      });
    });

    group('Edge Cases', () {
      test('should handle zero-size canvas for zones', () {
        expect(
          () => HabitabilityPainter.drawHabitableZones(
            canvas,
            Size.zero,
            viewProjectionMatrix,
            viewMatrix,
            simulation,
            true,
          ),
          returnsNormally,
        );
      });

      test('should handle zero body radius for indicator', () {
        final planet = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicGreen,
          name: 'Test Planet',
          bodyType: BodyType.planet,
          habitabilityStatus: HabitabilityStatus.habitable,
        );

        expect(
          () => HabitabilityPainter.drawHabitabilityIndicator(
            canvas,
            center,
            0.0, // zero radius
            planet,
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
          () => HabitabilityPainter.drawHabitableZones(
            canvas,
            canvasSize,
            viewProjectionMatrix,
            extremeView,
            simulation,
            true,
          ),
          returnsNormally,
        );
      });

      test('should handle negative center coordinates for indicator', () {
        final planet = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicGreen,
          name: 'Test Planet',
          bodyType: BodyType.planet,
          habitabilityStatus: HabitabilityStatus.habitable,
        );

        expect(
          () => HabitabilityPainter.drawHabitabilityIndicator(
            canvas,
            const Offset(-100, -100),
            bodyRadius,
            planet,
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
