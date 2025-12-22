import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/haptics/haptic_ink_well.dart';

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
class HostControlsWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isHosting = appState.liveSession.isHosting;
    final viewerCount = appState.liveSession.viewerCount;

    return Container(
      padding: const EdgeInsets.all(AppTypography.spacingMedium),
      decoration: BoxDecoration(
        color: isHosting
            ? AppColors.primaryColor.withValues(
                alpha: AppTypography.opacityMidFade,
              )
            : AppColors.uiWhite.withValues(
                alpha: AppTypography.opacityBarely,
              ),
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
                  isHosting ? l10n.liveSessionHosting : l10n.liveSessionNotHosting,
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
              if (isHosting) ...[
                _ViewerCountBadge(count: viewerCount),
              ],
            ],
          ),
          const SizedBox(height: AppTypography.spacingSmall),
          if (isHosting)
            _StopHostingButton(
              onPressed: () => _stopHosting(context),
            )
          else
            _StartHostingButton(
              onPressed: () => _startHosting(context),
            ),
        ],
      ),
    );
  }

  Future<void> _startHosting(BuildContext context) async {
    final success = await appState.liveSession.startHosting(
      scenarioName: scenarioName,
    );

    if (success) {
      onHostingStarted?.call();
    }
  }

  Future<void> _stopHosting(BuildContext context) async {
    final success = await appState.liveSession.stopHosting();

    if (success) {
      onHostingStopped?.call();
    }
  }
}

/// Badge showing the number of viewers
class _ViewerCountBadge extends StatelessWidget {
  final int count;

  const _ViewerCountBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTypography.spacingSmall,
        vertical: AppTypography.spacingXSmall,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(AppTypography.radiusSmall),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.visibility,
            color: AppColors.uiWhite,
            size: AppTypography.iconSizeSmall,
          ),
          const SizedBox(width: AppTypography.spacingXSmall),
          Text(
            l10n.liveSessionViewerCount(count),
            style: const TextStyle(
              color: AppColors.uiWhite,
              fontSize: AppTypography.fontSizeXSmall,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
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
