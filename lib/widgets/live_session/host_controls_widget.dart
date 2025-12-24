import 'package:flutter/material.dart';
import 'package:graviton/features/premium/presentation/paywall_screen.dart';
import 'package:graviton/features/premium/presentation/premium_state.dart';
import 'package:graviton/features/premium/presentation/widgets/session_expired_dialog.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/state/live_session_state.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/haptics/haptic_ink_well.dart';
import 'package:graviton/widgets/live_session/viewer_count_badge.dart';
import 'package:provider/provider.dart';

/// A compact widget for controlling live session hosting
///
/// Displays the current hosting status and provides controls to:
/// - Start hosting a new session
/// - View the current viewer count
/// - Stop hosting
///
/// This widget is designed to be placed in the simulation toolbar
/// or settings panel.
///
/// Example usage:
/// ```dart
/// HostControlsWidget(
///   appState: appState,
///   scenarioName: 'Solar System',
///   onHostingStarted: () => print('Started hosting'),
///   onHostingStopped: () => print('Stopped hosting'),
/// )
/// ```
class HostControlsWidget extends StatefulWidget {
  /// The application state containing live session state
  final AppState appState;

  /// The name of the scenario to host (required when starting)
  final String scenarioName;

  /// Callback when hosting starts successfully
  final VoidCallback? onHostingStarted;

  /// Callback when hosting stops
  final VoidCallback? onHostingStopped;

  const HostControlsWidget({
    super.key,
    required this.appState,
    required this.scenarioName,
    this.onHostingStarted,
    this.onHostingStopped,
  });

  @override
  State<HostControlsWidget> createState() => _HostControlsWidgetState();
}

class _HostControlsWidgetState extends State<HostControlsWidget> {
  PremiumState? _premiumState;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Set up session expiration callback
    _premiumState = Provider.of<PremiumState>(context, listen: false);
    _premiumState?.onSessionExpired = _handleSessionExpired;
  }

  @override
  void dispose() {
    // Clean up the callback
    _premiumState?.onSessionExpired = null;
    super.dispose();
  }

  void _handleSessionExpired() {
    // Auto-stop hosting when session expires
    _stopHosting(context, showDialog: true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Use Provider.of to listen to changes and trigger rebuilds
    final liveSession = Provider.of<LiveSessionState>(context);
    final isHosting = liveSession.isHosting;
    final viewerCount = liveSession.viewerCount;

    return Container(
      padding: const EdgeInsets.all(AppTypography.spacingMedium),
      decoration: BoxDecoration(
        color: isHosting
            ? AppColors.primaryColor.withValues(
                alpha: AppTypography.opacityMidFade,
              )
            : AppColors.uiWhite.withValues(alpha: AppTypography.opacityBarely),
        borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
        border: Border.all(
          color: isHosting
              ? AppColors.primaryColor
              : AppColors.uiWhite.withValues(
                  alpha: AppTypography.opacityDisabled,
                ),
          width: AppTypography.borderThin,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                isHosting ? Icons.wifi_tethering : Icons.wifi_tethering_off,
                color: isHosting
                    ? AppColors.primaryColor
                    : AppColors.uiWhite.withValues(
                        alpha: AppTypography.opacityHigh,
                      ),
                size: AppTypography.iconSizeLarge,
              ),
              const SizedBox(width: AppTypography.spacingSmall),
              Expanded(
                child: Text(
                  isHosting
                      ? l10n.liveSessionHosting
                      : l10n.liveSessionNotHosting,
                  style: TextStyle(
                    color: isHosting
                        ? AppColors.primaryColor
                        : AppColors.uiWhite.withValues(
                            alpha: AppTypography.opacityHigh,
                          ),
                    fontSize: AppTypography.fontSizeMedium,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (isHosting) ...[ViewerCountBadge(count: viewerCount)],
            ],
          ),
          const SizedBox(height: AppTypography.spacingSmall),
          if (isHosting)
            _StopHostingButton(onPressed: () => _stopHosting(context))
          else
            _StartHostingButton(onPressed: () => _startHosting(context)),
        ],
      ),
    );
  }

  Future<void> _startHosting(BuildContext context) async {
    final premiumState = Provider.of<PremiumState>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;

    // Check premium limits before starting
    if (!premiumState.canStartSession) {
      // Show session limit dialog
      final shouldUpgrade = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.premiumSessionLimitReached),
          content: Text(
            l10n.premiumSessionLimitMessage(
              premiumState.limits.freeSessionsPerDay,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.premiumUpgrade),
            ),
          ],
        ),
      );

      if (shouldUpgrade == true && context.mounted) {
        await PaywallScreen.show(context);
      }
      return;
    }

    // Start the session and record usage
    final liveSession = Provider.of<LiveSessionState>(context, listen: false);
    final success = await liveSession.startHosting(
      scenarioName: widget.scenarioName,
    );

    if (success) {
      // Start usage tracking for the session
      premiumState.startSessionTracking();
      widget.onHostingStarted?.call();
    }
  }

  Future<void> _stopHosting(
    BuildContext context, {
    bool showDialog = false,
  }) async {
    final liveSession = Provider.of<LiveSessionState>(context, listen: false);
    final premiumState = Provider.of<PremiumState>(context, listen: false);
    final success = await liveSession.stopHosting();

    if (success) {
      // Stop usage tracking for the session
      premiumState.stopSessionTracking();
      widget.onHostingStopped?.call();

      // Show expiration dialog if session was auto-stopped
      if (showDialog && context.mounted) {
        final shouldUpgrade = await SessionExpiredDialog.show(context);
        if (shouldUpgrade == true && context.mounted) {
          await PaywallScreen.show(context);
        }
        // Reset the expiration flag for next session
        premiumState.resetSessionExpired();
      }
    }
  }
}

/// Button to start hosting
class _StartHostingButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _StartHostingButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SizedBox(
      width: double.infinity,
      child: HapticInkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppTypography.radiusSmall),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppTypography.spacingSmall,
          ),
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(AppTypography.radiusSmall),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.play_circle_outline,
                color: AppColors.uiWhite,
                size: AppTypography.iconSizeMedium,
              ),
              const SizedBox(width: AppTypography.spacingSmall),
              Text(
                l10n.liveSessionStartHosting,
                style: const TextStyle(
                  color: AppColors.uiWhite,
                  fontSize: AppTypography.fontSizeSmall,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Button to stop hosting
class _StopHostingButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _StopHostingButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SizedBox(
      width: double.infinity,
      child: HapticInkWell(
        onTap: onPressed,
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
                Icons.stop_circle_outlined,
                color: AppColors.uiWhite.withValues(
                  alpha: AppTypography.opacityHigh,
                ),
                size: AppTypography.iconSizeMedium,
              ),
              const SizedBox(width: AppTypography.spacingSmall),
              Text(
                l10n.liveSessionStopHosting,
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
    );
  }
}
