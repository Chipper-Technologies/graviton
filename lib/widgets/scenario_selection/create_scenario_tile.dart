import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/common/haptic_ink_well.dart';

/// Widget for creating new custom scenarios
///
/// This tile displays a prominent "Create New Scenario" button that guides users
/// to the scenario editor for creating custom gravitational simulations.
class CreateScenarioTile extends StatelessWidget {
  /// Callback function to execute when the tile is tapped
  final VoidCallback onTap;

  const CreateScenarioTile({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 2,
      child: HapticInkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
            border: Border.all(
              color: AppColors.primaryColor.withValues(
                alpha: AppTypography.opacityMedium,
              ),
              width: AppTypography.borderThick,
              style: BorderStyle.solid,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: AppTypography.iconSizeXXXXLarge,
                height: AppTypography.iconSizeXXXXLarge,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(
                    alpha: AppTypography.opacityVeryFaint,
                  ),
                  borderRadius: BorderRadius.circular(
                    AppTypography.radiusXXLarge + AppTypography.radiusSmall,
                  ),
                ),
                child: Icon(
                  Icons.add_circle_outline,
                  color: AppColors.primaryColor,
                  size: AppTypography.iconSizeXXXLarge,
                ),
              ),
              SizedBox(width: AppTypography.spacingLarge),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.createCustomScenarioButton,
                      style: AppTypography.largeText.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    SizedBox(height: AppTypography.spacingXSmall),
                    Text(
                      l10n.createCustomScenarioDescription,
                      style: AppTypography.smallText.copyWith(
                        color: AppColors.uiWhite.withValues(
                          alpha: AppTypography.opacityVeryHigh,
                        ),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: AppColors.primaryColor,
                size: AppTypography.iconSizeMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
