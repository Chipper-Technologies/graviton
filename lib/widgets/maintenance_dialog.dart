import 'package:flutter/material.dart';
import 'package:graviton/enums/custom_message_type.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/services/remote_config_service.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_constraints.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/common/dialog_title.dart';
import 'package:graviton/widgets/haptics/haptic_text_button.dart';
import 'package:url_launcher/url_launcher.dart';

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
    final message = _testMessage ?? remoteConfig.getMaintenanceMessage(l10n);

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
          HapticTextButton(
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
    final notificationTypeEnum = remoteConfig.activeNotificationTypeEnum;

    // Use test values if provided, otherwise use remote config values
    final title =
        _testTitle ??
        (remoteConfig.activeNotificationTitle.isNotEmpty
            ? remoteConfig.activeNotificationTitle
            : _getDefaultTitle(l10n!, isEmergency, notificationTypeEnum));
    final message = _testMessage ?? remoteConfig.activeNotificationText;

    return ConstrainedBox(
      constraints: AppConstraints.dialogCompact,
      child: AlertDialog(
        backgroundColor: AppColors.uiBlack,
        title: DialogTitle(
          title: title,
          icon: _getIconForType(isEmergency, notificationTypeEnum),
          iconColor: _getColorForType(isEmergency, notificationTypeEnum),
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
        actions: _buildActions(
          context,
          l10n,
          remoteConfig,
          isEmergency,
          notificationTypeEnum,
        ),
      ),
    );
  }

  String _getDefaultTitle(
    AppLocalizations l10n,
    bool isEmergency,
    CustomMessageType type,
  ) {
    switch (type) {
      case CustomMessageType.info:
        return l10n.newsTitle;
      case CustomMessageType.warning:
        return l10n.warningTitle;
      case CustomMessageType.success:
        return l10n.successTitle;
      case CustomMessageType.announcement:
        return l10n.announcementTitle;
      case CustomMessageType.promotion:
        return l10n.promotionTitle;
      case CustomMessageType.update:
        return l10n.updateRequiredTitle;
    }
  }

  IconData _getIconForType(
    bool isEmergency,
    CustomMessageType notificationType,
  ) {
    if (isEmergency) return Icons.warning;

    switch (notificationType) {
      case CustomMessageType.warning:
        return Icons.warning_amber;
      case CustomMessageType.success:
        return Icons.check_circle;
      case CustomMessageType.announcement:
        return Icons.campaign;
      case CustomMessageType.promotion:
        return Icons.local_offer;
      case CustomMessageType.update:
        return Icons.system_update;
      case CustomMessageType.info:
        return Icons.info;
    }
  }

  Color _getColorForType(bool isEmergency, CustomMessageType notificationType) {
    if (isEmergency) return AppColors.uiRed;

    switch (notificationType) {
      case CustomMessageType.warning:
        return AppColors.uiOrange;
      case CustomMessageType.success:
        return AppColors.uiGreen;
      case CustomMessageType.announcement:
        return AppColors.primaryColor;
      case CustomMessageType.promotion:
        return AppColors.sectionTitlePurple;
      case CustomMessageType.update:
        return AppColors.uiLightBlueAccent;
      case CustomMessageType.info:
        return AppColors.uiLightBlueAccent;
    }
  }

  List<Widget> _buildActions(
    BuildContext context,
    AppLocalizations? l10n,
    RemoteConfigService remoteConfig,
    bool isEmergency,
    CustomMessageType notificationType,
  ) {
    final actions = <Widget>[];

    // Add action button if available
    if (remoteConfig.hasNotificationAction) {
      actions.add(
        HapticTextButton(
          onPressed: () async {
            final url = remoteConfig.customMessageActionUrl;
            if (await canLaunchUrl(Uri.parse(url))) {
              await launchUrl(Uri.parse(url));
            }
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
          child: Text(
            remoteConfig.customMessageActionText,
            style: TextStyle(
              color: _getColorForType(isEmergency, notificationType),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    // Add dismiss button
    actions.add(
      HapticTextButton(
        onPressed: _testOnClose ?? () => Navigator.of(context).pop(),
        child: Text(
          l10n?.ok ?? 'OK',
          style: TextStyle(
            color: isEmergency ? AppColors.uiRed : AppColors.uiLightBlueAccent,
          ),
        ),
      ),
    );

    return actions;
  }
}
