import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:graviton/core/enums/live_session_connection_status.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/state/live_session_state.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';

/// Widget that displays the current live session connection status
///
/// Shows a colored indicator dot with status text, adapting its
/// appearance based on the connection state (connected, connecting,
/// disconnected, error, reconnecting).
///
/// Example usage:
/// ```dart
/// ConnectionStatusIndicator(
///   showLabel: true,
///   compact: false,
/// )
/// ```
class ConnectionStatusIndicator extends StatelessWidget {
  /// Whether to show the status label text
  final bool showLabel;

  /// Whether to use compact layout (smaller dot, no padding)
  final bool compact;

  /// Optional callback when indicator is tapped
  final VoidCallback? onTap;

  /// Creates a connection status indicator
  const ConnectionStatusIndicator({
    super.key,
    this.showLabel = true,
    this.compact = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<LiveSessionState>(
      builder: (context, liveState, child) {
        if (!liveState.isInSession) {
          return const SizedBox.shrink();
        }

        final status = liveState.connectionStatus;
        final color = _getStatusColor(status);
        final l10n = AppLocalizations.of(context);

        return GestureDetector(
          onTap: onTap,
          child: Container(
            padding: compact
                ? EdgeInsets.zero
                : EdgeInsets.symmetric(
                    horizontal: AppTypography.spacingSmall,
                    vertical: AppTypography.spacingXSmall,
                  ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildStatusDot(status, color),
                if (showLabel) ...[
                  SizedBox(width: AppTypography.spacingXSmall),
                  Text(
                    _getStatusText(l10n, status),
                    style: TextStyle(
                      color: color,
                      fontSize: compact
                          ? AppTypography.fontSizeSmall
                          : AppTypography.fontSizeMedium,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusDot(LiveSessionConnectionStatus status, Color color) {
    final size = compact
        ? AppTypography.spacingSmall
        : AppTypography.spacingMedium;

    // Animate the dot for connecting/reconnecting states
    if (status.isConnecting) {
      return SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: AppTypography.opacityMedium),
            blurRadius: AppTypography.spacingXSmall,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(LiveSessionConnectionStatus status) {
    switch (status) {
      case LiveSessionConnectionStatus.disconnected:
        return AppColors.uiTextGrey;
      case LiveSessionConnectionStatus.connecting:
        return AppColors.uiStatusOrange;
      case LiveSessionConnectionStatus.connected:
        return AppColors.uiStatusGreen;
      case LiveSessionConnectionStatus.reconnecting:
        return AppColors.uiStatusOrange;
      case LiveSessionConnectionStatus.error:
        return AppColors.uiRed;
    }
  }

  String _getStatusText(
    AppLocalizations? l10n,
    LiveSessionConnectionStatus status,
  ) {
    if (l10n == null) {
      return status.name;
    }

    switch (status) {
      case LiveSessionConnectionStatus.disconnected:
        return l10n.liveSessionStatusDisconnected;
      case LiveSessionConnectionStatus.connecting:
        return l10n.liveSessionStatusConnecting;
      case LiveSessionConnectionStatus.connected:
        return l10n.liveSessionStatusConnected;
      case LiveSessionConnectionStatus.reconnecting:
        return l10n.liveSessionStatusReconnecting;
      case LiveSessionConnectionStatus.error:
        return l10n.liveSessionStatusError;
    }
  }
}
