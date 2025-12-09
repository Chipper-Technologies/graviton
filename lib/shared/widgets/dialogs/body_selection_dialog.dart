import 'package:flutter/material.dart';
import 'package:graviton/core/enums/ui_action.dart';
import 'package:graviton/core/enums/ui_element.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/celestial/body.dart';
import 'package:graviton/services/firebase/firebase_service.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/common/dialog_title.dart';
import 'package:graviton/widgets/haptics/haptic_elevated_button.dart';
import 'package:graviton/widgets/haptics/haptic_gesture_detector.dart';

/// Dialog that displays a list of celestial bodies for selection
class BodySelectionDialog extends StatefulWidget {
  /// List of bodies to display for selection
  final List<Body> bodies;

  /// Currently selected body index (if any)
  final int? selectedIndex;

  /// Callback when a body is selected
  final ValueChanged<int> onBodySelected;

  const BodySelectionDialog({
    super.key,
    required this.bodies,
    this.selectedIndex,
    required this.onBodySelected,
  });

  /// Show the body selection dialog and return the selected index
  static Future<int?> show({
    required BuildContext context,
    required List<Body> bodies,
    int? selectedIndex,
  }) {
    return showDialog<int>(
      context: context,
      builder: (context) => BodySelectionDialog(
        bodies: bodies,
        selectedIndex: selectedIndex,
        onBodySelected: (index) => Navigator.of(context).pop(index),
      ),
    );
  }

  @override
  State<BodySelectionDialog> createState() => _BodySelectionDialogState();
}

class _BodySelectionDialogState extends State<BodySelectionDialog> {
  int? _hoveredIndex;
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;

    // Track dialog opening
    FirebaseService.instance.logUIEventWithEnums(
      UIAction.dialogOpened,
      element: UIElement.bodySelection,
      value: 'body_selection_opened',
      additionalParams: {
        'body_count': widget.bodies.length.toString(),
        'has_selection': (widget.selectedIndex != null).toString(),
      },
    );
  }

  void _selectBody(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Track selection
    FirebaseService.instance.logUIEventWithEnums(
      UIAction.bodySelected,
      element: UIElement.bodySelection,
      value: widget.bodies[index].name,
      additionalParams: {
        'body_index': index.toString(),
        'body_type': widget.bodies[index].bodyType.toString(),
      },
    );

    widget.onBodySelected(index);
  }

  void _cancel() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      backgroundColor: AppColors.uiBlack.withValues(
        alpha: AppTypography.opacityAlmostOpaque,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTypography.radiusXLarge),
        side: BorderSide(
          color: AppColors.primaryColor.withValues(
            alpha: AppTypography.opacityFaint,
          ),
          width: 1,
        ),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            _buildHeader(l10n),

            // Body list
            Expanded(
              child: widget.bodies.isEmpty
                  ? _buildEmptyState(l10n)
                  : _buildBodyList(),
            ),

            // Footer with cancel button
            _buildFooter(l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l10n) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(
          alpha: AppTypography.opacityDisabled,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppTypography.radiusXLarge),
          topRight: Radius.circular(AppTypography.radiusXLarge),
        ),
      ),
      padding: EdgeInsets.all(AppTypography.spacingLarge),
      child: DialogTitle(
        title: l10n.selectBody,
        icon: Icons.public,
        iconColor: AppColors.primaryColor,
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppTypography.spacingXLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.info_outline,
              size: 64,
              color: AppColors.uiWhite.withValues(
                alpha: AppTypography.opacityMedium,
              ),
            ),
            SizedBox(height: AppTypography.spacingLarge),
            Text(
              l10n.noBodiesAvailable,
              style: AppTypography.mediumText.copyWith(
                color: AppColors.uiWhite.withValues(
                  alpha: AppTypography.opacityMedium,
                ),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: AppTypography.spacingMedium,
        vertical: AppTypography.spacingSmall,
      ),
      itemCount: widget.bodies.length,
      itemBuilder: (context, index) {
        return _buildBodyItem(index);
      },
    );
  }

  Widget _buildBodyItem(int index) {
    final body = widget.bodies[index];
    final isSelected = _selectedIndex == index;
    final isHovered = _hoveredIndex == index;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppTypography.spacingXSmall),
      child: HapticGestureDetector(
        onTap: () => _selectBody(index),
        child: MouseRegion(
          onEnter: (_) => setState(() => _hoveredIndex = index),
          onExit: (_) => setState(() => _hoveredIndex = null),
          cursor: SystemMouseCursors.click,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryColor.withValues(
                      alpha: AppTypography.opacityVeryFaint,
                    )
                  : isHovered
                  ? AppColors.uiWhite.withValues(
                      alpha: AppTypography.opacityFaint,
                    )
                  : AppColors.transparentColor,
              borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
              border: Border.all(
                color: isSelected
                    ? AppColors.primaryColor.withValues(
                        alpha: AppTypography.opacityMediumHigh,
                      )
                    : AppColors.uiWhite.withValues(
                        alpha: AppTypography.opacityFaint,
                      ),
                width: isSelected ? 2 : 1,
              ),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: AppTypography.spacingMedium,
              vertical: AppTypography.spacingMedium,
            ),
            child: Row(
              children: [
                // Body color indicator
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: body.color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.uiWhite.withValues(
                        alpha: AppTypography.opacityMedium,
                      ),
                      width: 1,
                    ),
                  ),
                ),
                SizedBox(width: AppTypography.spacingMedium),

                // Body name and type
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        body.name,
                        style: AppTypography.mediumText.copyWith(
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: AppColors.uiWhite,
                        ),
                      ),
                      if (body.isPlanet) ...[
                        SizedBox(height: AppTypography.spacingXSmall),
                        Text(
                          body.bodyType.toString().split('.').last,
                          style: AppTypography.smallText.copyWith(
                            color: AppColors.uiWhite.withValues(
                              alpha: AppTypography.opacityMediumHigh,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Selected indicator
                if (isSelected) ...[
                  SizedBox(width: AppTypography.spacingMedium),
                  Icon(
                    Icons.check_circle,
                    color: AppColors.primaryColor,
                    size: 24,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(AppLocalizations l10n) {
    return Container(
      padding: EdgeInsets.all(AppTypography.spacingLarge),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          HapticElevatedButton(
            onPressed: _cancel,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.transparentColor,
              foregroundColor: AppColors.uiWhite.withValues(
                alpha: AppTypography.opacityMediumHigh,
              ),
              elevation: 0,
              padding: EdgeInsets.symmetric(
                horizontal: AppTypography.spacingXLarge,
                vertical: AppTypography.spacingMedium,
              ),
            ),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }
}
