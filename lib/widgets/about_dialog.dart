import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graviton/enums/version_status.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/services/version_service.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_constraints.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/utils/clipboard_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// Dialog displaying app information and credits
class AppAboutDialog extends StatefulWidget {
  const AppAboutDialog({super.key});

  @override
  State<AppAboutDialog> createState() => _AppAboutDialogState();
}

class _AppAboutDialogState extends State<AppAboutDialog> {
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
            packageName: 'com.example.graviton',
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

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTypography.radiusXLarge),
      ),
      child: Container(
        constraints: AppConstraints.dialogCompact,
        child: SingleChildScrollView(
          padding: AppConstraints.dialogPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Large centered logo
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.uiWhiteBorder.withValues(
                      alpha: AppTypography.opacityVeryFaint,
                    ),
                    width: 2,
                  ),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/app-logo.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: AppTypography.spacingMedium),

              // Centered app name
              Text(
                l10n.appNameGraviton,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

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
              const SizedBox(height: 12),

              // Description
              Text(
                l10n.appDescription,
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Author Section with Chipper Logo
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.business,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.authorLabel,
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.uiTextGrey,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/images/chipper-logo.svg',
                              width: 20,
                              height: 20,
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                l10n.companyName,
                                style: theme.textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Website Section
              _buildInfoSection(
                context,
                icon: Icons.language,
                title: l10n.websiteLabel,
                content: 'https://github.com/Chipper-Technologies/graviton',
                isLink: true,
              ),
              const SizedBox(height: 12),
              // Privacy Policy Section
              _buildInfoSection(
                context,
                icon: Icons.privacy_tip,
                title: l10n.privacyPolicyLabel,
                content:
                    'https://chippertechnology.com/privacy-policy/graviton',
                isLink: true,
              ),
              const SizedBox(height: 24),

              // Close button
              Center(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.closeButton),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
    bool isLink = false,
  }) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 12),
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
              const SizedBox(height: 2),
              isLink
                  ? InkWell(
                      onTap: () => _launchUrl(content),
                      child: Text(
                        content,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          decoration: TextDecoration.underline,
                          decorationColor: theme.colorScheme.primary.withValues(
                            alpha: AppTypography.opacityMediumHigh,
                          ),
                        ),
                      ),
                    )
                  : Text(content, style: theme.textTheme.bodyMedium),
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.couldNotOpenUrl(url)),
              action: SnackBarAction(
                label: l10n.copyButton,
                onPressed: () {
                  // Copy URL to clipboard as fallback
                  ClipboardUtils.copyToClipboardSilent(url);
                },
              ),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Could not launch URL: $url, error: $e');
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.errorOpeningLink(e.toString())),
            action: SnackBarAction(
              label: l10n.copyButton,
              onPressed: () {
                ClipboardUtils.copyToClipboardSilent(url);
              },
            ),
          ),
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
        badgeText = l10n.versionStatusBeta;
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
        const SizedBox(height: 6),
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
              fontSize: AppTypography.fontSizeSmall,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Show upgrade link for outdated versions
        if (versionStatus == VersionStatus.outdated &&
            VersionService.instance.getStoreUrl() != null) ...[
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () => VersionService.instance.launchStore(),
            icon: Icon(
              Icons.open_in_new,
              size: 16,
              color: theme.colorScheme.primary,
            ),
            label: Text(
              l10n.updateNow,
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
