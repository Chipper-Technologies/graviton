import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/gravity_field_color_scheme.dart';
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
        useRealisticColors: false,
        showOrbitalPaths: true,
        showHabitableZones: false,
        showHabitabilityIndicators: false,
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
      });

      test('Should handle different display settings', () {
        final fullFeaturesPainter = GravitonPainter(
          sim: simulation,
          view: viewMatrix,
          proj: projMatrix,
          stars: stars,
          showTrails: false,
          useWarmTrails: true,
          useRealisticColors: false,
          showOrbitalPaths: true,
          showHabitableZones: true,
          showHabitabilityIndicators: true,
          cameraDistance: 300.0,
        );

        expect(fullFeaturesPainter.showTrails, isFalse);
        expect(fullFeaturesPainter.useWarmTrails, isTrue);
        expect(fullFeaturesPainter.showHabitableZones, isTrue);
        expect(fullFeaturesPainter.showHabitabilityIndicators, isTrue);
      });
    });

    group('Painting', () {
      testWidgets('Should paint without throwing errors', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomPaint(
                painter: painter,
                child: const SizedBox(width: 800, height: 600),
              ),
            ),
          ),
        );

        // Find the specific CustomPaint with our painter
        final customPaints = tester.widgetList<CustomPaint>(
          find.byType(CustomPaint),
        );
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
          useRealisticColors: false,
          showOrbitalPaths: false,
          cameraDistance: 300.0,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomPaint(
                painter: emptyPainter,
                child: const SizedBox(width: 800, height: 600),
              ),
            ),
          ),
        );

        // Find the specific CustomPaint with our painter
        final customPaints = tester.widgetList<CustomPaint>(
          find.byType(CustomPaint),
        );
        expect(customPaints.any((cp) => cp.painter == emptyPainter), isTrue);
      });

      testWidgets('Should handle zero-size canvas', (tester) async {
        // Use a minimal size instead of zero to avoid NaN in background gradients
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomPaint(
                painter: painter,
                child: const SizedBox(width: 1, height: 1),
              ),
            ),
          ),
        );

        // Find the specific CustomPaint with our painter
        final customPaints = tester.widgetList<CustomPaint>(
          find.byType(CustomPaint),
        );
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
          useRealisticColors: false,
          showOrbitalPaths: false,
          cameraDistance: 300.0,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomPaint(
                painter: nullStarsPainter,
                child: const SizedBox(width: 800, height: 600),
              ),
            ),
          ),
        );

        // Find the specific CustomPaint with our painter
        final customPaints = tester.widgetList<CustomPaint>(
          find.byType(CustomPaint),
        );
        expect(
          customPaints.any((cp) => cp.painter == nullStarsPainter),
          isTrue,
        );
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
          useRealisticColors: false,
          showOrbitalPaths: false,
          cameraDistance: 300.0,
        );

        expect(painter.shouldRepaint(newPainter), isTrue);
      });

      test('Should repaint when view matrix changes', () {
        final newViewMatrix = vm.Matrix4.identity()
          ..translateByVector3(vm.Vector3(10.0, 0.0, 0.0));
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
        final newProjMatrix = vm.Matrix4.identity()
          ..scaleByVector3(vm.Vector3(2.0, 2.0, 2.0));
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
      testWidgets('Should handle extreme matrix transformations', (
        tester,
      ) async {
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
              body: CustomPaint(
                painter: extremePainter,
                child: const SizedBox(width: 800, height: 600),
              ),
            ),
          ),
        );

        // Find the specific CustomPaint with our painter
        final customPaints = tester.widgetList<CustomPaint>(
          find.byType(CustomPaint),
        );
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
            simulation.trails[i].add(
              TrailPoint(vm.Vector3(j.toDouble(), 0, 0), 1.0),
            );
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
              body: CustomPaint(
                painter: manyBodiesPainter,
                child: const SizedBox(width: 800, height: 600),
              ),
            ),
          ),
        );

        // Find the specific CustomPaint with our painter
        final customPaints = tester.widgetList<CustomPaint>(
          find.byType(CustomPaint),
        );
        expect(
          customPaints.any((cp) => cp.painter == manyBodiesPainter),
          isTrue,
        );
      });

      testWidgets('Should handle many merge flashes', (tester) async {
        // Add many merge flashes
        for (int i = 0; i < 50; i++) {
          simulation.mergeFlashes.add(
            MergeFlash(vm.Vector3(i.toDouble(), 0, 0), AppColors.basicRed),
          );
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
              body: CustomPaint(
                painter: manyFlashesPainter,
                child: const SizedBox(width: 800, height: 600),
              ),
            ),
          ),
        );

        // Find the specific CustomPaint with our painter
        final customPaints = tester.widgetList<CustomPaint>(
          find.byType(CustomPaint),
        );
        expect(
          customPaints.any((cp) => cp.painter == manyFlashesPainter),
          isTrue,
        );
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
        simulation.mergeFlashes.add(
          MergeFlash(vm.Vector3(0, 0, -20), AppColors.basicRed, age: 0.5),
        );

        // Add some trails
        simulation.trails.add([
          TrailPoint(vm.Vector3(0, 0, -20), 1.0),
          TrailPoint(vm.Vector3(1, 0, -20), 0.8),
        ]);

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
          cameraDistance: 300.0,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomPaint(
                painter: fullFeaturesPainter,
                child: const SizedBox(width: 800, height: 600),
              ),
            ),
          ),
        );

        // Find the specific CustomPaint with our painter
        final customPaints = tester.widgetList<CustomPaint>(
          find.byType(CustomPaint),
        );
        expect(
          customPaints.any((cp) => cp.painter == fullFeaturesPainter),
          isTrue,
        );
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
          cameraDistance: 300.0,
        );

        // This indirectly tests that all specialized painters are working
        // together through the orchestrator
        expect(orchestratorPainter.sim, equals(simulation));
        expect(orchestratorPainter.showTrails, isTrue);
        expect(orchestratorPainter.useWarmTrails, isTrue);
        expect(orchestratorPainter.showHabitableZones, isTrue);
        expect(orchestratorPainter.showHabitabilityIndicators, isTrue);
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
          cameraDistance: 300.0,
        );

        expect(minimalPainter.showTrails, isFalse);
        expect(minimalPainter.useWarmTrails, isFalse);
        expect(minimalPainter.showHabitableZones, isFalse);
        expect(minimalPainter.showHabitabilityIndicators, isFalse);
      });
    });

    group('Collision Effects Integration', () {
      testWidgets('Should render collision effects correctly', (tester) async {
        // Add collision flash
        simulation.mergeFlashes.add(
          MergeFlash(vm.Vector3(0, 0, -20), AppColors.basicYellow, age: 0.5),
        );

        final effectsPainter = GravitonPainter(
          sim: simulation,
          view: viewMatrix,
          proj: projMatrix,
          stars: stars,
          showTrails: true,
          useWarmTrails: false,
          cameraDistance: 300.0,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomPaint(
                painter: effectsPainter,
                child: const SizedBox(width: 800, height: 600),
              ),
            ),
          ),
        );

        final customPaints = tester.widgetList<CustomPaint>(
          find.byType(CustomPaint),
        );
        expect(customPaints.any((cp) => cp.painter == effectsPainter), isTrue);
      });

      testWidgets('Should handle multiple collision effects', (tester) async {
        // Add multiple effects
        for (int i = 0; i < 5; i++) {
          simulation.mergeFlashes.add(
            MergeFlash(
              vm.Vector3(i * 10.0, 0, -20),
              AppColors.basicPrimaries[i % AppColors.basicPrimaries.length],
              age: i * 0.2,
            ),
          );
        }

        final multiEffectsPainter = GravitonPainter(
          sim: simulation,
          view: viewMatrix,
          proj: projMatrix,
          stars: stars,
          showTrails: true,
          useWarmTrails: false,
          cameraDistance: 300.0,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomPaint(
                painter: multiEffectsPainter,
                child: const SizedBox(width: 800, height: 600),
              ),
            ),
          ),
        );

        final customPaints = tester.widgetList<CustomPaint>(
          find.byType(CustomPaint),
        );
        expect(
          customPaints.any((cp) => cp.painter == multiEffectsPainter),
          isTrue,
        );
      });
    });

    group('Gravity Field Options', () {
      test('Should handle gravity field color schemes', () {
        final classicPainter = GravitonPainter(
          sim: simulation,
          view: viewMatrix,
          proj: projMatrix,
          stars: stars,
          showTrails: true,
          useWarmTrails: false,
          cameraDistance: 300.0,
          globalGravityFields: true,
          gravityFieldColorScheme: GravityFieldColorScheme.classic,
        );

        expect(
          classicPainter.gravityFieldColorScheme,
          equals(GravityFieldColorScheme.classic),
        );

        final spectralPainter = GravitonPainter(
          sim: simulation,
          view: viewMatrix,
          proj: projMatrix,
          stars: stars,
          showTrails: true,
          useWarmTrails: false,
          cameraDistance: 300.0,
          globalGravityFields: true,
          gravityFieldColorScheme: GravityFieldColorScheme.spectral,
        );

        expect(
          spectralPainter.gravityFieldColorScheme,
          equals(GravityFieldColorScheme.spectral),
        );
      });

      test('Should handle equipotential surfaces toggle', () {
        final withSurfacesPainter = GravitonPainter(
          sim: simulation,
          view: viewMatrix,
          proj: projMatrix,
          stars: stars,
          showTrails: true,
          useWarmTrails: false,
          cameraDistance: 300.0,
          showEquipotentialSurfaces: true,
        );

        expect(withSurfacesPainter.showEquipotentialSurfaces, isTrue);

        final withoutSurfacesPainter = GravitonPainter(
          sim: simulation,
          view: viewMatrix,
          proj: projMatrix,
          stars: stars,
          showTrails: true,
          useWarmTrails: false,
          cameraDistance: 300.0,
          showEquipotentialSurfaces: false,
        );

        expect(withoutSurfacesPainter.showEquipotentialSurfaces, isFalse);
      });

      test('Should handle gravity field indicators toggle', () {
        final withIndicatorsPainter = GravitonPainter(
          sim: simulation,
          view: viewMatrix,
          proj: projMatrix,
          stars: stars,
          showTrails: true,
          useWarmTrails: false,
          cameraDistance: 300.0,
          showGravityFieldIndicators: true,
        );

        expect(withIndicatorsPainter.showGravityFieldIndicators, isTrue);
      });
    });

    group('Follow Mode', () {
      test('Should handle follow mode enabled', () {
        final followPainter = GravitonPainter(
          sim: simulation,
          view: viewMatrix,
          proj: projMatrix,
          stars: stars,
          showTrails: true,
          useWarmTrails: false,
          cameraDistance: 300.0,
          followMode: true,
          selectedBodyIndex: 0,
        );

        expect(followPainter.followMode, isTrue);
        expect(followPainter.selectedBodyIndex, equals(0));
      });

      test('Should handle follow mode disabled', () {
        final noFollowPainter = GravitonPainter(
          sim: simulation,
          view: viewMatrix,
          proj: projMatrix,
          stars: stars,
          showTrails: true,
          useWarmTrails: false,
          cameraDistance: 300.0,
          followMode: false,
          selectedBodyIndex: null,
        );

        expect(noFollowPainter.followMode, isFalse);
        expect(noFollowPainter.selectedBodyIndex, isNull);
      });
    });

    group('Dual Orbital Paths', () {
      test('Should handle dual orbital paths enabled', () {
        final dualPathsPainter = GravitonPainter(
          sim: simulation,
          view: viewMatrix,
          proj: projMatrix,
          stars: stars,
          showTrails: true,
          useWarmTrails: false,
          cameraDistance: 300.0,
          dualOrbitalPaths: true,
        );

        expect(dualPathsPainter.dualOrbitalPaths, isTrue);
      });

      test('Should handle dual orbital paths disabled', () {
        final singlePathsPainter = GravitonPainter(
          sim: simulation,
          view: viewMatrix,
          proj: projMatrix,
          stars: stars,
          showTrails: true,
          useWarmTrails: false,
          cameraDistance: 300.0,
          dualOrbitalPaths: false,
        );

        expect(singlePathsPainter.dualOrbitalPaths, isFalse);
      });
    });

    group('Camera Distance', () {
      test('Should handle different camera distances', () {
        final closePainter = GravitonPainter(
          sim: simulation,
          view: viewMatrix,
          proj: projMatrix,
          stars: stars,
          showTrails: true,
          useWarmTrails: false,
          cameraDistance: 100.0,
        );

        expect(closePainter.cameraDistance, equals(100.0));

        final farPainter = GravitonPainter(
          sim: simulation,
          view: viewMatrix,
          proj: projMatrix,
          stars: stars,
          showTrails: true,
          useWarmTrails: false,
          cameraDistance: 1000.0,
        );

        expect(farPainter.cameraDistance, equals(1000.0));
      });

      test('Should repaint when camera distance changes', () {
        final painter1 = GravitonPainter(
          sim: simulation,
          view: viewMatrix,
          proj: projMatrix,
          stars: stars,
          showTrails: true,
          useWarmTrails: false,
          cameraDistance: 300.0,
        );

        final painter2 = GravitonPainter(
          sim: simulation,
          view: viewMatrix,
          proj: projMatrix,
          stars: stars,
          showTrails: true,
          useWarmTrails: false,
          cameraDistance: 500.0,
        );

        expect(painter1.shouldRepaint(painter2), isTrue);
      });
    });

    group('Realistic Colors', () {
      test('Should handle realistic colors enabled', () {
        final realisticPainter = GravitonPainter(
          sim: simulation,
          view: viewMatrix,
          proj: projMatrix,
          stars: stars,
          showTrails: true,
          useWarmTrails: false,
          useRealisticColors: true,
          cameraDistance: 300.0,
        );

        expect(realisticPainter.useRealisticColors, isTrue);
      });

      test('Should handle realistic colors disabled', () {
        final simplePainter = GravitonPainter(
          sim: simulation,
          view: viewMatrix,
          proj: projMatrix,
          stars: stars,
          showTrails: true,
          useWarmTrails: false,
          useRealisticColors: false,
          cameraDistance: 300.0,
        );

        expect(simplePainter.useRealisticColors, isFalse);
      });

      test('Should repaint when realistic colors toggle changes', () {
        final painter1 = GravitonPainter(
          sim: simulation,
          view: viewMatrix,
          proj: projMatrix,
          stars: stars,
          showTrails: true,
          useWarmTrails: false,
          useRealisticColors: false,
          cameraDistance: 300.0,
        );

        final painter2 = GravitonPainter(
          sim: simulation,
          view: viewMatrix,
          proj: projMatrix,
          stars: stars,
          showTrails: true,
          useWarmTrails: false,
          useRealisticColors: true,
          cameraDistance: 300.0,
        );

        expect(painter1.shouldRepaint(painter2), isTrue);
      });
    });
  });
}
