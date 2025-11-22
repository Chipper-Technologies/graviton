import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/enums/ui_action.dart';
import 'package:graviton/enums/ui_element.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/models/indicator_data.dart';
import 'package:graviton/painters/indicator_painter.dart';
import 'package:graviton/services/firebase_service.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/widgets/haptics/haptic_gesture_detector.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// Overlay that shows arrows pointing to off-screen bodies
class OffScreenIndicatorsOverlay extends StatelessWidget {
  final List<Body> bodies;
  final vm.Matrix4 viewMatrix;
  final vm.Matrix4 projMatrix;
  final Size screenSize;
  final int? selectedBodyIndex;
  final Function(int bodyIndex)? onIndicatorTapped;

  const OffScreenIndicatorsOverlay({
    super.key,
    required this.bodies,
    required this.viewMatrix,
    required this.projMatrix,
    required this.screenSize,
    this.selectedBodyIndex,
    this.onIndicatorTapped,
  });

  @override
  Widget build(BuildContext context) {
    final indicators = _calculateIndicators();

    return SizedBox.expand(
      child: Stack(
        children: indicators.map((indicator) {
          return Positioned(
            left: indicator.position.dx - 20, // 20 = tap area radius
            top: indicator.position.dy - 20,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: HapticGestureDetector(
                onTap: () {
                  FirebaseService.instance.logUIEventWithEnums(
                    UIAction.tap,
                    element: UIElement.body,
                    value: 'offscreen_indicator_${indicator.bodyIndex}',
                  );
                  onIndicatorTapped?.call(indicator.bodyIndex);
                },
                child: Container(
                  width: 40, // 20 radius * 2
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.transparentColor,
                  ),
                  child: CustomPaint(
                    painter: IndicatorPainter(
                      indicator: indicator,
                      isSelected: indicator.bodyIndex == selectedBodyIndex,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  List<IndicatorData> _calculateIndicators() {
    final indicators = <IndicatorData>[];
    final mvp = projMatrix * viewMatrix;

    for (int i = 0; i < bodies.length; i++) {
      final body = bodies[i];
      final homogeneousPos = vm.Vector4(
        body.position.x,
        body.position.y,
        body.position.z,
        1.0,
      );
      final clipPos = mvp * homogeneousPos;

      // Skip if behind camera
      if (clipPos.w <= 0) continue;

      // Convert to normalized device coordinates
      final ndc = vm.Vector3(
        clipPos.x / clipPos.w,
        clipPos.y / clipPos.w,
        clipPos.z / clipPos.w,
      );

      // Convert to screen coordinates
      final screenX = (ndc.x + 1) * 0.5 * screenSize.width;
      final screenY = (1 - ndc.y) * 0.5 * screenSize.height;

      // Check if object is off-screen
      final isOffScreen =
          screenX < 0 ||
          screenX > screenSize.width ||
          screenY < 0 ||
          screenY > screenSize.height ||
          ndc.z > 1.0; // Too far away

      if (isOffScreen) {
        // Skip showing individual planets if they have off-screen moons
        if (_shouldSkipPlanetWithMoon(body, i)) {
          continue;
        }

        final indicatorPosition = _calculateIndicatorPosition(
          screenX,
          screenY,
          screenSize,
        );

        final direction = _calculateDirection(screenX, screenY, screenSize);

        indicators.add(
          IndicatorData(
            bodyIndex: i,
            body: body,
            position: indicatorPosition,
            direction: direction,
          ),
        );
      }
    }

    return indicators;
  }

  Offset _calculateIndicatorPosition(
    double worldScreenX,
    double worldScreenY,
    Size size,
  ) {
    // Calculate direction to off-screen object
    final centerX = size.width * 0.5;
    final centerY = size.height * 0.5;

    final dirX = worldScreenX - centerX;
    final dirY = worldScreenY - centerY;
    final distance = math.sqrt(dirX * dirX + dirY * dirY);

    if (distance == 0) return Offset(centerX, centerY);

    // Normalize direction
    final normalizedX = dirX / distance;
    final normalizedY = dirY / distance;

    // Calculate position on screen edge
    final margin = 40.0;
    final maxX = size.width - margin;
    final maxY = size.height - margin;

    // Find intersection with screen bounds
    double indicatorX, indicatorY;

    // Calculate where the direction vector hits the screen bounds
    final tX = normalizedX > 0
        ? (maxX - centerX) / normalizedX
        : (margin - centerX) / normalizedX;
    final tY = normalizedY > 0
        ? (maxY - centerY) / normalizedY
        : (margin - centerY) / normalizedY;

    final t = math.min(tX.abs(), tY.abs());

    indicatorX = centerX + normalizedX * t;
    indicatorY = centerY + normalizedY * t;

    // Clamp to screen bounds
    indicatorX = indicatorX.clamp(margin, size.width - margin);
    indicatorY = indicatorY.clamp(margin, size.height - margin);

    return Offset(indicatorX, indicatorY);
  }

  vm.Vector2 _calculateDirection(
    double worldScreenX,
    double worldScreenY,
    Size size,
  ) {
    final centerX = size.width * 0.5;
    final centerY = size.height * 0.5;

    final dirX = worldScreenX - centerX;
    final dirY = worldScreenY - centerY;
    final distance = math.sqrt(dirX * dirX + dirY * dirY);

    if (distance == 0) return vm.Vector2(1.0, 0.0);

    return vm.Vector2(dirX / distance, dirY / distance);
  }

  /// Check if a planet should be skipped because it has an off-screen moon
  bool _shouldSkipPlanetWithMoon(Body body, int bodyIndex) {
    if (body.bodyType != BodyType.planet) return false;

    final mvp = projMatrix * viewMatrix;

    // Check if this planet has any moons that are also off-screen
    for (int i = 0; i < bodies.length; i++) {
      if (i == bodyIndex) continue; // Skip self

      final otherBody = bodies[i];
      if (otherBody.bodyType == BodyType.moon) {
        final parentPlanet = _findParentPlanet(otherBody);
        if (parentPlanet == body) {
          // This moon belongs to the current planet, check if moon is off-screen
          final moonHomogeneousPos = vm.Vector4(
            otherBody.position.x,
            otherBody.position.y,
            otherBody.position.z,
            1.0,
          );
          final moonClipPos = mvp * moonHomogeneousPos;

          // Skip if moon is behind camera
          if (moonClipPos.w <= 0) continue;

          // Convert to normalized device coordinates
          final moonNdc = vm.Vector3(
            moonClipPos.x / moonClipPos.w,
            moonClipPos.y / moonClipPos.w,
            moonClipPos.z / moonClipPos.w,
          );

          // Convert to screen coordinates
          final moonScreenX = (moonNdc.x + 1) * 0.5 * screenSize.width;
          final moonScreenY = (1 - moonNdc.y) * 0.5 * screenSize.height;

          // Check if moon is off-screen
          final moonIsOffScreen =
              moonScreenX < 0 ||
              moonScreenX > screenSize.width ||
              moonScreenY < 0 ||
              moonScreenY > screenSize.height ||
              moonNdc.z > 1.0;

          if (moonIsOffScreen) {
            return true; // Skip the planet since its moon is off-screen
          }
        }
      }
    }

    return false; // Don't skip this planet
  }

  /// Find the planet that this moon most likely orbits
  Body? _findParentPlanet(Body moon) {
    if (bodies.isEmpty) return null;

    Body? closestPlanet;
    double minDistance = double.infinity;

    // Find the closest planet to this moon
    for (final body in bodies) {
      if (body.bodyType == BodyType.planet) {
        final distance = (moon.position - body.position).length;
        if (distance < minDistance) {
          minDistance = distance;
          closestPlanet = body;
        }
      }
    }

    return closestPlanet;
  }
}
