import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graviton/config/flavor_config.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Right-side drawer for app options and settings
class OptionsDrawer extends StatefulWidget {
  final VoidCallback onShowHelp;
  final VoidCallback onShowSettings;
  final VoidCallback onShowScenarios;
  final VoidCallback onShowPhysicsSettings;
  final VoidCallback onShowAbout;
  final VoidCallback onShowDeveloperTools;
  final VoidCallback? onShowChangelog;

  const OptionsDrawer({
    super.key,
    required this.onShowHelp,
    required this.onShowSettings,
    required this.onShowScenarios,
    required this.onShowPhysicsSettings,
    required this.onShowAbout,
    required this.onShowDeveloperTools,
    this.onShowChangelog,
  });

  @override
  State<OptionsDrawer> createState() => _OptionsDrawerState();
}

class _OptionsDrawerState extends State<OptionsDrawer> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadVersionInfo();
  }

  Future<void> _loadVersionInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        _version = 'v${packageInfo.version}';
      });
    } catch (e) {
      // Fallback to static version if package info fails
      setState(() {
        _version = 'v1.2.0';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Drawer(
      backgroundColor: AppColors.uiBlack.withValues(
        alpha: AppTypography.opacityNearlyOpaque,
      ),
      width: 320,
      child: SafeArea(
        child: Column(
          children: [
            // Drawer header
            Container(
              padding: const EdgeInsets.all(AppTypography.spacingLarge),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.uiWhite.withValues(
                      alpha: AppTypography.opacityVeryFaint,
                    ),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    margin: const EdgeInsets.only(
                      right: AppTypography.spacingMedium,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primaryColor,
                        width: 2,
                      ),
                      image: DecorationImage(
                        image: AssetImage(AppConfig.appLogoPath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l10n.appTitle,
                          style: AppTypography.largeText.copyWith(
                            color: AppColors.uiWhite,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              _version,
                              style: AppTypography.smallText.copyWith(
                                color: AppColors.uiWhite.withValues(
                                  alpha: AppTypography.opacitySemiTransparent,
                                ),
                              ),
                            ),
                            if (_version.isNotEmpty) ...[
                              Text(
                                ' • ',
                                style: AppTypography.smallText.copyWith(
                                  color: AppColors.uiWhite.withValues(
                                    alpha: AppTypography.opacitySemiTransparent,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Close drawer first
                                  Navigator.of(context).pop();

                                  // Use the callback to let parent handle changelog dialog
                                  if (widget.onShowChangelog != null) {
                                    widget.onShowChangelog!();
                                  }
                                },
                                child: Text(
                                  l10n.changelogDebugTitle,
                                  style: AppTypography.smallText.copyWith(
                                    color: AppColors.primaryColor,
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Menu items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  vertical: AppTypography.spacingSmall,
                ),
                children: [
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.explore,
                    title: l10n.selectScenarioTooltip,
                    subtitle: l10n.scenariosMenuDescription,
                    onTap: () {
                      Navigator.of(context).pop();
                      widget.onShowScenarios();
                    },
                  ),
                  _buildDivider(),
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.science,
                    title: l10n.physicsSettingsTitle,
                    subtitle: l10n.physicsSettingsDescription,
                    onTap: () {
                      Navigator.of(context).pop();
                      widget.onShowPhysicsSettings();
                    },
                  ),
                  _buildDivider(),
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.tune,
                    title: l10n.settingsTitle,
                    subtitle: l10n.settingsMenuDescription,
                    onTap: () {
                      Navigator.of(context).pop();
                      widget.onShowSettings();
                    },
                  ),
                  _buildDivider(),
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.lightbulb_outline,
                    title: l10n.showHelpTooltip,
                    subtitle: l10n.helpMenuDescription,
                    onTap: () {
                      Navigator.of(context).pop();
                      widget.onShowHelp();
                    },
                  ),
                  _buildDivider(),

                  // Developer Tools (Debug only)
                  if (kDebugMode) ...[
                    _buildDrawerItem(
                      context: context,
                      icon: Icons.developer_mode,
                      title: l10n.developerToolsTitle,
                      subtitle: l10n.developerToolsMenuDescription,
                      onTap: () {
                        Navigator.of(context).pop();
                        widget.onShowDeveloperTools();
                      },
                    ),
                    _buildDivider(),
                  ],

                  _buildDrawerItem(
                    context: context,
                    icon: Icons.info_outline,
                    title: l10n.aboutButtonTooltip,
                    subtitle: l10n.aboutMenuDescription,
                    onTap: () {
                      Navigator.of(context).pop();
                      widget.onShowAbout();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        size: AppTypography.iconSizeXLarge,
        color: AppColors.sectionTitlePurple,
      ),
      title: Text(
        title,
        style: AppTypography.mediumText.copyWith(
          color: AppColors.uiWhite,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTypography.smallText.copyWith(
          color: AppColors.uiWhite.withValues(
            alpha: AppTypography.opacitySemiTransparent,
          ),
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppTypography.spacingLarge,
        vertical: AppTypography.spacingSmall,
      ),
      dense: false,
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: AppColors.uiDividerGrey,
      thickness: 1,
      height: 1,
      indent: AppTypography.spacingLarge,
      endIndent: AppTypography.spacingLarge,
    );
  }
}
