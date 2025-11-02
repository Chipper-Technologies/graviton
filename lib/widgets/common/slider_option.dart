import 'package:flutter/material.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';

/// A reusable slider widget component used across various dialogs and bottom sheets.
///
/// Supports two variants:
/// - Simple: Icon + label with minimal styling (used in body properties)
/// - Detailed: Icon + label + value display with enhanced container styling (used in simulation settings)
class SliderOption extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final IconData icon;
  final ValueChanged<double> onChanged;
  final String Function(double)? formatter;
  final bool isDetailed;

  const SliderOption({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.icon,
    required this.onChanged,
    this.formatter,
    this.isDetailed = false,
  });

  /// Creates a simple slider variant with minimal styling
  const SliderOption.simple({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.icon,
    required this.onChanged,
  }) : formatter = null,
       isDetailed = false;

  /// Creates a detailed slider variant with enhanced container styling and value display
  const SliderOption.detailed({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.icon,
    required this.onChanged,
    required this.formatter,
  }) : isDetailed = true;

  @override
  Widget build(BuildContext context) {
    // Clamp the value to ensure it's within the valid range
    // This prevents slider assertion errors when values are outside bounds
    final clampedValue = value.clamp(min, max);

    if (isDetailed) {
      return _buildDetailedSlider(context, clampedValue);
    } else {
      return _buildSimpleSlider(context, clampedValue);
    }
  }

  Widget _buildSimpleSlider(BuildContext context, double clampedValue) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        const SizedBox(height: AppTypography.spacingXSmall),
        SizedBox(
          width: double.infinity,
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              inactiveTrackColor: Theme.of(context).colorScheme.onSurface
                  .withValues(alpha: AppTypography.opacityVeryFaint),
              activeTrackColor: Theme.of(context).colorScheme.primary,
            ),
            child: Slider(
              value: clampedValue,
              min: min,
              max: max,
              divisions: divisions,
              label: label,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailedSlider(BuildContext context, double clampedValue) {
    return Container(
      margin: EdgeInsets.only(bottom: AppTypography.spacingLarge),
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
              Container(
                padding: EdgeInsets.all(AppTypography.spacingMedium),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(
                    alpha: AppTypography.opacityFaint,
                  ),
                  borderRadius: BorderRadius.circular(
                    AppTypography.radiusMedium,
                  ),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primaryColor,
                  size: AppTypography.iconSizeLarge,
                ),
              ),
              SizedBox(width: AppTypography.spacingLarge),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: AppColors.uiWhite,
                    fontSize: AppTypography.fontSizeLarge,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (formatter != null)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppTypography.spacingMedium,
                    vertical: AppTypography.spacingSmall,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.uiBlack.withValues(
                      alpha: AppTypography.opacityMedium,
                    ),
                    borderRadius: BorderRadius.circular(
                      AppTypography.radiusSmall,
                    ),
                  ),
                  child: Text(
                    formatter!(clampedValue),
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: AppTypography.fontSizeMedium,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: AppTypography.spacingLarge),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.primaryColor,
              inactiveTrackColor: AppColors.primaryColor.withValues(
                alpha: AppTypography.opacityFaint,
              ),
              thumbColor: AppColors.primaryColor,
              overlayColor: AppColors.primaryColor.withValues(
                alpha: AppTypography.opacityFaint,
              ),
              trackHeight: 6.0,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 20.0),
              valueIndicatorColor: AppColors.primaryColor,
              valueIndicatorTextStyle: TextStyle(
                color: AppColors.uiWhite,
                fontSize: AppTypography.fontSizeSmall,
                fontWeight: FontWeight.w600,
              ),
            ),
            child: Slider(
              value: clampedValue,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
