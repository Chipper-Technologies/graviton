import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/firebase/live_session.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/haptics/haptic_ink_well.dart';

/// A card widget displaying a live session for browsing/joining.
///
/// Shows session information including:
/// - Running status indicator
/// - Scenario name
/// - Host name
/// - Viewer count
/// - Password protection indicator (optional)
/// - Join button or "Your Session" label
class SessionCard extends StatelessWidget {
  /// The live session to display.
  final LiveSession session;

  /// Callback when the join button is tapped.
  final VoidCallback onJoin;

  /// Whether this is the current user's own session.
  ///
  /// When true, shows "Your Session" label instead of join button.
  final bool isOwnSession;

  /// Whether to show the password protection indicator.
  ///
  /// Defaults to true.
  final bool showPasswordIndicator;

  /// Creates a session card widget.
  const SessionCard({
    super.key,
    required this.session,
    required this.onJoin,
    this.isOwnSession = false,
    this.showPasswordIndicator = true,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.only(bottom: AppTypography.spacingSmall),
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
          _buildStatusIndicator(),
          const SizedBox(width: AppTypography.spacingMedium),
          // Session info
          Expanded(child: _buildSessionInfo(l10n)),
          // Join button or "Your Session" label
          _buildActionButton(l10n),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator() {
    return Container(
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
            : AppColors.uiWhite.withValues(alpha: AppTypography.opacityHigh),
        size: AppTypography.iconSizeMedium,
      ),
    );
  }

  Widget _buildSessionInfo(AppLocalizations l10n) {
    return Column(
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
            if (showPasswordIndicator && session.isPasswordProtected)
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
    );
  }

  Widget _buildActionButton(AppLocalizations l10n) {
    if (isOwnSession) {
      return Container(
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
      );
    }

    return HapticInkWell(
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
    );
  }
}
