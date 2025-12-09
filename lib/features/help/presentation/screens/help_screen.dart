import 'package:flutter/material.dart';
import 'package:graviton/core/enums/ui_action.dart';
import 'package:graviton/core/enums/ui_element.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/services/firebase/firebase_service.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_constraints.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/utils/ui_utils.dart';
import 'package:graviton/widgets/common/section_divider.dart';
import 'package:graviton/widgets/haptics/haptic_app_bar.dart';

/// Full-screen Help & Objectives page
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Track help screen access analytics
    FirebaseService.instance.logUIEventWithEnums(
      UIAction.helpSectionAccessed,
      element: UIElement.helpDocumentation,
      value: 'help_screen_opened',
    );

    return Scaffold(
      backgroundColor: AppColors.transparentColor,
      appBar: HapticAppBar(title: l10n.showHelpTooltip),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.uiBlack.withValues(
              alpha: AppTypography.opacityNearlyOpaque,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(AppTypography.spacingLarge),
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: AppConstraints.contentMaxWidth,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // What to Do section
                            _buildSection(
                              context,
                              icon: Icons.rocket_launch,
                              title: l10n.whatToDoTitle,
                              content: l10n.whatToDoDescription,
                            ),

                            // Learning Objectives section
                            _buildObjectivesSection(context, l10n),

                            // Quick Start section
                            _buildQuickStartSection(context, l10n),
                            SizedBox(height: AppTypography.spacingXXLarge),

                            // Call to action
                            Center(
                              child: ElevatedButton.icon(
                                onPressed: () => Navigator.of(context).pop(),
                                icon: const Icon(Icons.explore),
                                label: Text(l10n.getStarted),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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

  Widget _buildSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionDivider.labeled(
          title,
          bottomSpacing: AppTypography.spacingMedium,
        ),
        _buildFormattedContent(content),
      ],
    );
  }

  /// Build objectives section using individual list items
  Widget _buildObjectivesSection(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionDivider.labeled(
          l10n.objectivesTitle,
          topSpacing: AppTypography.spacingMedium,
          bottomSpacing: AppTypography.spacingMedium,
        ),
        // Try to use individual list items, fall back to description if they don't exist
        _tryBuildObjectivesList(l10n) ??
            Text(
              l10n.objectivesDescription,
              style: AppTypography.mediumText.copyWith(
                height: 1.6,
                color: AppColors.uiWhite,
              ),
            ),
      ],
    );
  }

  /// Build quick start section using individual list items
  Widget _buildQuickStartSection(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionDivider.labeled(
          l10n.quickStartTitle,
          topSpacing: AppTypography.spacingMedium,
          bottomSpacing: AppTypography.spacingMedium,
        ),
        // Try to use individual list items, fall back to description if they don't exist
        _tryBuildQuickStartList(l10n) ??
            Text(
              l10n.quickStartDescription,
              style: AppTypography.mediumText.copyWith(
                height: 1.6,
                color: AppColors.uiWhite,
              ),
            ),
      ],
    );
  }

  /// Try to build objectives list from individual items, return null if not available
  Widget? _tryBuildObjectivesList(AppLocalizations l10n) {
    try {
      return UIUtils.buildBulletList([
        l10n.objectives1,
        l10n.objectives2,
        l10n.objectives3,
        l10n.objectives4,
        l10n.objectives5,
        l10n.objectives6,
      ]);
    } catch (e) {
      // Individual items not available for this language
      return null;
    }
  }

  /// Try to build quick start list from individual items, return null if not available
  Widget? _tryBuildQuickStartList(AppLocalizations l10n) {
    try {
      return UIUtils.buildNumberedList([
        l10n.quickStart1,
        l10n.quickStart2,
        l10n.quickStart3,
        l10n.quickStart4,
        l10n.quickStart5,
        l10n.quickStart6,
      ]);
    } catch (e) {
      // Individual items not available for this language
      return null;
    }
  }

  /// Build formatted content with proper text styling
  Widget _buildFormattedContent(String content) {
    return Text(
      content,
      style: AppTypography.mediumText.copyWith(
        height: 1.6,
        color: AppColors.uiWhite,
      ),
    );
  }
}
