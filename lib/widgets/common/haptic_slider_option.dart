import 'package:flutter/material.dart';
import 'package:graviton/services/haptic_feedback_service.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';

/// A haptic-enabled slider widget component used across various dialogs and bottom sheets.
///
/// Provides tactile feedback for value changes, threshold crossings, and significant modifications.
/// Supports two variants:
/// - Simple: Icon + label with minimal styling (used in body properties)
/// - Detailed: Icon + label + value display with enhanced container styling (used in simulation settings)
class HapticSliderOption extends StatefulWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final IconData icon;
  final ValueChanged<double> onChanged;
  final String Function(double)? formatter;
  final bool isDetailed;

  const HapticSliderOption({
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

  /// Creates a simple haptic slider variant with minimal styling
  const HapticSliderOption.simple({
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

  /// Creates a detailed haptic slider variant with enhanced container styling and value display
  const HapticSliderOption.detailed({
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
  State<HapticSliderOption> createState() => _HapticSliderOptionState();
}

class _HapticSliderOptionState extends State<HapticSliderOption> {
  double? _previousValue;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _previousValue = widget.value;
  }

  void _onSliderChanged(double newValue) {
    // Provide haptic feedback for value changes
    if (!_isDragging) {
      // Initial drag start - light feedback
      HapticFeedbackService.instance.lightImpact();
      _isDragging = true;
    } else {
      // Check for significant value changes during drag
      if (_previousValue != null) {
        final change = (newValue - _previousValue!).abs();
        final range = widget.max - widget.min;
        final changePercent = change / range;

        // Provide feedback for significant changes (>5% of range)
        if (changePercent > 0.05) {
          HapticFeedbackService.instance.selectionClick();
        }

        // Special feedback for crossing major thresholds
        _checkThresholdCrossing(_previousValue!, newValue);
      }
    }

    _previousValue = newValue;
    widget.onChanged(newValue);
  }

  void _onSliderEnd(double finalValue) {
    // End of drag - confirmation feedback
    if (_isDragging) {
      HapticFeedbackService.instance.lightImpact();
      _isDragging = false;
    }
  }

  void _checkThresholdCrossing(double oldValue, double newValue) {
    final range = widget.max - widget.min;
    final thirdPoint = widget.min + (range / 3);
    final twoThirdPoint = widget.min + (2 * range / 3);

    // Check if we crossed major threshold points (33% and 66% of range)
    if ((oldValue < thirdPoint && newValue >= thirdPoint) ||
        (oldValue >= thirdPoint && newValue < thirdPoint) ||
        (oldValue < twoThirdPoint && newValue >= twoThirdPoint) ||
        (oldValue >= twoThirdPoint && newValue < twoThirdPoint)) {
      HapticFeedbackService.instance.mediumImpact();
    }

    // Special feedback for reaching extremes
    if ((oldValue > widget.min && newValue <= widget.min) ||
        (oldValue < widget.max && newValue >= widget.max)) {
      HapticFeedbackService.instance.heavyImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Clamp the value to ensure it's within the valid range
    // This prevents slider assertion errors when values are outside bounds
    final clampedValue = widget.value.clamp(widget.min, widget.max);

    if (widget.isDetailed) {
      return _buildDetailedSlider(context, clampedValue);
    } else {
      return _buildSimpleSlider(context, clampedValue);
    }
  }

  Widget _buildSimpleSlider(BuildContext context, double clampedValue) {
    final increment = (widget.max - widget.min) / widget.divisions;

    return Column(
      children: [
        Row(
          children: [
            Icon(widget.icon, size: AppTypography.iconSizeXLarge),
            const SizedBox(width: 8),
            Text(widget.label, style: Theme.of(context).textTheme.bodyMedium),
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
            child: Semantics(
              label: widget.label,
              value:
                  widget.formatter?.call(clampedValue) ??
                  clampedValue.toStringAsFixed(1),
              increasedValue:
                  widget.formatter?.call(
                    (clampedValue + increment).clamp(widget.min, widget.max),
                  ) ??
                  (clampedValue + increment)
                      .clamp(widget.min, widget.max)
                      .toStringAsFixed(1),
              decreasedValue:
                  widget.formatter?.call(
                    (clampedValue - increment).clamp(widget.min, widget.max),
                  ) ??
                  (clampedValue - increment)
                      .clamp(widget.min, widget.max)
                      .toStringAsFixed(1),
              onIncrease: () {
                final newValue = (clampedValue + increment).clamp(
                  widget.min,
                  widget.max,
                );
                widget.onChanged(newValue);
              },
              onDecrease: () {
                final newValue = (clampedValue - increment).clamp(
                  widget.min,
                  widget.max,
                );
                widget.onChanged(newValue);
              },
              child: Slider(
                value: clampedValue,
                min: widget.min,
                max: widget.max,
                divisions: widget.divisions,
                label: widget.label,
                onChanged: _onSliderChanged,
                onChangeEnd: _onSliderEnd,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailedSlider(BuildContext context, double clampedValue) {
    final increment = (widget.max - widget.min) / widget.divisions;

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
                  widget.icon,
                  color: AppColors.primaryColor,
                  size: AppTypography.iconSizeLarge,
                ),
              ),
              SizedBox(width: AppTypography.spacingLarge),
              Expanded(
                child: Text(
                  widget.label,
                  style: TextStyle(
                    color: AppColors.uiWhite,
                    fontSize: AppTypography.fontSizeLarge,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (widget.formatter != null)
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
                    widget.formatter!(clampedValue),
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
            child: Semantics(
              label: widget.label,
              value:
                  widget.formatter?.call(clampedValue) ??
                  clampedValue.toStringAsFixed(1),
              increasedValue:
                  widget.formatter?.call(
                    (clampedValue + increment).clamp(widget.min, widget.max),
                  ) ??
                  (clampedValue + increment)
                      .clamp(widget.min, widget.max)
                      .toStringAsFixed(1),
              decreasedValue:
                  widget.formatter?.call(
                    (clampedValue - increment).clamp(widget.min, widget.max),
                  ) ??
                  (clampedValue - increment)
                      .clamp(widget.min, widget.max)
                      .toStringAsFixed(1),
              onIncrease: () {
                final newValue = (clampedValue + increment).clamp(
                  widget.min,
                  widget.max,
                );
                widget.onChanged(newValue);
              },
              onDecrease: () {
                final newValue = (clampedValue - increment).clamp(
                  widget.min,
                  widget.max,
                );
                widget.onChanged(newValue);
              },
              child: Slider(
                value: clampedValue,
                min: widget.min,
                max: widget.max,
                divisions: widget.divisions,
                onChanged: _onSliderChanged,
                onChangeEnd: _onSliderEnd,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
