import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/celestial/body.dart';
import 'package:graviton/core/enums/simulation_status.dart';
import 'package:graviton/utils/semantic_utils.dart';

/// Semantic wrapper for the simulation canvas that provides accessibility
/// support for the CustomPaint physics simulation
class SemanticSimulationCanvas extends StatefulWidget {
  final Widget child;
  final List<Body> bodies;
  final SimulationStatus status;
  final double timeScale;
  final int stepCount;
  final double cameraDistance;
  final bool autoRotate;
  final bool followMode;
  final String? followingBodyName;
  final VoidCallback? onTap;
  final VoidCallback? onCenter;
  final VoidCallback? onToggleRotate;
  final VoidCallback? onZoomIn;
  final VoidCallback? onZoomOut;

  const SemanticSimulationCanvas({
    super.key,
    required this.child,
    required this.bodies,
    required this.status,
    required this.timeScale,
    required this.stepCount,
    required this.cameraDistance,
    required this.autoRotate,
    required this.followMode,
    this.followingBodyName,
    this.onTap,
    this.onCenter,
    this.onToggleRotate,
    this.onZoomIn,
    this.onZoomOut,
  });

  @override
  State<SemanticSimulationCanvas> createState() =>
      _SemanticSimulationCanvasState();
}

class _SemanticSimulationCanvasState extends State<SemanticSimulationCanvas> {
  late String _lastSimulationDescription;
  late String _lastCameraDescription;
  late String _lastBodiesDescription;
  bool _descriptionsInitialized = false;

  @override
  void initState() {
    super.initState();
    // Don't call _updateDescriptions() here since AppLocalizations isn't available yet
  }

  @override
  void didUpdateWidget(SemanticSimulationCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Only update descriptions if they were already initialized and there's a significant change
    if (_descriptionsInitialized && _hasSignificantChange(oldWidget)) {
      _updateDescriptions();
    }
  }

  void _updateDescriptions() {
    final l10n = AppLocalizations.of(context);
    if (l10n != null) {
      _lastSimulationDescription = SemanticUtils.createSimulationDescription(
        l10n,
        widget.bodies,
        widget.status,
        widget.timeScale,
        widget.stepCount,
      );

      _lastCameraDescription = SemanticUtils.createCameraDescription(
        l10n,
        widget.cameraDistance,
        widget.autoRotate,
        widget.followMode,
        widget.followingBodyName,
      );

      _lastBodiesDescription = SemanticUtils.createBodiesDescription(
        l10n,
        widget.bodies,
      );
    }
  }

  bool _hasSignificantChange(SemanticSimulationCanvas oldWidget) {
    // Significant changes that should trigger announcements
    return widget.status != oldWidget.status ||
        widget.bodies.length != oldWidget.bodies.length ||
        widget.followMode != oldWidget.followMode ||
        widget.followingBodyName != oldWidget.followingBodyName ||
        (widget.timeScale - oldWidget.timeScale).abs() > 0.5;
  }

  String _buildComprehensiveDescription() {
    // Return empty string if descriptions haven't been initialized yet
    if (!_descriptionsInitialized) {
      return '';
    }

    final descriptions = <String>[
      _lastSimulationDescription,
      _lastBodiesDescription,
      _lastCameraDescription,
    ];

    return descriptions.join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return widget.child;

    // Initialize descriptions on first build when AppLocalizations is available
    if (!_descriptionsInitialized) {
      _updateDescriptions();
      _descriptionsInitialized = true;
    }

    return Semantics(
      label: l10n.simulationCanvasLabel,
      hint: SemanticUtils.createKeyboardHints(l10n),
      value: _buildComprehensiveDescription(),
      onTap: widget.onTap,
      focused: true,
      explicitChildNodes: false,
      child: MergeSemantics(
        child: ExcludeSemantics(excluding: false, child: widget.child),
      ),
    );
  }
}
