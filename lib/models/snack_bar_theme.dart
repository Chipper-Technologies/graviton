import 'package:flutter/material.dart';

/// Theme configuration for SnackBar styling
/// 
/// This model encapsulates all the visual styling properties needed
/// to render a SnackBar with consistent theming across the app.
class SnackBarTheme {
  /// Background color of the SnackBar
  final Color backgroundColor;
  
  /// Border color of the SnackBar
  final Color borderColor;
  
  /// Color of the message text
  final Color textColor;
  
  /// Color of the severity icon
  final Color iconColor;
  
  /// Color of action button text
  final Color actionColor;
  
  /// Icon data for the severity indicator
  final IconData icon;

  /// Creates a new SnackBar theme configuration
  const SnackBarTheme({
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    required this.iconColor,
    required this.actionColor,
    required this.icon,
  });

  /// Creates a copy of this theme with the given fields replaced
  SnackBarTheme copyWith({
    Color? backgroundColor,
    Color? borderColor,
    Color? textColor,
    Color? iconColor,
    Color? actionColor,
    IconData? icon,
  }) {
    return SnackBarTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      textColor: textColor ?? this.textColor,
      iconColor: iconColor ?? this.iconColor,
      actionColor: actionColor ?? this.actionColor,
      icon: icon ?? this.icon,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is SnackBarTheme &&
      other.backgroundColor == backgroundColor &&
      other.borderColor == borderColor &&
      other.textColor == textColor &&
      other.iconColor == iconColor &&
      other.actionColor == actionColor &&
      other.icon == icon;
  }

  @override
  int get hashCode {
    return backgroundColor.hashCode ^
      borderColor.hashCode ^
      textColor.hashCode ^
      iconColor.hashCode ^
      actionColor.hashCode ^
      icon.hashCode;
  }

  @override
  String toString() {
    return 'SnackBarTheme(backgroundColor: $backgroundColor, '
        'borderColor: $borderColor, textColor: $textColor, '
        'iconColor: $iconColor, actionColor: $actionColor, '
        'icon: $icon)';
  }
}