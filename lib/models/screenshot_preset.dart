import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/models/camera_position.dart';

/// Screenshot preset for capturing marketing materials
class ScreenshotPreset {
  final String name;
  final String description;
  final ScenarioType scenarioType;
  final Map<String, dynamic> configuration;
  final CameraPosition camera;
  final bool showUI;
  final bool showTrails;
  final String trailType;
  final bool showLabels;

  // Enhanced camera controls
  final double? cameraDistance;
  final double? cameraPitch;
  final double? cameraYaw;
  final bool? cameraAutoRotate;

  // Timing controls
  final int timerSeconds;

  // Body focus controls
  final int? focusBodyIndex;
  final String? focusBodyName;
  final bool? enableFollowMode;

  // Additional visual controls
  final bool? showOrbitalPaths;
  final bool? showHabitableZones;
  final bool? showGravityWells;
  final bool? showOffScreenIndicators;

  const ScreenshotPreset({
    required this.name,
    required this.description,
    required this.scenarioType,
    required this.configuration,
    required this.camera,
    this.showUI = false,
    this.showTrails = true,
    this.trailType = 'warm',
    this.showLabels = false,

    // Enhanced camera controls with defaults
    this.cameraDistance,
    this.cameraPitch,
    this.cameraYaw,
    this.cameraAutoRotate,

    // Timing with default
    this.timerSeconds = 30,

    // Body focus controls
    this.focusBodyIndex,
    this.focusBodyName,
    this.enableFollowMode,

    // Additional visual controls
    this.showOrbitalPaths,
    this.showHabitableZones,
    this.showGravityWells,
    this.showOffScreenIndicators,
  });
}
