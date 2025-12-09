import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/services/ui/semantic_focus_service.dart';
import 'package:graviton/utils/number_utils.dart';

/// Semantic wrapper for camera control buttons with proper focus management
class SemanticCameraControls extends StatelessWidget {
  final Widget child;
  final VoidCallback? onCenter;
  final VoidCallback? onToggleRotate;
  final VoidCallback? onZoomIn;
  final VoidCallback? onZoomOut;
  final bool autoRotate;
  final double cameraDistance;

  const SemanticCameraControls({
    super.key,
    required this.child,
    this.onCenter,
    this.onToggleRotate,
    this.onZoomIn,
    this.onZoomOut,
    required this.autoRotate,
    required this.cameraDistance,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return child;

    final autoRotateText = autoRotate
        ? l10n.autoRotateActive
        : l10n.autoRotateInactive;
    final distanceText = l10n.distanceFormatted(
      NumberUtils.formatDistance(cameraDistance),
    );

    return SemanticFocusService.instance.createSemanticFocusWrapper(
      focusNode: SemanticFocusService.instance.cameraControlsFocusNode,
      semanticLabel: '${l10n.cameraLabel}. $autoRotateText. $distanceText',
      semanticHint: l10n.cameraTooltip,
      child: Semantics(container: true, explicitChildNodes: true, child: child),
    );
  }
}
