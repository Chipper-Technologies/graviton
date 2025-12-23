import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/state/live_session_state.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/common/graviton_tabs.dart';
import 'package:graviton/widgets/haptics/haptic_app_bar.dart';
import 'package:graviton/widgets/live_session/connection_status_indicator.dart';
import 'package:provider/provider.dart';

import '../widgets/browse_sessions_tab.dart';
import '../widgets/start_sharing_tab.dart';

/// Full-screen live session management page with tabbed interface
///
/// Provides two tabs:
/// - **Browse**: View and join active live sessions from other users
/// - **Start Sharing**: Host your own live session with optional password protection
///
/// Example usage:
/// ```dart
/// Navigator.push(
///   context,
///   MaterialPageRoute(
///     builder: (context) => LiveSessionScreen(appState: appState),
///   ),
/// );
/// ```
class LiveSessionScreen extends StatefulWidget {
  /// The application state containing simulation and live session state
  final AppState appState;

  /// Optional callback when hosting state changes
  final VoidCallback? onHostingChanged;

  /// Optional callback when viewing state changes
  final VoidCallback? onViewingChanged;

  const LiveSessionScreen({
    super.key,
    required this.appState,
    this.onHostingChanged,
    this.onViewingChanged,
  });

  @override
  State<LiveSessionScreen> createState() => _LiveSessionScreenState();

  /// Shows the LiveSessionScreen as a full screen route
  static Future<void> show(
    BuildContext context, {
    required AppState appState,
    VoidCallback? onHostingChanged,
    VoidCallback? onViewingChanged,
  }) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LiveSessionScreen(
          appState: appState,
          onHostingChanged: onHostingChanged,
          onViewingChanged: onViewingChanged,
        ),
      ),
    );
  }
}

class _LiveSessionScreenState extends State<LiveSessionScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final liveSessionState = Provider.of<LiveSessionState>(context);

    return Scaffold(
      backgroundColor: AppColors.transparentColor,
      extendBodyBehindAppBar: true,
      appBar: HapticAppBar(
        title: l10n.liveSessionMenuTitle,
        automaticallyImplyLeading: true,
        actions: [
          // Connection status indicator in app bar
          if (liveSessionState.isInSession)
            Padding(
              padding: const EdgeInsets.only(
                right: AppTypography.spacingMedium,
              ),
              child: ConnectionStatusIndicator(compact: true, showLabel: false),
            ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: AppColors.uiBlack.withValues(
            alpha: AppTypography.opacityNearlyOpaque,
          ),
        ),
        child: SafeArea(
          child: GravitonTabbedView(
            initialIndex: _getInitialTabIndex(liveSessionState),
            tabs: [
              GravitonTab(icon: Icons.search, label: l10n.liveSessionBrowseTab),
              GravitonTab(
                icon: Icons.wifi_tethering,
                label: l10n.liveSessionStartSharingTab,
              ),
            ],
            children: [
              BrowseSessionsTab(
                appState: widget.appState,
                onSessionJoined: (_) => widget.onViewingChanged?.call(),
                onSessionLeft: widget.onViewingChanged,
              ),
              StartSharingTab(
                appState: widget.appState,
                onHostingStarted: widget.onHostingChanged,
                onHostingStopped: widget.onHostingChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Determine initial tab based on current session state
  int _getInitialTabIndex(LiveSessionState state) {
    // If already hosting, go to Start Sharing tab
    if (state.isHosting) return 1;
    // Otherwise default to Browse tab
    return 0;
  }
}
