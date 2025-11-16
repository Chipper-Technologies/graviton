import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/services/semantic_focus_service.dart';
import 'package:graviton/utils/number_utils.dart';

/// Semantic wrapper for simulation control buttons with proper focus management
class SemanticSimulationControls extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPlayPause;
  final VoidCallback? onReset;
  final VoidCallback? onSpeedChange;
  final bool isPlaying;
  final double timeScale;

  const SemanticSimulationControls({
    super.key,
    required this.child,
    this.onPlayPause,
    this.onReset,
    this.onSpeedChange,
    required this.isPlaying,
    required this.timeScale,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return child;

    final playState = isPlaying ? l10n.statusRunning : l10n.statusPaused;
    final speedText = l10n.speedFormatted(
      NumberUtils.formatDecimal(timeScale, 1),
    );
    final playButtonText = isPlaying ? l10n.pauseButton : l10n.playButton;

    return SemanticFocusService.instance.createSemanticFocusWrapper(
      focusNode: SemanticFocusService.instance.simulationControlsFocusNode,
      semanticLabel:
          '${l10n.simulationStats}. ${l10n.statusLabel}: $playState. ${l10n.speedLabel}: $speedText',
      semanticHint: '$playButtonText, ${l10n.resetButton}, ${l10n.speedLabel}',
      child: Semantics(container: true, explicitChildNodes: true, child: child),
    );
  }
}
