import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graviton/l10n/app_localizations.dart';

/// Service for managing semantic focus traversal and accessibility navigation
class SemanticFocusService {
  static final SemanticFocusService _instance =
      SemanticFocusService._internal();
  static SemanticFocusService get instance => _instance;
  SemanticFocusService._internal();

  /// Focus nodes for main UI elements in traversal order
  final FocusNode simulationCanvasFocusNode = FocusNode();
  final FocusNode cameraControlsFocusNode = FocusNode();
  final FocusNode simulationControlsFocusNode = FocusNode();
  final FocusNode bottomSheetFocusNode = FocusNode();
  final FocusNode scenarioSelectorFocusNode = FocusNode();
  final FocusNode settingsButtonFocusNode = FocusNode();

  /// List of all focus nodes in logical traversal order
  late final List<FocusNode> _focusNodes = [
    simulationCanvasFocusNode,
    cameraControlsFocusNode,
    simulationControlsFocusNode,
    bottomSheetFocusNode,
    scenarioSelectorFocusNode,
    settingsButtonFocusNode,
  ];

  /// Current focus index
  int _currentFocusIndex = 0;

  /// Whether focus management is enabled
  bool _isEnabled = true;

  /// Enable or disable focus management
  void setEnabled(bool enabled) {
    _isEnabled = enabled;
  }

  /// Move focus to the next focusable element
  void focusNext() {
    if (!_isEnabled) return;

    _currentFocusIndex = (_currentFocusIndex + 1) % _focusNodes.length;
    _requestFocusAt(_currentFocusIndex);
  }

  /// Move focus to the previous focusable element
  void focusPrevious() {
    if (!_isEnabled) return;

    _currentFocusIndex =
        (_currentFocusIndex - 1 + _focusNodes.length) % _focusNodes.length;
    _requestFocusAt(_currentFocusIndex);
  }

  /// Focus on a specific element by index
  void focusAt(int index) {
    if (!_isEnabled || index < 0 || index >= _focusNodes.length) return;

    _currentFocusIndex = index;
    _requestFocusAt(index);
  }

  /// Focus on the simulation canvas (primary focus)
  void focusSimulation() {
    focusAt(0);
  }

  /// Focus on camera controls
  void focusCameraControls() {
    focusAt(1);
  }

  /// Focus on simulation controls
  void focusSimulationControls() {
    focusAt(2);
  }

  /// Focus on bottom sheet
  void focusBottomSheet() {
    focusAt(3);
  }

  /// Focus on scenario selector
  void focusScenarioSelector() {
    focusAt(4);
  }

  /// Focus on settings button
  void focusSettings() {
    focusAt(5);
  }

  /// Get the currently focused element index
  int get currentFocusIndex => _currentFocusIndex;

  /// Get the current focus node
  FocusNode get currentFocusNode => _focusNodes[_currentFocusIndex];

  /// Check if a specific element has focus
  bool hasFocus(int index) {
    if (index < 0 || index >= _focusNodes.length) return false;
    return _focusNodes[index].hasFocus;
  }

  /// Internal method to request focus at a specific index
  void _requestFocusAt(int index) {
    if (index >= 0 && index < _focusNodes.length) {
      _focusNodes[index].requestFocus();
    }
  }

  /// Create a focus scope widget for managing semantic focus
  Widget createFocusScope({required Widget child, bool autofocus = false}) {
    return FocusScope(autofocus: autofocus, child: child);
  }

  /// Create a semantic focus wrapper with proper traversal order
  Widget createSemanticFocusWrapper({
    required Widget child,
    required FocusNode focusNode,
    required String semanticLabel,
    String? semanticHint,
    VoidCallback? onTap,
    bool canRequestFocus = true,
    bool excludeSemantics = false,
  }) {
    return Focus(
      focusNode: focusNode,
      canRequestFocus: canRequestFocus,
      child: Semantics(
        label: semanticLabel,
        hint: semanticHint,
        focused: focusNode.hasFocus,
        button: onTap != null,
        onTap: onTap,
        excludeSemantics: excludeSemantics,
        child: child,
      ),
    );
  }

  /// Create keyboard shortcuts for focus navigation
  Widget createFocusKeyboardShortcuts({required Widget child}) {
    return Focus(
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          // Tab: Next focus
          if (event.logicalKey == LogicalKeyboardKey.tab) {
            if (HardwareKeyboard.instance.isShiftPressed) {
              focusPrevious();
            } else {
              focusNext();
            }
            return KeyEventResult.handled;
          }

          // Arrow keys for directional navigation
          if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
            focusNext();
            return KeyEventResult.handled;
          }

          if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
            focusPrevious();
            return KeyEventResult.handled;
          }
        }

        return KeyEventResult.ignored;
      },
      child: child,
    );
  }

  /// Get accessibility description for current focus state
  String getFocusDescription(AppLocalizations l10n) {
    // Use localized descriptions
    switch (_currentFocusIndex) {
      case 0:
        return l10n.simulationCanvasFocused;
      case 1:
        return l10n.cameraControlsFocused;
      case 2:
        return l10n.simulationControlsFocused;
      case 3:
        return l10n.bottomSheetFocused;
      case 4:
        return l10n.scenarioSelectorFocused;
      case 5:
        return l10n.settingsButtonFocused;
      default:
        return l10n.simulationCanvasFocused;
    }
  }

  /// Get available focus actions for current element
  List<String> getAvailableActions(AppLocalizations l10n) {
    switch (_currentFocusIndex) {
      case 0: // Simulation canvas
        return [
          l10n.tapToInteractWithSimulation,
          l10n.useKeyboardShortcutsForControls,
          l10n.dragToRotateCameraView,
          l10n.pinchToZoomInOut,
        ];
      case 1: // Camera controls
        return [
          l10n.tapToCenterCamera,
          l10n.tapToToggleAutoRotation,
          l10n.useZoomControls,
        ];
      case 2: // Simulation controls
        return [
          l10n.tapPlayPauseButton,
          l10n.tapResetButton,
          l10n.adjustSimulationSpeed,
        ];
      case 3: // Bottom sheet
        return [
          l10n.swipeUpToExpand,
          l10n.accessScenarioOptions,
          l10n.viewPhysicsSettings,
        ];
      case 4: // Scenario selector
        return [l10n.tapToChangeScenario, l10n.browseAvailableSimulations];
      case 5: // Settings button
        return [l10n.tapToOpenSettings, l10n.accessAppPreferences];
      default:
        return [l10n.noActionsAvailable];
    }
  }

  /// Dispose of all focus nodes
  void dispose() {
    for (final node in _focusNodes) {
      node.dispose();
    }
  }
}
