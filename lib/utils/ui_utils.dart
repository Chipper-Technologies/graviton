import 'package:flutter/material.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';

/// Utility functions for UI components and text formatting
class UIUtils {
  UIUtils._(); // Private constructor to prevent instantiation

  /// Simple emoji detection helper
  static bool isEmoji(String char) {
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

  /// Build a bullet list with proper text alignment
  static Widget buildBulletList(List<String> items) {
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
  static Widget buildNumberedList(List<String> items) {
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

  /// Build formatted content with support for line breaks and special formatting
  static Widget buildFormattedContent(String content) {
    final lines = content.split('\n');
    final widgets = <Widget>[];

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();

      if (line.isEmpty) {
        widgets.add(SizedBox(height: AppTypography.spacingSmall));
      } else {
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

  /// Format body name for moons as "Planet+Moon"
  static String formatBodyName(String bodyName, String bodyType) {
    // This is a simplified version - would need access to body relationships
    // for full functionality
    return bodyName;
  }

  /// Build a section with title and content
  static Widget buildSection({
    required BuildContext context,
    required String title,
    required Widget content,
    IconData? icon,
    Color? titleColor,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 20,
                color: titleColor ?? AppColors.sectionTitlePurple,
              ),
              SizedBox(width: AppTypography.spacingSmall),
            ],
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: titleColor ?? AppColors.sectionTitlePurple,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppTypography.spacingSmall),
        content,
      ],
    );
  }

  /// Build a section header with icon and title
  static Widget buildSectionHeader(
    String title,
    IconData icon, {
    Color? color,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color ?? AppColors.sectionTitlePurple),
        SizedBox(width: AppTypography.spacingSmall),
        Text(
          title,
          style: AppTypography.largeText.copyWith(
            fontWeight: FontWeight.w600,
            color: color ?? AppColors.sectionTitlePurple,
          ),
        ),
      ],
    );
  }
}
