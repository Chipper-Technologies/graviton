import 'package:flutter/material.dart';
import 'package:graviton/constants/rendering_constants.dart';
import 'package:graviton/enums/cinematic_camera_technique.dart';
import 'package:graviton/enums/gravity_field_color_scheme.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/enums/temperature_unit.dart';
import 'package:graviton/services/firebase_service.dart';
import 'package:graviton/utils/safe_haptic_feedback.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages UI settings and preferences
class UIState extends ChangeNotifier {
  bool _showTrails = true;
  bool _useWarmTrails = true;
  bool _useRealisticColors = false;
  bool _showOrbitalPaths = true;
  bool _dualOrbitalPaths = false;
  bool _showControls = true;
  bool _showStats = false;
  bool _showGrid = false;
  bool _showLabels = true;
  bool _showOffScreenIndicators = true;
  bool _enableUIHapticFeedback = true;
  bool _enableCollisionHapticFeedback = true;
  double _uiOpacity = RenderingConstants.defaultUIOpacity;

  // Gravity field settings
  bool _globalGravityFields = true;
  GravityFieldColorScheme _gravityFieldColorScheme =
      GravityFieldColorScheme.classic;
  bool _showEquipotentialSurfaces = false;
  bool _showGravityFieldIndicators = false;

  // Habitability settings
  bool _showHabitableZones = false;
  bool _showHabitabilityIndicators = false;

  // Collision visual effects settings
  bool _showCollisionDebris = true;
  bool _showCollisionShockwaves = true;
  bool _showCollisionEjection = true;
  bool _showCollisionPlasmaJets = false;

  // Language settings
  String? _selectedLanguageCode; // null means system default

  // Temperature unit settings
  TemperatureUnit _temperatureUnit = TemperatureUnit.kelvin;

  // Cinematic camera settings
  CinematicCameraTechnique _cinematicCameraTechnique =
      CinematicCameraTechnique.manual;
  double _cameraSpeed = 0.5;

  // Screenshot mode settings
  bool _hideUIInScreenshotMode = false;

  // Fullscreen mode settings
  bool _isFullscreen = false;

  // Changelog settings
  String? _lastSeenChangelogVersion;

  // SharedPreferences keys
  static const String _keyShowTrails = 'showTrails';
  static const String _keyUseWarmTrails = 'useWarmTrails';
  static const String _keyUseRealisticColors = 'useRealisticColors';
  static const String _keyShowOrbitalPaths = 'showOrbitalPaths';
  static const String _keyDualOrbitalPaths = 'dualOrbitalPaths';
  static const String _keyShowControls = 'showControls';
  static const String _keyShowStats = 'showStats';
  static const String _keyShowGrid = 'showGrid';
  static const String _keyShowLabels = 'showLabels';
  static const String _keyShowOffScreenIndicators = 'showOffScreenIndicators';
  static const String _keyEnableUIHapticFeedback = 'enableUIHapticFeedback';
  static const String _keyEnableCollisionHapticFeedback =
      'enableCollisionHapticFeedback';
  static const String _keyEnableVibration =
      'enableVibration'; // Legacy key for migration
  static const String _keyUIOpacity = 'uiOpacity';
  static const String _keyGlobalGravityFields = 'globalGravityFields';
  static const String _keyGravityFieldColorScheme = 'gravityFieldColorScheme';
  static const String _keyShowEquipotentialSurfaces =
      'showEquipotentialSurfaces';
  static const String _keyShowGravityFieldIndicators =
      'showGravityFieldIndicators';
  static const String _keyShowHabitableZones = 'showHabitableZones';
  static const String _keyShowHabitabilityIndicators =
      'showHabitabilityIndicators';
  static const String _keyShowCollisionDebris = 'showCollisionDebris';
  static const String _keyShowCollisionShockwaves = 'showCollisionShockwaves';
  static const String _keyShowCollisionEjection = 'showCollisionEjection';
  static const String _keyShowCollisionPlasmaJets = 'showCollisionPlasmaJets';
  static const String _keySelectedLanguageCode = 'selectedLanguageCode';
  static const String _keyTemperatureUnit = 'temperatureUnit';
  static const String _keyCinematicCameraTechnique = 'cinematicCameraTechnique';
  static const String _keyCameraSpeed = 'cameraSpeed';
  static const String _keyHideUIInScreenshotMode = 'hideUIInScreenshotMode';
  static const String _keyIsFullscreen = 'isFullscreen';
  static const String _keyLastSeenChangelogVersion = 'lastSeenChangelogVersion';

  /// Initialize and load saved settings
  Future<void> initialize() async {
    await _loadSettings();
  }

  /// Load settings from SharedPreferences
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _showTrails = prefs.getBool(_keyShowTrails) ?? true;
      _useWarmTrails = prefs.getBool(_keyUseWarmTrails) ?? true;
      _useRealisticColors = prefs.getBool(_keyUseRealisticColors) ?? false;
      _showOrbitalPaths = prefs.getBool(_keyShowOrbitalPaths) ?? true;
      _dualOrbitalPaths = prefs.getBool(_keyDualOrbitalPaths) ?? false;
      _showControls = prefs.getBool(_keyShowControls) ?? true;
      _showStats = prefs.getBool(_keyShowStats) ?? false;
      _showGrid = prefs.getBool(_keyShowGrid) ?? false;
      _showLabels = prefs.getBool(_keyShowLabels) ?? true;
      _showOffScreenIndicators =
          prefs.getBool(_keyShowOffScreenIndicators) ?? true;

      // Handle migration from legacy vibration setting to separate haptic settings
      if (prefs.containsKey(_keyEnableUIHapticFeedback) ||
          prefs.containsKey(_keyEnableCollisionHapticFeedback)) {
        // New settings exist, use them
        _enableUIHapticFeedback =
            prefs.getBool(_keyEnableUIHapticFeedback) ?? true;
        _enableCollisionHapticFeedback =
            prefs.getBool(_keyEnableCollisionHapticFeedback) ?? true;
      } else {
        // Migrate from legacy setting
        final legacyVibration = prefs.getBool(_keyEnableVibration) ?? true;
        _enableUIHapticFeedback = legacyVibration;
        _enableCollisionHapticFeedback = legacyVibration;
        // Save the new settings
        await prefs.setBool(
          _keyEnableUIHapticFeedback,
          _enableUIHapticFeedback,
        );
        await prefs.setBool(
          _keyEnableCollisionHapticFeedback,
          _enableCollisionHapticFeedback,
        );
      }

      // Always remove legacy key if it exists to prevent confusion
      if (prefs.containsKey(_keyEnableVibration)) {
        await prefs.remove(_keyEnableVibration);
      }

      _uiOpacity =
          prefs.getDouble(_keyUIOpacity) ?? RenderingConstants.defaultUIOpacity;

      // Load gravity field settings
      _globalGravityFields = prefs.getBool(_keyGlobalGravityFields) ?? true;
      _showEquipotentialSurfaces =
          prefs.getBool(_keyShowEquipotentialSurfaces) ?? false;
      _showGravityFieldIndicators =
          prefs.getBool(_keyShowGravityFieldIndicators) ?? false;

      // Load gravity field color scheme
      final gravityColorSchemeValue = prefs.getString(
        _keyGravityFieldColorScheme,
      );
      _gravityFieldColorScheme = gravityColorSchemeValue != null
          ? GravityFieldColorSchemeExtension.fromString(gravityColorSchemeValue)
          : GravityFieldColorScheme.classic;

      _showHabitableZones = prefs.getBool(_keyShowHabitableZones) ?? false;
      _showHabitabilityIndicators =
          prefs.getBool(_keyShowHabitabilityIndicators) ?? false;

      // Load collision visual effects settings
      _showCollisionDebris = prefs.getBool(_keyShowCollisionDebris) ?? true;
      _showCollisionShockwaves =
          prefs.getBool(_keyShowCollisionShockwaves) ?? true;
      _showCollisionEjection = prefs.getBool(_keyShowCollisionEjection) ?? true;
      _showCollisionPlasmaJets =
          prefs.getBool(_keyShowCollisionPlasmaJets) ?? false;

      _selectedLanguageCode = prefs.getString(_keySelectedLanguageCode);

      // Load temperature unit setting
      final temperatureUnitValue = prefs.getString(_keyTemperatureUnit);
      _temperatureUnit = temperatureUnitValue != null
          ? TemperatureUnit.fromString(temperatureUnitValue)
          : TemperatureUnit.kelvin;

      // Load cinematic camera technique setting
      final cinematicTechniqueValue = prefs.getString(
        _keyCinematicCameraTechnique,
      );
      _cinematicCameraTechnique = cinematicTechniqueValue != null
          ? CinematicCameraTechnique.fromValue(cinematicTechniqueValue)
          : CinematicCameraTechnique.manual;

      // Load camera speed setting
      _cameraSpeed = prefs.getDouble(_keyCameraSpeed) ?? 0.5;

      _hideUIInScreenshotMode =
          prefs.getBool(_keyHideUIInScreenshotMode) ?? false;

      _isFullscreen = prefs.getBool(_keyIsFullscreen) ?? false;

      // Load changelog tracking
      _lastSeenChangelogVersion = prefs.getString(_keyLastSeenChangelogVersion);

      notifyListeners();
    } catch (e) {
      // If SharedPreferences fails (e.g., in tests), use default values
      // Default values are already set in the field declarations, so no action needed
    }
  }

  /// Save a specific setting to SharedPreferences
  Future<void> _saveSetting(String key, dynamic value) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (value is bool) {
        await prefs.setBool(key, value);
      } else if (value is double) {
        await prefs.setDouble(key, value);
      } else if (value is String) {
        await prefs.setString(key, value);
      } else if (value == null) {
        await prefs.remove(key);
      }
    } catch (e) {
      // Ignore errors (e.g., in tests where binding isn't initialized)
      // This allows tests to run without SharedPreferences
    }
  }

  // Getters
  bool get showTrails => _showTrails;
  bool get useWarmTrails => _useWarmTrails;
  bool get useRealisticColors => _useRealisticColors;
  bool get showOrbitalPaths => _showOrbitalPaths;
  bool get dualOrbitalPaths => _dualOrbitalPaths;
  bool get showControls => _showControls;
  bool get showStats => _showStats;
  bool get showGrid => _showGrid;
  bool get showLabels => _showLabels;
  bool get showOffScreenIndicators => _showOffScreenIndicators;
  bool get enableUIHapticFeedback => _enableUIHapticFeedback;
  bool get enableCollisionHapticFeedback => _enableCollisionHapticFeedback;
  bool get enableVibration =>
      _enableUIHapticFeedback; // Legacy getter for backward compatibility
  double get uiOpacity => _uiOpacity;

  // Changelog getters
  String? get lastSeenChangelogVersion => _lastSeenChangelogVersion;

  // Habitability getters
  bool get showHabitableZones => _showHabitableZones;
  bool get showHabitabilityIndicators => _showHabitabilityIndicators;

  // Collision visual effects getters
  bool get showCollisionDebris => _showCollisionDebris;
  bool get showCollisionShockwaves => _showCollisionShockwaves;
  bool get showCollisionEjection => _showCollisionEjection;
  bool get showCollisionPlasmaJets => _showCollisionPlasmaJets;

  // Gravity field getters
  bool get globalGravityFields => _globalGravityFields;
  GravityFieldColorScheme get gravityFieldColorScheme =>
      _gravityFieldColorScheme;
  bool get showEquipotentialSurfaces => _showEquipotentialSurfaces;
  bool get showGravityFieldIndicators => _showGravityFieldIndicators;

  // Language getters
  String? get selectedLanguageCode => _selectedLanguageCode;

  // Temperature unit getters
  TemperatureUnit get temperatureUnit => _temperatureUnit;

  // Cinematic camera getters
  CinematicCameraTechnique get cinematicCameraTechnique =>
      _cinematicCameraTechnique;
  double get cameraSpeed => _cameraSpeed;

  // Screenshot mode getters
  bool get hideUIInScreenshotMode => _hideUIInScreenshotMode;

  // Fullscreen mode getters
  bool get isFullscreen => _isFullscreen;

  // Setters
  void toggleTrails() {
    _showTrails = !_showTrails;
    _saveSetting(_keyShowTrails, _showTrails);
    FirebaseService.instance.logSettingsChange('show_trails', _showTrails);
    notifyListeners();
  }

  void toggleWarmTrails() {
    _useWarmTrails = !_useWarmTrails;
    _saveSetting(_keyUseWarmTrails, _useWarmTrails);
    FirebaseService.instance.logSettingsChange('warm_trails', _useWarmTrails);
    notifyListeners();
  }

  void toggleRealisticColors() {
    _useRealisticColors = !_useRealisticColors;
    _saveSetting(_keyUseRealisticColors, _useRealisticColors);
    FirebaseService.instance.logSettingsChange(
      'realistic_colors',
      _useRealisticColors,
    );
    notifyListeners();
  }

  void toggleOrbitalPaths() {
    _showOrbitalPaths = !_showOrbitalPaths;
    _saveSetting(_keyShowOrbitalPaths, _showOrbitalPaths);
    FirebaseService.instance.logSettingsChange(
      'orbital_paths',
      _showOrbitalPaths,
    );
    notifyListeners();
  }

  void toggleDualOrbitalPaths() {
    _dualOrbitalPaths = !_dualOrbitalPaths;
    _saveSetting(_keyDualOrbitalPaths, _dualOrbitalPaths);
    FirebaseService.instance.logSettingsChange(
      'dual_orbital_paths',
      _dualOrbitalPaths,
    );
    notifyListeners();
  }

  void toggleControls() {
    _showControls = !_showControls;
    _saveSetting(_keyShowControls, _showControls);
    FirebaseService.instance.logSettingsChange('show_controls', _showControls);
    notifyListeners();
  }

  void toggleStats() {
    _showStats = !_showStats;
    _saveSetting(_keyShowStats, _showStats);
    FirebaseService.instance.logSettingsChange('show_stats', _showStats);
    notifyListeners();
  }

  void toggleGrid() {
    _showGrid = !_showGrid;
    _saveSetting(_keyShowGrid, _showGrid);
    FirebaseService.instance.logSettingsChange('show_grid', _showGrid);
    notifyListeners();
  }

  void toggleLabels() {
    _showLabels = !_showLabels;
    _saveSetting(_keyShowLabels, _showLabels);
    FirebaseService.instance.logSettingsChange('show_labels', _showLabels);
    notifyListeners();
  }

  void toggleOffScreenIndicators() {
    _showOffScreenIndicators = !_showOffScreenIndicators;
    _saveSetting(_keyShowOffScreenIndicators, _showOffScreenIndicators);
    FirebaseService.instance.logSettingsChange(
      'show_offscreen_indicators',
      _showOffScreenIndicators,
    );
    notifyListeners();
  }

  void toggleUIHapticFeedback() {
    _enableUIHapticFeedback = !_enableUIHapticFeedback;
    _saveSetting(_keyEnableUIHapticFeedback, _enableUIHapticFeedback);
    FirebaseService.instance.logSettingsChange(
      'enable_ui_haptic_feedback',
      _enableUIHapticFeedback,
    );
    notifyListeners();
  }

  void toggleCollisionHapticFeedback() {
    _enableCollisionHapticFeedback = !_enableCollisionHapticFeedback;
    _saveSetting(
      _keyEnableCollisionHapticFeedback,
      _enableCollisionHapticFeedback,
    );
    FirebaseService.instance.logSettingsChange(
      'enable_collision_haptic_feedback',
      _enableCollisionHapticFeedback,
    );
    notifyListeners();
  }

  // Legacy method for backward compatibility
  void toggleVibration() {
    toggleUIHapticFeedback();
  }

  void setUIOpacity(double opacity) {
    _uiOpacity = opacity.clamp(
      RenderingConstants.uiOpacityMin,
      RenderingConstants.uiOpacityMax,
    );
    _saveSetting(_keyUIOpacity, _uiOpacity);
    FirebaseService.instance.logSettingsChange('ui_opacity', _uiOpacity);
    notifyListeners();
  }

  // Habitability setters
  void toggleHabitableZones() {
    _showHabitableZones = !_showHabitableZones;
    _saveSetting(_keyShowHabitableZones, _showHabitableZones);
    FirebaseService.instance.logSettingsChange(
      'show_habitable_zones',
      _showHabitableZones,
    );
    notifyListeners();
  }

  void toggleHabitabilityIndicators() {
    _showHabitabilityIndicators = !_showHabitabilityIndicators;
    _saveSetting(_keyShowHabitabilityIndicators, _showHabitabilityIndicators);
    FirebaseService.instance.logSettingsChange(
      'show_habitability_indicators',
      _showHabitabilityIndicators,
    );
    notifyListeners();
  }

  // Collision visual effects setters
  void toggleCollisionDebris() {
    _showCollisionDebris = !_showCollisionDebris;
    _saveSetting(_keyShowCollisionDebris, _showCollisionDebris);
    FirebaseService.instance.logSettingsChange(
      'show_collision_debris',
      _showCollisionDebris,
    );
    notifyListeners();
  }

  void toggleCollisionShockwaves() {
    _showCollisionShockwaves = !_showCollisionShockwaves;
    _saveSetting(_keyShowCollisionShockwaves, _showCollisionShockwaves);
    FirebaseService.instance.logSettingsChange(
      'show_collision_shockwaves',
      _showCollisionShockwaves,
    );
    notifyListeners();
  }

  void toggleCollisionEjection() {
    _showCollisionEjection = !_showCollisionEjection;
    _saveSetting(_keyShowCollisionEjection, _showCollisionEjection);
    FirebaseService.instance.logSettingsChange(
      'show_collision_ejection',
      _showCollisionEjection,
    );
    notifyListeners();
  }

  void toggleCollisionPlasmaJets() {
    _showCollisionPlasmaJets = !_showCollisionPlasmaJets;
    _saveSetting(_keyShowCollisionPlasmaJets, _showCollisionPlasmaJets);
    FirebaseService.instance.logSettingsChange(
      'show_collision_plasma_jets',
      _showCollisionPlasmaJets,
    );
    notifyListeners();
  }

  // Gravity field setters
  void toggleGlobalGravityFields() {
    _globalGravityFields = !_globalGravityFields;
    _saveSetting(_keyGlobalGravityFields, _globalGravityFields);
    FirebaseService.instance.logSettingsChange(
      'global_gravity_fields',
      _globalGravityFields,
    );

    // Note: When enabling global gravity fields, AppState listener will automatically
    // call _ensureAllBodiesHaveGravityWellsEnabled() to set showGravityWell = true
    // on all bodies so they can be individually toggled off by the user.

    notifyListeners();
  }

  void setGravityFieldColorScheme(GravityFieldColorScheme scheme) {
    _gravityFieldColorScheme = scheme;
    _saveSetting(_keyGravityFieldColorScheme, scheme.name);
    FirebaseService.instance.logSettingsChange(
      'gravity_field_color_scheme',
      scheme.name,
    );
    notifyListeners();
  }

  void toggleEquipotentialSurfaces() {
    _showEquipotentialSurfaces = !_showEquipotentialSurfaces;
    _saveSetting(_keyShowEquipotentialSurfaces, _showEquipotentialSurfaces);
    FirebaseService.instance.logSettingsChange(
      'show_equipotential_surfaces',
      _showEquipotentialSurfaces,
    );
    notifyListeners();
  }

  void toggleGravityFieldIndicators() {
    _showGravityFieldIndicators = !_showGravityFieldIndicators;
    _saveSetting(_keyShowGravityFieldIndicators, _showGravityFieldIndicators);
    FirebaseService.instance.logSettingsChange(
      'show_gravity_field_indicators',
      _showGravityFieldIndicators,
    );
    notifyListeners();
  }

  // Language setters
  void setLanguage(String? languageCode) {
    _selectedLanguageCode = languageCode;
    _saveSetting(_keySelectedLanguageCode, languageCode);
    FirebaseService.instance.logSettingsChange(
      'language',
      languageCode ?? 'system',
    );
    notifyListeners();
  }

  // Temperature unit setters
  void setTemperatureUnit(TemperatureUnit unit) {
    _temperatureUnit = unit;
    _saveSetting(_keyTemperatureUnit, unit.name);
    FirebaseService.instance.logSettingsChange('temperature_unit', unit.name);
    notifyListeners();
  }

  // Cinematic camera setters
  void setCinematicCameraTechnique(CinematicCameraTechnique technique) {
    _cinematicCameraTechnique = technique;
    _saveSetting(_keyCinematicCameraTechnique, technique.value);

    // Haptic feedback for camera technique switching
    SafeHapticFeedback.mediumImpact();

    FirebaseService.instance.logSettingsChange(
      'cinematic_camera_technique',
      technique.value,
    );
    notifyListeners();
  }

  void setCameraSpeed(double speed) {
    _cameraSpeed = speed.clamp(0.1, 3.0);
    _saveSetting(_keyCameraSpeed, _cameraSpeed);

    // Haptic feedback for camera speed adjustment
    SafeHapticFeedback.lightImpact();

    FirebaseService.instance.logSettingsChange('camera_speed', _cameraSpeed);
    notifyListeners();
  }

  // Screenshot mode setters
  void toggleHideUIInScreenshotMode() {
    _hideUIInScreenshotMode = !_hideUIInScreenshotMode;
    _saveSetting(_keyHideUIInScreenshotMode, _hideUIInScreenshotMode);
    FirebaseService.instance.logSettingsChange(
      'hide_ui_in_screenshot_mode',
      _hideUIInScreenshotMode,
    );
    notifyListeners();
  }

  // Fullscreen mode setters
  void setFullscreen(bool isFullscreen) {
    _isFullscreen = isFullscreen;
    _saveSetting(_keyIsFullscreen, isFullscreen);
    FirebaseService.instance.logSettingsChange('fullscreen_mode', isFullscreen);
    notifyListeners();
  }

  void toggleFullscreen() {
    setFullscreen(!_isFullscreen);
  }

  // Changelog setters
  void setLastSeenChangelogVersion(String version) {
    _lastSeenChangelogVersion = version;
    _saveSetting(_keyLastSeenChangelogVersion, version);
    FirebaseService.instance.logSettingsChange(
      'last_seen_changelog_version',
      version,
    );
    notifyListeners();
  }

  /// Check if there's a new changelog version to show
  bool shouldShowChangelogFor(String currentAppVersion) {
    // If never seen any changelog, show for current version
    if (_lastSeenChangelogVersion == null) return true;

    // If last seen version is different from current, show changelog
    return _lastSeenChangelogVersion != currentAppVersion;
  }

  /// Apply performance optimizations for scenarios with many bodies or complex scenarios
  void applyPerformanceOptimizationsForScenario(
    ScenarioType scenario,
    int bodyCount,
  ) {
    // List of scenarios that are known to be performance-heavy
    final performanceHeavyScenarios = {
      ScenarioType.galaxyFormation,
      ScenarioType.asteroidBelt,
    };

    // Apply optimizations for scenarios with many bodies (>= 20) or known heavy scenarios
    if (bodyCount >= 20 || performanceHeavyScenarios.contains(scenario)) {
      // Disable labels for better performance with many bodies
      if (_showLabels) {
        _showLabels = false;
        _saveSetting(_keyShowLabels, false);
        FirebaseService.instance.logSettingsChange('show_labels', false);
      }

      // Disable orbital paths for better performance
      if (_showOrbitalPaths) {
        _showOrbitalPaths = false;
        _saveSetting(_keyShowOrbitalPaths, false);
        FirebaseService.instance.logSettingsChange('show_orbital_paths', false);
      }

      // Disable off-screen indicators for better performance
      if (_showOffScreenIndicators) {
        _showOffScreenIndicators = false;
        _saveSetting(_keyShowOffScreenIndicators, false);
        FirebaseService.instance.logSettingsChange(
          'show_offscreen_indicators',
          false,
        );
      }

      // Disable gravity wells for better performance with many bodies
      if (_globalGravityFields) {
        _globalGravityFields = false;
        _saveSetting(_keyGlobalGravityFields, false);
        FirebaseService.instance.logSettingsChange(
          'global_gravity_fields',
          false,
        );
      }

      notifyListeners();
    }
  }

  /// Apply performance optimizations for scenarios with many bodies (legacy method)
  @Deprecated('Use applyPerformanceOptimizationsForScenario instead')
  void applyPerformanceOptimizations(int bodyCount) {
    // For scenarios with many bodies (>= 20), automatically disable heavy features
    if (bodyCount >= 20) {
      // Disable labels for better performance with many bodies
      if (_showLabels) {
        _showLabels = false;
        _saveSetting(_keyShowLabels, false);
        FirebaseService.instance.logSettingsChange('show_labels', false);
      }

      // Disable orbital paths for better performance
      if (_showOrbitalPaths) {
        _showOrbitalPaths = false;
        _saveSetting(_keyShowOrbitalPaths, false);
        FirebaseService.instance.logSettingsChange('show_orbital_paths', false);
      }

      // Disable off-screen indicators for better performance
      if (_showOffScreenIndicators) {
        _showOffScreenIndicators = false;
        _saveSetting(_keyShowOffScreenIndicators, false);
        FirebaseService.instance.logSettingsChange(
          'show_offscreen_indicators',
          false,
        );
      }

      // Disable gravity wells for better performance with many bodies
      if (_globalGravityFields) {
        _globalGravityFields = false;
        _saveSetting(_keyGlobalGravityFields, false);
        FirebaseService.instance.logSettingsChange(
          'global_gravity_fields',
          false,
        );
      }

      notifyListeners();
    }
  }
}
