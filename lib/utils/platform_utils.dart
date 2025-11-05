import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:graviton/constants/rendering_constants.dart';

/// Utility functions for platform-specific behavior
class PlatformUtils {
  PlatformUtils._(); // Private constructor to prevent instantiation

  /// Check if the current platform is Android
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;

  /// Check if the current platform is iOS
  static bool get isIOS => !kIsWeb && Platform.isIOS;

  /// Check if the current platform is a mobile platform (Android or iOS)
  static bool get isMobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  /// Check if the current platform is a desktop platform
  static bool get isDesktop =>
      !kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);

  /// Check if the current platform is web
  static bool get isWeb => kIsWeb;

  /// Get platform-specific bottom sheet padding for system bar clearance
  /// Android needs extra padding for system navigation bar
  /// iOS handles this through safe areas automatically
  static double getBottomSheetSystemBarPadding() {
    return (!kIsWeb && Platform.isAndroid)
        ? RenderingConstants.bottomSheetSystemBarPadding
        : 0.0;
  }
}
