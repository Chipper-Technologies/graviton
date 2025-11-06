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

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Graviton'**
  String get appTitle;

  /// Button to start the simulation
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get playButton;

  /// Button to pause the simulation
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pauseButton;

  /// Button to reset the simulation
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get resetButton;

  /// Description for reset settings action
  ///
  /// In en, this message translates to:
  /// **'Reset all settings to default values'**
  String get resetSettingsDescription;

  /// Label for simulation speed control
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get speedLabel;

  /// Label for trail visibility toggle
  ///
  /// In en, this message translates to:
  /// **'Trails'**
  String get trailsLabel;

  /// Label for statistics display button
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get statsLabel;

  /// Label for bottom navigation camera button
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get bottomNavCameraLabel;

  /// Label for bottom navigation visuals button
  ///
  /// In en, this message translates to:
  /// **'Visuals'**
  String get bottomNavVisualsLabel;

  /// Label for bottom navigation physics button
  ///
  /// In en, this message translates to:
  /// **'Physics'**
  String get bottomNavPhysicsLabel;

  /// Tooltip for camera tab button
  ///
  /// In en, this message translates to:
  /// **'Camera settings and AI modes'**
  String get cameraTooltip;

  /// Tooltip for visuals tab button
  ///
  /// In en, this message translates to:
  /// **'Visual display options'**
  String get visualsTooltip;

  /// Tooltip for physics tab button
  ///
  /// In en, this message translates to:
  /// **'Physics visualization and settings'**
  String get physicsTooltip;

  /// Section title for AI camera modes
  ///
  /// In en, this message translates to:
  /// **'AI Camera Modes'**
  String get aiCameraModesTitle;

  /// Title for manual camera control mode
  ///
  /// In en, this message translates to:
  /// **'Manual Control'**
  String get manualControlTitle;

  /// Description for manual camera control mode
  ///
  /// In en, this message translates to:
  /// **'Full manual camera control'**
  String get manualControlDescription;

  /// Title for predictive orbital camera mode
  ///
  /// In en, this message translates to:
  /// **'Predictive Orbital'**
  String get predictiveOrbitalTitle;

  /// Description for predictive orbital camera mode
  ///
  /// In en, this message translates to:
  /// **'AI predicts optimal orbital views'**
  String get predictiveOrbitalDescription;

  /// Title for dynamic framing camera mode
  ///
  /// In en, this message translates to:
  /// **'Dynamic Framing'**
  String get dynamicFramingTitle;

  /// Description for dynamic framing camera mode
  ///
  /// In en, this message translates to:
  /// **'AI dynamically frames all objects'**
  String get dynamicFramingDescription;

  /// Section title for manual camera controls
  ///
  /// In en, this message translates to:
  /// **'Manual Controls'**
  String get manualControlsTitle;

  /// Label for AI camera movement speed slider
  ///
  /// In en, this message translates to:
  /// **'Camera Speed'**
  String get cameraSpeedLabel;

  /// Accessibility hint for camera speed slider
  ///
  /// In en, this message translates to:
  /// **'Adjust AI camera movement speed from slow to fast. Use arrow keys to change in small increments.'**
  String get cameraSpeedHint;

  /// Button text for selecting nearest celestial body
  ///
  /// In en, this message translates to:
  /// **'Select Nearest'**
  String get selectNearestTitle;

  /// Button text for stopping follow mode
  ///
  /// In en, this message translates to:
  /// **'Stop Follow'**
  String get stopFollowTitle;

  /// Button text for starting follow mode
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get followTitle;

  /// Button text for centering the camera view
  ///
  /// In en, this message translates to:
  /// **'Center View'**
  String get centerViewTitle;

  /// Button text for stopping auto rotation
  ///
  /// In en, this message translates to:
  /// **'Stop Rotate'**
  String get stopRotateTitle;

  /// Button text for starting auto rotation
  ///
  /// In en, this message translates to:
  /// **'Auto Rotate'**
  String get autoRotateTitle;

  /// Section title for visual display options
  ///
  /// In en, this message translates to:
  /// **'Display Options'**
  String get displayOptionsTitle;

  /// Toggle title for showing orbital trails
  ///
  /// In en, this message translates to:
  /// **'Show Trails'**
  String get showTrailsTitle;

  /// Toggle title for showing body labels
  ///
  /// In en, this message translates to:
  /// **'Show Labels'**
  String get showLabelsTitle;

  /// Toggle title for realistic color scheme
  ///
  /// In en, this message translates to:
  /// **'Realistic Colors'**
  String get realisticColorsTitle;

  /// Section title for physics visualization options
  ///
  /// In en, this message translates to:
  /// **'Physics Visualization'**
  String get physicsVisualizationTitle;

  /// Toggle title for gravity field visualization
  ///
  /// In en, this message translates to:
  /// **'Gravity Fields'**
  String get gravityFieldsTitle;

  /// Description for gravity field visualization toggle
  ///
  /// In en, this message translates to:
  /// **'Show gravitational field visualization'**
  String get gravityFieldsDescription;

  /// Section title for debug and statistics options
  ///
  /// In en, this message translates to:
  /// **'Debug & Statistics'**
  String get debugStatisticsTitle;

  /// Toggle title for showing statistics
  ///
  /// In en, this message translates to:
  /// **'Show Statistics'**
  String get showStatisticsTitle;

  /// Description for statistics display toggle
  ///
  /// In en, this message translates to:
  /// **'Display performance and physics stats'**
  String get showStatisticsDescription;

  /// Section title for current simulation statistics
  ///
  /// In en, this message translates to:
  /// **'Current Statistics'**
  String get currentStatisticsTitle;

  /// Statistics label for number of celestial bodies
  ///
  /// In en, this message translates to:
  /// **'Bodies'**
  String get bodiesStatLabel;

  /// Statistics label for current time scale multiplier
  ///
  /// In en, this message translates to:
  /// **'Time Scale'**
  String get timeScaleStatLabel;

  /// Statistics label for currently selected body
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get selectedStatLabel;

  /// Label for follow object button
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get followLabel;

  /// Label for center view button
  ///
  /// In en, this message translates to:
  /// **'Center'**
  String get centerLabel;

  /// Label for auto-rotate button
  ///
  /// In en, this message translates to:
  /// **'Rotate'**
  String get rotateLabel;

  /// Option for warm-colored trails
  ///
  /// In en, this message translates to:
  /// **'🔥 Warm'**
  String get warmTrails;

  /// Option for cool-colored trails
  ///
  /// In en, this message translates to:
  /// **'❄️ Cool'**
  String get coolTrails;

  /// Tooltip for the stats toggle button
  ///
  /// In en, this message translates to:
  /// **'Toggle Stats'**
  String get toggleStatsTooltip;

  /// Tooltip for the body labels toggle button
  ///
  /// In en, this message translates to:
  /// **'Toggle Body Labels'**
  String get toggleLabelsTooltip;

  /// Description for the body labels setting
  ///
  /// In en, this message translates to:
  /// **'Show celestial body names in the simulation'**
  String get showLabelsDescription;

  /// Title for the off-screen indicators toggle
  ///
  /// In en, this message translates to:
  /// **'Off-Screen Indicators'**
  String get offScreenIndicatorsTitle;

  /// Description for the off-screen indicators setting
  ///
  /// In en, this message translates to:
  /// **'Show arrows pointing to objects outside the visible area'**
  String get offScreenIndicatorsDescription;

  /// Tooltip for the auto-rotate button
  ///
  /// In en, this message translates to:
  /// **'Auto Rotate'**
  String get autoRotateTooltip;

  /// Tooltip for the center view button
  ///
  /// In en, this message translates to:
  /// **'Center View'**
  String get centerViewTooltip;

  /// Tooltip for the focus on nearest body button
  ///
  /// In en, this message translates to:
  /// **'Focus on Nearest Body'**
  String get focusOnNearestTooltip;

  /// Tooltip for the follow object button when an object is selected
  ///
  /// In en, this message translates to:
  /// **'Follow Selected Object'**
  String get followObjectTooltip;

  /// Tooltip for the follow object button when currently following
  ///
  /// In en, this message translates to:
  /// **'Stop Following Object'**
  String get stopFollowingTooltip;

  /// Tooltip for the follow object button when no object is selected
  ///
  /// In en, this message translates to:
  /// **'Select Object to Follow'**
  String get selectObjectToFollowTooltip;

  /// Title for the application settings screen
  ///
  /// In en, this message translates to:
  /// **'Application Settings'**
  String get settingsTitle;

  /// Tooltip for the settings button in the app bar
  ///
  /// In en, this message translates to:
  /// **'Application Settings'**
  String get settingsTooltip;

  /// Tooltip for the scenario selection button in the app bar
  ///
  /// In en, this message translates to:
  /// **'Select Scenario'**
  String get selectScenarioTooltip;

  /// Tooltip for the more options menu button
  ///
  /// In en, this message translates to:
  /// **'More options'**
  String get moreOptionsTooltip;

  /// Title for the physics settings menu item
  ///
  /// In en, this message translates to:
  /// **'Physics Settings'**
  String get physicsSettingsTitle;

  /// Description for the physics settings menu item
  ///
  /// In en, this message translates to:
  /// **'Simulation parameters'**
  String get physicsSettingsDescription;

  /// Physics section header in simulation settings
  ///
  /// In en, this message translates to:
  /// **'Physics'**
  String get physicsSection;

  /// Label for gravitational constant slider
  ///
  /// In en, this message translates to:
  /// **'Gravitational Constant'**
  String get gravitationalConstant;

  /// Label for softening parameter slider
  ///
  /// In en, this message translates to:
  /// **'Softening Parameter'**
  String get softeningParameter;

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

  /// Collisions section header in simulation settings
  ///
  /// In en, this message translates to:
  /// **'Collisions'**
  String get collisionsSection;

  /// Label for collision sensitivity slider
  ///
  /// In en, this message translates to:
  /// **'Collision Sensitivity'**
  String get collisionSensitivity;

  /// Trails section header in simulation settings
  ///
  /// In en, this message translates to:
  /// **'Trails'**
  String get trailsSection;

  /// Label for trail length slider
  ///
  /// In en, this message translates to:
  /// **'Trail Length'**
  String get trailLength;

  /// Label for trail fade rate slider
  ///
  /// In en, this message translates to:
  /// **'Trail Fade Rate'**
  String get trailFadeRate;

  /// Haptics section header in simulation settings
  ///
  /// In en, this message translates to:
  /// **'Haptics'**
  String get hapticsSection;

  /// Label for UI haptic feedback toggle
  ///
  /// In en, this message translates to:
  /// **'UI Haptic Feedback'**
  String get uiHapticFeedback;

  /// Detailed description for UI haptic feedback setting
  ///
  /// In en, this message translates to:
  /// **'Enable haptic feedback for UI interactions like button taps, toggles, and navigation'**
  String get uiHapticFeedbackDescription;

  /// Label for collision haptic feedback toggle
  ///
  /// In en, this message translates to:
  /// **'Collision Haptic Feedback'**
  String get collisionHapticFeedback;

  /// Detailed description for collision haptic feedback setting
  ///
  /// In en, this message translates to:
  /// **'Enable haptic feedback when celestial bodies collide during simulation'**
  String get collisionHapticFeedbackDescription;

  /// Legacy label for vibration enabled toggle
  ///
  /// In en, this message translates to:
  /// **'Vibration Enabled'**
  String get vibrationEnabled;

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

  /// Label for vibration throttle slider
  ///
  /// In en, this message translates to:
  /// **'Vibration Throttle'**
  String get vibrationThrottle;

  /// Description for the scenarios menu item
  ///
  /// In en, this message translates to:
  /// **'Explore different scenarios'**
  String get scenariosMenuDescription;

  /// Description for the settings menu item
  ///
  /// In en, this message translates to:
  /// **'Visual & behavior options'**
  String get settingsMenuDescription;

  /// Description for the help menu item
  ///
  /// In en, this message translates to:
  /// **'Tutorial & objectives'**
  String get helpMenuDescription;

  /// Description for the about menu item
  ///
  /// In en, this message translates to:
  /// **'App information & credits'**
  String get aboutMenuDescription;

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

  /// Label for trail color selection
  ///
  /// In en, this message translates to:
  /// **'Trail Color'**
  String get trailColorLabel;

  /// Section header for color-related settings
  ///
  /// In en, this message translates to:
  /// **'Colors'**
  String get colorsLabel;

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

  /// Label for close button
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeButton;

  /// Header for simulation statistics
  ///
  /// In en, this message translates to:
  /// **'Simulation Stats'**
  String get simulationStats;

  /// Label for simulation steps count
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get stepsLabel;

  /// Label for simulation time
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get timeLabel;

  /// Label for simulation time converted to Earth years
  ///
  /// In en, this message translates to:
  /// **'Earth Years'**
  String get earthYearsLabel;

  /// Label for simulation speed in stats
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get speedStatsLabel;

  /// Label for number of celestial bodies
  ///
  /// In en, this message translates to:
  /// **'Bodies'**
  String get bodiesLabel;

  /// Label for simulation status
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusLabel;

  /// Status when simulation is running
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get statusRunning;

  /// Status when simulation is paused
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get statusPaused;

  /// Status when simulation is stopped
  ///
  /// In en, this message translates to:
  /// **'Stopped'**
  String get statusStopped;

  /// Status when simulation has an error
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get statusError;

  /// Header for camera information
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get cameraLabel;

  /// Label for camera distance
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distanceLabel;

  /// Label for auto-rotate status
  ///
  /// In en, this message translates to:
  /// **'Auto-rotate'**
  String get autoRotateLabel;

  /// Auto-rotate is enabled
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get autoRotateOn;

  /// Auto-rotate is disabled
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get autoRotateOff;

  /// Label for camera yaw rotation
  ///
  /// In en, this message translates to:
  /// **'Yaw'**
  String get yawLabel;

  /// Label for camera pitch rotation
  ///
  /// In en, this message translates to:
  /// **'Pitch'**
  String get pitchLabel;

  /// Label for camera roll rotation
  ///
  /// In en, this message translates to:
  /// **'Roll'**
  String get rollLabel;

  /// Label for camera zoom level
  ///
  /// In en, this message translates to:
  /// **'Zoom'**
  String get zoomLabel;

  /// Header for camera controls section
  ///
  /// In en, this message translates to:
  /// **'Camera Controls'**
  String get cameraControlsLabel;

  /// Label for invert pitch controls toggle
  ///
  /// In en, this message translates to:
  /// **'Invert Pitch Controls'**
  String get invertPitchControlsLabel;

  /// Description for invert pitch controls toggle
  ///
  /// In en, this message translates to:
  /// **'Reverse up/down drag direction'**
  String get invertPitchControlsDescription;

  /// Label for cinematic camera technique selection
  ///
  /// In en, this message translates to:
  /// **'AI Camera Technique'**
  String get cinematicCameraTechniqueLabel;

  /// Description for cinematic camera technique setting
  ///
  /// In en, this message translates to:
  /// **'Choose how AI controls the camera when following objects'**
  String get cinematicCameraTechniqueDescription;

  /// Manual camera control technique
  ///
  /// In en, this message translates to:
  /// **'Manual Control'**
  String get cinematicTechniqueManual;

  /// Description for manual camera technique
  ///
  /// In en, this message translates to:
  /// **'Traditional manual camera controls with follow mode'**
  String get cinematicTechniqueManualDesc;

  /// Predictive orbital camera technique
  ///
  /// In en, this message translates to:
  /// **'Predictive Orbital'**
  String get cinematicTechniquePredictiveOrbital;

  /// Description for predictive orbital camera technique
  ///
  /// In en, this message translates to:
  /// **'AI tours and orbital predictions for educational scenarios'**
  String get cinematicTechniquePredictiveOrbitalDesc;

  /// Dynamic framing camera technique
  ///
  /// In en, this message translates to:
  /// **'Dynamic Framing'**
  String get cinematicTechniqueDynamicFraming;

  /// Description for dynamic framing camera technique
  ///
  /// In en, this message translates to:
  /// **'Real-time dramatic targeting for chaotic scenarios'**
  String get cinematicTechniqueDynamicFramingDesc;

  /// Header for marketing tools section
  ///
  /// In en, this message translates to:
  /// **'Marketing'**
  String get marketingLabel;

  /// Number of simulation steps
  ///
  /// In en, this message translates to:
  /// **'{count}'**
  String stepsCount(int count);

  /// Formatted simulation time in seconds
  ///
  /// In en, this message translates to:
  /// **'{time}s'**
  String timeFormatted(String time);

  /// Formatted simulation time in Earth years (abbreviated)
  ///
  /// In en, this message translates to:
  /// **'{years} yr'**
  String earthYearsFormatted(String years);

  /// Formatted simulation speed multiplier
  ///
  /// In en, this message translates to:
  /// **'{speed}x'**
  String speedFormatted(String speed);

  /// Quarter speed preset (0.25x)
  ///
  /// In en, this message translates to:
  /// **'Quarter Speed'**
  String get speedQuarter;

  /// Half speed preset (0.5x)
  ///
  /// In en, this message translates to:
  /// **'Half Speed'**
  String get speedHalf;

  /// Normal speed preset (1.0x)
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get speedNormal;

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

  /// Very fast speed preset (8.0x)
  ///
  /// In en, this message translates to:
  /// **'Very Fast'**
  String get speedVeryFast;

  /// Maximum speed preset (16.0x)
  ///
  /// In en, this message translates to:
  /// **'Maximum'**
  String get speedMaximum;

  /// Number of celestial bodies
  ///
  /// In en, this message translates to:
  /// **'{count}'**
  String bodiesCount(int count);

  /// Formatted camera distance
  ///
  /// In en, this message translates to:
  /// **'{distance}'**
  String distanceFormatted(String distance);

  /// Title for the scenario selection dialog
  ///
  /// In en, this message translates to:
  /// **'Select Scenario'**
  String get scenarioSelectionTitle;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Word for celestial bodies (lowercase for use in sentences)
  ///
  /// In en, this message translates to:
  /// **'bodies'**
  String get bodies;

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

  /// Label for habitability features
  ///
  /// In en, this message translates to:
  /// **'Habitability'**
  String get habitabilityLabel;

  /// Label for habitable zones toggle
  ///
  /// In en, this message translates to:
  /// **'Habitable Zones'**
  String get habitableZonesLabel;

  /// Label for habitability indicators toggle
  ///
  /// In en, this message translates to:
  /// **'Planet Status'**
  String get habitabilityIndicatorsLabel;

  /// Status for planets in the habitable zone
  ///
  /// In en, this message translates to:
  /// **'Habitable'**
  String get habitabilityHabitable;

  /// Status for planets too close to stars
  ///
  /// In en, this message translates to:
  /// **'Too Hot'**
  String get habitabilityTooHot;

  /// Status for planets too far from stars
  ///
  /// In en, this message translates to:
  /// **'Too Cold'**
  String get habitabilityTooCold;

  /// Status for bodies with unknown habitability
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get habitabilityUnknown;

  /// Temperature category for extremely cold bodies (below -100°C)
  ///
  /// In en, this message translates to:
  /// **'Frozen'**
  String get temperatureFrozen;

  /// Temperature category for cold bodies (-100°C to 0°C)
  ///
  /// In en, this message translates to:
  /// **'Cold'**
  String get temperatureCold;

  /// Temperature category for moderate temperature bodies (0°C to 50°C)
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get temperatureModerate;

  /// Temperature category for hot bodies (50°C to 150°C)
  ///
  /// In en, this message translates to:
  /// **'Hot'**
  String get temperatureHot;

  /// Temperature category for extremely hot bodies (above 150°C)
  ///
  /// In en, this message translates to:
  /// **'Scorching'**
  String get temperatureScorching;

  /// Temperature category for bodies where temperature doesn't apply
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get temperatureNotApplicable;

  /// Celsius temperature unit symbol
  ///
  /// In en, this message translates to:
  /// **'°C'**
  String get temperatureUnitCelsius;

  /// Kelvin temperature unit symbol
  ///
  /// In en, this message translates to:
  /// **'K'**
  String get temperatureUnitKelvin;

  /// Fahrenheit temperature unit symbol
  ///
  /// In en, this message translates to:
  /// **'°F'**
  String get temperatureUnitFahrenheit;

  /// Tooltip for habitable zones toggle button
  ///
  /// In en, this message translates to:
  /// **'Toggle Habitable Zones'**
  String get toggleHabitableZonesTooltip;

  /// Tooltip for habitability indicators toggle button
  ///
  /// In en, this message translates to:
  /// **'Toggle Planet Habitability Status'**
  String get toggleHabitabilityIndicatorsTooltip;

  /// Description for habitable zones setting
  ///
  /// In en, this message translates to:
  /// **'Show colored zones around stars indicating habitable regions'**
  String get habitableZonesDescription;

  /// Description for habitability indicators setting
  ///
  /// In en, this message translates to:
  /// **'Display color-coded status rings around planets based on their habitability'**
  String get habitabilityIndicatorsDescription;

  /// Title for the about dialog
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutDialogTitle;

  /// Description of the app shown in about dialog
  ///
  /// In en, this message translates to:
  /// **'A physics simulation exploring gravitational dynamics and orbital mechanics. Experience the beauty and complexity of celestial motion through interactive 3D visualization.'**
  String get appDescription;

  /// Label for author information
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get authorLabel;

  /// Label for website information
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get websiteLabel;

  /// Tooltip for the about button
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutButtonTooltip;

  /// Tooltip for the back navigation button
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backButtonTooltip;

  /// The name of the application
  ///
  /// In en, this message translates to:
  /// **'Graviton'**
  String get appNameGraviton;

  /// Label for version information
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get versionLabel;

  /// Text shown while version information is loading
  ///
  /// In en, this message translates to:
  /// **'Loading version...'**
  String get loadingVersion;

  /// The company name
  ///
  /// In en, this message translates to:
  /// **'Chipper Technologies LLC'**
  String get companyName;

  /// Label for gravity wells setting
  ///
  /// In en, this message translates to:
  /// **'Gravity Wells'**
  String get gravityWellsLabel;

  /// Description for gravity wells setting
  ///
  /// In en, this message translates to:
  /// **'Show gravitational field strength around objects'**
  String get gravityWellsDescription;

  /// Label for global gravity fields toggle
  ///
  /// In en, this message translates to:
  /// **'Global Gravity Fields'**
  String get globalGravityFieldsLabel;

  /// Description for global gravity fields setting
  ///
  /// In en, this message translates to:
  /// **'Enable gravity field visualization for all massive objects'**
  String get globalGravityFieldsDescription;

  /// Label for gravity field color scheme selection
  ///
  /// In en, this message translates to:
  /// **'Gravity Field Colors'**
  String get gravityFieldColorSchemeLabel;

  /// Description for gravity field color scheme setting
  ///
  /// In en, this message translates to:
  /// **'Choose the color scheme for gravitational field visualization'**
  String get gravityFieldColorSchemeDescription;

  /// Classic blue/yellow gravity field color scheme
  ///
  /// In en, this message translates to:
  /// **'Classic'**
  String get gravityColorSchemeClassic;

  /// Rainbow spectrum gravity field color scheme
  ///
  /// In en, this message translates to:
  /// **'Spectral'**
  String get gravityColorSchemeSpectral;

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

  /// Green-based gravity field color scheme
  ///
  /// In en, this message translates to:
  /// **'Emerald'**
  String get gravityColorSchemeEmerald;

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

  /// Formatted gravity field strength with unit
  ///
  /// In en, this message translates to:
  /// **'{strength} {unit}'**
  String gravityFieldStrengthFormatted(String strength, String unit);

  /// Label for equipotential surfaces toggle
  ///
  /// In en, this message translates to:
  /// **'Equipotential Surfaces'**
  String get equipotentialSurfacesLabel;

  /// Description for equipotential surfaces setting
  ///
  /// In en, this message translates to:
  /// **'Show surfaces of equal gravitational potential energy'**
  String get equipotentialSurfacesDescription;

  /// Label for gravity field strength indicators toggle
  ///
  /// In en, this message translates to:
  /// **'Field Strength Indicators'**
  String get gravityFieldIndicatorsLabel;

  /// Description for gravity field strength indicators setting
  ///
  /// In en, this message translates to:
  /// **'Show visual indicators of gravitational field strength'**
  String get gravityFieldIndicatorsDescription;

  /// Tooltip for the gravity fields toggle button
  ///
  /// In en, this message translates to:
  /// **'Toggle Gravity Fields'**
  String get toggleGravityFieldsTooltip;

  /// Label for language selection setting
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// Description for language selection setting
  ///
  /// In en, this message translates to:
  /// **'Change the app language'**
  String get languageDescription;

  /// Option to use system default language
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get languageSystem;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// German language option
  ///
  /// In en, this message translates to:
  /// **'Deutsch'**
  String get languageGerman;

  /// Spanish language option
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get languageSpanish;

  /// French language option
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get languageFrench;

  /// Chinese language option
  ///
  /// In en, this message translates to:
  /// **'中文'**
  String get languageChinese;

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

  /// Name for first star in random scenarios
  ///
  /// In en, this message translates to:
  /// **'Alpha'**
  String get bodyAlpha;

  /// Name for second star in random scenarios
  ///
  /// In en, this message translates to:
  /// **'Beta'**
  String get bodyBeta;

  /// Name for third star in random scenarios
  ///
  /// In en, this message translates to:
  /// **'Gamma'**
  String get bodyGamma;

  /// Name for small rocky planets
  ///
  /// In en, this message translates to:
  /// **'Rocky Planet'**
  String get bodyRockyPlanet;

  /// Name for Earth-like planets
  ///
  /// In en, this message translates to:
  /// **'Earth-like'**
  String get bodyEarthLike;

  /// Name for Super-Earth planets
  ///
  /// In en, this message translates to:
  /// **'Super-Earth'**
  String get bodySuperEarth;

  /// Name for the Sun
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get bodySun;

  /// Title for the body properties dialog
  ///
  /// In en, this message translates to:
  /// **'Body Properties'**
  String get bodyPropertiesTitle;

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

  /// Label for body type field
  ///
  /// In en, this message translates to:
  /// **'Body Type'**
  String get bodyPropertiesType;

  /// Label for body color field
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get bodyPropertiesColor;

  /// Label for body mass field
  ///
  /// In en, this message translates to:
  /// **'Mass'**
  String get bodyPropertiesMass;

  /// Label for body radius field
  ///
  /// In en, this message translates to:
  /// **'Radius'**
  String get bodyPropertiesRadius;

  /// Label for stellar luminosity field
  ///
  /// In en, this message translates to:
  /// **'Stellar Luminosity'**
  String get bodyPropertiesLuminosity;

  /// Label for velocity field
  ///
  /// In en, this message translates to:
  /// **'Velocity'**
  String get bodyPropertiesVelocity;

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

  /// Name for Earth
  ///
  /// In en, this message translates to:
  /// **'Earth'**
  String get bodyEarth;

  /// Name for the Moon
  ///
  /// In en, this message translates to:
  /// **'Moon'**
  String get bodyMoon;

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

  /// Name for planet in binary star system
  ///
  /// In en, this message translates to:
  /// **'Planet P'**
  String get bodyPlanetP;

  /// Name for moon in binary star system
  ///
  /// In en, this message translates to:
  /// **'Moon M'**
  String get bodyMoonM;

  /// Name for central star in asteroid belt
  ///
  /// In en, this message translates to:
  /// **'Central Star'**
  String get bodyCentralStar;

  /// Name for asteroids with number
  ///
  /// In en, this message translates to:
  /// **'Asteroid {number}'**
  String bodyAsteroid(int number);

  /// Name for black hole in galaxy formation
  ///
  /// In en, this message translates to:
  /// **'Black Hole'**
  String get bodyBlackHole;

  /// Name for planet with rings
  ///
  /// In en, this message translates to:
  /// **'Ringed Planet'**
  String get bodyRingedPlanet;

  /// Name for ring particles with number
  ///
  /// In en, this message translates to:
  /// **'Ring {number}'**
  String bodyRing(int number);

  /// Name for Mercury planet
  ///
  /// In en, this message translates to:
  /// **'Mercury'**
  String get bodyMercury;

  /// Name for Venus planet
  ///
  /// In en, this message translates to:
  /// **'Venus'**
  String get bodyVenus;

  /// Name for Mars planet
  ///
  /// In en, this message translates to:
  /// **'Mars'**
  String get bodyMars;

  /// Name for Jupiter planet
  ///
  /// In en, this message translates to:
  /// **'Jupiter'**
  String get bodyJupiter;

  /// Name for Saturn planet
  ///
  /// In en, this message translates to:
  /// **'Saturn'**
  String get bodySaturn;

  /// Name for Uranus planet
  ///
  /// In en, this message translates to:
  /// **'Uranus'**
  String get bodyUranus;

  /// Name for Neptune planet
  ///
  /// In en, this message translates to:
  /// **'Neptune'**
  String get bodyNeptune;

  /// Name for inner companion planet in asteroid belt scenario
  ///
  /// In en, this message translates to:
  /// **'Inner Planet'**
  String get bodyInnerPlanet;

  /// Name for outer companion planet in asteroid belt scenario
  ///
  /// In en, this message translates to:
  /// **'Outer Planet'**
  String get bodyOuterPlanet;

  /// Name for center of mass point in calculations
  ///
  /// In en, this message translates to:
  /// **'Center of Mass'**
  String get bodyCenterOfMass;

  /// Name pattern for numbered stars in galaxy scenarios
  ///
  /// In en, this message translates to:
  /// **'Star {number}'**
  String bodyStarNumber(int number);

  /// Educational focus for random scenario
  ///
  /// In en, this message translates to:
  /// **'chaotic dynamics'**
  String get educationalFocusChaoticDynamics;

  /// Educational focus for Earth-Moon-Sun scenario
  ///
  /// In en, this message translates to:
  /// **'real-world system'**
  String get educationalFocusRealWorldSystem;

  /// Educational focus for binary stars scenario
  ///
  /// In en, this message translates to:
  /// **'binary orbits'**
  String get educationalFocusBinaryOrbits;

  /// Educational focus for asteroid belt scenario
  ///
  /// In en, this message translates to:
  /// **'many-body dynamics'**
  String get educationalFocusManyBodyDynamics;

  /// Educational focus for galaxy formation scenario
  ///
  /// In en, this message translates to:
  /// **'structure formation'**
  String get educationalFocusStructureFormation;

  /// Educational focus for solar system scenario
  ///
  /// In en, this message translates to:
  /// **'planetary motion'**
  String get educationalFocusPlanetaryMotion;

  /// Title for the update required dialog
  ///
  /// In en, this message translates to:
  /// **'Update Required'**
  String get updateRequiredTitle;

  /// Message for the update required dialog
  ///
  /// In en, this message translates to:
  /// **'A newer version of this app is available. Please update to continue using the app with the latest features and improvements.'**
  String get updateRequiredMessage;

  /// Warning message for the update required dialog
  ///
  /// In en, this message translates to:
  /// **'This version is no longer supported.'**
  String get updateRequiredWarning;

  /// Button text to update now
  ///
  /// In en, this message translates to:
  /// **'Update Now'**
  String get updateNow;

  /// Button text to update later
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get updateLater;

  /// Badge text for current app version
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get versionStatusCurrent;

  /// Badge text for beta app version
  ///
  /// In en, this message translates to:
  /// **'Beta'**
  String get versionStatusBeta;

  /// Badge text for outdated app version
  ///
  /// In en, this message translates to:
  /// **'Out-of-Date'**
  String get versionStatusOutdated;

  /// Title for maintenance mode dialog
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get maintenanceTitle;

  /// Title for news notification dialog
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get newsTitle;

  /// Title for emergency notification dialog
  ///
  /// In en, this message translates to:
  /// **'Important Notice'**
  String get emergencyNotificationTitle;

  /// OK button text
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

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

  /// Countdown message shown before taking a screenshot
  ///
  /// In en, this message translates to:
  /// **'Screenshot in {seconds}s'**
  String screenshotCountdown(int seconds);

  /// Label for scene preset selection
  ///
  /// In en, this message translates to:
  /// **'Scene Preset'**
  String get scenePreset;

  /// Tooltip for previous preset button
  ///
  /// In en, this message translates to:
  /// **'Previous preset'**
  String get previousPreset;

  /// Tooltip for next preset button
  ///
  /// In en, this message translates to:
  /// **'Next preset'**
  String get nextPreset;

  /// Button text to apply the selected scene preset
  ///
  /// In en, this message translates to:
  /// **'Apply Scene'**
  String get applyScene;

  /// Snackbar message when a preset is applied
  ///
  /// In en, this message translates to:
  /// **'Applied preset: {presetName}'**
  String appliedPreset(String presetName);

  /// Button text to deactivate screenshot mode
  ///
  /// In en, this message translates to:
  /// **'Deactivate'**
  String get deactivate;

  /// Message shown when a screenshot scene is active
  ///
  /// In en, this message translates to:
  /// **'Scene active - simulation paused for screenshot capture'**
  String get sceneActive;

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

  /// Emoji for learning objectives
  ///
  /// In en, this message translates to:
  /// **'🎯'**
  String get scenarioLearnEmoji;

  /// Emoji for best for section
  ///
  /// In en, this message translates to:
  /// **'⭐'**
  String get scenarioBestEmoji;

  /// Learning content for solar system scenario
  ///
  /// In en, this message translates to:
  /// **'Learn: Planetary motion, orbital mechanics, familiar celestial bodies'**
  String get scenarioLearnSolar;

  /// Best for content for solar system scenario
  ///
  /// In en, this message translates to:
  /// **'Best for: Beginners, astronomy enthusiasts'**
  String get scenarioBestSolar;

  /// Learning content for Earth-Moon scenario
  ///
  /// In en, this message translates to:
  /// **'Learn: Three-body dynamics, lunar mechanics, tidal forces'**
  String get scenarioLearnEarthMoon;

  /// Best for content for Earth-Moon scenario
  ///
  /// In en, this message translates to:
  /// **'Best for: Understanding Earth-Moon system'**
  String get scenarioBestEarthMoon;

  /// Learning content for binary star scenario
  ///
  /// In en, this message translates to:
  /// **'Learn: Stellar evolution, binary systems, extreme gravity'**
  String get scenarioLearnBinary;

  /// Best for content for binary star scenario
  ///
  /// In en, this message translates to:
  /// **'Best for: Advanced physics exploration'**
  String get scenarioBestBinary;

  /// Learning content for three-body scenario
  ///
  /// In en, this message translates to:
  /// **'Learn: Chaos theory, unpredictable motion, unstable systems'**
  String get scenarioLearnThreeBody;

  /// Best for content for three-body scenario
  ///
  /// In en, this message translates to:
  /// **'Best for: Mathematical physics enthusiasts'**
  String get scenarioBestThreeBody;

  /// Learning content for random scenario
  ///
  /// In en, this message translates to:
  /// **'Learn: Discover unknown configurations, experimental physics'**
  String get scenarioLearnRandom;

  /// Best for content for random scenario
  ///
  /// In en, this message translates to:
  /// **'Best for: Exploration and experimentation'**
  String get scenarioBestRandom;

  /// Label for privacy policy link
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicyLabel;

  /// Title for tutorial welcome step
  ///
  /// In en, this message translates to:
  /// **'Welcome to Graviton!'**
  String get tutorialWelcomeTitle;

  /// Description for tutorial welcome step
  ///
  /// In en, this message translates to:
  /// **'Welcome to Graviton, your window into the fascinating world of gravitational physics! This app lets you explore how celestial bodies interact through gravity, creating beautiful orbital dances across space and time.'**
  String get tutorialWelcomeDescription;

  /// Description text for the welcome message card
  ///
  /// In en, this message translates to:
  /// **'Explore gravitational physics through interactive simulations. Try different scenarios, adjust controls, and watch the cosmos unfold!'**
  String get welcomeCardDescription;

  /// Button text to start quick tutorial
  ///
  /// In en, this message translates to:
  /// **'Quick Tutorial'**
  String get quickTutorialButton;

  /// Button text to dismiss welcome card
  ///
  /// In en, this message translates to:
  /// **'Got it!'**
  String get gotItButton;

  /// Hint text for tutorial navigation
  ///
  /// In en, this message translates to:
  /// **'Swipe left/right or use buttons to navigate'**
  String get tutorialNavigationHint;

  /// Title for tutorial objectives step
  ///
  /// In en, this message translates to:
  /// **'What Can You Do?'**
  String get tutorialObjectivesTitle;

  /// Description for tutorial objectives step
  ///
  /// In en, this message translates to:
  /// **'• Observe realistic orbital mechanics\n• Explore different astronomical scenarios\n• Experiment with gravitational interactions\n• Watch collisions and mergers\n• Learn about planetary motion\n• Discover chaotic three-body dynamics'**
  String get tutorialObjectivesDescription;

  /// Title for tutorial controls step
  ///
  /// In en, this message translates to:
  /// **'Simulation Controls'**
  String get tutorialControlsTitle;

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

  /// Title for tutorial camera step
  ///
  /// In en, this message translates to:
  /// **'Camera & View Controls'**
  String get tutorialCameraTitle;

  /// Description for tutorial camera step
  ///
  /// In en, this message translates to:
  /// **'Drag to rotate your view, pinch to zoom, and use two fingers to roll the camera. The bottom bar has focus, center, and auto-rotation controls for a cinematic experience.'**
  String get tutorialCameraDescription;

  /// Title for tutorial scenarios step
  ///
  /// In en, this message translates to:
  /// **'Choose Your Adventure'**
  String get tutorialScenariosTitle;

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

  /// Title for tutorial final step
  ///
  /// In en, this message translates to:
  /// **'Ready to Explore!'**
  String get tutorialExploreTitle;

  /// Description for tutorial final step
  ///
  /// In en, this message translates to:
  /// **'You\'re all set! Start with the Solar System to see familiar planets, or dive into the Three-Body Problem for some chaotic fun. Remember: every reset creates a new universe to explore!'**
  String get tutorialExploreDescription;

  /// Button to skip tutorial
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skipTutorial;

  /// Previous button
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// Next button
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Final tutorial button to start using the app
  ///
  /// In en, this message translates to:
  /// **'Get Started!'**
  String get getStarted;

  /// Tooltip for tutorial button
  ///
  /// In en, this message translates to:
  /// **'Show Tutorial'**
  String get showTutorialTooltip;

  /// Title for help dialog
  ///
  /// In en, this message translates to:
  /// **'Help & Objectives'**
  String get helpAndObjectivesTitle;

  /// Title for what to do section
  ///
  /// In en, this message translates to:
  /// **'What to Do in Graviton'**
  String get whatToDoTitle;

  /// Description of what users can do
  ///
  /// In en, this message translates to:
  /// **'Graviton is a physics playground where you can:\n\n🪐 Explore realistic orbital mechanics\n🌟 Watch stellar evolution and collisions\n🎯 Learn about gravitational forces\n🎮 Experiment with different scenarios\n📚 Understand celestial dynamics\n🔄 Create endless random configurations'**
  String get whatToDoDescription;

  /// Title for learning objectives section
  ///
  /// In en, this message translates to:
  /// **'Learning Objectives'**
  String get objectivesTitle;

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

  /// Title for quick start section
  ///
  /// In en, this message translates to:
  /// **'Quick Start Guide'**
  String get quickStartTitle;

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

  /// Description of learning objectives (fallback for languages without individual items)
  ///
  /// In en, this message translates to:
  /// **'• Understand how gravity shapes the cosmos\n• Observe stable vs. chaotic orbital systems\n• Learn why planets move in elliptical orbits\n• Discover how binary stars interact\n• See what happens when objects collide\n• Appreciate the three-body problem\'s complexity'**
  String get objectivesDescription;

  /// Quick start instructions (fallback for languages without individual items)
  ///
  /// In en, this message translates to:
  /// **'1. Choose a scenario (Solar System recommended for beginners)\n2. Press Play to start the simulation\n3. Drag to rotate your view, pinch to zoom\n4. Tap the Speed slider to control time\n5. Try Reset for new random configurations\n6. Enable Trails to see orbital paths'**
  String get quickStartDescription;

  /// Tooltip for help button
  ///
  /// In en, this message translates to:
  /// **'Help & Objectives'**
  String get showHelpTooltip;

  /// Button to show tutorial
  ///
  /// In en, this message translates to:
  /// **'Tutorial'**
  String get tutorialButton;

  /// Button to reset tutorial state (debug only)
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get resetTutorialButton;

  /// Message shown when tutorial state is reset
  ///
  /// In en, this message translates to:
  /// **'Tutorial state reset! Restart app to see first-time experience.'**
  String get tutorialResetMessage;

  /// Button to copy text to clipboard
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copyButton;

  /// Error message when URL cannot be opened
  ///
  /// In en, this message translates to:
  /// **'Could not open {url}'**
  String couldNotOpenUrl(String url);

  /// Error message when link fails to open
  ///
  /// In en, this message translates to:
  /// **'Error opening link: {error}'**
  String errorOpeningLink(String error);

  /// Message shown when text is copied to clipboard
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard: {text}'**
  String copiedToClipboard(String text);

  /// Title for changelog dialog
  ///
  /// In en, this message translates to:
  /// **'What\'s New'**
  String get changelogTitle;

  /// Tooltip for close dialog button
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeDialog;

  /// Format for changelog release date
  ///
  /// In en, this message translates to:
  /// **'Released {date}'**
  String changelogReleaseDate(String date);

  /// Section header for added features
  ///
  /// In en, this message translates to:
  /// **'New Features'**
  String get changelogAdded;

  /// Section header for improvements
  ///
  /// In en, this message translates to:
  /// **'Improvements'**
  String get changelogImproved;

  /// Section header for bug fixes
  ///
  /// In en, this message translates to:
  /// **'Bug Fixes'**
  String get changelogFixed;

  /// Button to skip changelog
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get changelogSkip;

  /// Button to finish changelog
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get changelogDone;

  /// Button to show changelog dialog
  ///
  /// In en, this message translates to:
  /// **'Show Changelog'**
  String get changelogButton;

  /// Developer button to reset changelog state
  ///
  /// In en, this message translates to:
  /// **'Reset Changelog State'**
  String get resetChangelogButton;

  /// Message shown when changelog state is reset
  ///
  /// In en, this message translates to:
  /// **'Changelog state has been reset'**
  String get changelogResetMessage;

  /// Debug section title for changelog in settings
  ///
  /// In en, this message translates to:
  /// **'Changelog'**
  String get changelogDebugTitle;

  /// Error message when no changelog data is found
  ///
  /// In en, this message translates to:
  /// **'No changelog found. Add changelog data to Firestore first.\nCurrent version: {version}'**
  String changelogNotFoundError(String version);

  /// Error message when changelog fails to load
  ///
  /// In en, this message translates to:
  /// **'Failed to load changelog: {error}'**
  String changelogLoadError(String error);

  /// Message when no changelogs are available
  ///
  /// In en, this message translates to:
  /// **'No changelogs available'**
  String get noChangelogsAvailable;

  /// Error message when failing to load changelogs
  ///
  /// In en, this message translates to:
  /// **'Error loading changelogs: {error}'**
  String errorLoadingChangelogs(String error);

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

  /// Color description for white stars (A-type)
  ///
  /// In en, this message translates to:
  /// **'White'**
  String get stellarColorWhite;

  /// Color description for yellow-white stars (F-type)
  ///
  /// In en, this message translates to:
  /// **'Yellow-white'**
  String get stellarColorYellowWhite;

  /// Color description for yellow stars (G-type, like our Sun)
  ///
  /// In en, this message translates to:
  /// **'Yellow'**
  String get stellarColorYellow;

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

  /// Section title for orbital path visualization controls
  ///
  /// In en, this message translates to:
  /// **'Path Visualization'**
  String get pathVisualizationTitle;

  /// Section title for navigation assistance features
  ///
  /// In en, this message translates to:
  /// **'Navigation Aids'**
  String get navigationAidsTitle;

  /// Label for classic gravity field color scheme
  ///
  /// In en, this message translates to:
  /// **'Classic'**
  String get gravityFieldClassicLabel;

  /// Label for spectral gravity field color scheme
  ///
  /// In en, this message translates to:
  /// **'Spectral'**
  String get gravityFieldSpectralLabel;

  /// Label for monochrome gravity field color scheme
  ///
  /// In en, this message translates to:
  /// **'Monochrome'**
  String get gravityFieldMonochromeLabel;

  /// Label for neon gravity field color scheme
  ///
  /// In en, this message translates to:
  /// **'Neon'**
  String get gravityFieldNeonLabel;

  /// Label for emerald gravity field color scheme
  ///
  /// In en, this message translates to:
  /// **'Emerald'**
  String get gravityFieldEmeraldLabel;

  /// Description for app information and credits menu item
  ///
  /// In en, this message translates to:
  /// **'App information and credits'**
  String get appInformationCredits;

  /// Title for developer tools dialog
  ///
  /// In en, this message translates to:
  /// **'Developer Tools'**
  String get developerToolsTitle;

  /// Description for developer tools menu item
  ///
  /// In en, this message translates to:
  /// **'Debug tools for development'**
  String get developerToolsMenuDescription;

  /// Description for tutorial button
  ///
  /// In en, this message translates to:
  /// **'Interactive guided tour of the app'**
  String get tutorialDescription;

  /// Description for reset tutorial button
  ///
  /// In en, this message translates to:
  /// **'Reset tutorial progress'**
  String get resetTutorialDescription;

  /// Description for changelog button
  ///
  /// In en, this message translates to:
  /// **'View app updates and changes'**
  String get changelogDescription;

  /// Description for reset changelog button
  ///
  /// In en, this message translates to:
  /// **'Reset changelog read status'**
  String get resetChangelogDescription;

  /// Success message when tutorial is reset
  ///
  /// In en, this message translates to:
  /// **'Tutorial progress has been reset'**
  String get tutorialResetSuccess;

  /// Success message when changelog is reset
  ///
  /// In en, this message translates to:
  /// **'Changelog status has been reset'**
  String get changelogResetSuccess;

  /// Label for copyright information section
  ///
  /// In en, this message translates to:
  /// **'Copyright'**
  String get copyrightLabel;

  /// Copyright notice text
  ///
  /// In en, this message translates to:
  /// **'All rights reserved'**
  String get allRightsReserved;

  /// Display name for star body type
  ///
  /// In en, this message translates to:
  /// **'Star'**
  String get bodyTypeStar;

  /// Display name for planet body type
  ///
  /// In en, this message translates to:
  /// **'Planet'**
  String get bodyTypePlanet;

  /// Display name for moon body type
  ///
  /// In en, this message translates to:
  /// **'Moon'**
  String get bodyTypeMoon;

  /// Display name for asteroid body type
  ///
  /// In en, this message translates to:
  /// **'Asteroid'**
  String get bodyTypeAsteroid;

  /// Plural form for star body type with count
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 Star} other{{count} Stars}}'**
  String bodyTypeStarPlural(int count);

  /// Plural form for planet body type with count
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 Planet} other{{count} Planets}}'**
  String bodyTypePlanetPlural(int count);

  /// Plural form for moon body type with count
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 Moon} other{{count} Moons}}'**
  String bodyTypeMoonPlural(int count);

  /// Plural form for asteroid body type with count
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 Asteroid} other{{count} Asteroids}}'**
  String bodyTypeAsteroidPlural(int count);

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

  /// Display name for error notification type
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get notificationTypeError;

  /// Display name for warning notification type
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get notificationTypeWarning;

  /// Display name for info notification type
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get notificationTypeInfo;

  /// Display name for success notification type
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get notificationTypeSuccess;

  /// Display name for debug notification type
  ///
  /// In en, this message translates to:
  /// **'Debug'**
  String get notificationTypeDebug;

  /// Display name for full tracking mode
  ///
  /// In en, this message translates to:
  /// **'Full Tracking'**
  String get trackingModeFull;

  /// Display name for essential tracking mode
  ///
  /// In en, this message translates to:
  /// **'Essential Only'**
  String get trackingModeEssential;

  /// Display name for no tracking mode
  ///
  /// In en, this message translates to:
  /// **'No Tracking'**
  String get trackingModeNone;

  /// Display name for limited tracking mode
  ///
  /// In en, this message translates to:
  /// **'Limited Tracking'**
  String get trackingModeLimited;

  /// Description for full tracking mode
  ///
  /// In en, this message translates to:
  /// **'All analytics, crashes, and interactions'**
  String get trackingModeFullDescription;

  /// Description for essential tracking mode
  ///
  /// In en, this message translates to:
  /// **'Critical crashes and errors only'**
  String get trackingModeEssentialDescription;

  /// Description for no tracking mode
  ///
  /// In en, this message translates to:
  /// **'No data collection'**
  String get trackingModeNoneDescription;

  /// Description for limited tracking mode
  ///
  /// In en, this message translates to:
  /// **'User interactions only'**
  String get trackingModeLimitedDescription;

  /// Display name for added changelog category
  ///
  /// In en, this message translates to:
  /// **'Added'**
  String get changelogCategoryAdded;

  /// Display name for improved changelog category
  ///
  /// In en, this message translates to:
  /// **'Improved'**
  String get changelogCategoryImproved;

  /// Display name for fixed changelog category
  ///
  /// In en, this message translates to:
  /// **'Fixed'**
  String get changelogCategoryFixed;

  /// Display name for manual camera technique
  ///
  /// In en, this message translates to:
  /// **'Manual Control'**
  String get cameraManual;

  /// Display name for predictive orbital camera technique
  ///
  /// In en, this message translates to:
  /// **'Predictive Orbital'**
  String get cameraPredictiveOrbital;

  /// Display name for dynamic framing camera technique
  ///
  /// In en, this message translates to:
  /// **'Dynamic Framing'**
  String get cameraDynamicFraming;

  /// Description for manual camera technique
  ///
  /// In en, this message translates to:
  /// **'Traditional manual camera controls with follow mode'**
  String get cameraManualDescription;

  /// Description for predictive orbital camera technique
  ///
  /// In en, this message translates to:
  /// **'AI predicts orbital paths for dramatic camera movements'**
  String get cameraPredictiveOrbitalDescription;

  /// Description for dynamic framing camera technique
  ///
  /// In en, this message translates to:
  /// **'Automatically adjusts framing based on scene content'**
  String get cameraDynamicFramingDescription;

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

  /// Hint text for fullscreen toggle gesture
  ///
  /// In en, this message translates to:
  /// **'Tap to toggle fullscreen'**
  String get tapToToggleFullscreen;

  /// Hint shown when in fullscreen mode
  ///
  /// In en, this message translates to:
  /// **'Tap anywhere to exit fullscreen'**
  String get exitFullscreenHint;

  /// Accessibility label for the main simulation canvas
  ///
  /// In en, this message translates to:
  /// **'Gravitational Physics Simulation'**
  String get simulationCanvasLabel;

  /// Accessibility hint for simulation canvas interactions
  ///
  /// In en, this message translates to:
  /// **'Use keyboard shortcuts to control simulation. Space to pause, R to reset, C to center camera'**
  String get simulationCanvasHint;

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

  /// Accessibility description when simulation is empty
  ///
  /// In en, this message translates to:
  /// **'No celestial bodies currently in the simulation'**
  String get noBodiesInSimulation;

  /// Description of bodies currently in simulation
  ///
  /// In en, this message translates to:
  /// **'Bodies in simulation: {descriptions}'**
  String bodiesInSimulation(String descriptions);

  /// Description of camera in free movement mode
  ///
  /// In en, this message translates to:
  /// **'Camera in free mode at distance {distance}. Auto-rotation: {rotation}'**
  String cameraFreeDescription(String distance, String rotation);

  /// Description of camera in follow mode
  ///
  /// In en, this message translates to:
  /// **'Camera following {bodyName} at distance {distance}. Auto-rotation: {rotation}'**
  String cameraFollowingDescription(
    String bodyName,
    String distance,
    String rotation,
  );

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

  /// Live region announcement for value changes
  ///
  /// In en, this message translates to:
  /// **'{updateType} changed to {value}'**
  String liveUpdateAnnouncement(String updateType, String value);

  /// Hint about available keyboard shortcuts
  ///
  /// In en, this message translates to:
  /// **'Use Space to pause/resume, R to reset, C to center camera, A to toggle auto-rotation'**
  String get keyboardShortcutsHint;

  /// Accessibility description of physics statistics
  ///
  /// In en, this message translates to:
  /// **'Physics: {time} time units, {earthYears} Earth years, {steps} simulation steps completed'**
  String physicsStatsDescription(String time, String earthYears, int steps);

  /// Semantic action label for toggling camera auto-rotation
  ///
  /// In en, this message translates to:
  /// **'Toggle auto-rotation'**
  String get toggleAutoRotateAction;

  /// Semantic action label for zooming in
  ///
  /// In en, this message translates to:
  /// **'Zoom in'**
  String get zoomInAction;

  /// Semantic action label for zooming out
  ///
  /// In en, this message translates to:
  /// **'Zoom out'**
  String get zoomOutAction;

  /// State description for expanded UI elements
  ///
  /// In en, this message translates to:
  /// **'expanded'**
  String get expandedState;

  /// State description for collapsed UI elements
  ///
  /// In en, this message translates to:
  /// **'collapsed'**
  String get collapsedState;

  /// Label for the currently selected scenario
  ///
  /// In en, this message translates to:
  /// **'Current scenario'**
  String get currentScenario;

  /// Text indicating number of scenarios available
  ///
  /// In en, this message translates to:
  /// **'scenarios available'**
  String get scenariosAvailable;

  /// Accessibility label for bottom sheet component
  ///
  /// In en, this message translates to:
  /// **'Bottom sheet'**
  String get bottomSheetLabel;

  /// Main accessibility label for the physics simulation
  ///
  /// In en, this message translates to:
  /// **'Gravitational Physics Simulation'**
  String get gravitationalSimulationLabel;

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

  /// Accessibility announcement for speed changes
  ///
  /// In en, this message translates to:
  /// **'Simulation speed changed to {newValue}'**
  String accessibilitySpeedChange(String newValue);

  /// Accessibility announcement for gravity changes
  ///
  /// In en, this message translates to:
  /// **'Gravity strength changed to {newValue}'**
  String accessibilityGravityChange(String newValue);

  /// Accessibility announcement for collision radius changes
  ///
  /// In en, this message translates to:
  /// **'Collision sensitivity changed to {newValue}'**
  String accessibilityCollisionRadiusChange(String newValue);

  /// Accessibility announcement for camera reset
  ///
  /// In en, this message translates to:
  /// **'Camera view reset to default position'**
  String get accessibilityCameraReset;

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

  /// Accessibility announcement when camera stops following
  ///
  /// In en, this message translates to:
  /// **'Camera stopped following celestial body'**
  String get accessibilityCameraUnfollow;

  /// Accessibility announcement for tutorial progress
  ///
  /// In en, this message translates to:
  /// **'Tutorial step {currentStep} of {totalSteps}: {stepName}'**
  String accessibilityTutorialProgress(
    int currentStep,
    int totalSteps,
    String stepName,
  );

  /// Accessibility announcement for error messages
  ///
  /// In en, this message translates to:
  /// **'Error: {errorMessage}'**
  String accessibilityError(String errorMessage);

  /// Accessibility announcement when a setting is enabled
  ///
  /// In en, this message translates to:
  /// **'{settingName} enabled'**
  String accessibilitySettingEnabled(String settingName);

  /// Accessibility announcement when a setting is disabled
  ///
  /// In en, this message translates to:
  /// **'{settingName} disabled'**
  String accessibilitySettingDisabled(String settingName);
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
