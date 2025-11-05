import 'package:flutter/material.dart';
import 'package:graviton/utils/haptic_utils.dart';

/// Enhanced InkWell with haptic feedback
class HapticInkWell extends StatelessWidget {
  final Widget? child;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onDoubleTap;
  final GestureLongPressCallback? onLongPress;
  final GestureTapDownCallback? onTapDown;
  final GestureTapUpCallback? onTapUp;
  final GestureTapCancelCallback? onTapCancel;
  final ValueChanged<bool>? onHighlightChanged;
  final ValueChanged<bool>? onHover;
  final MouseCursor? mouseCursor;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? highlightColor;
  final WidgetStateProperty<Color?>? overlayColor;
  final Color? splashColor;
  final InteractiveInkFeatureFactory? splashFactory;
  final double? radius;
  final BorderRadius? borderRadius;
  final ShapeBorder? customBorder;
  final bool? enableFeedback;
  final bool excludeFromSemantics;
  final FocusNode? focusNode;
  final bool canRequestFocus;
  final ValueChanged<bool>? onFocusChange;
  final bool autofocus;

  const HapticInkWell({
    super.key,
    this.child,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.onHighlightChanged,
    this.onHover,
    this.mouseCursor,
    this.focusColor,
    this.hoverColor,
    this.highlightColor,
    this.overlayColor,
    this.splashColor,
    this.splashFactory,
    this.radius,
    this.borderRadius,
    this.customBorder,
    this.enableFeedback,
    this.excludeFromSemantics = false,
    this.focusNode,
    this.canRequestFocus = true,
    this.onFocusChange,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap == null
          ? null
          : () {
              HapticUtils.tap();
              onTap!();
            },
      onDoubleTap: onDoubleTap == null
          ? null
          : () {
              HapticUtils.tap();
              onDoubleTap!();
            },
      onLongPress: onLongPress == null
          ? null
          : () {
              HapticUtils.longPress();
              onLongPress!();
            },
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      onHighlightChanged: onHighlightChanged,
      onHover: onHover,
      mouseCursor: mouseCursor,
      focusColor: focusColor,
      hoverColor: hoverColor,
      highlightColor: highlightColor,
      overlayColor: overlayColor,
      splashColor: splashColor,
      splashFactory: splashFactory,
      radius: radius,
      borderRadius: borderRadius,
      customBorder: customBorder,
      enableFeedback: enableFeedback ?? true,
      excludeFromSemantics: excludeFromSemantics,
      focusNode: focusNode,
      canRequestFocus: canRequestFocus,
      onFocusChange: onFocusChange,
      autofocus: autofocus,
      child: child,
    );
  }
}
