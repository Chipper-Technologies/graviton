import 'package:flutter/material.dart';
import 'package:graviton/enums/firebase_event.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/services/firebase_service.dart';
import 'package:graviton/services/simulation_share_service.dart';
import 'package:graviton/state/simulation_state.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/common/graviton_snack_bar.dart';
import 'package:graviton/widgets/haptics/haptic_ink_well.dart';

/// Action button for sharing simulation state or images
class ShareActionButton extends StatelessWidget {
  final SimulationState simulationState;
  final GlobalKey repaintBoundaryKey;

  const ShareActionButton({
    required this.simulationState,
    required this.repaintBoundaryKey,
    super.key,
  });

  /// Show share options dialog
  Future<void> showShareOptions(BuildContext context) async {
    final l10n = AppLocalizations.of(context);

    // Log dialog open event
    FirebaseService.instance.logEventWithEnum(FirebaseEvent.shareDialogOpened);

    final option = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundBlack,
        title: Text(
          l10n!.shareSimulation,
          style: AppTypography.titleText.copyWith(color: AppColors.uiWhite),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.image, color: AppColors.primaryColor),
              title: Text(
                l10n.shareImage,
                style: AppTypography.mediumText.copyWith(
                  color: AppColors.uiWhite,
                ),
              ),
              subtitle: Text(
                l10n.shareImageDescription,
                style: AppTypography.smallText.copyWith(
                  color: AppColors.uiWhite.withValues(
                    alpha: AppTypography.opacityHigh,
                  ),
                ),
              ),
              onTap: () => Navigator.of(context).pop('image'),
            ),
            const SizedBox(height: AppTypography.spacingMedium),
            ListTile(
              leading: const Icon(Icons.code, color: AppColors.primaryColor),
              title: Text(
                l10n.shareState,
                style: AppTypography.mediumText.copyWith(
                  color: AppColors.uiWhite,
                ),
              ),
              subtitle: Text(
                l10n.shareStateDescription,
                style: AppTypography.smallText.copyWith(
                  color: AppColors.uiWhite.withValues(
                    alpha: AppTypography.opacityHigh,
                  ),
                ),
              ),
              onTap: () => Navigator.of(context).pop('state'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              l10n.cancel,
              style: AppTypography.mediumText.copyWith(
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );

    if (option == null || !context.mounted) {
      // Log cancellation
      if (option == null) {
        FirebaseService.instance.logEventWithEnum(FirebaseEvent.shareCancelled);
      }
      return;
    }

    try {
      final service = SimulationShareService.instance;
      bool success = false;

      if (option == 'image') {
        success = await service.shareSimulationImage(
          repaintBoundaryKey: repaintBoundaryKey,
          subject: l10n!.shareSnapshotSubject,
          text: l10n.shareText,
        );
      } else if (option == 'state') {
        success = await service.shareSimulationState(
          simulationState: simulationState,
          subject: l10n!.shareSubject,
          text: l10n.shareText,
        );
      }

      if (context.mounted) {
        if (success) {
          // Log successful share with type
          if (option == 'image') {
            FirebaseService.instance.logEventWithEnum(
              FirebaseEvent.simulationImageShared,
            );
          } else {
            FirebaseService.instance.logEventWithEnum(
              FirebaseEvent.simulationStateShared,
            );
          }
          FirebaseService.instance.logEventWithEnum(
            FirebaseEvent.simulationShared,
          );

          GravitonSnackBar.success(
            context: context,
            message: l10n!.shareSuccess,
          );
        } else {
          // Log share failure
          FirebaseService.instance.logEventWithEnum(FirebaseEvent.shareFailed);

          GravitonSnackBar.error(context: context, message: l10n!.shareFailed);
        }
      }
    } catch (e) {
      // Log exception as failure
      FirebaseService.instance.logEventWithEnum(FirebaseEvent.shareFailed);
      if (context.mounted) {
        GravitonSnackBar.error(context: context, message: l10n!.shareFailed);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Material(
      color: AppColors.transparentColor,
      child: HapticInkWell(
        onTap: () => showShareOptions(context),
        borderRadius: AppTypography.createRadius(AppTypography.radiusLarge),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppTypography.spacingLarge,
            horizontal: AppTypography.spacingMedium,
          ),
          decoration: BoxDecoration(
            color: AppColors.uiWhite.withValues(
              alpha: AppTypography.opacityBarely,
            ),
            borderRadius: AppTypography.createRadius(AppTypography.radiusLarge),
            border: AppTypography.createBorder(
              opacity: AppTypography.opacityDisabled,
              width: AppTypography.borderThin,
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.share,
                color: AppColors.uiWhite.withValues(
                  alpha: AppTypography.opacityVeryHigh,
                ),
                size: AppTypography.iconSizeXXLarge,
              ),
              const SizedBox(height: AppTypography.spacingSmall),
              Text(
                l10n!.share,
                style: AppTypography.smallText.copyWith(
                  color: AppColors.uiWhite.withValues(
                    alpha: AppTypography.opacityVeryHigh,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
