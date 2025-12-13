import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graviton/core/enums/ui_action.dart';
import 'package:graviton/core/enums/ui_element.dart';
import 'package:graviton/services/firebase/firebase_service.dart';
import 'package:graviton/services/ui/haptic_feedback_service.dart';

/// Service for handling keyboard navigation and accessibility shortcuts
class KeyboardNavigationService {
  static final KeyboardNavigationService _instance =
      KeyboardNavigationService._internal();
  static KeyboardNavigationService get instance => _instance;
  KeyboardNavigationService._internal();

  /// Callback functions for various keyboard actions
  VoidCallback? _onPlayPause;
  VoidCallback? _onReset;
  VoidCallback? _onCenterCamera;
  VoidCallback? _onToggleAutoRotate;
  VoidCallback? _onZoomIn;
  VoidCallback? _onZoomOut;
  VoidCallback? _onToggleTrails;
  VoidCallback? _onToggleStats;
  VoidCallback? _onToggleLabels;
  VoidCallback? _onNextScenario;
  VoidCallback? _onPreviousScenario;
  VoidCallback? _onOpenSettings;

  /// Whether keyboard navigation is currently enabled
  bool _isEnabled = true;

  /// Focus node for the main simulation area
  final FocusNode simulationFocusNode = FocusNode();

  /// Enable or disable keyboard navigation
  void setEnabled(bool enabled) {
    _isEnabled = enabled;
  }

  /// Register callback functions for keyboard shortcuts
  void registerCallbacks({
    VoidCallback? onPlayPause,
    VoidCallback? onReset,
    VoidCallback? onCenterCamera,
    VoidCallback? onToggleAutoRotate,
    VoidCallback? onZoomIn,
    VoidCallback? onZoomOut,
    VoidCallback? onToggleTrails,
    VoidCallback? onToggleStats,
    VoidCallback? onToggleLabels,
    VoidCallback? onNextScenario,
    VoidCallback? onPreviousScenario,
    VoidCallback? onOpenSettings,
  }) {
    _onPlayPause = onPlayPause;
    _onReset = onReset;
    _onCenterCamera = onCenterCamera;
    _onToggleAutoRotate = onToggleAutoRotate;
    _onZoomIn = onZoomIn;
    _onZoomOut = onZoomOut;
    _onToggleTrails = onToggleTrails;
    _onToggleStats = onToggleStats;
    _onToggleLabels = onToggleLabels;
    _onNextScenario = onNextScenario;
    _onPreviousScenario = onPreviousScenario;
    _onOpenSettings = onOpenSettings;
  }

  /// Handle keyboard events
  bool handleKeyEvent(KeyEvent event) {
    if (!_isEnabled || event is! KeyDownEvent) {
      return false;
    }

    // Check for modifier keys
    final isCtrlPressed = HardwareKeyboard.instance.isControlPressed;

    switch (event.logicalKey) {
      // Space: Play/Pause
      case LogicalKeyboardKey.space:
        _executeWithHaptic(_onPlayPause, 'Space');
        return true;

      // R: Reset simulation
      case LogicalKeyboardKey.keyR:
        _executeWithHaptic(_onReset, 'R');
        return true;

      // C: Center camera
      case LogicalKeyboardKey.keyC:
        _executeWithHaptic(_onCenterCamera, 'C');
        return true;

      // A: Toggle auto-rotate
      case LogicalKeyboardKey.keyA:
        _executeWithHaptic(_onToggleAutoRotate, 'A');
        return true;

      // Plus/Equal: Zoom in
      case LogicalKeyboardKey.equal:
      case LogicalKeyboardKey.numpadAdd:
        _executeWithHaptic(
          _onZoomIn,
          event.logicalKey == LogicalKeyboardKey.equal ? '+' : 'Numpad+',
        );
        return true;

      // Minus: Zoom out
      case LogicalKeyboardKey.minus:
      case LogicalKeyboardKey.numpadSubtract:
        _executeWithHaptic(
          _onZoomOut,
          event.logicalKey == LogicalKeyboardKey.minus ? '-' : 'Numpad-',
        );
        return true;

      // T: Toggle trails
      case LogicalKeyboardKey.keyT:
        _executeWithHaptic(_onToggleTrails, 'T');
        return true;

      // S: Toggle stats (without Ctrl modifier)
      case LogicalKeyboardKey.keyS:
        if (!isCtrlPressed) {
          _executeWithHaptic(_onToggleStats, 'S');
          return true;
        }
        return false;

      // L: Toggle labels
      case LogicalKeyboardKey.keyL:
        _executeWithHaptic(_onToggleLabels, 'L');
        return true;

      // Arrow keys for scenario navigation
      case LogicalKeyboardKey.arrowRight:
        if (isCtrlPressed) {
          _executeWithHaptic(_onNextScenario, 'Ctrl+Right');
          return true;
        }
        return false;

      case LogicalKeyboardKey.arrowLeft:
        if (isCtrlPressed) {
          _executeWithHaptic(_onPreviousScenario, 'Ctrl+Left');
          return true;
        }
        return false;

      // Escape or Ctrl+, : Open settings
      case LogicalKeyboardKey.escape:
        _executeWithHaptic(_onOpenSettings, 'Escape');
        return true;

      case LogicalKeyboardKey.comma:
        if (isCtrlPressed) {
          _executeWithHaptic(_onOpenSettings, 'Ctrl+,');
          return true;
        }
        return false;

      default:
        return false;
    }
  }

  /// Execute callback with haptic feedback and analytics
  void _executeWithHaptic(VoidCallback? callback, [String? shortcutKey]) {
    if (callback != null) {
      HapticFeedbackService.instance.light();

      // Log keyboard shortcut usage
      if (shortcutKey != null) {
        _logKeyboardShortcut(shortcutKey);
      }

      callback();
    }
  }

  /// Log keyboard shortcut usage analytics
  void _logKeyboardShortcut(String shortcutKey) {
    FirebaseService.instance.logUIEventWithEnums(
      UIAction.keyboardShortcutUsed,
      element: UIElement.keyboardShortcuts,
      value: shortcutKey,
      additionalParams: {
        'shortcut_key': shortcutKey,
        'has_focus': hasFocus.toString(),
        'navigation_enabled': _isEnabled.toString(),
        'input_method': 'keyboard',
      },
    );

    // Also log as accessibility navigation usage
    FirebaseService.instance.logUIEventWithEnums(
      UIAction.accessibilityNavigation,
      element: UIElement.accessibilityNavigation,
      value: shortcutKey,
      additionalParams: {
        'navigation_type': 'keyboard_shortcut',
        'shortcut_action': _getShortcutAction(shortcutKey),
      },
    );
  }

  /// Get the action name for a keyboard shortcut
  String _getShortcutAction(String shortcutKey) {
    switch (shortcutKey.toLowerCase()) {
      case 'space':
        return 'play_pause';
      case 'r':
        return 'reset';
      case 'c':
        return 'center_camera';
      case 'a':
        return 'auto_rotate';
      case '+':
      case '=':
      case 'numpad_add':
        return 'zoom_in';
      case '-':
      case 'numpad_subtract':
        return 'zoom_out';
      case 't':
        return 'toggle_trails';
      case 's':
        return 'toggle_stats';
      case 'l':
        return 'toggle_labels';
      case 'ctrl+right':
        return 'next_scenario';
      case 'ctrl+left':
        return 'previous_scenario';
      case 'escape':
      case 'ctrl+,':
        return 'open_settings';
      default:
        return 'unknown';
    }
  }

  /// Get keyboard shortcuts help text
  String getKeyboardShortcutsHelp() {
    return '''
Keyboard Shortcuts:
• Space: Play/Pause simulation
• R: Reset simulation
• C: Center camera view
• A: Toggle auto-rotation
• +/-: Zoom in/out
• T: Toggle trails
• S: Toggle statistics
• L: Toggle body labels
• Ctrl+←/→: Previous/Next scenario
• Esc: Open settings
• Ctrl+,: Open settings (alternative)
''';
  }

  /// Create a keyboard listener widget
  Widget createKeyboardListener({
    required Widget child,
    bool requestFocus = true,
  }) {
    return KeyboardListener(
      focusNode: simulationFocusNode,
      autofocus: requestFocus,
      onKeyEvent: handleKeyEvent,
      child: child,
    );
  }

  /// Request focus for keyboard navigation
  void requestFocus() {
    simulationFocusNode.requestFocus();
  }

  /// Check if the simulation area has focus
  bool get hasFocus => simulationFocusNode.hasFocus;

  /// Dispose of resources
  void dispose() {
    simulationFocusNode.dispose();
  }
}
