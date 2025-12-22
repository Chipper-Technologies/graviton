import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/firebase/live_session.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/haptics/haptic_ink_well.dart';

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
    widget.appState.liveSession.startSessionDiscovery();
  }

  @override
  void dispose() {
    widget.appState.liveSession.stopSessionDiscovery();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final liveSession = widget.appState.liveSession;
    final sessions = liveSession.activeSessions;
    final isLoading = liveSession.isLoadingSessions;
    final isViewing = liveSession.isViewing;

    if (isViewing) {
      return _ViewingSessionCard(
        appState: widget.appState,
        onLeave: () => _leaveSession(context),
      );
    }

    if (isLoading) {
      return _LoadingState();
    }

    if (sessions.isEmpty) {
      return _EmptyState(message: l10n.liveSessionNoSessions);
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
          (session) => _SessionCard(
            session: session,
            onJoin: () => _joinSession(context, session),
          ),
        ),
      ],
    );
  }

  Future<void> _joinSession(BuildContext context, LiveSession session) async {
    final success = await widget.appState.liveSession.startViewing(session.id);
    if (success) {
      widget.onSessionJoined?.call(session);
    }
  }

  Future<void> _leaveSession(BuildContext context) async {
    final success = await widget.appState.liveSession.stopViewing();
    if (success) {
      widget.onSessionLeft?.call();
    }
  }
}

/// Card displaying a single session that can be joined
class _SessionCard extends StatelessWidget {
  final LiveSession session;
  final VoidCallback onJoin;

  const _SessionCard({
    required this.session,
    required this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.only(bottom: AppTypography.spacingSmall),
      padding: const EdgeInsets.all(AppTypography.spacingMedium),
      decoration: BoxDecoration(
        color: AppColors.uiWhite.withValues(
          alpha: AppTypography.opacityBarely,
        ),
        borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
        border: Border.all(
          color: AppColors.uiWhite.withValues(
            alpha: AppTypography.opacityDisabled,
          ),
          width: AppTypography.borderThin,
        ),
      ),
      child: Row(
        children: [
          // Session indicator
          Container(
            width: AppTypography.iconSizeXLarge,
            height: AppTypography.iconSizeXLarge,
            decoration: BoxDecoration(
              color: session.isRunning
                  ? AppColors.habitabilityHabitable.withValues(
                      alpha: AppTypography.opacityMidFade,
                    )
                  : AppColors.uiWhite.withValues(
                      alpha: AppTypography.opacityDisabled,
                    ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              session.isRunning ? Icons.play_arrow : Icons.pause,
              color: session.isRunning
                  ? AppColors.habitabilityHabitable
                  : AppColors.uiWhite.withValues(
                      alpha: AppTypography.opacityHigh,
                    ),
              size: AppTypography.iconSizeMedium,
            ),
          ),
          const SizedBox(width: AppTypography.spacingMedium),
          // Session info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.scenarioName,
                  style: TextStyle(
                    color: AppColors.uiWhite.withValues(
                      alpha: AppTypography.opacityFull,
                    ),
                    fontSize: AppTypography.fontSizeMedium,
                    fontWeight: FontWeight.w600,
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
                const SizedBox(height: AppTypography.spacingXSmall),
                Row(
                  children: [
                    Icon(
                      Icons.visibility,
                      color: AppColors.uiWhite.withValues(
                        alpha: AppTypography.opacityMedium,
                      ),
                      size: AppTypography.iconSizeSmall,
                    ),
                    const SizedBox(width: AppTypography.spacingXSmall),
                    Text(
                      l10n.liveSessionViewerCount(session.viewerCount),
                      style: TextStyle(
                        color: AppColors.uiWhite.withValues(
                          alpha: AppTypography.opacityMedium,
                        ),
                        fontSize: AppTypography.fontSizeXSmall,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Join button
          HapticInkWell(
            onTap: onJoin,
            borderRadius: BorderRadius.circular(AppTypography.radiusSmall),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTypography.spacingMedium,
                vertical: AppTypography.spacingSmall,
              ),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(AppTypography.radiusSmall),
              ),
              child: Text(
                l10n.liveSessionJoin,
                style: const TextStyle(
                  color: AppColors.uiWhite,
                  fontSize: AppTypography.fontSizeSmall,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Card showing the currently viewed session
class _ViewingSessionCard extends StatelessWidget {
  final AppState appState;
  final VoidCallback onLeave;

  const _ViewingSessionCard({
    required this.appState,
    required this.onLeave,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final session = appState.liveSession.currentSession;

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
                  borderRadius: BorderRadius.circular(AppTypography.radiusSmall),
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

/// Loading state widget
class _LoadingState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTypography.spacingXLarge),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            AppColors.uiWhite.withValues(alpha: AppTypography.opacityHigh),
          ),
        ),
      ),
    );
  }
}

/// Empty state widget
class _EmptyState extends StatelessWidget {
  final String message;

  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTypography.spacingXLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.wifi_tethering_off,
              color: AppColors.uiWhite.withValues(
                alpha: AppTypography.opacityMedium,
              ),
              size: AppTypography.iconSizeXXXLarge,
            ),
            const SizedBox(height: AppTypography.spacingMedium),
            Text(
              message,
              style: TextStyle(
                color: AppColors.uiWhite.withValues(
                  alpha: AppTypography.opacityMedium,
                ),
                fontSize: AppTypography.fontSizeMedium,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
