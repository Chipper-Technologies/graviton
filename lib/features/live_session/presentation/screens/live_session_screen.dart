import 'package:flutter/material.dart';
import 'package:graviton/features/account/presentation/screens/account_management_screen.dart';
import 'package:graviton/features/auth/state/auth_state.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/ui/dialog_action.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/state/live_session_state.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/common/base_confirmation_dialog.dart';
import 'package:graviton/widgets/common/dialog_title.dart';
import 'package:graviton/widgets/common/graviton_tabs.dart';
import 'package:graviton/widgets/haptics/haptic_app_bar.dart';
import 'package:graviton/widgets/haptics/haptic_ink_well.dart';
import 'package:graviton/widgets/haptics/haptic_text_button.dart';
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
  ///
  /// If the user is not authenticated, shows a dialog prompting them
  /// to create an account first.
  static Future<void> show(
    BuildContext context, {
    required AppState appState,
    VoidCallback? onHostingChanged,
    VoidCallback? onViewingChanged,
  }) async {
    final authState = Provider.of<AuthState>(context, listen: false);

    // Check if user is authenticated (not anonymous and not null)
    if (!authState.isAuthenticated) {
      // Show dialog prompting user to create account
      final shouldCreateAccount = await _showAuthRequiredDialog(context);
      if (shouldCreateAccount && context.mounted) {
        // Navigate to account management screen
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AccountManagementScreen(),
          ),
        );
      }
      return;
    }

    await Navigator.push(
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

  /// Shows a dialog explaining that live sessions require an account
  static Future<bool> _showAuthRequiredDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    return await BaseConfirmationDialog.show<bool>(
          context: context,
          title: l10n.liveSessionRequiresAccountTitle,
          message: l10n.liveSessionRequiresAccountMessage,
          titleIcon: Icons.account_circle_outlined,
          actions: [
            DialogAction(
              text: l10n.cancel,
              onPressed: () => Navigator.pop(context, false),
            ),
            DialogAction(
              text: l10n.liveSessionCreateAccount,
              onPressed: () => Navigator.pop(context, true),
              textColor: AppColors.primaryColor,
            ),
          ],
        ) ??
        false;
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
          // Connection status indicator in app bar - tappable to show settings
          if (liveSessionState.isInSession)
            Padding(
              padding: const EdgeInsets.only(
                right: AppTypography.spacingMedium,
              ),
              child: HapticInkWell(
                onTap: () => _showSessionSettings(context),
                borderRadius: BorderRadius.circular(AppTypography.radiusSmall),
                child: Padding(
                  padding: const EdgeInsets.all(AppTypography.spacingSmall),
                  child: ConnectionStatusIndicator(
                    compact: true,
                    showLabel: false,
                  ),
                ),
              ),
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

  /// Shows session settings dialog with current session info and options
  void _showSessionSettings(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final liveSession = Provider.of<LiveSessionState>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.uiBlack.withValues(
          alpha: AppTypography.opacityAlmostOpaque,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
          side: BorderSide(
            color: AppColors.primaryColor.withValues(
              alpha: AppTypography.opacityFaint,
            ),
            width: AppTypography.borderThin,
          ),
        ),
        title: DialogTitle(
          title: l10n.liveSessionSettings,
          icon: liveSession.isHosting ? Icons.wifi_tethering : Icons.visibility,
          iconColor: AppColors.primaryColor,
          iconSize: AppTypography.iconSizeLarge,
          spacing: AppTypography.spacingSmall,
          titleStyle: AppTypography.largeText.copyWith(
            color: AppColors.uiWhite,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Connection status
            const ConnectionStatusIndicator(showLabel: true, compact: false),
            const SizedBox(height: AppTypography.spacingMedium),

            // Session info
            if (liveSession.isHosting) ...[
              Text(
                l10n.liveSessionViewerCount(liveSession.viewerCount),
                style: AppTypography.mediumText.copyWith(
                  color: AppColors.uiWhite.withValues(
                    alpha: AppTypography.opacityVeryHigh,
                  ),
                ),
              ),
            ] else if (liveSession.currentSession != null) ...[
              Text(
                l10n.liveSessionHostedBy(liveSession.currentSession!.hostName),
                style: AppTypography.mediumText.copyWith(
                  color: AppColors.uiWhite.withValues(
                    alpha: AppTypography.opacityVeryHigh,
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: [
          HapticTextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.uiWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTypography.radiusSmall),
              ),
            ),
            child: Text(
              l10n.closeButton,
              style: AppTypography.mediumText.copyWith(
                color: AppColors.uiWhite.withValues(
                  alpha: AppTypography.opacityMediumHigh,
                ),
              ),
            ),
          ),
          HapticTextButton(
            onPressed: () {
              Navigator.pop(context);
              if (liveSession.isHosting) {
                liveSession.stopHosting();
                widget.onHostingChanged?.call();
              } else {
                liveSession.stopViewing();
                widget.onViewingChanged?.call();
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.celestialRed,
              backgroundColor: AppColors.celestialRed.withValues(
                alpha: AppTypography.opacityDisabled,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTypography.radiusSmall),
              ),
            ),
            child: Text(
              liveSession.isHosting
                  ? l10n.liveSessionStopHosting
                  : l10n.liveSessionLeave,
              style: AppTypography.mediumText.copyWith(
                color: AppColors.celestialRed,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
