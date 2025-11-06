import 'package:flutter/material.dart';
import 'package:graviton/utils/haptic_utils.dart';

/// Enhanced TextButton with haptic feedback
class HapticTextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final ButtonStyle? style;
  final VoidCallback? onLongPress;
  final ValueChanged<bool>? onHover;
  final ValueChanged<bool>? onFocusChange;
  final bool autofocus;
  final Clip clipBehavior;
  final FocusNode? focusNode;

  const HapticTextButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.style,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.autofocus = false,
    this.clipBehavior = Clip.none,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed == null
          ? null
          : () {
              HapticUtils.tap();
              onPressed!();
            },
      onLongPress: onLongPress == null
          ? null
          : () {
              HapticUtils.longPress();
              onLongPress!();
            },
      style: style,
      onHover: onHover,
      onFocusChange: onFocusChange,
      autofocus: autofocus,
      clipBehavior: clipBehavior,
      focusNode: focusNode,
      child: child,
    );
  }
}
