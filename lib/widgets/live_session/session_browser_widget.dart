import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/state/live_session_state.dart';
import 'package:provider/provider.dart';
import 'package:graviton/models/firebase/live_session.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/haptics/haptic_ink_well.dart';
import 'package:graviton/widgets/live_session/session_card.dart';
import 'package:graviton/widgets/live_session/session_empty_state.dart';
import 'package:graviton/widgets/live_session/session_loading_indicator.dart';

/// A widget for browsing and joining live sessions
///
/// Displays a list of active live sessions that the user can join.
/// Shows session metadata including host name, scenario, and viewer count.
///
/// Example usage:
/// ```dart
/// SessionBrowserWidget(
///   appState: appState,
///   onSessionJoined: (session) => print('Joined: ${session.id}'),
/// )
/// ```
class SessionBrowserWidget extends StatefulWidget {
  /// The application state containing live session state
  final AppState appState;

  /// Callback when a session is successfully joined
  final void Function(LiveSession session)? onSessionJoined;

  /// Callback when leaving a session
  final VoidCallback? onSessionLeft;

  const SessionBrowserWidget({
    super.key,
    required this.appState,
    this.onSessionJoined,
    this.onSessionLeft,
  });

  @override
  State<SessionBrowserWidget> createState() => _SessionBrowserWidgetState();
}

class _SessionBrowserWidgetState extends State<SessionBrowserWidget> {
  @override
  void initState() {
    super.initState();
    // Use post-frame callback to avoid calling notifyListeners during build
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.appState.liveSession.startSessionDiscovery();
      }
    });
  }

  @override
  void dispose() {
    // Pass notify: false to avoid triggering state updates during widget teardown
    widget.appState.liveSession.stopSessionDiscovery(notify: false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Use Provider.of to listen to changes and trigger rebuilds
    final liveSession = Provider.of<LiveSessionState>(context);
    final sessions = liveSession.activeSessions;
    final isLoading = liveSession.isLoadingSessions;
    final isViewing = liveSession.isViewing;

    if (isViewing) {
      return _ViewingSessionCard(onLeave: () => _leaveSession(context));
    }

    if (isLoading) {
      return const SessionLoadingIndicator();
    }

    if (sessions.isEmpty) {
      return SessionEmptyState(message: l10n.liveSessionNoSessions);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppTypography.spacingSmall),
          child: Text(
            l10n.liveSessionBrowseSessions,
            style: TextStyle(
              color: AppColors.uiWhite.withValues(
                alpha: AppTypography.opacityHigh,
              ),
              fontSize: AppTypography.fontSizeMedium,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ...sessions.map(
          (session) => SessionCard(
            session: session,
            onJoin: () => _joinSession(context, session),
          ),
        ),
      ],
    );
  }

  Future<void> _joinSession(BuildContext context, LiveSession session) async {
    final liveSession = Provider.of<LiveSessionState>(context, listen: false);
    final success = await liveSession.startViewing(session.id);
    if (success) {
      widget.onSessionJoined?.call(session);
    }
  }

  Future<void> _leaveSession(BuildContext context) async {
    final liveSession = Provider.of<LiveSessionState>(context, listen: false);
    final success = await liveSession.stopViewing();
    if (success) {
      widget.onSessionLeft?.call();
    }
  }
}

/// Card showing the currently viewed session
class _ViewingSessionCard extends StatelessWidget {
  final VoidCallback onLeave;

  const _ViewingSessionCard({required this.onLeave});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final liveSession = Provider.of<LiveSessionState>(context);
    final session = liveSession.currentSession;

    return Container(
      padding: const EdgeInsets.all(AppTypography.spacingMedium),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(
          alpha: AppTypography.opacityMidFade,
        ),
        borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
        border: Border.all(
          color: AppColors.primaryColor,
          width: AppTypography.borderThin,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.visibility,
                color: AppColors.primaryColor,
                size: AppTypography.iconSizeLarge,
              ),
              const SizedBox(width: AppTypography.spacingSmall),
              Expanded(
                child: Text(
                  l10n.liveSessionViewing,
                  style: const TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: AppTypography.fontSizeMedium,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (session != null) ...[
            const SizedBox(height: AppTypography.spacingSmall),
            Text(
              session.scenarioName,
              style: TextStyle(
                color: AppColors.uiWhite.withValues(
                  alpha: AppTypography.opacityFull,
                ),
                fontSize: AppTypography.fontSizeLarge,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTypography.spacingXSmall),
            Text(
              l10n.liveSessionHostedBy(session.hostName),
              style: TextStyle(
                color: AppColors.uiWhite.withValues(
                  alpha: AppTypography.opacityHigh,
                ),
                fontSize: AppTypography.fontSizeSmall,
              ),
            ),
          ],
          const SizedBox(height: AppTypography.spacingMedium),
          SizedBox(
            width: double.infinity,
            child: HapticInkWell(
              onTap: onLeave,
              borderRadius: BorderRadius.circular(AppTypography.radiusSmall),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: AppTypography.spacingSmall,
                ),
                decoration: BoxDecoration(
                  color: AppColors.uiWhite.withValues(
                    alpha: AppTypography.opacityMidFade,
                  ),
                  borderRadius: BorderRadius.circular(
                    AppTypography.radiusSmall,
                  ),
                  border: Border.all(
                    color: AppColors.uiWhite.withValues(
                      alpha: AppTypography.opacityHigh,
                    ),
                    width: AppTypography.borderThin,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.exit_to_app,
                      color: AppColors.uiWhite.withValues(
                        alpha: AppTypography.opacityHigh,
                      ),
                      size: AppTypography.iconSizeMedium,
                    ),
                    const SizedBox(width: AppTypography.spacingSmall),
                    Text(
                      l10n.liveSessionLeave,
                      style: TextStyle(
                        color: AppColors.uiWhite.withValues(
                          alpha: AppTypography.opacityHigh,
                        ),
                        fontSize: AppTypography.fontSizeSmall,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
