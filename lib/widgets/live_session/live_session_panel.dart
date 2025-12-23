import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/state/live_session_state.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/common/section_divider.dart';
import 'package:graviton/widgets/haptics/haptic_ink_well.dart';
import 'package:graviton/widgets/live_session/connection_status_indicator.dart';
import 'package:graviton/widgets/live_session/host_controls_widget.dart';
import 'package:graviton/widgets/live_session/session_browser_widget.dart';
import 'package:provider/provider.dart';

/// A comprehensive panel for managing live session functionality
///
/// Provides a unified interface for:
/// - Hosting a live session to share simulation with others
/// - Browsing and joining other users' live sessions
/// - Viewing connection status and session statistics
///
/// This widget is designed to be displayed in a modal bottom sheet
/// or as a side panel.
///
/// Example usage:
/// ```dart
/// showModalBottomSheet(
///   context: context,
///   builder: (_) => const LiveSessionPanel(),
/// );
/// ```
class LiveSessionPanel extends StatelessWidget {
  /// Optional callback when a hosting state changes
  final VoidCallback? onHostingChanged;

  /// Optional callback when viewing state changes
  final VoidCallback? onViewingChanged;

  const LiveSessionPanel({
    super.key,
    this.onHostingChanged,
    this.onViewingChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final appState = Provider.of<AppState>(context);
    final liveSessionState = Provider.of<LiveSessionState>(context);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundBlack.withValues(
          alpha: AppTypography.opacityNearlyOpaque,
        ),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppTypography.radiusLarge),
        ),
        border: Border.all(
          color: AppColors.primaryColor.withValues(
            alpha: AppTypography.opacityMidFade,
          ),
          width: AppTypography.borderThin,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _PanelHeader(l10n: l10n, liveSessionState: liveSessionState),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTypography.spacingLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Connection Status Section
                  _ConnectionStatusSection(liveSessionState: liveSessionState),

                  const SectionDivider.plain(),

                  // Host Controls Section
                  _SectionTitle(
                    icon: Icons.wifi_tethering,
                    title: l10n.liveSessionHosting,
                  ),
                  const SizedBox(height: AppTypography.spacingMedium),
                  HostControlsWidget(
                    appState: appState,
                    scenarioName: appState.simulation.currentScenario.name,
                    onHostingStarted: onHostingChanged,
                    onHostingStopped: onHostingChanged,
                  ),

                  const SizedBox(height: AppTypography.spacingXLarge),
                  const SectionDivider.plain(),

                  // Browse Sessions Section
                  _SectionTitle(
                    icon: Icons.search,
                    title: l10n.liveSessionBrowseSessions,
                  ),
                  const SizedBox(height: AppTypography.spacingMedium),
                  SessionBrowserWidget(
                    appState: appState,
                    onSessionJoined: (_) => onViewingChanged?.call(),
                    onSessionLeft: onViewingChanged,
                  ),

                  const SizedBox(height: AppTypography.spacingLarge),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Shows the LiveSessionPanel in a modal bottom sheet
  static Future<void> show(
    BuildContext context, {
    VoidCallback? onHostingChanged,
    VoidCallback? onViewingChanged,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      builder: (context) => LiveSessionPanel(
        onHostingChanged: onHostingChanged,
        onViewingChanged: onViewingChanged,
      ),
    );
  }
}

/// Header section with title and close button
class _PanelHeader extends StatelessWidget {
  final AppLocalizations l10n;
  final LiveSessionState liveSessionState;

  const _PanelHeader({
    required this.l10n,
    required this.liveSessionState,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTypography.spacingLarge),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.uiWhite.withValues(
              alpha: AppTypography.opacityVeryFaint,
            ),
            width: AppTypography.borderThin,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.cast_connected,
            color: AppColors.primaryColor,
            size: AppTypography.iconSizeXLarge,
          ),
          const SizedBox(width: AppTypography.spacingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.liveSessionTitle,
                  style: TextStyle(
                    color: AppColors.uiWhite,
                    fontSize: AppTypography.fontSizeXLarge,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  _getSubtitle(l10n, liveSessionState),
                  style: TextStyle(
                    color: AppColors.uiWhite.withValues(
                      alpha: AppTypography.opacityHigh,
                    ),
                    fontSize: AppTypography.fontSizeSmall,
                  ),
                ),
              ],
            ),
          ),
          // Drag handle indicator
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.uiWhite.withValues(
                alpha: AppTypography.opacityMidFade,
              ),
              borderRadius: BorderRadius.circular(AppTypography.radiusSmall),
            ),
          ),
          const SizedBox(width: AppTypography.spacingLarge),
          HapticInkWell(
            onTap: () => Navigator.of(context).pop(),
            borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
            child: Container(
              padding: const EdgeInsets.all(AppTypography.spacingSmall),
              child: Icon(
                Icons.close,
                color: AppColors.uiWhite.withValues(
                  alpha: AppTypography.opacityHigh,
                ),
                size: AppTypography.iconSizeLarge,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getSubtitle(AppLocalizations l10n, LiveSessionState state) {
    if (state.isHosting) {
      return l10n.liveSessionHostingDescription;
    } else if (state.isViewing) {
      return l10n.liveSessionViewingDescription;
    }
    return l10n.liveSessionDescription;
  }
}

/// Section for displaying connection status
class _ConnectionStatusSection extends StatelessWidget {
  final LiveSessionState liveSessionState;

  const _ConnectionStatusSection({required this.liveSessionState});

  @override
  Widget build(BuildContext context) {
    // Only show when connected to a session
    if (!liveSessionState.isHosting && !liveSessionState.isViewing) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: AppTypography.spacingLarge),
      child: Row(
        children: [
          const ConnectionStatusIndicator(
            showLabel: true,
            compact: false,
          ),
          const Spacer(),
          if (liveSessionState.viewerCount > 0)
            _ViewerCountBadge(count: liveSessionState.viewerCount),
        ],
      ),
    );
  }
}

/// Badge showing viewer count
class _ViewerCountBadge extends StatelessWidget {
  final int count;

  const _ViewerCountBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTypography.spacingMedium,
        vertical: AppTypography.spacingXSmall,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(
          alpha: AppTypography.opacityMidFade,
        ),
        borderRadius: BorderRadius.circular(AppTypography.radiusSmall),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.visibility,
            color: AppColors.primaryColor,
            size: AppTypography.iconSizeSmall,
          ),
          const SizedBox(width: AppTypography.spacingXSmall),
          Text(
            l10n.liveSessionViewerCount(count),
            style: TextStyle(
              color: AppColors.primaryColor,
              fontSize: AppTypography.fontSizeSmall,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Section title with icon
class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionTitle({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.uiWhite.withValues(
            alpha: AppTypography.opacityHigh,
          ),
          size: AppTypography.iconSizeMedium,
        ),
        const SizedBox(width: AppTypography.spacingSmall),
        Text(
          title,
          style: TextStyle(
            color: AppColors.uiWhite.withValues(
              alpha: AppTypography.opacityHigh,
            ),
            fontSize: AppTypography.fontSizeMedium,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
