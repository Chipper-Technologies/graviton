import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/painters/orbital_path_painter.dart';
import 'package:graviton/services/simulation.dart' as physics;
import 'package:vector_math/vector_math_64.dart' as vm;

void main() {
  group('OrbitalPathPainter Tests', () {
    late Canvas canvas;
    late PictureRecorder recorder;
    late physics.Simulation simulation;

    setUp(() {
      recorder = PictureRecorder();
      canvas = Canvas(recorder);
      simulation = physics.Simulation();
    });

    tearDown(() {
      recorder.endRecording();
    });

    group('Basic Drawing', () {
      testWidgets('should draw orbital paths when enabled', (tester) async {
        const size = Size(800, 600);
        final vp = vm.Matrix4.identity();

        // This should not throw
        expect(() {
          OrbitalPathPainter.drawOrbitalPaths(
            canvas,
            size,
            vp,
            simulation,
            true, // showOrbitalPaths enabled
          );
        }, returnsNormally);
      });

      testWidgets('should not draw orbital paths when disabled', (
        tester,
      ) async {
        const size = Size(800, 600);
        final vp = vm.Matrix4.identity();

        // This should not throw and should handle disabled state
        expect(() {
          OrbitalPathPainter.drawOrbitalPaths(
            canvas,
            size,
            vp,
            simulation,
            false, // showOrbitalPaths disabled
          );
        }, returnsNormally);
      });

      testWidgets('should handle dual mode', (tester) async {
        const size = Size(800, 600);
        final vp = vm.Matrix4.identity();

        expect(() {
          OrbitalPathPainter.drawOrbitalPaths(
            canvas,
            size,
            vp,
            simulation,
            true,
            dualMode: true, // Enable dual mode
          );
        }, returnsNormally);
      });
    });

    group('Different Scenarios', () {
      testWidgets('should handle solar system scenario', (tester) async {
        const size = Size(800, 600);
        final vp = vm.Matrix4.identity();

        // Create simulation with solar system
        simulation.resetWithScenario(ScenarioType.solarSystem);

        expect(() {
          OrbitalPathPainter.drawOrbitalPaths(
            canvas,
            size,
            vp,
            simulation,
            true,
          );
        }, returnsNormally);
      });

      testWidgets('should handle earth-moon-sun scenario', (tester) async {
        const size = Size(800, 600);
        final vp = vm.Matrix4.identity();

        simulation.resetWithScenario(ScenarioType.earthMoonSun);

        expect(() {
          OrbitalPathPainter.drawOrbitalPaths(
            canvas,
            size,
            vp,
            simulation,
            true,
          );
        }, returnsNormally);
      });

      testWidgets('should handle binary stars scenario', (tester) async {
        const size = Size(800, 600);
        final vp = vm.Matrix4.identity();

        simulation.resetWithScenario(ScenarioType.binaryStars);

        expect(() {
          OrbitalPathPainter.drawOrbitalPaths(
            canvas,
            size,
            vp,
            simulation,
            true,
          );
        }, returnsNormally);
      });

      testWidgets('should handle asteroid belt scenario', (tester) async {
        const size = Size(800, 600);
        final vp = vm.Matrix4.identity();

        simulation.resetWithScenario(ScenarioType.asteroidBelt);

        expect(() {
          OrbitalPathPainter.drawOrbitalPaths(
            canvas,
            size,
            vp,
            simulation,
            true,
          );
        }, returnsNormally);
      });

      testWidgets('should handle galaxy formation scenario', (tester) async {
        const size = Size(800, 600);
        final vp = vm.Matrix4.identity();

        simulation.resetWithScenario(ScenarioType.galaxyFormation);

        expect(() {
          OrbitalPathPainter.drawOrbitalPaths(
            canvas,
            size,
            vp,
            simulation,
            true,
          );
        }, returnsNormally);
      });

      testWidgets('should handle random scenario', (tester) async {
        const size = Size(800, 600);
        final vp = vm.Matrix4.identity();

        simulation.resetWithScenario(ScenarioType.random);

        expect(() {
          OrbitalPathPainter.drawOrbitalPaths(
            canvas,
            size,
            vp,
            simulation,
            true,
          );
        }, returnsNormally);
      });
    });

    group('Different Canvas Sizes', () {
      testWidgets('should handle various canvas sizes', (tester) async {
        final vp = vm.Matrix4.identity();
        simulation.resetWithScenario(ScenarioType.solarSystem);

        final sizes = [
          const Size(100, 100),
          const Size(400, 300),
          const Size(800, 600),
          const Size(1920, 1080),
          const Size(1, 1),
          const Size(0, 0),
        ];

        for (final size in sizes) {
          expect(() {
            OrbitalPathPainter.drawOrbitalPaths(
              canvas,
              size,
              vp,
              simulation,
              true,
            );
          }, returnsNormally);
        }
      });
    });

    group('Different View Matrices', () {
      testWidgets('should handle different transformations', (tester) async {
        const size = Size(800, 600);
        simulation.resetWithScenario(ScenarioType.solarSystem);

        // Identity matrix
        final identity = vm.Matrix4.identity();
        expect(() {
          OrbitalPathPainter.drawOrbitalPaths(
            canvas,
            size,
            identity,
            simulation,
            true,
          );
        }, returnsNormally);

        // Scaled matrix
        final scaled = vm.Matrix4.identity()..scale(2.0);
        expect(() {
          OrbitalPathPainter.drawOrbitalPaths(
            canvas,
            size,
            scaled,
            simulation,
            true,
          );
        }, returnsNormally);

        // Translated matrix
        final translated = vm.Matrix4.identity()..translate(100.0, 100.0, 0.0);
        expect(() {
          OrbitalPathPainter.drawOrbitalPaths(
            canvas,
            size,
            translated,
            simulation,
            true,
          );
        }, returnsNormally);

        // Rotated matrix
        final rotated = vm.Matrix4.identity()..rotateZ(math.pi / 4);
        expect(() {
          OrbitalPathPainter.drawOrbitalPaths(
            canvas,
            size,
            rotated,
            simulation,
            true,
          );
        }, returnsNormally);
      });
    });

    group('Dual Mode Tests', () {
      testWidgets('should handle dual mode with solar system', (tester) async {
        const size = Size(800, 600);
        final vp = vm.Matrix4.identity();
        simulation.resetWithScenario(ScenarioType.solarSystem);

        expect(() {
          OrbitalPathPainter.drawOrbitalPaths(
            canvas,
            size,
            vp,
            simulation,
            true,
            dualMode: true,
          );
        }, returnsNormally);
      });

      testWidgets('should handle dual mode with earth-moon-sun', (
        tester,
      ) async {
        const size = Size(800, 600);
        final vp = vm.Matrix4.identity();
        simulation.resetWithScenario(ScenarioType.earthMoonSun);

        expect(() {
          OrbitalPathPainter.drawOrbitalPaths(
            canvas,
            size,
            vp,
            simulation,
            true,
            dualMode: true,
          );
        }, returnsNormally);
      });

      testWidgets('should handle dual mode disabled', (tester) async {
        const size = Size(800, 600);
        final vp = vm.Matrix4.identity();
        simulation.resetWithScenario(ScenarioType.solarSystem);

        expect(() {
          OrbitalPathPainter.drawOrbitalPaths(
            canvas,
            size,
            vp,
            simulation,
            true,
            dualMode: false,
          );
        }, returnsNormally);
      });
    });

    group('Empty and Edge Cases', () {
      testWidgets('should handle empty simulation', (tester) async {
        const size = Size(800, 600);
        final vp = vm.Matrix4.identity();
        final emptySimulation = physics.Simulation();

        expect(() {
          OrbitalPathPainter.drawOrbitalPaths(
            canvas,
            size,
            vp,
            emptySimulation,
            true,
          );
        }, returnsNormally);
      });

      testWidgets('should handle simulation with one body', (tester) async {
        const size = Size(800, 600);
        final vp = vm.Matrix4.identity();

        // Create simulation with single body
        simulation.resetWithScenario(ScenarioType.random);

        expect(() {
          OrbitalPathPainter.drawOrbitalPaths(
            canvas,
            size,
            vp,
            simulation,
            true,
          );
        }, returnsNormally);
      });

      testWidgets('should handle extreme view matrices', (tester) async {
        const size = Size(800, 600);
        simulation.resetWithScenario(ScenarioType.solarSystem);

        // Very large scale
        final largeScale = vm.Matrix4.identity()..scale(1000.0);
        expect(() {
          OrbitalPathPainter.drawOrbitalPaths(
            canvas,
            size,
            largeScale,
            simulation,
            true,
          );
        }, returnsNormally);

        // Very small scale
        final smallScale = vm.Matrix4.identity()..scale(0.001);
        expect(() {
          OrbitalPathPainter.drawOrbitalPaths(
            canvas,
            size,
            smallScale,
            simulation,
            true,
          );
        }, returnsNormally);

        // Zero scale (edge case)
        final zeroScale = vm.Matrix4.identity()..scale(0.0);
        expect(() {
          OrbitalPathPainter.drawOrbitalPaths(
            canvas,
            size,
            zeroScale,
            simulation,
            true,
          );
        }, returnsNormally);
      });
    });

    group('Performance Tests', () {
      testWidgets('should handle complex scenarios efficiently', (
        tester,
      ) async {
        const size = Size(800, 600);
        final vp = vm.Matrix4.identity();

        final complexScenarios = [
          ScenarioType.galaxyFormation,
          ScenarioType.solarSystem,
          ScenarioType.binaryStars,
        ];

        for (final scenario in complexScenarios) {
          simulation.resetWithScenario(scenario);

          expect(() {
            OrbitalPathPainter.drawOrbitalPaths(
              canvas,
              size,
              vp,
              simulation,
              true,
              dualMode: true, // More complex rendering
            );
          }, returnsNormally);
        }
      });

      testWidgets('should handle multiple rapid draws', (tester) async {
        const size = Size(800, 600);
        final vp = vm.Matrix4.identity();
        simulation.resetWithScenario(ScenarioType.solarSystem);

        // Simulate multiple frame renders
        for (int i = 0; i < 10; i++) {
          expect(() {
            OrbitalPathPainter.drawOrbitalPaths(
              canvas,
              size,
              vp,
              simulation,
              true,
            );
          }, returnsNormally);
        }
      });
    });

    group('OrbitalPathPoint Tests', () {
      test('should create invalid point', () {
        const point = OrbitalPathPoint.invalid;
        expect(point.isVisible, isFalse);
        expect(point.position, equals(Offset.zero));
      });

      test('should create visible point', () {
        const position = Offset(100, 200);
        final point = OrbitalPathPoint.visible(position);
        expect(point.isVisible, isTrue);
        expect(point.position, equals(position));
      });

      test('should create custom point', () {
        const position = Offset(50, 75);
        const point = OrbitalPathPoint(position: position, isVisible: true);
        expect(point.isVisible, isTrue);
        expect(point.position, equals(position));
      });

      test('should handle different positions', () {
        final positions = [
          Offset.zero,
          const Offset(100, 100),
          const Offset(-50, 200),
          const Offset(1000, -500),
        ];

        for (final pos in positions) {
          final point = OrbitalPathPoint.visible(pos);
          expect(point.position, equals(pos));
          expect(point.isVisible, isTrue);
        }
      });
    });

    group('Stress Tests', () {
      testWidgets('should handle rapid scenario changes', (tester) async {
        const size = Size(800, 600);
        final vp = vm.Matrix4.identity();

        final scenarios = ScenarioType.values;

        for (final scenario in scenarios) {
          simulation.resetWithScenario(scenario);

          expect(() {
            OrbitalPathPainter.drawOrbitalPaths(
              canvas,
              size,
              vp,
              simulation,
              true,
            );
          }, returnsNormally);
        }
      });

      testWidgets('should handle alternating dual mode', (tester) async {
        const size = Size(800, 600);
        final vp = vm.Matrix4.identity();
        simulation.resetWithScenario(ScenarioType.solarSystem);

        for (int i = 0; i < 5; i++) {
          final dualMode = i % 2 == 0;

          expect(() {
            OrbitalPathPainter.drawOrbitalPaths(
              canvas,
              size,
              vp,
              simulation,
              true,
              dualMode: dualMode,
            );
          }, returnsNormally);
        }
      });
    });
  });
}
