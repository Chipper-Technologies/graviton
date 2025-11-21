import 'package:flutter/material.dart';
import 'package:graviton/utils/haptic_utils.dart';

/// Enhanced GestureDetector with haptic feedback
class HapticGestureDetector extends StatelessWidget {
  final Widget child;
  final GestureTapCallback? onTap;
  final GestureLongPressCallback? onLongPress;
  final GestureTapDownCallback? onTapDown;
  final GestureTapUpCallback? onTapUp;
  final GestureTapCancelCallback? onTapCancel;
  final GestureTapCallback? onDoubleTap;
  final GestureScaleStartCallback? onScaleStart;
  final GestureScaleUpdateCallback? onScaleUpdate;
  final GestureScaleEndCallback? onScaleEnd;
  final GestureDragStartCallback? onPanStart;
  final GestureDragUpdateCallback? onPanUpdate;
  final GestureDragEndCallback? onPanEnd;
  final HitTestBehavior? behavior;
  final bool excludeFromSemantics;

  const HapticGestureDetector({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.onDoubleTap,
    this.onScaleStart,
    this.onScaleUpdate,
    this.onScaleEnd,
    this.onPanStart,
    this.onPanUpdate,
    this.onPanEnd,
    this.behavior,
    this.excludeFromSemantics = false,
  });

  @override
  Widget build(BuildContext context) {
    // Only show pointer cursor for explicit tap/click actions, not for
    // drag/pan/scale gestures which might cover large interactive areas
    final bool hasClickableAction = onTap != null || onLongPress != null;

    final gestureDetector = GestureDetector(
      onTap: onTap == null
          ? null
          : () {
              HapticUtils.tap();
              onTap!();
            },
      onLongPress: onLongPress == null
          ? null
          : () {
              HapticUtils.longPress();
              onLongPress!();
            },
      onDoubleTap: onDoubleTap == null
          ? null
          : () {
              HapticUtils.tap();
              onDoubleTap!();
            },
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      onScaleStart: onScaleStart,
      onScaleUpdate: onScaleUpdate,
      onScaleEnd: onScaleEnd,
      onPanStart: onPanStart,
      onPanUpdate: onPanUpdate,
      onPanEnd: onPanEnd,
      behavior: behavior,
      excludeFromSemantics: excludeFromSemantics,
      child: child,
    );

    // Only wrap in MouseRegion if we have clickable actions
    if (hasClickableAction) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: gestureDetector,
      );
    }

    return gestureDetector;
  }
}
