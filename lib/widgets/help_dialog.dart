import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_constraints.dart';
import 'package:graviton/theme/app_typography.dart';

/// Dialog that explains what users can do and the app's objectives
class HelpDialog extends StatelessWidget {
  const HelpDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTypography.radiusXLarge),
      ),
      child: Container(
        constraints: AppConstraints.dialogLarge,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title with close button
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryColor.withValues(alpha: 0.15),
                    AppColors.primaryColor.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppTypography.radiusXLarge),
                  topRight: Radius.circular(AppTypography.radiusXLarge),
                ),
              ),
              padding: EdgeInsets.all(AppTypography.spacingLarge),
              child: Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: AppColors.primaryColor,
                    size: 28,
                  ),
                  SizedBox(width: AppTypography.spacingMedium),
                  Text(
                    l10n.showHelpTooltip,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            // Content
            Flexible(
              child: Padding(
                padding: AppConstraints.dialogPadding,
                child: SingleChildScrollView(
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
                      SizedBox(height: AppTypography.spacingXLarge),

                      // Learning Objectives section
                      _buildObjectivesSection(context, l10n),
                      SizedBox(height: AppTypography.spacingXLarge),

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
          ],
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
        // Header like settings dialog
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.sectionTitlePurple,
          ),
        ),
        SizedBox(height: AppTypography.spacingSmall),
        // Content with emoji formatting if needed
        _buildFormattedContent(content),
      ],
    );
  }

  /// Build formatted content that handles emoji lists properly
  Widget _buildFormattedContent(String content) {
    // Split into lines and handle emoji formatting
    final lines = content.split('\n');
    final List<Widget> widgets = [];

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (line.trim().isEmpty) continue;

      // Check if line starts with an emoji (any emoji character followed by space)
      // Using a more general approach to detect emojis
      if (line.trim().length > 2 && _isEmoji(line.trim().substring(0, 2))) {
        // Find where the emoji ends and text begins
        int textStart = 0;
        for (int j = 0; j < line.length; j++) {
          if (line[j] == ' ') {
            textStart = j + 1;
            break;
          }
        }

        if (textStart > 0) {
          final emoji = line.substring(0, textStart - 1);
          final text = line.substring(textStart);

          widgets.add(
            Padding(
              padding: EdgeInsets.only(bottom: i < lines.length - 1 ? 4.0 : 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 24,
                    child: Text(
                      emoji,
                      style: AppTypography.mediumText.copyWith(height: 1.6),
                    ),
                  ),
                  SizedBox(width: AppTypography.spacingXSmall),
                  Expanded(
                    child: Text(
                      text,
                      style: AppTypography.mediumText.copyWith(height: 1.6),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          // Fallback to regular text if parsing fails
          widgets.add(
            Padding(
              padding: EdgeInsets.only(bottom: i < lines.length - 1 ? 4.0 : 0),
              child: Text(
                line.trim(),
                style: AppTypography.mediumText.copyWith(height: 1.6),
              ),
            ),
          );
        }
      } else {
        // Regular text line
        widgets.add(
          Padding(
            padding: EdgeInsets.only(bottom: i < lines.length - 1 ? 4.0 : 0),
            child: Text(
              line.trim(),
              style: AppTypography.mediumText.copyWith(height: 1.6),
            ),
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  /// Simple emoji detection helper
  bool _isEmoji(String char) {
    // Check for common emoji ranges in Unicode
    final runes = char.runes.toList();
    if (runes.isEmpty) return false;

    final code = runes[0];
    // Basic emoji ranges (simplified)
    return (code >= 0x1F600 && code <= 0x1F64F) || // Emoticons
        (code >= 0x1F300 && code <= 0x1F5FF) || // Misc Symbols
        (code >= 0x1F680 && code <= 0x1F6FF) || // Transport
        (code >= 0x1F1E6 && code <= 0x1F1FF) || // Flags
        (code >= 0x2600 && code <= 0x26FF) || // Misc symbols
        (code >= 0x2700 && code <= 0x27BF); // Dingbats
  }

  /// Build objectives section using individual list items
  Widget _buildObjectivesSection(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.objectivesTitle,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.sectionTitlePurple,
          ),
        ),
        SizedBox(height: AppTypography.spacingSmall),
        // Try to use individual list items, fall back to description if they don't exist
        _tryBuildObjectivesList(l10n) ??
            Text(
              l10n.objectivesDescription,
              style: AppTypography.mediumText.copyWith(height: 1.6),
            ),
      ],
    );
  }

  /// Build quick start section using individual list items
  Widget _buildQuickStartSection(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.quickStartTitle,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.sectionTitlePurple,
          ),
        ),
        SizedBox(height: AppTypography.spacingSmall),
        // Try to use individual list items, fall back to description if they don't exist
        _tryBuildQuickStartList(l10n) ??
            Text(
              l10n.quickStartDescription,
              style: AppTypography.mediumText.copyWith(height: 1.6),
            ),
      ],
    );
  }

  /// Try to build objectives list from individual items, return null if not available
  Widget? _tryBuildObjectivesList(AppLocalizations l10n) {
    try {
      return _buildBulletList([
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
      return _buildNumberedList([
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

  /// Build a bullet list with proper text alignment
  Widget _buildBulletList(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 24,
                    child: Text(
                      '•',
                      style: AppTypography.mediumText.copyWith(
                        height: 1.6,
                        color: AppColors.sectionTitlePurple,
                      ),
                    ),
                  ),
                  SizedBox(width: AppTypography.spacingXSmall),
                  Expanded(
                    child: Text(
                      item,
                      style: AppTypography.mediumText.copyWith(height: 1.6),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  /// Build a numbered list with proper text alignment
  Widget _buildNumberedList(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.asMap().entries.map((entry) {
        final index = entry.key + 1;
        final item = entry.value;
        return Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 24,
                child: Text(
                  '$index.',
                  style: AppTypography.mediumText.copyWith(
                    height: 1.6,
                    fontWeight: FontWeight.w600,
                    color: AppColors.sectionTitlePurple,
                  ),
                ),
              ),
              SizedBox(width: AppTypography.spacingXSmall),
              Expanded(
                child: Text(
                  item,
                  style: AppTypography.mediumText.copyWith(height: 1.6),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
