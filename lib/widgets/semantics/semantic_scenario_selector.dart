import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/services/semantic_focus_service.dart';

/// Semantic wrapper for scenario selector with proper focus management
class SemanticScenarioSelector extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final String? currentScenario;
  final int? scenarioCount;

  const SemanticScenarioSelector({
    super.key,
    required this.child,
    this.onTap,
    this.currentScenario,
    this.scenarioCount,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return child;

    final scenarioText = currentScenario != null
        ? '${l10n.currentScenario}: $currentScenario'
        : l10n.selectScenarioTooltip;
    final countText = scenarioCount != null
        ? '$scenarioCount ${l10n.scenariosAvailable}'
        : '';

    return SemanticFocusService.instance.createSemanticFocusWrapper(
      focusNode: SemanticFocusService.instance.scenarioSelectorFocusNode,
      semanticLabel: '${l10n.selectScenarioTooltip}. $scenarioText. $countText',
      semanticHint: l10n.selectScenarioTooltip,
      onTap: onTap,
      child: child,
    );
  }
}
