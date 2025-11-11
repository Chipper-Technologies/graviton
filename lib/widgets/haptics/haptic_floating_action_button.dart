import 'package:flutter/material.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/utils/haptic_utils.dart';

/// Enhanced FloatingActionButton with haptic feedback and scroll-aware visibility
class HapticFloatingActionButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget? child;
  final String? tooltip;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? splashColor;
  final double? elevation;
  final double? focusElevation;
  final double? hoverElevation;
  final double? highlightElevation;
  final double? disabledElevation;
  final ShapeBorder? shape;
  final bool mini;
  final Clip clipBehavior;
  final bool autofocus;
  final MaterialTapTargetSize? materialTapTargetSize;
  final bool isExtended;
  final MouseCursor? mouseCursor;
  final bool? enableFeedback;
  final FocusNode? focusNode;
  final ScrollController? scrollController;
  final bool hideOnScroll;

  const HapticFloatingActionButton({
    super.key,
    required this.onPressed,
    this.child,
    this.tooltip,
    this.foregroundColor,
    this.backgroundColor,
    this.focusColor,
    this.hoverColor,
    this.splashColor,
    this.elevation,
    this.focusElevation,
    this.hoverElevation,
    this.highlightElevation,
    this.disabledElevation,
    this.shape,
    this.mini = false,
    this.clipBehavior = Clip.none,
    this.autofocus = false,
    this.materialTapTargetSize,
    this.isExtended = false,
    this.mouseCursor,
    this.enableFeedback,
    this.focusNode,
    this.scrollController,
    this.hideOnScroll = true,
  });

  /// Factory constructor for extended FAB with scroll awareness
  factory HapticFloatingActionButton.extended({
    Key? key,
    required VoidCallback? onPressed,
    Widget? icon,
    required Widget label,
    String? tooltip,
    Color? foregroundColor,
    Color? backgroundColor,
    Color? focusColor,
    Color? hoverColor,
    Color? splashColor,
    double? elevation,
    double? focusElevation,
    double? hoverElevation,
    double? highlightElevation,
    double? disabledElevation,
    ShapeBorder? shape,
    Clip clipBehavior = Clip.none,
    bool autofocus = false,
    MaterialTapTargetSize? materialTapTargetSize,
    MouseCursor? mouseCursor,
    bool? enableFeedback,
    FocusNode? focusNode,
    ScrollController? scrollController,
    bool hideOnScroll = false,
  }) {
    return HapticFloatingActionButton(
      key: key,
      onPressed: onPressed,
      tooltip: tooltip,
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
      focusColor: focusColor,
      hoverColor: hoverColor,
      splashColor: splashColor,
      elevation: elevation,
      focusElevation: focusElevation,
      hoverElevation: hoverElevation,
      highlightElevation: highlightElevation,
      disabledElevation: disabledElevation,
      shape: shape,
      clipBehavior: clipBehavior,
      autofocus: autofocus,
      materialTapTargetSize: materialTapTargetSize,
      isExtended: true,
      mouseCursor: mouseCursor,
      enableFeedback: enableFeedback,
      focusNode: focusNode,
      scrollController: scrollController,
      hideOnScroll: hideOnScroll,
      child: icon != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                icon,
                const SizedBox(width: AppTypography.spacingSmall),
                label,
              ],
            )
          : label,
    );
  }

  @override
  State<HapticFloatingActionButton> createState() =>
      _HapticFloatingActionButtonState();
}

class _HapticFloatingActionButtonState extends State<HapticFloatingActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isVisible = true;
  double _lastScrollPosition = 0.0;
  static const double _scrollThreshold =
      10.0; // Minimum scroll distance to trigger hide/show

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Set up scroll listening if enabled
    if (widget.hideOnScroll && widget.scrollController != null) {
      _setupScrollListener();
    }

    // Start visible (set to completed state immediately)
    _animationController.value = 1.0;
  }

  @override
  void didUpdateWidget(HapticFloatingActionButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle scroll controller changes
    if (widget.scrollController != oldWidget.scrollController ||
        widget.hideOnScroll != oldWidget.hideOnScroll) {
      _tearDownScrollListener(oldWidget);
      if (widget.hideOnScroll && widget.scrollController != null) {
        _setupScrollListener();
      }
    }
  }

  @override
  void dispose() {
    _tearDownScrollListener(widget);
    _animationController.dispose();
    super.dispose();
  }

  void _setupScrollListener() {
    widget.scrollController?.addListener(_onScroll);
  }

  void _tearDownScrollListener(HapticFloatingActionButton oldWidget) {
    if (oldWidget.hideOnScroll && oldWidget.scrollController != null) {
      oldWidget.scrollController?.removeListener(_onScroll);
    }
  }

  void _onScroll() {
    if (!widget.hideOnScroll || widget.scrollController == null) return;

    final currentPosition = widget.scrollController!.position.pixels;
    final scrollDelta = currentPosition - _lastScrollPosition;

    // Only react to significant scroll movements
    if (scrollDelta.abs() < _scrollThreshold) return;

    final shouldHide = scrollDelta > 0; // Hide when scrolling down

    if (shouldHide && _isVisible) {
      _hideFAB();
    } else if (!shouldHide && !_isVisible) {
      _showFAB();
    }

    _lastScrollPosition = currentPosition;
  }

  void _hideFAB() {
    if (!_isVisible) return;
    setState(() {
      _isVisible = false;
    });
    _animationController.reverse();
  }

  void _showFAB() {
    if (_isVisible) return;
    setState(() {
      _isVisible = true;
    });
    _animationController.forward();
  }

  void _onPressed() {
    if (widget.onPressed != null) {
      HapticUtils.tap();
      widget.onPressed!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(scale: _scaleAnimation.value, child: child);
      },
      child: widget.isExtended
          ? FloatingActionButton.extended(
              onPressed: widget.onPressed != null ? _onPressed : null,
              label: widget.child!,
              tooltip: widget.tooltip,
              foregroundColor: widget.foregroundColor,
              backgroundColor: widget.backgroundColor,
              focusColor: widget.focusColor,
              hoverColor: widget.hoverColor,
              splashColor: widget.splashColor,
              elevation: widget.elevation,
              focusElevation: widget.focusElevation,
              hoverElevation: widget.hoverElevation,
              highlightElevation: widget.highlightElevation,
              disabledElevation: widget.disabledElevation,
              shape: widget.shape,
              clipBehavior: widget.clipBehavior,
              autofocus: widget.autofocus,
              materialTapTargetSize: widget.materialTapTargetSize,
              mouseCursor: widget.mouseCursor,
              enableFeedback: widget.enableFeedback,
              focusNode: widget.focusNode,
            )
          : FloatingActionButton(
              onPressed: widget.onPressed != null ? _onPressed : null,
              tooltip: widget.tooltip,
              foregroundColor: widget.foregroundColor,
              backgroundColor: widget.backgroundColor,
              focusColor: widget.focusColor,
              hoverColor: widget.hoverColor,
              splashColor: widget.splashColor,
              elevation: widget.elevation,
              focusElevation: widget.focusElevation,
              hoverElevation: widget.hoverElevation,
              highlightElevation: widget.highlightElevation,
              disabledElevation: widget.disabledElevation,
              shape: widget.shape,
              mini: widget.mini,
              clipBehavior: widget.clipBehavior,
              autofocus: widget.autofocus,
              materialTapTargetSize: widget.materialTapTargetSize,
              mouseCursor: widget.mouseCursor,
              enableFeedback: widget.enableFeedback,
              focusNode: widget.focusNode,
              child: widget.child,
            ),
    );
  }
}
