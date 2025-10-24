import 'package:flutter/material.dart';

/// App-wide constraint constants for consistent layout and design
class AppConstraints {
  // Dialog constraints
  static const BoxConstraints dialogSmall = BoxConstraints(
    maxWidth: 300,
    maxHeight: 400,
  );
  static const BoxConstraints dialogMedium = BoxConstraints(
    maxWidth: 400,
    maxHeight: 600,
  );
  static const BoxConstraints dialogLarge = BoxConstraints(
    maxWidth: 500,
    maxHeight: 700,
  );

  // Padding constants
  static const EdgeInsets dialogPadding = EdgeInsets.all(20);
  static const EdgeInsets cardPadding = EdgeInsets.all(16);
  static const EdgeInsets sectionPadding = EdgeInsets.symmetric(
    vertical: 12,
    horizontal: 16,
  );

  // Spacing constants
  static const double smallSpacing = 8.0;
  static const double mediumSpacing = 16.0;
  static const double largeSpacing = 24.0;

  // Border radius constants
  static const double cardRadius = 12.0;
  static const double dialogRadius = 16.0;
  static const double buttonRadius = 8.0;
}
