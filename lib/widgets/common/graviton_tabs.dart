import 'package:flutter/material.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/utils/haptic_utils.dart';

/// Custom tab widget that follows Graviton design system
class GravitonTab extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool showActiveDot;
  final bool isEnabled;

  const GravitonTab({
    super.key,
    required this.icon,
    required this.label,
    this.isActive = false,
    this.showActiveDot = false,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = !isEnabled
        ? AppColors.uiWhite.withValues(alpha: AppTypography.opacityMedium)
        : isActive
        ? AppColors.primaryColor
        : null;

    return Opacity(
      opacity: isEnabled ? 1.0 : 0.7,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Icon(
                icon,
                size: AppTypography.iconSizeLarge,
                color: effectiveColor,
              ),
              // Active indicator dot
              if (showActiveDot && isEnabled)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppColors.uiOrange,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: effectiveColor)),
        ],
      ),
    );
  }
}

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
                borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
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
    );
  }
}

/// A complete tabbed interface widget for Graviton
class GravitonTabbedView extends StatefulWidget {
  final List<GravitonTab> tabs;
  final List<Widget> children;
  final int initialIndex;
  final Function(int)? onTabChanged;

  const GravitonTabbedView({
    super.key,
    required this.tabs,
    required this.children,
    this.initialIndex = 0,
    this.onTabChanged,
  });

  @override
  State<GravitonTabbedView> createState() => _GravitonTabbedViewState();
}

class _GravitonTabbedViewState extends State<GravitonTabbedView>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.tabs.length,
      vsync: this,
      initialIndex: widget.initialIndex,
    );

    if (widget.onTabChanged != null) {
      _tabController.addListener(() {
        if (_tabController.indexIsChanging) {
          // Add haptic feedback for tab navigation
          HapticUtils.navigate();
          widget.onTabChanged!(_tabController.index);
        }
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GravitonTabBar(controller: _tabController, tabs: widget.tabs),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: widget.children,
          ),
        ),
      ],
    );
  }
}
