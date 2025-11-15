import 'package:flutter/material.dart';
import 'package:graviton/utils/haptic_utils.dart';
import 'package:graviton/widgets/common/graviton_tab.dart';
import 'package:graviton/widgets/common/graviton_tab_bar.dart';

/// A complete tabbed interface widget for Graviton
class GravitonTabbedView extends StatefulWidget {
  final List<GravitonTab> tabs;
  final List<Widget> children;
  final int initialIndex;
  final Function(int)? onTabChanged;
  final List<bool>? disabledTabs;

  const GravitonTabbedView({
    super.key,
    required this.tabs,
    required this.children,
    this.initialIndex = 0,
    this.onTabChanged,
    this.disabledTabs,
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

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        // Add haptic feedback for tab navigation
        HapticUtils.navigate();
        widget.onTabChanged?.call(_tabController.index);
        // Rebuild to update active state
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check if any tabs are disabled to determine if swiping should be disabled
    final hasDisabledTabs = widget.disabledTabs?.contains(true) ?? false;

    // Rebuild tabs with current active state
    final updatedTabs = List.generate(
      widget.tabs.length,
      (index) => GravitonTab(
        icon: widget.tabs[index].icon,
        label: widget.tabs[index].label,
        isActive: _tabController.index == index,
        isEnabled: widget.tabs[index].isEnabled,
      ),
    );

    return Column(
      children: [
        GravitonTabBar(
          controller: _tabController,
          tabs: updatedTabs,
          disabledTabs: widget.disabledTabs,
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            physics: hasDisabledTabs
                ? const NeverScrollableScrollPhysics()
                : null,
            children: widget.children,
          ),
        ),
      ],
    );
  }
}
