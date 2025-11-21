import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/haptics/haptic_ink_well.dart';

/// Tile for importing a scenario from file
///
/// Displays an import button with icon and description that triggers
/// file selection when tapped.
class ImportScenarioTile extends StatelessWidget {
  final VoidCallback onTap;

  const ImportScenarioTile({super.key, required this.onTap});

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
          padding: EdgeInsets.all(AppTypography.spacingLarge),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
            border: Border.all(
              color: AppColors.uiCyanAccent.withValues(
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
                  color: AppColors.uiCyanAccent.withValues(
                    alpha: AppTypography.opacityVeryFaint,
                  ),
                  borderRadius: BorderRadius.circular(
                    AppTypography.radiusXXLarge + AppTypography.radiusSmall,
                  ),
                ),
                child: Icon(
                  Icons.file_upload_outlined,
                  color: AppColors.uiCyanAccent,
                  size: AppTypography.iconSizeXXXLarge,
                ),
              ),
              SizedBox(width: AppTypography.spacingLarge),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.importScenario,
                      style: AppTypography.largeText.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.uiCyanAccent,
                      ),
                    ),
                    SizedBox(height: AppTypography.spacingXSmall),
                    Text(
                      l10n.importScenarioDescription,
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
                color: AppColors.uiCyanAccent,
                size: AppTypography.iconSizeMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
