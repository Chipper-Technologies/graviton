import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/services/ui/semantic_focus_service.dart';

/// Semantic wrapper for settings button with proper focus management
class SemanticSettingsButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const SemanticSettingsButton({super.key, required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return child;

    return SemanticFocusService.instance.createSemanticFocusWrapper(
      focusNode: SemanticFocusService.instance.settingsButtonFocusNode,
      semanticLabel: l10n.settingsTooltip,
      semanticHint: l10n.settingsTooltip,
      onTap: onTap,
      child: child,
    );
  }
}
