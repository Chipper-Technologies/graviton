import 'package:flutter/material.dart';
import 'package:graviton/utils/haptic_utils.dart';

/// Enhanced IconButton with haptic feedback
class HapticIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget icon;
  final double? iconSize;
  final VisualDensity? visualDensity;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry? alignment;
  final double? splashRadius;
  final Color? color;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? highlightColor;
  final Color? splashColor;
  final Color? disabledColor;
  final String? tooltip;
  final bool autofocus;
  final bool? enableFeedback;
  final BoxConstraints? constraints;
  final ButtonStyle? style;
  final bool? isSelected;
  final Widget? selectedIcon;
  final FocusNode? focusNode;

  const HapticIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.iconSize,
    this.visualDensity,
    this.padding,
    this.alignment,
    this.splashRadius,
    this.color,
    this.focusColor,
    this.hoverColor,
    this.highlightColor,
    this.splashColor,
    this.disabledColor,
    this.tooltip,
    this.autofocus = false,
    this.enableFeedback,
    this.constraints,
    this.style,
    this.isSelected,
    this.selectedIcon,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed == null
          ? null
          : () {
              HapticUtils.tap();
              onPressed!();
            },
      mouseCursor: onPressed == null
          ? SystemMouseCursors.basic
          : SystemMouseCursors.click,
      icon: icon,
      iconSize: iconSize,
      visualDensity: visualDensity,
      padding: padding,
      alignment: alignment,
      splashRadius: splashRadius,
      color: color,
      focusColor: focusColor,
      hoverColor: hoverColor,
      highlightColor: highlightColor,
      splashColor: splashColor,
      disabledColor: disabledColor,
      tooltip: tooltip,
      autofocus: autofocus,
      enableFeedback: enableFeedback,
      constraints: constraints,
      style: style,
      isSelected: isSelected,
      selectedIcon: selectedIcon,
      focusNode: focusNode,
    );
  }
}
