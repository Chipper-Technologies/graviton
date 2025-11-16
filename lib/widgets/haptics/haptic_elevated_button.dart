import 'package:flutter/material.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/utils/haptic_utils.dart';

/// Enhanced ElevatedButton with haptic feedback
class HapticElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final ButtonStyle? style;
  final VoidCallback? onLongPress;
  final ValueChanged<bool>? onHover;
  final ValueChanged<bool>? onFocusChange;
  final bool autofocus;
  final Clip clipBehavior;
  final FocusNode? focusNode;

  const HapticElevatedButton({
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

  /// Factory constructor for icon button
  factory HapticElevatedButton.icon({
    Key? key,
    required VoidCallback? onPressed,
    required Widget icon,
    required Widget label,
    ButtonStyle? style,
    VoidCallback? onLongPress,
    ValueChanged<bool>? onHover,
    ValueChanged<bool>? onFocusChange,
    bool autofocus = false,
    Clip clipBehavior = Clip.none,
    FocusNode? focusNode,
  }) {
    return HapticElevatedButton(
      key: key,
      onPressed: onPressed,
      style: style,
      onLongPress: onLongPress,
      onHover: onHover,
      onFocusChange: onFocusChange,
      autofocus: autofocus,
      clipBehavior: clipBehavior,
      focusNode: focusNode,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(width: AppTypography.spacingSmall),
          label,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
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
