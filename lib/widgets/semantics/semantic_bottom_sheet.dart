import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/services/ui/semantic_focus_service.dart';

/// Semantic wrapper for bottom sheet with proper focus management and navigation
class SemanticBottomSheet extends StatelessWidget {
  final Widget child;
  final VoidCallback? onExpand;
  final VoidCallback? onCollapse;
  final bool isExpanded;
  final String? currentScenario;

  const SemanticBottomSheet({
    super.key,
    required this.child,
    this.onExpand,
    this.onCollapse,
    required this.isExpanded,
    this.currentScenario,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return child;

    final expandState = isExpanded ? l10n.expandedState : l10n.collapsedState;
    final scenarioText = currentScenario != null
        ? '${l10n.currentScenario}: $currentScenario'
        : l10n.selectScenarioTooltip;

    return SemanticFocusService.instance.createSemanticFocusWrapper(
      focusNode: SemanticFocusService.instance.bottomSheetFocusNode,
      semanticLabel: '${l10n.bottomSheetLabel}. $expandState. $scenarioText',
      semanticHint: l10n.selectScenarioTooltip,
      onTap: isExpanded ? onCollapse : onExpand,
      child: Semantics(container: true, explicitChildNodes: true, child: child),
    );
  }
}
