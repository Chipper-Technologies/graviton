// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Graviton';

  @override
  String get playButton => 'Play';

  @override
  String get pauseButton => 'Pause';

  @override
  String get resetButton => 'Reset';

  @override
  String get speedLabel => 'Speed';

  @override
  String get trailsLabel => 'Trails';

  @override
  String get statsLabel => 'Stats';

  @override
  String get selectLabel => 'Select';

  @override
  String get followLabel => 'Follow';

  @override
  String get centerLabel => 'Center';

  @override
  String get rotateLabel => 'Rotate';

  @override
  String get warmTrails => '🔥 Warm';

  @override
  String get coolTrails => '❄️ Cool';

  @override
  String get toggleStatsTooltip => 'Toggle Stats';

  @override
  String get toggleLabelsTooltip => 'Toggle Body Labels';

  @override
  String get showLabelsDescription =>
      'Show celestial body names in the simulation';

  @override
  String get offScreenIndicatorsTitle => 'Off-Screen Indicators';

  @override
  String get offScreenIndicatorsDescription =>
      'Show arrows pointing to objects outside the visible area';

  @override
  String get autoRotateTooltip => 'Auto Rotate';

  @override
  String get centerViewTooltip => 'Center View';

  @override
  String get focusOnNearestTooltip => 'Focus on Nearest Body';

  @override
  String get followObjectTooltip => 'Follow Selected Object';

  @override
  String get stopFollowingTooltip => 'Stop Following Object';

  @override
  String get selectObjectToFollowTooltip => 'Select Object to Follow';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsTooltip => 'Settings';

  @override
  String get selectScenarioTooltip => 'Select Scenario';

  @override
  String get moreOptionsTooltip => 'More options';

  @override
  String get physicsSettingsTitle => 'Physics Settings';

  @override
  String get physicsSettingsDescription => 'Simulation parameters';

  @override
  String get physicsSection => 'Physics';

  @override
  String get gravitationalConstant => 'Gravitational Constant';

  @override
  String get softeningParameter => 'Softening Parameter';

  @override
  String get simulationSpeed => 'Simulation Speed';

  @override
  String get collisionsSection => 'Collisions';

  @override
  String get collisionSensitivity => 'Collision Sensitivity';

  @override
  String get trailsSection => 'Trails';

  @override
  String get trailLength => 'Trail Length';

  @override
  String get trailFadeRate => 'Trail Fade Rate';

  @override
  String get hapticsSection => 'Haptics';

  @override
  String get vibrationEnabled => 'Vibration Enabled';

  @override
  String get hapticFeedbackCollisions => 'Haptic feedback on collisions';

  @override
  String get vibrationThrottle => 'Vibration Throttle';

  @override
  String get scenariosMenuDescription => 'Explore different scenarios';

  @override
  String get settingsMenuDescription => 'Visual & behavior options';

  @override
  String get helpMenuDescription => 'Tutorial & objectives';

  @override
  String get showTrails => 'Show Trails';

  @override
  String get showTrailsDescription => 'Display motion trails behind objects';

  @override
  String get showOrbitalPaths => 'Show Orbital Paths';

  @override
  String get showOrbitalPathsDescription =>
      'Display predicted orbital paths in scenarios with stable orbits';

  @override
  String get dualOrbitalPaths => 'Dual Orbital Paths';

  @override
  String get dualOrbitalPathsDescription =>
      'Show both ideal circular and actual elliptical orbital paths';

  @override
  String get trailColorLabel => 'Trail Color';

  @override
  String get colorsLabel => 'Colors';

  @override
  String get realisticColors => 'Realistic Colors';

  @override
  String get realisticColorsDescription =>
      'Use scientifically accurate colors based on temperature and stellar classification';

  @override
  String get closeButton => 'Close';

  @override
  String get simulationStats => 'Simulation Stats';

  @override
  String get stepsLabel => 'Steps';

  @override
  String get timeLabel => 'Time';

  @override
  String get earthYearsLabel => 'Earth Years';

  @override
  String get speedStatsLabel => 'Speed';

  @override
  String get bodiesLabel => 'Bodies';

  @override
  String get statusLabel => 'Status';

  @override
  String get statusRunning => 'Running';

  @override
  String get statusPaused => 'Paused';

  @override
  String get cameraLabel => 'Camera';

  @override
  String get distanceLabel => 'Distance';

  @override
  String get autoRotateLabel => 'Auto-rotate';

  @override
  String get autoRotateOn => 'On';

  @override
  String get autoRotateOff => 'Off';

  @override
  String get cameraControlsLabel => 'Camera Controls';

  @override
  String get invertPitchControlsLabel => 'Invert Pitch Controls';

  @override
  String get invertPitchControlsDescription => 'Reverse up/down drag direction';

  @override
  String get cinematicCameraTechniqueLabel => 'AI Camera Technique';

  @override
  String get cinematicCameraTechniqueDescription =>
      'Choose how AI controls the camera when following objects';

  @override
  String get cinematicTechniqueManual => 'Manual Control';

  @override
  String get cinematicTechniqueManualDesc =>
      'Traditional manual camera controls with follow mode';

  @override
  String get cinematicTechniquePredictiveOrbital => 'Predictive Orbital';

  @override
  String get cinematicTechniquePredictiveOrbitalDesc =>
      'AI tours and orbital predictions for educational scenarios';

  @override
  String get cinematicTechniqueDynamicFraming => 'Dynamic Framing';

  @override
  String get cinematicTechniqueDynamicFramingDesc =>
      'Real-time dramatic targeting for chaotic scenarios';

  @override
  String get marketingLabel => 'Marketing';

  @override
  String stepsCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString';
  }

  @override
  String timeFormatted(String time) {
    return '${time}s';
  }

  @override
  String earthYearsFormatted(String years) {
    return '$years yr';
  }

  @override
  String speedFormatted(String speed) {
    return '${speed}x';
  }

  @override
  String bodiesCount(int count) {
    return '$count';
  }

  @override
  String distanceFormatted(String distance) {
    return '$distance';
  }

  @override
  String get scenarioSelectionTitle => 'Select Scenario';

  @override
  String get cancel => 'Cancel';

  @override
  String get bodies => 'bodies';

  @override
  String get scenarioRandom => 'Random System';

  @override
  String get scenarioRandomDescription =>
      'Randomly generated chaotic three-body system with unpredictable dynamics';

  @override
  String get scenarioEarthMoonSun => 'Earth-Moon-Sun';

  @override
  String get scenarioEarthMoonSunDescription =>
      'Educational simulation of our familiar Earth-Moon-Sun system';

  @override
  String get scenarioBinaryStars => 'Binary Stars';

  @override
  String get scenarioBinaryStarsDescription =>
      'Two massive stars orbiting each other with circumbinary planets';

  @override
  String get scenarioAsteroidBelt => 'Asteroid Belt';

  @override
  String get scenarioAsteroidBeltDescription =>
      'Central star surrounded by a belt of rocky asteroids and debris';

  @override
  String get scenarioGalaxyFormation => 'Galaxy Formation';

  @override
  String get scenarioGalaxyFormationDescription =>
      'Watch matter organize into spiral structures around a central black hole';

  @override
  String get scenarioPlanetaryRings => 'Planetary Rings';

  @override
  String get scenarioPlanetaryRingsDescription =>
      'Ring system dynamics around a massive planet like Saturn';

  @override
  String get scenarioSolarSystem => 'Solar System';

  @override
  String get scenarioSolarSystemDescription =>
      'Simplified version of our solar system with inner and outer planets';

  @override
  String get habitabilityLabel => 'Habitability';

  @override
  String get habitableZonesLabel => 'Habitable Zones';

  @override
  String get habitabilityIndicatorsLabel => 'Planet Status';

  @override
  String get habitabilityHabitable => 'Habitable';

  @override
  String get habitabilityTooHot => 'Too Hot';

  @override
  String get habitabilityTooCold => 'Too Cold';

  @override
  String get habitabilityUnknown => 'Unknown';

  @override
  String get temperatureFrozen => 'Frozen';

  @override
  String get temperatureCold => 'Cold';

  @override
  String get temperatureModerate => 'Moderate';

  @override
  String get temperatureHot => 'Hot';

  @override
  String get temperatureScorching => 'Scorching';

  @override
  String get temperatureNotApplicable => 'N/A';

  @override
  String get temperatureUnitCelsius => '°C';

  @override
  String get temperatureUnitKelvin => 'K';

  @override
  String get temperatureUnitFahrenheit => '°F';

  @override
  String get toggleHabitableZonesTooltip => 'Toggle Habitable Zones';

  @override
  String get toggleHabitabilityIndicatorsTooltip =>
      'Toggle Planet Habitability Status';

  @override
  String get habitableZonesDescription =>
      'Show colored zones around stars indicating habitable regions';

  @override
  String get habitabilityIndicatorsDescription =>
      'Display color-coded status rings around planets based on their habitability';

  @override
  String get aboutDialogTitle => 'About';

  @override
  String get appDescription =>
      'A physics simulation exploring gravitational dynamics and orbital mechanics. Experience the beauty and complexity of celestial motion through interactive 3D visualization.';

  @override
  String get authorLabel => 'Author';

  @override
  String get websiteLabel => 'Website';

  @override
  String get aboutButtonTooltip => 'About';

  @override
  String get appNameGraviton => 'Graviton';

  @override
  String get versionLabel => 'Version';

  @override
  String get loadingVersion => 'Loading version...';

  @override
  String get companyName => 'Chipper Technologies, LLC';

  @override
  String get gravityWellsLabel => 'Gravity Wells';

  @override
  String get gravityWellsDescription =>
      'Show gravitational field strength around objects';

  @override
  String get languageLabel => 'Language';

  @override
  String get languageDescription => 'Change the app language';

  @override
  String get languageSystem => 'System Default';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageChinese => '中文';

  @override
  String get languageJapanese => '日本語';

  @override
  String get languageKorean => '한국어';

  @override
  String get bodyAlpha => 'Alpha';

  @override
  String get bodyBeta => 'Beta';

  @override
  String get bodyGamma => 'Gamma';

  @override
  String get bodyRockyPlanet => 'Rocky Planet';

  @override
  String get bodyEarthLike => 'Earth-like';

  @override
  String get bodySuperEarth => 'Super-Earth';

  @override
  String get bodySun => 'Sun';

  @override
  String get bodyPropertiesTitle => 'Body Properties';

  @override
  String get bodyPropertiesName => 'Name';

  @override
  String get bodyPropertiesNameHint => 'Enter body name';

  @override
  String get bodyPropertiesType => 'Body Type';

  @override
  String get bodyPropertiesColor => 'Color';

  @override
  String get bodyPropertiesMass => 'Mass';

  @override
  String get bodyPropertiesRadius => 'Radius';

  @override
  String get bodyPropertiesLuminosity => 'Stellar Luminosity';

  @override
  String get bodyPropertiesVelocity => 'Velocity';

  @override
  String get bodyPropertiesAxisX => 'X:';

  @override
  String get bodyPropertiesAxisY => 'Y:';

  @override
  String get bodyPropertiesAxisZ => 'Z:';

  @override
  String get bodyEarth => 'Earth';

  @override
  String get bodyMoon => 'Moon';

  @override
  String get bodyStarA => 'Star A';

  @override
  String get bodyStarB => 'Star B';

  @override
  String get bodyPlanetP => 'Planet P';

  @override
  String get bodyMoonM => 'Moon M';

  @override
  String get bodyCentralStar => 'Central Star';

  @override
  String bodyAsteroid(int number) {
    return 'Asteroid $number';
  }

  @override
  String get bodyBlackHole => 'Black Hole';

  @override
  String get bodyRingedPlanet => 'Ringed Planet';

  @override
  String bodyRing(int number) {
    return 'Ring $number';
  }

  @override
  String get bodyMercury => 'Mercury';

  @override
  String get bodyVenus => 'Venus';

  @override
  String get bodyMars => 'Mars';

  @override
  String get bodyJupiter => 'Jupiter';

  @override
  String get bodySaturn => 'Saturn';

  @override
  String get bodyUranus => 'Uranus';

  @override
  String get bodyNeptune => 'Neptune';

  @override
  String get bodyInnerPlanet => 'Inner Planet';

  @override
  String get bodyOuterPlanet => 'Outer Planet';

  @override
  String get bodyCenterOfMass => 'Center of Mass';

  @override
  String bodyStarNumber(int number) {
    return 'Star $number';
  }

  @override
  String get educationalFocusChaoticDynamics => 'chaotic dynamics';

  @override
  String get educationalFocusRealWorldSystem => 'real-world system';

  @override
  String get educationalFocusBinaryOrbits => 'binary orbits';

  @override
  String get educationalFocusManyBodyDynamics => 'many-body dynamics';

  @override
  String get educationalFocusStructureFormation => 'structure formation';

  @override
  String get educationalFocusPlanetaryMotion => 'planetary motion';

  @override
  String get updateRequiredTitle => 'Update Required';

  @override
  String get updateRequiredMessage =>
      'A newer version of this app is available. Please update to continue using the app with the latest features and improvements.';

  @override
  String get updateRequiredWarning => 'This version is no longer supported.';

  @override
  String get updateNow => 'Update Now';

  @override
  String get updateLater => 'Later';

  @override
  String get versionStatusCurrent => 'Current';

  @override
  String get versionStatusBeta => 'Beta';

  @override
  String get versionStatusOutdated => 'Out-of-Date';

  @override
  String get maintenanceTitle => 'Maintenance';

  @override
  String get newsTitle => 'News';

  @override
  String get emergencyNotificationTitle => 'Important Notice';

  @override
  String get ok => 'OK';

  @override
  String get screenshotMode => 'Screenshot Mode';

  @override
  String get screenshotModeSubtitle =>
      'Enable preset scenes for capturing marketing screenshots';

  @override
  String get hideUIInScreenshotMode => 'Hide Navigation';

  @override
  String get hideUIInScreenshotModeSubtitle =>
      'Hide app bar, bottom navigation, and copyright when screenshot mode is active';

  @override
  String get scenePreset => 'Scene Preset';

  @override
  String get previousPreset => 'Previous preset';

  @override
  String get nextPreset => 'Next preset';

  @override
  String get applyScene => 'Apply Scene';

  @override
  String appliedPreset(String presetName) {
    return 'Applied preset: $presetName';
  }

  @override
  String get deactivate => 'Deactivate';

  @override
  String get sceneActive =>
      'Scene active - simulation paused for screenshot capture';

  @override
  String get presetGalaxyFormationOverview => 'Galaxy Formation Overview';

  @override
  String get presetGalaxyFormationOverviewDesc =>
      'Wide view of spiral galaxy formation with cosmic background';

  @override
  String get presetGalaxyCoreDetail => 'Galaxy Core Detail';

  @override
  String get presetGalaxyCoreDetailDesc =>
      'Close-up of bright galactic center with accretion disk';

  @override
  String get presetGalaxyBlackHole => 'Galaxy Black Hole';

  @override
  String get presetGalaxyBlackHoleDesc =>
      'Close-up view of supermassive black hole at galactic center';

  @override
  String get presetCompleteSolarSystem => 'Complete Solar System';

  @override
  String get presetCompleteSolarSystemDesc =>
      'All planets visible with beautiful orbital trails';

  @override
  String get presetInnerSolarSystem => 'Inner Solar System';

  @override
  String get presetInnerSolarSystemDesc =>
      'Close-up of Mercury, Venus, Earth, and Mars with habitable zone indicator';

  @override
  String get presetEarthView => 'Earth View';

  @override
  String get presetEarthViewDesc =>
      'Close-up perspective of Earth with atmospheric detail';

  @override
  String get presetSaturnRings => 'Saturn\'s Majestic Rings';

  @override
  String get presetSaturnRingsDesc =>
      'Close-up of Saturn with detailed ring system';

  @override
  String get presetEarthMoonSystem => 'Earth-Moon System';

  @override
  String get presetEarthMoonSystemDesc =>
      'Earth and Moon with visible orbital mechanics';

  @override
  String get presetBinaryStarDrama => 'Binary Star Drama';

  @override
  String get presetBinaryStarDramaDesc =>
      'Front view of two massive stars in gravitational dance';

  @override
  String get presetBinaryStarPlanetMoon => 'Binary Star Planet & Moon';

  @override
  String get presetBinaryStarPlanetMoonDesc =>
      'Planet and moon orbiting in chaotic binary star system';

  @override
  String get presetAsteroidBeltChaos => 'Asteroid Belt Chaos';

  @override
  String get presetAsteroidBeltChaosDesc =>
      'Dense asteroid field with gravitational effects';

  @override
  String get presetThreeBodyBallet => 'Three-Body Ballet';

  @override
  String get presetThreeBodyBalletDesc =>
      'Classic three-body problem in elegant motion';

  @override
  String get scenarioLearnEmoji => '🎯';

  @override
  String get scenarioBestEmoji => '⭐';

  @override
  String get scenarioLearnSolar =>
      'Learn: Planetary motion, orbital mechanics, familiar celestial bodies';

  @override
  String get scenarioBestSolar => 'Best for: Beginners, astronomy enthusiasts';

  @override
  String get scenarioLearnEarthMoon =>
      'Learn: Three-body dynamics, lunar mechanics, tidal forces';

  @override
  String get scenarioBestEarthMoon =>
      'Best for: Understanding Earth-Moon system';

  @override
  String get scenarioLearnBinary =>
      'Learn: Stellar evolution, binary systems, extreme gravity';

  @override
  String get scenarioBestBinary => 'Best for: Advanced physics exploration';

  @override
  String get scenarioLearnThreeBody =>
      'Learn: Chaos theory, unpredictable motion, unstable systems';

  @override
  String get scenarioBestThreeBody =>
      'Best for: Mathematical physics enthusiasts';

  @override
  String get scenarioLearnRandom =>
      'Learn: Discover unknown configurations, experimental physics';

  @override
  String get scenarioBestRandom => 'Best for: Exploration and experimentation';

  @override
  String get privacyPolicyLabel => 'Privacy Policy';

  @override
  String get tutorialWelcomeTitle => 'Welcome to Graviton!';

  @override
  String get tutorialWelcomeDescription =>
      'Welcome to Graviton, your window into the fascinating world of gravitational physics! This app lets you explore how celestial bodies interact through gravity, creating beautiful orbital dances across space and time.';

  @override
  String get welcomeCardDescription =>
      'Explore gravitational physics through interactive simulations. Try different scenarios, adjust controls, and watch the cosmos unfold!';

  @override
  String get quickTutorialButton => 'Quick Tutorial';

  @override
  String get gotItButton => 'Got it!';

  @override
  String get tutorialNavigationHint =>
      'Swipe left/right or use buttons to navigate';

  @override
  String get tutorialObjectivesTitle => 'What Can You Do?';

  @override
  String get tutorialObjectivesDescription =>
      '• Observe realistic orbital mechanics\n• Explore different astronomical scenarios\n• Experiment with gravitational interactions\n• Watch collisions and mergers\n• Learn about planetary motion\n• Discover chaotic three-body dynamics';

  @override
  String get tutorialControlsTitle => 'Simulation Controls';

  @override
  String get tutorialControlsDescription =>
      'Tap anywhere to bring up the floating Play/Pause controls for the simulation. The speed control is in the top-right corner. Tap the menu (⋮) for scenarios, settings, and physics adjustments.';

  @override
  String get tutorialControlsDescriptionPart1 =>
      'Tap anywhere to bring up the floating Play/Pause controls for the simulation. The speed control is in the top-right corner. Tap the menu';

  @override
  String get tutorialControlsDescriptionPart2 =>
      'for scenarios, settings, and physics adjustments.';

  @override
  String get tutorialCameraTitle => 'Camera & View Controls';

  @override
  String get tutorialCameraDescription =>
      'Drag to rotate your view, pinch to zoom, and use two fingers to roll the camera. The bottom bar has focus, center, and auto-rotation controls for a cinematic experience.';

  @override
  String get tutorialScenariosTitle => 'Choose Your Adventure';

  @override
  String get tutorialScenariosDescription =>
      'Access the menu (⋮) in the top-right to explore different scenarios: our Solar System, Earth-Moon dynamics, Binary Stars, or the chaotic Three-Body Problem. Each offers unique physics to discover!';

  @override
  String get tutorialScenariosDescriptionPart1 => 'Access the menu';

  @override
  String get tutorialScenariosDescriptionPart2 =>
      'in the top-right to explore different scenarios: our Solar System, Earth-Moon dynamics, Binary Stars, or the chaotic Three-Body Problem. Each offers unique physics to discover!';

  @override
  String get tutorialExploreTitle => 'Ready to Explore!';

  @override
  String get tutorialExploreDescription =>
      'You\'re all set! Start with the Solar System to see familiar planets, or dive into the Three-Body Problem for some chaotic fun. Remember: every reset creates a new universe to explore!';

  @override
  String get skipTutorial => 'Skip';

  @override
  String get previous => 'Previous';

  @override
  String get next => 'Next';

  @override
  String get getStarted => 'Get Started!';

  @override
  String get showTutorialTooltip => 'Show Tutorial';

  @override
  String get helpAndObjectivesTitle => 'Help & Objectives';

  @override
  String get whatToDoTitle => 'What to Do in Graviton';

  @override
  String get whatToDoDescription =>
      'Graviton is a physics playground where you can:\n\n🪐 Explore realistic orbital mechanics\n🌟 Watch stellar evolution and collisions\n🎯 Learn about gravitational forces\n🎮 Experiment with different scenarios\n📚 Understand celestial dynamics\n🔄 Create endless random configurations';

  @override
  String get objectivesTitle => 'Learning Objectives';

  @override
  String get objectives1 => 'Understand how gravity shapes the cosmos';

  @override
  String get objectives2 => 'Observe stable vs. chaotic orbital systems';

  @override
  String get objectives3 => 'Learn why planets move in elliptical orbits';

  @override
  String get objectives4 => 'Discover how binary stars interact';

  @override
  String get objectives5 => 'See what happens when objects collide';

  @override
  String get objectives6 => 'Appreciate the three-body problem\'s complexity';

  @override
  String get quickStartTitle => 'Quick Start Guide';

  @override
  String get quickStart1 =>
      'Choose a scenario (Solar System recommended for beginners)';

  @override
  String get quickStart2 => 'Press Play to start the simulation';

  @override
  String get quickStart3 => 'Drag to rotate your view, pinch to zoom';

  @override
  String get quickStart4 => 'Tap the Speed slider to control time';

  @override
  String get quickStart5 => 'Try Reset for new random configurations';

  @override
  String get quickStart6 => 'Enable Trails to see orbital paths';

  @override
  String get objectivesDescription =>
      '• Understand how gravity shapes the cosmos\n• Observe stable vs. chaotic orbital systems\n• Learn why planets move in elliptical orbits\n• Discover how binary stars interact\n• See what happens when objects collide\n• Appreciate the three-body problem\'s complexity';

  @override
  String get quickStartDescription =>
      '1. Choose a scenario (Solar System recommended for beginners)\n2. Press Play to start the simulation\n3. Drag to rotate your view, pinch to zoom\n4. Tap the Speed slider to control time\n5. Try Reset for new random configurations\n6. Enable Trails to see orbital paths';

  @override
  String get showHelpTooltip => 'Help & Objectives';

  @override
  String get tutorialButton => 'Tutorial';

  @override
  String get resetTutorialButton => 'Reset';

  @override
  String get tutorialResetMessage =>
      'Tutorial state reset! Restart app to see first-time experience.';

  @override
  String get copyButton => 'Copy';

  @override
  String couldNotOpenUrl(String url) {
    return 'Could not open $url';
  }

  @override
  String errorOpeningLink(String error) {
    return 'Error opening link: $error';
  }

  @override
  String copiedToClipboard(String text) {
    return 'Copied to clipboard: $text';
  }

  @override
  String get changelogTitle => 'What\'s New';

  @override
  String get closeDialog => 'Close';

  @override
  String changelogReleaseDate(String date) {
    return 'Released $date';
  }

  @override
  String get changelogAdded => 'New Features';

  @override
  String get changelogImproved => 'Improvements';

  @override
  String get changelogFixed => 'Bug Fixes';

  @override
  String get changelogSkip => 'Skip';

  @override
  String get changelogDone => 'Done';

  @override
  String get changelogButton => 'Show Changelog';

  @override
  String get resetChangelogButton => 'Reset Changelog State';

  @override
  String get changelogResetMessage => 'Changelog state has been reset';
}
