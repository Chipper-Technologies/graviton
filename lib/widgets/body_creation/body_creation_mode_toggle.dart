import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/haptics/haptic_circular_button.dart';

/// A toggle button for activating/deactivating body creation mode
///
/// This widget provides a circular button that toggles between active and inactive
/// states for adding new bodies to the simulation during runtime.
class BodyCreationModeToggle extends StatelessWidget {
  final bool isActive;
  final VoidCallback onToggle;

  const BodyCreationModeToggle({
    super.key,
    required this.isActive,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return HapticCircularButton(
      icon: Icons.add_circle_outline,
      onTap: onToggle,
      size: AppTypography.buttonSizeStandard,
      iconColor: AppColors.uiWhite,
      backgroundColor: isActive
          ? AppColors.primaryColor.withValues(
              alpha: AppTypography.opacityNearlyOpaque,
            )
          : AppColors.uiBlack.withValues(alpha: AppTypography.opacityHigh),
      borderColor: isActive
          ? null
          : AppColors.uiWhite.withValues(alpha: AppTypography.opacityFaint),
      semanticsLabel: l10n.addBodyButton,
      semanticsHint: isActive
          ? l10n.tapToDisableAddBodyMode
          : l10n.tapToEnableAddBodyMode,
      tooltip: l10n.addBodyButton,
    );
  }
}
