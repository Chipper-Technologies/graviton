import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/services/version_service.dart';
import 'package:graviton/theme/app_typography.dart';

/// Dialog that prompts users to update when they're running an outdated version
class VersionCheckDialog extends StatelessWidget {
  final bool isEnforced;

  const VersionCheckDialog({super.key, this.isEnforced = true});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return AlertDialog(
      backgroundColor:
          DialogTheme.of(context).backgroundColor ?? theme.colorScheme.surface,
      title: Row(
        children: [
          Icon(Icons.system_update, color: theme.colorScheme.error, size: 24),
          const SizedBox(width: 12),
          Text(
            l10n.updateRequiredTitle,
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.updateRequiredMessage,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(
                alpha: AppTypography.opacityVeryHigh,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.errorContainer.withValues(
                alpha: AppTypography.opacityFaint,
              ),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: theme.colorScheme.error.withValues(
                  alpha: AppTypography.opacityFaint,
                ),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.warning_rounded,
                  color: theme.colorScheme.error,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.updateRequiredWarning,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        // Show "Later" button only for non-enforced updates
        if (!isEnforced)
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              l10n.updateLater,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(
                  alpha: AppTypography.opacityMediumHigh,
                ),
              ),
            ),
          ),
        ElevatedButton(
          onPressed: () async {
            if (isEnforced) {
              // Don't close dialog for enforced updates - just launch store
              await VersionService.instance.launchStore();
            } else {
              // Close dialog for optional updates and launch store
              Navigator.of(context).pop();
              await VersionService.instance.launchStore();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.open_in_new,
                size: 18,
                color: theme.colorScheme.onPrimary,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.updateNow,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Show the version check dialog if update is required
  static Future<void> showIfRequired(BuildContext context) async {
    final versionService = VersionService.instance;

    // Check for enforced minimum version first
    if (!versionService.meetsMinimumVersion()) {
      if (context.mounted) {
        await showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (context) => const VersionCheckDialog(isEnforced: true),
        );
      }
    }
    // Check for preferred minimum version (optional update)
    else if (!versionService.meetsPreferredVersion()) {
      if (context.mounted) {
        await showDialog<void>(
          context: context,
          barrierDismissible: true,
          builder: (context) => const VersionCheckDialog(isEnforced: false),
        );
      }
    }
  }
}
