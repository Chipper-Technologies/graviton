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
        final view = WidgetsBinding.instance.platformDispatcher.views.first;
        SemanticsService.sendAnnouncement(view, message, TextDirection.ltr);
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
    required AppLocalizations l10n,
  }) {
    final message = l10n.accessibilityMergeEvent(body1Name, body2Name);
    announceSimulationEvent(
      message,
      additionalContext: l10n.accessibilityMergeEventContext,
    );
  }

  /// Announce simulation state changes
  void announceSimulationStateChange(
    String state, {
    required AppLocalizations l10n,
  }) {
    final accessibilityState = AccessibilitySimulationState.fromString(state);
    final announcement = _getLocalizedStateAnnouncement(
      accessibilityState,
      l10n,
    );
    final context = _getLocalizedStateContext(accessibilityState, l10n);

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
  void announceScenarioChange(
    String scenarioName, {
    required AppLocalizations l10n,
  }) {
    final message = l10n.accessibilityScenarioChange(scenarioName);
    announceSimulationEvent(
      message,
      additionalContext: l10n.accessibilityScenarioChangeContext,
    );
  }

  /// Announce physics parameter changes
  void announcePhysicsChange(
    String parameter,
    String newValue, {
    required AppLocalizations l10n,
  }) {
    final physicsParam = AccessibilityPhysicsParameter.fromString(parameter);
    final announcement = _getLocalizedPhysicsAnnouncement(
      physicsParam,
      newValue,
      l10n,
    );

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

  /// Announce camera actions
  void announceCameraAction(String action, {required AppLocalizations l10n}) {
    final cameraAction = AccessibilityCameraAction.fromString(action);
    final announcement = _getLocalizedCameraAnnouncement(cameraAction, l10n);

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

  /// Announce tutorial progress
  void announceTutorialProgress(
    String stepName,
    int currentStep,
    int totalSteps, {
    required AppLocalizations l10n,
  }) {
    final announcement = l10n.accessibilityTutorialProgress(
      currentStep,
      totalSteps,
      stepName,
    );

    announceToScreenReader(
      announcement,
      importance: LiveRegionImportance.assertive,
    );
  }

  /// Announce error messages with high priority
  void announceError(String errorMessage, {required AppLocalizations l10n}) {
    final announcement = l10n.accessibilityError(errorMessage);

    announceToScreenReader(
      announcement,
      importance: LiveRegionImportance.assertive,
    );
  }

  /// Announce when important settings change
  void announceSettingChange(
    String settingName,
    bool isEnabled, {
    required AppLocalizations l10n,
  }) {
    final announcement = isEnabled
        ? l10n.accessibilitySettingEnabled(settingName)
        : l10n.accessibilitySettingDisabled(settingName);

    announceToScreenReader(announcement);
  }
}
