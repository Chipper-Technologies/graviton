import 'package:flutter/material.dart';
import 'package:graviton/enums/ui_action.dart';
import 'package:graviton/enums/ui_element.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/services/changelog_service.dart';
import 'package:graviton/services/firebase_service.dart';
import 'package:graviton/services/onboarding_service.dart';
import 'package:graviton/services/screenshot_mode_service.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/changelog_dialog.dart';
import 'package:graviton/widgets/common/action_option.dart';
import 'package:graviton/widgets/common/graviton_snack_bar.dart';
import 'package:graviton/widgets/haptics/haptic_app_bar.dart';
import 'package:graviton/widgets/screenshot_mode_widget.dart';
import 'package:graviton/widgets/section_title.dart';
import 'package:graviton/widgets/overlays/tutorial_overlay.dart';

/// Developer Tools full-screen page
class DeveloperToolsScreen extends StatelessWidget {
  const DeveloperToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.transparentColor,
      appBar: HapticAppBar(title: l10n.developerToolsTitle),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.uiBlack.withValues(
              alpha: AppTypography
                  .opacityNearlyOpaque, // Nearly opaque with subtle background hint
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(AppTypography.spacingLarge),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Screenshot Mode Section
                        if (ScreenshotModeService().isAvailable) ...[
                          SectionTitle(title: l10n.marketingLabel),
                          SizedBox(height: AppTypography.spacingMedium),
                          const ScreenshotModeWidget(),
                          SizedBox(height: AppTypography.spacingXXLarge),
                        ],

                        // Actions Section
                        SectionTitle(title: l10n.showHelpTooltip),
                        SizedBox(height: AppTypography.spacingMedium),

                        // Tutorial Button
                        ActionOption(
                          icon: Icons.school,
                          title: l10n.tutorialButton,
                          description: l10n.tutorialDescription,
                          onPressed: () => _startTutorial(context),
                          isPrimary: true,
                        ),
                        SizedBox(height: AppTypography.spacingLarge),

                        // Changelog Section
                        SectionTitle(title: l10n.changelogHometitle),
                        SizedBox(height: AppTypography.spacingMedium),

                        // Changelog Button
                        ActionOption(
                          icon: Icons.assignment,
                          title: l10n.changelogButton,
                          description: l10n.changelogDescription,
                          onPressed: () => _showChangelog(context),
                          isPrimary: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Starts the tutorial overlay
  void _startTutorial(BuildContext context) {
    FirebaseService.instance.logUIEventWithEnums(
      UIAction.tutorialStarted,
      element: UIElement.tutorial,
    );

    final currentContext = context;

    // Close the developer tools screen first
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

  /// Shows the changelog dialog
  void _showChangelog(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
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
          GravitonSnackBar.info(
            context: currentContext,
            message: l10n.noChangelogsAvailable,
          );
        }
        return;
      }

      // Close the developer tools screen first
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
        GravitonSnackBar.error(
          context: currentContext,
          message: l10n.changelogLoadError(e.toString()),
        );
      }
    }
  }
}
