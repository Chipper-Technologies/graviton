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

  /// Title for the settings dialog
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Tooltip for the settings button in the app bar
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTooltip;

  /// Tooltip for the scenario selection button in the app bar
  ///
  /// In en, this message translates to:
  /// **'Select Scenario'**
  String get selectScenarioTooltip;

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
  /// **'Chipper Technologies, LLC'**
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

  /// Name for stars with number
  ///
  /// In en, this message translates to:
  /// **'Star {number}'**
  String bodyStar(int number);

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

  /// Label for privacy policy link
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicyLabel;
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
