import 'package:flutter/material.dart';
import 'package:graviton/enums/ui_action.dart';
import 'package:graviton/enums/ui_element.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/services/firebase_service.dart';
import 'package:graviton/services/screenshot_mode_service.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:provider/provider.dart';

/// Floating video-style controls for play/pause and reset
class FloatingSimulationControls extends StatefulWidget {
  const FloatingSimulationControls({super.key});

  @override
  State<FloatingSimulationControls> createState() =>
      _FloatingSimulationControlsState();
}

class _FloatingSimulationControlsState extends State<FloatingSimulationControls>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
    _startAutoHideTimer();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startAutoHideTimer() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _isVisible) {
        _hideControls();
      }
    });
  }

  void _showControls() {
    if (!_isVisible) {
      setState(() {
        _isVisible = true;
      });
      _animationController.forward();
      _startAutoHideTimer();
    }
  }

  void _hideControls() {
    if (_isVisible) {
      setState(() {
        _isVisible = false;
      });
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<AppState>(
      builder: (context, appState, child) {
        return GestureDetector(
          onTap: _showControls,
          behavior: HitTestBehavior.translucent,
          child: Stack(
            children: [
              // Invisible overlay to detect taps and show controls
              Positioned.fill(
                child: GestureDetector(
                  onTap: _showControls,
                  child: const SizedBox.expand(),
                ),
              ),

              // Floating controls
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Positioned(
                    bottom:
                        45, // Moved up from 30 to give more space above copyright
                    left: 0,
                    right: 0,
                    child: Opacity(
                      opacity: _fadeAnimation.value,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.uiBlack.withValues(
                              alpha: AppTypography.opacityMedium,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.uiWhite.withValues(
                                alpha: AppTypography.opacityVeryFaint,
                              ),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.uiBlack.withValues(
                                  alpha: AppTypography.opacityFaint,
                                ),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Play/Pause Button
                              _buildControlButton(
                                icon: appState.simulation.isPaused
                                    ? Icons.play_arrow
                                    : Icons.pause,
                                onPressed: () {
                                  final action = appState.simulation.isPaused
                                      ? 'play'
                                      : 'pause';
                                  FirebaseService.instance.logUIEventWithEnums(
                                    UIAction.buttonPressed,
                                    element: UIElement.simulationControl,
                                    value: action,
                                  );
                                  appState.simulation.pause();
                                  _showControls(); // Keep controls visible after interaction
                                },
                                tooltip: appState.simulation.isPaused
                                    ? l10n.playButton
                                    : l10n.pauseButton,
                                isPrimary: true,
                              ),

                              const SizedBox(width: 12),

                              // Reset Button
                              _buildControlButton(
                                icon: Icons.refresh,
                                onPressed: () {
                                  FirebaseService.instance.logUIEventWithEnums(
                                    UIAction.buttonPressed,
                                    element: UIElement.simulationControl,
                                    value: 'reset',
                                  );

                                  // Check if screenshot mode is active and deactivate it first
                                  final screenshotService =
                                      ScreenshotModeService();
                                  if (screenshotService.isActive) {
                                    screenshotService.deactivate(
                                      uiState: appState.ui,
                                    );
                                  }

                                  appState.resetAll();
                                  _showControls(); // Keep controls visible after interaction
                                },
                                tooltip: l10n.resetButton,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
    bool isPrimary = false,
  }) {
    return Tooltip(
      message: tooltip,
      preferBelow: false,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isPrimary
                        ? AppColors.primaryColor.withValues(
                            alpha: AppTypography.opacityNearlyOpaque,
                          )
                        : AppColors.uiWhite.withValues(
                            alpha: AppTypography.opacityVeryFaint,
                          ),
                    borderRadius: BorderRadius.circular(20),
                    border: isPrimary
                        ? null
                        : Border.all(
                            color: AppColors.uiWhite.withValues(
                              alpha: AppTypography.opacityFaint,
                            ),
                            width: 1,
                          ),
                  ),
                  child: Icon(
                    icon,
                    color: isPrimary
                        ? AppColors.uiWhite
                        : AppColors.uiWhite.withValues(
                            alpha: AppTypography.opacityNearlyOpaque,
                          ),
                    size: 20,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tooltip,
                  style: TextStyle(
                    color: AppColors.uiWhite.withValues(
                      alpha: AppTypography.opacityVeryHigh,
                    ),
                    fontSize: AppTypography.fontSizeSmall,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
