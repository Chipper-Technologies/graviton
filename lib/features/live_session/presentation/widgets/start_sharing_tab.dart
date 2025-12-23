import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/state/live_session_state.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/common/section_divider.dart';
import 'package:graviton/widgets/common/styled_text_field.dart';
import 'package:graviton/widgets/common/toggle_option.dart';
import 'package:graviton/widgets/haptics/haptic_ink_well.dart';
import 'package:graviton/widgets/live_session/connection_status_indicator.dart';
import 'package:provider/provider.dart';

/// Tab for starting and managing a live session host
///
/// Allows users to:
/// - Name their session
/// - Start hosting with optional password protection
/// - View current viewer count while hosting
/// - Stop hosting
///
/// The session automatically broadcasts the current scenario and updates
/// seamlessly when the user switches scenarios.
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
  final _sessionNameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordProtected = false;
  bool _isStarting = false;
  String? _previousScenarioName;

  @override
  void initState() {
    super.initState();
    _previousScenarioName = widget.appState.simulation.currentScenario.name;
    widget.appState.simulation.addListener(_onSimulationChanged);

    // Initialize form fields from hosted session if already hosting
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeFromHostedSession();
    });
  }

  /// Initialize form fields from the current hosted session
  void _initializeFromHostedSession() {
    final liveSession = Provider.of<LiveSessionState>(context, listen: false);
    if (liveSession.isHosting) {
      final hostedSession = liveSession.hostedSession;
      if (hostedSession != null) {
        _sessionNameController.text = hostedSession.scenarioName;
        setState(() {
          _isPasswordProtected = hostedSession.isPasswordProtected;
        });
      }
    }
  }

  @override
  void didUpdateWidget(covariant StartSharingTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.appState.simulation != widget.appState.simulation) {
      oldWidget.appState.simulation.removeListener(_onSimulationChanged);
      widget.appState.simulation.addListener(_onSimulationChanged);
    }
  }

  @override
  void dispose() {
    widget.appState.simulation.removeListener(_onSimulationChanged);
    _sessionNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Called when the simulation state changes
  void _onSimulationChanged() {
    final currentScenarioName = widget.appState.simulation.currentScenario.name;

    // Check if scenario changed and we're hosting
    if (_previousScenarioName != currentScenarioName) {
      _previousScenarioName = currentScenarioName;

      // Auto-update the session if hosting
      final liveSession = Provider.of<LiveSessionState>(context, listen: false);
      if (liveSession.isHosting) {
        liveSession.updateHostedSession(scenarioName: currentScenarioName);
      }
    }
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

          // Session name input using standard StyledTextField
          StyledTextField(
            controller: _sessionNameController,
            icon: Icons.label_outline,
            labelText: l10n.liveSessionSessionName,
            hintText: l10n.liveSessionSessionNameHint,
            onChanged: (_) {},
          ),
          const SizedBox(height: AppTypography.spacingMedium),

          // Password protection toggle using standard ToggleOption
          ToggleOption(
            title: l10n.liveSessionPasswordProtection,
            description: l10n.liveSessionPasswordDescription,
            icon: _isPasswordProtected ? Icons.lock : Icons.lock_open,
            isEnabled: _isPasswordProtected,
            onChanged: (value) {
              setState(() {
                _isPasswordProtected = value;
                if (!value) {
                  _passwordController.clear();
                }
              });
            },
          ),

          // Password input field (shown when protection is enabled)
          if (_isPasswordProtected) ...[
            StyledTextField(
              controller: _passwordController,
              icon: Icons.lock_outline,
              hintText: l10n.liveSessionSetPassword,
              onChanged: (_) {},
              obscureText: true,
            ),
            const SizedBox(height: AppTypography.spacingMedium),
          ],

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

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hosting status banner
          Container(
            width: double.infinity,
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
            child: Row(
              children: [
                const Icon(
                  Icons.wifi_tethering,
                  color: AppColors.primaryColor,
                  size: AppTypography.iconSizeLarge,
                ),
                const SizedBox(width: AppTypography.spacingMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.liveSessionHosting,
                        style: const TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: AppTypography.fontSizeMedium,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppTypography.spacingXSmall),
                      Text(
                        l10n.liveSessionViewerCount(viewerCount),
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
                const ConnectionStatusIndicator(
                  showLabel: false,
                  compact: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTypography.spacingMedium),

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
          const SizedBox(height: AppTypography.spacingLarge),

          // Divider between status and form
          const SectionDivider.plain(),
          const SizedBox(height: AppTypography.spacingLarge),

          // Session name input using standard StyledTextField
          StyledTextField(
            controller: _sessionNameController,
            icon: Icons.label_outline,
            labelText: l10n.liveSessionSessionName,
            hintText: l10n.liveSessionSessionNameHint,
            onChanged: (_) {},
          ),
          const SizedBox(height: AppTypography.spacingMedium),

          // Password protection toggle using standard ToggleOption
          ToggleOption(
            title: l10n.liveSessionPasswordProtection,
            description: l10n.liveSessionPasswordDescription,
            icon: _isPasswordProtected ? Icons.lock : Icons.lock_open,
            isEnabled: _isPasswordProtected,
            onChanged: (value) {
              setState(() {
                _isPasswordProtected = value;
                if (!value) {
                  _passwordController.clear();
                }
              });
            },
          ),

          // Password input field (shown when protection is enabled)
          if (_isPasswordProtected) ...[
            StyledTextField(
              controller: _passwordController,
              icon: Icons.lock_outline,
              hintText: l10n.liveSessionSetPassword,
              onChanged: (_) {},
              obscureText: true,
            ),
          ],
          const SizedBox(height: AppTypography.spacingMedium),

          // Update session button
          SizedBox(
            width: double.infinity,
            child: HapticInkWell(
              onTap: () => _updateSession(context),
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
                    const Icon(
                      Icons.check,
                      color: AppColors.uiWhite,
                      size: AppTypography.iconSizeMedium,
                    ),
                    const SizedBox(width: AppTypography.spacingSmall),
                    Text(
                      l10n.liveSessionUpdateSession,
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

  Future<void> _updateSession(BuildContext context) async {
    final liveSession = Provider.of<LiveSessionState>(context, listen: false);
    final sessionName = _sessionNameController.text.trim().isEmpty
        ? widget.appState.simulation.currentScenario.name
        : _sessionNameController.text.trim();

    await liveSession.updateHostedSession(scenarioName: sessionName);
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

    // Use session name if provided, otherwise fall back to scenario name
    final sessionName = _sessionNameController.text.trim().isNotEmpty
        ? _sessionNameController.text.trim()
        : widget.appState.simulation.currentScenario.name;

    // Store the session name in the controller so it persists to the hosting view
    _sessionNameController.text = sessionName;

    final success = await liveSession.startHosting(
      scenarioName: sessionName,
      password: _isPasswordProtected ? _passwordController.text : null,
    );

    setState(() => _isStarting = false);

    if (success) {
      // Keep form values - they're used in the hosting view
      // Only clear the password for security
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
