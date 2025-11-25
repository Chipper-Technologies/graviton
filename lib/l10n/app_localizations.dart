import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('zh'),
    Locale('de'),
    Locale('ja'),
    Locale('ko'),
  ];

  /// Description of the app shown in about dialog
  ///
  /// In en, this message translates to:
  /// **'A physics simulation exploring gravitational dynamics and orbital mechanics. Experience the beauty and complexity of celestial motion through interactive 3D visualization.'**
  String get appDescription;

  /// Display name for development app flavor
  ///
  /// In en, this message translates to:
  /// **'Development'**
  String get appFlavorDevelopment;

  /// Display name for production app flavor
  ///
  /// In en, this message translates to:
  /// **'Production'**
  String get appFlavorProduction;

  /// Description for app information and credits menu item
  ///
  /// In en, this message translates to:
  /// **'App information and credits'**
  String get appInformationCredits;

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Graviton'**
  String get appTitle;

  /// Tooltip for the back navigation button
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backButtonTooltip;

  /// Label for bottom navigation visuals button
  ///
  /// In en, this message translates to:
  /// **'Visuals'**
  String get bottomNavVisualsLabel;

  /// Detailed description for collision haptic feedback setting
  ///
  /// In en, this message translates to:
  /// **'Enable haptic feedback when celestial bodies collide during simulation'**
  String get collisionHapticFeedbackDescription;

  /// Hint shown when in fullscreen mode
  ///
  /// In en, this message translates to:
  /// **'Tap anywhere to exit fullscreen'**
  String get exitFullscreenHint;

  /// Title for fullscreen mode
  ///
  /// In en, this message translates to:
  /// **'Fullscreen Mode'**
  String get fullscreenMode;

  /// Description for fullscreen mode functionality
  ///
  /// In en, this message translates to:
  /// **'Hide all UI elements for immersive viewing'**
  String get fullscreenModeDescription;

  /// Legacy description for vibration enabled toggle
  ///
  /// In en, this message translates to:
  /// **'Haptic feedback on collisions'**
  String get hapticFeedbackCollisions;

  /// Legacy detailed description for haptic feedback setting
  ///
  /// In en, this message translates to:
  /// **'Enable haptic feedback for UI interactions and collisions'**
  String get hapticFeedbackDescription;

  /// Detailed description for UI haptic feedback setting
  ///
  /// In en, this message translates to:
  /// **'Enable haptic feedback for UI interactions like button taps, toggles, and navigation'**
  String get uiHapticFeedbackDescription;

  /// Section title for visual display options
  ///
  /// In en, this message translates to:
  /// **'Display Options'**
  String get displayOptionsTitle;

  /// Button to pause the simulation
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pauseButton;

  /// Button to start the simulation
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get playButton;

  /// No description provided for @presetAsteroidBeltChaos.
  ///
  /// In en, this message translates to:
  /// **'Asteroid Belt Chaos'**
  String get presetAsteroidBeltChaos;

  /// No description provided for @presetAsteroidBeltChaosDesc.
  ///
  /// In en, this message translates to:
  /// **'Dense asteroid field with gravitational effects'**
  String get presetAsteroidBeltChaosDesc;

  /// No description provided for @presetBinaryStarDrama.
  ///
  /// In en, this message translates to:
  /// **'Binary Star Drama'**
  String get presetBinaryStarDrama;

  /// No description provided for @presetBinaryStarDramaDesc.
  ///
  /// In en, this message translates to:
  /// **'Front view of two massive stars in gravitational dance'**
  String get presetBinaryStarDramaDesc;

  /// No description provided for @presetBinaryStarPlanetMoon.
  ///
  /// In en, this message translates to:
  /// **'Binary Star Planet & Moon'**
  String get presetBinaryStarPlanetMoon;

  /// No description provided for @presetBinaryStarPlanetMoonDesc.
  ///
  /// In en, this message translates to:
  /// **'Planet and moon orbiting in chaotic binary star system'**
  String get presetBinaryStarPlanetMoonDesc;

  /// No description provided for @presetCompleteSolarSystem.
  ///
  /// In en, this message translates to:
  /// **'Complete Solar System'**
  String get presetCompleteSolarSystem;

  /// No description provided for @presetCompleteSolarSystemDesc.
  ///
  /// In en, this message translates to:
  /// **'All planets visible with beautiful orbital trails'**
  String get presetCompleteSolarSystemDesc;

  /// No description provided for @presetEarthMoonSystem.
  ///
  /// In en, this message translates to:
  /// **'Earth-Moon System'**
  String get presetEarthMoonSystem;

  /// No description provided for @presetEarthMoonSystemDesc.
  ///
  /// In en, this message translates to:
  /// **'Earth and Moon with visible orbital mechanics'**
  String get presetEarthMoonSystemDesc;

  /// No description provided for @presetEarthView.
  ///
  /// In en, this message translates to:
  /// **'Earth View'**
  String get presetEarthView;

  /// No description provided for @presetEarthViewDesc.
  ///
  /// In en, this message translates to:
  /// **'Close-up perspective of Earth with atmospheric detail'**
  String get presetEarthViewDesc;

  /// No description provided for @presetGalaxyBlackHole.
  ///
  /// In en, this message translates to:
  /// **'Galaxy Black Hole'**
  String get presetGalaxyBlackHole;

  /// No description provided for @presetGalaxyBlackHoleDesc.
  ///
  /// In en, this message translates to:
  /// **'Close-up view of supermassive black hole at galactic center'**
  String get presetGalaxyBlackHoleDesc;

  /// No description provided for @presetGalaxyCoreDetail.
  ///
  /// In en, this message translates to:
  /// **'Galaxy Core Detail'**
  String get presetGalaxyCoreDetail;

  /// No description provided for @presetGalaxyCoreDetailDesc.
  ///
  /// In en, this message translates to:
  /// **'Close-up of bright galactic center with accretion disk'**
  String get presetGalaxyCoreDetailDesc;

  /// No description provided for @presetGalaxyFormationOverview.
  ///
  /// In en, this message translates to:
  /// **'Galaxy Formation Overview'**
  String get presetGalaxyFormationOverview;

  /// No description provided for @presetGalaxyFormationOverviewDesc.
  ///
  /// In en, this message translates to:
  /// **'Wide view of spiral galaxy formation with cosmic background'**
  String get presetGalaxyFormationOverviewDesc;

  /// No description provided for @presetInnerSolarSystem.
  ///
  /// In en, this message translates to:
  /// **'Inner Solar System'**
  String get presetInnerSolarSystem;

  /// No description provided for @presetInnerSolarSystemDesc.
  ///
  /// In en, this message translates to:
  /// **'Close-up of Mercury, Venus, Earth, and Mars with habitable zone indicator'**
  String get presetInnerSolarSystemDesc;

  /// No description provided for @presetSaturnRings.
  ///
  /// In en, this message translates to:
  /// **'Saturn\'s Majestic Rings'**
  String get presetSaturnRings;

  /// No description provided for @presetSaturnRingsDesc.
  ///
  /// In en, this message translates to:
  /// **'Close-up of Saturn with detailed ring system'**
  String get presetSaturnRingsDesc;

  /// No description provided for @presetThreeBodyBallet.
  ///
  /// In en, this message translates to:
  /// **'Three-Body Ballet'**
  String get presetThreeBodyBallet;

  /// No description provided for @presetThreeBodyBalletDesc.
  ///
  /// In en, this message translates to:
  /// **'Classic three-body problem in elegant motion'**
  String get presetThreeBodyBalletDesc;

  /// Button to reset the simulation
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get resetButton;

  /// Developer button to reset changelog state
  ///
  /// In en, this message translates to:
  /// **'Reset Changelog State'**
  String get resetChangelogButton;

  /// Description for reset changelog button
  ///
  /// In en, this message translates to:
  /// **'Reset changelog read status'**
  String get resetChangelogDescription;

  /// Description for reset settings action
  ///
  /// In en, this message translates to:
  /// **'Reset all settings to default values'**
  String get resetSettingsDescription;

  /// Description for reset tutorial button
  ///
  /// In en, this message translates to:
  /// **'Reset tutorial progress'**
  String get resetTutorialDescription;

  /// Accessibility description when simulation canvas has focus
  ///
  /// In en, this message translates to:
  /// **'Simulation canvas focused - main physics simulation area'**
  String get simulationCanvasFocused;

  /// Accessibility hint for simulation canvas interactions
  ///
  /// In en, this message translates to:
  /// **'Use keyboard shortcuts to control simulation. Space to pause, R to reset, C to center camera'**
  String get simulationCanvasHint;

  /// Accessibility label for the main simulation canvas
  ///
  /// In en, this message translates to:
  /// **'Gravitational Physics Simulation'**
  String get simulationCanvasLabel;

  /// Accessibility description when simulation controls have focus
  ///
  /// In en, this message translates to:
  /// **'Simulation controls focused - play, pause, reset simulation'**
  String get simulationControlsFocused;

  /// Comprehensive description of simulation state for screen readers
  ///
  /// In en, this message translates to:
  /// **'Gravitational simulation with {bodyCount} celestial bodies. Status: {status}. Speed: {speed}. Steps: {steps}'**
  String simulationDescription(
    int bodyCount,
    String status,
    String speed,
    int steps,
  );

  /// Label for simulation speed slider
  ///
  /// In en, this message translates to:
  /// **'Simulation Speed'**
  String get simulationSpeed;

  /// Accessibility hint for simulation speed slider
  ///
  /// In en, this message translates to:
  /// **'Adjust simulation speed from 0.1x to 16x normal speed. Use arrow keys to change in small increments.'**
  String get simulationSpeedHint;

  /// Comprehensive description of simulation state for accessibility
  ///
  /// In en, this message translates to:
  /// **'Gravitational simulation with {bodyCount} celestial bodies. Status: {status}. Speed: {speed}. Steps completed: {stepCount}. Tap to interact with simulation or use keyboard shortcuts.'**
  String simulationStateDescription(
    int bodyCount,
    String status,
    String speed,
    int stepCount,
  );

  /// Header for simulation statistics
  ///
  /// In en, this message translates to:
  /// **'Simulation Stats'**
  String get simulationStats;

  /// Label for simulation steps counter in stats overlay
  ///
  /// In en, this message translates to:
  /// **'Simulation Steps'**
  String get simulationStepsLabel;

  /// Double speed preset (2.0x)
  ///
  /// In en, this message translates to:
  /// **'Double'**
  String get speedDouble;

  /// Fast speed preset (4.0x)
  ///
  /// In en, this message translates to:
  /// **'Fast'**
  String get speedFast;

  /// Formatted simulation speed multiplier
  ///
  /// In en, this message translates to:
  /// **'{speed}x'**
  String speedFormatted(String speed);

  /// Half speed preset (0.5x)
  ///
  /// In en, this message translates to:
  /// **'Half Speed'**
  String get speedHalf;

  /// Label for simulation speed control
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get speedLabel;

  /// Maximum speed preset (16.0x)
  ///
  /// In en, this message translates to:
  /// **'Maximum'**
  String get speedMaximum;

  /// Normal speed preset (1.0x)
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get speedNormal;

  /// Quarter speed preset (0.25x)
  ///
  /// In en, this message translates to:
  /// **'Quarter Speed'**
  String get speedQuarter;

  /// Very fast speed preset (8.0x)
  ///
  /// In en, this message translates to:
  /// **'Very Fast'**
  String get speedVeryFast;

  /// Button text for stopping follow mode
  ///
  /// In en, this message translates to:
  /// **'Stop Follow'**
  String get stopFollowTitle;

  /// Tooltip for the follow object button when currently following
  ///
  /// In en, this message translates to:
  /// **'Stop Following Object'**
  String get stopFollowingTooltip;

  /// Button text for stopping auto rotation
  ///
  /// In en, this message translates to:
  /// **'Stop Rotate'**
  String get stopRotateTitle;

  /// Description for test preset used in unit testing
  ///
  /// In en, this message translates to:
  /// **'Test preset for unit testing'**
  String get testPresetForUnitTesting;

  /// Label for trail visibility toggle
  ///
  /// In en, this message translates to:
  /// **'Trails'**
  String get trailsLabel;

  /// Accessibility description when camera controls have focus
  ///
  /// In en, this message translates to:
  /// **'Camera controls focused - adjust view and perspective'**
  String get cameraControlsFocused;

  /// Header for camera controls section
  ///
  /// In en, this message translates to:
  /// **'Camera Controls'**
  String get cameraControlsLabel;

  /// Display name for dynamic framing camera technique
  ///
  /// In en, this message translates to:
  /// **'Dynamic Framing'**
  String get cameraDynamicFraming;

  /// Description for dynamic framing camera technique
  ///
  /// In en, this message translates to:
  /// **'Automatically adjusts framing based on scene content'**
  String get cameraDynamicFramingDescription;

  /// Description of camera in follow mode
  ///
  /// In en, this message translates to:
  /// **'Camera following {bodyName} at distance {distance}. Auto-rotation: {rotation}'**
  String cameraFollowingDescription(
    String bodyName,
    String distance,
    String rotation,
  );

  /// Description of camera in free movement mode
  ///
  /// In en, this message translates to:
  /// **'Camera in free mode at distance {distance}. Auto-rotation: {rotation}'**
  String cameraFreeDescription(String distance, String rotation);

  /// Header for camera information
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get cameraLabel;

  /// Display name for manual camera technique
  ///
  /// In en, this message translates to:
  /// **'Manual Control'**
  String get cameraManual;

  /// Description for manual camera technique
  ///
  /// In en, this message translates to:
  /// **'Traditional manual camera controls with follow mode'**
  String get cameraManualDescription;

  /// Display name for predictive orbital camera technique
  ///
  /// In en, this message translates to:
  /// **'Predictive Orbital'**
  String get cameraPredictiveOrbital;

  /// Description for predictive orbital camera technique
  ///
  /// In en, this message translates to:
  /// **'AI predicts orbital paths for dramatic camera movements'**
  String get cameraPredictiveOrbitalDescription;

  /// Section title for camera settings including FOV and visual aids
  ///
  /// In en, this message translates to:
  /// **'Camera Settings'**
  String get cameraSettingsTitle;

  /// Accessibility hint for camera speed slider
  ///
  /// In en, this message translates to:
  /// **'Adjust AI camera movement speed from slow to fast. Use arrow keys to change in small increments.'**
  String get cameraSpeedHint;

  /// Label for AI camera movement speed slider
  ///
  /// In en, this message translates to:
  /// **'Camera Speed'**
  String get cameraSpeedLabel;

  /// Tooltip for camera tab button
  ///
  /// In en, this message translates to:
  /// **'Camera settings and AI modes'**
  String get cameraTooltip;

  /// Formatted camera distance
  ///
  /// In en, this message translates to:
  /// **'{distance}'**
  String distanceFormatted(String distance);

  /// Label for camera distance
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distanceLabel;

  /// Title for preview tab in scenario editor
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get previewEditortitle;

  /// Title for setup tab in scenario editor
  ///
  /// In en, this message translates to:
  /// **'Setup'**
  String get setupEditorTitle;

  /// Label for auto-rotate button
  ///
  /// In en, this message translates to:
  /// **'Rotate'**
  String get rotateLabel;

  /// Action hint for physics settings
  ///
  /// In en, this message translates to:
  /// **'View physics settings'**
  String get viewPhysicsSettings;

  /// Semantic action label for zooming in
  ///
  /// In en, this message translates to:
  /// **'Zoom in'**
  String get zoomInAction;

  /// Label for camera zoom level
  ///
  /// In en, this message translates to:
  /// **'Zoom'**
  String get zoomLabel;

  /// Semantic action label for zooming out
  ///
  /// In en, this message translates to:
  /// **'Zoom out'**
  String get zoomOutAction;

  /// Section title for color selection
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get colorEditor;

  /// Template for color option accessibility label
  ///
  /// In en, this message translates to:
  /// **'Color option {colorName}'**
  String colorOptionTemplate(String colorName, Object color);

  /// Accessibility label for color picker
  ///
  /// In en, this message translates to:
  /// **'Color selector'**
  String get colorSelector;

  /// Tooltip for individual color options in color picker
  ///
  /// In en, this message translates to:
  /// **'Select {colorName} color for celestial body'**
  String colorOptionTooltip(String colorName);

  /// Tooltip for visuals tab button
  ///
  /// In en, this message translates to:
  /// **'Visual display options'**
  String get visualsTooltip;

  /// Label for collision haptic feedback toggle
  ///
  /// In en, this message translates to:
  /// **'Collision Haptic Feedback'**
  String get collisionHapticFeedback;

  /// Label for collision sensitivity slider
  ///
  /// In en, this message translates to:
  /// **'Collision Sensitivity'**
  String get collisionSensitivity;

  /// Classic blue/yellow gravity field color scheme
  ///
  /// In en, this message translates to:
  /// **'Classic'**
  String get gravityColorSchemeClassic;

  /// Green-based gravity field color scheme
  ///
  /// In en, this message translates to:
  /// **'Emerald'**
  String get gravityColorSchemeEmerald;

  /// Grayscale gravity field color scheme
  ///
  /// In en, this message translates to:
  /// **'Monochrome'**
  String get gravityColorSchemeMonochrome;

  /// Bright neon gravity field color scheme
  ///
  /// In en, this message translates to:
  /// **'Neon'**
  String get gravityColorSchemeNeon;

  /// Rainbow spectrum gravity field color scheme
  ///
  /// In en, this message translates to:
  /// **'Spectral'**
  String get gravityColorSchemeSpectral;

  /// Label for gravity setting in physics preview
  ///
  /// In en, this message translates to:
  /// **'Gravity'**
  String get gravityEditor;

  /// Description for gravity field color scheme setting
  ///
  /// In en, this message translates to:
  /// **'Choose the color scheme for gravitational field visualization'**
  String get gravityFieldColorSchemeDescription;

  /// Label for gravity field color scheme selection
  ///
  /// In en, this message translates to:
  /// **'Gravity Field Colors'**
  String get gravityFieldColorSchemeLabel;

  /// Description for gravity field strength indicators setting
  ///
  /// In en, this message translates to:
  /// **'Show visual indicators of gravitational field strength'**
  String get gravityFieldIndicatorsDescription;

  /// Label for gravity field strength indicators toggle
  ///
  /// In en, this message translates to:
  /// **'Field Strength Indicators'**
  String get gravityFieldIndicatorsLabel;

  /// Formatted gravity field strength with unit
  ///
  /// In en, this message translates to:
  /// **'{strength} {unit}'**
  String gravityFieldStrengthFormatted(String strength, String unit);

  /// Label for gravity field strength readout
  ///
  /// In en, this message translates to:
  /// **'Field Strength'**
  String get gravityFieldStrengthLabel;

  /// Unit for gravity field strength (meters per second squared)
  ///
  /// In en, this message translates to:
  /// **'m/s²'**
  String get gravityFieldStrengthUnit;

  /// Description for gravity field visualization toggle
  ///
  /// In en, this message translates to:
  /// **'Show gravitational field visualization'**
  String get gravityFieldsDescription;

  /// Toggle title for gravity field visualization
  ///
  /// In en, this message translates to:
  /// **'Gravity Fields'**
  String get gravityFieldsTitle;

  /// Description for gravity wells setting
  ///
  /// In en, this message translates to:
  /// **'Show gravitational field strength around objects'**
  String get gravityWellsDescription;

  /// Label for gravity wells setting
  ///
  /// In en, this message translates to:
  /// **'Gravity Wells'**
  String get gravityWellsLabel;

  /// Hint text for mass input field in scenario editor
  ///
  /// In en, this message translates to:
  /// **'Mass (kg)'**
  String get massKgEditorhint;

  /// Placeholder message for future physics configuration feature in scenario editor
  ///
  /// In en, this message translates to:
  /// **'Physics configuration will be implemented here'**
  String get physicsConfigurationWillBeImplementedHereEditor;

  /// Validation error for physics field out of range
  ///
  /// In en, this message translates to:
  /// **'{field} must be between {min} and {max}'**
  String physicsFieldRangeError(String field, double min, double max);

  /// Physics section header in simulation settings
  ///
  /// In en, this message translates to:
  /// **'Physics'**
  String get physicsSection;

  /// Description for the physics settings menu item
  ///
  /// In en, this message translates to:
  /// **'Simulation parameters'**
  String get physicsSettingsDescription;

  /// Title for the physics settings menu item
  ///
  /// In en, this message translates to:
  /// **'Physics Settings'**
  String get physicsSettingsTitle;

  /// Accessibility description of physics statistics
  ///
  /// In en, this message translates to:
  /// **'Physics: {time} time units, {earthYears} Earth years, {steps} simulation steps completed'**
  String physicsStatsDescription(String time, String earthYears, int steps);

  /// Tooltip for physics tab button
  ///
  /// In en, this message translates to:
  /// **'Physics visualization and settings'**
  String get physicsTooltip;

  /// Section title for physics visualization options
  ///
  /// In en, this message translates to:
  /// **'Physics Visualization'**
  String get physicsVisualizationTitle;

  /// Temperature category for cold bodies (-100°C to 0°C)
  ///
  /// In en, this message translates to:
  /// **'Cold'**
  String get temperatureCold;

  /// Label for temperature input field in scenario editor
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get temperatureEditorlabel;

  /// Temperature category for extremely cold bodies (below -100°C)
  ///
  /// In en, this message translates to:
  /// **'Frozen'**
  String get temperatureFrozen;

  /// Temperature category for hot bodies (50°C to 150°C)
  ///
  /// In en, this message translates to:
  /// **'Hot'**
  String get temperatureHot;

  /// Hint text for temperature input field in scenario editor
  ///
  /// In en, this message translates to:
  /// **'Temperature (K)'**
  String get temperatureKEditorhint;

  /// Hint text for temperature input field in Celsius
  ///
  /// In en, this message translates to:
  /// **'Temperature (°C)'**
  String get temperatureCelsiusEditorhint;

  /// Hint text for temperature input field in Fahrenheit
  ///
  /// In en, this message translates to:
  /// **'Temperature (°F)'**
  String get temperatureFahrenheitEditorhint;

  /// Temperature category for moderate temperature bodies (0°C to 50°C)
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get temperatureModerate;

  /// Temperature category for bodies where temperature doesn't apply
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get temperatureNotApplicable;

  /// Temperature category for extremely hot bodies (above 150°C)
  ///
  /// In en, this message translates to:
  /// **'Scorching'**
  String get temperatureScorching;

  /// Celsius temperature unit symbol
  ///
  /// In en, this message translates to:
  /// **'°C'**
  String get temperatureUnitCelsius;

  /// Fahrenheit temperature unit symbol
  ///
  /// In en, this message translates to:
  /// **'°F'**
  String get temperatureUnitFahrenheit;

  /// Kelvin temperature unit symbol
  ///
  /// In en, this message translates to:
  /// **'K'**
  String get temperatureUnitKelvin;

  /// Celsius temperature unit full name
  ///
  /// In en, this message translates to:
  /// **'Celsius'**
  String get temperatureUnitCelsiusName;

  /// Fahrenheit temperature unit full name
  ///
  /// In en, this message translates to:
  /// **'Fahrenheit'**
  String get temperatureUnitFahrenheitName;

  /// Kelvin temperature unit full name
  ///
  /// In en, this message translates to:
  /// **'Kelvin'**
  String get temperatureUnitKelvinName;

  /// Section title for velocity in meters per second
  ///
  /// In en, this message translates to:
  /// **'Velocity (m/s)'**
  String get velocityMsEditor;

  /// Button text to add a new celestial body
  ///
  /// In en, this message translates to:
  /// **'Add Body'**
  String get addBodyButton;

  /// Instructions for adding bodies in scenario editor
  ///
  /// In en, this message translates to:
  /// **'Add celestial bodies to create your custom scenario'**
  String get addCelestialBodiesToCreateYourCustomScenarioEditor;

  /// Placeholder message for future particle systems configuration feature in scenario editor
  ///
  /// In en, this message translates to:
  /// **'Asteroid belt and other particle systems will be configured here'**
  String get asteroidBeltAndOtherParticleSystemsWillBeConfiguredHereEditor;

  /// Beginner difficulty level for scenarios
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get beginnerEditor;

  /// Message shown when no bodies have been added to scenario
  ///
  /// In en, this message translates to:
  /// **'No bodies added yet'**
  String get noBodiesAdded;

  /// Instruction message for adding bodies in the setup tab
  ///
  /// In en, this message translates to:
  /// **'Add bodies in the Setup tab'**
  String get addBodiesInSetupTab;

  /// Default name for scenarios without a title
  ///
  /// In en, this message translates to:
  /// **'Untitled Scenario'**
  String get untitledScenario;

  /// Message shown when scenario has no description
  ///
  /// In en, this message translates to:
  /// **'No description provided'**
  String get noDescriptionProvided;

  /// Label for collision softening parameter in physics editor
  ///
  /// In en, this message translates to:
  /// **'Collision Softening'**
  String get collisionSoftening;

  /// Label for collision radius parameter in physics editor
  ///
  /// In en, this message translates to:
  /// **'Collision Radius'**
  String get collisionRadius;

  /// Section title for body type selection
  ///
  /// In en, this message translates to:
  /// **'Body Type'**
  String get bodyTypeEditor;

  /// Hint text for duplicate body action
  ///
  /// In en, this message translates to:
  /// **'Create a copy of this celestial body'**
  String get createACopyOfThisCelestialBodyEditorHint;

  /// Button text to create a new custom scenario
  ///
  /// In en, this message translates to:
  /// **'Create Custom Scenario'**
  String get createCustomScenarioButton;

  /// Description for creating custom scenarios
  ///
  /// In en, this message translates to:
  /// **'Design your own gravitational scenario with custom celestial bodies'**
  String get createCustomScenarioDescription;

  /// Button text to create a scenario
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get createScenarioButton;

  /// Title for creating new scenario
  ///
  /// In en, this message translates to:
  /// **'Create Scenario'**
  String get createScenarioTitle;

  /// Accessibility label for edit scenario button
  ///
  /// In en, this message translates to:
  /// **'Edit scenario'**
  String get editScenarioButton;

  /// Accessibility hint for edit scenario button
  ///
  /// In en, this message translates to:
  /// **'Edit this scenario'**
  String get editScenarioHint;

  /// Accessibility label for edit body button
  ///
  /// In en, this message translates to:
  /// **'Edit body'**
  String get editBodyButton;

  /// Accessibility hint for edit body button
  ///
  /// In en, this message translates to:
  /// **'Edit this celestial body'**
  String get editBodyHint;

  /// Accessibility label for delete scenario button
  ///
  /// In en, this message translates to:
  /// **'Delete scenario'**
  String get deleteScenarioButton;

  /// Accessibility hint for delete scenario button
  ///
  /// In en, this message translates to:
  /// **'Delete this scenario'**
  String get deleteScenarioHint;

  /// Default description for custom scenarios in editor
  ///
  /// In en, this message translates to:
  /// **'A custom gravitational simulation'**
  String get customGravitationalSimulationEditor;

  /// Message for delete body confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone. The celestial body will be permanently removed from the scenario.'**
  String get deleteBodyConfirmMessage;

  /// Title for delete body confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Delete {bodyName}?'**
  String deleteBodyConfirmTitle(String bodyName);

  /// Label for delete body action
  ///
  /// In en, this message translates to:
  /// **'Delete {bodyName}'**
  String deleteBodyNameTemplate(String bodyName);

  /// Tooltip for delete body action
  ///
  /// In en, this message translates to:
  /// **'Delete Body'**
  String get deleteBodyTooltip;

  /// Button text for delete actions
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteButton;

  /// Message for delete scenario confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to permanently delete \"{scenarioName}\"? This action cannot be undone.'**
  String deleteScenarioConfirmMessage(String scenarioName);

  /// Title for delete scenario dialog
  ///
  /// In en, this message translates to:
  /// **'Delete Scenario'**
  String get deleteScenarioTitle;

  /// Success message when scenario is deleted
  ///
  /// In en, this message translates to:
  /// **'Successfully deleted scenario: {scenarioName}'**
  String deleteScenarioSuccessMessage(String scenarioName);

  /// Error message when scenario deletion fails
  ///
  /// In en, this message translates to:
  /// **'Failed to delete scenario: {error}'**
  String deleteScenarioFailedMessage(String error);

  /// Label for edit tab in body editor
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editEditorLabel;

  /// Title for editing existing scenario
  ///
  /// In en, this message translates to:
  /// **'Edit Scenario'**
  String get editScenarioTitle;

  /// Default educational focus for custom scenarios
  ///
  /// In en, this message translates to:
  /// **'Gravitational forces'**
  String get gravitationalForcesEditor;

  /// Default name for new scenarios in editor
  ///
  /// In en, this message translates to:
  /// **'New Scenario'**
  String get newScenarioEditor;

  /// Message shown when no bodies exist in scenario editor
  ///
  /// In en, this message translates to:
  /// **'No bodies yet'**
  String get noBodiesYetEditor;

  /// Section title for position coordinates in meters
  ///
  /// In en, this message translates to:
  /// **'Position (m)'**
  String get positionMEditor;

  /// Section title for position and motion settings
  ///
  /// In en, this message translates to:
  /// **'Position & Motion'**
  String get positionMotionEditor;

  /// Section title for body properties
  ///
  /// In en, this message translates to:
  /// **'Properties'**
  String get propertiesEditor;

  /// Hint text for delete body action
  ///
  /// In en, this message translates to:
  /// **'Remove this celestial body from the scenario'**
  String get removeThisCelestialBodyFromTheScenarioEditorHint;

  /// Label for softening parameter in physics preview
  ///
  /// In en, this message translates to:
  /// **'Softening'**
  String get softeningEditor;

  /// Section title for stellar properties
  ///
  /// In en, this message translates to:
  /// **'Stellar Properties'**
  String get stellarPropertiesEditor;

  /// Label for trail points setting in physics preview
  ///
  /// In en, this message translates to:
  /// **'Trail Points'**
  String get trailPointsEditor;

  /// Name for custom color fallback
  ///
  /// In en, this message translates to:
  /// **'custom color'**
  String get customColor;

  /// Label for custom scenario type
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get customLabel;

  /// Default description for custom scenarios
  ///
  /// In en, this message translates to:
  /// **'Custom gravitational scenario'**
  String get customScenarioDescription;

  /// Button text to view a scenario
  ///
  /// In en, this message translates to:
  /// **'View Scenario'**
  String get viewScenarioButton;

  /// Accessibility hint for view scenario action
  ///
  /// In en, this message translates to:
  /// **'View scenario details in read-only mode'**
  String get viewScenarioHint;

  /// Button text to export a scenario
  ///
  /// In en, this message translates to:
  /// **'Export Scenario'**
  String get exportScenarioButton;

  /// Accessibility hint for export scenario action
  ///
  /// In en, this message translates to:
  /// **'Export scenario to file for sharing'**
  String get exportScenarioHint;

  /// Error message when scenario export fails
  ///
  /// In en, this message translates to:
  /// **'Failed to export scenario: {error}'**
  String exportScenarioFailedMessage(String error);

  /// Message shown when export scenario is not implemented
  ///
  /// In en, this message translates to:
  /// **'Export scenario functionality not implemented yet'**
  String get exportScenarioNotImplementedMessage;

  /// Button text for save actions
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveButton;

  /// Tooltip for save body button
  ///
  /// In en, this message translates to:
  /// **'Save Body'**
  String get saveBodyTooltip;

  /// Accessibility label for save button when creating new body
  ///
  /// In en, this message translates to:
  /// **'Save new body'**
  String get saveNewBodyAccessibility;

  /// Accessibility hint for save button when creating new body
  ///
  /// In en, this message translates to:
  /// **'Creates the body with current settings'**
  String get saveNewBodyHint;

  /// Accessibility label for save button when editing existing body
  ///
  /// In en, this message translates to:
  /// **'Save changes to body'**
  String get saveChangesToBodyAccessibility;

  /// Accessibility hint for save button when editing existing body
  ///
  /// In en, this message translates to:
  /// **'Saves all changes made to this body'**
  String get saveChangesToBodyHint;

  /// Accessibility label for more actions menu button
  ///
  /// In en, this message translates to:
  /// **'More actions'**
  String get moreActionsAccessibility;

  /// Accessibility hint for more actions menu button
  ///
  /// In en, this message translates to:
  /// **'Open menu with duplicate and delete options'**
  String get moreActionsHint;

  /// Accessibility hint for duplicate body menu item
  ///
  /// In en, this message translates to:
  /// **'Creates a copy of this body'**
  String get duplicateBodyAccessibility;

  /// Accessibility hint for delete body menu item
  ///
  /// In en, this message translates to:
  /// **'Permanently removes this body'**
  String get deleteBodyAccessibility;

  /// Accessibility description when settings button has focus
  ///
  /// In en, this message translates to:
  /// **'Settings button focused - open application settings'**
  String get settingsButtonFocused;

  /// Description for the settings menu item
  ///
  /// In en, this message translates to:
  /// **'Visual & behavior options'**
  String get settingsMenuDescription;

  /// Tooltip for the settings button in the app bar
  ///
  /// In en, this message translates to:
  /// **'Application Settings'**
  String get settingsTooltip;

  /// Semantic action label for toggling camera auto-rotation
  ///
  /// In en, this message translates to:
  /// **'Toggle auto-rotation'**
  String get toggleAutoRotateAction;

  /// Tooltip for the gravity fields toggle button
  ///
  /// In en, this message translates to:
  /// **'Toggle Gravity Fields'**
  String get toggleGravityFieldsTooltip;

  /// Tooltip for habitability indicators toggle button
  ///
  /// In en, this message translates to:
  /// **'Toggle Planet Habitability Status'**
  String get toggleHabitabilityIndicatorsTooltip;

  /// Tooltip for habitable zones toggle button
  ///
  /// In en, this message translates to:
  /// **'Toggle Habitable Zones'**
  String get toggleHabitableZonesTooltip;

  /// Tooltip for the body labels toggle button
  ///
  /// In en, this message translates to:
  /// **'Toggle Body Labels'**
  String get toggleLabelsTooltip;

  /// Tooltip for the stats toggle button
  ///
  /// In en, this message translates to:
  /// **'Toggle Stats'**
  String get toggleStatsTooltip;

  /// Label for statistics display button
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get statsLabel;

  /// Description for the help menu item
  ///
  /// In en, this message translates to:
  /// **'Tutorial & objectives'**
  String get helpMenuDescription;

  /// Button to show tutorial
  ///
  /// In en, this message translates to:
  /// **'Tutorial'**
  String get tutorialButton;

  /// Description for tutorial camera step
  ///
  /// In en, this message translates to:
  /// **'Drag to rotate your view, pinch to zoom, use two fingers to roll the camera, and use three fingers to pan. The bottom bar has focus, center, and auto-rotation controls for a cinematic experience.'**
  String get tutorialCameraDescription;

  /// Title for tutorial camera step
  ///
  /// In en, this message translates to:
  /// **'Camera & View Controls'**
  String get tutorialCameraTitle;

  /// Description for tutorial controls step
  ///
  /// In en, this message translates to:
  /// **'Tap anywhere to bring up the floating Play/Pause controls for the simulation. The speed control is in the top-right corner. Tap the menu (⋮) for scenarios, settings, and physics adjustments.'**
  String get tutorialControlsDescription;

  /// First part of tutorial controls description (before menu icon)
  ///
  /// In en, this message translates to:
  /// **'Tap anywhere to bring up the floating Play/Pause controls for the simulation. The speed control is in the top-right corner. Tap the menu'**
  String get tutorialControlsDescriptionPart1;

  /// Second part of tutorial controls description (after menu icon)
  ///
  /// In en, this message translates to:
  /// **'for scenarios, settings, and physics adjustments.'**
  String get tutorialControlsDescriptionPart2;

  /// Title for tutorial controls step
  ///
  /// In en, this message translates to:
  /// **'Simulation Controls'**
  String get tutorialControlsTitle;

  /// Description for tutorial button
  ///
  /// In en, this message translates to:
  /// **'Interactive guided tour of the app'**
  String get tutorialDescription;

  /// Description for tutorial final step
  ///
  /// In en, this message translates to:
  /// **'You\'re all set! Start with the Solar System to see familiar planets, or dive into the Three-Body Problem for some chaotic fun. Remember: every reset creates a new universe to explore!'**
  String get tutorialExploreDescription;

  /// Title for tutorial final step
  ///
  /// In en, this message translates to:
  /// **'Ready to Explore!'**
  String get tutorialExploreTitle;

  /// Hint text for tutorial navigation
  ///
  /// In en, this message translates to:
  /// **'Swipe left/right or use buttons to navigate'**
  String get tutorialNavigationHint;

  /// Description for tutorial objectives step
  ///
  /// In en, this message translates to:
  /// **'• Observe realistic orbital mechanics\n• Explore different astronomical scenarios\n• Experiment with gravitational interactions\n• Watch collisions and mergers\n• Learn about planetary motion\n• Discover chaotic three-body dynamics'**
  String get tutorialObjectivesDescription;

  /// Title for tutorial objectives step
  ///
  /// In en, this message translates to:
  /// **'What Can You Do?'**
  String get tutorialObjectivesTitle;

  /// Message shown when tutorial state is reset
  ///
  /// In en, this message translates to:
  /// **'Tutorial state reset! Restart app to see first-time experience.'**
  String get tutorialResetMessage;

  /// Success message when tutorial is reset
  ///
  /// In en, this message translates to:
  /// **'Tutorial progress has been reset'**
  String get tutorialResetSuccess;

  /// Description for tutorial scenarios step
  ///
  /// In en, this message translates to:
  /// **'Access the menu (⋮) in the top-right to explore different scenarios: our Solar System, Earth-Moon dynamics, Binary Stars, or the chaotic Three-Body Problem. Each offers unique physics to discover!'**
  String get tutorialScenariosDescription;

  /// First part of tutorial scenarios description (before menu icon)
  ///
  /// In en, this message translates to:
  /// **'Access the menu'**
  String get tutorialScenariosDescriptionPart1;

  /// Second part of tutorial scenarios description (after menu icon)
  ///
  /// In en, this message translates to:
  /// **'in the top-right to explore different scenarios: our Solar System, Earth-Moon dynamics, Binary Stars, or the chaotic Three-Body Problem. Each offers unique physics to discover!'**
  String get tutorialScenariosDescriptionPart2;

  /// Title for tutorial scenarios step
  ///
  /// In en, this message translates to:
  /// **'Choose Your Adventure'**
  String get tutorialScenariosTitle;

  /// Description for tutorial welcome step
  ///
  /// In en, this message translates to:
  /// **'Welcome to Graviton, your window into the fascinating world of gravitational physics! This app lets you explore how celestial bodies interact through gravity, creating beautiful orbital dances across space and time.'**
  String get tutorialWelcomeDescription;

  /// Title for tutorial welcome step
  ///
  /// In en, this message translates to:
  /// **'Welcome to Graviton!'**
  String get tutorialWelcomeTitle;

  /// Description text for the welcome message card
  ///
  /// In en, this message translates to:
  /// **'Explore gravitational physics through interactive simulations. Try different scenarios, adjust controls, and watch the cosmos unfold!'**
  String get welcomeCardDescription;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Label for scenario description field in editor
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descriptionEditorLabel;

  /// Next button
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// OK button text
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Previous button
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// Live region announcement for value changes
  ///
  /// In en, this message translates to:
  /// **'{updateType} changed to {value}'**
  String liveUpdateAnnouncement(String updateType, String value);

  /// Formatted simulation time in seconds
  ///
  /// In en, this message translates to:
  /// **'{time}s'**
  String timeFormatted(String time);

  /// Label for simulation time
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get timeLabel;

  /// Statistics label for current time scale multiplier
  ///
  /// In en, this message translates to:
  /// **'Time Scale'**
  String get timeScaleStatLabel;

  /// Button text to update later
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get updateLater;

  /// Button text to update now
  ///
  /// In en, this message translates to:
  /// **'Update Now'**
  String get updateNow;

  /// Message for the update required dialog
  ///
  /// In en, this message translates to:
  /// **'A newer version of this app is available. Please update to continue using the app with the latest features and improvements.'**
  String get updateRequiredMessage;

  /// Title for the update required dialog
  ///
  /// In en, this message translates to:
  /// **'Update Required'**
  String get updateRequiredTitle;

  /// Warning message for the update required dialog
  ///
  /// In en, this message translates to:
  /// **'This version is no longer supported.'**
  String get updateRequiredWarning;

  /// Error message when failing to load changelogs
  ///
  /// In en, this message translates to:
  /// **'Error loading changelogs: {error}'**
  String errorLoadingChangelogs(String error);

  /// Error message when link fails to open
  ///
  /// In en, this message translates to:
  /// **'Error opening link: {error}'**
  String errorOpeningLink(String error);

  /// Display name for debug notification type
  ///
  /// In en, this message translates to:
  /// **'Debug'**
  String get notificationTypeDebug;

  /// Display name for info notification type
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get notificationTypeInfo;

  /// Title for warning notification dialog
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warningTitle;

  /// Debug message when accessibility announcement cannot be made
  ///
  /// In en, this message translates to:
  /// **'Accessibility announcement skipped (no binding): {message}'**
  String accessibilityAnnouncementSkippedNoBindingMessage(String message);

  /// Accessibility announcement for camera focus
  ///
  /// In en, this message translates to:
  /// **'Camera focused on nearest celestial body'**
  String get accessibilityCameraFocus;

  /// Accessibility announcement for camera follow mode
  ///
  /// In en, this message translates to:
  /// **'Camera now following selected celestial body'**
  String get accessibilityCameraFollow;

  /// Accessibility announcement for camera reset
  ///
  /// In en, this message translates to:
  /// **'Camera view reset to default position'**
  String get accessibilityCameraReset;

  /// Accessibility announcement when camera stops following
  ///
  /// In en, this message translates to:
  /// **'Camera stopped following celestial body'**
  String get accessibilityCameraUnfollow;

  /// Accessibility announcement for collision radius changes
  ///
  /// In en, this message translates to:
  /// **'Collision sensitivity changed to {newValue}'**
  String accessibilityCollisionRadiusChange(String newValue);

  /// Accessibility announcement for error messages
  ///
  /// In en, this message translates to:
  /// **'Error: {errorMessage}'**
  String accessibilityError(String errorMessage);

  /// Accessibility announcement for gravity changes
  ///
  /// In en, this message translates to:
  /// **'Gravity strength changed to {newValue}'**
  String accessibilityGravityChange(String newValue);

  /// Accessibility announcement for celestial body collisions
  ///
  /// In en, this message translates to:
  /// **'Collision detected: {body1} merged with {body2}'**
  String accessibilityMergeEvent(String body1, String body2);

  /// Additional context for merge event announcements
  ///
  /// In en, this message translates to:
  /// **'The combined mass creates a new celestial body'**
  String get accessibilityMergeEventContext;

  /// Accessibility announcement for scenario changes
  ///
  /// In en, this message translates to:
  /// **'Scenario changed to {scenarioName}'**
  String accessibilityScenarioChange(String scenarioName);

  /// Additional context for scenario change announcements
  ///
  /// In en, this message translates to:
  /// **'New celestial bodies and physics parameters loaded'**
  String get accessibilityScenarioChangeContext;

  /// Accessibility announcement when a setting is disabled
  ///
  /// In en, this message translates to:
  /// **'{settingName} disabled'**
  String accessibilitySettingDisabled(String settingName);

  /// Accessibility announcement when a setting is enabled
  ///
  /// In en, this message translates to:
  /// **'{settingName} enabled'**
  String accessibilitySettingEnabled(String settingName);

  /// Accessibility announcement when simulation is paused
  ///
  /// In en, this message translates to:
  /// **'Simulation paused'**
  String get accessibilitySimulationPaused;

  /// Additional context for simulation pause announcement
  ///
  /// In en, this message translates to:
  /// **'All celestial bodies have stopped moving'**
  String get accessibilitySimulationPausedContext;

  /// Accessibility announcement when simulation is reset
  ///
  /// In en, this message translates to:
  /// **'Simulation reset'**
  String get accessibilitySimulationReset;

  /// Additional context for simulation reset announcement
  ///
  /// In en, this message translates to:
  /// **'New scenario loaded with fresh celestial bodies'**
  String get accessibilitySimulationResetContext;

  /// Accessibility announcement when simulation is resumed
  ///
  /// In en, this message translates to:
  /// **'Simulation resumed'**
  String get accessibilitySimulationResumed;

  /// Additional context for simulation resume announcement
  ///
  /// In en, this message translates to:
  /// **'Celestial bodies are moving again'**
  String get accessibilitySimulationResumedContext;

  /// Accessibility announcement when simulation starts
  ///
  /// In en, this message translates to:
  /// **'Simulation started'**
  String get accessibilitySimulationStarted;

  /// Additional context for simulation start announcement
  ///
  /// In en, this message translates to:
  /// **'Celestial bodies are now in motion'**
  String get accessibilitySimulationStartedContext;

  /// Accessibility announcement when simulation is stopped
  ///
  /// In en, this message translates to:
  /// **'Simulation stopped'**
  String get accessibilitySimulationStopped;

  /// Additional context for simulation stop announcement
  ///
  /// In en, this message translates to:
  /// **'All celestial bodies have been reset'**
  String get accessibilitySimulationStoppedContext;

  /// Accessibility announcement for speed changes
  ///
  /// In en, this message translates to:
  /// **'Simulation speed changed to {newValue}'**
  String accessibilitySpeedChange(String newValue);

  /// Accessibility announcement for tutorial progress
  ///
  /// In en, this message translates to:
  /// **'Tutorial step {currentStep} of {totalSteps}: {stepName}'**
  String accessibilityTutorialProgress(
    int currentStep,
    int totalSteps,
    String stepName,
  );

  /// Section header for added features
  ///
  /// In en, this message translates to:
  /// **'New Features'**
  String get changelogAdded;

  /// Button to show changelog dialog
  ///
  /// In en, this message translates to:
  /// **'Show Changelog'**
  String get changelogButton;

  /// Display name for added changelog category
  ///
  /// In en, this message translates to:
  /// **'Added'**
  String get changelogCategoryAdded;

  /// Display name for fixed changelog category
  ///
  /// In en, this message translates to:
  /// **'Fixed'**
  String get changelogCategoryFixed;

  /// Display name for improved changelog category
  ///
  /// In en, this message translates to:
  /// **'Improved'**
  String get changelogCategoryImproved;

  /// Description for changelog button
  ///
  /// In en, this message translates to:
  /// **'View app updates and changes'**
  String get changelogDescription;

  /// Button to finish changelog
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get changelogDone;

  /// Section header for bug fixes
  ///
  /// In en, this message translates to:
  /// **'Bug Fixes'**
  String get changelogFixed;

  /// Title for the changelog dialog in home screen
  ///
  /// In en, this message translates to:
  /// **'Changelog'**
  String get changelogHometitle;

  /// Section header for improvements
  ///
  /// In en, this message translates to:
  /// **'Improvements'**
  String get changelogImproved;

  /// Error message when changelog fails to load
  ///
  /// In en, this message translates to:
  /// **'Failed to load changelog: {error}'**
  String changelogLoadError(String error);

  /// Error message when no changelog data is found
  ///
  /// In en, this message translates to:
  /// **'No changelog found. Add changelog data to Firestore first.\nCurrent version: {version}'**
  String changelogNotFoundError(String version);

  /// Format for changelog release date
  ///
  /// In en, this message translates to:
  /// **'Released {date}'**
  String changelogReleaseDate(String date);

  /// Message shown when changelog state is reset
  ///
  /// In en, this message translates to:
  /// **'Changelog state has been reset'**
  String get changelogResetMessage;

  /// Success message when changelog is reset
  ///
  /// In en, this message translates to:
  /// **'Changelog status has been reset'**
  String get changelogResetSuccess;

  /// Title for changelog dialog
  ///
  /// In en, this message translates to:
  /// **'What\'s New'**
  String get changelogTitle;

  /// Section title for debug and statistics options
  ///
  /// In en, this message translates to:
  /// **'Debug & Statistics'**
  String get debugStatisticsTitle;

  /// Error message when changelog fails to load
  ///
  /// In en, this message translates to:
  /// **'Error loading changelog: {error}'**
  String errorLoadingChangelogEHome(String error);

  /// Message when no changelog is available for a specific version
  ///
  /// In en, this message translates to:
  /// **'No changelog available for version {version}'**
  String noChangelogAvailableForVersionHome(String version);

  /// Name for test preset in screenshot mode
  ///
  /// In en, this message translates to:
  /// **'Test Preset'**
  String get testPreset;

  /// Button text to test a scenario
  ///
  /// In en, this message translates to:
  /// **'Test Scenario'**
  String get testScenarioButton;

  /// Accessibility hint for test scenario action
  ///
  /// In en, this message translates to:
  /// **'Test the current scenario in simulation'**
  String get testScenarioHint;

  /// Message shown when test scenario is not implemented
  ///
  /// In en, this message translates to:
  /// **'Test scenario functionality not implemented yet'**
  String get testScenarioNotImplementedMessage;

  /// Accessibility hint for scenario editor menu button
  ///
  /// In en, this message translates to:
  /// **'Open menu with test and export options'**
  String get scenarioEditorMenuHint;

  /// Tooltip for the about button
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutButtonTooltip;

  /// Description for the about menu item
  ///
  /// In en, this message translates to:
  /// **'App information & credits'**
  String get aboutMenuDescription;

  /// Accessibility hint for app preferences
  ///
  /// In en, this message translates to:
  /// **'Access app preferences'**
  String get accessAppPreferences;

  /// Action hint for scenario options
  ///
  /// In en, this message translates to:
  /// **'Access scenario options'**
  String get accessScenarioOptions;

  /// Action hint for speed control
  ///
  /// In en, this message translates to:
  /// **'Adjust simulation speed'**
  String get adjustSimulationSpeed;

  /// Section title for AI camera modes
  ///
  /// In en, this message translates to:
  /// **'AI Camera Modes'**
  String get aiCameraModesTitle;

  /// Copyright notice text
  ///
  /// In en, this message translates to:
  /// **'All rights reserved'**
  String get allRightsReserved;

  /// Title for announcement notification dialog
  ///
  /// In en, this message translates to:
  /// **'Announcement'**
  String get announcementTitle;

  /// Snackbar message when a preset is applied
  ///
  /// In en, this message translates to:
  /// **'Applied preset: {presetName}'**
  String appliedPreset(String presetName);

  /// Button text to apply the selected scene preset
  ///
  /// In en, this message translates to:
  /// **'Apply Scene'**
  String get applyScene;

  /// Validation error message for empty scenario
  ///
  /// In en, this message translates to:
  /// **'At least one body is required'**
  String get atLeastOneBodyIsRequired;

  /// Label for author information
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get authorLabel;

  /// Status text when auto-rotation is enabled
  ///
  /// In en, this message translates to:
  /// **'active'**
  String get autoRotateActive;

  /// Status text when auto-rotation is disabled
  ///
  /// In en, this message translates to:
  /// **'inactive'**
  String get autoRotateInactive;

  /// Label for auto-rotate status
  ///
  /// In en, this message translates to:
  /// **'Auto-rotate'**
  String get autoRotateLabel;

  /// Auto-rotate is disabled
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get autoRotateOff;

  /// Auto-rotate is enabled
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get autoRotateOn;

  /// Tooltip for the auto-rotate button
  ///
  /// In en, this message translates to:
  /// **'Auto Rotate'**
  String get autoRotateTooltip;

  /// Label for camera auto-rotation speed control slider
  ///
  /// In en, this message translates to:
  /// **'Rotate Speed'**
  String get rotateSpeed;

  /// Name for black color
  ///
  /// In en, this message translates to:
  /// **'black'**
  String get blackColor;

  /// Word for celestial bodies (lowercase for use in sentences)
  ///
  /// In en, this message translates to:
  /// **'bodies'**
  String get bodies;

  /// Description text for the bodies header section
  ///
  /// In en, this message translates to:
  /// **'Celestial bodies in your scenario'**
  String get bodiesHeaderDescription;

  /// Header text showing number of bodies with proper pluralization
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No Bodies} =1{1 Body} other{{count} Bodies}}'**
  String bodiesHeaderPlural(int count);

  /// Header text showing number of scenarios with proper pluralization
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No Scenarios} =1{1 Scenario} other{{count} Scenarios}}'**
  String scenariosHeaderPlural(int count);

  /// Header text showing number of experiments with proper pluralization
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No Experiments} =1{1 Experiment} other{{count} Experiments}}'**
  String experimentsHeaderPlural(int count);

  /// Description of bodies currently in simulation
  ///
  /// In en, this message translates to:
  /// **'Bodies in simulation: {descriptions}'**
  String bodiesInSimulation(String descriptions);

  /// Label for number of celestial bodies
  ///
  /// In en, this message translates to:
  /// **'Bodies'**
  String get bodiesLabel;

  /// Name for first star in random scenarios
  ///
  /// In en, this message translates to:
  /// **'Alpha'**
  String get bodyAlpha;

  /// Name for asteroids with number
  ///
  /// In en, this message translates to:
  /// **'Asteroid {number}'**
  String bodyAsteroid(int number);

  /// Name for second star in random scenarios
  ///
  /// In en, this message translates to:
  /// **'Beta'**
  String get bodyBeta;

  /// Name for black hole in galaxy formation
  ///
  /// In en, this message translates to:
  /// **'Black Hole'**
  String get bodyBlackHole;

  /// Name for center of mass point in calculations
  ///
  /// In en, this message translates to:
  /// **'Center of Mass'**
  String get bodyCenterOfMass;

  /// Name for central star in asteroid belt
  ///
  /// In en, this message translates to:
  /// **'Central Star'**
  String get bodyCentralStar;

  /// Validation error for invalid body color
  ///
  /// In en, this message translates to:
  /// **'{prefix}: color must be valid hex format (#RRGGBB or #AARRGGBB)'**
  String bodyColorInvalid(String prefix);

  /// Name for Earth
  ///
  /// In en, this message translates to:
  /// **'Earth'**
  String get bodyEarth;

  /// Name for Earth-like planets
  ///
  /// In en, this message translates to:
  /// **'Earth-like'**
  String get bodyEarthLike;

  /// Name for third star in random scenarios
  ///
  /// In en, this message translates to:
  /// **'Gamma'**
  String get bodyGamma;

  /// Template for body index reference
  ///
  /// In en, this message translates to:
  /// **'Body {index}'**
  String bodyIndex(int index);

  /// Name for inner companion planet in asteroid belt scenario
  ///
  /// In en, this message translates to:
  /// **'Inner Planet'**
  String get bodyInnerPlanet;

  /// Name for Jupiter planet
  ///
  /// In en, this message translates to:
  /// **'Jupiter'**
  String get bodyJupiter;

  /// Name for Mars planet
  ///
  /// In en, this message translates to:
  /// **'Mars'**
  String get bodyMars;

  /// Validation error for invalid body mass
  ///
  /// In en, this message translates to:
  /// **'{prefix}: mass must be between 0.001 and 1000'**
  String bodyMassInvalid(String prefix);

  /// Name for Mercury planet
  ///
  /// In en, this message translates to:
  /// **'Mercury'**
  String get bodyMercury;

  /// Name for the Moon
  ///
  /// In en, this message translates to:
  /// **'Moon'**
  String get bodyMoon;

  /// Name for moon in binary star system
  ///
  /// In en, this message translates to:
  /// **'Moon M'**
  String get bodyMoonM;

  /// Name for spacecraft in gravitational slingshot scenario
  ///
  /// In en, this message translates to:
  /// **'Spacecraft'**
  String get bodySpacecraft;

  /// Name for Jupiter's moon Io
  ///
  /// In en, this message translates to:
  /// **'Io'**
  String get bodyIo;

  /// Name for Jupiter's moon Europa
  ///
  /// In en, this message translates to:
  /// **'Europa'**
  String get bodyEuropa;

  /// Template for duplicated body name
  ///
  /// In en, this message translates to:
  /// **'{bodyName} Copy'**
  String bodyNameCopyTemplate(String bodyName);

  /// Validation error for missing body name
  ///
  /// In en, this message translates to:
  /// **'{prefix}: name is required'**
  String bodyNameRequired(String prefix);

  /// Name for Neptune planet
  ///
  /// In en, this message translates to:
  /// **'Neptune'**
  String get bodyNeptune;

  /// Template for naming new bodies with a number
  ///
  /// In en, this message translates to:
  /// **'Body {number}'**
  String bodyNumberTemplate(String number);

  /// Name for outer companion planet in asteroid belt scenario
  ///
  /// In en, this message translates to:
  /// **'Outer Planet'**
  String get bodyOuterPlanet;

  /// Name for planet in binary star system
  ///
  /// In en, this message translates to:
  /// **'Planet P'**
  String get bodyPlanetP;

  /// Validation error for invalid position component
  ///
  /// In en, this message translates to:
  /// **'{prefix}: position[{component}] must be a finite number'**
  String bodyPositionComponentInvalid(String prefix, int component);

  /// Validation error for invalid body position
  ///
  /// In en, this message translates to:
  /// **'{prefix}: position must be a 3D array [x, y, z]'**
  String bodyPositionInvalid(String prefix);

  /// Label for X axis
  ///
  /// In en, this message translates to:
  /// **'X:'**
  String get bodyPropertiesAxisX;

  /// Label for Y axis
  ///
  /// In en, this message translates to:
  /// **'Y:'**
  String get bodyPropertiesAxisY;

  /// Label for Z axis
  ///
  /// In en, this message translates to:
  /// **'Z:'**
  String get bodyPropertiesAxisZ;

  /// Label for stellar luminosity field
  ///
  /// In en, this message translates to:
  /// **'Stellar Luminosity'**
  String get bodyPropertiesLuminosity;

  /// Label for body mass field
  ///
  /// In en, this message translates to:
  /// **'Mass'**
  String get bodyPropertiesMass;

  /// Label for body name field
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get bodyPropertiesName;

  /// Hint text for body name input field
  ///
  /// In en, this message translates to:
  /// **'Enter body name'**
  String get bodyPropertiesNameHint;

  /// Label for body radius field
  ///
  /// In en, this message translates to:
  /// **'Radius'**
  String get bodyPropertiesRadius;

  /// Hint text for mass slider in body properties
  ///
  /// In en, this message translates to:
  /// **'Adjust the gravitational influence and orbital dynamics'**
  String get bodyPropertiesMassHint;

  /// Hint text for radius slider in body properties
  ///
  /// In en, this message translates to:
  /// **'Control the size and collision boundary'**
  String get bodyPropertiesRadiusHint;

  /// Title for the body properties dialog
  ///
  /// In en, this message translates to:
  /// **'Body Properties'**
  String get bodyPropertiesTitle;

  /// Label for velocity field
  ///
  /// In en, this message translates to:
  /// **'Velocity'**
  String get bodyPropertiesVelocity;

  /// Validation error for invalid body radius
  ///
  /// In en, this message translates to:
  /// **'{prefix}: radius must be between 0.1 and 50'**
  String bodyRadiusInvalid(String prefix);

  /// Name for ring particles with number
  ///
  /// In en, this message translates to:
  /// **'Ring {number}'**
  String bodyRing(int number);

  /// Name for planet with rings
  ///
  /// In en, this message translates to:
  /// **'Ringed Planet'**
  String get bodyRingedPlanet;

  /// Name for small rocky planets
  ///
  /// In en, this message translates to:
  /// **'Rocky Planet'**
  String get bodyRockyPlanet;

  /// Name for Saturn planet
  ///
  /// In en, this message translates to:
  /// **'Saturn'**
  String get bodySaturn;

  /// Template for selected body display
  ///
  /// In en, this message translates to:
  /// **'Body {bodyNumber}'**
  String bodySelectedTemplate(String bodyNumber);

  /// Name for first star in binary systems
  ///
  /// In en, this message translates to:
  /// **'Star A'**
  String get bodyStarA;

  /// Name for second star in binary systems
  ///
  /// In en, this message translates to:
  /// **'Star B'**
  String get bodyStarB;

  /// Name pattern for numbered stars in galaxy scenarios
  ///
  /// In en, this message translates to:
  /// **'Star {number}'**
  String bodyStarNumber(int number);

  /// Name for the Sun
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get bodySun;

  /// Name for Super-Earth planets
  ///
  /// In en, this message translates to:
  /// **'Super-Earth'**
  String get bodySuperEarth;

  /// Display name for asteroid body type
  ///
  /// In en, this message translates to:
  /// **'Asteroid'**
  String get bodyTypeAsteroid;

  /// Plural form for asteroid body type with count
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 Asteroid} other{{count} Asteroids}}'**
  String bodyTypeAsteroidPlural(int count);

  /// Validation error for invalid body type
  ///
  /// In en, this message translates to:
  /// **'{prefix}: invalid bodyType \"{bodyType}\"'**
  String bodyTypeInvalid(String prefix, String bodyType);

  /// Plural form for moon body type with count
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 Moon} other{{count} Moons}}'**
  String bodyTypeMoonPlural(int count);

  /// Display name for planet body type
  ///
  /// In en, this message translates to:
  /// **'Planet'**
  String get bodyTypePlanet;

  /// Plural form for planet body type with count
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 Planet} other{{count} Planets}}'**
  String bodyTypePlanetPlural(int count);

  /// Accessibility label for body type picker
  ///
  /// In en, this message translates to:
  /// **'Body type selector'**
  String get bodyTypeSelector;

  /// Display name for star body type
  ///
  /// In en, this message translates to:
  /// **'Star'**
  String get bodyTypeStar;

  /// Plural form for star body type with count
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 Star} other{{count} Stars}}'**
  String bodyTypeStarPlural(int count);

  /// Display name for neutron star body type
  ///
  /// In en, this message translates to:
  /// **'Neutron Star'**
  String get bodyTypeNeutronStar;

  /// Display name for black hole body type
  ///
  /// In en, this message translates to:
  /// **'Black Hole'**
  String get bodyTypeBlackHole;

  /// Display name for moon body type
  ///
  /// In en, this message translates to:
  /// **'Moon'**
  String get bodyTypeMoon;

  /// Template for body type accessibility label
  ///
  /// In en, this message translates to:
  /// **'{bodyType} body type'**
  String bodyTypeTemplate(String bodyType, Object type);

  /// Tooltip description for star body type
  ///
  /// In en, this message translates to:
  /// **'Massive celestial bodies that generate light and heat through nuclear fusion. Stars are the primary energy sources in stellar systems.'**
  String get bodyTypeTooltipStar;

  /// Tooltip description for planet body type
  ///
  /// In en, this message translates to:
  /// **'Large celestial bodies that orbit stars and have cleared their orbital path. Planets can be rocky or gaseous and may host moons.'**
  String get bodyTypeTooltipPlanet;

  /// Tooltip description for moon body type
  ///
  /// In en, this message translates to:
  /// **'Natural satellites that orbit planets. Moons can influence tides and provide stability to planetary systems.'**
  String get bodyTypeTooltipMoon;

  /// Tooltip description for asteroid body type
  ///
  /// In en, this message translates to:
  /// **'Small rocky bodies that orbit the sun. Asteroids are remnants from the early formation of the solar system.'**
  String get bodyTypeTooltipAsteroid;

  /// Tooltip description for black hole body type
  ///
  /// In en, this message translates to:
  /// **'Regions of spacetime with gravitational fields so intense that nothing, not even light, can escape from them.'**
  String get bodyTypeTooltipBlackHole;

  /// Tooltip description for neutron star body type
  ///
  /// In en, this message translates to:
  /// **'Extremely dense stellar remnants formed when massive stars collapse. They have incredibly strong gravitational and magnetic fields.'**
  String get bodyTypeTooltipNeutronStar;

  /// Name for Uranus planet
  ///
  /// In en, this message translates to:
  /// **'Uranus'**
  String get bodyUranus;

  /// Validation error for invalid velocity component
  ///
  /// In en, this message translates to:
  /// **'{prefix}: velocity[{component}] must be a finite number'**
  String bodyVelocityComponentInvalid(String prefix, int component);

  /// Validation error for invalid body velocity
  ///
  /// In en, this message translates to:
  /// **'{prefix}: velocity must be a 3D array [vx, vy, vz]'**
  String bodyVelocityInvalid(String prefix);

  /// Name for Venus planet
  ///
  /// In en, this message translates to:
  /// **'Venus'**
  String get bodyVenus;

  /// Accessibility description when bottom sheet has focus
  ///
  /// In en, this message translates to:
  /// **'Bottom sheet focused - scenario and settings access'**
  String get bottomSheetFocused;

  /// Accessibility label for bottom sheet component
  ///
  /// In en, this message translates to:
  /// **'Bottom sheet'**
  String get bottomSheetLabel;

  /// Accessibility hint for scenario browsing
  ///
  /// In en, this message translates to:
  /// **'Browse available simulations'**
  String get browseAvailableSimulations;

  /// Template for celestial body semantic label
  ///
  /// In en, this message translates to:
  /// **'{bodyName} celestial body'**
  String celestialBodyNameTemplate(String bodyName, Object name);

  /// Label for center view button
  ///
  /// In en, this message translates to:
  /// **'Center'**
  String get centerLabel;

  /// Tooltip for the center view button
  ///
  /// In en, this message translates to:
  /// **'Center View'**
  String get centerViewTooltip;

  /// Description for cinematic camera technique setting
  ///
  /// In en, this message translates to:
  /// **'Choose how AI controls the camera when following objects'**
  String get cinematicCameraTechniqueDescription;

  /// Label for cinematic camera technique selection
  ///
  /// In en, this message translates to:
  /// **'AI Camera Technique'**
  String get cinematicCameraTechniqueLabel;

  /// Description for dynamic framing camera technique
  ///
  /// In en, this message translates to:
  /// **'Real-time dramatic targeting for chaotic scenarios'**
  String get cinematicTechniqueDynamicFramingDesc;

  /// Description for predictive orbital camera technique
  ///
  /// In en, this message translates to:
  /// **'AI tours and orbital predictions for educational scenarios'**
  String get cinematicTechniquePredictiveOrbitalDesc;

  /// Label for close button
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeButton;

  /// State description for collapsed UI elements
  ///
  /// In en, this message translates to:
  /// **'collapsed'**
  String get collapsedState;

  /// Collisions section header in simulation settings
  ///
  /// In en, this message translates to:
  /// **'Collisions'**
  String get collisionsSection;

  /// Section header for color-related settings
  ///
  /// In en, this message translates to:
  /// **'Colors'**
  String get colorsLabel;

  /// The company name
  ///
  /// In en, this message translates to:
  /// **'Chipper Technologies LLC'**
  String get companyName;

  /// Option for cool-colored trails
  ///
  /// In en, this message translates to:
  /// **'❄️ Cool'**
  String get coolTrails;

  /// Message shown when text is copied to clipboard
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard: {text}'**
  String copiedToClipboard(String text);

  /// Button to copy text to clipboard
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copyButton;

  /// Label for copyright information section
  ///
  /// In en, this message translates to:
  /// **'Copyright'**
  String get copyrightLabel;

  /// Error message when URL cannot be opened
  ///
  /// In en, this message translates to:
  /// **'Could not open {url}'**
  String couldNotOpenUrl(String url);

  /// Description for crosshairs visual aid
  ///
  /// In en, this message translates to:
  /// **'Show center screen indicator'**
  String get crosshairsDescription;

  /// Title for crosshairs visual aid toggle
  ///
  /// In en, this message translates to:
  /// **'Crosshairs'**
  String get crosshairsTitle;

  /// Label for the currently selected scenario
  ///
  /// In en, this message translates to:
  /// **'Current scenario'**
  String get currentScenario;

  /// Section title for current simulation statistics
  ///
  /// In en, this message translates to:
  /// **'Current Statistics'**
  String get currentStatisticsTitle;

  /// Accessibility hint for currently selected items
  ///
  /// In en, this message translates to:
  /// **'Currently selected'**
  String get currentlySelected;

  /// Name for cyan color
  ///
  /// In en, this message translates to:
  /// **'cyan'**
  String get cyanColor;

  /// Button text to deactivate screenshot mode
  ///
  /// In en, this message translates to:
  /// **'Deactivate'**
  String get deactivate;

  /// Hint text for scenario description input field
  ///
  /// In en, this message translates to:
  /// **'Describe what this scenario demonstrates'**
  String get describeWhatThisScenarioDemonstratesEditorHint;

  /// Label for details tab in body editor
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get detailsEditorLabel;

  /// Description for developer tools menu item
  ///
  /// In en, this message translates to:
  /// **'Debug tools for development'**
  String get developerToolsMenuDescription;

  /// Title for developer tools dialog
  ///
  /// In en, this message translates to:
  /// **'Developer Tools'**
  String get developerToolsTitle;

  /// Label for difficulty selection dropdown
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get difficultyEditorLabel;

  /// Button text to discard changes
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discardButton;

  /// Action hint for camera rotation
  ///
  /// In en, this message translates to:
  /// **'Drag to rotate camera view'**
  String get dragToRotateCameraView;

  /// Title for the dual orbital paths toggle
  ///
  /// In en, this message translates to:
  /// **'Dual Orbital Paths'**
  String get dualOrbitalPaths;

  /// Description for dual orbital paths setting
  ///
  /// In en, this message translates to:
  /// **'Show both ideal circular and actual elliptical orbital paths'**
  String get dualOrbitalPathsDescription;

  /// Label for duplicate body action
  ///
  /// In en, this message translates to:
  /// **'Duplicate {bodyName}'**
  String duplicateBodyNameTemplate(String bodyName);

  /// Tooltip for duplicate body action
  ///
  /// In en, this message translates to:
  /// **'Duplicate Body'**
  String get duplicateBodyTooltip;

  /// Description for dynamic framing camera mode
  ///
  /// In en, this message translates to:
  /// **'AI dynamically frames all objects'**
  String get dynamicFramingDescription;

  /// Name for earth blue color
  ///
  /// In en, this message translates to:
  /// **'earth blue'**
  String get earthBlueColor;

  /// Formatted simulation time in Earth years (abbreviated)
  ///
  /// In en, this message translates to:
  /// **'{years} yr'**
  String earthYearsFormatted(String years);

  /// Label for simulation time converted to Earth years
  ///
  /// In en, this message translates to:
  /// **'Earth Years'**
  String get earthYearsLabel;

  /// Educational focus for binary stars scenario
  ///
  /// In en, this message translates to:
  /// **'binary orbits'**
  String get educationalFocusBinaryOrbits;

  /// Educational focus for random scenario
  ///
  /// In en, this message translates to:
  /// **'chaotic dynamics'**
  String get educationalFocusChaoticDynamics;

  /// Educational focus for asteroid belt scenario
  ///
  /// In en, this message translates to:
  /// **'many-body dynamics'**
  String get educationalFocusManyBodyDynamics;

  /// Educational focus for solar system scenario
  ///
  /// In en, this message translates to:
  /// **'planetary motion'**
  String get educationalFocusPlanetaryMotion;

  /// Educational focus for Earth-Moon-Sun scenario
  ///
  /// In en, this message translates to:
  /// **'real-world system'**
  String get educationalFocusRealWorldSystem;

  /// Educational focus for galaxy formation scenario
  ///
  /// In en, this message translates to:
  /// **'structure formation'**
  String get educationalFocusStructureFormation;

  /// Title for educational objectives section in editor
  ///
  /// In en, this message translates to:
  /// **'Educational Objectives'**
  String get educationalObjectivesEditortitle;

  /// Message explaining future educational objectives functionality
  ///
  /// In en, this message translates to:
  /// **'Educational objectives and challenges can be configured here in future versions.'**
  String get educationalObjectivesFutureMessage;

  /// List of planned educational objective features
  ///
  /// In en, this message translates to:
  /// **'This will include:\n• Learning goals\n• Success criteria\n• Guided challenges\n• Assessment rubrics'**
  String get educationalObjectivesListMessage;

  /// Title for emergency notification dialog
  ///
  /// In en, this message translates to:
  /// **'Important Notice'**
  String get emergencyNotificationTitle;

  /// Hint text for scenario name input field
  ///
  /// In en, this message translates to:
  /// **'Enter scenario name'**
  String get enterScenarioNameEditorHint;

  /// Description for equipotential surfaces setting
  ///
  /// In en, this message translates to:
  /// **'Show surfaces of equal gravitational potential energy'**
  String get equipotentialSurfacesDescription;

  /// Label for equipotential surfaces toggle
  ///
  /// In en, this message translates to:
  /// **'Equipotential Surfaces'**
  String get equipotentialSurfacesLabel;

  /// Exit button text
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// Message for exit confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit Graviton?'**
  String get exitAppMessage;

  /// Title for exit confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Exit App'**
  String get exitAppTitle;

  /// State description for expanded UI elements
  ///
  /// In en, this message translates to:
  /// **'expanded'**
  String get expandedState;

  /// Error message when scenario switching fails
  ///
  /// In en, this message translates to:
  /// **'Failed to switch scenario: {error}'**
  String failedToSwitchScenarioError(String error);

  /// Label for field of view slider
  ///
  /// In en, this message translates to:
  /// **'Field of View'**
  String get fieldOfViewLabel;

  /// Tooltip for the focus on nearest body button
  ///
  /// In en, this message translates to:
  /// **'Focus on Nearest Body'**
  String get focusOnNearestTooltip;

  /// Label for follow object button
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get followLabel;

  /// Tooltip for the follow object button when an object is selected
  ///
  /// In en, this message translates to:
  /// **'Follow Selected Object'**
  String get followObjectTooltip;

  /// Final tutorial button to start using the app
  ///
  /// In en, this message translates to:
  /// **'Get Started!'**
  String get getStarted;

  /// Description for global gravity fields setting
  ///
  /// In en, this message translates to:
  /// **'Enable gravity field visualization for all massive objects'**
  String get globalGravityFieldsDescription;

  /// Label for global gravity fields toggle
  ///
  /// In en, this message translates to:
  /// **'Global Gravity Fields'**
  String get globalGravityFieldsLabel;

  /// Button text to dismiss welcome card
  ///
  /// In en, this message translates to:
  /// **'Got it!'**
  String get gotItButton;

  /// Label for gravitational constant slider
  ///
  /// In en, this message translates to:
  /// **'Gravitational Constant'**
  String get gravitationalConstant;

  /// Name for green color
  ///
  /// In en, this message translates to:
  /// **'green'**
  String get greenColor;

  /// Status for planets in the habitable zone
  ///
  /// In en, this message translates to:
  /// **'Habitable'**
  String get habitabilityHabitable;

  /// Description for habitability indicators setting
  ///
  /// In en, this message translates to:
  /// **'Display color-coded status rings around planets based on their habitability'**
  String get habitabilityIndicatorsDescription;

  /// Label for habitability indicators toggle
  ///
  /// In en, this message translates to:
  /// **'Planet Status'**
  String get habitabilityIndicatorsLabel;

  /// Label for habitability features
  ///
  /// In en, this message translates to:
  /// **'Habitability'**
  String get habitabilityLabel;

  /// Status for planets too far from stars
  ///
  /// In en, this message translates to:
  /// **'Too Cold'**
  String get habitabilityTooCold;

  /// Status for planets too close to stars
  ///
  /// In en, this message translates to:
  /// **'Too Hot'**
  String get habitabilityTooHot;

  /// Status for bodies with unknown habitability
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get habitabilityUnknown;

  /// Status for gas giant planets
  ///
  /// In en, this message translates to:
  /// **'Gas Giant'**
  String get habitabilityGasGiant;

  /// Status for bodies too small to retain atmosphere
  ///
  /// In en, this message translates to:
  /// **'Too Small'**
  String get habitabilityTooSmall;

  /// Status for bodies lacking atmospheric protection
  ///
  /// In en, this message translates to:
  /// **'No Atmosphere'**
  String get habitabilityNoAtmosphere;

  /// Status for bodies with poisonous atmospheric composition
  ///
  /// In en, this message translates to:
  /// **'Toxic Atmosphere'**
  String get habitabilityToxicAtmosphere;

  /// Status for bodies exposed to dangerous radiation levels
  ///
  /// In en, this message translates to:
  /// **'High Radiation'**
  String get habitabilityHighRadiation;

  /// Status for bodies with extreme temperature gradients
  ///
  /// In en, this message translates to:
  /// **'Tidally Locked'**
  String get habitabilityTidallyLocked;

  /// Status for bodies with crushing gravitational forces
  ///
  /// In en, this message translates to:
  /// **'Extreme Gravity'**
  String get habitabilityExtremeGravity;

  /// Description for habitable zones setting
  ///
  /// In en, this message translates to:
  /// **'Show colored zones around stars indicating habitable regions'**
  String get habitableZonesDescription;

  /// Label for habitable zones toggle
  ///
  /// In en, this message translates to:
  /// **'Habitable Zones'**
  String get habitableZonesLabel;

  /// Haptics section header in simulation settings
  ///
  /// In en, this message translates to:
  /// **'Haptics'**
  String get hapticsSection;

  /// Title for toggle to hide app bar and bottom navigation in screenshot mode
  ///
  /// In en, this message translates to:
  /// **'Hide Navigation'**
  String get hideUIInScreenshotMode;

  /// Subtitle explaining hide UI in screenshot mode functionality
  ///
  /// In en, this message translates to:
  /// **'Hide app bar, bottom navigation, and copyright when screenshot mode is active'**
  String get hideUIInScreenshotModeSubtitle;

  /// Description for velocity fields
  ///
  /// In en, this message translates to:
  /// **'Initial motion vectors determining orbital paths'**
  String get initialMotionVectorsDescription;

  /// Error message for invalid JSON format
  ///
  /// In en, this message translates to:
  /// **'Invalid JSON format: {error}'**
  String invalidJsonFormat(String error);

  /// Description for invert pitch controls toggle
  ///
  /// In en, this message translates to:
  /// **'Reverse up/down drag direction'**
  String get invertPitchControlsDescription;

  /// Label for invert pitch controls toggle
  ///
  /// In en, this message translates to:
  /// **'Invert Pitch Controls'**
  String get invertPitchControlsLabel;

  /// Name for jupiter tan color
  ///
  /// In en, this message translates to:
  /// **'jupiter tan'**
  String get jupiterTanColor;

  /// Hint about available keyboard shortcuts
  ///
  /// In en, this message translates to:
  /// **'Use Space to pause/resume, R to reset, C to center camera, A to toggle auto-rotation'**
  String get keyboardShortcutsHint;

  /// Chinese language option
  ///
  /// In en, this message translates to:
  /// **'中文'**
  String get languageChinese;

  /// Description for language selection setting
  ///
  /// In en, this message translates to:
  /// **'Change the app language'**
  String get languageDescription;

  /// Hint text for language selection dropdown
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred display language'**
  String get languageSelectionHint;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// French language option
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get languageFrench;

  /// German language option
  ///
  /// In en, this message translates to:
  /// **'Deutsch'**
  String get languageGerman;

  /// Japanese language option
  ///
  /// In en, this message translates to:
  /// **'日本語'**
  String get languageJapanese;

  /// Korean language option
  ///
  /// In en, this message translates to:
  /// **'한국어'**
  String get languageKorean;

  /// Label for general settings section (including language and temperature units)
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get languageLabel;

  /// Label for temperature units setting
  ///
  /// In en, this message translates to:
  /// **'Temperature Units'**
  String get temperatureUnitsLabel;

  /// Description for temperature units setting
  ///
  /// In en, this message translates to:
  /// **'Preferred units for displaying temperatures throughout the app'**
  String get temperatureUnitsDescription;

  /// Spanish language option
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get languageSpanish;

  /// Option to use system default language
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get languageSystem;

  /// Description for stellar luminosity field
  ///
  /// In en, this message translates to:
  /// **'Light energy output - affects heating and visibility'**
  String get lightEnergyOutputDescription;

  /// Text shown while version information is loading
  ///
  /// In en, this message translates to:
  /// **'Loading version...'**
  String get loadingVersion;

  /// Label for stellar luminosity field
  ///
  /// In en, this message translates to:
  /// **'Luminosity'**
  String get luminosityEditorLabel;

  /// Hint text for luminosity input field in scenario editor
  ///
  /// In en, this message translates to:
  /// **'Luminosity (W)'**
  String get luminosityWEditorhint;

  /// Title for maintenance mode dialog
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get maintenanceTitle;

  /// Description for manual camera control mode
  ///
  /// In en, this message translates to:
  /// **'Full manual camera control'**
  String get manualControlDescription;

  /// Section title for manual camera controls
  ///
  /// In en, this message translates to:
  /// **'Manual Controls'**
  String get manualControlsTitle;

  /// Header for marketing tools section
  ///
  /// In en, this message translates to:
  /// **'Marketing'**
  String get marketingLabel;

  /// Name for mars red color
  ///
  /// In en, this message translates to:
  /// **'mars red'**
  String get marsRedColor;

  /// Validation error for invalid maxTrailPoints value
  ///
  /// In en, this message translates to:
  /// **'maxTrailPoints must be between 10 and 5000'**
  String get maxTrailPointsInvalid;

  /// Validation error message for too many bodies
  ///
  /// In en, this message translates to:
  /// **'Maximum 50 bodies allowed'**
  String get maximum50BodiesAllowed;

  /// Name for mercury gray color
  ///
  /// In en, this message translates to:
  /// **'mercury gray'**
  String get mercuryGrayColor;

  /// Validation error for missing bodies field
  ///
  /// In en, this message translates to:
  /// **'Missing required field: bodies'**
  String get missingRequiredFieldBodies;

  /// Validation error for missing configuration field
  ///
  /// In en, this message translates to:
  /// **'Missing required field: configuration'**
  String get missingRequiredFieldConfiguration;

  /// Validation error for missing metadata field
  ///
  /// In en, this message translates to:
  /// **'Missing required field: metadata'**
  String get missingRequiredFieldMetadata;

  /// Validation error for missing particleSystems field
  ///
  /// In en, this message translates to:
  /// **'Missing required field: particleSystems'**
  String get missingRequiredFieldParticleSystems;

  /// Validation error for missing physics field
  ///
  /// In en, this message translates to:
  /// **'Missing required field: physics'**
  String get missingRequiredFieldPhysics;

  /// Validation error for missing version field
  ///
  /// In en, this message translates to:
  /// **'Missing required field: version'**
  String get missingRequiredFieldVersion;

  /// Tooltip for the more options menu button
  ///
  /// In en, this message translates to:
  /// **'More options'**
  String get moreOptionsTooltip;

  /// Section title for navigation assistance features
  ///
  /// In en, this message translates to:
  /// **'Navigation Aids'**
  String get navigationAidsTitle;

  /// Name for neptune blue color
  ///
  /// In en, this message translates to:
  /// **'neptune blue'**
  String get neptuneBlueColor;

  /// Title for news notification dialog
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get newsTitle;

  /// Tooltip for next preset button
  ///
  /// In en, this message translates to:
  /// **'Next preset'**
  String get nextPreset;

  /// Tooltip for next scene navigation
  ///
  /// In en, this message translates to:
  /// **'Next Scene'**
  String get nextSceneTooltip;

  /// Accessibility message when no actions are available
  ///
  /// In en, this message translates to:
  /// **'No actions available'**
  String get noActionsAvailable;

  /// Accessibility description when simulation is empty
  ///
  /// In en, this message translates to:
  /// **'No celestial bodies currently in the simulation'**
  String get noBodiesInSimulation;

  /// Message when no changelogs are available
  ///
  /// In en, this message translates to:
  /// **'No changelogs available'**
  String get noChangelogsAvailable;

  /// No description provided for @objectives1.
  ///
  /// In en, this message translates to:
  /// **'Understand how gravity shapes the cosmos'**
  String get objectives1;

  /// No description provided for @objectives2.
  ///
  /// In en, this message translates to:
  /// **'Observe stable vs. chaotic orbital systems'**
  String get objectives2;

  /// No description provided for @objectives3.
  ///
  /// In en, this message translates to:
  /// **'Learn why planets move in elliptical orbits'**
  String get objectives3;

  /// No description provided for @objectives4.
  ///
  /// In en, this message translates to:
  /// **'Discover how binary stars interact'**
  String get objectives4;

  /// No description provided for @objectives5.
  ///
  /// In en, this message translates to:
  /// **'See what happens when objects collide'**
  String get objectives5;

  /// No description provided for @objectives6.
  ///
  /// In en, this message translates to:
  /// **'Appreciate the three-body problem\'s complexity'**
  String get objectives6;

  /// Description of learning objectives (fallback for languages without individual items)
  ///
  /// In en, this message translates to:
  /// **'• Understand how gravity shapes the cosmos\n• Observe stable vs. chaotic orbital systems\n• Learn why planets move in elliptical orbits\n• Discover how binary stars interact\n• See what happens when objects collide\n• Appreciate the three-body problem\'s complexity'**
  String get objectivesDescription;

  /// Title for learning objectives section
  ///
  /// In en, this message translates to:
  /// **'Learning Objectives'**
  String get objectivesTitle;

  /// Description for the off-screen indicators setting
  ///
  /// In en, this message translates to:
  /// **'Show arrows pointing to objects outside the visible area'**
  String get offScreenIndicatorsDescription;

  /// Title for the off-screen indicators toggle
  ///
  /// In en, this message translates to:
  /// **'Off-Screen Indicators'**
  String get offScreenIndicatorsTitle;

  /// Name for orange color
  ///
  /// In en, this message translates to:
  /// **'orange'**
  String get orangeColor;

  /// Title for particle systems section in editor
  ///
  /// In en, this message translates to:
  /// **'Particle Systems'**
  String get particleSystemsEditortitle;

  /// Section title for orbital path visualization controls
  ///
  /// In en, this message translates to:
  /// **'Path Visualization'**
  String get pathVisualizationTitle;

  /// Description for mass and radius fields
  ///
  /// In en, this message translates to:
  /// **'Physical properties that determine gravitational influence and size'**
  String get physicalPropertiesDescription;

  /// Action hint for zoom gesture
  ///
  /// In en, this message translates to:
  /// **'Pinch to zoom in/out'**
  String get pinchToZoomInOut;

  /// Label for camera pitch rotation
  ///
  /// In en, this message translates to:
  /// **'Pitch'**
  String get pitchLabel;

  /// Label for position field
  ///
  /// In en, this message translates to:
  /// **'Position'**
  String get positionEditorLabel;

  /// Description for predictive orbital camera mode
  ///
  /// In en, this message translates to:
  /// **'AI predicts optimal orbital views'**
  String get predictiveOrbitalDescription;

  /// Tooltip for previous preset button
  ///
  /// In en, this message translates to:
  /// **'Previous preset'**
  String get previousPreset;

  /// Tooltip for previous scene navigation
  ///
  /// In en, this message translates to:
  /// **'Previous Scene'**
  String get previousSceneTooltip;

  /// Label for privacy policy link
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicyLabel;

  /// Title for promotion notification dialog
  ///
  /// In en, this message translates to:
  /// **'Promotion'**
  String get promotionTitle;

  /// No description provided for @quickStart1.
  ///
  /// In en, this message translates to:
  /// **'Choose a scenario (Solar System recommended for beginners)'**
  String get quickStart1;

  /// No description provided for @quickStart2.
  ///
  /// In en, this message translates to:
  /// **'Press Play to start the simulation'**
  String get quickStart2;

  /// No description provided for @quickStart3.
  ///
  /// In en, this message translates to:
  /// **'Drag to rotate your view, pinch to zoom'**
  String get quickStart3;

  /// No description provided for @quickStart4.
  ///
  /// In en, this message translates to:
  /// **'Tap the Speed slider to control time'**
  String get quickStart4;

  /// No description provided for @quickStart5.
  ///
  /// In en, this message translates to:
  /// **'Try Reset for new random configurations'**
  String get quickStart5;

  /// No description provided for @quickStart6.
  ///
  /// In en, this message translates to:
  /// **'Enable Trails to see orbital paths'**
  String get quickStart6;

  /// Quick start instructions (fallback for languages without individual items)
  ///
  /// In en, this message translates to:
  /// **'1. Choose a scenario (Solar System recommended for beginners)\n2. Press Play to start the simulation\n3. Drag to rotate your view, pinch to zoom\n4. Tap the Speed slider to control time\n5. Try Reset for new random configurations\n6. Enable Trails to see orbital paths'**
  String get quickStartDescription;

  /// Title for quick start section
  ///
  /// In en, this message translates to:
  /// **'Quick Start Guide'**
  String get quickStartTitle;

  /// Button text to start quick tutorial
  ///
  /// In en, this message translates to:
  /// **'Quick Tutorial'**
  String get quickTutorialButton;

  /// Hint text for radius input field in scenario editor
  ///
  /// In en, this message translates to:
  /// **'Radius (m)'**
  String get radiusMEditorhint;

  /// Label for realistic colors toggle
  ///
  /// In en, this message translates to:
  /// **'Realistic Colors'**
  String get realisticColors;

  /// Description for realistic colors toggle
  ///
  /// In en, this message translates to:
  /// **'Use scientifically accurate colors based on temperature and stellar classification'**
  String get realisticColorsDescription;

  /// Name for red color
  ///
  /// In en, this message translates to:
  /// **'red'**
  String get redColor;

  /// Label for camera roll rotation
  ///
  /// In en, this message translates to:
  /// **'Roll'**
  String get rollLabel;

  /// Name for saturn cream color
  ///
  /// In en, this message translates to:
  /// **'saturn cream'**
  String get saturnCreamColor;

  /// Name of the asteroid belt scenario
  ///
  /// In en, this message translates to:
  /// **'Asteroid Belt'**
  String get scenarioAsteroidBelt;

  /// Description of the asteroid belt scenario
  ///
  /// In en, this message translates to:
  /// **'Central star surrounded by a belt of rocky asteroids and debris'**
  String get scenarioAsteroidBeltDescription;

  /// Best for content for binary star scenario
  ///
  /// In en, this message translates to:
  /// **'Best for: Advanced physics exploration'**
  String get scenarioBestBinary;

  /// Best for content for Earth-Moon scenario
  ///
  /// In en, this message translates to:
  /// **'Best for: Understanding Earth-Moon system'**
  String get scenarioBestEarthMoon;

  /// Emoji for best for section
  ///
  /// In en, this message translates to:
  /// **'⭐'**
  String get scenarioBestEmoji;

  /// Best for content for random scenario
  ///
  /// In en, this message translates to:
  /// **'Best for: Exploration and experimentation'**
  String get scenarioBestRandom;

  /// Best for content for solar system scenario
  ///
  /// In en, this message translates to:
  /// **'Best for: Beginners, astronomy enthusiasts'**
  String get scenarioBestSolar;

  /// Best for content for three-body scenario
  ///
  /// In en, this message translates to:
  /// **'Best for: Mathematical physics enthusiasts'**
  String get scenarioBestThreeBody;

  /// Name of the binary stars scenario
  ///
  /// In en, this message translates to:
  /// **'Binary Stars'**
  String get scenarioBinaryStars;

  /// Description of the binary stars scenario
  ///
  /// In en, this message translates to:
  /// **'Two massive stars orbiting each other with circumbinary planets'**
  String get scenarioBinaryStarsDescription;

  /// Name for custom user-created scenarios
  ///
  /// In en, this message translates to:
  /// **'Custom Scenario'**
  String get scenarioCustom;

  /// Description for custom user-created scenarios
  ///
  /// In en, this message translates to:
  /// **'User-created custom gravitational scenario with personalized celestial bodies'**
  String get scenarioCustomDescription;

  /// Name of the Earth-Moon-Sun scenario
  ///
  /// In en, this message translates to:
  /// **'Earth-Moon-Sun'**
  String get scenarioEarthMoonSun;

  /// Description of the Earth-Moon-Sun scenario
  ///
  /// In en, this message translates to:
  /// **'Educational simulation of our familiar Earth-Moon-Sun system'**
  String get scenarioEarthMoonSunDescription;

  /// Name of the galaxy formation scenario
  ///
  /// In en, this message translates to:
  /// **'Galaxy Formation'**
  String get scenarioGalaxyFormation;

  /// Description of the galaxy formation scenario
  ///
  /// In en, this message translates to:
  /// **'Watch matter organize into spiral structures around a central black hole'**
  String get scenarioGalaxyFormationDescription;

  /// Title for scenario information section in editor
  ///
  /// In en, this message translates to:
  /// **'Scenario Information'**
  String get scenarioInformationEditortitle;

  /// Learning content for binary star scenario
  ///
  /// In en, this message translates to:
  /// **'Learn: Stellar evolution, binary systems, extreme gravity'**
  String get scenarioLearnBinary;

  /// Learning content for Earth-Moon scenario
  ///
  /// In en, this message translates to:
  /// **'Learn: Three-body dynamics, lunar mechanics, tidal forces'**
  String get scenarioLearnEarthMoon;

  /// Emoji for learning objectives
  ///
  /// In en, this message translates to:
  /// **'🎯'**
  String get scenarioLearnEmoji;

  /// Learning content for random scenario
  ///
  /// In en, this message translates to:
  /// **'Learn: Discover unknown configurations, experimental physics'**
  String get scenarioLearnRandom;

  /// Learning content for solar system scenario
  ///
  /// In en, this message translates to:
  /// **'Learn: Planetary motion, orbital mechanics, familiar celestial bodies'**
  String get scenarioLearnSolar;

  /// Learning content for three-body scenario
  ///
  /// In en, this message translates to:
  /// **'Learn: Chaos theory, unpredictable motion, unstable systems'**
  String get scenarioLearnThreeBody;

  /// Validation error for empty scenario name
  ///
  /// In en, this message translates to:
  /// **'Scenario name is required and cannot be empty'**
  String get scenarioNameRequired;

  /// Validation error for scenario name too long
  ///
  /// In en, this message translates to:
  /// **'Scenario name must be 100 characters or less'**
  String get scenarioNameTooLong;

  /// Name of the planetary rings scenario
  ///
  /// In en, this message translates to:
  /// **'Planetary Rings'**
  String get scenarioPlanetaryRings;

  /// Description of the planetary rings scenario
  ///
  /// In en, this message translates to:
  /// **'Ring system dynamics around a massive planet like Saturn'**
  String get scenarioPlanetaryRingsDescription;

  /// Name of the random scenario
  ///
  /// In en, this message translates to:
  /// **'Random System'**
  String get scenarioRandom;

  /// Description of the random scenario
  ///
  /// In en, this message translates to:
  /// **'Randomly generated chaotic three-body system with unpredictable dynamics'**
  String get scenarioRandomDescription;

  /// Error message when scenario save fails
  ///
  /// In en, this message translates to:
  /// **'Failed to save scenario: {error}'**
  String scenarioSaveFailedMessage(String error);

  /// Success message when scenario is saved
  ///
  /// In en, this message translates to:
  /// **'Scenario saved successfully'**
  String get scenarioSavedSuccessMessage;

  /// Accessibility description when scenario selector has focus
  ///
  /// In en, this message translates to:
  /// **'Scenario selector focused - choose different simulations'**
  String get scenarioSelectorFocused;

  /// Name of the solar system scenario
  ///
  /// In en, this message translates to:
  /// **'Solar System'**
  String get scenarioSolarSystem;

  /// Description of the solar system scenario
  ///
  /// In en, this message translates to:
  /// **'Simplified version of our solar system with inner and outer planets'**
  String get scenarioSolarSystemDescription;

  /// Name for special/internal scenarios not available in main selection
  ///
  /// In en, this message translates to:
  /// **'Special Scenario'**
  String get scenarioSpecial;

  /// Description for special/internal scenarios used for screenshots
  ///
  /// In en, this message translates to:
  /// **'Special scenario for screenshot mode'**
  String get scenarioSpecialDescription;

  /// Text indicating number of scenarios available
  ///
  /// In en, this message translates to:
  /// **'scenarios available'**
  String get scenariosAvailable;

  /// Description for the scenarios menu item
  ///
  /// In en, this message translates to:
  /// **'Explore different scenarios'**
  String get scenariosMenuDescription;

  /// Message shown when a screenshot scene is active
  ///
  /// In en, this message translates to:
  /// **'Scene active - simulation paused for screenshot capture'**
  String get sceneActive;

  /// Label for scene preset selection
  ///
  /// In en, this message translates to:
  /// **'Scene Preset'**
  String get scenePreset;

  /// User message shown during scheduled maintenance
  ///
  /// In en, this message translates to:
  /// **'Scheduled maintenance in progress'**
  String get scheduledMaintenanceInProgress;

  /// Countdown message shown before taking a screenshot
  ///
  /// In en, this message translates to:
  /// **'Screenshot in {seconds}s'**
  String screenshotCountdown(int seconds);

  /// Title for screenshot mode toggle
  ///
  /// In en, this message translates to:
  /// **'Screenshot Mode'**
  String get screenshotMode;

  /// Subtitle explaining screenshot mode functionality
  ///
  /// In en, this message translates to:
  /// **'Enable preset scenes for capturing marketing screenshots'**
  String get screenshotModeSubtitle;

  /// Accessibility label for color picker
  ///
  /// In en, this message translates to:
  /// **'Select a color for the celestial body'**
  String get selectAColorForTheCelestialBody;

  /// Button text for selecting nearest celestial body
  ///
  /// In en, this message translates to:
  /// **'Select Nearest'**
  String get selectNearestTitle;

  /// Tooltip for the follow object button when no object is selected
  ///
  /// In en, this message translates to:
  /// **'Select Object to Follow'**
  String get selectObjectToFollowTooltip;

  /// Tooltip for the scenario selection button in the app bar
  ///
  /// In en, this message translates to:
  /// **'Select Scenario'**
  String get selectScenarioTooltip;

  /// Hint text for body type picker
  ///
  /// In en, this message translates to:
  /// **'Select the type of celestial body'**
  String get selectTheTypeOfCelestialBody;

  /// Statistics label for currently selected body
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get selectedStatLabel;

  /// Tooltip for help button
  ///
  /// In en, this message translates to:
  /// **'Help & Objectives'**
  String get showHelpTooltip;

  /// Description for the body labels setting
  ///
  /// In en, this message translates to:
  /// **'Show celestial body names in the simulation'**
  String get showLabelsDescription;

  /// Toggle title for showing body labels
  ///
  /// In en, this message translates to:
  /// **'Show Labels'**
  String get showLabelsTitle;

  /// Title for the orbital paths toggle
  ///
  /// In en, this message translates to:
  /// **'Show Orbital Paths'**
  String get showOrbitalPaths;

  /// Description for show orbital paths setting
  ///
  /// In en, this message translates to:
  /// **'Display predicted orbital paths in scenarios with stable orbits'**
  String get showOrbitalPathsDescription;

  /// Description for statistics display toggle
  ///
  /// In en, this message translates to:
  /// **'Display performance and physics stats'**
  String get showStatisticsDescription;

  /// Toggle title for showing statistics
  ///
  /// In en, this message translates to:
  /// **'Show Statistics'**
  String get showStatisticsTitle;

  /// Label for the show trails switch
  ///
  /// In en, this message translates to:
  /// **'Show Trails'**
  String get showTrails;

  /// Description for show trails setting
  ///
  /// In en, this message translates to:
  /// **'Display motion trails behind objects'**
  String get showTrailsDescription;

  /// Tooltip for tutorial button
  ///
  /// In en, this message translates to:
  /// **'Show Tutorial'**
  String get showTutorialTooltip;

  /// Button to skip tutorial
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skipTutorial;

  /// Label for softening parameter slider
  ///
  /// In en, this message translates to:
  /// **'Softening Parameter'**
  String get softeningParameter;

  /// Description for position coordinates
  ///
  /// In en, this message translates to:
  /// **'Spatial coordinates in 3D space (X, Y, Z axes)'**
  String get spatialCoordinatesDescription;

  /// Status when simulation has an error
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get statusError;

  /// Label for simulation status
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusLabel;

  /// Status when simulation is paused
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get statusPaused;

  /// Status when simulation is running
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get statusRunning;

  /// Status when simulation is stopped
  ///
  /// In en, this message translates to:
  /// **'Stopped'**
  String get statusStopped;

  /// Color description for very hot stars (O-type)
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get stellarColorBlue;

  /// Color description for hot stars (B-type)
  ///
  /// In en, this message translates to:
  /// **'Blue-white'**
  String get stellarColorBlueWhite;

  /// Color description for orange stars (K-type)
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get stellarColorOrange;

  /// Color description for cool red stars (M-type)
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get stellarColorRed;

  /// Color description for white stars (A-type)
  ///
  /// In en, this message translates to:
  /// **'White'**
  String get stellarColorWhite;

  /// Color description for yellow stars (G-type, like our Sun)
  ///
  /// In en, this message translates to:
  /// **'Yellow'**
  String get stellarColorYellow;

  /// Color description for yellow-white stars (F-type)
  ///
  /// In en, this message translates to:
  /// **'Yellow-white'**
  String get stellarColorYellowWhite;

  /// Description for stellar temperature field
  ///
  /// In en, this message translates to:
  /// **'Stellar temperature affecting light and heat emission'**
  String get stellarTemperatureDescription;

  /// Number of simulation steps
  ///
  /// In en, this message translates to:
  /// **'{count}'**
  String stepsCount(int count);

  /// Label for simulation steps count
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get stepsLabel;

  /// Title for success notification dialog
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get successTitle;

  /// Action hint for expanding bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Swipe up to expand'**
  String get swipeUpToExpand;

  /// Action hint for play/pause control
  ///
  /// In en, this message translates to:
  /// **'Tap play/pause button'**
  String get tapPlayPauseButton;

  /// Action hint for reset control
  ///
  /// In en, this message translates to:
  /// **'Tap reset button'**
  String get tapResetButton;

  /// Action hint for camera centering
  ///
  /// In en, this message translates to:
  /// **'Tap to center camera'**
  String get tapToCenterCamera;

  /// Accessibility hint for scenario selection
  ///
  /// In en, this message translates to:
  /// **'Tap to change scenario'**
  String get tapToChangeScenario;

  /// Action hint for simulation canvas interaction
  ///
  /// In en, this message translates to:
  /// **'Tap to interact with simulation'**
  String get tapToInteractWithSimulation;

  /// Accessibility hint for settings button
  ///
  /// In en, this message translates to:
  /// **'Tap to open settings'**
  String get tapToOpenSettings;

  /// Accessibility hint for selectable items
  ///
  /// In en, this message translates to:
  /// **'Tap to select'**
  String get tapToSelect;

  /// Action hint for auto-rotation toggle
  ///
  /// In en, this message translates to:
  /// **'Tap to toggle auto-rotation'**
  String get tapToToggleAutoRotation;

  /// Hint text for fullscreen toggle gesture
  ///
  /// In en, this message translates to:
  /// **'Tap to toggle fullscreen'**
  String get tapToToggleFullscreen;

  /// Accessibility hint for body tile in scenario editor
  ///
  /// In en, this message translates to:
  /// **'Tap to view and edit details. {bodyType} with {mass}.'**
  String
  tapToViewAndEditDetailsBodyBodyTypeNameWithNumberUtilsFormatMassBodyMassEditorhint(
    String bodyType,
    String mass,
  );

  /// Display name for essential tracking mode
  ///
  /// In en, this message translates to:
  /// **'Essential Only'**
  String get trackingModeEssential;

  /// Description for essential tracking mode
  ///
  /// In en, this message translates to:
  /// **'Critical crashes and errors only'**
  String get trackingModeEssentialDescription;

  /// Display name for full tracking mode
  ///
  /// In en, this message translates to:
  /// **'Full Tracking'**
  String get trackingModeFull;

  /// Description for full tracking mode
  ///
  /// In en, this message translates to:
  /// **'All analytics, crashes, and interactions'**
  String get trackingModeFullDescription;

  /// Display name for limited tracking mode
  ///
  /// In en, this message translates to:
  /// **'Limited Tracking'**
  String get trackingModeLimited;

  /// Description for limited tracking mode
  ///
  /// In en, this message translates to:
  /// **'User interactions only'**
  String get trackingModeLimitedDescription;

  /// Display name for no tracking mode
  ///
  /// In en, this message translates to:
  /// **'No Tracking'**
  String get trackingModeNone;

  /// Description for no tracking mode
  ///
  /// In en, this message translates to:
  /// **'No data collection'**
  String get trackingModeNoneDescription;

  /// Label for trail color selection
  ///
  /// In en, this message translates to:
  /// **'Trail Color'**
  String get trailColorLabel;

  /// Label for trail fade rate slider
  ///
  /// In en, this message translates to:
  /// **'Trail Fade Rate'**
  String get trailFadeRate;

  /// Label for trail length slider
  ///
  /// In en, this message translates to:
  /// **'Trail Length'**
  String get trailLength;

  /// Label for body type field
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get typeEditorLabel;

  /// Label for UI haptic feedback toggle
  ///
  /// In en, this message translates to:
  /// **'UI Haptic Feedback'**
  String get uiHapticFeedback;

  /// Dialog message for unsaved changes warning
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes. Are you sure you want to leave?'**
  String get unsavedChangesMessage;

  /// Dialog title for unsaved changes warning
  ///
  /// In en, this message translates to:
  /// **'Unsaved Changes'**
  String get unsavedChangesTitle;

  /// Name for uranus cyan color
  ///
  /// In en, this message translates to:
  /// **'uranus cyan'**
  String get uranusCyanColor;

  /// Action hint for keyboard shortcuts
  ///
  /// In en, this message translates to:
  /// **'Use keyboard shortcuts for controls'**
  String get useKeyboardShortcutsForControls;

  /// Action hint for zoom controls
  ///
  /// In en, this message translates to:
  /// **'Use zoom controls'**
  String get useZoomControls;

  /// Name for venus yellow color
  ///
  /// In en, this message translates to:
  /// **'venus yellow'**
  String get venusYellowColor;

  /// Label for version information
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get versionLabel;

  /// Badge text for current app version
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get versionStatusCurrent;

  /// Badge text for outdated app version
  ///
  /// In en, this message translates to:
  /// **'Out-of-Date'**
  String get versionStatusOutdated;

  /// Legacy label for vibration enabled toggle
  ///
  /// In en, this message translates to:
  /// **'Vibration Enabled'**
  String get vibrationEnabled;

  /// Label for vibration throttle slider
  ///
  /// In en, this message translates to:
  /// **'Vibration Throttle'**
  String get vibrationThrottle;

  /// Option for warm-colored trails
  ///
  /// In en, this message translates to:
  /// **'🔥 Warm'**
  String get warmTrails;

  /// Label for website information
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get websiteLabel;

  /// Description of what users can do
  ///
  /// In en, this message translates to:
  /// **'Graviton is a physics playground where you can:\n\n🪐 Explore realistic orbital mechanics\n🌟 Watch stellar evolution and collisions\n🎯 Learn about gravitational forces\n🎮 Experiment with different scenarios\n📚 Understand celestial dynamics\n🔄 Create endless random configurations'**
  String get whatToDoDescription;

  /// Title for what to do section
  ///
  /// In en, this message translates to:
  /// **'What to Do in Graviton'**
  String get whatToDoTitle;

  /// Name for white color
  ///
  /// In en, this message translates to:
  /// **'white'**
  String get whiteColor;

  /// Hint text for X coordinate input field in scenario editor
  ///
  /// In en, this message translates to:
  /// **'X coordinate'**
  String get xCoordinateEditorhint;

  /// X coordinate label
  ///
  /// In en, this message translates to:
  /// **'X'**
  String get xCoordinateLabel;

  /// Hint text for X velocity input field in scenario editor
  ///
  /// In en, this message translates to:
  /// **'X velocity'**
  String get xVelocityEditorhint;

  /// Hint text for Y coordinate input field in scenario editor
  ///
  /// In en, this message translates to:
  /// **'Y coordinate'**
  String get yCoordinateEditorhint;

  /// Y coordinate label
  ///
  /// In en, this message translates to:
  /// **'Y'**
  String get yCoordinateLabel;

  /// Hint text for Y velocity input field in scenario editor
  ///
  /// In en, this message translates to:
  /// **'Y velocity'**
  String get yVelocityEditorhint;

  /// Label for camera yaw rotation
  ///
  /// In en, this message translates to:
  /// **'Yaw'**
  String get yawLabel;

  /// Name for yellow color
  ///
  /// In en, this message translates to:
  /// **'yellow'**
  String get yellowColor;

  /// Hint text for Z coordinate input field in scenario editor
  ///
  /// In en, this message translates to:
  /// **'Z coordinate'**
  String get zCoordinateEditorhint;

  /// Z coordinate label
  ///
  /// In en, this message translates to:
  /// **'Z'**
  String get zCoordinateLabel;

  /// Hint text for Z velocity input field in scenario editor
  ///
  /// In en, this message translates to:
  /// **'Z velocity'**
  String get zVelocityEditorhint;

  /// Description for orbital close approach event
  ///
  /// In en, this message translates to:
  /// **'Close approach: {distance} units'**
  String orbitalEventCloseApproach(String distance);

  /// Accessibility announcement when bodies combine
  ///
  /// In en, this message translates to:
  /// **'The combined mass creates a new celestial body'**
  String get accessibilityBodiesCombined;

  /// Accessibility announcement when bodies start moving
  ///
  /// In en, this message translates to:
  /// **'Celestial bodies are now in motion'**
  String get accessibilityBodiesInMotion;

  /// Accessibility announcement when bodies stop
  ///
  /// In en, this message translates to:
  /// **'All celestial bodies have stopped moving'**
  String get accessibilityBodiesStopped;

  /// Accessibility announcement when bodies resume motion
  ///
  /// In en, this message translates to:
  /// **'Celestial bodies are moving again'**
  String get accessibilityBodiesResumed;

  /// Accessibility announcement when bodies are reset
  ///
  /// In en, this message translates to:
  /// **'All celestial bodies have been reset'**
  String get accessibilityBodiesReset;

  /// Accessibility announcement when new scenario loads
  ///
  /// In en, this message translates to:
  /// **'New scenario loaded with fresh celestial bodies'**
  String get accessibilityNewScenarioLoaded;

  /// Accessibility announcement when scenario parameters change
  ///
  /// In en, this message translates to:
  /// **'New celestial bodies and physics parameters loaded'**
  String get accessibilityNewParametersLoaded;

  /// Label for scenario presets tab
  ///
  /// In en, this message translates to:
  /// **'Presets'**
  String get scenarioTabPresets;

  /// Label for custom scenario tab
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get scenarioTabCustom;

  /// Section title for user's saved custom scenarios
  ///
  /// In en, this message translates to:
  /// **'Saved Scenarios'**
  String get savedScenariosTitle;

  /// Section title for experimental physics scenarios
  ///
  /// In en, this message translates to:
  /// **'Experiments'**
  String get experimentsTitle;

  /// Subtitle explaining the purpose of experimental scenarios
  ///
  /// In en, this message translates to:
  /// **'Explore interesting physics concepts'**
  String get experimentsSubtitle;

  /// Formatted body count for custom scenarios
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 bodies} =1{1 body} other{{count} bodies}}'**
  String customScenarioBodyCount(int count);

  /// Text shown when custom scenario was created today
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get customScenarioCreatedToday;

  /// Text shown when custom scenario was created yesterday
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get customScenarioCreatedYesterday;

  /// Text shown when custom scenario was created days ago
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day ago} other{{count} days ago}}'**
  String customScenarioCreatedDaysAgo(int count, Object days);

  /// Text shown when custom scenario was created weeks ago
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 week ago} other{{count} weeks ago}}'**
  String customScenarioCreatedWeeksAgo(int count, Object weeks);

  /// Text shown when custom scenario was created months ago
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 month ago} other{{count} months ago}}'**
  String customScenarioCreatedMonthsAgo(int count, Object months);

  /// Text shown when custom scenario creation date is unknown
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get customScenarioCreatedUnknown;

  /// Section title for orbital placement controls
  ///
  /// In en, this message translates to:
  /// **'Orbital Placement'**
  String get orbitalPlacementEditor;

  /// Button text to place body in orbit around another body
  ///
  /// In en, this message translates to:
  /// **'Place in Orbit'**
  String get placeInOrbitButton;

  /// Label for central body selection dropdown
  ///
  /// In en, this message translates to:
  /// **'Central Body'**
  String get centralBodySelector;

  /// Label for orbit radius slider
  ///
  /// In en, this message translates to:
  /// **'Orbit Radius'**
  String get orbitRadiusEditor;

  /// Label for orbit phase (starting position) slider
  ///
  /// In en, this message translates to:
  /// **'Orbit Phase'**
  String get orbitPhaseEditor;

  /// Label for orbit inclination angle slider
  ///
  /// In en, this message translates to:
  /// **'Inclination'**
  String get orbitInclinationEditor;

  /// Option for circular orbit type
  ///
  /// In en, this message translates to:
  /// **'Circular Orbit'**
  String get circularOrbitOption;

  /// Option for elliptical orbit type
  ///
  /// In en, this message translates to:
  /// **'Elliptical Orbit'**
  String get ellipticalOrbitOption;

  /// Display text for calculated orbital period
  ///
  /// In en, this message translates to:
  /// **'Period: {period}'**
  String orbitalPeriodDisplay(String period);

  /// Message when no central bodies are available for orbit
  ///
  /// In en, this message translates to:
  /// **'No other bodies available for orbital placement'**
  String get noAvailableCentralBodies;

  /// Description text for orbital placement feature
  ///
  /// In en, this message translates to:
  /// **'Configure this body to orbit around another celestial body with realistic physics'**
  String get orbitalPlacementDescription;

  /// Description text shown when orbital placement is active, explaining that position and velocity are auto-calculated
  ///
  /// In en, this message translates to:
  /// **'Orbital placement is active. Position and velocity will be calculated automatically based on the orbit parameters below.'**
  String get orbitalPlacementActiveDescription;

  /// Toggle description for showing gravitational field visualization for a specific body
  ///
  /// In en, this message translates to:
  /// **'Show gravitational field visualization for this body'**
  String get showGravitationalFieldVisualization;

  /// Button text to cancel orbital placement mode
  ///
  /// In en, this message translates to:
  /// **'Cancel Orbital Placement'**
  String get cancelOrbitalPlacement;

  /// Button text to make orbital configuration stable
  ///
  /// In en, this message translates to:
  /// **'Make Stable'**
  String get makeStable;

  /// Warning message for massive orbiting body relative to central body
  ///
  /// In en, this message translates to:
  /// **'⚠️ Warning: Orbiting body is very massive relative to central body. This may cause unstable orbits or the bodies may orbit each other.'**
  String get orbitalWarningMassiveBody;

  /// Tip message for significant mass ratio between bodies
  ///
  /// In en, this message translates to:
  /// **'💡 Tip: This is a significant mass ratio. Consider increasing orbital distance for stability.'**
  String get orbitalTipSignificantMass;

  /// Warning message for very close orbital distance
  ///
  /// In en, this message translates to:
  /// **'⚠️ Warning: Very close orbit. Risk of collision or tidal disruption.'**
  String get orbitalWarningCloseOrbit;

  /// Tip message for distant orbital configuration
  ///
  /// In en, this message translates to:
  /// **'💡 Tip: Distant orbit. Gravitational influence from other bodies may perturb this orbit.'**
  String get orbitalTipDistantOrbit;

  /// Message for good orbital configuration
  ///
  /// In en, this message translates to:
  /// **'✅ Good orbital configuration for a stable system.'**
  String get orbitalGoodConfiguration;

  /// Generic error message for orbital calculations
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get orbitalError;

  /// Warning text for unstable orbital configurations
  ///
  /// In en, this message translates to:
  /// **'This orbital configuration may lead to collisions or ejections. Consider using the \"Make Stable\" button.'**
  String get orbitalConfigurationWarning;

  /// Default name for new celestial bodies
  ///
  /// In en, this message translates to:
  /// **'Celestial Body'**
  String get defaultBodyName;

  /// Label for orbital period display
  ///
  /// In en, this message translates to:
  /// **'Orbital Period'**
  String get orbitalPeriodLabel;

  /// Message indicating the orbit is stable
  ///
  /// In en, this message translates to:
  /// **'Orbit is Stable'**
  String get orbitIsStable;

  /// Message indicating the orbit may be unstable
  ///
  /// In en, this message translates to:
  /// **'Orbit May Be Unstable'**
  String get orbitMayBeUnstable;

  /// Generic format for body type description
  ///
  /// In en, this message translates to:
  /// **'{bodyType} body'**
  String bodyTypeGeneric(String bodyType);

  /// Feedback message when orbital radius is increased
  ///
  /// In en, this message translates to:
  /// **'increased by {amount} units'**
  String orbitalRadiusIncreasedFeedback(String amount);

  /// Feedback message when orbital radius is decreased
  ///
  /// In en, this message translates to:
  /// **'decreased by {amount} units'**
  String orbitalRadiusDecreasedFeedback(String amount);

  /// Feedback message when orbital radius is slightly adjusted
  ///
  /// In en, this message translates to:
  /// **'fine-tuned'**
  String get orbitalRadiusFineTunedFeedback;

  /// Success message when orbit is stabilized
  ///
  /// In en, this message translates to:
  /// **'Orbit stabilized! Radius {changeDescription} to {finalRadius} units. Phase and inclination reset for stability.'**
  String orbitStabilizedMessage(String changeDescription, String finalRadius);

  /// Name for binary pulsar experimental scenario
  ///
  /// In en, this message translates to:
  /// **'Binary Pulsar'**
  String get experimentBinaryPulsarName;

  /// Description for binary pulsar experimental scenario
  ///
  /// In en, this message translates to:
  /// **'Two neutron stars spiraling inward due to gravitational waves'**
  String get experimentBinaryPulsarDescription;

  /// Expected duration for binary pulsar experiment
  ///
  /// In en, this message translates to:
  /// **'100 years'**
  String get experimentBinaryPulsarDuration;

  /// Name for primary pulsar in binary pulsar scenario
  ///
  /// In en, this message translates to:
  /// **'Pulsar A'**
  String get binaryPulsarPulsarA;

  /// Name for companion neutron star in binary pulsar scenario
  ///
  /// In en, this message translates to:
  /// **'Neutron Star B'**
  String get binaryPulsarNeutronStarB;

  /// Detailed description for binary pulsar scenario physics
  ///
  /// In en, this message translates to:
  /// **'This scenario demonstrates: extreme gravitational fields, relativistic effects, gravitational wave emission, and orbital decay. The neutron stars will slowly spiral inward over time, eventually merging in a catastrophic collision that produces gravitational waves.'**
  String get binaryPulsarScenarioDescription;

  /// Author attribution for physics experiments
  ///
  /// In en, this message translates to:
  /// **'Graviton Physics Experiments'**
  String get binaryPulsarAuthor;

  /// Educational focus for binary pulsar experiment
  ///
  /// In en, this message translates to:
  /// **'Relativity and Gravitational Waves'**
  String get binaryPulsarEducationalFocus;

  /// Name for trojan asteroids experimental scenario
  ///
  /// In en, this message translates to:
  /// **'Trojan Asteroids'**
  String get experimentTrojanAsteroidsName;

  /// Description for trojan asteroids experimental scenario
  ///
  /// In en, this message translates to:
  /// **'Stable points in Jupiter\'s orbit where asteroids accumulate'**
  String get experimentTrojanAsteroidsDescription;

  /// Expected duration for trojan asteroids experiment
  ///
  /// In en, this message translates to:
  /// **'50 years'**
  String get experimentTrojanAsteroidsDuration;

  /// Name for Sun in trojan asteroids scenario
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get trojanAsteroidsSun;

  /// Name for Jupiter in trojan asteroids scenario
  ///
  /// In en, this message translates to:
  /// **'Jupiter'**
  String get trojanAsteroidsJupiter;

  /// Name pattern for L4 trojan asteroids
  ///
  /// In en, this message translates to:
  /// **'L4 Trojan {number}'**
  String trojanAsteroidsL4Name(int number);

  /// Name pattern for L5 trojan asteroids
  ///
  /// In en, this message translates to:
  /// **'L5 Trojan {number}'**
  String trojanAsteroidsL5Name(int number);

  /// Detailed description for trojan asteroids scenario physics
  ///
  /// In en, this message translates to:
  /// **'This scenario demonstrates: Lagrange points, stable orbital mechanics, three-body dynamics, and gravitational equilibrium. The Trojan asteroids remain in stable positions 60° ahead and behind Jupiter, trapped in gravitational balance.'**
  String get trojanAsteroidsScenarioDescription;

  /// Educational focus for trojan asteroids experiment
  ///
  /// In en, this message translates to:
  /// **'Lagrange Points and Orbital Stability'**
  String get trojanAsteroidsEducationalFocus;

  /// Name for double star eclipse experimental scenario
  ///
  /// In en, this message translates to:
  /// **'Double Star Eclipse'**
  String get experimentDoubleStarEclipseName;

  /// Description for double star eclipse experimental scenario
  ///
  /// In en, this message translates to:
  /// **'Binary star system where one star regularly eclipses the other'**
  String get experimentDoubleStarEclipseDescription;

  /// Expected duration for double star eclipse experiment
  ///
  /// In en, this message translates to:
  /// **'30 days'**
  String get experimentDoubleStarEclipseDuration;

  /// Name for rogue planet experimental scenario
  ///
  /// In en, this message translates to:
  /// **'Rogue Planet'**
  String get experimentRoguePlanetName;

  /// Description for rogue planet experimental scenario
  ///
  /// In en, this message translates to:
  /// **'A planet ejected from its system encounters a new solar system'**
  String get experimentRoguePlanetDescription;

  /// Expected duration for rogue planet experiment
  ///
  /// In en, this message translates to:
  /// **'500 years'**
  String get experimentRoguePlanetDuration;

  /// Name for gravitational slingshot experimental scenario
  ///
  /// In en, this message translates to:
  /// **'Gravitational Slingshot'**
  String get experimentGravitationalSlingshotName;

  /// Description for gravitational slingshot experimental scenario
  ///
  /// In en, this message translates to:
  /// **'A spacecraft uses Jupiter\'s moon Io to gain speed and reach Europa'**
  String get experimentGravitationalSlingshotDescription;

  /// Expected duration for gravitational slingshot experiment
  ///
  /// In en, this message translates to:
  /// **'2 years'**
  String get experimentGravitationalSlingshotDuration;

  /// Advanced difficulty level for experimental scenarios
  ///
  /// In en, this message translates to:
  /// **'advanced'**
  String get experimentDifficultyAdvanced;

  /// Intermediate difficulty level for experimental scenarios
  ///
  /// In en, this message translates to:
  /// **'intermediate'**
  String get experimentDifficultyIntermediate;

  /// Beginner difficulty level for experimental scenarios
  ///
  /// In en, this message translates to:
  /// **'beginner'**
  String get experimentDifficultyBeginner;

  /// Message shown when selecting an experimental scenario that's not yet implemented
  ///
  /// In en, this message translates to:
  /// **'Experimental scenario \"{scenarioName}\" - Coming soon!'**
  String experimentComingSoon(String scenarioName);

  /// Text shown for unknown or invalid values
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknownValue;

  /// Name for primary star in double star eclipse scenario
  ///
  /// In en, this message translates to:
  /// **'Primary Star'**
  String get bodyPrimaryStar;

  /// Name for secondary star in double star eclipse scenario
  ///
  /// In en, this message translates to:
  /// **'Secondary Star'**
  String get bodySecondaryStar;

  /// Name for inner rocky planet in rogue planet scenario
  ///
  /// In en, this message translates to:
  /// **'Inner Rocky Planet'**
  String get bodyInnerRockyPlanet;

  /// Name for habitable planet in rogue planet scenario
  ///
  /// In en, this message translates to:
  /// **'Habitable Planet'**
  String get bodyHabitablePlanet;

  /// Name for gas giant planet in rogue planet scenario
  ///
  /// In en, this message translates to:
  /// **'Gas Giant'**
  String get bodyGasGiant;

  /// Name for ice giant planet in rogue planet scenario
  ///
  /// In en, this message translates to:
  /// **'Ice Giant'**
  String get bodyIceGiant;

  /// Name for rogue planet in rogue planet scenario
  ///
  /// In en, this message translates to:
  /// **'Rogue Planet'**
  String get bodyRoguePlanet;

  /// Author name for experimental physics scenarios
  ///
  /// In en, this message translates to:
  /// **'Graviton Physics Team'**
  String get authorGravitonPhysicsTeam;

  /// Detailed description for double star eclipse scenario
  ///
  /// In en, this message translates to:
  /// **'Watch as two stars orbit each other in a close binary system. Observe how the smaller secondary star regularly passes in front of the larger primary star, causing periodic eclipses. This demonstrates stellar photometry, binary orbital mechanics, and how astronomers discover exoplanets using similar transit methods.'**
  String get doubleStarEclipseScenarioDescription;

  /// Educational focus for double star eclipse scenario
  ///
  /// In en, this message translates to:
  /// **'Binary stars, eclipses, stellar photometry'**
  String get doubleStarEclipseEducationalFocus;

  /// Detailed description for rogue planet scenario
  ///
  /// In en, this message translates to:
  /// **'A stable solar system with well-spaced planetary orbits encounters a massive rogue planet approaching from interstellar space. Watch as the intruder\'s gravity disrupts the delicate orbital balance, potentially ejecting planets or creating chaotic gravitational interactions. This scenario demonstrates planetary system dynamics, gravitational slingshot effects, and how rogue planets can reshape entire solar systems.'**
  String get roguePlanetScenarioDescription;

  /// Educational focus for rogue planet scenario
  ///
  /// In en, this message translates to:
  /// **'Rogue planets, gravitational encounters, orbital disruption'**
  String get roguePlanetEducationalFocus;

  /// Title for the simulation information screen
  ///
  /// In en, this message translates to:
  /// **'Simulation Info'**
  String get simulationInfoTitle;

  /// Title for the scenario information section
  ///
  /// In en, this message translates to:
  /// **'Scenario Information'**
  String get scenarioInfoTitle;

  /// Label for scenario name field
  ///
  /// In en, this message translates to:
  /// **'Scenario'**
  String get scenarioNameLabel;

  /// Title for the body statistics section
  ///
  /// In en, this message translates to:
  /// **'Body Statistics'**
  String get bodyStatisticsTitle;

  /// Label for total number of bodies
  ///
  /// In en, this message translates to:
  /// **'Total Bodies'**
  String get totalBodiesLabel;

  /// Label for number of stars
  ///
  /// In en, this message translates to:
  /// **'Stars'**
  String get starsLabel;

  /// Label for number of planets
  ///
  /// In en, this message translates to:
  /// **'Planets'**
  String get planetsLabel;

  /// Label for number of asteroids and moons
  ///
  /// In en, this message translates to:
  /// **'Asteroids & Moons'**
  String get asteroidsLabel;

  /// Label for number of black holes
  ///
  /// In en, this message translates to:
  /// **'Black Holes'**
  String get blackHolesLabel;

  /// Label for total mass of all bodies
  ///
  /// In en, this message translates to:
  /// **'Total Mass'**
  String get totalMassLabel;

  /// Label for number of potentially habitable worlds
  ///
  /// In en, this message translates to:
  /// **'Habitable Worlds'**
  String get habitableWorldsLabel;

  /// Title for the physics information section
  ///
  /// In en, this message translates to:
  /// **'Physics Parameters'**
  String get physicsInfoTitle;

  /// Label for simulation time scale
  ///
  /// In en, this message translates to:
  /// **'Time Scale'**
  String get timeScaleLabel;

  /// Label for gravitational constant parameter
  ///
  /// In en, this message translates to:
  /// **'Gravitational Constant'**
  String get gravitationalConstantLabel;

  /// Label for softening parameter
  ///
  /// In en, this message translates to:
  /// **'Softening Parameter'**
  String get softeningParameterLabel;

  /// Label for collision radius multiplier
  ///
  /// In en, this message translates to:
  /// **'Collision Radius'**
  String get collisionRadiusLabel;

  /// Name for classic three-body problem scenario
  ///
  /// In en, this message translates to:
  /// **'Three-Body Classic'**
  String get scenarioThreeBodyClassic;

  /// Description for classic three-body problem scenario
  ///
  /// In en, this message translates to:
  /// **'Classic three-body problem demonstrating chaotic gravitational dynamics'**
  String get scenarioThreeBodyClassicDescription;

  /// Name for collision demonstration scenario
  ///
  /// In en, this message translates to:
  /// **'Collision Demo'**
  String get scenarioCollisionDemo;

  /// Description for collision demonstration scenario
  ///
  /// In en, this message translates to:
  /// **'Collision demonstration with orbital mechanics and body interactions'**
  String get scenarioCollisionDemoDescription;

  /// Name for deep space exploration scenario
  ///
  /// In en, this message translates to:
  /// **'Deep Space'**
  String get scenarioDeepSpace;

  /// Description for deep space exploration scenario
  ///
  /// In en, this message translates to:
  /// **'Deep space exploration with distant objects and sparse gravitational fields'**
  String get scenarioDeepSpaceDescription;

  /// Label for total system energy
  ///
  /// In en, this message translates to:
  /// **'Total Energy'**
  String get systemEnergyLabel;

  /// Label for system kinetic energy
  ///
  /// In en, this message translates to:
  /// **'Kinetic Energy'**
  String get kineticEnergyLabel;

  /// Label for system gravitational potential energy
  ///
  /// In en, this message translates to:
  /// **'Potential Energy'**
  String get potentialEnergyLabel;

  /// Label for total system angular momentum
  ///
  /// In en, this message translates to:
  /// **'Angular Momentum'**
  String get angularMomentumLabel;

  /// Label for system center of mass position
  ///
  /// In en, this message translates to:
  /// **'Center of Mass'**
  String get centerOfMassLabel;

  /// Label for min/max body velocities
  ///
  /// In en, this message translates to:
  /// **'Velocity Range'**
  String get velocityRangeLabel;

  /// Label for average body velocity
  ///
  /// In en, this message translates to:
  /// **'Average Velocity'**
  String get averageVelocityLabel;

  /// Label for min/max body temperatures
  ///
  /// In en, this message translates to:
  /// **'Temperature Range'**
  String get temperatureRangeLabel;

  /// Label for total system momentum
  ///
  /// In en, this message translates to:
  /// **'System Momentum'**
  String get systemMomentumLabel;

  /// Title for energy and dynamics section
  ///
  /// In en, this message translates to:
  /// **'Energy & Dynamics'**
  String get energyDynamicsTitle;

  /// Title for orbital mechanics section
  ///
  /// In en, this message translates to:
  /// **'Orbital Mechanics'**
  String get orbitalMechanicsTitle;

  /// Title for individual celestial bodies section
  ///
  /// In en, this message translates to:
  /// **'Celestial Bodies'**
  String get celestialBodiesTitle;

  /// Label for celestial body name
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get bodyNameLabel;

  /// Label for celestial body mass
  ///
  /// In en, this message translates to:
  /// **'Mass'**
  String get bodyMassLabel;

  /// Label for celestial body radius
  ///
  /// In en, this message translates to:
  /// **'Radius'**
  String get bodyRadiusLabel;

  /// Label for celestial body velocity
  ///
  /// In en, this message translates to:
  /// **'Velocity'**
  String get bodyVelocityLabel;

  /// Label for celestial body temperature
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get bodyTemperatureLabel;

  /// Label for stellar luminosity
  ///
  /// In en, this message translates to:
  /// **'Luminosity'**
  String get bodyLuminosityLabel;

  /// Label for celestial body position coordinates
  ///
  /// In en, this message translates to:
  /// **'Position'**
  String get bodyPositionLabel;

  /// Label for celestial body type
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get bodyTypeLabel;

  /// Label for planetary habitability status
  ///
  /// In en, this message translates to:
  /// **'Habitability'**
  String get bodyHabitabilityLabel;

  /// Label for individual body kinetic energy
  ///
  /// In en, this message translates to:
  /// **'Kinetic Energy'**
  String get bodyKineticEnergyLabel;

  /// Label for escape velocity from body surface
  ///
  /// In en, this message translates to:
  /// **'Escape Velocity'**
  String get bodyEscapeVelocityLabel;

  /// Label for body's distance from system center of mass
  ///
  /// In en, this message translates to:
  /// **'Distance from Center'**
  String get bodyDistanceFromCenterLabel;

  /// Label for estimated orbital period
  ///
  /// In en, this message translates to:
  /// **'Orbital Period'**
  String get bodyOrbitalPeriodLabel;

  /// Value shown when data is not applicable
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get notApplicableValue;

  /// Status text for habitable worlds
  ///
  /// In en, this message translates to:
  /// **'Habitable'**
  String get habitableStatus;

  /// Status text for unknown habitability
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknownHabitabilityStatus;

  /// Status text for too hot for life
  ///
  /// In en, this message translates to:
  /// **'Too Hot'**
  String get tooHotStatus;

  /// Status text for too cold for life
  ///
  /// In en, this message translates to:
  /// **'Too Cold'**
  String get tooColdStatus;

  /// Status text for no atmosphere
  ///
  /// In en, this message translates to:
  /// **'No Atmosphere'**
  String get noAtmosphereStatus;

  /// Title for body selection dialog
  ///
  /// In en, this message translates to:
  /// **'Select Body'**
  String get selectBody;

  /// Message shown when no bodies are available to select
  ///
  /// In en, this message translates to:
  /// **'No bodies available'**
  String get noBodiesAvailable;

  /// Label for share action button
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// Title for share simulation dialog
  ///
  /// In en, this message translates to:
  /// **'Share Simulation'**
  String get shareSimulation;

  /// Option to share simulation as an image
  ///
  /// In en, this message translates to:
  /// **'Share Image'**
  String get shareImage;

  /// Description for share image option
  ///
  /// In en, this message translates to:
  /// **'Capture and share the current view'**
  String get shareImageDescription;

  /// Option to share simulation state as JSON
  ///
  /// In en, this message translates to:
  /// **'Share State'**
  String get shareState;

  /// Description for share state option
  ///
  /// In en, this message translates to:
  /// **'Export simulation data as importable file'**
  String get shareStateDescription;

  /// Success message after sharing
  ///
  /// In en, this message translates to:
  /// **'Shared successfully'**
  String get shareSuccess;

  /// Error message when sharing fails
  ///
  /// In en, this message translates to:
  /// **'Failed to share'**
  String get shareFailed;

  /// Error message when image capture fails
  ///
  /// In en, this message translates to:
  /// **'Cannot capture image. Please try again.'**
  String get shareImageError;

  /// Subject line when sharing simulation
  ///
  /// In en, this message translates to:
  /// **'Graviton Simulation'**
  String get shareSubject;

  /// Subject line when sharing simulation snapshot
  ///
  /// In en, this message translates to:
  /// **'Graviton Simulation Snapshot'**
  String get shareSnapshotSubject;

  /// Text message when sharing simulation
  ///
  /// In en, this message translates to:
  /// **'Check out this gravitational simulation!'**
  String get shareText;

  /// Button to import a scenario from file
  ///
  /// In en, this message translates to:
  /// **'Import Scenario'**
  String get importScenario;

  /// Description for import scenario button
  ///
  /// In en, this message translates to:
  /// **'Load a scenario from a JSON file'**
  String get importScenarioDescription;

  /// Success message after importing scenario
  ///
  /// In en, this message translates to:
  /// **'Scenario imported successfully'**
  String get importSuccess;

  /// Error message when import fails
  ///
  /// In en, this message translates to:
  /// **'Failed to import scenario'**
  String get importFailed;

  /// Error message for invalid file format
  ///
  /// In en, this message translates to:
  /// **'Invalid file format. Please select a valid JSON file.'**
  String get importInvalidFile;

  /// Error message when selected file is not found
  ///
  /// In en, this message translates to:
  /// **'File not found. Please try again.'**
  String get importFileNotFound;

  /// Message when user cancels file selection
  ///
  /// In en, this message translates to:
  /// **'Import cancelled'**
  String get importCancelled;

  /// Title for account management screen
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountManagementTitle;

  /// Tooltip for account button in app bar
  ///
  /// In en, this message translates to:
  /// **'Account & Profile'**
  String get accountButtonTooltip;

  /// Title for sign in prompt
  ///
  /// In en, this message translates to:
  /// **'Sign In to Your Account'**
  String get signInPromptTitle;

  /// Message explaining benefits of signing in
  ///
  /// In en, this message translates to:
  /// **'Create an account or sign in to sync your data and preferences across devices.'**
  String get signInPromptMessage;

  /// Button to sign in
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signInButton;

  /// Button to sign out
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOutButton;

  /// Button for anonymous users to reset their session and start fresh
  ///
  /// In en, this message translates to:
  /// **'Reset Session'**
  String get resetSessionButton;

  /// Success message after signing out
  ///
  /// In en, this message translates to:
  /// **'Successfully signed out'**
  String get signOutSuccess;

  /// Error message when an operation times out
  ///
  /// In en, this message translates to:
  /// **'Operation timed out. Please try again.'**
  String get operationTimeout;

  /// Generic error message when an operation fails
  ///
  /// In en, this message translates to:
  /// **'Operation failed. Please try again.'**
  String get operationFailed;

  /// Error message when a link cannot be opened
  ///
  /// In en, this message translates to:
  /// **'Could not open link. Please try again.'**
  String get couldNotOpenLink;

  /// Message shown when user needs to wait before retrying an operation
  ///
  /// In en, this message translates to:
  /// **'Please wait a moment before trying again.'**
  String get pleaseWaitBeforeRetrying;

  /// Rate limit message with cooldown duration
  ///
  /// In en, this message translates to:
  /// **'Please wait {seconds} seconds before trying again.'**
  String rateLimitWithCooldown(int seconds);

  /// Error message for network connectivity issues
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your connection and try again.'**
  String get networkError;

  /// Button to continue without account
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get continueAsGuestButton;

  /// Success message for anonymous sign in
  ///
  /// In en, this message translates to:
  /// **'Signed in as guest'**
  String get signInAnonymousSuccess;

  /// Label for anonymous users
  ///
  /// In en, this message translates to:
  /// **'Guest User'**
  String get anonymousUserLabel;

  /// Label for guest account type
  ///
  /// In en, this message translates to:
  /// **'Guest Account'**
  String get guestAccountLabel;

  /// Label for authenticated account
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get authenticatedLabel;

  /// Tooltip for change avatar button
  ///
  /// In en, this message translates to:
  /// **'Change Avatar'**
  String get changeAvatarTooltip;

  /// Tooltip for edit display name button
  ///
  /// In en, this message translates to:
  /// **'Edit Name'**
  String get editDisplayNameTooltip;

  /// Section title for account actions
  ///
  /// In en, this message translates to:
  /// **'Account Actions'**
  String get accountActionsSection;

  /// Title for upgrade account option
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Full Account'**
  String get upgradeAccountTitle;

  /// Description for upgrade account
  ///
  /// In en, this message translates to:
  /// **'Save your data and access it from any device'**
  String get upgradeAccountDescription;

  /// Section title for account management options
  ///
  /// In en, this message translates to:
  /// **'Account Management'**
  String get accountManagementSection;

  /// Section title for danger zone
  ///
  /// In en, this message translates to:
  /// **'Danger Zone'**
  String get dangerZoneSection;

  /// Button to delete account
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccountButton;

  /// Success message after changing avatar
  ///
  /// In en, this message translates to:
  /// **'Avatar updated successfully'**
  String get avatarChangedSuccess;

  /// Error message when avatar change fails
  ///
  /// In en, this message translates to:
  /// **'Failed to update avatar'**
  String get avatarChangedError;

  /// Description for account menu item in drawer
  ///
  /// In en, this message translates to:
  /// **'Manage your account and profile'**
  String get accountMenuDescription;

  /// Label for email input field
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// Label for password input field
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// Button text to create a new account
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccountButton;

  /// Validation error when email field is empty
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterEmail;

  /// Validation error when email format is invalid
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get pleaseEnterValidEmail;

  /// Validation error when password field is empty
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterPassword;

  /// Validation error when password is too short
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLength;

  /// Text to toggle from create account to sign in
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign In'**
  String get alreadyHaveAccount;

  /// Text to toggle from sign in to create account
  ///
  /// In en, this message translates to:
  /// **'Need an account? Create One'**
  String get needAccount;

  /// Button text for Google sign-in
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// Button text for Apple sign-in
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get continueWithApple;

  /// Title for avatar selector dialog
  ///
  /// In en, this message translates to:
  /// **'Select Avatar'**
  String get selectAvatarTitle;

  /// Title for edit account information screen
  ///
  /// In en, this message translates to:
  /// **'Edit Account Information'**
  String get editAccountInformationTitle;

  /// Label for display name input field
  ///
  /// In en, this message translates to:
  /// **'Display Name'**
  String get displayNameLabel;

  /// Validation error when display name is empty
  ///
  /// In en, this message translates to:
  /// **'Please enter a display name'**
  String get pleaseEnterDisplayName;

  /// Validation error when display name is too short
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters'**
  String get displayNameMinLength;

  /// Title for delete account dialog
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccountTitle;

  /// Warning message in delete account dialog
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get deleteAccountWarning;

  /// Message explaining what will be deleted
  ///
  /// In en, this message translates to:
  /// **'Deleting your account will permanently remove any data associated with it.'**
  String get deleteAccountMessage;

  /// First item in delete account list
  ///
  /// In en, this message translates to:
  /// **'Your profile and avatar'**
  String get deleteAccountItem1;

  /// Second item in delete account list
  ///
  /// In en, this message translates to:
  /// **'All saved preferences'**
  String get deleteAccountItem2;

  /// Third item in delete account list
  ///
  /// In en, this message translates to:
  /// **'Custom scenarios and settings'**
  String get deleteAccountItem3;

  /// Fourth item in delete account list
  ///
  /// In en, this message translates to:
  /// **'Account authentication'**
  String get deleteAccountItem4;

  /// Prompt for password confirmation before deleting account
  ///
  /// In en, this message translates to:
  /// **'Please enter your password to confirm:'**
  String get deleteAccountPasswordPrompt;

  /// Divider text between authentication options
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get orDivider;

  /// Hint text for display name field
  ///
  /// In en, this message translates to:
  /// **'Enter your name (optional)'**
  String get displayNameHint;

  /// Hint text for email field
  ///
  /// In en, this message translates to:
  /// **'Your email address'**
  String get emailHint;

  /// Hint text for password field
  ///
  /// In en, this message translates to:
  /// **'Your password'**
  String get passwordHint;

  /// Text to switch from create account to sign in
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get alreadyHaveAccountSignIn;

  /// Text to switch from sign in to create account
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Create one'**
  String get needAccountCreateOne;

  /// Option to use Google profile photo as avatar
  ///
  /// In en, this message translates to:
  /// **'Use Google Profile Photo'**
  String get useGoogleProfilePhoto;

  /// Section title for custom avatar selection
  ///
  /// In en, this message translates to:
  /// **'Custom Avatars'**
  String get customAvatars;

  /// Button text to save selected avatar
  ///
  /// In en, this message translates to:
  /// **'Save Avatar'**
  String get saveAvatar;

  /// Label for display name input field in edit screen
  ///
  /// In en, this message translates to:
  /// **'Display Name'**
  String get displayNameFieldLabel;

  /// Hint for display name input field in edit screen
  ///
  /// In en, this message translates to:
  /// **'Enter your display name'**
  String get displayNameFieldHint;

  /// Button text to save account information changes
  ///
  /// In en, this message translates to:
  /// **'Save Account Information'**
  String get saveAccountInformation;

  /// Validation error when email is empty
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// Validation error when email format is invalid
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get emailInvalid;

  /// Validation error when password is empty
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// Validation error when password is too short
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// Default display name for users who don't provide one
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get defaultUserName;

  /// Error message when Google sign-in fails
  ///
  /// In en, this message translates to:
  /// **'Google sign-in was canceled or failed. Please try again.'**
  String get googleSignInError;

  /// Success message when display name is updated
  ///
  /// In en, this message translates to:
  /// **'Display name updated'**
  String get displayNameUpdated;

  /// Error message when display name update fails
  ///
  /// In en, this message translates to:
  /// **'Failed to update display name'**
  String get displayNameUpdateFailed;

  /// Success message when anonymous session is reset
  ///
  /// In en, this message translates to:
  /// **'Session reset successfully'**
  String get sessionResetSuccess;

  /// Success message when account is deleted
  ///
  /// In en, this message translates to:
  /// **'Account deleted successfully'**
  String get accountDeletedSuccess;

  /// Error message for user-not-found Firebase error
  ///
  /// In en, this message translates to:
  /// **'No account found with this email address.'**
  String get errorUserNotFound;

  /// Error message for wrong-password Firebase error
  ///
  /// In en, this message translates to:
  /// **'Incorrect password. Please try again.'**
  String get errorWrongPassword;

  /// Error message for invalid-email Firebase error
  ///
  /// In en, this message translates to:
  /// **'Invalid email address format.'**
  String get errorInvalidEmail;

  /// Error message for user-disabled Firebase error
  ///
  /// In en, this message translates to:
  /// **'This account has been disabled.'**
  String get errorUserDisabled;

  /// Error message for email-already-in-use Firebase error
  ///
  /// In en, this message translates to:
  /// **'An account already exists with this email address.'**
  String get errorEmailInUse;

  /// Error message for weak-password Firebase error
  ///
  /// In en, this message translates to:
  /// **'Password is too weak. Please use a stronger password.'**
  String get errorWeakPassword;

  /// Error message for operation-not-allowed Firebase error
  ///
  /// In en, this message translates to:
  /// **'This sign-in method is not enabled.'**
  String get errorOperationNotAllowed;

  /// Error message for requires-recent-login Firebase error
  ///
  /// In en, this message translates to:
  /// **'Please sign in again to perform this action.'**
  String get errorRequiresRecentLogin;

  /// Error message for network-request-failed Firebase error
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your connection.'**
  String get errorNetworkFailed;

  /// Generic error message with placeholder for error details
  ///
  /// In en, this message translates to:
  /// **'An error occurred: {message}'**
  String errorUnknown(String message);

  /// Exception message when Google Sign-In is not properly initialized
  ///
  /// In en, this message translates to:
  /// **'Google Sign-In not initialized'**
  String get exceptionGoogleSignInNotInitialized;

  /// Exception message when Google sign-in operation times out
  ///
  /// In en, this message translates to:
  /// **'Google sign-in timed out'**
  String get exceptionGoogleSignInTimeout;

  /// Exception message when attempting Apple Sign-In on non-Apple platforms
  ///
  /// In en, this message translates to:
  /// **'Apple Sign-In is only available on Apple platforms'**
  String get exceptionAppleSignInPlatform;

  /// Exception message when trying to link credentials but no anonymous user exists
  ///
  /// In en, this message translates to:
  /// **'No anonymous user to link'**
  String get exceptionNoAnonymousUser;

  /// Exception message when an operation requires a signed-in user but none exists
  ///
  /// In en, this message translates to:
  /// **'No user signed in'**
  String get exceptionNoUserSignedIn;

  /// Firebase auth error when user is not found
  ///
  /// In en, this message translates to:
  /// **'No account found with this email address.'**
  String get firebaseErrorUserNotFound;

  /// Firebase auth error for wrong password
  ///
  /// In en, this message translates to:
  /// **'Incorrect password. Please try again.'**
  String get firebaseErrorWrongPassword;

  /// Firebase auth error for invalid email format
  ///
  /// In en, this message translates to:
  /// **'Invalid email address format.'**
  String get firebaseErrorInvalidEmail;

  /// Firebase auth error when user account is disabled
  ///
  /// In en, this message translates to:
  /// **'This account has been disabled.'**
  String get firebaseErrorUserDisabled;

  /// Firebase auth error when email is already in use
  ///
  /// In en, this message translates to:
  /// **'An account already exists with this email address.'**
  String get firebaseErrorEmailInUse;

  /// Firebase auth error for weak password
  ///
  /// In en, this message translates to:
  /// **'Password is too weak. Please use a stronger password.'**
  String get firebaseErrorWeakPassword;

  /// Firebase auth error when operation is not allowed
  ///
  /// In en, this message translates to:
  /// **'This sign-in method is not enabled.'**
  String get firebaseErrorOperationNotAllowed;

  /// Firebase auth error requiring recent login
  ///
  /// In en, this message translates to:
  /// **'Please sign in again to perform this action.'**
  String get firebaseErrorRequiresRecentLogin;

  /// Firebase auth error for network failures
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your connection.'**
  String get firebaseErrorNetworkFailed;

  /// Default Firebase auth error message with placeholder
  ///
  /// In en, this message translates to:
  /// **'An error occurred: {message}'**
  String firebaseErrorDefault(String message);

  /// Success message after sending verification email
  ///
  /// In en, this message translates to:
  /// **'Verification email sent! Please check your inbox.'**
  String get emailVerificationSent;

  /// Success message after resending verification email
  ///
  /// In en, this message translates to:
  /// **'Verification email resent successfully.'**
  String get emailVerificationResent;

  /// Label indicating email is not verified
  ///
  /// In en, this message translates to:
  /// **'Email not verified'**
  String get emailNotVerified;

  /// Label indicating email is verified
  ///
  /// In en, this message translates to:
  /// **'Email verified'**
  String get emailVerified;

  /// Title for email verification section
  ///
  /// In en, this message translates to:
  /// **'Verify Email Address'**
  String get verifyEmailAddress;

  /// Message explaining email verification requirement
  ///
  /// In en, this message translates to:
  /// **'Please verify your email address to access all features. Check your inbox for the verification link.'**
  String get verifyEmailMessage;

  /// Button text to send verification email
  ///
  /// In en, this message translates to:
  /// **'Send Verification Email'**
  String get sendVerificationEmail;

  /// Button text to resend verification email
  ///
  /// In en, this message translates to:
  /// **'Resend Verification Email'**
  String get resendVerificationEmail;

  /// Button text to refresh email verification status
  ///
  /// In en, this message translates to:
  /// **'Check Verification Status'**
  String get checkVerificationStatus;

  /// Status message when email verification is pending
  ///
  /// In en, this message translates to:
  /// **'Email verification pending'**
  String get emailVerificationPending;

  /// Message shown when user must wait before resending verification email
  ///
  /// In en, this message translates to:
  /// **'Please wait {seconds} seconds before requesting another verification email.'**
  String verificationEmailCooldown(int seconds);

  /// Title for terms and privacy section
  ///
  /// In en, this message translates to:
  /// **'Terms & Privacy'**
  String get termsAndPrivacy;

  /// Checkbox label for accepting terms and privacy
  ///
  /// In en, this message translates to:
  /// **'I accept the Terms of Service and Privacy Policy'**
  String get acceptTermsAndPrivacy;

  /// Error message when terms are not accepted
  ///
  /// In en, this message translates to:
  /// **'You must accept the Terms of Service and Privacy Policy to continue.'**
  String get mustAcceptTerms;

  /// Link text for Terms of Service
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// Link text for Privacy Policy
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Action to view Terms of Service
  ///
  /// In en, this message translates to:
  /// **'View Terms of Service'**
  String get viewTermsOfService;

  /// Action to view Privacy Policy
  ///
  /// In en, this message translates to:
  /// **'View Privacy Policy'**
  String get viewPrivacyPolicy;

  /// Shows when terms were last updated
  ///
  /// In en, this message translates to:
  /// **'Last updated: {date}'**
  String termsLastUpdated(String date);

  /// Shows when privacy policy was last updated
  ///
  /// In en, this message translates to:
  /// **'Last updated: {date}'**
  String privacyLastUpdated(String date);

  /// Message about minimum age requirement (COPPA compliance)
  ///
  /// In en, this message translates to:
  /// **'You must be 13 years or older to create an account.'**
  String get ageRequirement;

  /// Checkbox label for age confirmation
  ///
  /// In en, this message translates to:
  /// **'I confirm that I am 13 years or older'**
  String get confirmAge;

  /// Exception key when email verification fails
  ///
  /// In en, this message translates to:
  /// **'exceptionEmailVerificationFailed'**
  String get exceptionEmailVerificationFailed;

  /// Exception key when verification email is rate limited
  ///
  /// In en, this message translates to:
  /// **'exceptionEmailVerificationCooldown'**
  String get exceptionEmailVerificationCooldown;

  /// Exception key when terms are not accepted
  ///
  /// In en, this message translates to:
  /// **'exceptionTermsNotAccepted'**
  String get exceptionTermsNotAccepted;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'ja',
    'ko',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
