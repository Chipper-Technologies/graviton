import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/state/live_session_state.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/haptics/haptic_ink_well.dart';
import 'package:graviton/widgets/live_session/connection_status_indicator.dart';
import 'package:provider/provider.dart';

/// Tab for starting and managing a live session host
///
/// Allows users to:
/// - Start hosting with optional password protection
/// - View current viewer count while hosting
/// - Stop hosting
class StartSharingTab extends StatefulWidget {
  /// The application state
  final AppState appState;

  /// Callback when hosting starts successfully
  final VoidCallback? onHostingStarted;

  /// Callback when hosting stops
  final VoidCallback? onHostingStopped;

  const StartSharingTab({
    super.key,
    required this.appState,
    this.onHostingStarted,
    this.onHostingStopped,
  });

  @override
  State<StartSharingTab> createState() => _StartSharingTabState();
}

class _StartSharingTabState extends State<StartSharingTab> {
  final _passwordController = TextEditingController();
  bool _isPasswordProtected = false;
  bool _isStarting = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final liveSession = Provider.of<LiveSessionState>(context);
    final isHosting = liveSession.isHosting;

    return Padding(
      padding: const EdgeInsets.all(AppTypography.spacingLarge),
      child: isHosting ? _buildHostingView(context) : _buildStartView(context),
    );
  }

  Widget _buildStartView(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scenarioName = widget.appState.simulation.currentScenario.name;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description
          Text(
            l10n.liveSessionShareDescription,
            style: TextStyle(
              color: AppColors.uiWhite.withValues(
                alpha: AppTypography.opacityHigh,
              ),
              fontSize: AppTypography.fontSizeMedium,
            ),
          ),
          const SizedBox(height: AppTypography.spacingXLarge),

          // Current scenario info
          _InfoCard(
            icon: Icons.public,
            title: l10n.liveSessionScenarioToShare,
            value: scenarioName,
          ),
          const SizedBox(height: AppTypography.spacingLarge),

          // Password protection toggle
          Container(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _isPasswordProtected ? Icons.lock : Icons.lock_open,
                      color: _isPasswordProtected
                          ? AppColors.primaryColor
                          : AppColors.uiWhite.withValues(
                              alpha: AppTypography.opacityHigh,
                            ),
                      size: AppTypography.iconSizeMedium,
                    ),
                    const SizedBox(width: AppTypography.spacingMedium),
                    Expanded(
                      child: Text(
                        l10n.liveSessionPasswordProtection,
                        style: TextStyle(
                          color: AppColors.uiWhite.withValues(
                            alpha: AppTypography.opacityFull,
                          ),
                          fontSize: AppTypography.fontSizeMedium,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Switch(
                      value: _isPasswordProtected,
                      onChanged: (value) {
                        setState(() {
                          _isPasswordProtected = value;
                          if (!value) {
                            _passwordController.clear();
                          }
                        });
                      },
                      activeTrackColor: AppColors.primaryColor,
                    ),
                  ],
                ),
                if (_isPasswordProtected) ...[
                  const SizedBox(height: AppTypography.spacingMedium),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    style: const TextStyle(color: AppColors.uiWhite),
                    decoration: InputDecoration(
                      hintText: l10n.liveSessionSetPassword,
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
                        borderRadius: BorderRadius.circular(
                          AppTypography.radiusMedium,
                        ),
                        borderSide: BorderSide(
                          color: AppColors.primaryColor.withValues(
                            alpha: AppTypography.opacityHigh,
                          ),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppTypography.radiusMedium,
                        ),
                        borderSide: BorderSide(
                          color: AppColors.primaryColor.withValues(
                            alpha: AppTypography.opacityHigh,
                          ),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppTypography.radiusMedium,
                        ),
                        borderSide: const BorderSide(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTypography.spacingSmall),
                  Text(
                    l10n.liveSessionPasswordDescription,
                    style: TextStyle(
                      color: AppColors.uiWhite.withValues(
                        alpha: AppTypography.opacityMedium,
                      ),
                      fontSize: AppTypography.fontSizeSmall,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppTypography.spacingXLarge),

          // Start hosting button
          SizedBox(
            width: double.infinity,
            child: HapticInkWell(
              onTap: _isStarting ? null : () => _startHosting(context),
              borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: AppTypography.spacingMedium,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(
                    AppTypography.radiusMedium,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isStarting)
                      const SizedBox(
                        width: AppTypography.iconSizeMedium,
                        height: AppTypography.iconSizeMedium,
                        child: CircularProgressIndicator(
                          color: AppColors.uiWhite,
                          strokeWidth: 2,
                        ),
                      )
                    else
                      const Icon(
                        Icons.wifi_tethering,
                        color: AppColors.uiWhite,
                        size: AppTypography.iconSizeMedium,
                      ),
                    const SizedBox(width: AppTypography.spacingSmall),
                    Text(
                      l10n.liveSessionStartHosting,
                      style: const TextStyle(
                        color: AppColors.uiWhite,
                        fontSize: AppTypography.fontSizeMedium,
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

  Widget _buildHostingView(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final liveSession = Provider.of<LiveSessionState>(context);
    final viewerCount = liveSession.viewerCount;
    final scenarioName = widget.appState.simulation.currentScenario.name;

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hosting status card
            Container(
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
                children: [
                  // Status header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.wifi_tethering,
                        color: AppColors.primaryColor,
                        size: AppTypography.iconSizeLarge,
                      ),
                      const SizedBox(width: AppTypography.spacingSmall),
                      Text(
                        l10n.liveSessionHosting,
                        style: const TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: AppTypography.fontSizeLarge,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTypography.spacingLarge),

                  // Connection status
                  const ConnectionStatusIndicator(showLabel: true),
                  const SizedBox(height: AppTypography.spacingLarge),

                  // Scenario name
                  Text(
                    scenarioName,
                    style: TextStyle(
                      color: AppColors.uiWhite.withValues(
                        alpha: AppTypography.opacityFull,
                      ),
                      fontSize: AppTypography.fontSizeLarge,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppTypography.spacingMedium),

                  // Viewer count
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTypography.spacingMedium,
                      vertical: AppTypography.spacingSmall,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.uiWhite.withValues(
                        alpha: AppTypography.opacityMidFade,
                      ),
                      borderRadius: BorderRadius.circular(
                        AppTypography.radiusSmall,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.visibility,
                          color: AppColors.uiWhite,
                          size: AppTypography.iconSizeMedium,
                        ),
                        const SizedBox(width: AppTypography.spacingSmall),
                        Text(
                          l10n.liveSessionViewerCount(viewerCount),
                          style: const TextStyle(
                            color: AppColors.uiWhite,
                            fontSize: AppTypography.fontSizeMedium,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTypography.spacingXLarge),

            // Stop hosting button
            SizedBox(
              width: double.infinity,
              child: HapticInkWell(
                onTap: () => _stopHosting(context),
                borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppTypography.spacingMedium,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.uiWhite.withValues(
                      alpha: AppTypography.opacityMidFade,
                    ),
                    borderRadius: BorderRadius.circular(
                      AppTypography.radiusMedium,
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
                        Icons.stop_circle_outlined,
                        color: AppColors.uiWhite.withValues(
                          alpha: AppTypography.opacityFull,
                        ),
                        size: AppTypography.iconSizeMedium,
                      ),
                      const SizedBox(width: AppTypography.spacingSmall),
                      Text(
                        l10n.liveSessionStopHosting,
                        style: TextStyle(
                          color: AppColors.uiWhite.withValues(
                            alpha: AppTypography.opacityFull,
                          ),
                          fontSize: AppTypography.fontSizeMedium,
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
      ),
    );
  }

  Future<void> _startHosting(BuildContext context) async {
    // Validate password if protection is enabled
    if (_isPasswordProtected && _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.liveSessionPasswordRequired,
          ),
          backgroundColor: AppColors.uiRed,
        ),
      );
      return;
    }

    setState(() => _isStarting = true);

    final liveSession = Provider.of<LiveSessionState>(context, listen: false);
    final scenarioName = widget.appState.simulation.currentScenario.name;

    final success = await liveSession.startHosting(
      scenarioName: scenarioName,
      password: _isPasswordProtected ? _passwordController.text : null,
    );

    setState(() => _isStarting = false);

    if (success) {
      _passwordController.clear();
      widget.onHostingStarted?.call();
    }
  }

  Future<void> _stopHosting(BuildContext context) async {
    final liveSession = Provider.of<LiveSessionState>(context, listen: false);
    final success = await liveSession.stopHosting();

    if (success) {
      widget.onHostingStopped?.call();
    }
  }
}

/// Info card for displaying scenario details
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
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
          Icon(
            icon,
            color: AppColors.primaryColor,
            size: AppTypography.iconSizeLarge,
          ),
          const SizedBox(width: AppTypography.spacingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.uiWhite.withValues(
                      alpha: AppTypography.opacityMedium,
                    ),
                    fontSize: AppTypography.fontSizeSmall,
                  ),
                ),
                const SizedBox(height: AppTypography.spacingXSmall),
                Text(
                  value,
                  style: TextStyle(
                    color: AppColors.uiWhite.withValues(
                      alpha: AppTypography.opacityFull,
                    ),
                    fontSize: AppTypography.fontSizeMedium,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
