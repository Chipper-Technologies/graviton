import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/ui/graviton_menu_item_config.dart';
import 'package:graviton/services/firebase/firebase_service.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/core/enums/ui_action.dart';
import 'package:graviton/core/enums/ui_element.dart';

/// A reusable popup menu widget following Graviton's design system
///
/// This widget provides a consistent PopupMenuButton implementation with:
/// - Haptic feedback on selections
/// - Firebase analytics tracking
/// - Accessibility support
/// - Consistent styling and layout
class GravitonPopupMenu extends StatelessWidget {
  final String accessibilityLabel;
  final String accessibilityHint;
  final List<GravitonMenuItemConfig> menuItems;
  final void Function(String value)? onSelected;
  final UIElement analyticsElement;
  final Map<String, Object>? additionalAnalyticsParams;

  const GravitonPopupMenu({
    super.key,
    required this.accessibilityLabel,
    required this.accessibilityHint,
    required this.menuItems,
    required this.analyticsElement,
    this.onSelected,
    this.additionalAnalyticsParams,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Semantics(
      button: true,
      label: accessibilityLabel,
      hint: accessibilityHint,
      child: PopupMenuButton<String>(
        color: AppColors.uiBlack.withValues(alpha: AppColors.alphaNearlyOpaque),
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTypography.radiusSmall),
          side: BorderSide(
            color: AppColors.uiWhite.withValues(alpha: AppColors.alphaLow),
            width: 1.0,
          ),
        ),
        icon: Icon(Icons.more_vert, color: AppColors.uiWhite),
        tooltip: accessibilityLabel,
        onOpened: () {
          // Add haptic feedback when menu is opened
          HapticFeedback.lightImpact();
        },
        onSelected: (value) {
          // Add haptic feedback for menu selection
          HapticFeedback.lightImpact();

          // Log analytics for menu selection
          FirebaseService.instance.logUIEventWithEnums(
            UIAction.buttonPressed,
            element: analyticsElement,
            value: 'menu_$value',
            additionalParams: additionalAnalyticsParams,
          );

          // Find the menu item configuration and call its onTap callback
          final menuItem = menuItems.firstWhere((item) => item.value == value);
          menuItem.onTap?.call();

          // Also call the onSelected callback if provided
          onSelected?.call(value);
        },
        itemBuilder: (BuildContext context) => menuItems
            .map(
              (item) => PopupMenuItem<String>(
                value: item.value,
                height: 56, // Increased height for larger touch target
                child: Semantics(
                  label: _getLocalizedText(l10n, item.labelKey),
                  hint: _getLocalizedText(l10n, item.hintKey),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color:
                                  item.borderColor ??
                                  AppColors.primaryColor.withValues(
                                    alpha: AppColors.alphaMediumVisible,
                                  ),
                              width: 1.5,
                            ),
                          ),
                          child: Icon(
                            item.icon,
                            color: item.iconColor ?? AppColors.primaryColor,
                            size: 18,
                          ),
                        ),
                        SizedBox(width: AppTypography.spacingMedium),
                        Text(
                          _getLocalizedText(l10n, item.labelKey),
                          style: AppTypography.mediumText.copyWith(
                            color: AppColors.uiWhite,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  /// Map of localization keys to their corresponding AppLocalizations getters
  static final Map<String, String Function(AppLocalizations)> _localizationMap =
      {
        'testScenarioButton': (l10n) => l10n.testScenarioButton,
        'testScenarioHint': (l10n) => l10n.testScenarioHint,
        'viewScenarioButton': (l10n) => l10n.viewScenarioButton,
        'viewScenarioHint': (l10n) => l10n.viewScenarioHint,
        'exportScenarioButton': (l10n) => l10n.exportScenarioButton,
        'exportScenarioHint': (l10n) => l10n.exportScenarioHint,
        'duplicateBodyTooltip': (l10n) => l10n.duplicateBodyTooltip,
        'duplicateBodyAccessibility': (l10n) => l10n.duplicateBodyAccessibility,
        'editBodyButton': (l10n) => l10n.editBodyButton,
        'editBodyHint': (l10n) => l10n.editBodyHint,
        'deleteBodyTooltip': (l10n) => l10n.deleteBodyTooltip,
        'deleteBodyAccessibility': (l10n) => l10n.deleteBodyAccessibility,
        'editScenarioButton': (l10n) => l10n.editScenarioButton,
        'editScenarioHint': (l10n) => l10n.editScenarioHint,
        'deleteScenarioButton': (l10n) => l10n.deleteScenarioButton,
        'deleteScenarioHint': (l10n) => l10n.deleteScenarioHint,
        'createScenarioTitle': (l10n) => l10n.createScenarioTitle,
        'createScenarioButton': (l10n) => l10n.createScenarioButton,
        'importScenario': (l10n) => l10n.importScenario,
        'importScenarioDescription': (l10n) => l10n.importScenarioDescription,
        // Add more keys here as needed
      };

  /// Helper method to get localized text by key name
  String _getLocalizedText(AppLocalizations l10n, String key) {
    final getter = _localizationMap[key];
    if (getter != null) {
      return getter(l10n);
    }
    return key; // Fallback to the key itself if not found
  }
}
