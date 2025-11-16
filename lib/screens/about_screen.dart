import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graviton/config/flavor_config.dart';
import 'package:graviton/enums/version_status.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/services/version_service.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/utils/clipboard_utils.dart';
import 'package:graviton/widgets/common/graviton_snack_bar.dart';
import 'package:graviton/widgets/haptics/haptic_app_bar.dart';
import 'package:graviton/widgets/haptics/haptic_ink_well.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// Full-screen About page displaying app information and credits
class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  PackageInfo? _packageInfo;

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      debugPrint(
        'Package info loaded: ${packageInfo.version}+${packageInfo.buildNumber}',
      );
      if (mounted) {
        setState(() {
          _packageInfo = packageInfo;
        });
      }
    } catch (e) {
      debugPrint('Error loading package info: $e');
      if (mounted) {
        setState(() {
          _packageInfo = PackageInfo(
            appName: 'Graviton',
            packageName: 'io.chipper.graviton',
            version: '1.0.0',
            buildNumber: '1',
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.transparentColor,
      appBar: HapticAppBar(title: l10n.aboutButtonTooltip),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: AppColors.uiBlack.withValues(
            alpha: AppTypography.opacityNearlyOpaque,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppTypography.spacingLarge),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  children: [
                    // Large centered logo
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.uiWhiteBorder.withValues(
                            alpha: AppTypography.opacityVeryFaint,
                          ),
                          width: 2,
                        ),
                        image: DecorationImage(
                          image: AssetImage(AppConfig.appLogoPath),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppTypography.spacingXLarge),

                    // Centered app name
                    Text(
                      l10n.appTitle,
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.uiWhite,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppTypography.spacingMedium),

                    // Centered version with status color
                    if (_packageInfo != null)
                      _buildVersionInfo(context, theme, l10n)
                    else
                      Text(
                        l10n.loadingVersion,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: AppTypography.opacityHigh,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    const SizedBox(height: AppTypography.spacingMedium),

                    // Description
                    Text(
                      l10n.appDescription,
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppTypography.spacingXXLarge),

                    // Author Section with Chipper Logo
                    _buildInfoSection(
                      context,
                      icon: Icons.business,
                      title: l10n.authorLabel,
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            AppConfig.chipperLogoPath,
                            width: 20,
                            height: 20,
                          ),
                          const SizedBox(width: AppTypography.spacingSmall),
                          Flexible(
                            child: Text(
                              l10n.companyName,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppTypography.spacingLarge),

                    // Website Section
                    _buildInfoSection(
                      context,
                      icon: Icons.language,
                      title: l10n.websiteLabel,
                      child: HapticInkWell(
                        onTap: () => _launchUrl(AppConfig.githubUrl),
                        child: Text(
                          AppConfig.githubUrl,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            decoration: TextDecoration.underline,
                            decorationColor: theme.colorScheme.primary
                                .withValues(
                                  alpha: AppTypography.opacityMediumHigh,
                                ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppTypography.spacingMedium),

                    // Privacy Policy Section
                    _buildInfoSection(
                      context,
                      icon: Icons.privacy_tip,
                      title: l10n.privacyPolicyLabel,
                      child: HapticInkWell(
                        onTap: () => _launchUrl(AppConfig.privacyPolicyUrl),
                        child: Text(
                          AppConfig.privacyPolicyUrl,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            decoration: TextDecoration.underline,
                            decorationColor: theme.colorScheme.primary
                                .withValues(
                                  alpha: AppTypography.opacityMediumHigh,
                                ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppTypography.spacingXXLarge),

                    // Copyright Section
                    _buildInfoSection(
                      context,
                      icon: Icons.copyright,
                      title: l10n.copyrightLabel,
                      child: Text(
                        '© ${DateTime.now().year} ${l10n.companyName}. ${l10n.allRightsReserved}.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                    const SizedBox(height: AppTypography.spacingXXLarge),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: AppTypography.iconSizeXLarge,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: AppTypography.spacingMedium),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.uiTextGrey,
                ),
              ),
              const SizedBox(height: AppTypography.spacingXXSmall),
              child,
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          GravitonSnackBar.warning(
            context: context,
            message: l10n.couldNotOpenUrl(url),
            actionLabel: l10n.copyButton,
            onActionPressed: () {
              // Copy URL to clipboard as fallback
              ClipboardUtils.copyToClipboardSilent(url);
            },
          );
        }
      }
    } catch (e) {
      debugPrint('Could not launch URL: $url, error: $e');
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        GravitonSnackBar.error(
          context: context,
          message: l10n.errorOpeningLink(e.toString()),
          actionLabel: l10n.copyButton,
          onActionPressed: () {
            ClipboardUtils.copyToClipboardSilent(url);
          },
        );
      }
    }
  }

  /// Build version info with status color and upgrade link if needed
  Widget _buildVersionInfo(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    final versionStatus = VersionService.instance.getVersionStatus();
    final versionText =
        '${l10n.versionLabel} ${_packageInfo!.version}+${_packageInfo!.buildNumber}';

    // Determine badge properties based on version status
    late Color badgeColor;
    late String badgeText;

    switch (versionStatus) {
      case VersionStatus.current:
        badgeColor = AppColors.uiStatusGreen;
        badgeText = l10n.versionStatusCurrent;
        break;
      case VersionStatus.beta:
        badgeColor = AppColors.basicBlue;
        badgeText = l10n.bodyBeta;
        break;
      case VersionStatus.outdated:
        badgeColor = AppColors.uiRed;
        badgeText = l10n.versionStatusOutdated;
        break;
    }

    return Column(
      children: [
        Text(
          versionText,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppTypography.spacingSmall),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTypography.spacingSmall,
            vertical: AppTypography.spacingXSmall,
          ),
          decoration: BoxDecoration(
            color: badgeColor,
            borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
          ),
          child: Text(
            badgeText,
            style: TextStyle(
              color: AppColors.uiWhite,
              fontSize: AppTypography.fontSizeMedium,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Show upgrade link for outdated versions
        if (versionStatus == VersionStatus.outdated &&
            VersionService.instance.getStoreUrl() != null) ...[
          const SizedBox(height: AppTypography.spacingLarge),
          ElevatedButton.icon(
            onPressed: () => VersionService.instance.launchStore(),
            icon: Icon(
              Icons.open_in_new,
              size: AppTypography.iconSizeLarge,
              color: AppColors.uiWhite,
            ),
            label: Text(
              l10n.updateNow,
              style: TextStyle(
                color: AppColors.uiWhite,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.basicBlue,
              padding: const EdgeInsets.symmetric(
                horizontal: AppTypography.spacingLarge,
                vertical: AppTypography.spacingMedium,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
