import 'package:flutter/material.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/utils/haptic_utils.dart';
import 'package:graviton/widgets/common/graviton_tab.dart';

/// Custom TabBar that follows Graviton design system
class GravitonTabBar extends StatelessWidget {
  final TabController controller;
  final List<GravitonTab> tabs;
  final List<bool>? disabledTabs;

  const GravitonTabBar({
    super.key,
    required this.controller,
    required this.tabs,
    this.disabledTabs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: EdgeInsets.all(AppTypography.spacingMedium),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
        color: AppColors.uiBlack.withValues(alpha: AppTypography.opacityHigh),
        border: Border.all(
          color: AppColors.primaryColor.withValues(
            alpha: AppTypography.opacityVeryFaint,
          ),
          width: 1,
        ),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            SizedBox(
              height: 50, // Ensure TabBar takes full height
              child: TabBar(
                controller: controller,
                onTap: (index) {
                  // This onTap is only reached if the gesture isn't blocked
                  HapticUtils.navigate();
                },
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    AppTypography.radiusMedium,
                  ),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryColor.withValues(
                        alpha: AppTypography.opacityMedium,
                      ),
                      AppColors.primaryColor.withValues(
                        alpha: AppTypography.opacityFaint,
                      ),
                    ],
                  ),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: AppColors.transparentColor,
                labelColor: AppColors.uiWhite,
                unselectedLabelColor: AppColors.uiWhite.withValues(
                  alpha: AppTypography.opacityMediumHigh,
                ),
                labelStyle: const TextStyle(
                  fontSize: AppTypography.fontSizeMedium,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: AppTypography.fontSizeMedium,
                  fontWeight: FontWeight.w500,
                ),
                tabs: tabs,
              ),
            ),
            // Overlay gesture detectors for disabled tabs
            if (disabledTabs != null) ...{
              for (int i = 0; i < disabledTabs!.length; i++)
                if (disabledTabs![i])
                  Positioned.fill(
                    child: Row(
                      children: List.generate(tabs.length, (index) {
                        if (index != i) {
                          return Expanded(
                            child: Container(),
                          ); // Empty space for enabled tabs
                        }
                        return Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              // Block the tap and provide error feedback
                              HapticUtils.error();
                            },
                            child: Container(
                              color: Colors.transparent, // Invisible overlay
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
            },
          ],
        ),
      ),
    );
  }
}
