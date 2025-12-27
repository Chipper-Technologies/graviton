import 'package:flutter/material.dart';

/// Animated pulse effect widget
///
/// Creates a subtle scale animation that pulses when enabled.
/// Useful for drawing attention to time-sensitive UI elements.
class PulseAnimation extends StatefulWidget {
  /// The child widget to animate
  final Widget child;

  /// Whether the animation is enabled
  final bool enabled;

  /// Duration of one pulse cycle
  final Duration duration;

  /// Maximum scale factor at peak of pulse
  final double maxScale;

  const PulseAnimation({
    required this.child,
    required this.enabled,
    this.duration = const Duration(milliseconds: 1000),
    this.maxScale = 1.05,
    super.key,
  });

  @override
  State<PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<PulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(
      begin: 1.0,
      end: widget.maxScale,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (widget.enabled) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(PulseAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled && !oldWidget.enabled) {
      _controller.repeat(reverse: true);
    } else if (!widget.enabled && oldWidget.enabled) {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(scale: _animation.value, child: child);
      },
      child: widget.child,
    );
  }
}
