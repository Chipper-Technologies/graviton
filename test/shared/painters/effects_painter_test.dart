import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/models/particles/collision_particle.dart';
import 'package:graviton/models/particles/debris_cloud.dart';
import 'package:graviton/models/effects/merge_flash.dart';
import 'package:graviton/models/effects/plasma_jet.dart';
import 'package:graviton/models/effects/shockwave.dart';
import 'package:graviton/shared/painters/effects_painter.dart';
import 'package:graviton/services/simulation/simulation.dart' as physics;
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void main() {
  group('EffectsPainter', () {
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
    });

    group('drawMergeFlashes', () {
      test('should draw merge flashes when simulation has active flashes', () {
        // Add merge flashes to simulation
        simulation.mergeFlashes.add(
          MergeFlash(
            vm.Vector3(0, 0, -20),
            AppColors.basicYellow,
            age: 0.5, // Recent flash
          ),
        );

        expect(
          () => EffectsPainter.drawMergeFlashes(
            canvas,
            canvasSize,
            viewProjectionMatrix,
            simulation,
          ),
          returnsNormally,
        );
      });

      test('should handle empty merge flashes list', () {
        // Empty simulation (no merge flashes)
        expect(
          () => EffectsPainter.drawMergeFlashes(
            canvas,
            canvasSize,
            viewProjectionMatrix,
            simulation,
          ),
          returnsNormally,
        );
      });

      test('should handle multiple merge flashes with different ages', () {
        // Recent flash
        simulation.mergeFlashes.add(
          MergeFlash(
            vm.Vector3(0, 0, -20),
            AppColors.basicYellow,
            age: 0.2, // Very recent
          ),
        );

        // Moderate age flash
        simulation.mergeFlashes.add(
          MergeFlash(
            vm.Vector3(30, 0, -20),
            AppColors.basicOrange,
            age: 1.0, // 1 second old
          ),
        );

        // Nearly expired flash
        simulation.mergeFlashes.add(
          MergeFlash(
            vm.Vector3(-30, 0, -20),
            AppColors.basicRed,
            age: 2.8, // Nearly expired (assuming 3s duration)
          ),
        );

        expect(
          () => EffectsPainter.drawMergeFlashes(
            canvas,
            canvasSize,
            viewProjectionMatrix,
            simulation,
          ),
          returnsNormally,
        );
      });

      test('should handle flashes with different colors', () {
        final colors = [
          AppColors.basicYellow,
          AppColors.basicOrange,
          AppColors.basicRed,
          AppColors.basicBlue,
          AppColors.basicPurple,
          AppColors.uiWhite,
        ];

        for (int i = 0; i < colors.length; i++) {
          simulation.mergeFlashes.add(
            MergeFlash(
              vm.Vector3(i * 10.0, 0, -20),
              colors[i],
              age: i * 0.3, // Staggered ages
            ),
          );
        }

        expect(
          () => EffectsPainter.drawMergeFlashes(
            canvas,
            canvasSize,
            viewProjectionMatrix,
            simulation,
          ),
          returnsNormally,
        );
      });

      test('should handle flashes at various positions', () {
        // Add flashes at different 3D positions
        simulation.mergeFlashes.addAll([
          MergeFlash(vm.Vector3(0, 0, -20), AppColors.basicRed, age: 0.5),
          MergeFlash(vm.Vector3(50, 0, -20), AppColors.basicGreen, age: 0.5),
          MergeFlash(vm.Vector3(-50, 0, -20), AppColors.basicBlue, age: 0.5),
          MergeFlash(vm.Vector3(0, 50, -20), AppColors.basicYellow, age: 0.5),
          MergeFlash(vm.Vector3(0, -50, -20), AppColors.basicPurple, age: 0.5),
          MergeFlash(
            vm.Vector3(0, 0, -50),
            AppColors.basicCyan,
            age: 0.5,
          ), // Further away
        ]);

        expect(
          () => EffectsPainter.drawMergeFlashes(
            canvas,
            canvasSize,
            viewProjectionMatrix,
            simulation,
          ),
          returnsNormally,
        );
      });

      test('should handle flash age progression', () {
        // Test flashes at different stages of their lifecycle
        simulation.mergeFlashes.addAll([
          MergeFlash(
            vm.Vector3(0, 0, -20),
            AppColors.uiWhite,
            age: 0.0,
          ), // Brand new
          MergeFlash(
            vm.Vector3(20, 0, -20),
            AppColors.basicYellow,
            age: 0.5,
          ), // Young
          MergeFlash(
            vm.Vector3(40, 0, -20),
            AppColors.basicOrange,
            age: 1.5,
          ), // Middle-aged
          MergeFlash(
            vm.Vector3(60, 0, -20),
            AppColors.basicRed,
            age: 2.5,
          ), // Old
          MergeFlash(
            vm.Vector3(80, 0, -20),
            AppColors.uiBlack,
            age: 3.0,
          ), // Very old
        ]);

        expect(
          () => EffectsPainter.drawMergeFlashes(
            canvas,
            canvasSize,
            viewProjectionMatrix,
            simulation,
          ),
          returnsNormally,
        );
      });

      test('should handle zero age flash', () {
        simulation.mergeFlashes.add(
          MergeFlash(
            vm.Vector3(0, 0, -20),
            AppColors.uiWhite,
            age: 0.0, // Brand new flash
          ),
        );

        expect(
          () => EffectsPainter.drawMergeFlashes(
            canvas,
            canvasSize,
            viewProjectionMatrix,
            simulation,
          ),
          returnsNormally,
        );
      });

      test('should handle negative age flash gracefully', () {
        simulation.mergeFlashes.add(
          MergeFlash(
            vm.Vector3(0, 0, -20),
            AppColors.basicRed,
            age: -1.0, // Negative age (shouldn't happen but test robustness)
          ),
        );

        expect(
          () => EffectsPainter.drawMergeFlashes(
            canvas,
            canvasSize,
            viewProjectionMatrix,
            simulation,
          ),
          returnsNormally,
        );
      });
    });

    group('Edge Cases', () {
      test('should handle flashes behind camera', () {
        simulation.mergeFlashes.add(
          MergeFlash(
            vm.Vector3(0, 0, 10), // Positive Z (behind camera)
            AppColors.basicYellow,
            age: 0.5,
          ),
        );

        expect(
          () => EffectsPainter.drawMergeFlashes(
            canvas,
            canvasSize,
            viewProjectionMatrix,
            simulation,
          ),
          returnsNormally,
        );
      });

      test('should handle zero-size canvas', () {
        simulation.mergeFlashes.add(
          MergeFlash(vm.Vector3(0, 0, -20), AppColors.basicYellow, age: 0.5),
        );

        expect(
          () => EffectsPainter.drawMergeFlashes(
            canvas,
            Size.zero,
            viewProjectionMatrix,
            simulation,
          ),
          returnsNormally,
        );
      });

      test('should handle extreme view transformations', () {
        simulation.mergeFlashes.add(
          MergeFlash(vm.Vector3(0, 0, -20), AppColors.basicYellow, age: 0.5),
        );

        final extremeView = vm.Matrix4.identity()
          ..translateByVector3(vm.Vector3(1000, 1000, 1000))
          ..rotateX(3.14159)
          ..scaleByVector3(vm.Vector3(0.001, 0.001, 0.001));

        expect(
          () => EffectsPainter.drawMergeFlashes(
            canvas,
            canvasSize,
            extremeView,
            simulation,
          ),
          returnsNormally,
        );
      });

      test('should handle many merge flashes performance test', () {
        // Add 100 flashes to test performance
        for (int i = 0; i < 100; i++) {
          simulation.mergeFlashes.add(
            MergeFlash(
              vm.Vector3(i * 2.0, 0, -20),
              AppColors.basicPrimaries[i % AppColors.basicPrimaries.length],
              age: i * 0.03, // Staggered ages
            ),
          );
        }

        expect(
          () => EffectsPainter.drawMergeFlashes(
            canvas,
            canvasSize,
            viewProjectionMatrix,
            simulation,
          ),
          returnsNormally,
        );
      });

      test('should handle flashes at extreme distances', () {
        simulation.mergeFlashes.addAll([
          MergeFlash(
            vm.Vector3(0, 0, -1),
            AppColors.basicRed,
            age: 0.5,
          ), // Very close
          MergeFlash(
            vm.Vector3(0, 0, -1000),
            AppColors.basicBlue,
            age: 0.5,
          ), // Very far
          MergeFlash(
            vm.Vector3(1000, 0, -20),
            AppColors.basicGreen,
            age: 0.5,
          ), // Far to side
          MergeFlash(
            vm.Vector3(-1000, 0, -20),
            AppColors.basicYellow,
            age: 0.5,
          ), // Far other side
          MergeFlash(
            vm.Vector3(0, 1000, -20),
            AppColors.basicPurple,
            age: 0.5,
          ), // Far up
          MergeFlash(
            vm.Vector3(0, -1000, -20),
            AppColors.basicCyan,
            age: 0.5,
          ), // Far down
        ]);

        expect(
          () => EffectsPainter.drawMergeFlashes(
            canvas,
            canvasSize,
            viewProjectionMatrix,
            simulation,
          ),
          returnsNormally,
        );
      });

      test('should handle flashes with transparent colors', () {
        simulation.mergeFlashes.addAll([
          MergeFlash(
            vm.Vector3(0, 0, -20),
            AppColors.transparentColor,
            age: 0.5,
          ),
          MergeFlash(
            vm.Vector3(20, 0, -20),
            AppColors.basicRed.withValues(alpha: AppTypography.opacityMedium),
            age: 0.5,
          ),
          MergeFlash(
            vm.Vector3(40, 0, -20),
            AppColors.basicBlue.withValues(
              alpha: AppTypography.opacityDisabled,
            ),
            age: 0.5,
          ),
        ]);

        expect(
          () => EffectsPainter.drawMergeFlashes(
            canvas,
            canvasSize,
            viewProjectionMatrix,
            simulation,
          ),
          returnsNormally,
        );
      });

      test('should handle very old flashes', () {
        // These would normally be cleaned up by the simulation, but test robustness
        simulation.mergeFlashes.addAll([
          MergeFlash(
            vm.Vector3(0, 0, -20),
            AppColors.uiWhite,
            age: 10.0,
          ), // Very old
          MergeFlash(
            vm.Vector3(20, 0, -20),
            AppColors.basicRed,
            age: 100.0,
          ), // Extremely old
        ]);

        expect(
          () => EffectsPainter.drawMergeFlashes(
            canvas,
            canvasSize,
            viewProjectionMatrix,
            simulation,
          ),
          returnsNormally,
        );
      });
    });

    tearDown(() {
      recorder.endRecording();
    });
  });

  group('drawDebrisParticles', () {
    late Canvas canvas;
    late ui.PictureRecorder recorder;
    late Size canvasSize;
    late vm.Matrix4 viewProjectionMatrix;
    late List<CollisionParticle> particles;

    setUp(() {
      recorder = ui.PictureRecorder();
      canvas = Canvas(recorder);
      canvasSize = const Size(800, 600);
      viewProjectionMatrix = vm.Matrix4.identity();
      particles = [];
    });

    test('should draw debris particles', () {
      particles.add(
        CollisionParticle(
          position: vm.Vector3(0, 0, -20),
          velocity: vm.Vector3(1, 1, 0),
          color: AppColors.basicRed,
          size: 2.0,
          lifetime: 2.0,
          mass: 0.5,
        ),
      );

      expect(
        () => EffectsPainter.drawDebrisParticles(
          canvas,
          canvasSize,
          viewProjectionMatrix,
          particles,
        ),
        returnsNormally,
      );
    });

    test('should handle empty particles list', () {
      expect(
        () => EffectsPainter.drawDebrisParticles(
          canvas,
          canvasSize,
          viewProjectionMatrix,
          particles,
        ),
        returnsNormally,
      );
    });

    test('should draw glow for larger particles', () {
      particles.add(
        CollisionParticle(
          position: vm.Vector3(0, 0, -20),
          velocity: vm.Vector3.zero(),
          color: AppColors.basicYellow,
          size: 3.0, // Size > 1.5 triggers glow
          lifetime: 2.0,
          mass: 0.5,
        ),
      );

      expect(
        () => EffectsPainter.drawDebrisParticles(
          canvas,
          canvasSize,
          viewProjectionMatrix,
          particles,
        ),
        returnsNormally,
      );
    });

    test('should handle particles with varying opacity', () {
      particles.addAll([
        CollisionParticle(
          position: vm.Vector3(0, 0, -20),
          velocity: vm.Vector3.zero(),
          color: AppColors.basicRed,
          size: 2.0,
          lifetime: 2.0,
          mass: 0.5,
        )..age = 0.0, // Full opacity
        CollisionParticle(
          position: vm.Vector3(10, 0, -20),
          velocity: vm.Vector3.zero(),
          color: AppColors.basicGreen,
          size: 2.0,
          lifetime: 2.0,
          mass: 0.5,
        )..age = 1.0, // Half opacity
        CollisionParticle(
          position: vm.Vector3(20, 0, -20),
          velocity: vm.Vector3.zero(),
          color: AppColors.basicBlue,
          size: 2.0,
          lifetime: 2.0,
          mass: 0.5,
        )..age = 2.0, // Nearly transparent
      ]);

      expect(
        () => EffectsPainter.drawDebrisParticles(
          canvas,
          canvasSize,
          viewProjectionMatrix,
          particles,
        ),
        returnsNormally,
      );
    });

    test('should handle many particles', () {
      for (int i = 0; i < 100; i++) {
        particles.add(
          CollisionParticle(
            position: vm.Vector3(i.toDouble(), 0, -20),
            velocity: vm.Vector3.zero(),
            color:
                AppColors.basicPrimaries[i % AppColors.basicPrimaries.length],
            size: 1.0 + (i % 3),
            lifetime: 2.0,
            mass: 0.5,
          ),
        );
      }

      expect(
        () => EffectsPainter.drawDebrisParticles(
          canvas,
          canvasSize,
          viewProjectionMatrix,
          particles,
        ),
        returnsNormally,
      );
    });

    tearDown(() {
      recorder.endRecording();
    });
  });

  group('drawShockwaves', () {
    late Canvas canvas;
    late ui.PictureRecorder recorder;
    late Size canvasSize;
    late vm.Matrix4 viewProjectionMatrix;
    late List<Shockwave> shockwaves;

    setUp(() {
      recorder = ui.PictureRecorder();
      canvas = Canvas(recorder);
      canvasSize = const Size(800, 600);
      viewProjectionMatrix = vm.Matrix4.identity();
      shockwaves = [];
    });

    test('should draw shockwaves', () {
      shockwaves.add(
        Shockwave(
          position: vm.Vector3(0, 0, -20),
          color: AppColors.basicBlue,
          maxRadius: 50.0,
          thickness: 2.0,
          lifetime: 2.0,
          impactEnergy: 100.0,
        ),
      );

      expect(
        () => EffectsPainter.drawShockwaves(
          canvas,
          canvasSize,
          viewProjectionMatrix,
          shockwaves,
        ),
        returnsNormally,
      );
    });

    test('should handle empty shockwaves list', () {
      expect(
        () => EffectsPainter.drawShockwaves(
          canvas,
          canvasSize,
          viewProjectionMatrix,
          shockwaves,
        ),
        returnsNormally,
      );
    });

    test('should handle multiple shockwaves at different stages', () {
      shockwaves.addAll([
        Shockwave(
          position: vm.Vector3(0, 0, -20),
          color: AppColors.basicBlue,
          maxRadius: 30.0,
          thickness: 2.0,
          lifetime: 2.0,
          impactEnergy: 100.0,
        )..age = 0.1,
        Shockwave(
          position: vm.Vector3(50, 0, -20),
          color: AppColors.basicRed,
          maxRadius: 50.0,
          thickness: 3.0,
          lifetime: 2.0,
          impactEnergy: 200.0,
        )..age = 1.0,
      ]);

      expect(
        () => EffectsPainter.drawShockwaves(
          canvas,
          canvasSize,
          viewProjectionMatrix,
          shockwaves,
        ),
        returnsNormally,
      );
    });

    tearDown(() {
      recorder.endRecording();
    });
  });

  group('drawDebrisClouds', () {
    late Canvas canvas;
    late ui.PictureRecorder recorder;
    late Size canvasSize;
    late vm.Matrix4 viewProjectionMatrix;
    late List<DebrisCloud> clouds;

    setUp(() {
      recorder = ui.PictureRecorder();
      canvas = Canvas(recorder);
      canvasSize = const Size(800, 600);
      viewProjectionMatrix = vm.Matrix4.identity();
      clouds = [];
    });

    test('should draw debris clouds', () {
      final particles = [
        CollisionParticle(
          position: vm.Vector3(0, 0, -20),
          velocity: vm.Vector3.zero(),
          color: AppColors.basicRed,
          size: 2.0,
          lifetime: 2.0,
          mass: 0.5,
        ),
      ];

      clouds.add(
        DebrisCloud(
          particles: particles,
          centerOfMass: vm.Vector3(0, 0, -20),
          expansionRate: 5.0,
          lifetime: 3.0,
          baseColor: AppColors.basicRed,
          collisionDirection: vm.Vector3(1, 0, 0),
        ),
      );

      expect(
        () => EffectsPainter.drawDebrisClouds(
          canvas,
          canvasSize,
          viewProjectionMatrix,
          clouds,
        ),
        returnsNormally,
      );
    });

    test('should handle empty clouds list', () {
      expect(
        () => EffectsPainter.drawDebrisClouds(
          canvas,
          canvasSize,
          viewProjectionMatrix,
          clouds,
        ),
        returnsNormally,
      );
    });

    tearDown(() {
      recorder.endRecording();
    });
  });

  group('drawPlasmaJets', () {
    late Canvas canvas;
    late ui.PictureRecorder recorder;
    late Size canvasSize;
    late vm.Matrix4 viewProjectionMatrix;
    late List<PlasmaJet> jets;

    setUp(() {
      recorder = ui.PictureRecorder();
      canvas = Canvas(recorder);
      canvasSize = const Size(800, 600);
      viewProjectionMatrix = vm.Matrix4.identity();
      jets = [];
    });

    test('should draw plasma jets', () {
      final particles = [
        CollisionParticle(
          position: vm.Vector3(0, 0, -20),
          velocity: vm.Vector3(10, 0, 0),
          color: AppColors.stellarOType,
          size: 2.0,
          lifetime: 2.0,
          mass: 0.5,
        ),
        CollisionParticle(
          position: vm.Vector3(5, 0, -20),
          velocity: vm.Vector3(10, 0, 0),
          color: AppColors.stellarOType,
          size: 2.0,
          lifetime: 2.0,
          mass: 0.5,
        ),
      ];

      jets.add(
        PlasmaJet(
          particles: particles,
          origin: vm.Vector3(0, 0, -20),
          direction: vm.Vector3(1, 0, 0),
          velocity: 10.0,
          lifetime: 3.0,
          baseColor: AppColors.stellarOType,
          temperature: 25000.0,
        ),
      );

      expect(
        () => EffectsPainter.drawPlasmaJets(
          canvas,
          canvasSize,
          viewProjectionMatrix,
          jets,
        ),
        returnsNormally,
      );
    });

    test('should handle empty jets list', () {
      expect(
        () => EffectsPainter.drawPlasmaJets(
          canvas,
          canvasSize,
          viewProjectionMatrix,
          jets,
        ),
        returnsNormally,
      );
    });

    tearDown(() {
      recorder.endRecording();
    });
  });

  group('drawAllCollisionEffects', () {
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
    });

    test('should draw all collision effects', () {
      // Add merge flash
      simulation.mergeFlashes.add(
        MergeFlash(vm.Vector3(0, 0, -20), AppColors.basicYellow, age: 0.5),
      );

      expect(
        () => EffectsPainter.drawAllCollisionEffects(
          canvas,
          canvasSize,
          viewProjectionMatrix,
          simulation,
        ),
        returnsNormally,
      );
    });

    test('should handle empty simulation', () {
      expect(
        () => EffectsPainter.drawAllCollisionEffects(
          canvas,
          canvasSize,
          viewProjectionMatrix,
          simulation,
        ),
        returnsNormally,
      );
    });

    tearDown(() {
      recorder.endRecording();
    });
  });
}
