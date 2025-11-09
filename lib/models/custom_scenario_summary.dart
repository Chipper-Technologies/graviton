import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/theme/app_colors.dart';

/// Summary information about a custom scenario (for UI display)
class CustomScenarioSummary {
  final String name;
  final String description;
  final int bodyCount;
  final String difficulty;
  final String educationalFocus;
  final List<String> tags;
  final DateTime? createdAt;

  const CustomScenarioSummary({
    required this.name,
    required this.description,
    required this.bodyCount,
    required this.difficulty,
    required this.educationalFocus,
    required this.tags,
    this.createdAt,
  });

  /// Create a formatted body count string for UI display
  String bodyCountDisplay(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return l10n.customScenarioBodyCount(bodyCount);
  }

  /// Create a formatted difficulty display with capitalization
  String get difficultyDisplay =>
      difficulty.substring(0, 1).toUpperCase() + difficulty.substring(1);

  /// Get a color for the difficulty level
  Color get difficultyColor {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return AppColors.uiGreen;
      case 'intermediate':
        return AppColors.uiOrange;
      case 'advanced':
        return AppColors.uiRed;
      default:
        return AppColors.primaryColor;
    }
  }

  /// Create a formatted date string for UI display
  String createdAtDisplay(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (createdAt == null) {
      return l10n.customScenarioCreatedUnknown;
    }

    final now = DateTime.now();
    final difference = now.difference(createdAt!);

    if (difference.inDays == 0) {
      return l10n.customScenarioCreatedToday;
    } else if (difference.inDays == 1) {
      return l10n.customScenarioCreatedYesterday;
    } else if (difference.inDays < 7) {
      return l10n.customScenarioCreatedDaysAgo(
        difference.inDays,
        difference.inDays,
      );
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return l10n.customScenarioCreatedWeeksAgo(weeks, weeks);
    } else {
      final months = (difference.inDays / 30).floor();
      return l10n.customScenarioCreatedMonthsAgo(months, months);
    }
  }
}
