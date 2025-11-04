import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/services/remote_config_service.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_constraints.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/common/dialog_title.dart';

/// Dialog for showing maintenance messages, news banners, and emergency notifications
class MaintenanceDialog extends StatelessWidget {
  final bool _isMaintenanceMode;
  final String? _testTitle;
  final String? _testMessage;
  final VoidCallback? _testOnClose;

  const MaintenanceDialog._({required bool isMaintenanceMode})
    : _isMaintenanceMode = isMaintenanceMode,
      _testTitle = null,
      _testMessage = null,
      _testOnClose = null;

  /// Public constructor for testing - creates a maintenance mode dialog
  const MaintenanceDialog.maintenance({
    super.key,
    String? title,
    String? message,
    VoidCallback? onClose,
  }) : _isMaintenanceMode = true,
       _testTitle = title,
       _testMessage = message,
       _testOnClose = onClose;

  /// Public constructor for testing - creates a notification mode dialog
  const MaintenanceDialog.notification({
    super.key,
    String? title,
    String? message,
    VoidCallback? onClose,
  }) : _isMaintenanceMode = false,
       _testTitle = title,
       _testMessage = message,
       _testOnClose = onClose;

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
    // Use test values if provided, otherwise use remote config values
    final title = _testTitle ?? l10n?.maintenanceTitle ?? 'Maintenance';
    final message = _testMessage ?? remoteConfig.maintenanceMessage;

    return ConstrainedBox(
      constraints: AppConstraints.dialogCompact,
      child: AlertDialog(
        backgroundColor: AppColors.uiBlack,
        title: DialogTitle(
          title: title,
          icon: Icons.build,
          iconColor: AppColors.uiOrange,
          titleStyle: TextStyle(
            color: AppColors.uiWhite,
            fontSize: AppTypography.fontSizeXLarge,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          message,
          style: TextStyle(
            color: AppColors.uiTextGrey,
            fontSize: AppTypography.fontSizeMedium,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _testOnClose ?? () => Navigator.of(context).pop(),
            child: Text(
              l10n?.ok ?? 'OK',
              style: TextStyle(color: AppColors.uiLightBlueAccent),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationDialog(
    BuildContext context,
    AppLocalizations? l10n,
    RemoteConfigService remoteConfig,
  ) {
    final isEmergency = remoteConfig.isEmergencyNotification;

    // Use test values if provided, otherwise use remote config values
    final title =
        _testTitle ??
        (isEmergency
            ? (l10n?.emergencyNotificationTitle ?? 'Important Notice')
            : (l10n?.newsTitle ?? 'News'));
    final message = _testMessage ?? remoteConfig.activeNotificationText;

    return ConstrainedBox(
      constraints: AppConstraints.dialogCompact,
      child: AlertDialog(
        backgroundColor: AppColors.uiBlack,
        title: DialogTitle(
          title: title,
          icon: isEmergency ? Icons.warning : Icons.info,
          iconColor: isEmergency
              ? AppColors.uiRed
              : AppColors.uiLightBlueAccent,
          titleStyle: TextStyle(
            color: AppColors.uiWhite,
            fontSize: AppTypography.fontSizeXLarge,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          message,
          style: TextStyle(
            color: AppColors.uiTextGrey,
            fontSize: AppTypography.fontSizeMedium,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _testOnClose ?? () => Navigator.of(context).pop(),
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
      ),
    );
  }
}
