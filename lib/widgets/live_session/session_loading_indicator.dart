import 'package:flutter/material.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';

/// Loading indicator widget for live session screens
///
/// Displays a centered circular progress indicator.
class SessionLoadingIndicator extends StatelessWidget {
  /// Whether to use the primary color style
  final bool usePrimaryColor;

  const SessionLoadingIndicator({this.usePrimaryColor = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTypography.spacingXLarge),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            usePrimaryColor
                ? AppColors.primaryColor
                : AppColors.uiWhite.withValues(
                    alpha: AppTypography.opacityHigh,
                  ),
          ),
        ),
      ),
    );
  }
}
