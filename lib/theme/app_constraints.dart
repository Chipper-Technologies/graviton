import 'package:flutter/material.dart';

/// Centralized UI constraints for consistent sizing across the app
class AppConstraints {
  AppConstraints._();

  // Dialog Constraints
  /// Standard width for most dialogs
  static const double dialogStandardWidth = 600;

  /// Compact height for simple dialogs (About)
  static const double dialogCompactHeight = 600;

  /// Medium height for content-rich dialogs (Settings)
  static const double dialogMediumHeight = 800;

  /// Large height for text-heavy dialogs (Help)
  static const double dialogLargeHeight = 900;

  /// Standard dialog constraints for about/info dialogs
  static const BoxConstraints dialogCompact = BoxConstraints(
    maxWidth: dialogStandardWidth,
    maxHeight: dialogCompactHeight,
  );

  /// Medium dialog constraints for settings/configuration dialogs
  static const BoxConstraints dialogMedium = BoxConstraints(
    maxWidth: dialogStandardWidth,
    maxHeight: dialogMediumHeight,
  );

  /// Large dialog constraints for help/documentation dialogs
  static const BoxConstraints dialogLarge = BoxConstraints(
    maxWidth: dialogStandardWidth,
    maxHeight: dialogLargeHeight,
  );

  /// Custom dialog constraints with specified dimensions
  static BoxConstraints customDialog({
    double? width,
    double? height,
    double? maxWidth,
    double? maxHeight,
  }) {
    return BoxConstraints(
      minWidth: width ?? 0,
      maxWidth: maxWidth ?? width ?? dialogStandardWidth,
      minHeight: height ?? 0,
      maxHeight: maxHeight ?? height ?? double.infinity,
    );
  }

  // Dialog Padding
  /// Standard padding for dialog content areas
  static const EdgeInsets dialogPadding = EdgeInsets.all(24);

  /// Compact padding for dialog content with less space
  static const EdgeInsets dialogPaddingCompact = EdgeInsets.all(16);

  // Future UI constraints can be added here:
  // - Button sizes
  // - Card dimensions
  // - Modal sizes
  // - Panel widths
  // - etc.
}
