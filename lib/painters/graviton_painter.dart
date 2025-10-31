import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:graviton/constants/rendering_constants.dart';
import 'package:graviton/constants/simulation_constants.dart';
import 'package:graviton/enums/celestial_body_name.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/painters/asteroid_belt_painter.dart';
import 'package:graviton/services/simulation.dart' as physics;
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/utils/painter_utils.dart';
import 'package:graviton/utils/star_generator.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

import 'background_painter.dart';
import 'celestial_body_painter.dart';
import 'effects_painter.dart';
import 'gravity_painter.dart';
import 'habitability_painter.dart';
import 'orbital_path_painter.dart';
import 'trail_painter.dart';

/// Custom painter for rendering the gravitational simulation
/// This painter orchestrates all the specialized painters to render the complete scene
class GravitonPainter extends CustomPainter {
  final physics.Simulation sim;
  final vm.Matrix4 view;
  final vm.Matrix4 proj;
  final List<StarData> stars;
  final bool showTrails;
  final bool useWarmTrails;
  final bool useRealisticColors;
  final bool showOrbitalPaths;
  final bool dualOrbitalPaths;
  final bool showHabitableZones;
  final bool showHabitabilityIndicators;
  final int? selectedBodyIndex;
  final bool followMode;
  final double cameraDistance;

  GravitonPainter({
    required this.sim,
    required this.view,
    required this.proj,
    required this.stars,
    required this.showTrails,
    required this.useWarmTrails,
    this.useRealisticColors = false,
    this.showOrbitalPaths = true,
    this.dualOrbitalPaths = false,
    this.showHabitableZones = false,
    this.showHabitabilityIndicators = false,
    this.selectedBodyIndex,
    this.followMode = false,
    required this.cameraDistance,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final vp = proj * view;

    // Draw spherical space background that wraps around the scene
    BackgroundPainter.drawSphericalSpaceBackground(canvas, size, vp, view, 42);

    // Draw enhanced starfield
    BackgroundPainter.drawEnhancedStarfield(canvas, vp, view, size, stars);

    // Draw distant galaxies in 3D space
    BackgroundPainter.drawDistantGalaxies(canvas, vp, view, size);

    // Draw merge flashes
    EffectsPainter.drawMergeFlashes(canvas, size, vp, sim);

    // Draw trails
    TrailPainter.drawTrails(
      canvas,
      size,
      vp,
      sim,
      showTrails,
      useWarmTrails,
      useRealisticColors,
    );

    // Draw orbital paths (predictive paths showing where bodies will go)
    OrbitalPathPainter.drawOrbitalPaths(
      canvas,
      size,
      vp,
      sim,
      showOrbitalPaths,
      dualMode: dualOrbitalPaths,
    );

    // Draw habitable zones (before bodies so they appear as background elements)
    HabitabilityPainter.drawHabitableZones(
      canvas,
      size,
      vp,
      view,
      sim,
      showHabitableZones,
    );

    // Draw gravity wells (before bodies as background elements)
    // Now controlled per-body via Body.showGravityWell property
    GravityPainter.drawGravityWells(
      canvas,
      size,
      vp,
      sim,
      cameraDistance,
      view,
    );

    // Draw asteroid belt particles (before bodies but after background elements)
    if (sim.currentScenario == ScenarioType.asteroidBelt) {
      // Original asteroid belt scenario
      AsteroidBeltPainter.drawAsteroidBelt(
        canvas,
        size,
        vp,
        sim.asteroidBelt,
        true,
      );
    } else if (sim.currentScenario == ScenarioType.solarSystem) {
      // Solar system with both belts
      AsteroidBeltPainter.drawAsteroidBelt(
        canvas,
        size,
        vp,
        sim.asteroidBelt,
        true,
      ); // Main asteroid belt
      AsteroidBeltPainter.drawAsteroidBelt(
        canvas,
        size,
        vp,
        sim.kuiperBelt,
        true,
      ); // Kuiper belt
    } else if (sim.currentScenario == ScenarioType.galaxyFormation) {
      // Galaxy formation with proper 3D galactic glow
      _drawGalactic3DGlow(canvas, size, vp, sim);

      AsteroidBeltPainter.drawAsteroidBelt(
        canvas,
        size,
        vp,
        sim.asteroidBelt,
        true,
      ); // Galactic disk
      AsteroidBeltPainter.drawAsteroidBelt(
        canvas,
        size,
        vp,
        sim.kuiperBelt,
        true,
      ); // Galactic halo
    }

    // Bodies (sorted back-to-front by eye-space z)
    final indices = List.generate(sim.bodies.length, (i) => i);
    indices.sort((a, b) {
      final za = PainterUtils.clipZ(vp, sim.bodies[a].position);
      final zb = PainterUtils.clipZ(vp, sim.bodies[b].position);
      return za.compareTo(zb);
    });

    for (final i in indices) {
      final b = sim.bodies[i];
      final p = PainterUtils.project(vp, b.position, size);
      if (p == null) continue;

      final eyeSpace =
          (view * vm.Vector4(b.position.x, b.position.y, b.position.z, 1));
      final dist = (-eyeSpace.z).abs().clamp(
        RenderingConstants.distanceClampMin,
        RenderingConstants.distanceClampMax,
      );
      final pr = (b.radius * RenderingConstants.bodySizeMultiplier / dist)
          .clamp(
            RenderingConstants.bodyMinSize,
            RenderingConstants.bodyMaxSize,
          );

      // Special visibility handling for black holes in solar system simulation
      double opacity = 1.0;
      bool shouldRenderBody = true;

      // Check if this is a black hole in any scenario that should have distance-based visibility
      final bodyEnum = CelestialBodyName.fromString(b.name);
      if (bodyEnum?.isBlackHole == true) {
        // Black hole visibility based on actual camera zoom level (cameraDistance)
        // Hide completely when camera distance > 550, start easing in from 550 down to 285
        const double hideDistance = 550.0;
        const double fullVisibleDistance = 285.0;

        if (cameraDistance > hideDistance) {
          shouldRenderBody = false;
        } else if (cameraDistance > fullVisibleDistance) {
          // Calculate opacity for smooth fade-in as we zoom closer (lower camera distance)
          final fadeRatio =
              (hideDistance - cameraDistance) /
              (hideDistance - fullVisibleDistance);
          opacity = (fadeRatio * fadeRatio * fadeRatio).clamp(
            0.0,
            1.0,
          ); // Smooth ease-in curve (cubic for smoother transition)

          // Only render if opacity is significant enough to be visible
          shouldRenderBody = opacity > 0.05;
        }
        // When cameraDistance <= fullVisibleDistance, opacity remains 1.0 (fully visible)
      }

      if (shouldRenderBody) {
        // Render the celestial body using the specialized painter with calculated opacity
        CelestialBodyPainter.drawBody(
          canvas,
          p,
          pr,
          b,
          viewMatrix: vp,
          canvasSize: size,
          opacity: opacity,
          useRealisticColors: useRealisticColors,
        );
      }

      // Draw habitability indicator for planets
      HabitabilityPainter.drawHabitabilityIndicator(
        canvas,
        p,
        pr,
        b,
        showHabitabilityIndicators,
      );

      // Draw selection/follow indicator
      if (selectedBodyIndex != null && selectedBodyIndex == i) {
        _drawSelectionIndicator(canvas, p, pr, followMode);
      }
    }

    // Draw photon rings AFTER all bodies are rendered (so they appear on top)
    if (sim.currentScenario == ScenarioType.galaxyFormation) {
      _drawPhotonRingAfterBodies(canvas, size, vp, sim, cameraDistance);
    }
  }

  /// Draw photon rings after bodies are rendered so they appear on top
  static void _drawPhotonRingAfterBodies(
    Canvas canvas,
    Size size,
    vm.Matrix4 vp,
    physics.Simulation sim,
    double cameraDistance,
  ) {
    // Find the galactic center (supermassive black hole - the most massive body at origin)
    final galacticCenter = sim.bodies
        .where(
          (b) => b.mass > SimulationConstants.stellarBlackHoleMassThreshold,
        )
        .firstOrNull;
    if (galacticCenter == null) return;

    // Project the galactic center position to screen coordinates
    final centerScreen = PainterUtils.project(
      vp,
      galacticCenter.position,
      size,
    );
    if (centerScreen == null) return; // Behind camera or outside view

    // Calculate distance for scaling
    final view = vp;
    final eyeSpace =
        (view *
        vm.Vector4(
          galacticCenter.position.x,
          galacticCenter.position.y,
          galacticCenter.position.z,
          1,
        ));

    final distance = (-eyeSpace.z).abs().clamp(
      RenderingConstants.distanceClampMin,
      RenderingConstants.distanceClampMax,
    );

    // Draw the photon ring on top of everything
    _drawPhotonRing(
      canvas,
      centerScreen,
      0.0,
      distance,
      cameraDistance,
    ); // glowRadius not needed anymore
  }

  /// Draw selection indicator around selected/followed body
  static void _drawSelectionIndicator(
    Canvas canvas,
    Offset center,
    double bodyRadius,
    bool isFollowMode,
  ) {
    final selectionRadius = bodyRadius * 2.5;

    if (isFollowMode) {
      // Follow mode: Bright animated ring to indicate active following
      final time = DateTime.now().millisecondsSinceEpoch / 1000.0;
      final pulseAlpha = (0.7 + 0.3 * math.sin(time * 3.0)).clamp(0.4, 1.0);
      final followPaint = Paint()
        ..color = AppColors.uiCyanAccent.withValues(alpha: pulseAlpha)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0;

      canvas.drawCircle(center, selectionRadius, followPaint);

      // Inner follow ring
      final innerFollowPaint = Paint()
        ..color = AppColors.uiCyan.withValues(
          alpha: pulseAlpha * AppTypography.opacityMediumHigh,
        )
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;

      canvas.drawCircle(center, selectionRadius * 0.7, innerFollowPaint);
    } else {
      // Selection mode: Steady ring to indicate selected but not following
      final selectionPaint = Paint()
        ..color = AppColors.uiWhite.withValues(
          alpha: AppTypography.opacityVeryHigh,
        )
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      canvas.drawCircle(center, selectionRadius, selectionPaint);

      // Dashed inner ring effect
      final innerPaint = Paint()
        ..color = AppColors.uiWhite.withValues(
          alpha: AppTypography.opacitySemiTransparent,
        )
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;

      canvas.drawCircle(center, selectionRadius * 0.8, innerPaint);
    }
  }

  /// Draw proper 3D galactic glow that scales with distance and projects correctly
  static void _drawGalactic3DGlow(
    Canvas canvas,
    Size size,
    vm.Matrix4 vp,
    physics.Simulation sim,
  ) {
    // Find the galactic center (supermassive black hole - the most massive body at origin)
    final galacticCenter = sim.bodies
        .where(
          (b) => b.mass > SimulationConstants.stellarBlackHoleMassThreshold,
        )
        .firstOrNull;
    if (galacticCenter == null) return;

    // Calculate distance-based scaling (same as particles)
    final view = vp;
    final eyeSpace =
        (view *
        vm.Vector4(
          galacticCenter.position.x,
          galacticCenter.position.y,
          galacticCenter.position.z,
          1,
        ));

    final distance = (-eyeSpace.z).abs().clamp(
      RenderingConstants.distanceClampMin,
      RenderingConstants.distanceClampMax,
    );

    // Scale glow based on distance - smooth transition between scaling modes
    final baseGlowSize =
        240.0; // Base size in 3D units representing actual galactic bulge size

    // Use smooth blended scaling instead of abrupt transition
    final transitionStart = 150.0;
    final transitionEnd = 250.0;

    final gentleScaleFactor = math.sqrt(
      RenderingConstants.bodySizeMultiplier / distance,
    );
    final aggressiveScaleFactor =
        RenderingConstants.bodySizeMultiplier / (distance * 1.5);

    // Smooth blend between the two scaling methods
    final scaleFactor = distance <= transitionStart
        ? gentleScaleFactor // Pure gentle scaling when close
        : distance >= transitionEnd
        ? aggressiveScaleFactor // Pure aggressive scaling when far
        : _blendScaling(
            gentleScaleFactor,
            aggressiveScaleFactor,
            distance,
            transitionStart,
            transitionEnd,
          );

    final glowRadius = (baseGlowSize * scaleFactor).clamp(
      10.0,
      size.width * 0.8,
    );

    // Ensure the glow becomes very small when far away but still visible when close
    final minRadius = 16.0;
    final maxRadius = math.min(size.width, size.height) * 0.8;
    final finalGlowRadius = glowRadius.clamp(minRadius, maxRadius);

    // Calculate distance-based alpha multiplier - MORE visible when zoomed out far to see galactic structure
    // Inverse relationship: when far away (large distance), make it more visible
    final distanceAlphaMultiplier = (400.0 / distance).clamp(0.3, 2.5);

    // GALAXY-WIDE: Massive bluish/purple galactic disk glow spanning entire galaxy
    // Scale up the galaxy size more aggressively when far away for better visibility
    final galaxySizeMultiplier = distance > 200.0 ? 1.5 : 1.0;
    final galaxyRadius =
        finalGlowRadius *
        10.0 *
        galaxySizeMultiplier; // Much larger to span entire galaxy
    final galaxyHeight =
        galaxyRadius *
        0.25; // Very flattened for realistic galactic disk appearance

    _drawGalactic3DDisk(
      canvas,
      size,
      vp,
      galacticCenter.position,
      galaxyRadius,
      galaxyHeight,
      [
        AppColors.withAlpha(
          AppColors.galaxySlateBlue,
          AppColors.alphaSemiVisible * distanceAlphaMultiplier,
        ),
        AppColors.withAlpha(
          AppColors.galaxyDarkSlateBlue,
          AppColors.alphaMediumHigh * distanceAlphaMultiplier,
        ),
        AppColors.withAlpha(
          AppColors.galaxyRoyalBlue,
          AppColors.alphaMedium * distanceAlphaMultiplier,
        ),
        AppColors.withAlpha(
          AppColors.galaxyPureBlue,
          AppColors.alphaLowMedium * distanceAlphaMultiplier,
        ),
        AppColors.withAlpha(
          AppColors.galaxyIndigo,
          AppColors.alphaLow * distanceAlphaMultiplier,
        ),
        AppColors.withAlpha(
          AppColors.galaxyIndigo,
          AppColors.alphaFaint2 * distanceAlphaMultiplier,
        ),
        AppColors.withAlpha(
          AppColors.galaxyIndigo,
          AppColors.alphaVeryFaint2 * distanceAlphaMultiplier,
        ),
        AppColors.withAlpha(
          AppColors.galaxyIndigo,
          AppColors.alphaAlmostInvisible * distanceAlphaMultiplier,
        ),
        AppColors.withAlpha(
          AppColors.galaxyIndigo,
          AppColors.alphaExtremelyFaint * distanceAlphaMultiplier,
        ),
        AppColors.withAlpha(
          AppColors.galaxyIndigo,
          AppColors.alphaVeryFaint * distanceAlphaMultiplier,
        ),
        AppColors.withAlpha(
          AppColors.galaxyIndigo,
          0.001 * distanceAlphaMultiplier,
        ), // Nearly transparent
        AppColors.withAlpha(
          AppColors.galaxyIndigo,
          0.0,
        ), // Fully transparent edge
      ],
      const [
        0.0,
        0.15,
        0.3,
        0.45,
        0.6,
        0.72,
        0.82,
        0.90,
        0.95,
        0.98,
        0.995,
        1.0,
      ],
    );

    // LARGEST: Galactic bulge - massive diffuse stellar halo with very soft edges
    final bulgeRadius =
        finalGlowRadius *
        3.0 *
        galaxySizeMultiplier; // Much bigger - 3x and larger when far away
    final bulgeHeight =
        bulgeRadius *
        0.3; // Squashed height - 30% of width for disk-like appearance

    _drawGalactic3DDisk(
      canvas,
      size,
      vp,
      galacticCenter.position,
      bulgeRadius,
      bulgeHeight,
      [
        AppColors.withAlpha(
          AppColors.accretionMoccasin,
          AppColors.alphaMoreVisible * distanceAlphaMultiplier,
        ), // Moccasin center - much brighter
        AppColors.withAlpha(
          AppColors.accretionPlum,
          AppColors.alphaSemiVisible * distanceAlphaMultiplier,
        ), // Plum middle - much brighter
        AppColors.withAlpha(
          AppColors.accretionMediumPurple,
          AppColors.alphaMedium * distanceAlphaMultiplier,
        ), // Medium purple - much brighter
        AppColors.withAlpha(
          AppColors.galaxyIndigo,
          AppColors.alphaMediumFaint * distanceAlphaMultiplier,
        ), // Indigo outer
        AppColors.withAlpha(
          AppColors.galaxyIndigo,
          AppColors.alphaVeryFaint4 * distanceAlphaMultiplier,
        ), // Very faint outer
        AppColors.withAlpha(
          AppColors.galaxyIndigo,
          AppColors.alphaExtremelyFaint * distanceAlphaMultiplier,
        ), // Extremely faint
        AppColors.withAlpha(
          AppColors.galaxyIndigo,
          AppColors.alphaVeryFaint * distanceAlphaMultiplier,
        ), // Almost invisible
        AppColors.withAlpha(
          AppColors.galaxyIndigo,
          AppColors.alphaAlmostInvisible * distanceAlphaMultiplier,
        ), // Nearly invisible
        AppColors.withAlpha(
          AppColors.galaxyIndigo,
          0.002 * distanceAlphaMultiplier,
        ), // Barely visible
        AppColors.withAlpha(AppColors.galaxyIndigo, 0.0), // Transparent edge
      ],
      const [0.0, 0.2, 0.4, 0.6, 0.75, 0.85, 0.92, 0.96, 0.99, 1.0],
    );

    // LARGE: Outer red radiating energy layer with much softer edges
    final outerRadius =
        finalGlowRadius * galaxySizeMultiplier; // Larger when far away
    final outerHeight =
        outerRadius *
        0.4; // Squashed height - 40% of width for disk-like appearance

    _drawGalactic3DDisk(
      canvas,
      size,
      vp,
      galacticCenter.position,
      outerRadius,
      outerHeight,
      [
        AppColors.withAlpha(
          AppColors.accretionOrangeRed,
          AppColors.alphaQuarter * distanceAlphaMultiplier,
        ), // Orange-red center - brighter
        AppColors.withAlpha(
          AppColors.accretionTomato,
          AppColors.alphaVisible * distanceAlphaMultiplier,
        ), // Tomato middle - brighter
        AppColors.withAlpha(
          AppColors.accretionRed,
          AppColors.alphaLowMedium * distanceAlphaMultiplier,
        ), // Red outer - brighter
        AppColors.withAlpha(
          AppColors.accretionRed,
          AppColors.alphaFaint3 * distanceAlphaMultiplier,
        ), // Faint red
        AppColors.withAlpha(
          AppColors.accretionRed,
          AppColors.alphaFaint * distanceAlphaMultiplier,
        ), // Very faint red
        AppColors.withAlpha(
          AppColors.accretionRed,
          AppColors.alphaVeryFaint * distanceAlphaMultiplier,
        ), // Almost invisible red
        AppColors.withAlpha(
          AppColors.accretionRed,
          0.003 * distanceAlphaMultiplier,
        ), // Barely visible red
        AppColors.withAlpha(
          AppColors.accretionRed,
          0.001 * distanceAlphaMultiplier,
        ), // Nearly transparent red
        AppColors.withAlpha(AppColors.accretionRed, 0.0), // Transparent edge
      ],
      const [0.0, 0.25, 0.5, 0.7, 0.82, 0.90, 0.95, 0.98, 1.0],
    );

    // Middle golden galactic bulge layer with ultra-soft edges - SLIGHTLY DIMMED
    final middleRadius =
        finalGlowRadius * 0.65 * galaxySizeMultiplier; // Larger when far away
    final middleHeight =
        middleRadius *
        0.5; // Squashed height - 50% of width for disk-like appearance

    // Slight dimming for middle layer to reduce center brightness
    final middleDimMultiplier = 0.7; // Reduce middle brightness by 30%

    _drawGalactic3DDisk(
      canvas,
      size,
      vp,
      galacticCenter.position,
      middleRadius,
      middleHeight,
      [
        AppColors.withAlpha(
          AppColors.accretionGold,
          AppColors.alphaSemiTransparent *
              distanceAlphaMultiplier *
              middleDimMultiplier,
        ), // Dimmed gold center
        AppColors.withAlpha(
          AppColors.accretionOrange,
          AppColors.alphaMediumVisible *
              distanceAlphaMultiplier *
              middleDimMultiplier,
        ), // Dimmed orange middle
        AppColors.withAlpha(
          AppColors.accretionDarkOrange,
          AppColors.alphaVisible * distanceAlphaMultiplier,
        ), // Normal dark orange outer
        AppColors.withAlpha(
          AppColors.accretionDarkOrange,
          AppColors.alphaMediumFaint * distanceAlphaMultiplier,
        ), // Faint orange
        AppColors.withAlpha(
          AppColors.accretionDarkOrange,
          AppColors.alphaVeryFaint4 * distanceAlphaMultiplier,
        ), // Very faint orange
        AppColors.withAlpha(
          AppColors.accretionDarkOrange,
          AppColors.alphaExtremelyFaint * distanceAlphaMultiplier,
        ), // Almost invisible
        AppColors.withAlpha(
          AppColors.accretionDarkOrange,
          AppColors.alphaAlmostInvisible * distanceAlphaMultiplier,
        ), // Nearly invisible
        AppColors.withAlpha(
          AppColors.accretionDarkOrange,
          0.002 * distanceAlphaMultiplier,
        ), // Barely visible
        AppColors.withAlpha(
          AppColors.accretionDarkOrange,
          0.0,
        ), // Transparent edge
      ],
      const [0.0, 0.2, 0.45, 0.7, 0.82, 0.90, 0.95, 0.98, 1.0],
    );

    // Inner bright accretion disk core with very soft edges - TONED DOWN for better star visibility
    final innerRadius =
        finalGlowRadius * 0.3 * galaxySizeMultiplier; // Larger when far away
    final innerHeight =
        innerRadius *
        0.6; // Squashed height - 60% of width for disk-like appearance

    // Create a dimmer multiplier for the center to not overpower star trails
    final centerDimMultiplier = 0.4; // Reduce center brightness by 60%

    _drawGalactic3DDisk(
      canvas,
      size,
      vp,
      galacticCenter.position,
      innerRadius,
      innerHeight,
      [
        AppColors.withAlpha(
          AppColors.accretionGold,
          AppColors.alphaSemiVisible *
              distanceAlphaMultiplier *
              centerDimMultiplier,
        ), // Dimmed gold center instead of white
        AppColors.withAlpha(
          AppColors.accretionOrange,
          AppColors.alphaMediumVisible *
              distanceAlphaMultiplier *
              centerDimMultiplier,
        ), // Dimmed orange instead of gold
        AppColors.withAlpha(
          AppColors.accretionDarkOrange,
          AppColors.alphaVisible *
              distanceAlphaMultiplier *
              centerDimMultiplier,
        ), // Dimmed dark orange
        AppColors.withAlpha(
          AppColors.accretionOrange,
          AppColors.alphaSemiVisible * distanceAlphaMultiplier,
        ), // Faint orange
        AppColors.withAlpha(
          AppColors.accretionOrange,
          AppColors.alphaMediumFaint * distanceAlphaMultiplier,
        ), // Very faint orange
        AppColors.withAlpha(
          AppColors.accretionOrange,
          AppColors.alphaVeryFaint4 * distanceAlphaMultiplier,
        ), // Almost invisible
        AppColors.withAlpha(
          AppColors.accretionOrange,
          AppColors.alphaExtremelyFaint * distanceAlphaMultiplier,
        ), // Nearly invisible
        AppColors.withAlpha(
          AppColors.accretionOrange,
          0.003 * distanceAlphaMultiplier,
        ), // Barely visible
        AppColors.withAlpha(
          AppColors.accretionOrange,
          0.001 * distanceAlphaMultiplier,
        ), // Nearly transparent
        AppColors.withAlpha(AppColors.accretionOrange, 0.0), // Transparent edge
      ],
      const [0.0, 0.1, 0.3, 0.6, 0.75, 0.85, 0.92, 0.96, 0.99, 1.0],
    );
  }

  /// Draw a 3D galactic disk that properly rotates with camera perspective
  /// Similar to Saturn's rings but for galactic structures
  static void _drawGalactic3DDisk(
    Canvas canvas,
    Size size,
    vm.Matrix4 vp,
    vm.Vector3 centerPosition,
    double diskRadius,
    double diskHeight,
    List<Color> gradientColors,
    List<double> gradientStops,
  ) {
    // Create multiple concentric disks with decreasing opacity for soft edges
    const int numRings = 8; // Number of concentric rings

    for (int ring = 0; ring < numRings; ring++) {
      final ringProgress = ring / (numRings - 1); // 0.0 to 1.0
      final currentRadius =
          diskRadius *
          (0.3 + 0.7 * ringProgress); // Start from 30% and go to 100%

      // Calculate opacity based on ring progress
      final opacityMultiplier = math.pow(
        1.0 - ringProgress,
        2.5,
      ); // Exponential fade-out

      const int numSegments = 32; // Fewer segments per ring for performance
      final points = <Offset>[];

      // Generate points around the current ring
      for (int i = 0; i <= numSegments; i++) {
        final angle = (i / numSegments) * 2 * math.pi;

        // Galaxy formation uses XY plane (vertical) to match asteroid belt particles
        // Create disk in XY plane like the asteroid belt particles
        final localX = currentRadius * math.cos(angle);
        final localY = currentRadius * math.sin(angle);
        final localZ = 0.0; // Disk is flat in XY plane

        // Transform to world space
        final worldPos = vm.Vector3(
          centerPosition.x + localX,
          centerPosition.y + localY,
          centerPosition.z + localZ,
        );

        // Project to screen space
        final screenPos = PainterUtils.project(vp, worldPos, size);
        if (screenPos != null) {
          points.add(screenPos);
        }
      }

      // If we have enough points, draw the ring
      if (points.length > 3) {
        // Find the center point for the gradient
        var centerX = 0.0;
        var centerY = 0.0;
        for (final point in points) {
          centerX += point.dx;
          centerY += point.dy;
        }
        centerX /= points.length;
        centerY /= points.length;
        final centerScreen = Offset(centerX, centerY);

        // Calculate the bounding box for the gradient
        var minX = double.infinity;
        var maxX = double.negativeInfinity;
        var minY = double.infinity;
        var maxY = double.negativeInfinity;

        for (final point in points) {
          if (point.dx < minX) minX = point.dx;
          if (point.dx > maxX) maxX = point.dx;
          if (point.dy < minY) minY = point.dy;
          if (point.dy > maxY) maxY = point.dy;
        }

        final width = maxX - minX;
        final height = maxY - minY;
        final gradientRadius = math.max(width, height) / 2;

        // Select appropriate colors based on ring position
        final colorIndex = (ringProgress * (gradientColors.length - 1)).floor();
        final nextColorIndex = math.min(
          colorIndex + 1,
          gradientColors.length - 1,
        );
        final localProgress =
            (ringProgress * (gradientColors.length - 1)) - colorIndex;

        // Interpolate between colors
        final baseColor = gradientColors[colorIndex];
        final nextColor = gradientColors[nextColorIndex];

        final ringColor =
            Color.lerp(baseColor, nextColor, localProgress) ?? baseColor;
        final finalColor = ringColor.withValues(
          alpha: ringColor.a * opacityMultiplier,
        );

        // Create a simple radial gradient for this ring
        final paint = Paint()
          ..style = PaintingStyle.fill
          ..shader =
              RadialGradient(
                center: Alignment.center,
                radius: 1.0,
                colors: [
                  finalColor,
                  finalColor.withValues(
                    alpha: finalColor.a * AppTypography.opacityHigh,
                  ),
                  finalColor.withValues(
                    alpha: finalColor.a * AppTypography.opacityFaint,
                  ),
                  finalColor.withValues(
                    alpha: AppTypography.opacityTransparent,
                  ),
                ],
                stops: const [0.0, 0.4, 0.7, 1.0],
              ).createShader(
                Rect.fromCenter(
                  center: centerScreen,
                  width: gradientRadius * 2,
                  height: gradientRadius * 2,
                ),
              );

        // Create path from projected points
        final path = Path();
        path.moveTo(points[0].dx, points[0].dy);
        for (int i = 1; i < points.length; i++) {
          path.lineTo(points[i].dx, points[i].dy);
        }
        path.close();

        // Draw the ring
        canvas.drawPath(path, paint);
      }
    }
  }

  /// Smoothly blend between two scaling factors to avoid abrupt transitions
  static double _blendScaling(
    double gentleFactor,
    double aggressiveFactor,
    double distance,
    double transitionStart,
    double transitionEnd,
  ) {
    // Calculate blend ratio (0.0 = pure gentle, 1.0 = pure aggressive)
    final blendRatio =
        ((distance - transitionStart) / (transitionEnd - transitionStart))
            .clamp(0.0, 1.0);

    // Use smooth interpolation (ease-in-out curve) for natural transition
    final smoothRatio = blendRatio * blendRatio * (3.0 - 2.0 * blendRatio);

    // Blend the two scaling factors
    return gentleFactor * (1.0 - smoothRatio) + aggressiveFactor * smoothRatio;
  }

  /// Draw the photon ring - brilliant thin ring of light around the black hole event horizon
  /// Only visible when zoomed in very close to the black hole
  static void _drawPhotonRing(
    Canvas canvas,
    Offset center,
    double glowRadius,
    double distance,
    double cameraDistance,
  ) {
    // First, calculate the actual black hole visual size using same system as particles
    final blackHoleVisualRadius =
        (2.5 * RenderingConstants.bodySizeMultiplier / distance).clamp(
          RenderingConstants.bodyMinSize,
          RenderingConstants.bodyMaxSize,
        );

    // Photon ring radius - make it larger for better visibility
    // In real physics, photon rings are at ~2.6x the Schwarzschild radius
    final schwarzschildRadius =
        blackHoleVisualRadius * 0.6; // Larger photon ring radius

    // Photon ring visibility based on camera distance with smooth easing
    // Start appearing at 100, fully visible at 50
    const double startFadeDistance = 100.0;
    const double fullVisibleDistance = 50.0;

    double ringOpacity = 1.0;

    if (cameraDistance > startFadeDistance) {
      ringOpacity = 0.0; // Too far away to see photon ring
    } else if (cameraDistance > fullVisibleDistance) {
      // Calculate opacity for smooth fade-in as we zoom closer
      final fadeRatio =
          (startFadeDistance - cameraDistance) /
          (startFadeDistance - fullVisibleDistance);
      ringOpacity = (fadeRatio * fadeRatio * fadeRatio).clamp(
        0.0,
        1.0,
      ); // Cubic easing
    }

    // Apply size-based fade as well for very small rings
    if (schwarzschildRadius < 8.0) {
      final sizeFade = (schwarzschildRadius / 8.0).clamp(0.0, 1.0);
      ringOpacity *= sizeFade; // Combine with distance-based opacity
    }

    // Don't render if opacity is too low to be visible
    if (ringOpacity < 0.01) {
      return;
    }

    // Ring should be much wider and more prominent
    final ringWidth = math.max(3.0, schwarzschildRadius * 0.35).clamp(3.0, 6.0);

    // Try multiple approaches to make the ring visible against galactic glow

    // Use canvas save/restore with global alpha for smoother blending
    canvas.save();

    // Apply global opacity - this affects all subsequent drawing operations
    final alphaLayer = Paint()
      ..color = AppColors.uiWhite.withValues(alpha: ringOpacity);
    canvas.saveLayer(null, alphaLayer);

    // First, draw a bright orange/red base ring (warmer colors show better)
    final basePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = ringWidth
      ..color = AppColors.gravitonOrangeRed
      ..blendMode = BlendMode.lighten; // Use lighten to cut through background

    canvas.drawCircle(center, schwarzschildRadius, basePaint);

    // Then add a bright gold layer on top
    final goldPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = ringWidth * 0.7
      ..color = AppColors.gravitonGold
      ..blendMode = BlendMode.plus; // Additive blending

    canvas.drawCircle(center, schwarzschildRadius, goldPaint);

    // Finally, add a bright white core for maximum visibility
    final corePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = ringWidth * 0.3
      ..color = AppColors.uiWhite
      ..blendMode = BlendMode.plus;

    canvas.drawCircle(center, schwarzschildRadius, corePaint);

    canvas.restore(); // Restore the alpha layer
    canvas.restore(); // Restore the saved state
  }

  @override
  bool shouldRepaint(covariant GravitonPainter oldDelegate) {
    return cameraDistance != oldDelegate.cameraDistance ||
        sim != oldDelegate.sim ||
        view != oldDelegate.view ||
        proj != oldDelegate.proj ||
        stars != oldDelegate.stars ||
        showTrails != oldDelegate.showTrails ||
        useWarmTrails != oldDelegate.useWarmTrails ||
        useRealisticColors != oldDelegate.useRealisticColors ||
        showOrbitalPaths != oldDelegate.showOrbitalPaths ||
        dualOrbitalPaths != oldDelegate.dualOrbitalPaths ||
        showHabitableZones != oldDelegate.showHabitableZones ||
        showHabitabilityIndicators != oldDelegate.showHabitabilityIndicators ||
        selectedBodyIndex != oldDelegate.selectedBodyIndex ||
        followMode != oldDelegate.followMode;
  }
}
