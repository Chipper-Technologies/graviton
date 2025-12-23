import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/firebase/live_session.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/state/live_session_state.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/common/dialog_title.dart';
import 'package:graviton/widgets/haptics/haptic_ink_well.dart';
import 'package:graviton/widgets/haptics/haptic_text_button.dart';
import 'package:provider/provider.dart';

/// Tab for browsing and joining live sessions
///
/// Displays a list of active sessions with the ability to join them.
/// Password-protected sessions show a lock icon and prompt for password
/// when joining.
class BrowseSessionsTab extends StatefulWidget {
  /// The application state
  final AppState appState;

  /// Callback when a session is successfully joined
  final void Function(LiveSession session)? onSessionJoined;

  /// Callback when leaving a session
  final VoidCallback? onSessionLeft;

  const BrowseSessionsTab({
    super.key,
    required this.appState,
    this.onSessionJoined,
    this.onSessionLeft,
  });

  @override
  State<BrowseSessionsTab> createState() => _BrowseSessionsTabState();
}

class _BrowseSessionsTabState extends State<BrowseSessionsTab> {
  @override
  void initState() {
    super.initState();
    // Start session discovery when tab is shown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.appState.liveSession.startSessionDiscovery();
      }
    });
  }

  @override
  void dispose() {
    widget.appState.liveSession.stopSessionDiscovery(notify: false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final liveSession = Provider.of<LiveSessionState>(context);
    final sessions = liveSession.activeSessions;
    final isLoading = liveSession.isLoadingSessions;
    final isViewing = liveSession.isViewing;
    final hostedSessionId = liveSession.hostedSessionId;

    return Padding(
      padding: const EdgeInsets.all(AppTypography.spacingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description
          Text(
            l10n.liveSessionBrowseDescription,
            style: TextStyle(
              color: AppColors.uiWhite.withValues(
                alpha: AppTypography.opacityHigh,
              ),
              fontSize: AppTypography.fontSizeMedium,
            ),
          ),
          const SizedBox(height: AppTypography.spacingLarge),

          // Current viewing card or session list
          Expanded(
            child: isViewing
                ? _ViewingCard(onLeave: () => _leaveSession(context))
                : isLoading
                ? _LoadingState()
                : sessions.isEmpty
                ? _EmptyState(message: l10n.liveSessionNoSessions)
                : _SessionList(
                    sessions: sessions,
                    hostedSessionId: hostedSessionId,
                    onJoin: (session) => _joinSession(context, session),
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _joinSession(BuildContext context, LiveSession session) async {
    // Get provider reference before any async operation
    final liveSession = Provider.of<LiveSessionState>(context, listen: false);

    // If password protected, show password dialog
    if (session.isPasswordProtected) {
      final password = await _showPasswordDialog(context);
      if (password == null || !mounted)
        return; // User cancelled or widget disposed

      final success = await liveSession.startViewing(
        session.id,
        password: password,
      );
      if (success) {
        widget.onSessionJoined?.call(session);
      }
    } else {
      final success = await liveSession.startViewing(session.id);
      if (success) {
        widget.onSessionJoined?.call(session);
      }
    }
  }

  Future<void> _leaveSession(BuildContext context) async {
    final liveSession = Provider.of<LiveSessionState>(context, listen: false);
    final success = await liveSession.stopViewing();
    if (success) {
      widget.onSessionLeft?.call();
    }
  }

  Future<String?> _showPasswordDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();

    return showDialog<String>(
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
          title: l10n.liveSessionEnterPassword,
          icon: Icons.lock_outline,
          iconColor: AppColors.primaryColor,
          iconSize: AppTypography.iconSizeLarge,
          spacing: AppTypography.spacingSmall,
          titleStyle: AppTypography.largeText.copyWith(
            color: AppColors.uiWhite,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: TextField(
          controller: controller,
          obscureText: true,
          autofocus: true,
          style: const TextStyle(color: AppColors.uiWhite),
          decoration: InputDecoration(
            hintText: l10n.liveSessionPasswordHint,
            hintStyle: TextStyle(
              color: AppColors.uiWhite.withValues(
                alpha: AppTypography.opacityMedium,
              ),
            ),
            prefixIcon: Icon(
              Icons.lock_outline,
              color: AppColors.primaryColor,
              size: AppTypography.iconSizeMedium,
            ),
            filled: true,
            fillColor: AppColors.uiWhite.withValues(
              alpha: AppTypography.opacityBarely,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
              borderSide: BorderSide(
                color: AppColors.primaryColor.withValues(
                  alpha: AppTypography.opacityHigh,
                ),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
              borderSide: BorderSide(
                color: AppColors.primaryColor.withValues(
                  alpha: AppTypography.opacityHigh,
                ),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
              borderSide: const BorderSide(color: AppColors.primaryColor),
            ),
          ),
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
              l10n.cancel,
              style: AppTypography.mediumText.copyWith(
                color: AppColors.uiWhite.withValues(
                  alpha: AppTypography.opacityMediumHigh,
                ),
              ),
            ),
          ),
          HapticTextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primaryColor,
              backgroundColor: AppColors.primaryColor.withValues(
                alpha: AppTypography.opacityDisabled,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTypography.radiusSmall),
              ),
            ),
            child: Text(
              l10n.liveSessionJoin,
              style: AppTypography.mediumText.copyWith(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Loading indicator while fetching sessions
class _LoadingState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primaryColor),
    );
  }
}

/// Empty state when no sessions available
class _EmptyState extends StatelessWidget {
  final String message;

  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.wifi_tethering_off,
            size: AppTypography.iconSizeXXXLarge,
            color: AppColors.uiWhite.withValues(
              alpha: AppTypography.opacityMedium,
            ),
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
          ),
        ],
      ),
    );
  }
}

/// List of available sessions
class _SessionList extends StatelessWidget {
  final List<LiveSession> sessions;
  final String? hostedSessionId;
  final void Function(LiveSession) onJoin;

  const _SessionList({
    required this.sessions,
    required this.onJoin,
    this.hostedSessionId,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: sessions.length,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppTypography.spacingMedium),
      itemBuilder: (context, index) => _SessionCard(
        session: sessions[index],
        isOwnSession: sessions[index].id == hostedSessionId,
        onJoin: () => onJoin(sessions[index]),
      ),
    );
  }
}

/// Card displaying a single session
class _SessionCard extends StatelessWidget {
  final LiveSession session;
  final bool isOwnSession;
  final VoidCallback onJoin;

  const _SessionCard({
    required this.session,
    required this.onJoin,
    this.isOwnSession = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(AppTypography.spacingMedium),
      decoration: BoxDecoration(
        color: AppColors.uiWhite.withValues(alpha: AppTypography.opacityBarely),
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
          // Session status indicator
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
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        session.scenarioName,
                        style: TextStyle(
                          color: AppColors.uiWhite.withValues(
                            alpha: AppTypography.opacityFull,
                          ),
                          fontSize: AppTypography.fontSizeMedium,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (session.isPasswordProtected)
                      Padding(
                        padding: const EdgeInsets.only(
                          left: AppTypography.spacingSmall,
                        ),
                        child: Icon(
                          Icons.lock,
                          size: AppTypography.iconSizeSmall,
                          color: AppColors.uiWhite.withValues(
                            alpha: AppTypography.opacityHigh,
                          ),
                        ),
                      ),
                  ],
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
          // Join button or "Your Session" label
          if (isOwnSession)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTypography.spacingMedium,
                vertical: AppTypography.spacingSmall,
              ),
              decoration: BoxDecoration(
                color: AppColors.uiWhite.withValues(
                  alpha: AppTypography.opacityDisabled,
                ),
                borderRadius: BorderRadius.circular(AppTypography.radiusSmall),
              ),
              child: Text(
                l10n.liveSessionYourSession,
                style: TextStyle(
                  color: AppColors.uiWhite.withValues(
                    alpha: AppTypography.opacityHigh,
                  ),
                  fontSize: AppTypography.fontSizeSmall,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          else
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
                  borderRadius: BorderRadius.circular(
                    AppTypography.radiusSmall,
                  ),
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

/// Card showing currently viewing session
class _ViewingCard extends StatelessWidget {
  final VoidCallback onLeave;

  const _ViewingCard({required this.onLeave});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final liveSession = Provider.of<LiveSessionState>(context);
    final session = liveSession.currentSession;

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(AppTypography.spacingLarge),
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
          mainAxisSize: MainAxisSize.min,
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
              const SizedBox(height: AppTypography.spacingMedium),
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
                  fontSize: AppTypography.fontSizeMedium,
                ),
              ),
            ],
            const SizedBox(height: AppTypography.spacingLarge),
            SizedBox(
              width: double.infinity,
              child: HapticInkWell(
                onTap: onLeave,
                borderRadius: BorderRadius.circular(AppTypography.radiusSmall),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppTypography.spacingMedium,
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
                  child: Center(
                    child: Text(
                      l10n.liveSessionLeave,
                      style: TextStyle(
                        color: AppColors.uiWhite.withValues(
                          alpha: AppTypography.opacityFull,
                        ),
                        fontSize: AppTypography.fontSizeMedium,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
