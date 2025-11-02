import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_constraints.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:provider/provider.dart';

/// Dialog for adjusting simulation settings
class SettingsDialog extends StatelessWidget {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<AppState>(
      builder: (context, appState, child) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: AppConstraints.dialogRoundedBorder,
          ),
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: AppConstraints.dialogMedium,
            decoration: BoxDecoration(
              color: AppColors.uiBlack.withValues(
                alpha: AppTypography.opacityMediumHigh,
              ),
              borderRadius: AppConstraints.dialogRoundedBorder,
              border: Border.all(
                color: AppColors.uiWhite.withValues(
                  alpha: AppTypography.opacityDisabled,
                ),
                width: AppTypography.borderThin,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with gradient background
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryColor.withValues(
                          alpha: AppTypography.opacityMidFade,
                        ),
                        AppColors.primaryColor.withValues(
                          alpha: AppTypography.opacityBarely,
                        ),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: AppConstraints.dialogTopBorder,
                  ),
                  padding: EdgeInsets.all(AppTypography.spacingLarge),
                  child: Row(
                    children: [
                      Icon(
                        Icons.tune,
                        color: AppColors.primaryColor,
                        size: AppTypography.iconSizeXXXLarge,
                      ),
                      SizedBox(width: AppTypography.spacingMedium),
                      Text(
                        l10n.settingsTitle,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: AppColors.uiWhite,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close, color: AppColors.uiWhite),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: AppTypography.spacingXLarge,
                      right: AppTypography.spacingXLarge,
                      top: AppTypography.spacingXLarge,
                      bottom: AppTypography.spacingXLarge,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLanguageOption(context, l10n, appState),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    AppLocalizations l10n,
    AppState appState,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: AppTypography.spacingSmall),
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
                      l10n.languageLabel,
                      style: TextStyle(
                        color: AppColors.uiWhite,
                        fontSize: AppTypography.fontSizeLarge,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: AppTypography.spacingXSmall),
                    Text(
                      l10n.languageDescription,
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
          SizedBox(height: AppTypography.spacingLarge),
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
        ],
      ),
    );
  }
}
