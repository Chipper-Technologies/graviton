import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:graviton/enums/accessibility_simulation_state.dart';
import 'package:graviton/enums/accessibility_physics_parameter.dart';
import 'package:graviton/enums/accessibility_camera_action.dart';
import 'package:graviton/enums/live_region_importance.dart';
import 'package:graviton/l10n/app_localizations.dart';

/// Service for managing accessibility features and live region announcements
class AccessibilityService {
  static final AccessibilityService _instance =
      AccessibilityService._internal();
  static AccessibilityService get instance => _instance;
  AccessibilityService._internal();

  /// Announce a message to screen readers using live regions
  ///
  /// This method creates a live region announcement that will be read
  /// by screen readers when important events occur in the simulation.
  void announceToScreenReader(
    String message, {
    LiveRegionImportance importance = LiveRegionImportance.polite,
  }) {
    // Check if we have a valid binding before attempting to announce
    if (_hasValidBinding()) {
      try {
        // Use SemanticsService to announce the message
        SemanticsService.announce(message, TextDirection.ltr);
      } catch (e) {
        // Gracefully handle any cases where accessibility services are unavailable
        if (kDebugMode) {
          debugPrint(
            'Accessibility announcement failed: $message (${e.toString()})',
          );
        }
      }
    } else {
      // Silently fail if binding is not available (common in tests)
      if (kDebugMode) {
        debugPrint('Accessibility announcement skipped (no binding): $message');
      }
    }
  }

  /// Check if we have a valid binding available for announcements
  bool _hasValidBinding() {
    try {
      // Check if ServicesBinding instance is available
      final binding = ServicesBinding.instance;

      // Try to access the defaultBinaryMessenger and verify it's functional
      // by checking if we can access its properties without exception
      final messenger = binding.defaultBinaryMessenger;

      // Additional validation by checking if we can access messenger properties
      // This ensures the messenger is not just non-null but actually functional
      messenger
          .toString(); // Simple operation that should work if messenger is valid

      return true;
    } catch (e) {
      // If any exception occurs, binding is not available or not functional
      return false;
    }
  }

  /// Announce simulation events with appropriate context
  void announceSimulationEvent(String event, {String? additionalContext}) {
    final message = additionalContext != null
        ? '$event. $additionalContext'
        : event;

    announceToScreenReader(message, importance: LiveRegionImportance.polite);
  }

  /// Announce collision/merge events
  void announceMergeEvent(
    String body1Name,
    String body2Name, {
    AppLocalizations? l10n,
  }) {
    if (l10n != null) {
      final message = l10n.accessibilityMergeEvent(body1Name, body2Name);
      announceSimulationEvent(
        message,
        additionalContext: l10n.accessibilityMergeEventContext,
      );
    } else {
      // Fallback to English - these should be rare cases when l10n is not available
      announceSimulationEvent(
        'Collision detected: $body1Name merged with $body2Name',
        additionalContext: 'The combined mass creates a new celestial body',
      );
    }
  }

  /// Announce simulation state changes
  void announceSimulationStateChange(String state, {AppLocalizations? l10n}) {
    if (l10n == null) {
      // Fallback to English if no localization provided
      _announceSimulationStateChangeFallback(state);
      return;
    }

    final accessibilityState = AccessibilitySimulationState.fromString(state);
    final announcement = _getLocalizedStateAnnouncement(
      accessibilityState,
      l10n,
    );
    final context = _getLocalizedStateContext(accessibilityState, l10n);

    announceSimulationEvent(announcement, additionalContext: context);
  }

  /// Fallback method for when localization is not available
  void _announceSimulationStateChangeFallback(String state) {
    final accessibilityState = AccessibilitySimulationState.fromString(state);
    String announcement;
    String? context;

    switch (accessibilityState) {
      case AccessibilitySimulationState.started:
      case AccessibilitySimulationState.running:
        announcement = 'Simulation started';
        context = 'Celestial bodies are now in motion';
        break;
      case AccessibilitySimulationState.paused:
        announcement = 'Simulation paused';
        context = 'All celestial bodies have stopped moving';
        break;
      case AccessibilitySimulationState.resumed:
        announcement = 'Simulation resumed';
        context = 'Celestial bodies are moving again';
        break;
      case AccessibilitySimulationState.stopped:
        announcement = 'Simulation stopped';
        context = 'All celestial bodies have been reset';
        break;
      case AccessibilitySimulationState.reset:
        announcement = 'Simulation reset';
        context = 'New scenario loaded with fresh celestial bodies';
        break;
    }

    announceSimulationEvent(announcement, additionalContext: context);
  }

  /// Get localized state announcement
  String _getLocalizedStateAnnouncement(
    AccessibilitySimulationState state,
    AppLocalizations l10n,
  ) {
    switch (state) {
      case AccessibilitySimulationState.started:
      case AccessibilitySimulationState.running:
        return l10n.accessibilitySimulationStarted;
      case AccessibilitySimulationState.paused:
        return l10n.accessibilitySimulationPaused;
      case AccessibilitySimulationState.resumed:
        return l10n.accessibilitySimulationResumed;
      case AccessibilitySimulationState.stopped:
        return l10n.accessibilitySimulationStopped;
      case AccessibilitySimulationState.reset:
        return l10n.accessibilitySimulationReset;
    }
  }

  /// Get localized state context
  String _getLocalizedStateContext(
    AccessibilitySimulationState state,
    AppLocalizations l10n,
  ) {
    switch (state) {
      case AccessibilitySimulationState.started:
      case AccessibilitySimulationState.running:
        return l10n.accessibilitySimulationStartedContext;
      case AccessibilitySimulationState.paused:
        return l10n.accessibilitySimulationPausedContext;
      case AccessibilitySimulationState.resumed:
        return l10n.accessibilitySimulationResumedContext;
      case AccessibilitySimulationState.stopped:
        return l10n.accessibilitySimulationStoppedContext;
      case AccessibilitySimulationState.reset:
        return l10n.accessibilitySimulationResetContext;
    }
  }

  /// Announce scenario changes
  void announceScenarioChange(String scenarioName, {AppLocalizations? l10n}) {
    if (l10n != null) {
      final message = l10n.accessibilityScenarioChange(scenarioName);
      announceSimulationEvent(
        message,
        additionalContext: l10n.accessibilityScenarioChangeContext,
      );
    } else {
      // Fallback to English
      announceSimulationEvent(
        'Scenario changed to $scenarioName',
        additionalContext: 'New celestial bodies and physics parameters loaded',
      );
    }
  }

  /// Announce physics parameter changes
  void announcePhysicsChange(
    String parameter,
    String newValue, {
    AppLocalizations? l10n,
  }) {
    final physicsParam = AccessibilityPhysicsParameter.fromString(parameter);
    String announcement;

    if (l10n != null) {
      announcement = _getLocalizedPhysicsAnnouncement(
        physicsParam,
        newValue,
        l10n,
      );
    } else {
      // Fallback to English
      announcement = _getPhysicsAnnouncementFallback(physicsParam, newValue);
    }

    announceToScreenReader(announcement);
  }

  /// Get localized physics change announcement
  String _getLocalizedPhysicsAnnouncement(
    AccessibilityPhysicsParameter parameter,
    String newValue,
    AppLocalizations l10n,
  ) {
    switch (parameter) {
      case AccessibilityPhysicsParameter.speed:
        return l10n.accessibilitySpeedChange(newValue);
      case AccessibilityPhysicsParameter.gravity:
        return l10n.accessibilityGravityChange(newValue);
      case AccessibilityPhysicsParameter.collisionRadius:
        return l10n.accessibilityCollisionRadiusChange(newValue);
    }
  }

  /// Fallback physics change announcement for when localization is not available
  String _getPhysicsAnnouncementFallback(
    AccessibilityPhysicsParameter parameter,
    String newValue,
  ) {
    switch (parameter) {
      case AccessibilityPhysicsParameter.speed:
        return 'Simulation speed changed to $newValue';
      case AccessibilityPhysicsParameter.gravity:
        return 'Gravity strength changed to $newValue';
      case AccessibilityPhysicsParameter.collisionRadius:
        return 'Collision sensitivity changed to $newValue';
    }
  }

  /// Announce camera actions
  void announceCameraAction(String action, {AppLocalizations? l10n}) {
    final cameraAction = AccessibilityCameraAction.fromString(action);
    String announcement;

    if (l10n != null) {
      announcement = _getLocalizedCameraAnnouncement(cameraAction, l10n);
    } else {
      // Fallback to English
      announcement = _getCameraAnnouncementFallback(cameraAction);
    }

    announceToScreenReader(announcement);
  }

  /// Get localized camera action announcement
  String _getLocalizedCameraAnnouncement(
    AccessibilityCameraAction action,
    AppLocalizations l10n,
  ) {
    switch (action) {
      case AccessibilityCameraAction.reset:
        return l10n.accessibilityCameraReset;
      case AccessibilityCameraAction.focus:
        return l10n.accessibilityCameraFocus;
      case AccessibilityCameraAction.follow:
        return l10n.accessibilityCameraFollow;
      case AccessibilityCameraAction.unfollow:
        return l10n.accessibilityCameraUnfollow;
    }
  }

  /// Fallback camera action announcement for when localization is not available
  String _getCameraAnnouncementFallback(AccessibilityCameraAction action) {
    switch (action) {
      case AccessibilityCameraAction.reset:
        return 'Camera view reset to default position';
      case AccessibilityCameraAction.focus:
        return 'Camera focused on nearest celestial body';
      case AccessibilityCameraAction.follow:
        return 'Camera now following selected celestial body';
      case AccessibilityCameraAction.unfollow:
        return 'Camera stopped following celestial body';
    }
  }

  /// Announce tutorial progress
  void announceTutorialProgress(
    String stepName,
    int currentStep,
    int totalSteps, {
    AppLocalizations? l10n,
  }) {
    String announcement;

    if (l10n != null) {
      announcement = l10n.accessibilityTutorialProgress(
        currentStep,
        totalSteps,
        stepName,
      );
    } else {
      // Fallback to English
      announcement = 'Tutorial step $currentStep of $totalSteps: $stepName';
    }

    announceToScreenReader(
      announcement,
      importance: LiveRegionImportance.assertive,
    );
  }

  /// Announce error messages with high priority
  void announceError(String errorMessage, {AppLocalizations? l10n}) {
    String announcement;

    if (l10n != null) {
      announcement = l10n.accessibilityError(errorMessage);
    } else {
      // Fallback to English
      announcement = 'Error: $errorMessage';
    }

    announceToScreenReader(
      announcement,
      importance: LiveRegionImportance.assertive,
    );
  }

  /// Announce when important settings change
  void announceSettingChange(
    String settingName,
    bool isEnabled, {
    AppLocalizations? l10n,
  }) {
    String announcement;

    if (l10n != null) {
      announcement = isEnabled
          ? l10n.accessibilitySettingEnabled(settingName)
          : l10n.accessibilitySettingDisabled(settingName);
    } else {
      // Fallback to English
      final status = isEnabled ? 'enabled' : 'disabled';
      announcement = '$settingName $status';
    }

    announceToScreenReader(announcement);
  }
}
