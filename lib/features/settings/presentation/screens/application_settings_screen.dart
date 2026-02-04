import 'package:flutter/material.dart';
import 'package:graviton/core/enums/temperature_unit.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_constraints.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/utils/haptic_utils.dart';
import 'package:graviton/widgets/common/section_divider.dart';
import 'package:graviton/widgets/haptics/haptic_app_bar.dart';
import 'package:graviton/widgets/haptics/haptic_switch.dart';
import 'package:provider/provider.dart';

/// Full-screen Application Settings page
class ApplicationSettingsScreen extends StatelessWidget {
  const ApplicationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<AppState>(
      builder: (context, appState, child) {
        return Scaffold(
          backgroundColor: AppColors.transparentColor,
          appBar: HapticAppBar(title: l10n.settingsTooltip),
          body: SafeArea(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.uiBlack.withValues(
                  alpha: AppTypography.opacityNearlyOpaque,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(AppTypography.spacingLarge),
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: AppConstraints.contentMaxWidth,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // General Settings Section (Language and Temperature Units)
                                SectionDivider.labeled(
                                  l10n.languageLabel,
                                  bottomSpacing: AppTypography.spacingMedium,
                                ),
                                _buildGeneralOptions(context, l10n, appState),

                                // Haptic Feedback Settings Section
                                SectionDivider.labeled(
                                  l10n.hapticsSection,
                                  topSpacing: AppTypography.spacingMedium,
                                  bottomSpacing: AppTypography.spacingMedium,
                                ),
                                _buildUIHapticFeedbackOption(
                                  context,
                                  l10n,
                                  appState,
                                ),
                                const SizedBox(
                                  height: AppTypography.spacingMedium,
                                ),
                                _buildCollisionHapticFeedbackOption(
                                  context,
                                  l10n,
                                  appState,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGeneralOptions(
    BuildContext context,
    AppLocalizations l10n,
    AppState appState,
  ) {
    return Container(
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
          // Language Setting
          Row(
            children: [
              Icon(
                Icons.language,
                color: AppColors.primaryColor,
                size: AppTypography.iconSizeXXLarge,
              ),
              SizedBox(width: AppTypography.spacingLarge),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.languageDescription,
                      style: TextStyle(
                        color: AppColors.uiWhite,
                        fontSize: AppTypography.fontSizeLarge,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: AppTypography.spacingXSmall),
                    Text(
                      l10n.languageSelectionHint,
                      style: TextStyle(
                        color: AppColors.uiWhite.withValues(
                          alpha: AppTypography.opacityHigh,
                        ),
                        fontSize: AppTypography.fontSizeMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppTypography.spacingMedium),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: AppTypography.spacingMedium,
              vertical: AppTypography.spacingSmall,
            ),
            decoration: BoxDecoration(
              color: AppColors.uiBlack.withValues(
                alpha: AppTypography.opacityMedium,
              ),
              borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
              border: Border.all(
                color: AppColors.primaryColor.withValues(
                  alpha: AppTypography.opacityMedium,
                ),
                width: AppTypography.borderThin,
              ),
            ),
            child: DropdownButton<String?>(
              value: appState.ui.selectedLanguageCode,
              underline: Container(),
              isExpanded: true,
              dropdownColor: AppColors.uiBlack,
              style: TextStyle(
                color: AppColors.uiWhite,
                fontSize: AppTypography.fontSizeMedium,
              ),
              onChanged: (String? newValue) {
                // Add haptic feedback for language selection
                HapticUtils.navigate();
                appState.ui.setLanguage(newValue);
              },
              items: [
                DropdownMenuItem<String?>(
                  value: null,
                  child: Text(
                    l10n.languageSystem,
                    style: TextStyle(color: AppColors.uiWhite),
                  ),
                ),
                DropdownMenuItem<String?>(
                  value: 'en',
                  child: Text(
                    l10n.languageEnglish,
                    style: TextStyle(color: AppColors.uiWhite),
                  ),
                ),
                DropdownMenuItem<String?>(
                  value: 'de',
                  child: Text(
                    l10n.languageGerman,
                    style: TextStyle(color: AppColors.uiWhite),
                  ),
                ),
                DropdownMenuItem<String?>(
                  value: 'es',
                  child: Text(
                    l10n.languageSpanish,
                    style: TextStyle(color: AppColors.uiWhite),
                  ),
                ),
                DropdownMenuItem<String?>(
                  value: 'fr',
                  child: Text(
                    l10n.languageFrench,
                    style: TextStyle(color: AppColors.uiWhite),
                  ),
                ),
                DropdownMenuItem<String?>(
                  value: 'zh',
                  child: Text(
                    l10n.languageChinese,
                    style: TextStyle(color: AppColors.uiWhite),
                  ),
                ),
                DropdownMenuItem<String?>(
                  value: 'ja',
                  child: Text(
                    l10n.languageJapanese,
                    style: TextStyle(color: AppColors.uiWhite),
                  ),
                ),
                DropdownMenuItem<String?>(
                  value: 'ko',
                  child: Text(
                    l10n.languageKorean,
                    style: TextStyle(color: AppColors.uiWhite),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: AppTypography.spacingXLarge),

          // Temperature Unit Setting
          Row(
            children: [
              Icon(
                Icons.thermostat,
                color: AppColors.primaryColor,
                size: AppTypography.iconSizeXXLarge,
              ),
              SizedBox(width: AppTypography.spacingLarge),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.temperatureUnitsLabel,
                      style: TextStyle(
                        color: AppColors.uiWhite,
                        fontSize: AppTypography.fontSizeLarge,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: AppTypography.spacingXSmall),
                    Text(
                      l10n.temperatureUnitsDescription,
                      style: TextStyle(
                        color: AppColors.uiWhite.withValues(
                          alpha: AppTypography.opacityHigh,
                        ),
                        fontSize: AppTypography.fontSizeMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppTypography.spacingMedium),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: AppTypography.spacingMedium,
              vertical: AppTypography.spacingSmall,
            ),
            decoration: BoxDecoration(
              color: AppColors.uiBlack.withValues(
                alpha: AppTypography.opacityMedium,
              ),
              borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
              border: Border.all(
                color: AppColors.primaryColor.withValues(
                  alpha: AppTypography.opacityMedium,
                ),
                width: AppTypography.borderThin,
              ),
            ),
            child: DropdownButton<String>(
              value: appState.ui.temperatureUnit.name,
              underline: Container(),
              isExpanded: true,
              dropdownColor: AppColors.uiBlack,
              style: TextStyle(
                color: AppColors.uiWhite,
                fontSize: AppTypography.fontSizeMedium,
              ),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  // Add haptic feedback for temperature unit selection
                  HapticUtils.navigate();
                  final unit = TemperatureUnit.fromString(newValue);
                  appState.ui.setTemperatureUnit(unit);
                }
              },
              items: [
                DropdownMenuItem<String>(
                  value: 'celsius',
                  child: Text(
                    l10n.temperatureUnitCelsiusName,
                    style: TextStyle(color: AppColors.uiWhite),
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'fahrenheit',
                  child: Text(
                    l10n.temperatureUnitFahrenheitName,
                    style: TextStyle(color: AppColors.uiWhite),
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'kelvin',
                  child: Text(
                    l10n.temperatureUnitKelvinName,
                    style: TextStyle(color: AppColors.uiWhite),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUIHapticFeedbackOption(
    BuildContext context,
    AppLocalizations l10n,
    AppState appState,
  ) {
    return Container(
      padding: EdgeInsets.all(AppTypography.spacingLarge),
      decoration: BoxDecoration(
        color: appState.ui.enableUIHapticFeedback
            ? AppColors.primaryColor.withValues(
                alpha: AppTypography.opacityMidFade,
              )
            : AppColors.uiWhite.withValues(alpha: AppTypography.opacityBarely),
        borderRadius: BorderRadius.circular(AppTypography.radiusLarge),
        border: appState.ui.enableUIHapticFeedback
            ? Border.all(
                color: AppColors.primaryColor,
                width: AppTypography.borderThin,
              )
            : Border.all(
                color: AppColors.uiWhite.withValues(
                  alpha: AppTypography.opacityDisabled,
                ),
                width: AppTypography.borderThin,
              ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.touch_app,
            color: appState.ui.enableUIHapticFeedback
                ? AppColors.primaryColor
                : AppColors.uiWhite.withValues(
                    alpha: AppTypography.opacityMedium,
                  ),
            size: AppTypography.iconSizeXXLarge,
          ),
          SizedBox(width: AppTypography.spacingLarge),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.uiHapticFeedback,
                  style: TextStyle(
                    color: appState.ui.enableUIHapticFeedback
                        ? AppColors.primaryColor
                        : AppColors.uiWhite,
                    fontSize: AppTypography.fontSizeLarge,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppTypography.spacingXSmall),
                Text(
                  l10n.uiHapticFeedbackDescription,
                  style: TextStyle(
                    color: AppColors.uiWhite.withValues(
                      alpha: AppTypography.opacityHigh,
                    ),
                    fontSize: AppTypography.fontSizeMedium,
                  ),
                ),
              ],
            ),
          ),
          HapticSwitch(
            value: appState.ui.enableUIHapticFeedback,
            onChanged: (bool value) {
              // Haptic feedback is already handled by HapticSwitch
              appState.ui.toggleUIHapticFeedback();
            },
            activeColor: AppColors.primaryColor,
            inactiveThumbColor: AppColors.uiWhite.withValues(
              alpha: AppTypography.opacityMedium,
            ),
            inactiveTrackColor: AppColors.uiBlack.withValues(
              alpha: AppTypography.opacityMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollisionHapticFeedbackOption(
    BuildContext context,
    AppLocalizations l10n,
    AppState appState,
  ) {
    return Container(
      padding: EdgeInsets.all(AppTypography.spacingLarge),
      decoration: BoxDecoration(
        color: appState.ui.enableCollisionHapticFeedback
            ? AppColors.primaryColor.withValues(
                alpha: AppTypography.opacityMidFade,
              )
            : AppColors.uiWhite.withValues(alpha: AppTypography.opacityBarely),
        borderRadius: BorderRadius.circular(AppTypography.radiusLarge),
        border: appState.ui.enableCollisionHapticFeedback
            ? Border.all(
                color: AppColors.primaryColor,
                width: AppTypography.borderThin,
              )
            : Border.all(
                color: AppColors.uiWhite.withValues(
                  alpha: AppTypography.opacityDisabled,
                ),
                width: AppTypography.borderThin,
              ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.vibration,
            color: appState.ui.enableCollisionHapticFeedback
                ? AppColors.primaryColor
                : AppColors.uiWhite.withValues(
                    alpha: AppTypography.opacityMedium,
                  ),
            size: AppTypography.iconSizeXXLarge,
          ),
          SizedBox(width: AppTypography.spacingLarge),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.collisionHapticFeedback,
                  style: TextStyle(
                    color: appState.ui.enableCollisionHapticFeedback
                        ? AppColors.primaryColor
                        : AppColors.uiWhite,
                    fontSize: AppTypography.fontSizeLarge,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppTypography.spacingXSmall),
                Text(
                  l10n.collisionHapticFeedbackDescription,
                  style: TextStyle(
                    color: AppColors.uiWhite.withValues(
                      alpha: AppTypography.opacityHigh,
                    ),
                    fontSize: AppTypography.fontSizeMedium,
                  ),
                ),
              ],
            ),
          ),
          HapticSwitch(
            value: appState.ui.enableCollisionHapticFeedback,
            onChanged: (bool value) {
              // Haptic feedback is already handled by HapticSwitch
              appState.ui.toggleCollisionHapticFeedback();
            },
            activeColor: AppColors.primaryColor,
            inactiveThumbColor: AppColors.uiWhite.withValues(
              alpha: AppTypography.opacityMedium,
            ),
            inactiveTrackColor: AppColors.uiBlack.withValues(
              alpha: AppTypography.opacityMedium,
            ),
          ),
        ],
      ),
    );
  }
}
