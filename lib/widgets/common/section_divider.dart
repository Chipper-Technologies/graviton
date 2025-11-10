import 'package:flutter/material.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';

/// A reusable section divider widget that supports both plain dividers and labeled dividers
///
/// Features:
/// - Plain horizontal line divider (when no label provided)
/// - Labeled divider with text in the center (when label provided)
/// - Consistent styling with theme colors
/// - Configurable spacing above and below
class SectionDivider extends StatelessWidget {
  /// The text label to display in the center of the divider (optional)
  final String? label;

  /// Custom text style for the label (optional)
  final TextStyle? labelStyle;

  /// The height/thickness of the divider line
  final double thickness;

  /// The color of the divider line (uses uiDividerGrey if not specified)
  final Color? color;

  /// Horizontal padding around the label text
  final double labelPadding;

  /// Spacing above the divider
  final double topSpacing;

  /// Spacing below the divider
  final double bottomSpacing;

  /// Left indent for plain dividers
  final double indent;

  /// Right indent for plain dividers
  final double endIndent;

  /// Total height of the divider widget (for plain dividers)
  final double? height;

  const SectionDivider({
    super.key,
    this.label,
    this.labelStyle,
    this.thickness = 1.0,
    this.color,
    this.labelPadding = 16.0,
    this.topSpacing = 0.0,
    this.bottomSpacing = 0.0,
    this.indent = 0.0,
    this.endIndent = 0.0,
    this.height,
  });

  /// Creates a simple divider without any label, styled like the standard app divider
  const SectionDivider.plain({
    super.key,
    this.thickness = 1.0,
    this.color,
    this.topSpacing = 0.0,
    this.bottomSpacing = 0.0,
    this.indent = AppTypography.spacingLarge,
    this.endIndent = AppTypography.spacingLarge,
    this.height = 1.0,
  }) : label = null,
       labelStyle = null,
       labelPadding = 0.0;

  /// Creates a labeled divider with default styling
  const SectionDivider.labeled(
    this.label, {
    super.key,
    this.labelStyle,
    this.thickness = 1.0,
    this.color,
    this.labelPadding = 16.0,
    this.topSpacing = 0.0,
    this.bottomSpacing = 0.0,
    this.indent = 0.0,
    this.endIndent = 0.0,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final Widget dividerWidget = label == null
        ? _buildPlainDivider(context)
        : _buildLabeledDivider(context);

    // Wrap with spacing if needed
    if (topSpacing > 0 || bottomSpacing > 0) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (topSpacing > 0) SizedBox(height: topSpacing),
          dividerWidget,
          if (bottomSpacing > 0) SizedBox(height: bottomSpacing),
        ],
      );
    }

    return dividerWidget;
  }

  /// Builds a simple horizontal divider line using Flutter's Divider widget
  Widget _buildPlainDivider(BuildContext context) {
    return Divider(
      color: color ?? AppColors.uiDividerGrey,
      thickness: thickness,
      height: height ?? thickness,
      indent: indent,
      endIndent: endIndent,
    );
  }

  /// Builds a divider with a label in the center
  Widget _buildLabeledDivider(BuildContext context) {
    final effectiveLabelStyle =
        labelStyle ??
        Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w500,
        );

    return Row(
      children: [
        // Left divider line
        Expanded(
          child: Container(
            height: thickness,
            color: color ?? AppColors.uiDividerGrey,
          ),
        ),
        // Label text with padding
        Padding(
          padding: EdgeInsets.symmetric(horizontal: labelPadding),
          child: Text(label!, style: effectiveLabelStyle),
        ),
        // Right divider line
        Expanded(
          child: Container(
            height: thickness,
            color: color ?? AppColors.uiDividerGrey,
          ),
        ),
      ],
    );
  }
}
