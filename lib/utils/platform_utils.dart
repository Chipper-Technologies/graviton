import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:graviton/core/constants/rendering_constants.dart';

/// Utility functions for platform-specific behavior
class PlatformUtils {
  PlatformUtils._(); // Private constructor to prevent instantiation

  // ====== Basic Platform Detection ======

  /// Check if the current platform is Android
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;

  /// Check if the current platform is iOS
  static bool get isIOS => !kIsWeb && Platform.isIOS;

  /// Check if the current platform is macOS
  static bool get isMacOS => !kIsWeb && Platform.isMacOS;

  /// Check if the current platform is Windows
  static bool get isWindows => !kIsWeb && Platform.isWindows;

  /// Check if the current platform is Linux
  static bool get isLinux => !kIsWeb && Platform.isLinux;

  /// Check if the current platform is web
  static bool get isWeb => kIsWeb;

  // ====== Platform Categories ======

  /// Check if the current platform is a mobile platform (Android or iOS)
  static bool get isMobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  /// Check if the current platform is a desktop platform
  static bool get isDesktop =>
      !kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);

  /// Check if the current platform is Apple (iOS or macOS)
  static bool get isApple => !kIsWeb && (Platform.isIOS || Platform.isMacOS);

  // ====== Platform Capabilities ======

  /// Check if the platform supports hover interactions (mouse/trackpad)
  /// Desktop platforms and web support hover, mobile does not
  static bool get supportsHover => isDesktop || isWeb;

  /// Check if the platform supports haptic feedback
  /// Mobile platforms support haptics, desktop typically does not
  static bool get supportsHaptics => isMobile;

  /// Check if the platform supports custom mouse cursors
  /// Desktop and web support custom cursors, mobile does not
  static bool get supportsCustomCursors => isDesktop || isWeb;

  /// Check if the platform has a physical keyboard typically available
  /// Desktop platforms have keyboards, mobile typically does not (unless external)
  static bool get hasPhysicalKeyboard => isDesktop;

  /// Check if the platform supports window management (resize, minimize, etc.)
  /// Desktop platforms support window management, mobile/web may not
  static bool get supportsWindowManagement => isDesktop;

  /// Check if the platform supports file system access
  /// Desktop and mobile support file access, web has limited support
  static bool get supportsFileSystem => !isWeb;

  // ====== UI Behavior Helpers ======

  /// Check if tooltips should be shown by default
  /// Tooltips are more useful on hover-enabled platforms
  static bool get shouldShowTooltips => supportsHover;

  /// Check if cursor should auto-hide during interactions
  /// Useful for immersive experiences on desktop platforms
  static bool get shouldAutoHideCursor => isDesktop;

  /// Check if platform uses system navigation bars
  /// Android uses system navigation bars, iOS uses gestures
  static bool get usesSystemNavigationBar => isAndroid;

  /// Check if platform uses native title bars
  /// Desktop platforms typically show native window title bars
  static bool get usesNativeTitleBar => isDesktop;

  /// Check if platform should use compact UI elements
  /// Mobile platforms benefit from larger touch targets
  static bool get shouldUseCompactUI => isDesktop;

  /// Check if platform should show scroll bars by default
  /// Desktop platforms typically show scrollbars, mobile auto-hides them
  static bool get shouldShowScrollbars => isDesktop;

  // ====== Platform-Specific Values ======

  /// Get platform-specific bottom sheet padding for system bar clearance
  /// Android needs extra padding for system navigation bar
  /// iOS handles this through safe areas automatically
  static double getBottomSheetSystemBarPadding() {
    return (!kIsWeb && Platform.isAndroid)
        ? RenderingConstants.bottomSheetSystemBarPadding
        : 0.0;
  }

  /// Get platform-specific minimum touch target size
  /// Mobile platforms need larger touch targets (48-56dp)
  /// Desktop can use smaller targets with precise mouse input
  static double getMinimumTouchTargetSize() {
    if (isMobile) {
      return 48.0; // Material Design mobile touch target
    } else if (isDesktop) {
      return 32.0; // Smaller is acceptable with mouse precision
    } else {
      return 44.0; // Web default
    }
  }

  /// Get platform-specific icon size for buttons
  /// Scales based on platform conventions
  static double getIconSize() {
    if (isMobile) {
      return 24.0; // Standard mobile icon size
    } else if (isDesktop) {
      return 20.0; // Slightly smaller for desktop
    } else {
      return 22.0; // Web compromise
    }
  }

  /// Get platform-specific animation duration multiplier
  /// Desktop can use faster animations, mobile benefits from slightly longer
  static double getAnimationDurationMultiplier() {
    if (isMobile) {
      return 1.0; // Standard duration
    } else if (isDesktop) {
      return 0.8; // Slightly faster on desktop
    } else {
      return 0.9; // Web compromise
    }
  }

  // ====== Debug Utilities ======

  /// Get a human-readable platform name for debugging
  static String get platformName {
    if (kIsWeb) return 'Web';
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isLinux) return 'Linux';
    return 'Unknown';
  }

  /// Get operating system version information
  /// Returns empty string on web
  static String get osVersion {
    return kIsWeb ? '' : Platform.operatingSystemVersion;
  }

  /// Get a description of current platform capabilities
  static String get capabilitiesDescription {
    final caps = <String>[];
    if (supportsHover) caps.add('hover');
    if (supportsHaptics) caps.add('haptics');
    if (supportsCustomCursors) caps.add('cursors');
    if (hasPhysicalKeyboard) caps.add('keyboard');
    if (supportsWindowManagement) caps.add('windows');
    if (supportsFileSystem) caps.add('files');
    return caps.join(', ');
  }
}
