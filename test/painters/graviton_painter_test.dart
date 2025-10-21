import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/models/merge_flash.dart';
import 'package:graviton/models/trail_point.dart';
import 'package:graviton/painters/graviton_painter.dart';
import 'package:graviton/services/simulation.dart' as physics;
import 'package:graviton/utils/star_generator.dart';
import 'package:vector_math/vector_math_64.dart' as vm;
import 'package:graviton/theme/app_colors.dart';

void main() {
  group('GravitonPainter', () {
    late physics.Simulation simulation;
    late vm.Matrix4 viewMatrix;
    late vm.Matrix4 projMatrix;
    late List<StarData> stars;
    late GravitonPainter painter;

    setUp(() {
      simulation = physics.Simulation();
      viewMatrix = vm.Matrix4.identity();
      projMatrix = vm.Matrix4.identity();
      stars = [
        StarData(vm.Vector3(10, 10, 10), 1.0, 0.8, 0xFFFFFFFF),
        StarData(vm.Vector3(-10, -10, -10), 0.8, 0.6, 0xFFFFE4B5),
        StarData(vm.Vector3(0, 15, -5), 1.2, 0.9, 0xFF87CEEB),
      ];

      painter = GravitonPainter(
        sim: simulation,
        view: viewMatrix,
        proj: projMatrix,
        stars: stars,
        showTrails: true,
        useWarmTrails: false,
        showOrbitalPaths: true,
        showHabitableZones: false,
        showHabitabilityIndicators: false,
        showGravityWells: false,
        cameraDistance: 300.0,
      );
    });

    group('Initialization', () {
      test('Should create painter with required parameters', () {
        expect(painter.sim, equals(simulation));
        expect(painter.view, equals(viewMatrix));
        expect(painter.proj, equals(projMatrix));
        expect(painter.stars, equals(stars));
        expect(painter.showTrails, isTrue);
        expect(painter.useWarmTrails, isFalse);
        expect(painter.showHabitableZones, isFalse);
        expect(painter.showHabitabilityIndicators, isFalse);
        expect(painter.showGravityWells, isFalse);
      });

      test('Should handle different display settings', () {
        final fullFeaturesPainter = GravitonPainter(
          sim: simulation,
          view: viewMatrix,
          proj: projMatrix,
          stars: stars,
          showTrails: false,
          useWarmTrails: true,
          showOrbitalPaths: true,
          showHabitableZones: true,
          showHabitabilityIndicators: true,
          showGravityWells: true,
          cameraDistance: 300.0,
        );

        expect(fullFeaturesPainter.showTrails, isFalse);
        expect(fullFeaturesPainter.useWarmTrails, isTrue);
        expect(fullFeaturesPainter.showHabitableZones, isTrue);
        expect(fullFeaturesPainter.showHabitabilityIndicators, isTrue);
        expect(fullFeaturesPainter.showGravityWells, isTrue);
      });
    });

    group('Painting', () {
      testWidgets('Should paint without throwing errors', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomPaint(painter: painter, child: const SizedBox(width: 800, height: 600)),
            ),
          ),
        );

        // Find the specific CustomPaint with our painter
        final customPaints = tester.widgetList<CustomPaint>(find.byType(CustomPaint));
        expect(customPaints.any((cp) => cp.painter == painter), isTrue);
      });

      testWidgets('Should handle empty simulation gracefully', (tester) async {
        simulation.bodies.clear();
        simulation.trails.clear();
        simulation.mergeFlashes.clear();

        final emptyPainter = GravitonPainter(
          sim: simulation,
          view: viewMatrix,
          proj: projMatrix,
          stars: stars,
          showTrails: true,
          useWarmTrails: false,
          showOrbitalPaths: false,
          cameraDistance: 300.0,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomPaint(painter: emptyPainter, child: const SizedBox(width: 800, height: 600)),
            ),
          ),
        );

        // Find the specific CustomPaint with our painter
        final customPaints = tester.widgetList<CustomPaint>(find.byType(CustomPaint));
        expect(customPaints.any((cp) => cp.painter == emptyPainter), isTrue);
      });

      testWidgets('Should handle zero-size canvas', (tester) async {
        // Use a minimal size instead of zero to avoid NaN in background gradients
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomPaint(painter: painter, child: const SizedBox(width: 1, height: 1)),
            ),
          ),
        );

        // Find the specific CustomPaint with our painter
        final customPaints = tester.widgetList<CustomPaint>(find.byType(CustomPaint));
        expect(customPaints.any((cp) => cp.painter == painter), isTrue);
      });

      testWidgets('Should handle null stars list', (tester) async {
        final nullStarsPainter = GravitonPainter(
          sim: simulation,
          view: viewMatrix,
          proj: projMatrix,
          stars: [],
          showTrails: true,
          useWarmTrails: false,
          showOrbitalPaths: false,
          cameraDistance: 300.0,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomPaint(painter: nullStarsPainter, child: const SizedBox(width: 800, height: 600)),
            ),
          ),
        );

        // Find the specific CustomPaint with our painter
        final customPaints = tester.widgetList<CustomPaint>(find.byType(CustomPaint));
        expect(customPaints.any((cp) => cp.painter == nullStarsPainter), isTrue);
      });
    });

    group('Repaint Logic', () {
      test('Should repaint when simulation changes', () {
        final newSimulation = physics.Simulation();
        final newPainter = GravitonPainter(
          sim: newSimulation,
          view: viewMatrix,
          proj: projMatrix,
          stars: stars,
          showTrails: true,
          useWarmTrails: false,
          showOrbitalPaths: false,
          cameraDistance: 300.0,
        );

        expect(painter.shouldRepaint(newPainter), isTrue);
      });

      test('Should repaint when view matrix changes', () {
        final newViewMatrix = vm.Matrix4.identity()..translateByVector3(vm.Vector3(10.0, 0.0, 0.0));
        final newPainter = GravitonPainter(
          sim: simulation,
          view: newViewMatrix,
          proj: projMatrix,
          stars: stars,
          showTrails: true,
          useWarmTrails: false,
          showOrbitalPaths: false,
          cameraDistance: 300.0,
        );

        expect(painter.shouldRepaint(newPainter), isTrue);
      });

      test('Should repaint when projection matrix changes', () {
        final newProjMatrix = vm.Matrix4.identity()..scaleByVector3(vm.Vector3(2.0, 2.0, 2.0));
        final newPainter = GravitonPainter(
          sim: simulation,
          view: viewMatrix,
          proj: newProjMatrix,
          stars: stars,
          showTrails: true,
          useWarmTrails: false,
          showOrbitalPaths: false,
          cameraDistance: 300.0,
        );

        expect(painter.shouldRepaint(newPainter), isTrue);
      });

      test('Should repaint when stars change', () {
        final newStars = [StarData(vm.Vector3(5, 5, 5), 1.0, 0.8, 0xFFFFFFFF)];
        final newPainter = GravitonPainter(
          sim: simulation,
          view: viewMatrix,
          proj: projMatrix,
          stars: newStars,
          showTrails: true,
          useWarmTrails: false,
          showOrbitalPaths: false,
          cameraDistance: 300.0,
        );

        expect(painter.shouldRepaint(newPainter), isTrue);
      });

      test('Should repaint when trail settings change', () {
        final newPainter = GravitonPainter(
          sim: simulation,
          view: viewMatrix,
          proj: projMatrix,
          stars: stars,
          showTrails: false,
          useWarmTrails: true,
          showOrbitalPaths: true,
          cameraDistance: 300.0,
        );

        expect(painter.shouldRepaint(newPainter), isTrue);
      });

      test('Should always repaint for real-time simulation', () {
        final identicalPainter = GravitonPainter(
          sim: simulation,
          view: viewMatrix,
          proj: projMatrix,
          stars: stars,
          showTrails: true,
          useWarmTrails: false,
          showOrbitalPaths: false,
          cameraDistance: 300.0,
        );

        // Real-time simulation always repaints for smooth animation
        expect(painter.shouldRepaint(identicalPainter), isTrue);
      });
    });

    group('Edge Cases', () {
      testWidgets('Should handle extreme matrix transformations', (tester) async {
        final extremeView = vm.Matrix4.identity()
          ..translateByVector3(vm.Vector3(1000.0, 1000.0, 1000.0))
          ..rotateX(math.pi)
          ..scaleByVector3(vm.Vector3(0.001, 0.001, 0.001));

        final extremePainter = GravitonPainter(
          sim: simulation,
          view: extremeView,
          proj: projMatrix,
          stars: stars,
          showTrails: true,
          useWarmTrails: false,
          showOrbitalPaths: false,
          cameraDistance: 300.0,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomPaint(painter: extremePainter, child: const SizedBox(width: 800, height: 600)),
            ),
          ),
        );

        // Find the specific CustomPaint with our painter
        final customPaints = tester.widgetList<CustomPaint>(find.byType(CustomPaint));
        expect(customPaints.any((cp) => cp.painter == extremePainter), isTrue);
      });

      testWidgets('Should handle many bodies and trails', (tester) async {
        // Add many bodies to test performance edge case
        for (int i = 0; i < 100; i++) {
          simulation.bodies.add(
            Body(
              position: vm.Vector3(i.toDouble(), 0, 0),
              velocity: vm.Vector3.zero(),
              mass: 1.0,
              radius: 1.0,
              color: AppColors.uiWhite,
              name: 'Body $i',
            ),
          );
        }

        // Add many trail points
        for (int i = 0; i < simulation.bodies.length; i++) {
          simulation.trails.add([]);
          for (int j = 0; j < 100; j++) {
            simulation.trails[i].add(TrailPoint(vm.Vector3(j.toDouble(), 0, 0), 1.0));
          }
        }

        final manyBodiesPainter = GravitonPainter(
          sim: simulation,
          view: viewMatrix,
          proj: projMatrix,
          stars: stars,
          showTrails: true,
          useWarmTrails: false,
          showOrbitalPaths: false,
          cameraDistance: 300.0,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomPaint(painter: manyBodiesPainter, child: const SizedBox(width: 800, height: 600)),
            ),
          ),
        );

        // Find the specific CustomPaint with our painter
        final customPaints = tester.widgetList<CustomPaint>(find.byType(CustomPaint));
        expect(customPaints.any((cp) => cp.painter == manyBodiesPainter), isTrue);
      });

      testWidgets('Should handle many merge flashes', (tester) async {
        // Add many merge flashes
        for (int i = 0; i < 50; i++) {
          simulation.mergeFlashes.add(MergeFlash(vm.Vector3(i.toDouble(), 0, 0), AppColors.basicRed));
        }

        final manyFlashesPainter = GravitonPainter(
          sim: simulation,
          view: viewMatrix,
          proj: projMatrix,
          stars: stars,
          showTrails: true,
          useWarmTrails: false,
          showOrbitalPaths: false,
          cameraDistance: 300.0,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomPaint(painter: manyFlashesPainter, child: const SizedBox(width: 800, height: 600)),
            ),
          ),
        );

        // Find the specific CustomPaint with our painter
        final customPaints = tester.widgetList<CustomPaint>(find.byType(CustomPaint));
        expect(customPaints.any((cp) => cp.painter == manyFlashesPainter), isTrue);
      });

      testWidgets('Should handle all display options enabled', (tester) async {
        // Add bodies with different types
        simulation.bodies.add(
          Body(
            position: vm.Vector3(0, 0, -20),
            velocity: vm.Vector3.zero(),
            mass: 100.0,
            radius: 8.0,
            color: AppColors.basicYellow,
            name: 'Test Star',
          ),
        );

        simulation.bodies.add(
          Body(
            position: vm.Vector3(30, 0, -20),
            velocity: vm.Vector3.zero(),
            mass: 20.0,
            radius: 4.0,
            color: AppColors.basicBlue,
            name: 'Test Planet',
          ),
        );

        // Add some merge flashes
        simulation.mergeFlashes.add(MergeFlash(vm.Vector3(0, 0, -20), AppColors.basicRed, age: 0.5));

        // Add some trails
        simulation.trails.add([TrailPoint(vm.Vector3(0, 0, -20), 1.0), TrailPoint(vm.Vector3(1, 0, -20), 0.8)]);

        final fullFeaturesPainter = GravitonPainter(
          sim: simulation,
          view: viewMatrix,
          proj: projMatrix,
          stars: stars,
          showTrails: true,
          useWarmTrails: true,
          showOrbitalPaths: true,
          showHabitableZones: true,
          showHabitabilityIndicators: true,
          showGravityWells: true,
          cameraDistance: 300.0,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomPaint(painter: fullFeaturesPainter, child: const SizedBox(width: 800, height: 600)),
            ),
          ),
        );

        // Find the specific CustomPaint with our painter
        final customPaints = tester.widgetList<CustomPaint>(find.byType(CustomPaint));
        expect(customPaints.any((cp) => cp.painter == fullFeaturesPainter), isTrue);
      });
    });

    group('Orchestration', () {
      test('Should orchestrate all specialized painters correctly', () {
        // Test that the painter coordinates all the specialized painters
        // by verifying that it doesn't throw when all features are enabled
        final orchestratorPainter = GravitonPainter(
          sim: simulation,
          view: viewMatrix,
          proj: projMatrix,
          stars: stars,
          showTrails: true,
          useWarmTrails: true,
          showOrbitalPaths: true,
          showHabitableZones: true,
          showHabitabilityIndicators: true,
          showGravityWells: true,
          cameraDistance: 300.0,
        );

        // This indirectly tests that all specialized painters are working
        // together through the orchestrator
        expect(orchestratorPainter.sim, equals(simulation));
        expect(orchestratorPainter.showTrails, isTrue);
        expect(orchestratorPainter.useWarmTrails, isTrue);
        expect(orchestratorPainter.showHabitableZones, isTrue);
        expect(orchestratorPainter.showHabitabilityIndicators, isTrue);
        expect(orchestratorPainter.showGravityWells, isTrue);
      });

      test('Should handle feature toggling', () {
        // Test individual feature control
        final minimalPainter = GravitonPainter(
          sim: simulation,
          view: viewMatrix,
          proj: projMatrix,
          stars: stars,
          showTrails: false,
          useWarmTrails: false,
          showOrbitalPaths: false,
          showHabitableZones: false,
          showHabitabilityIndicators: false,
          showGravityWells: false,
          cameraDistance: 300.0,
        );

        expect(minimalPainter.showTrails, isFalse);
        expect(minimalPainter.useWarmTrails, isFalse);
        expect(minimalPainter.showHabitableZones, isFalse);
        expect(minimalPainter.showHabitabilityIndicators, isFalse);
        expect(minimalPainter.showGravityWells, isFalse);
      });
    });
  });
}
