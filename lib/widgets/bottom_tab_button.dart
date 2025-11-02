import 'package:flutter/material.dart';
import 'package:graviton/painters/gradient_grid_painter.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';

/// A tab button for the bottom navigation bar with proper theming
class BottomTabButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String tooltip;
  final VoidCallback? onPressed;
  final bool isActive;

  const BottomTabButton({
    super.key,
    required this.icon,
    required this.label,
    required this.tooltip,
    required this.onPressed,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;

    return Tooltip(
      message: tooltip,
      preferBelow: false,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: AppTypography.createRadius(AppTypography.radiusLarge),
          splashColor: AppColors.primaryColor.withValues(
            alpha: AppTypography.opacityDisabled,
          ),
          highlightColor: AppColors.primaryColor.withValues(
            alpha: AppTypography.opacityBarely,
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            height: 64, // Increased from 56 to 64 for better visual presence
            padding: const EdgeInsets.symmetric(
              horizontal: AppTypography.spacingSmall,
              vertical: AppTypography.spacingSmall,
            ),
            decoration: BoxDecoration(
              borderRadius: AppTypography.createRadius(
                AppTypography.radiusLarge,
              ),
              // Add button shadows for depth
              boxShadow: [
                BoxShadow(
                  color: AppColors.uiBlack.withValues(
                    alpha: AppTypography.opacityVeryFaint,
                  ),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                ),
                BoxShadow(
                  color: AppColors.uiBlack.withValues(
                    alpha: AppTypography.opacityDisabled,
                  ),
                  offset: const Offset(0, 4),
                  blurRadius: 8,
                ),
                BoxShadow(
                  color: AppColors.uiBlack.withValues(
                    alpha: AppTypography.opacityBarely,
                  ),
                  offset: const Offset(0, 8),
                  blurRadius: 16,
                ),
              ],
            ),
            child: Stack(
              children: [
                // Dark background layer
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      // Dark background for the button
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.uiBlack.withValues(
                            alpha: AppTypography.opacityMediumHigh,
                          ), // Reduced opacity
                          AppColors.uiBlack.withValues(
                            alpha: AppTypography.opacityHigh,
                          ), // Reduced opacity
                          AppColors.uiBlack.withValues(
                            alpha: AppTypography.opacityVeryHigh,
                          ), // Reduced opacity
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                      // Add a border with different states for active/inactive/disabled
                      border: Border.all(
                        color: !isEnabled
                            ? AppColors.uiWhite.withValues(
                                alpha: AppTypography.opacityDisabled,
                              ) // Very subtle for disabled
                            : isActive
                            ? AppColors.primaryColor.withValues(
                                alpha: AppTypography.opacitySemiTransparent,
                              ) // Purple for active
                            : AppColors.uiBorderGrey.withValues(
                                alpha: AppTypography.opacityMediumHigh,
                              ), // Grey for inactive but enabled
                        width: isActive ? 1.5 : 1.0,
                      ),
                      borderRadius: AppTypography.createRadius(
                        AppTypography.radiusLarge,
                      ),
                    ),
                  ),
                ),

                // Purple grid overlay that fades out at bottom
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: AppTypography.createRadius(
                      AppTypography.radiusLarge,
                    ),
                    child: CustomPaint(
                      painter: GradientGridPainter(
                        gridSize:
                            6.0, // Moderate grid size for balanced line density
                        gridColor: AppColors.primaryColor,
                        opacity: !isEnabled
                            ? AppTypography
                                  .opacityBarely // Even more subtle grid for disabled buttons
                            : isActive
                            ? AppTypography
                                  .opacityDisabled // Much lighter grid for active buttons
                            : AppTypography
                                  .opacityBarely, // Much lighter grid for inactive but enabled buttons
                      ),
                    ),
                  ),
                ),

                // Purple gradient overlay for active buttons
                if (isActive)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.primaryColor.withValues(
                              alpha: AppTypography.opacityMidFade,
                            ),
                            AppColors.primaryColor.withValues(
                              alpha: AppTypography.opacityDisabled,
                            ),
                            AppColors.primaryColor.withValues(
                              alpha: AppTypography.opacityBarely,
                            ),
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                        borderRadius: AppTypography.createRadius(
                          AppTypography.radiusLarge,
                        ),
                      ),
                    ),
                  ),

                // Grey gradient overlay for inactive but enabled buttons
                if (!isActive && isEnabled)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.uiBorderGrey.withValues(
                              alpha: AppTypography.opacityDisabled,
                            ),
                            AppColors.uiBorderGrey.withValues(
                              alpha: AppTypography.opacityBarely,
                            ),
                            AppColors.uiBorderGrey.withValues(
                              alpha: AppTypography.opacityTransparent,
                            ),
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                        borderRadius: AppTypography.createRadius(
                          AppTypography.radiusLarge,
                        ),
                      ),
                    ),
                  ),

                // Content layer with proper vertical centering
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Icon with state-specific colors
                      Icon(
                        icon,
                        color: !isEnabled
                            ? AppColors.uiTextGrey.withValues(
                                alpha: AppTypography.opacitySemiTransparent,
                              ) // Grey for disabled
                            : isActive
                            ? AppColors.primaryColor.withValues(
                                alpha: AppTypography.opacityMediumHigh,
                              ) // Darker purple for active
                            : AppColors.uiTextGrey.withValues(
                                alpha: AppTypography.opacityVeryHigh,
                              ), // Grey for inactive but enabled
                        size: AppTypography.iconSizeMedium,
                      ),

                      const SizedBox(
                        width: 6,
                      ), // Smaller spacing for compact button
                      // Label with enhanced drop shadow for better contrast
                      Flexible(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: AppTypography.smallText.copyWith(
                            // Using existing small text
                            fontSize: 11, // Slightly smaller for compact button
                            color: isEnabled
                                ? AppColors.uiWhite.withValues(
                                    alpha: AppTypography.opacityVeryHigh,
                                  )
                                : AppColors.uiWhite.withValues(
                                    alpha: AppTypography.opacityMedium,
                                  ),
                            fontWeight: isActive
                                ? FontWeight.w600
                                : FontWeight.w500,
                            letterSpacing: 0.3,
                            // Enhanced text shadows for better readability on gradient background
                            shadows: [
                              // Close, strong shadow for definition
                              Shadow(
                                color: AppColors.uiBlack.withValues(
                                  alpha: AppTypography.opacityNearlyOpaque,
                                ),
                                offset: const Offset(0, 1),
                                blurRadius: 2,
                              ),
                              // Medium shadow for depth
                              Shadow(
                                color: AppColors.uiBlack.withValues(
                                  alpha: AppTypography.opacityHigh,
                                ),
                                offset: const Offset(0, 2),
                                blurRadius: 4,
                              ),
                              // Larger shadow for glow effect
                              Shadow(
                                color: AppColors.uiBlack.withValues(
                                  alpha: AppTypography.opacityMedium,
                                ),
                                offset: const Offset(0, 3),
                                blurRadius: 8,
                              ),
                              // Outermost shadow for enhanced depth
                              Shadow(
                                color: AppColors.uiBlack.withValues(
                                  alpha: AppTypography.opacityFaint,
                                ),
                                offset: const Offset(0, 4),
                                blurRadius: 16,
                              ),
                            ],
                          ),
                          child: Text(label),
                        ),
                      ),
                    ],
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
