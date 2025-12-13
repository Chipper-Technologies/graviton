import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/core/enums/gravity_field_color_scheme.dart';
import 'package:graviton/core/enums/scenario_type.dart';
import 'package:graviton/shared/painters/graviton_painter.dart';
import 'package:graviton/services/simulation/simulation.dart' as physics;
import 'package:graviton/utils/star_generator.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void main() {
  group('GravitonPainter Tests', () {
    late physics.Simulation simulation;
    late vm.Matrix4 view;
    late vm.Matrix4 proj;
    late List<StarData> stars;

    setUp(() {
      simulation = physics.Simulation();
      view = vm.Matrix4.identity();
      proj = vm.Matrix4.identity();
      stars = [];
    });

    group('Constructor Tests', () {
      testWidgets('should create painter with default parameters', (
        tester,
      ) async {
        expect(() {
          GravitonPainter(
            sim: simulation,
            view: view,
            proj: proj,
            stars: stars,
            showTrails: true,
            useWarmTrails: false,
            useRealisticColors: true,
            showOrbitalPaths: false,
            dualOrbitalPaths: false,
            showHabitableZones: false,
            showHabitabilityIndicators: false,
            selectedBodyIndex: null,
            followMode: false,
            cameraDistance: 1000.0,
            globalGravityFields: false,
            gravityFieldColorScheme: GravityFieldColorScheme.classic,
            showEquipotentialSurfaces: false,
            showGravityFieldIndicators: false,
          );
        }, returnsNormally);
      });

      testWidgets('should create painter with selected body', (tester) async {
        simulation.resetWithScenario(ScenarioType.solarSystem);

        expect(() {
          GravitonPainter(
            sim: simulation,
            view: view,
            proj: proj,
            stars: stars,
            showTrails: true,
            useWarmTrails: false,
            useRealisticColors: true,
            showOrbitalPaths: false,
            dualOrbitalPaths: false,
            showHabitableZones: false,
            showHabitabilityIndicators: false,
            selectedBodyIndex: 0,
            followMode: true,
            cameraDistance: 500.0,
            globalGravityFields: true,
            gravityFieldColorScheme: GravityFieldColorScheme.spectral,
            showEquipotentialSurfaces: true,
            showGravityFieldIndicators: true,
          );
        }, returnsNormally);
      });

      testWidgets('should create painter with all features enabled', (
        tester,
      ) async {
        simulation.resetWithScenario(ScenarioType.galaxyFormation);

        expect(() {
          GravitonPainter(
            sim: simulation,
            view: view,
            proj: proj,
            stars: stars,
            showTrails: true,
            useWarmTrails: true,
            useRealisticColors: true,
            showOrbitalPaths: true,
            dualOrbitalPaths: true,
            showHabitableZones: true,
            showHabitabilityIndicators: true,
            selectedBodyIndex: 1,
            followMode: true,
            cameraDistance: 2000.0,
            globalGravityFields: true,
            gravityFieldColorScheme: GravityFieldColorScheme.neon,
            showEquipotentialSurfaces: true,
            showGravityFieldIndicators: true,
          );
        }, returnsNormally);
      });
    });

    group('Paint Method Tests', () {
      testWidgets('should paint with solar system scenario', (tester) async {
        simulation.resetWithScenario(ScenarioType.solarSystem);
        const size = Size(800, 600);

        final painter = GravitonPainter(
          sim: simulation,
          view: view,
          proj: proj,
          stars: stars,
          showTrails: true,
          useWarmTrails: false,
          useRealisticColors: true,
          showOrbitalPaths: false,
          dualOrbitalPaths: false,
          showHabitableZones: false,
          showHabitabilityIndicators: false,
          selectedBodyIndex: null,
          followMode: false,
          cameraDistance: 1000.0,
          globalGravityFields: false,
          gravityFieldColorScheme: GravityFieldColorScheme.classic,
          showEquipotentialSurfaces: false,
          showGravityFieldIndicators: false,
        );

        final recorder = PictureRecorder();
        final canvas = Canvas(recorder);

        expect(() {
          painter.paint(canvas, size);
        }, returnsNormally);

        recorder.endRecording();
      });

      testWidgets('should paint with galaxy formation scenario', (
        tester,
      ) async {
        simulation.resetWithScenario(ScenarioType.galaxyFormation);
        const size = Size(1200, 800);

        final painter = GravitonPainter(
          sim: simulation,
          view: view,
          proj: proj,
          stars: stars,
          showTrails: true,
          useWarmTrails: true,
          useRealisticColors: true,
          showOrbitalPaths: true,
          dualOrbitalPaths: true,
          showHabitableZones: true,
          showHabitabilityIndicators: true,
          selectedBodyIndex: 0,
          followMode: true,
          cameraDistance: 5000.0,
          globalGravityFields: true,
          gravityFieldColorScheme: GravityFieldColorScheme.spectral,
          showEquipotentialSurfaces: true,
          showGravityFieldIndicators: true,
        );

        final recorder = PictureRecorder();
        final canvas = Canvas(recorder);

        expect(() {
          painter.paint(canvas, size);
        }, returnsNormally);

        recorder.endRecording();
      });

      testWidgets('should paint with binary stars scenario', (tester) async {
        simulation.resetWithScenario(ScenarioType.binaryStars);
        const size = Size(600, 600);

        final painter = GravitonPainter(
          sim: simulation,
          view: view,
          proj: proj,
          stars: stars,
          showTrails: false,
          useWarmTrails: false,
          useRealisticColors: false,
          showOrbitalPaths: true,
          dualOrbitalPaths: false,
          showHabitableZones: false,
          showHabitabilityIndicators: false,
          selectedBodyIndex: null,
          followMode: false,
          cameraDistance: 800.0,
          globalGravityFields: true,
          gravityFieldColorScheme: GravityFieldColorScheme.monochrome,
          showEquipotentialSurfaces: false,
          showGravityFieldIndicators: true,
        );

        final recorder = PictureRecorder();
        final canvas = Canvas(recorder);

        expect(() {
          painter.paint(canvas, size);
        }, returnsNormally);

        recorder.endRecording();
      });

      testWidgets('should paint with earth-moon-sun scenario', (tester) async {
        simulation.resetWithScenario(ScenarioType.earthMoonSun);
        const size = Size(400, 300);

        final painter = GravitonPainter(
          sim: simulation,
          view: view,
          proj: proj,
          stars: stars,
          showTrails: true,
          useWarmTrails: true,
          useRealisticColors: true,
          showOrbitalPaths: false,
          dualOrbitalPaths: false,
          showHabitableZones: true,
          showHabitabilityIndicators: true,
          selectedBodyIndex: 1, // Earth
          followMode: false,
          cameraDistance: 200.0,
          globalGravityFields: false,
          gravityFieldColorScheme: GravityFieldColorScheme.classic,
          showEquipotentialSurfaces: false,
          showGravityFieldIndicators: false,
        );

        final recorder = PictureRecorder();
        final canvas = Canvas(recorder);

        expect(() {
          painter.paint(canvas, size);
        }, returnsNormally);

        recorder.endRecording();
      });
    });

    group('Different Canvas Sizes', () {
      testWidgets('should handle various canvas sizes', (tester) async {
        simulation.resetWithScenario(ScenarioType.solarSystem);

        final painter = GravitonPainter(
          sim: simulation,
          view: view,
          proj: proj,
          stars: stars,
          showTrails: true,
          useWarmTrails: false,
          useRealisticColors: true,
          showOrbitalPaths: false,
          dualOrbitalPaths: false,
          showHabitableZones: false,
          showHabitabilityIndicators: false,
          selectedBodyIndex: null,
          followMode: false,
          cameraDistance: 1000.0,
          globalGravityFields: false,
          gravityFieldColorScheme: GravityFieldColorScheme.classic,
          showEquipotentialSurfaces: false,
          showGravityFieldIndicators: false,
        );

        final sizes = [
          const Size(100, 100),
          const Size(400, 300),
          const Size(800, 600),
          const Size(1920, 1080),
          const Size(1, 1),
        ];

        for (final size in sizes) {
          final recorder = PictureRecorder();
          final canvas = Canvas(recorder);

          expect(() {
            painter.paint(canvas, size);
          }, returnsNormally);

          recorder.endRecording();
        }
      });
    });

    group('Different Gravity Field Color Schemes', () {
      testWidgets('should handle all gravity field color schemes', (
        tester,
      ) async {
        simulation.resetWithScenario(ScenarioType.solarSystem);
        const size = Size(800, 600);

        final schemes = GravityFieldColorScheme.values;

        for (final scheme in schemes) {
          final painter = GravitonPainter(
            sim: simulation,
            view: view,
            proj: proj,
            stars: stars,
            showTrails: false,
            useWarmTrails: false,
            useRealisticColors: true,
            showOrbitalPaths: false,
            dualOrbitalPaths: false,
            showHabitableZones: false,
            showHabitabilityIndicators: false,
            selectedBodyIndex: null,
            followMode: false,
            cameraDistance: 1000.0,
            globalGravityFields: true,
            gravityFieldColorScheme: scheme,
            showEquipotentialSurfaces: true,
            showGravityFieldIndicators: true,
          );

          final recorder = PictureRecorder();
          final canvas = Canvas(recorder);

          expect(() {
            painter.paint(canvas, size);
          }, returnsNormally);

          recorder.endRecording();
        }
      });
    });

    group('Different Scenarios', () {
      testWidgets('should handle all scenario types', (tester) async {
        const size = Size(800, 600);

        final scenarios = ScenarioType.values;

        for (final scenario in scenarios) {
          simulation.resetWithScenario(scenario);

          final painter = GravitonPainter(
            sim: simulation,
            view: view,
            proj: proj,
            stars: stars,
            showTrails: true,
            useWarmTrails: false,
            useRealisticColors: true,
            showOrbitalPaths: true,
            dualOrbitalPaths: false,
            showHabitableZones: true,
            showHabitabilityIndicators: true,
            selectedBodyIndex: null,
            followMode: false,
            cameraDistance: 1000.0,
            globalGravityFields: true,
            gravityFieldColorScheme: GravityFieldColorScheme.classic,
            showEquipotentialSurfaces: false,
            showGravityFieldIndicators: false,
          );

          final recorder = PictureRecorder();
          final canvas = Canvas(recorder);

          expect(() {
            painter.paint(canvas, size);
          }, returnsNormally);

          recorder.endRecording();
        }
      });
    });

    group('shouldRepaint Tests', () {
      test('should always repaint (returns true)', () {
        simulation.resetWithScenario(ScenarioType.solarSystem);

        final painter1 = GravitonPainter(
          sim: simulation,
          view: view,
          proj: proj,
          stars: stars,
          showTrails: true,
          useWarmTrails: false,
          useRealisticColors: true,
          showOrbitalPaths: false,
          dualOrbitalPaths: false,
          showHabitableZones: false,
          showHabitabilityIndicators: false,
          selectedBodyIndex: null,
          followMode: false,
          cameraDistance: 1000.0,
          globalGravityFields: false,
          gravityFieldColorScheme: GravityFieldColorScheme.classic,
          showEquipotentialSurfaces: false,
          showGravityFieldIndicators: false,
        );

        final painter2 = GravitonPainter(
          sim: simulation,
          view: view,
          proj: proj,
          stars: stars,
          showTrails: false, // Different parameter
          useWarmTrails: false,
          useRealisticColors: true,
          showOrbitalPaths: false,
          dualOrbitalPaths: false,
          showHabitableZones: false,
          showHabitabilityIndicators: false,
          selectedBodyIndex: null,
          followMode: false,
          cameraDistance: 1000.0,
          globalGravityFields: false,
          gravityFieldColorScheme: GravityFieldColorScheme.classic,
          showEquipotentialSurfaces: false,
          showGravityFieldIndicators: false,
        );

        // Should always return true for animation purposes
        expect(painter1.shouldRepaint(painter2), isTrue);
      });
    });

    group('Matrix Transformations', () {
      testWidgets('should handle different view matrices', (tester) async {
        simulation.resetWithScenario(ScenarioType.solarSystem);
        const size = Size(800, 600);

        final transformations = [
          vm.Matrix4.identity(),
          vm.Matrix4.identity()..scaleByVector3(vm.Vector3(2.0, 2.0, 2.0)),
          vm.Matrix4.identity()
            ..translateByVector3(vm.Vector3(100.0, 100.0, 0.0)),
          vm.Matrix4.identity()..rotateZ(math.pi / 4),
          vm.Matrix4.identity()..rotateX(math.pi / 6),
          vm.Matrix4.identity()..rotateY(math.pi / 3),
        ];

        for (final transformation in transformations) {
          final painter = GravitonPainter(
            sim: simulation,
            view: transformation,
            proj: proj,
            stars: stars,
            showTrails: true,
            useWarmTrails: false,
            useRealisticColors: true,
            showOrbitalPaths: false,
            dualOrbitalPaths: false,
            showHabitableZones: false,
            showHabitabilityIndicators: false,
            selectedBodyIndex: null,
            followMode: false,
            cameraDistance: 1000.0,
            globalGravityFields: false,
            gravityFieldColorScheme: GravityFieldColorScheme.classic,
            showEquipotentialSurfaces: false,
            showGravityFieldIndicators: false,
          );

          final recorder = PictureRecorder();
          final canvas = Canvas(recorder);

          expect(() {
            painter.paint(canvas, size);
          }, returnsNormally);

          recorder.endRecording();
        }
      });

      testWidgets('should handle different projection matrices', (
        tester,
      ) async {
        simulation.resetWithScenario(ScenarioType.solarSystem);
        const size = Size(800, 600);

        final projections = [
          vm.Matrix4.identity(),
          vm.Matrix4.identity()..scaleByVector3(vm.Vector3(0.5, 0.5, 0.5)),
          vm.Matrix4.identity()..scaleByVector3(vm.Vector3(2.0, 2.0, 2.0)),
          vm.Matrix4.identity()
            ..translateByVector3(vm.Vector3(50.0, 50.0, 0.0)),
        ];

        for (final projection in projections) {
          final painter = GravitonPainter(
            sim: simulation,
            view: view,
            proj: projection,
            stars: stars,
            showTrails: true,
            useWarmTrails: false,
            useRealisticColors: true,
            showOrbitalPaths: false,
            dualOrbitalPaths: false,
            showHabitableZones: false,
            showHabitabilityIndicators: false,
            selectedBodyIndex: null,
            followMode: false,
            cameraDistance: 1000.0,
            globalGravityFields: false,
            gravityFieldColorScheme: GravityFieldColorScheme.classic,
            showEquipotentialSurfaces: false,
            showGravityFieldIndicators: false,
          );

          final recorder = PictureRecorder();
          final canvas = Canvas(recorder);

          expect(() {
            painter.paint(canvas, size);
          }, returnsNormally);

          recorder.endRecording();
        }
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle empty simulation', (tester) async {
        const size = Size(800, 600);
        final emptySimulation = physics.Simulation();

        final painter = GravitonPainter(
          sim: emptySimulation,
          view: view,
          proj: proj,
          stars: stars,
          showTrails: true,
          useWarmTrails: false,
          useRealisticColors: true,
          showOrbitalPaths: false,
          dualOrbitalPaths: false,
          showHabitableZones: false,
          showHabitabilityIndicators: false,
          selectedBodyIndex: null,
          followMode: false,
          cameraDistance: 1000.0,
          globalGravityFields: false,
          gravityFieldColorScheme: GravityFieldColorScheme.classic,
          showEquipotentialSurfaces: false,
          showGravityFieldIndicators: false,
        );

        final recorder = PictureRecorder();
        final canvas = Canvas(recorder);

        expect(() {
          painter.paint(canvas, size);
        }, returnsNormally);

        recorder.endRecording();
      });

      testWidgets('should handle extreme camera distances', (tester) async {
        simulation.resetWithScenario(ScenarioType.solarSystem);
        const size = Size(800, 600);

        final distances = [0.1, 1.0, 100.0, 10000.0, 1000000.0];

        for (final distance in distances) {
          final painter = GravitonPainter(
            sim: simulation,
            view: view,
            proj: proj,
            stars: stars,
            showTrails: true,
            useWarmTrails: false,
            useRealisticColors: true,
            showOrbitalPaths: false,
            dualOrbitalPaths: false,
            showHabitableZones: false,
            showHabitabilityIndicators: false,
            selectedBodyIndex: null,
            followMode: false,
            cameraDistance: distance,
            globalGravityFields: false,
            gravityFieldColorScheme: GravityFieldColorScheme.classic,
            showEquipotentialSurfaces: false,
            showGravityFieldIndicators: false,
          );

          final recorder = PictureRecorder();
          final canvas = Canvas(recorder);

          expect(() {
            painter.paint(canvas, size);
          }, returnsNormally);

          recorder.endRecording();
        }
      });

      testWidgets('should handle invalid selected body index', (tester) async {
        simulation.resetWithScenario(ScenarioType.solarSystem);
        const size = Size(800, 600);

        final invalidIndices = [-1, 100, 999];

        for (final index in invalidIndices) {
          final painter = GravitonPainter(
            sim: simulation,
            view: view,
            proj: proj,
            stars: stars,
            showTrails: true,
            useWarmTrails: false,
            useRealisticColors: true,
            showOrbitalPaths: false,
            dualOrbitalPaths: false,
            showHabitableZones: false,
            showHabitabilityIndicators: false,
            selectedBodyIndex: index,
            followMode: false,
            cameraDistance: 1000.0,
            globalGravityFields: false,
            gravityFieldColorScheme: GravityFieldColorScheme.classic,
            showEquipotentialSurfaces: false,
            showGravityFieldIndicators: false,
          );

          final recorder = PictureRecorder();
          final canvas = Canvas(recorder);

          expect(() {
            painter.paint(canvas, size);
          }, returnsNormally);

          recorder.endRecording();
        }
      });
    });

    group('Performance Tests', () {
      testWidgets('should handle rapid repaints', (tester) async {
        simulation.resetWithScenario(ScenarioType.galaxyFormation);
        const size = Size(800, 600);

        final painter = GravitonPainter(
          sim: simulation,
          view: view,
          proj: proj,
          stars: stars,
          showTrails: true,
          useWarmTrails: true,
          useRealisticColors: true,
          showOrbitalPaths: true,
          dualOrbitalPaths: true,
          showHabitableZones: true,
          showHabitabilityIndicators: true,
          selectedBodyIndex: 0,
          followMode: true,
          cameraDistance: 2000.0,
          globalGravityFields: true,
          gravityFieldColorScheme: GravityFieldColorScheme.emerald,
          showEquipotentialSurfaces: true,
          showGravityFieldIndicators: true,
        );

        // Simulate multiple rapid repaints
        for (int i = 0; i < 5; i++) {
          final recorder = PictureRecorder();
          final canvas = Canvas(recorder);

          expect(() {
            painter.paint(canvas, size);
          }, returnsNormally);

          recorder.endRecording();
        }
      });
    });
  });
}
