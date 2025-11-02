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
            borderRadius: BorderRadius.circular(AppTypography.radiusXLarge),
          ),
          child: Container(
            constraints: AppConstraints.dialogMedium,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title with close button
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.uiOrangeAccent.withValues(
                          alpha: AppTypography.opacityMidFade,
                        ),
                        AppColors.uiOrangeAccent.withValues(
                          alpha: AppTypography.opacityBarely,
                        ),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppTypography.radiusXLarge),
                      topRight: Radius.circular(AppTypography.radiusXLarge),
                    ),
                  ),
                  padding: EdgeInsets.all(AppTypography.spacingLarge),
                  child: Row(
                    children: [
                      Icon(
                        Icons.tune,
                        color: AppColors.uiOrangeAccent,
                        size: 28,
                      ),
                      SizedBox(width: AppTypography.spacingMedium),
                      Text(
                        l10n.settingsTitle,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                // Scrollable content
                Flexible(
                  child: Padding(
                    padding: AppConstraints.dialogPadding,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Language Section
                          Text(
                            l10n.languageLabel,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(color: AppColors.sectionTitlePurple),
                          ),
                          SizedBox(height: AppTypography.spacingSmall),

                          // Language Selection
                          Container(
                            padding: EdgeInsets.all(AppTypography.spacingLarge),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.uiBorderGrey),
                              borderRadius: BorderRadius.circular(
                                AppTypography.radiusMedium,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header with icon and text
                                Row(
                                  children: [
                                    const Icon(Icons.language),
                                    SizedBox(
                                      width: AppTypography.spacingMedium,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(l10n.languageLabel),
                                          Text(
                                            l10n.languageDescription,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  color: AppColors.uiWhite
                                                      .withValues(
                                                        alpha: AppTypography
                                                            .opacitySemiTransparent,
                                                      ),
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: AppTypography.spacingMedium),
                                // Dropdown below
                                SizedBox(
                                  width: double.infinity,
                                  child: DropdownButton<String?>(
                                    value: appState.ui.selectedLanguageCode,
                                    underline: Container(),
                                    isExpanded: true,
                                    onChanged: (String? newValue) {
                                      appState.ui.setLanguage(newValue);
                                    },
                                    items: [
                                      DropdownMenuItem<String?>(
                                        value: null,
                                        child: Text(l10n.languageSystem),
                                      ),
                                      DropdownMenuItem<String?>(
                                        value: 'en',
                                        child: Text(l10n.languageEnglish),
                                      ),
                                      DropdownMenuItem<String?>(
                                        value: 'de',
                                        child: Text(l10n.languageGerman),
                                      ),
                                      DropdownMenuItem<String?>(
                                        value: 'es',
                                        child: Text(l10n.languageSpanish),
                                      ),
                                      DropdownMenuItem<String?>(
                                        value: 'fr',
                                        child: Text(l10n.languageFrench),
                                      ),
                                      DropdownMenuItem<String?>(
                                        value: 'zh',
                                        child: Text(l10n.languageChinese),
                                      ),
                                      DropdownMenuItem<String?>(
                                        value: 'ja',
                                        child: Text(l10n.languageJapanese),
                                      ),
                                      DropdownMenuItem<String?>(
                                        value: 'ko',
                                        child: Text(l10n.languageKorean),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
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
}
