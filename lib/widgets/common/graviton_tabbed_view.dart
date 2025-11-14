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
    // Check if any tabs are disabled to determine if swiping should be disabled
    final hasDisabledTabs = widget.disabledTabs?.contains(true) ?? false;

    return Column(
      children: [
        GravitonTabBar(
          controller: _tabController,
          tabs: widget.tabs,
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
