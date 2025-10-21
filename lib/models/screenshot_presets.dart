import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/camera_position.dart';
import 'package:graviton/models/screenshot_preset.dart';

/// Predefined screenshot presets for marketing materials
class ScreenshotPresets {
  /// Get all presets with localized names and descriptions
  static List<ScreenshotPreset> getPresets(AppLocalizations l10n) {
    return [
      // 1. Galaxy Formation Overview
      ScreenshotPreset(
        name: l10n.presetGalaxyFormationOverview,
        description: l10n.presetGalaxyFormationOverviewDesc,
        scenarioType: ScenarioType.galaxyFormation,
        configuration: {
          'bodyCount': 500,
          'centralMass': 50000.0,
          'diskRadius': 3000.0,
          'timeStep': 0.1,
          'showGalaxyCore': true,
        },
        camera: const CameraPosition(distance: 656.0, yaw: 0.77, pitch: -0.94, roll: 0.37),
        cameraDistance: 656.0,
        cameraYaw: 0.77,
        cameraPitch: -0.94,
        cameraAutoRotate: false,
        showTrails: true,
        trailType: 'warm',
        showLabels: false,
        showOffScreenIndicators: false,
        timerSeconds: 30,
      ),

      // 2. Galaxy Core Detail
      ScreenshotPreset(
        name: l10n.presetGalaxyCoreDetail,
        description: l10n.presetGalaxyCoreDetailDesc,
        scenarioType: ScenarioType.galaxyFormation,
        configuration: {
          'bodyCount': 300,
          'centralMass': 75000.0,
          'diskRadius': 2000.0,
          'timeStep': 0.1,
          'showGalaxyCore': true,
        },
        camera: const CameraPosition(distance: 281.0, yaw: 0.55, pitch: -0.81, roll: 0.17),
        cameraDistance: 281.0,
        cameraYaw: 0.55,
        cameraPitch: -0.81,
        cameraAutoRotate: false,
        showTrails: true,
        trailType: 'cool',
        showLabels: false,
        showOffScreenIndicators: false,
        timerSeconds: 30,
      ),

      // 3. Galaxy Black Hole
      ScreenshotPreset(
        name: l10n.presetGalaxyBlackHole,
        description: l10n.presetGalaxyBlackHoleDesc,
        scenarioType: ScenarioType.galaxyFormation,
        configuration: {
          'bodyCount': 300,
          'centralMass': 75000.0,
          'diskRadius': 2000.0,
          'timeStep': 0.1,
          'showGalaxyCore': true,
        },
        camera: const CameraPosition(distance: 49.4, yaw: -0.10, pitch: -1.18, roll: 5.94),
        cameraDistance: 49.4,
        cameraYaw: -0.10,
        cameraPitch: -1.18,
        cameraAutoRotate: false,
        showTrails: true,
        trailType: 'cool',
        showLabels: true,
        showOffScreenIndicators: false,
        timerSeconds: 0,
      ),

      // 4. Solar System Overview
      ScreenshotPreset(
        name: l10n.presetCompleteSolarSystem,
        description: l10n.presetCompleteSolarSystemDesc,
        scenarioType: ScenarioType.solarSystem,
        configuration: {'showAllPlanets': true, 'showMoons': true, 'timeStep': 0.5},
        camera: const CameraPosition(distance: 1800.0, yaw: 5.68, pitch: 0.47, roll: 0.37),
        cameraDistance: 1800.0,
        cameraYaw: 5.68,
        cameraPitch: 0.47,
        cameraAutoRotate: false,
        showTrails: true,
        trailType: 'warm',
        showLabels: true,
        showOffScreenIndicators: false,
        timerSeconds: 0,
      ),

      // 5. Inner Planets Detail
      ScreenshotPreset(
        name: l10n.presetInnerSolarSystem,
        description: l10n.presetInnerSolarSystemDesc,
        scenarioType: ScenarioType.solarSystem,
        configuration: {'focusRegion': 'inner', 'showInnerPlanets': true, 'showHabitableZone': true, 'timeStep': 0.3},
        camera: const CameraPosition(distance: 243.0, yaw: 1.59, pitch: 0.79, roll: 0.13),
        cameraDistance: 243.0,
        cameraYaw: 1.59,
        cameraPitch: 0.79,
        cameraAutoRotate: false,
        showTrails: true,
        trailType: 'warm',
        showLabels: true,
        showOffScreenIndicators: false,
        showHabitableZones: true,
        timerSeconds: 0,
      ),

      // 6. Earth View
      ScreenshotPreset(
        name: l10n.presetEarthView,
        description: l10n.presetEarthViewDesc,
        scenarioType: ScenarioType.solarSystem,
        configuration: {'showAllPlanets': true, 'showMoons': true, 'timeStep': 0.3},
        camera: const CameraPosition(distance: 12.8, yaw: 4.58, pitch: 0.36, roll: 0.65),
        cameraDistance: 12.8,
        cameraYaw: 4.58,
        cameraPitch: 0.36,
        cameraAutoRotate: false,
        focusBodyIndex: 3, // Earth
        enableFollowMode: true,
        showTrails: true,
        trailType: 'warm',
        showLabels: true,
        showOffScreenIndicators: false,
        timerSeconds: 0,
      ),

      // 7. Saturn's Majestic Rings
      ScreenshotPreset(
        name: l10n.presetSaturnRings,
        description: l10n.presetSaturnRingsDesc,
        scenarioType: ScenarioType.solarSystem,
        configuration: {'focusPlanet': 'saturn', 'showRings': true, 'timeStep': 0.3},
        camera: const CameraPosition(distance: 100.0, yaw: 4.29, pitch: 0.41, roll: 6.06),
        cameraDistance: 100.0,
        cameraYaw: 4.29,
        cameraPitch: 0.41,
        cameraAutoRotate: false,
        focusBodyIndex: 6, // Saturn
        enableFollowMode: true,
        showTrails: false,
        showLabels: false,
        showOffScreenIndicators: false,
        timerSeconds: 0,
      ),

      // 8. Earth-Moon System
      ScreenshotPreset(
        name: l10n.presetEarthMoonSystem,
        description: l10n.presetEarthMoonSystemDesc,
        scenarioType: ScenarioType.earthMoonSun,
        configuration: {'showMoonOrbit': true, 'timeStep': 0.2},
        camera: const CameraPosition(distance: 8.2, yaw: 2.49, pitch: -0.941, roll: 0.11),
        cameraDistance: 8.2,
        cameraYaw: 2.49,
        cameraPitch: -0.941,
        cameraAutoRotate: false,
        focusBodyIndex: 1, // Earth
        enableFollowMode: true,
        showTrails: true,
        trailType: 'cool',
        showLabels: false,
        showOffScreenIndicators: false,
        timerSeconds: 0,
      ),

      // 9. Binary Star Drama
      ScreenshotPreset(
        name: l10n.presetBinaryStarDrama,
        description: l10n.presetBinaryStarDramaDesc,
        scenarioType: ScenarioType.binaryStars,
        configuration: {'starMassRatio': 0.8, 'planetCount': 0, 'timeStep': 0.1},
        camera: const CameraPosition(distance: 88.9, yaw: 1.05, pitch: -0.17, roll: 0.13),
        cameraDistance: 88.9,
        cameraYaw: 1.05,
        cameraPitch: -0.17,
        cameraAutoRotate: false,
        showTrails: true,
        trailType: 'warm',
        showLabels: true,
        showOffScreenIndicators: false,
        timerSeconds: 30,
      ),

      // 10. Binary Star Planet & Moon
      ScreenshotPreset(
        name: l10n.presetBinaryStarPlanetMoon,
        description: l10n.presetBinaryStarPlanetMoonDesc,
        scenarioType: ScenarioType.binaryStars,
        configuration: {'starMassRatio': 0.8, 'planetCount': 3, 'timeStep': 0.1},
        camera: const CameraPosition(distance: 7.3, yaw: 1.88, pitch: 1.16, roll: 0.22),
        cameraDistance: 7.3,
        cameraYaw: 1.88,
        cameraPitch: 1.16,
        cameraAutoRotate: false,
        focusBodyIndex: 2, // Plant P
        enableFollowMode: true,
        showTrails: true,
        trailType: 'warm',
        showLabels: false,
        showOffScreenIndicators: false,
        timerSeconds: 5,
      ),

      // 11. Asteroid Belt Chaos
      ScreenshotPreset(
        name: l10n.presetAsteroidBeltChaos,
        description: l10n.presetAsteroidBeltChaosDesc,
        scenarioType: ScenarioType.asteroidBelt,
        configuration: {'asteroidCount': 200, 'beltRadius': 3000.0, 'showGravityWells': true, 'timeStep': 0.1},
        camera: const CameraPosition(distance: 51.3, yaw: 0.92, pitch: 0.45, roll: 6.17),
        cameraDistance: 51.3,
        cameraYaw: 0.92,
        cameraPitch: 0.45,
        cameraAutoRotate: false,
        showTrails: true,
        trailType: 'cool',
        showLabels: true,
        showOffScreenIndicators: false,
        timerSeconds: 30,
      ),

      // 12. Three-Body Ballet
      ScreenshotPreset(
        name: l10n.presetThreeBodyBallet,
        description: l10n.presetThreeBodyBalletDesc,
        scenarioType: ScenarioType.threeBodyClassic,
        configuration: {
          'bodyMasses': [1000.0, 800.0, 600.0],
          'initialConfiguration': 'figure_eight',
          'timeStep': 0.05,
        },
        camera: const CameraPosition(distance: 100.0, yaw: 1.61, pitch: -0.17, roll: 0.17),
        cameraDistance: 100.0,
        cameraYaw: 1.61,
        cameraPitch: -0.17,
        cameraAutoRotate: false,
        showTrails: true,
        trailType: 'warm',
        showLabels: true,
        showOffScreenIndicators: false,
        timerSeconds: 30,
      ),
    ];
  }

  /// Get preset by index
  static ScreenshotPreset? getPreset(int index, AppLocalizations l10n) {
    final presets = getPresets(l10n);
    if (index >= 0 && index < presets.length) {
      return presets[index];
    }
    return null;
  }

  /// Get preset by name
  static ScreenshotPreset? getPresetByName(String name, AppLocalizations l10n) {
    try {
      final presets = getPresets(l10n);
      return presets.firstWhere((preset) => preset.name == name);
    } catch (e) {
      return null;
    }
  }

  /// Get total number of presets
  static int getPresetCount() => 12; // Fixed count since we know the number of presets
}
