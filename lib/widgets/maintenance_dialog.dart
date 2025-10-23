import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/services/remote_config_service.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';

/// Dialog for showing maintenance messages, news banners, and emergency notifications
class MaintenanceDialog extends StatelessWidget {
  final bool _isMaintenanceMode;

  const MaintenanceDialog._({required bool isMaintenanceMode})
    : _isMaintenanceMode = isMaintenanceMode;

  static Future<void> showIfNeeded(BuildContext context) async {
    final remoteConfig = RemoteConfigService.instance;

    // Show maintenance dialog if maintenance mode is enabled
    if (remoteConfig.maintenanceMode) {
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) =>
            const MaintenanceDialog._(isMaintenanceMode: true),
      );
      return;
    }

    // Show notification banner if there's an active notification
    if (remoteConfig.hasActiveNotification) {
      await showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (context) =>
            const MaintenanceDialog._(isMaintenanceMode: false),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final remoteConfig = RemoteConfigService.instance;
    final l10n = AppLocalizations.of(context);

    if (_isMaintenanceMode) {
      return _buildMaintenanceDialog(context, l10n, remoteConfig);
    } else {
      return _buildNotificationDialog(context, l10n, remoteConfig);
    }
  }

  Widget _buildMaintenanceDialog(
    BuildContext context,
    AppLocalizations? l10n,
    RemoteConfigService remoteConfig,
  ) {
    return AlertDialog(
      backgroundColor: AppColors.uiBlack,
      title: Row(
        children: [
          Icon(Icons.build, color: AppColors.uiOrange, size: 24),
          const SizedBox(width: 8),
          Text(
            l10n?.maintenanceTitle ?? 'Maintenance',
            style: TextStyle(
              color: AppColors.uiWhite,
              fontSize: AppTypography.fontSizeXLarge,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: Text(
        remoteConfig.maintenanceMessage,
        style: TextStyle(
          color: AppColors.uiTextGrey,
          fontSize: AppTypography.fontSizeMedium,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            l10n?.ok ?? 'OK',
            style: TextStyle(color: AppColors.uiLightBlueAccent),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationDialog(
    BuildContext context,
    AppLocalizations? l10n,
    RemoteConfigService remoteConfig,
  ) {
    final isEmergency = remoteConfig.isEmergencyNotification;

    return AlertDialog(
      backgroundColor: AppColors.uiBlack,
      title: Row(
        children: [
          Icon(
            isEmergency ? Icons.warning : Icons.info,
            color: isEmergency ? AppColors.uiRed : AppColors.uiLightBlueAccent,
            size: 24,
          ),
          const SizedBox(width: 8),
          Text(
            isEmergency
                ? (l10n?.emergencyNotificationTitle ?? 'Important Notice')
                : (l10n?.newsTitle ?? 'News'),
            style: TextStyle(
              color: AppColors.uiWhite,
              fontSize: AppTypography.fontSizeXLarge,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: Text(
        remoteConfig.activeNotificationText,
        style: TextStyle(
          color: AppColors.uiTextGrey,
          fontSize: AppTypography.fontSizeMedium,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            l10n?.ok ?? 'OK',
            style: TextStyle(
              color: isEmergency
                  ? AppColors.uiRed
                  : AppColors.uiLightBlueAccent,
            ),
          ),
        ),
      ],
    );
  }
}
