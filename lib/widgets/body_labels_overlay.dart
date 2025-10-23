import 'package:flutter/material.dart';
import 'package:graviton/constants/rendering_constants.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// Overlay widget that displays labels for celestial bodies
class BodyLabelsOverlay extends StatelessWidget {
  final List<Body> bodies;
  final vm.Matrix4 viewMatrix;
  final vm.Matrix4 projMatrix;
  final Size screenSize;
  final AppLocalizations? l10n;

  const BodyLabelsOverlay({
    super.key,
    required this.bodies,
    required this.viewMatrix,
    required this.projMatrix,
    required this.screenSize,
    this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BodyLabelsPainter(
        bodies: bodies,
        viewMatrix: viewMatrix,
        projMatrix: projMatrix,
        l10n: l10n,
      ),
      size: screenSize,
    );
  }
}

class _BodyLabelsPainter extends CustomPainter {
  final List<Body> bodies;
  final vm.Matrix4 viewMatrix;
  final vm.Matrix4 projMatrix;
  final AppLocalizations? l10n;

  _BodyLabelsPainter({
    required this.bodies,
    required this.viewMatrix,
    required this.projMatrix,
    this.l10n,
  });

  /// Translate a stored body name to the current localized name
  String _getLocalizedBodyName(String storedName) {
    if (l10n == null) return storedName;

    // Map stored English names to localized names
    switch (storedName) {
      case 'Alpha':
        return l10n!.bodyAlpha;
      case 'Beta':
        return l10n!.bodyBeta;
      case 'Gamma':
        return l10n!.bodyGamma;
      case 'Rocky Planet':
        return l10n!.bodyRockyPlanet;
      case 'Sun':
        return l10n!.bodySun;
      case 'Earth':
        return l10n!.bodyEarth;
      case 'Moon':
        return l10n!.bodyMoon;
      case 'Star A':
        return l10n!.bodyStarA;
      case 'Star B':
        return l10n!.bodyStarB;
      case 'Planet P':
        return l10n!.bodyPlanetP;
      case 'Moon M':
        return l10n!.bodyMoonM;
      case 'Central Star':
        return l10n!.bodyCentralStar;
      case 'Black Hole':
        return l10n!.bodyBlackHole;
      case 'Ringed Planet':
        return l10n!.bodyRingedPlanet;
      case 'Mercury':
        return l10n!.bodyMercury;
      case 'Venus':
        return l10n!.bodyVenus;
      case 'Mars':
        return l10n!.bodyMars;
      case 'Jupiter':
        return l10n!.bodyJupiter;
      case 'Saturn':
        return l10n!.bodySaturn;
      case 'Uranus':
        return l10n!.bodyUranus;
      case 'Neptune':
        return l10n!.bodyNeptune;
      default:
        // Handle numbered bodies like "Asteroid 1", "Star 2", "Ring 3"
        if (storedName.startsWith('Asteroid ')) {
          final number = storedName.substring(9);
          final numInt = int.tryParse(number);
          if (numInt != null) {
            return l10n!.bodyAsteroid(numInt);
          }
        } else if (storedName.startsWith('Star ')) {
          final number = storedName.substring(5);
          final numInt = int.tryParse(number);
          if (numInt != null) {
            return l10n!.bodyStar(numInt);
          }
        } else if (storedName.startsWith('Ring ')) {
          final number = storedName.substring(5);
          final numInt = int.tryParse(number);
          if (numInt != null) {
            return l10n!.bodyRing(numInt);
          }
        }

        return storedName; // Fallback to original name
    }
  }

  /// Project 3D world position to 2D screen coordinates
  Offset? _project(vm.Vector3 worldPos, Size size) {
    final viewPos = viewMatrix.transformed3(worldPos);
    if (viewPos.z > -RenderingConstants.projectionClipZThreshold) {
      return null; // Behind camera
    }

    final clipPos = projMatrix.transformed3(viewPos);
    if (clipPos.z.abs() < RenderingConstants.projectionClipZThreshold) {
      return null; // Too close to camera
    }

    final ndc = clipPos / clipPos.z;
    if (ndc.x.abs() > 2.0 || ndc.y.abs() > 2.0) {
      return null; // Outside view frustum
    }

    final screenX =
        (ndc.x * RenderingConstants.ndcTransformOffset +
            RenderingConstants.ndcTransformOffset) *
        size.width;

    final screenY =
        (-ndc.y * RenderingConstants.ndcTransformOffset +
            RenderingConstants.ndcTransformOffset) *
        size.height;

    return Offset(screenX, screenY);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final textStyle = TextStyle(
      color: AppColors.uiWhite.withValues(
        alpha: AppTypography.opacityNearlyOpaque,
      ),
      fontSize: AppTypography.fontSizeSmall,
      fontWeight: FontWeight.w500,
      shadows: AppTypography.createTextShadow(
        color: AppColors.uiBlack,
        opacity: AppTypography.opacityVeryHigh,
      ),
    );

    for (int i = 0; i < bodies.length; i++) {
      final body = bodies[i];
      final screenPos = _project(body.position, size);

      if (screenPos == null) continue;

      // Offset label position slightly to avoid overlapping with the body
      final labelOffset = Offset(
        screenPos.dx + 15, // Offset to the right
        screenPos.dy - 10, // Offset upward
      );

      // Get the localized name for the body
      final localizedName = _getLocalizedBodyName(body.name);

      // Create text painter
      final textPainter = TextPainter(
        text: TextSpan(text: localizedName, style: textStyle),
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();

      // Draw background box for better readability
      final backgroundRect = Rect.fromLTWH(
        labelOffset.dx - 3,
        labelOffset.dy - 2,
        textPainter.width + 6,
        textPainter.height + 4,
      );

      final backgroundPaint = Paint()
        ..color = AppColors.uiBlack.withValues(
          alpha: AppTypography.opacityMediumHigh,
        )
        ..style = PaintingStyle.fill;

      canvas.drawRRect(
        RRect.fromRectAndRadius(backgroundRect, const Radius.circular(3)),
        backgroundPaint,
      );

      // Draw the text
      textPainter.paint(canvas, labelOffset);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Always repaint since bodies are moving
  }
}
