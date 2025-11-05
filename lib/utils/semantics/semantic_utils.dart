import 'package:graviton/enums/simulation_status.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/body.dart';

/// Utility class for creating accessible semantic descriptions and actions
class SemanticUtils {
  SemanticUtils._();

  /// Creates a comprehensive description of the current simulation state
  static String createSimulationDescription(
    AppLocalizations l10n,
    List<Body> bodies,
    SimulationStatus status,
    double timeScale,
    int stepCount,
  ) {
    final bodyCount = bodies.length;
    final statusText = _getStatusDescription(status, l10n);
    final speedText = l10n.speedFormatted(timeScale.toStringAsFixed(1));

    return l10n.simulationStateDescription(
      bodyCount,
      statusText,
      speedText,
      stepCount,
    );
  }

  /// Creates a description of celestial bodies currently visible
  static String createBodiesDescription(
    AppLocalizations l10n,
    List<Body> bodies,
  ) {
    if (bodies.isEmpty) {
      return l10n.noBodiesInSimulation;
    }

    final bodyTypes = <String, int>{};
    for (final body in bodies) {
      final typeName = _getBodyTypeName(body, l10n);
      bodyTypes[typeName] = (bodyTypes[typeName] ?? 0) + 1;
    }

    final descriptions = bodyTypes.entries
        .map(
          (entry) =>
              '${entry.value} ${entry.key}${entry.value != 1 ? 's' : ''}',
        )
        .join(', ');

    return l10n.bodiesInSimulation(descriptions);
  }

  /// Creates camera position description for accessibility
  static String createCameraDescription(
    AppLocalizations l10n,
    double distance,
    bool autoRotate,
    bool followMode,
    String? followingBodyName,
  ) {
    final distanceText = l10n.distanceFormatted(distance.toStringAsFixed(1));
    final rotateText = autoRotate
        ? l10n.autoRotateActive
        : l10n.autoRotateInactive;

    if (followMode && followingBodyName != null) {
      return l10n.cameraFollowingDescription(
        followingBodyName,
        distanceText,
        rotateText,
      );
    }

    return l10n.cameraFreeDescription(distanceText, rotateText);
  }

  /// Creates live region announcement for simulation changes
  static String createLiveUpdate(
    AppLocalizations l10n,
    String updateType,
    String value,
  ) {
    return l10n.liveUpdateAnnouncement(updateType, value);
  }

  /// Creates keyboard shortcut hints for accessibility
  static String createKeyboardHints(AppLocalizations l10n) {
    return l10n.keyboardShortcutsHint;
  }

  /// Determines if a semantic announcement should be made based on time intervals
  static bool shouldAnnounce(DateTime lastAnnouncement, Duration interval) {
    return DateTime.now().difference(lastAnnouncement) >= interval;
  }

  /// Creates semantic label for physics statistics
  static String createPhysicsStatsLabel(
    AppLocalizations l10n,
    double totalTime,
    double earthYears,
    int stepCount,
  ) {
    return l10n.physicsStatsDescription(
      totalTime.toStringAsFixed(1),
      earthYears.toStringAsFixed(2),
      stepCount,
    );
  }

  /// Helper method to get status description
  static String _getStatusDescription(
    SimulationStatus status,
    AppLocalizations l10n,
  ) {
    switch (status) {
      case SimulationStatus.running:
        return l10n.statusRunning;
      case SimulationStatus.paused:
        return l10n.statusPaused;
      case SimulationStatus.stopped:
        return l10n.statusStopped;
      case SimulationStatus.error:
        return l10n.statusError;
    }
  }

  /// Helper method to get body type name for accessibility
  static String _getBodyTypeName(Body body, AppLocalizations l10n) {
    // Determine body type based on mass, size, or name
    if (body.mass > 1e29) {
      return l10n.bodyTypeStar;
    } else if (body.mass > 1e24) {
      return l10n.bodyTypePlanet;
    } else if (body.mass > 1e22) {
      return l10n.bodyTypeMoon;
    } else {
      return l10n.bodyTypeAsteroid;
    }
  }
}
