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
                    size: 28,
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
                padding: EdgeInsets.all(AppTypography.spacingXLarge),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Screenshot Mode Section
                      if (ScreenshotModeService().isAvailable) ...[
                        _buildSection(
                          context,
                          title: l10n.marketingLabel,
                          icon: Icons.camera_alt,
                          children: [const ScreenshotModeWidget()],
                        ),
                        SizedBox(height: AppTypography.spacingXLarge),
                      ],

                      // Help & Objectives Section
                      _buildSection(
                        context,
                        title: l10n.helpAndObjectivesTitle,
                        icon: Icons.help_outline,
                        children: [
                          _buildActionButton(
                            context,
                            icon: Icons.school,
                            label: l10n.tutorialButton,
                            description: l10n.tutorialDescription,
                            onPressed: () => _showTutorialFromSettings(context),
                            isPrimary: true,
                          ),
                          ...[
                            SizedBox(height: AppTypography.spacingMedium),
                            _buildActionButton(
                              context,
                              icon: Icons.refresh,
                              label: l10n.resetTutorialButton,
                              description: l10n.resetTutorialDescription,
                              onPressed: () => _resetTutorialState(context),
                              isPrimary: false,
                            ),
                          ],
                        ],
                      ),

                      SizedBox(height: AppTypography.spacingXLarge),

                      // Changelog Section
                      _buildSection(
                        context,
                        title: l10n.changelogDebugTitle,
                        icon: Icons.assignment,
                        children: [
                          _buildActionButton(
                            context,
                            icon: Icons.assignment,
                            label: l10n.changelogButton,
                            description: l10n.changelogDescription,
                            onPressed: () =>
                                _showChangelogFromSettings(context),
                            isPrimary: true,
                          ),
                        ],
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

  /// Build a section with title and content
  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: EdgeInsets.all(AppTypography.spacingLarge),
      decoration: BoxDecoration(
        color: AppColors.uiWhite.withValues(alpha: AppTypography.opacityBarely),
        borderRadius: BorderRadius.circular(AppTypography.radiusLarge),
        border: Border.all(
          color: AppColors.uiWhite.withValues(
            alpha: AppTypography.opacityDisabled,
          ),
          width: AppTypography.borderThin,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primaryColor, size: 20),
              SizedBox(width: AppTypography.spacingMedium),
              SectionTitle(title: title),
            ],
          ),
          SizedBox(height: AppTypography.spacingLarge),
          ...children,
        ],
      ),
    );
  }

  /// Build an action button with consistent styling
  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String description,
    required VoidCallback onPressed,
    required bool isPrimary,
  }) {
    return SizedBox(
      width: double.infinity,
      child: isPrimary
          ? ElevatedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, size: 18),
              label: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: AppTypography.mediumText.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    description,
                    style: AppTypography.smallText.copyWith(
                      color: AppColors.uiWhite.withValues(
                        alpha: AppTypography.opacitySemiTransparent,
                      ),
                    ),
                  ),
                ],
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor.withValues(
                  alpha: AppTypography.opacityFaint,
                ),
                foregroundColor: AppColors.uiWhite,
                padding: EdgeInsets.symmetric(
                  horizontal: AppTypography.spacingLarge,
                  vertical: AppTypography.spacingMedium,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppTypography.radiusMedium,
                  ),
                  side: BorderSide(
                    color: AppColors.primaryColor.withValues(
                      alpha: AppTypography.opacityMidFade,
                    ),
                    width: AppTypography.borderThin,
                  ),
                ),
              ),
            )
          : OutlinedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, size: 18),
              label: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: AppTypography.mediumText.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    description,
                    style: AppTypography.smallText.copyWith(
                      color: AppColors.uiWhite.withValues(
                        alpha: AppTypography.opacitySemiTransparent,
                      ),
                    ),
                  ),
                ],
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.uiWhite,
                padding: EdgeInsets.symmetric(
                  horizontal: AppTypography.spacingLarge,
                  vertical: AppTypography.spacingMedium,
                ),
                side: BorderSide(
                  color: AppColors.uiWhite.withValues(
                    alpha: AppTypography.opacityMidFade,
                  ),
                  width: AppTypography.borderThin,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppTypography.radiusMedium,
                  ),
                ),
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
