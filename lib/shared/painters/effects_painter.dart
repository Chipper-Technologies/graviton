import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:graviton/core/constants/rendering_constants.dart';
import 'package:graviton/core/constants/simulation_constants.dart';
import 'package:graviton/models/particles/collision_particle.dart';
import 'package:graviton/models/particles/debris_cloud.dart';
import 'package:graviton/models/effects/plasma_jet.dart';
import 'package:graviton/models/effects/shockwave.dart';
import 'package:graviton/services/simulation/simulation.dart' as physics;
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/utils/painter_utils.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// Painter responsible for rendering visual effects like merge flashes and explosions
class EffectsPainter {
  /// Draw merge flashes from body collisions
  static void drawMergeFlashes(
    Canvas canvas,
    Size size,
    vm.Matrix4 vp,
    physics.Simulation sim,
  ) {
    // Flashes (draw before bodies so glow looks integrated)
    for (final flash in sim.mergeFlashes) {
      final p = PainterUtils.project(vp, flash.position, size);
      if (p == null) continue;

      final t = (flash.age / SimulationConstants.flashDuration).clamp(0.0, 1.0);
      final alpha = math.exp(-SimulationConstants.flashExpDecay * t);
      final radius =
          SimulationConstants.flashInitialRadius +
          SimulationConstants.flashMaxRadius * t;

      final shader = RadialGradient(
        colors: [
          flash.color.withValues(
            alpha: SimulationConstants.flashInitialAlpha * alpha,
          ),
          flash.color.withValues(alpha: AppTypography.opacityTransparent),
        ],
      ).createShader(Rect.fromCircle(center: p, radius: radius));

      canvas.drawCircle(p, radius, Paint()..shader = shader);
    }
  }

  /// Draw debris particles from collisions
  static void drawDebrisParticles(
    Canvas canvas,
    Size size,
    vm.Matrix4 vp,
    List<CollisionParticle> particles,
  ) {
    for (final particle in particles) {
      final p = PainterUtils.project(vp, particle.position, size);
      if (p == null) continue;

      final paint = Paint()
        ..color = particle.color.withValues(alpha: particle.opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(p, particle.size, paint);

      // Draw glow for larger particles
      if (particle.size > RenderingConstants.particleGlowRadiusMultiplier) {
        final glowPaint = Paint()
          ..color = particle.color.withValues(
            alpha: particle.opacity * AppTypography.opacityFaint,
          )
          ..maskFilter = MaskFilter.blur(
            BlurStyle.normal,
            particle.size * RenderingConstants.particleGlowBlurMultiplier,
          );
        canvas.drawCircle(
          p,
          particle.size * RenderingConstants.particleGlowRadiusMultiplier,
          glowPaint,
        );
      }
    }
  }

  /// Draw shockwave rings from collisions
  static void drawShockwaves(
    Canvas canvas,
    Size size,
    vm.Matrix4 vp,
    List<Shockwave> shockwaves,
  ) {
    for (final shockwave in shockwaves) {
      final p = PainterUtils.project(vp, shockwave.position, size);
      if (p == null) continue;

      // Project radius to screen space (approximate)
      final radiusPoint =
          shockwave.position + vm.Vector3(shockwave.radius, 0, 0);
      final rp = PainterUtils.project(vp, radiusPoint, size);
      if (rp == null) continue;

      final screenRadius = (rp - p).distance;

      // Draw ring with gradient
      final ringPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = shockwave.thickness
        ..color = shockwave.color.withValues(alpha: shockwave.opacity);

      canvas.drawCircle(p, screenRadius, ringPaint);

      // Draw inner glow
      final glowPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = shockwave.thickness * 2
        ..color = shockwave.color.withValues(
          alpha: shockwave.opacity * AppTypography.opacityFaint,
        )
        ..maskFilter = MaskFilter.blur(
          BlurStyle.normal,
          shockwave.thickness * RenderingConstants.particleGlowBlurMultiplier,
        );

      canvas.drawCircle(p, screenRadius, glowPaint);
    }
  }

  /// Draw debris clouds (material ejection)
  static void drawDebrisClouds(
    Canvas canvas,
    Size size,
    vm.Matrix4 vp,
    List<DebrisCloud> clouds,
  ) {
    for (final cloud in clouds) {
      // Draw each particle in the cloud with softer appearance
      for (final particle in cloud.particles) {
        final p = PainterUtils.project(vp, particle.position, size);
        if (p == null) continue;

        // Softer, larger particles for cloud effect
        final cloudSize =
            particle.size * RenderingConstants.cloudParticleSizeMultiplier;
        final paint = Paint()
          ..color = particle.color.withValues(
            alpha: particle.opacity * AppTypography.opacityMedium,
          )
          ..maskFilter = MaskFilter.blur(
            BlurStyle.normal,
            cloudSize * AppTypography.opacityFaint,
          );

        canvas.drawCircle(p, cloudSize, paint);
      }

      // Optionally draw cloud center indicator for debugging
      // final center = PainterUtils.project(vp, cloud.centerOfMass, size);
      // if (center != null) {
      //   canvas.drawCircle(
      //     center,
      //     3,
      //     Paint()..color = cloud.baseColor.withValues(alpha: 0.5),
      //   );
      // }
    }
  }

  /// Draw plasma jets from massive star collisions
  static void drawPlasmaJets(
    Canvas canvas,
    Size size,
    vm.Matrix4 vp,
    List<PlasmaJet> jets,
  ) {
    for (final jet in jets) {
      final origin = PainterUtils.project(vp, jet.origin, size);
      if (origin == null) continue;

      // Draw jet particles as a stream
      final sortedParticles = jet.particles.toList()
        ..sort((a, b) {
          final distA = (a.position - jet.origin).length;
          final distB = (b.position - jet.origin).length;
          return distB.compareTo(distA); // Draw farthest first
        });

      for (int i = 0; i < sortedParticles.length; i++) {
        final particle = sortedParticles[i];
        final p = PainterUtils.project(vp, particle.position, size);
        if (p == null) continue;

        // Calculate intensity based on distance from origin
        final distance = (particle.position - jet.origin).length;
        final normalizedDist = (distance / jet.length).clamp(0.0, 1.0);
        final intensity = 1.0 - normalizedDist;

        // Draw particle with glow
        final particleColor = jet.temperatureAdjustedColor.withValues(
          alpha: particle.opacity * intensity,
        );

        // Core
        final corePaint = Paint()
          ..color = particleColor
          ..style = PaintingStyle.fill;
        canvas.drawCircle(p, particle.size, corePaint);

        // Glow
        final glowPaint = Paint()
          ..color = particleColor.withValues(alpha: particleColor.a * 0.4)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, particle.size);
        canvas.drawCircle(p, particle.size * 2, glowPaint);

        // Draw connecting line to previous particle for stream effect
        if (i > 0) {
          final prevParticle = sortedParticles[i - 1];
          final prevP = PainterUtils.project(vp, prevParticle.position, size);
          if (prevP != null) {
            final linePaint = Paint()
              ..color = particleColor.withValues(alpha: particleColor.a * 0.3)
              ..strokeWidth = particle.size * 0.5
              ..style = PaintingStyle.stroke;
            canvas.drawLine(prevP, p, linePaint);
          }
        }
      }
    }
  }

  /// Draw all collision effects
  static void drawAllCollisionEffects(
    Canvas canvas,
    Size size,
    vm.Matrix4 vp,
    physics.Simulation sim,
  ) {
    final effects = sim.collisionEffects;

    // Draw in layers for proper depth and blending
    // 1. Shockwaves (background layer)
    if (sim.appState?.ui.showCollisionShockwaves ?? false) {
      drawShockwaves(canvas, size, vp, effects.shockwaves);
    }

    // 2. Debris clouds (mid layer)
    if (sim.appState?.ui.showCollisionEjection ?? false) {
      drawDebrisClouds(canvas, size, vp, effects.debrisClouds);
    }

    // 3. Plasma jets (bright layer)
    if (sim.appState?.ui.showCollisionPlasmaJets ?? false) {
      drawPlasmaJets(canvas, size, vp, effects.plasmaJets);
    }

    // 4. Debris particles (top layer for crispness)
    if (sim.appState?.ui.showCollisionDebris ?? false) {
      drawDebrisParticles(canvas, size, vp, effects.debrisParticles);
    }

    // 5. Merge flashes (always on top)
    drawMergeFlashes(canvas, size, vp, sim);
  }
}
