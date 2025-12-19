import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/haptics/haptic_circular_button.dart';

/// A toggle button for locking/unlocking body interaction (dragging)
///
/// This widget provides a circular button that toggles between locked and unlocked
/// states. When locked, users cannot accidentally drag bodies out of their orbits.
class InteractionLockToggle extends StatelessWidget {
  /// Whether the interaction is currently locked
  final bool isLocked;

  /// Callback when the toggle is pressed
  final VoidCallback onToggle;

  const InteractionLockToggle({
    super.key,
    required this.isLocked,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return HapticCircularButton(
      icon: isLocked ? Icons.lock_outline : Icons.lock_open,
      onTap: onToggle,
      size: AppTypography.buttonSizeStandard,
      iconColor: AppColors.uiWhite,
      backgroundColor: isLocked
          ? AppColors.primaryColor.withValues(
              alpha: AppTypography.opacityNearlyOpaque,
            )
          : AppColors.uiBlack.withValues(alpha: AppTypography.opacityHigh),
      borderColor: isLocked
          ? null
          : AppColors.uiWhite.withValues(alpha: AppTypography.opacityFaint),
      semanticsLabel: l10n.lockInteraction,
      semanticsHint: isLocked
          ? l10n.tapToUnlockInteraction
          : l10n.tapToLockInteraction,
      tooltip: l10n.lockInteraction,
    );
  }
}
