import 'package:flutter/material.dart';
import 'package:graviton/constants/rendering_constants.dart';
import 'package:graviton/services/firebase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages UI settings and preferences
class UIState extends ChangeNotifier {
  bool _showTrails = true;
  bool _useWarmTrails = true;
  bool _showOrbitalPaths = true;
  bool _dualOrbitalPaths = false;
  bool _showControls = true;
  bool _showStats = false;
  bool _showGrid = false;
  bool _showLabels = true;
  bool _showOffScreenIndicators = true;
  bool _enableVibration = true;
  double _uiOpacity = RenderingConstants.defaultUIOpacity;

  // Habitability settings
  bool _showHabitableZones = false;
  bool _showHabitabilityIndicators = false;

  // Gravity visualization settings
  bool _showGravityWells = false;

  // Language settings
  String? _selectedLanguageCode; // null means system default

  // SharedPreferences keys
  static const String _keyShowTrails = 'showTrails';
  static const String _keyUseWarmTrails = 'useWarmTrails';
  static const String _keyShowOrbitalPaths = 'showOrbitalPaths';
  static const String _keyDualOrbitalPaths = 'dualOrbitalPaths';
  static const String _keyShowControls = 'showControls';
  static const String _keyShowStats = 'showStats';
  static const String _keyShowGrid = 'showGrid';
  static const String _keyShowLabels = 'showLabels';
  static const String _keyShowOffScreenIndicators = 'showOffScreenIndicators';
  static const String _keyEnableVibration = 'enableVibration';
  static const String _keyUIOpacity = 'uiOpacity';
  static const String _keyShowHabitableZones = 'showHabitableZones';
  static const String _keyShowHabitabilityIndicators = 'showHabitabilityIndicators';
  static const String _keyShowGravityWells = 'showGravityWells';
  static const String _keySelectedLanguageCode = 'selectedLanguageCode';

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
      _showOrbitalPaths = prefs.getBool(_keyShowOrbitalPaths) ?? true;
      _dualOrbitalPaths = prefs.getBool(_keyDualOrbitalPaths) ?? false;
      _showControls = prefs.getBool(_keyShowControls) ?? true;
      _showStats = prefs.getBool(_keyShowStats) ?? false;
      _showGrid = prefs.getBool(_keyShowGrid) ?? false;
      _showLabels = prefs.getBool(_keyShowLabels) ?? true;
      _showOffScreenIndicators = prefs.getBool(_keyShowOffScreenIndicators) ?? true;
      _enableVibration = prefs.getBool(_keyEnableVibration) ?? true;
      _uiOpacity = prefs.getDouble(_keyUIOpacity) ?? RenderingConstants.defaultUIOpacity;
      _showHabitableZones = prefs.getBool(_keyShowHabitableZones) ?? false;
      _showHabitabilityIndicators = prefs.getBool(_keyShowHabitabilityIndicators) ?? false;
      _showGravityWells = prefs.getBool(_keyShowGravityWells) ?? false;
      _selectedLanguageCode = prefs.getString(_keySelectedLanguageCode);

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
  bool get showOrbitalPaths => _showOrbitalPaths;
  bool get dualOrbitalPaths => _dualOrbitalPaths;
  bool get showControls => _showControls;
  bool get showStats => _showStats;
  bool get showGrid => _showGrid;
  bool get showLabels => _showLabels;
  bool get showOffScreenIndicators => _showOffScreenIndicators;
  bool get enableVibration => _enableVibration;
  double get uiOpacity => _uiOpacity;

  // Habitability getters
  bool get showHabitableZones => _showHabitableZones;
  bool get showHabitabilityIndicators => _showHabitabilityIndicators;

  // Gravity visualization getters
  bool get showGravityWells => _showGravityWells;

  // Language getters
  String? get selectedLanguageCode => _selectedLanguageCode;

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

  void toggleOrbitalPaths() {
    _showOrbitalPaths = !_showOrbitalPaths;
    _saveSetting(_keyShowOrbitalPaths, _showOrbitalPaths);
    FirebaseService.instance.logSettingsChange('orbital_paths', _showOrbitalPaths);
    notifyListeners();
  }

  void toggleDualOrbitalPaths() {
    _dualOrbitalPaths = !_dualOrbitalPaths;
    _saveSetting(_keyDualOrbitalPaths, _dualOrbitalPaths);
    FirebaseService.instance.logSettingsChange('dual_orbital_paths', _dualOrbitalPaths);
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
    FirebaseService.instance.logSettingsChange('show_offscreen_indicators', _showOffScreenIndicators);
    notifyListeners();
  }

  void toggleVibration() {
    _enableVibration = !_enableVibration;
    _saveSetting(_keyEnableVibration, _enableVibration);
    FirebaseService.instance.logSettingsChange('enable_vibration', _enableVibration);
    notifyListeners();
  }

  void setUIOpacity(double opacity) {
    _uiOpacity = opacity.clamp(RenderingConstants.uiOpacityMin, RenderingConstants.uiOpacityMax);
    _saveSetting(_keyUIOpacity, _uiOpacity);
    FirebaseService.instance.logSettingsChange('ui_opacity', _uiOpacity);
    notifyListeners();
  }

  // Habitability setters
  void toggleHabitableZones() {
    _showHabitableZones = !_showHabitableZones;
    _saveSetting(_keyShowHabitableZones, _showHabitableZones);
    FirebaseService.instance.logSettingsChange('show_habitable_zones', _showHabitableZones);
    notifyListeners();
  }

  void toggleHabitabilityIndicators() {
    _showHabitabilityIndicators = !_showHabitabilityIndicators;
    _saveSetting(_keyShowHabitabilityIndicators, _showHabitabilityIndicators);
    FirebaseService.instance.logSettingsChange('show_habitability_indicators', _showHabitabilityIndicators);
    notifyListeners();
  }

  // Gravity visualization setters
  void toggleGravityWells() {
    _showGravityWells = !_showGravityWells;
    _saveSetting(_keyShowGravityWells, _showGravityWells);
    FirebaseService.instance.logSettingsChange('show_gravity_wells', _showGravityWells);
    notifyListeners();
  }

  // Language setters
  void setLanguage(String? languageCode) {
    _selectedLanguageCode = languageCode;
    _saveSetting(_keySelectedLanguageCode, languageCode);
    FirebaseService.instance.logSettingsChange('language', languageCode ?? 'system');
    notifyListeners();
  }
}
