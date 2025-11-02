import 'package:flutter/material.dart';
import 'package:graviton/enums/ui_action.dart';
import 'package:graviton/enums/ui_element.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/services/changelog_service.dart';
import 'package:graviton/services/firebase_service.dart';
import 'package:graviton/services/onboarding_service.dart';
import 'package:graviton/services/screenshot_mode_service.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_constraints.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/changelog_dialog.dart';
import 'package:graviton/widgets/common/action_option.dart';
import 'package:graviton/widgets/screenshot_mode_widget.dart';
import 'package:graviton/widgets/section_title.dart';
import 'package:graviton/widgets/tutorial_overlay.dart';

/// Developer Tools dialog for debug-only features
/// This dialog contains Screenshot Mode, Help & Objectives, and Changelog
class DeveloperToolsDialog extends StatelessWidget {
  const DeveloperToolsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTypography.radiusXXLarge),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: AppConstraints.dialogMedium,
        decoration: BoxDecoration(
          color: AppColors.uiBlack.withValues(
            alpha: AppTypography.opacityMediumHigh,
          ),
          borderRadius: BorderRadius.circular(AppTypography.radiusXXLarge),
          border: Border.all(
            color: AppColors.uiWhite.withValues(
              alpha: AppTypography.opacityDisabled,
            ),
            width: AppTypography.borderThin,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with gradient background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryColor.withValues(
                      alpha: AppTypography.opacityMidFade,
                    ),
                    AppColors.primaryColor.withValues(
                      alpha: AppTypography.opacityBarely,
                    ),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppTypography.radiusXXLarge),
                  topRight: Radius.circular(AppTypography.radiusXXLarge),
                ),
              ),
              padding: EdgeInsets.all(AppTypography.spacingLarge),
              child: Row(
                children: [
                  Icon(
                    Icons.developer_mode,
                    color: AppColors.primaryColor,
                    size: AppTypography.iconSizeXXXLarge,
                  ),
                  SizedBox(width: AppTypography.spacingMedium),
                  Text(
                    l10n.developerToolsTitle,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.uiWhite,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.uiWhite),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Scrollable content
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(
                  left: AppTypography.spacingXLarge,
                  right: AppTypography.spacingXLarge,
                  top: AppTypography.spacingXLarge,
                  bottom: AppTypography.spacingXLarge,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Screenshot Mode Section
                      if (ScreenshotModeService().isAvailable) ...[
                        SectionTitle(title: l10n.marketingLabel),
                        SizedBox(height: AppTypography.spacingMedium),
                        const ScreenshotModeWidget(),
                        SizedBox(height: AppTypography.spacingXLarge),
                      ],

                      // Help & Objectives Section
                      SectionTitle(title: l10n.helpAndObjectivesTitle),
                      SizedBox(height: AppTypography.spacingMedium),
                      ActionOption(
                        title: l10n.tutorialButton,
                        description: l10n.tutorialDescription,
                        icon: Icons.school,
                        onPressed: () => _showTutorialFromSettings(context),
                        isPrimary: true,
                      ),
                      ActionOption(
                        title: l10n.resetTutorialButton,
                        description: l10n.resetTutorialDescription,
                        icon: Icons.refresh,
                        onPressed: () => _resetTutorialState(context),
                        isPrimary: false,
                      ),

                      // Changelog Section
                      SectionTitle(title: l10n.changelogDebugTitle),
                      SizedBox(height: AppTypography.spacingMedium),
                      ActionOption(
                        title: l10n.changelogButton,
                        description: l10n.changelogDescription,
                        icon: Icons.assignment,
                        onPressed: () => _showChangelogFromSettings(context),
                        isPrimary: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Show tutorial overlay from developer tools
  void _showTutorialFromSettings(BuildContext context) {
    FirebaseService.instance.logUIEventWithEnums(
      UIAction.tutorialStarted,
      element: UIElement.tutorial,
    );

    final currentContext = context;

    // Close the developer tools dialog first
    Navigator.of(context).pop();

    // Then show the tutorial
    showDialog<void>(
      context: currentContext,
      barrierDismissible: false,
      builder: (dialogContext) => TutorialOverlay(
        onComplete: () async {
          await OnboardingService.markTutorialCompleted();
          if (dialogContext.mounted) {
            Navigator.of(dialogContext).pop();
          }
        },
      ),
    );
  }

  /// Reset tutorial state
  void _resetTutorialState(BuildContext context) {
    OnboardingService.resetTutorialState();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.tutorialResetSuccess),
        backgroundColor: AppColors.uiGreen,
      ),
    );
  }

  /// Show changelog from developer tools
  void _showChangelogFromSettings(BuildContext context) async {
    FirebaseService.instance.logUIEventWithEnums(
      UIAction.changelogShown,
      element: UIElement.changelog,
    );

    final currentContext = context;

    // Fetch changelogs
    try {
      final changelogs = await ChangelogService.instance.fetchChangelogs();

      if (changelogs.isEmpty) {
        if (currentContext.mounted) {
          ScaffoldMessenger.of(currentContext).showSnackBar(
            SnackBar(
              content: Text('No changelogs available'),
              backgroundColor: AppColors.uiOrange,
            ),
          );
        }
        return;
      }

      // Close the developer tools dialog first
      if (currentContext.mounted) {
        Navigator.of(currentContext).pop();
      }

      // Then show the changelog
      if (currentContext.mounted) {
        showDialog<void>(
          context: currentContext,
          builder: (dialogContext) => ChangelogDialog(
            changelogs: changelogs,
            onComplete: () {
              Navigator.of(dialogContext).pop();
            },
          ),
        );
      }
    } catch (e) {
      if (currentContext.mounted) {
        ScaffoldMessenger.of(currentContext).showSnackBar(
          SnackBar(
            content: Text('Error loading changelogs: $e'),
            backgroundColor: AppColors.uiOrange,
          ),
        );
      }
    }
  }
}
