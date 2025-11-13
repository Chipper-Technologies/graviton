import 'package:flutter/material.dart';
import 'package:graviton/enums/snack_bar_severity.dart';
import 'package:graviton/models/snack_bar_theme.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';

/// A themed SnackBar widget that follows Graviton's cosmic design system
///
/// This widget provides consistent styling across the app with severity-based
/// theming including appropriate colors, icons, and visual feedback.
///
/// Usage examples:
/// ```dart
/// GravitonSnackBar.show(
///   context: context,
///   message: 'Body added to scenario successfully',
///   severity: SnackBarSeverity.success,
/// )
///
/// GravitonSnackBar.show(
///   context: context,
///   message: 'Failed to save scenario',
///   severity: SnackBarSeverity.error,
///   duration: Duration(seconds: 5),
///   actionLabel: 'Retry',
///   onActionPressed: () => _retryOperation(),
/// )
/// ```
class GravitonSnackBar {
  /// Shows a themed SnackBar with the specified message and severity
  static void show({
    required BuildContext context,
    required String message,
    SnackBarSeverity severity = SnackBarSeverity.info,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onActionPressed,
    VoidCallback? onVisible,
    DismissDirection dismissDirection = DismissDirection.down,
  }) {
    final theme = _getThemeForSeverity(severity);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: _buildContent(message, theme),
        backgroundColor: theme.backgroundColor,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(AppTypography.spacingMedium),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTypography.radiusLarge),
          side: BorderSide(
            color: theme.borderColor,
            width: AppTypography.borderMedium,
          ),
        ),
        elevation: AppTypography.spacingMedium,
        action: (actionLabel != null && onActionPressed != null)
            ? SnackBarAction(
                label: actionLabel,
                textColor: theme.actionColor,
                onPressed: onActionPressed,
              )
            : null,
        onVisible: onVisible,
        dismissDirection: dismissDirection,
      ),
    );
  }

  /// Builds the content of the SnackBar with icon and message
  static Widget _buildContent(String message, SnackBarTheme theme) {
    return Row(
      children: [
        Icon(
          theme.icon,
          color: theme.iconColor,
          size: AppTypography.iconSizeMedium,
        ),
        SizedBox(width: AppTypography.spacingMedium),
        Expanded(
          child: Text(
            message,
            style: TextStyle(
              color: theme.textColor,
              fontSize: AppTypography.fontSizeMedium,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  /// Gets the appropriate theme based on severity level
  static SnackBarTheme _getThemeForSeverity(SnackBarSeverity severity) {
    switch (severity) {
      case SnackBarSeverity.info:
        return SnackBarTheme(
          backgroundColor: AppColors.uiBlack.withValues(
            alpha: AppTypography.opacityVeryHigh,
          ),
          borderColor: AppColors.uiBlue.withValues(
            alpha: AppTypography.opacityHigh,
          ),
          textColor: AppColors.uiWhite,
          iconColor: AppColors.uiBlue,
          actionColor: AppColors.uiBlue,
          icon: Icons.info_outline,
        );
      case SnackBarSeverity.success:
        return SnackBarTheme(
          backgroundColor: AppColors.uiBlack.withValues(
            alpha: AppTypography.opacityVeryHigh,
          ),
          borderColor: AppColors.uiStatusGreen.withValues(
            alpha: AppTypography.opacityHigh,
          ),
          textColor: AppColors.uiWhite,
          iconColor: AppColors.uiStatusGreen,
          actionColor: AppColors.uiStatusGreen,
          icon: Icons.check_circle_outline,
        );
      case SnackBarSeverity.warning:
        return SnackBarTheme(
          backgroundColor: AppColors.uiBlack.withValues(
            alpha: AppTypography.opacityVeryHigh,
          ),
          borderColor: AppColors.uiStatusOrange.withValues(
            alpha: AppTypography.opacityHigh,
          ),
          textColor: AppColors.uiWhite,
          iconColor: AppColors.uiStatusOrange,
          actionColor: AppColors.uiStatusOrange,
          icon: Icons.warning_outlined,
        );
      case SnackBarSeverity.error:
        return SnackBarTheme(
          backgroundColor: AppColors.uiBlack.withValues(
            alpha: AppTypography.opacityVeryHigh,
          ),
          borderColor: AppColors.uiRed.withValues(
            alpha: AppTypography.opacityHigh,
          ),
          textColor: AppColors.uiWhite,
          iconColor: AppColors.uiRed,
          actionColor: AppColors.uiRed,
          icon: Icons.error_outline,
        );
    }
  }

  /// Convenience method for showing info messages
  static void info({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    show(
      context: context,
      message: message,
      severity: SnackBarSeverity.info,
      duration: duration,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  /// Convenience method for showing success messages
  static void success({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    show(
      context: context,
      message: message,
      severity: SnackBarSeverity.success,
      duration: duration,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  /// Convenience method for showing warning messages
  static void warning({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 4),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    show(
      context: context,
      message: message,
      severity: SnackBarSeverity.warning,
      duration: duration,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  /// Convenience method for showing error messages
  static void error({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 5),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    show(
      context: context,
      message: message,
      severity: SnackBarSeverity.error,
      duration: duration,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }
}
