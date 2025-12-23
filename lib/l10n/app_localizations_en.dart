// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appDescription =>
      'A physics simulation exploring gravitational dynamics and orbital mechanics. Experience the beauty and complexity of celestial motion through interactive 3D visualization.';

  @override
  String get appFlavorDevelopment => 'Development';

  @override
  String get appFlavorProduction => 'Production';

  @override
  String get appInformationCredits => 'App information and credits';

  @override
  String get appTitle => 'Graviton';

  @override
  String get backButtonTooltip => 'Back';

  @override
  String get bottomNavVisualsLabel => 'Visuals';

  @override
  String get collisionHapticFeedbackDescription =>
      'Enable haptic feedback when celestial bodies collide during simulation';

  @override
  String get exitFullscreenHint => 'Tap anywhere to exit fullscreen';

  @override
  String get fullscreenMode => 'Fullscreen Mode';

  @override
  String get fullscreenModeDescription =>
      'Hide all UI elements for immersive viewing';

  @override
  String get hapticFeedbackCollisions => 'Haptic feedback on collisions';

  @override
  String get hapticFeedbackDescription =>
      'Enable haptic feedback for UI interactions and collisions';

  @override
  String get uiHapticFeedbackDescription =>
      'Enable haptic feedback for UI interactions like button taps, toggles, and navigation';

  @override
  String get displayOptionsTitle => 'Display Options';

  @override
  String get pauseButton => 'Pause';

  @override
  String get playButton => 'Play';

  @override
  String get presetAsteroidBeltChaos => 'Asteroid Belt Chaos';

  @override
  String get presetAsteroidBeltChaosDesc =>
      'Dense asteroid field with gravitational effects';

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
  String get presetCompleteSolarSystem => 'Complete Solar System';

  @override
  String get presetCompleteSolarSystemDesc =>
      'All planets visible with beautiful orbital trails';

  @override
  String get presetEarthMoonSystem => 'Earth-Moon System';

  @override
  String get presetEarthMoonSystemDesc =>
      'Earth and Moon with visible orbital mechanics';

  @override
  String get presetEarthView => 'Earth View';

  @override
  String get presetEarthViewDesc =>
      'Close-up perspective of Earth with atmospheric detail';

  @override
  String get presetGalaxyBlackHole => 'Galaxy Black Hole';

  @override
  String get presetGalaxyBlackHoleDesc =>
      'Close-up view of supermassive black hole at galactic center';

  @override
  String get presetGalaxyCoreDetail => 'Galaxy Core Detail';

  @override
  String get presetGalaxyCoreDetailDesc =>
      'Close-up of bright galactic center with accretion disk';

  @override
  String get presetGalaxyFormationOverview => 'Galaxy Formation Overview';

  @override
  String get presetGalaxyFormationOverviewDesc =>
      'Wide view of spiral galaxy formation with cosmic background';

  @override
  String get presetInnerSolarSystem => 'Inner Solar System';

  @override
  String get presetInnerSolarSystemDesc =>
      'Close-up of Mercury, Venus, Earth, and Mars with habitable zone indicator';

  @override
  String get presetSaturnRings => 'Saturn\'s Majestic Rings';

  @override
  String get presetSaturnRingsDesc =>
      'Close-up of Saturn with detailed ring system';

  @override
  String get presetThreeBodyBallet => 'Three-Body Ballet';

  @override
  String get presetThreeBodyBalletDesc =>
      'Classic three-body problem in elegant motion';

  @override
  String get resetButton => 'Reset';

  @override
  String get resetChangelogButton => 'Reset Changelog State';

  @override
  String get resetChangelogDescription => 'Reset changelog read status';

  @override
  String get resetSettingsDescription => 'Reset all settings to default values';

  @override
  String get resetTutorialDescription => 'Reset tutorial progress';

  @override
  String get simulationCanvasFocused =>
      'Simulation canvas focused - main physics simulation area';

  @override
  String get simulationCanvasHint =>
      'Use keyboard shortcuts to control simulation. Space to pause, R to reset, C to center camera';

  @override
  String get simulationCanvasLabel => 'Gravitational Physics Simulation';

  @override
  String get simulationControlsFocused =>
      'Simulation controls focused - play, pause, reset simulation';

  @override
  String simulationDescription(
    int bodyCount,
    String status,
    String speed,
    int steps,
  ) {
    return 'Gravitational simulation with $bodyCount celestial bodies. Status: $status. Speed: $speed. Steps: $steps';
  }

  @override
  String get simulationSpeed => 'Simulation Speed';

  @override
  String get simulationSpeedHint =>
      'Adjust simulation speed from 0.1x to 16x normal speed. Use arrow keys to change in small increments.';

  @override
  String simulationStateDescription(
    int bodyCount,
    String status,
    String speed,
    int stepCount,
  ) {
    return 'Gravitational simulation with $bodyCount celestial bodies. Status: $status. Speed: $speed. Steps completed: $stepCount. Tap to interact with simulation or use keyboard shortcuts.';
  }

  @override
  String get simulationStats => 'Simulation Stats';

  @override
  String get simulationStepsLabel => 'Simulation Steps';

  @override
  String get speedDouble => 'Double';

  @override
  String get speedFast => 'Fast';

  @override
  String speedFormatted(String speed) {
    return '${speed}x';
  }

  @override
  String get speedHalf => 'Half Speed';

  @override
  String get speedLabel => 'Speed';

  @override
  String get speedMaximum => 'Maximum';

  @override
  String get speedNormal => 'Normal';

  @override
  String get speedQuarter => 'Quarter Speed';

  @override
  String get speedVeryFast => 'Very Fast';

  @override
  String get stopFollowTitle => 'Stop Follow';

  @override
  String get stopFollowingTooltip => 'Stop Following Object';

  @override
  String get stopRotateTitle => 'Stop Rotate';

  @override
  String get testPresetForUnitTesting => 'Test preset for unit testing';

  @override
  String get trailsLabel => 'Trails';

  @override
  String get cameraControlsFocused =>
      'Camera controls focused - adjust view and perspective';

  @override
  String get cameraControlsLabel => 'Camera Controls';

  @override
  String get cameraDynamicFraming => 'Dynamic Framing';

  @override
  String get cameraDynamicFramingDescription =>
      'Automatically adjusts framing based on scene content';

  @override
  String cameraFollowingDescription(
    String bodyName,
    String distance,
    String rotation,
  ) {
    return 'Camera following $bodyName at distance $distance. Auto-rotation: $rotation';
  }

  @override
  String cameraFreeDescription(String distance, String rotation) {
    return 'Camera in free mode at distance $distance. Auto-rotation: $rotation';
  }

  @override
  String get cameraLabel => 'Camera';

  @override
  String get cameraManual => 'Manual Control';

  @override
  String get cameraManualDescription =>
      'Traditional manual camera controls with follow mode';

  @override
  String get cameraPredictiveOrbital => 'Predictive Orbital';

  @override
  String get cameraPredictiveOrbitalDescription =>
      'AI predicts orbital paths for dramatic camera movements';

  @override
  String get cameraSettingsTitle => 'Camera Settings';

  @override
  String get cameraSpeedHint =>
      'Adjust AI camera movement speed from slow to fast. Use arrow keys to change in small increments.';

  @override
  String get cameraSpeedLabel => 'Camera Speed';

  @override
  String get cameraTooltip => 'Camera settings and AI modes';

  @override
  String distanceFormatted(String distance) {
    return '$distance';
  }

  @override
  String get distanceLabel => 'Distance';

  @override
  String get previewEditortitle => 'Preview';

  @override
  String get setupEditorTitle => 'Setup';

  @override
  String get rotateLabel => 'Rotate';

  @override
  String get viewPhysicsSettings => 'View physics settings';

  @override
  String get zoomInAction => 'Zoom in';

  @override
  String get zoomLabel => 'Zoom';

  @override
  String get zoomOutAction => 'Zoom out';

  @override
  String get colorEditor => 'Color';

  @override
  String colorOptionTemplate(String colorName, Object color) {
    return 'Color option $colorName';
  }

  @override
  String get colorSelector => 'Color selector';

  @override
  String colorOptionTooltip(String colorName) {
    return 'Select $colorName color for celestial body';
  }

  @override
  String get visualsTooltip => 'Visual display options';

  @override
  String get collisionHapticFeedback => 'Collision Haptic Feedback';

  @override
  String get collisionSensitivity => 'Collision Sensitivity';

  @override
  String get gravityColorSchemeClassic => 'Classic';

  @override
  String get gravityColorSchemeEmerald => 'Emerald';

  @override
  String get gravityColorSchemeMonochrome => 'Monochrome';

  @override
  String get gravityColorSchemeNeon => 'Neon';

  @override
  String get gravityColorSchemeSpectral => 'Spectral';

  @override
  String get gravityEditor => 'Gravity';

  @override
  String get gravityFieldColorSchemeDescription =>
      'Choose the color scheme for gravitational field visualization';

  @override
  String get gravityFieldColorSchemeLabel => 'Gravity Field Colors';

  @override
  String get gravityFieldIndicatorsDescription =>
      'Show visual indicators of gravitational field strength';

  @override
  String get gravityFieldIndicatorsLabel => 'Field Strength Indicators';

  @override
  String gravityFieldStrengthFormatted(String strength, String unit) {
    return '$strength $unit';
  }

  @override
  String get gravityFieldStrengthLabel => 'Field Strength';

  @override
  String get gravityFieldStrengthUnit => 'm/s²';

  @override
  String get gravityFieldsDescription =>
      'Show gravitational field visualization';

  @override
  String get gravityFieldsTitle => 'Gravity Fields';

  @override
  String get relativisticEffectsTitle => 'Relativistic Effects';

  @override
  String get relativisticEffectsDescription =>
      'Apply post-Newtonian corrections for high-speed objects';

  @override
  String get relativisticGlowTitle => 'Relativistic Glow';

  @override
  String get relativisticGlowDescription =>
      'Visualize time dilation with velocity-based glow';

  @override
  String get tidalForcesTitle => 'Tidal Forces';

  @override
  String get tidalForcesDescription =>
      'Calculate tidal deformation and heating effects';

  @override
  String get tidalVisualizationTitle => 'Tidal Visualization';

  @override
  String get tidalVisualizationDescription =>
      'Show tidal stress and deformation axes';

  @override
  String get gravityWellsDescription =>
      'Show gravitational field strength around objects';

  @override
  String get gravityWellsLabel => 'Gravity Wells';

  @override
  String get massKgEditorhint => 'Mass (kg)';

  @override
  String get physicsConfigurationWillBeImplementedHereEditor =>
      'Physics configuration will be implemented here';

  @override
  String physicsFieldRangeError(String field, double min, double max) {
    return '$field must be between $min and $max';
  }

  @override
  String get physicsSection => 'Physics';

  @override
  String get physicsSettingsDescription => 'Simulation parameters';

  @override
  String get physicsSettingsTitle => 'Physics Settings';

  @override
  String physicsStatsDescription(String time, String earthYears, int steps) {
    return 'Physics: $time time units, $earthYears Earth years, $steps simulation steps completed';
  }

  @override
  String get physicsTooltip => 'Physics visualization and settings';

  @override
  String get physicsVisualizationTitle => 'Physics Visualization';

  @override
  String get temperatureCold => 'Cold';

  @override
  String get temperatureEditorlabel => 'Temperature';

  @override
  String get temperatureFrozen => 'Frozen';

  @override
  String get temperatureHot => 'Hot';

  @override
  String get temperatureKEditorhint => 'Temperature (K)';

  @override
  String get temperatureCelsiusEditorhint => 'Temperature (°C)';

  @override
  String get temperatureFahrenheitEditorhint => 'Temperature (°F)';

  @override
  String get temperatureModerate => 'Moderate';

  @override
  String get temperatureNotApplicable => 'N/A';

  @override
  String get temperatureScorching => 'Scorching';

  @override
  String get temperatureUnitCelsius => '°C';

  @override
  String get temperatureUnitFahrenheit => '°F';

  @override
  String get temperatureUnitKelvin => 'K';

  @override
  String get temperatureUnitCelsiusName => 'Celsius';

  @override
  String get temperatureUnitFahrenheitName => 'Fahrenheit';

  @override
  String get temperatureUnitKelvinName => 'Kelvin';

  @override
  String get velocityMsEditor => 'Velocity (m/s)';

  @override
  String get addBodyButton => 'Add Body';

  @override
  String get tapToEnableAddBodyMode =>
      'Tap to enable add body mode - click on canvas to place new bodies';

  @override
  String get tapToDisableAddBodyMode =>
      'Tap to disable add body mode and return to normal interaction';

  @override
  String get addBodyModeActive => 'Add Body Mode Active';

  @override
  String get addBodyModeInactive => 'Add Body Mode Inactive';

  @override
  String get tapToPlaceBody => 'Tap anywhere on the canvas to place a new body';

  @override
  String get lockInteraction => 'Lock Interaction';

  @override
  String get tapToLockInteraction =>
      'Tap to lock interaction - prevents accidentally moving bodies';

  @override
  String get tapToUnlockInteraction =>
      'Tap to unlock interaction - allows moving bodies by dragging';

  @override
  String get interactionLocked => 'Interaction locked';

  @override
  String get interactionUnlocked => 'Interaction unlocked';

  @override
  String get bodyPlacedSuccessfully => 'Body placed successfully';

  @override
  String get addCelestialBodiesToCreateYourCustomScenarioEditor =>
      'Add celestial bodies to create your custom scenario';

  @override
  String get asteroidBeltAndOtherParticleSystemsWillBeConfiguredHereEditor =>
      'Asteroid belt and other particle systems will be configured here';

  @override
  String get beginnerEditor => 'Beginner';

  @override
  String get noBodiesAdded => 'No bodies added yet';

  @override
  String get addBodiesInSetupTab => 'Add bodies in the Setup tab';

  @override
  String get untitledScenario => 'Untitled Scenario';

  @override
  String get noDescriptionProvided => 'No description provided';

  @override
  String get collisionSoftening => 'Collision Softening';

  @override
  String get collisionRadius => 'Collision Radius';

  @override
  String get bodyTypeEditor => 'Body Type';

  @override
  String get createACopyOfThisCelestialBodyEditorHint =>
      'Create a copy of this celestial body';

  @override
  String get createCustomScenarioButton => 'Create Custom Scenario';

  @override
  String get createCustomScenarioDescription =>
      'Design your own gravitational scenario with custom celestial bodies';

  @override
  String get createScenarioButton => 'Create';

  @override
  String get createScenarioTitle => 'Create Scenario';

  @override
  String get editScenarioButton => 'Edit scenario';

  @override
  String get editScenarioHint => 'Edit this scenario';

  @override
  String get editBodyButton => 'Edit body';

  @override
  String get editBodyHint => 'Edit this celestial body';

  @override
  String get deleteScenarioButton => 'Delete scenario';

  @override
  String get deleteScenarioHint => 'Delete this scenario';

  @override
  String get customGravitationalSimulationEditor =>
      'A custom gravitational simulation';

  @override
  String get deleteBodyConfirmMessage =>
      'This action cannot be undone. The celestial body will be permanently removed from the scenario.';

  @override
  String deleteBodyConfirmTitle(String bodyName) {
    return 'Delete $bodyName?';
  }

  @override
  String deleteBodyNameTemplate(String bodyName) {
    return 'Delete $bodyName';
  }

  @override
  String get deleteBodyTooltip => 'Delete Body';

  @override
  String get deleteButton => 'Delete';

  @override
  String deleteScenarioConfirmMessage(String scenarioName) {
    return 'Are you sure you want to permanently delete \"$scenarioName\"? This action cannot be undone.';
  }

  @override
  String get deleteScenarioTitle => 'Delete Scenario';

  @override
  String deleteScenarioSuccessMessage(String scenarioName) {
    return 'Successfully deleted scenario: $scenarioName';
  }

  @override
  String deleteScenarioFailedMessage(String error) {
    return 'Failed to delete scenario: $error';
  }

  @override
  String get editEditorLabel => 'Edit';

  @override
  String get editScenarioTitle => 'Edit Scenario';

  @override
  String get gravitationalForcesEditor => 'Gravitational forces';

  @override
  String get newScenarioEditor => 'New Scenario';

  @override
  String get noBodiesYetEditor => 'No bodies yet';

  @override
  String get positionMEditor => 'Position (m)';

  @override
  String get positionMotionEditor => 'Position & Motion';

  @override
  String get propertiesEditor => 'Properties';

  @override
  String get removeThisCelestialBodyFromTheScenarioEditorHint =>
      'Remove this celestial body from the scenario';

  @override
  String get softeningEditor => 'Softening';

  @override
  String get stellarPropertiesEditor => 'Stellar Properties';

  @override
  String get trailPointsEditor => 'Trail Points';

  @override
  String get customColor => 'custom color';

  @override
  String get customLabel => 'Custom';

  @override
  String get customScenarioDescription => 'Custom gravitational scenario';

  @override
  String get viewScenarioButton => 'View Scenario';

  @override
  String get viewScenarioHint => 'View scenario details in read-only mode';

  @override
  String get exportScenarioButton => 'Export Scenario';

  @override
  String get exportScenarioHint => 'Export scenario to file for sharing';

  @override
  String exportScenarioFailedMessage(String error) {
    return 'Failed to export scenario: $error';
  }

  @override
  String get exportScenarioNotImplementedMessage =>
      'Export scenario functionality not implemented yet';

  @override
  String get saveButton => 'Save';

  @override
  String get saveBodyTooltip => 'Save Body';

  @override
  String get saveNewBodyAccessibility => 'Save new body';

  @override
  String get saveNewBodyHint => 'Creates the body with current settings';

  @override
  String get saveChangesToBodyAccessibility => 'Save changes to body';

  @override
  String get saveChangesToBodyHint => 'Saves all changes made to this body';

  @override
  String get moreActionsAccessibility => 'More actions';

  @override
  String get moreActionsHint => 'Open menu with duplicate and delete options';

  @override
  String get duplicateBodyAccessibility => 'Creates a copy of this body';

  @override
  String get deleteBodyAccessibility => 'Permanently removes this body';

  @override
  String get settingsButtonFocused =>
      'Settings button focused - open application settings';

  @override
  String get settingsMenuDescription => 'Visual & behavior options';

  @override
  String get settingsTooltip => 'Application Settings';

  @override
  String get toggleAutoRotateAction => 'Toggle auto-rotation';

  @override
  String get toggleGravityFieldsTooltip => 'Toggle Gravity Fields';

  @override
  String get toggleHabitabilityIndicatorsTooltip =>
      'Toggle Planet Habitability Status';

  @override
  String get toggleHabitableZonesTooltip => 'Toggle Habitable Zones';

  @override
  String get toggleLabelsTooltip => 'Toggle Body Labels';

  @override
  String get toggleStatsTooltip => 'Toggle Stats';

  @override
  String get statsLabel => 'Stats';

  @override
  String get helpMenuDescription => 'Tutorial & objectives';

  @override
  String get tutorialButton => 'Tutorial';

  @override
  String get tutorialCameraDescription =>
      'Drag to rotate your view, pinch to zoom, use two fingers to roll the camera, and use three fingers to pan. The bottom bar has focus, center, and auto-rotation controls for a cinematic experience.';

  @override
  String get tutorialCameraTitle => 'Camera & View Controls';

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
  String get tutorialControlsTitle => 'Simulation Controls';

  @override
  String get tutorialDescription => 'Interactive guided tour of the app';

  @override
  String get tutorialExploreDescription =>
      'You\'re all set! Start with the Solar System to see familiar planets, or dive into the Three-Body Problem for some chaotic fun. Remember: every reset creates a new universe to explore!';

  @override
  String get tutorialExploreTitle => 'Ready to Explore!';

  @override
  String get tutorialNavigationHint =>
      'Swipe left/right or use buttons to navigate';

  @override
  String get tutorialObjectivesDescription =>
      '• Observe realistic orbital mechanics\n• Explore different astronomical scenarios\n• Experiment with gravitational interactions\n• Watch collisions and mergers\n• Learn about planetary motion\n• Discover chaotic three-body dynamics';

  @override
  String get tutorialObjectivesTitle => 'What Can You Do?';

  @override
  String get tutorialResetMessage =>
      'Tutorial state reset! Restart app to see first-time experience.';

  @override
  String get tutorialResetSuccess => 'Tutorial progress has been reset';

  @override
  String get tutorialScenariosDescription =>
      'Access the menu (⋮) in the top-right to explore different scenarios: our Solar System, Earth-Moon dynamics, Binary Stars, or the chaotic Three-Body Problem. Each offers unique physics to discover!';

  @override
  String get tutorialScenariosDescriptionPart1 => 'Access the menu';

  @override
  String get tutorialScenariosDescriptionPart2 =>
      'in the top-right to explore different scenarios: our Solar System, Earth-Moon dynamics, Binary Stars, or the chaotic Three-Body Problem. Each offers unique physics to discover!';

  @override
  String get tutorialScenariosTitle => 'Choose Your Adventure';

  @override
  String get tutorialWelcomeDescription =>
      'Welcome to Graviton, your window into the fascinating world of gravitational physics! This app lets you explore how celestial bodies interact through gravity, creating beautiful orbital dances across space and time.';

  @override
  String get tutorialWelcomeTitle => 'Welcome to Graviton!';

  @override
  String get welcomeCardDescription =>
      'Explore gravitational physics through interactive simulations. Try different scenarios, adjust controls, and watch the cosmos unfold!';

  @override
  String get cancel => 'Cancel';

  @override
  String get descriptionEditorLabel => 'Description';

  @override
  String get next => 'Next';

  @override
  String get ok => 'OK';

  @override
  String get previous => 'Previous';

  @override
  String liveUpdateAnnouncement(String updateType, String value) {
    return '$updateType changed to $value';
  }

  @override
  String timeFormatted(String time) {
    return '${time}s';
  }

  @override
  String get timeLabel => 'Time';

  @override
  String get timeScaleStatLabel => 'Time Scale';

  @override
  String get updateLater => 'Later';

  @override
  String get updateNow => 'Update Now';

  @override
  String get updateRequiredMessage =>
      'A newer version of this app is available. Please update to continue using the app with the latest features and improvements.';

  @override
  String get updateRequiredTitle => 'Update Required';

  @override
  String get updateRequiredWarning => 'This version is no longer supported.';

  @override
  String errorLoadingChangelogs(String error) {
    return 'Error loading changelogs: $error';
  }

  @override
  String errorOpeningLink(String error) {
    return 'Error opening link: $error';
  }

  @override
  String get notificationTypeDebug => 'Debug';

  @override
  String get notificationTypeInfo => 'Info';

  @override
  String get warningTitle => 'Warning';

  @override
  String accessibilityAnnouncementSkippedNoBindingMessage(String message) {
    return 'Accessibility announcement skipped (no binding): $message';
  }

  @override
  String get accessibilityCameraFocus =>
      'Camera focused on nearest celestial body';

  @override
  String get accessibilityCameraFollow =>
      'Camera now following selected celestial body';

  @override
  String get accessibilityCameraReset =>
      'Camera view reset to default position';

  @override
  String get accessibilityCameraUnfollow =>
      'Camera stopped following celestial body';

  @override
  String accessibilityCollisionRadiusChange(String newValue) {
    return 'Collision sensitivity changed to $newValue';
  }

  @override
  String accessibilityError(String errorMessage) {
    return 'Error: $errorMessage';
  }

  @override
  String accessibilityGravityChange(String newValue) {
    return 'Gravity strength changed to $newValue';
  }

  @override
  String accessibilityMergeEvent(String body1, String body2) {
    return 'Collision detected: $body1 merged with $body2';
  }

  @override
  String get accessibilityMergeEventContext =>
      'The combined mass creates a new celestial body';

  @override
  String accessibilityScenarioChange(String scenarioName) {
    return 'Scenario changed to $scenarioName';
  }

  @override
  String get accessibilityScenarioChangeContext =>
      'New celestial bodies and physics parameters loaded';

  @override
  String accessibilitySettingDisabled(String settingName) {
    return '$settingName disabled';
  }

  @override
  String accessibilitySettingEnabled(String settingName) {
    return '$settingName enabled';
  }

  @override
  String get accessibilitySimulationPaused => 'Simulation paused';

  @override
  String get accessibilitySimulationPausedContext =>
      'All celestial bodies have stopped moving';

  @override
  String get accessibilitySimulationReset => 'Simulation reset';

  @override
  String get accessibilitySimulationResetContext =>
      'New scenario loaded with fresh celestial bodies';

  @override
  String get accessibilitySimulationResumed => 'Simulation resumed';

  @override
  String get accessibilitySimulationResumedContext =>
      'Celestial bodies are moving again';

  @override
  String get accessibilitySimulationStarted => 'Simulation started';

  @override
  String get accessibilitySimulationStartedContext =>
      'Celestial bodies are now in motion';

  @override
  String get accessibilitySimulationStopped => 'Simulation stopped';

  @override
  String get accessibilitySimulationStoppedContext =>
      'All celestial bodies have been reset';

  @override
  String accessibilitySpeedChange(String newValue) {
    return 'Simulation speed changed to $newValue';
  }

  @override
  String accessibilityTutorialProgress(
    int currentStep,
    int totalSteps,
    String stepName,
  ) {
    return 'Tutorial step $currentStep of $totalSteps: $stepName';
  }

  @override
  String get changelogAdded => 'New Features';

  @override
  String get changelogButton => 'Show Changelog';

  @override
  String get changelogCategoryAdded => 'Added';

  @override
  String get changelogCategoryFixed => 'Fixed';

  @override
  String get changelogCategoryImproved => 'Improved';

  @override
  String get changelogDescription => 'View app updates and changes';

  @override
  String get changelogDone => 'Done';

  @override
  String get changelogFixed => 'Bug Fixes';

  @override
  String get changelogHometitle => 'Changelog';

  @override
  String get changelogImproved => 'Improvements';

  @override
  String changelogLoadError(String error) {
    return 'Failed to load changelog: $error';
  }

  @override
  String changelogNotFoundError(String version) {
    return 'No changelog found. Add changelog data to Firestore first.\nCurrent version: $version';
  }

  @override
  String changelogReleaseDate(String date) {
    return 'Released $date';
  }

  @override
  String get changelogResetMessage => 'Changelog state has been reset';

  @override
  String get changelogResetSuccess => 'Changelog status has been reset';

  @override
  String get changelogTitle => 'What\'s New';

  @override
  String get debugStatisticsTitle => 'Debug & Statistics';

  @override
  String errorLoadingChangelogEHome(String error) {
    return 'Error loading changelog: $error';
  }

  @override
  String noChangelogAvailableForVersionHome(String version) {
    return 'No changelog available for version $version';
  }

  @override
  String get testPreset => 'Test Preset';

  @override
  String get testScenarioButton => 'Test Scenario';

  @override
  String get testScenarioHint => 'Test the current scenario in simulation';

  @override
  String get testScenarioNotImplementedMessage =>
      'Test scenario functionality not implemented yet';

  @override
  String get scenarioEditorMenuHint => 'Open menu with test and export options';

  @override
  String get aboutButtonTooltip => 'About';

  @override
  String get aboutMenuDescription => 'App information & credits';

  @override
  String get accessAppPreferences => 'Access app preferences';

  @override
  String get accessScenarioOptions => 'Access scenario options';

  @override
  String get adjustSimulationSpeed => 'Adjust simulation speed';

  @override
  String get aiCameraModesTitle => 'AI Camera Modes';

  @override
  String get allRightsReserved => 'All rights reserved';

  @override
  String get announcementTitle => 'Announcement';

  @override
  String appliedPreset(String presetName) {
    return 'Applied preset: $presetName';
  }

  @override
  String get applyScene => 'Apply Scene';

  @override
  String get atLeastOneBodyIsRequired => 'At least one body is required';

  @override
  String get authorLabel => 'Author';

  @override
  String get autoRotateActive => 'active';

  @override
  String get autoRotateInactive => 'inactive';

  @override
  String get autoRotateLabel => 'Auto-rotate';

  @override
  String get autoRotateOff => 'Off';

  @override
  String get autoRotateOn => 'On';

  @override
  String get autoRotateTooltip => 'Auto Rotate';

  @override
  String get rotateSpeed => 'Rotate Speed';

  @override
  String get blackColor => 'black';

  @override
  String get bodies => 'bodies';

  @override
  String get bodiesHeaderDescription => 'Celestial bodies in your scenario';

  @override
  String bodiesHeaderPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Bodies',
      one: '1 Body',
      zero: 'No Bodies',
    );
    return '$_temp0';
  }

  @override
  String scenariosHeaderPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Scenarios',
      one: '1 Scenario',
      zero: 'No Scenarios',
    );
    return '$_temp0';
  }

  @override
  String experimentsHeaderPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Experiments',
      one: '1 Experiment',
      zero: 'No Experiments',
    );
    return '$_temp0';
  }

  @override
  String bodiesInSimulation(String descriptions) {
    return 'Bodies in simulation: $descriptions';
  }

  @override
  String get bodiesLabel => 'Bodies';

  @override
  String get bodyAlpha => 'Alpha';

  @override
  String bodyAsteroid(int number) {
    return 'Asteroid $number';
  }

  @override
  String get bodyBeta => 'Beta';

  @override
  String get bodyBlackHole => 'Black Hole';

  @override
  String get bodyCenterOfMass => 'Center of Mass';

  @override
  String get bodyCentralStar => 'Central Star';

  @override
  String bodyColorInvalid(String prefix) {
    return '$prefix: color must be valid hex format (#RRGGBB or #AARRGGBB)';
  }

  @override
  String get bodyEarth => 'Earth';

  @override
  String get bodyEarthLike => 'Earth-like';

  @override
  String get bodyGamma => 'Gamma';

  @override
  String bodyIndex(int index) {
    return 'Body $index';
  }

  @override
  String get bodyNewDefault => 'New Body';

  @override
  String get bodyPlacementTooClose =>
      'Too close to existing body - please tap elsewhere';

  @override
  String get bodyInnerPlanet => 'Inner Planet';

  @override
  String get bodyJupiter => 'Jupiter';

  @override
  String get bodyMars => 'Mars';

  @override
  String bodyMassInvalid(String prefix) {
    return '$prefix: mass must be between 0.001 and 1000';
  }

  @override
  String get bodyMercury => 'Mercury';

  @override
  String get bodyMoon => 'Moon';

  @override
  String get bodyMoonM => 'Moon M';

  @override
  String get bodySpacecraft => 'Spacecraft';

  @override
  String get bodyIo => 'Io';

  @override
  String get bodyEuropa => 'Europa';

  @override
  String bodyNameCopyTemplate(String bodyName) {
    return '$bodyName Copy';
  }

  @override
  String bodyNameRequired(String prefix) {
    return '$prefix: name is required';
  }

  @override
  String get bodyNeptune => 'Neptune';

  @override
  String bodyNumberTemplate(String number) {
    return 'Body $number';
  }

  @override
  String get bodyOuterPlanet => 'Outer Planet';

  @override
  String get bodyPlanetP => 'Planet P';

  @override
  String bodyPositionComponentInvalid(String prefix, int component) {
    return '$prefix: position[$component] must be a finite number';
  }

  @override
  String bodyPositionInvalid(String prefix) {
    return '$prefix: position must be a 3D array [x, y, z]';
  }

  @override
  String get bodyPropertiesAxisX => 'X:';

  @override
  String get bodyPropertiesAxisY => 'Y:';

  @override
  String get bodyPropertiesAxisZ => 'Z:';

  @override
  String get bodyPropertiesLuminosity => 'Stellar Luminosity';

  @override
  String get bodyPropertiesMass => 'Mass';

  @override
  String get bodyPropertiesName => 'Name';

  @override
  String get bodyPropertiesNameHint => 'Enter body name';

  @override
  String get bodyPropertiesRadius => 'Radius';

  @override
  String get bodyPropertiesMassHint =>
      'Adjust the gravitational influence and orbital dynamics';

  @override
  String get bodyPropertiesRadiusHint =>
      'Control the size and collision boundary';

  @override
  String get bodyPropertiesTitle => 'Body Properties';

  @override
  String get bodyPropertiesVelocity => 'Velocity';

  @override
  String bodyRadiusInvalid(String prefix) {
    return '$prefix: radius must be between 0.1 and 50';
  }

  @override
  String bodyRing(int number) {
    return 'Ring $number';
  }

  @override
  String get bodyRingedPlanet => 'Ringed Planet';

  @override
  String get bodyRockyPlanet => 'Rocky Planet';

  @override
  String get bodySaturn => 'Saturn';

  @override
  String bodySelectedTemplate(String bodyNumber) {
    return 'Body $bodyNumber';
  }

  @override
  String get bodyStarA => 'Star A';

  @override
  String get bodyStarB => 'Star B';

  @override
  String bodyStarNumber(int number) {
    return 'Star $number';
  }

  @override
  String get bodySun => 'Sun';

  @override
  String get bodySuperEarth => 'Super-Earth';

  @override
  String get bodyTypeAsteroid => 'Asteroid';

  @override
  String bodyTypeAsteroidPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Asteroids',
      one: '1 Asteroid',
    );
    return '$_temp0';
  }

  @override
  String bodyTypeInvalid(String prefix, String bodyType) {
    return '$prefix: invalid bodyType \"$bodyType\"';
  }

  @override
  String bodyTypeMoonPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Moons',
      one: '1 Moon',
    );
    return '$_temp0';
  }

  @override
  String get bodyTypePlanet => 'Planet';

  @override
  String bodyTypePlanetPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Planets',
      one: '1 Planet',
    );
    return '$_temp0';
  }

  @override
  String get bodyTypeSelector => 'Body type selector';

  @override
  String get bodyTypeStar => 'Star';

  @override
  String bodyTypeStarPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Stars',
      one: '1 Star',
    );
    return '$_temp0';
  }

  @override
  String get bodyTypeNeutronStar => 'Neutron Star';

  @override
  String get bodyTypeBlackHole => 'Black Hole';

  @override
  String get bodyTypeMoon => 'Moon';

  @override
  String bodyTypeTemplate(String bodyType, Object type) {
    return '$bodyType body type';
  }

  @override
  String get bodyTypeTooltipStar =>
      'Massive celestial bodies that generate light and heat through nuclear fusion. Stars are the primary energy sources in stellar systems.';

  @override
  String get bodyTypeTooltipPlanet =>
      'Large celestial bodies that orbit stars and have cleared their orbital path. Planets can be rocky or gaseous and may host moons.';

  @override
  String get bodyTypeTooltipMoon =>
      'Natural satellites that orbit planets. Moons can influence tides and provide stability to planetary systems.';

  @override
  String get bodyTypeTooltipAsteroid =>
      'Small rocky bodies that orbit the sun. Asteroids are remnants from the early formation of the solar system.';

  @override
  String get bodyTypeTooltipBlackHole =>
      'Regions of spacetime with gravitational fields so intense that nothing, not even light, can escape from them.';

  @override
  String get bodyTypeTooltipNeutronStar =>
      'Extremely dense stellar remnants formed when massive stars collapse. They have incredibly strong gravitational and magnetic fields.';

  @override
  String get bodyUranus => 'Uranus';

  @override
  String bodyVelocityComponentInvalid(String prefix, int component) {
    return '$prefix: velocity[$component] must be a finite number';
  }

  @override
  String bodyVelocityInvalid(String prefix) {
    return '$prefix: velocity must be a 3D array [vx, vy, vz]';
  }

  @override
  String get bodyVenus => 'Venus';

  @override
  String get bottomSheetFocused =>
      'Bottom sheet focused - scenario and settings access';

  @override
  String get bottomSheetLabel => 'Bottom sheet';

  @override
  String get browseAvailableSimulations => 'Browse available simulations';

  @override
  String celestialBodyNameTemplate(String bodyName, Object name) {
    return '$bodyName celestial body';
  }

  @override
  String get centerLabel => 'Center';

  @override
  String get centerViewTooltip => 'Center View';

  @override
  String get cinematicCameraTechniqueDescription =>
      'Choose how AI controls the camera when following objects';

  @override
  String get cinematicCameraTechniqueLabel => 'AI Camera Technique';

  @override
  String get cinematicTechniqueDynamicFramingDesc =>
      'Real-time dramatic targeting for chaotic scenarios';

  @override
  String get cinematicTechniquePredictiveOrbitalDesc =>
      'AI tours and orbital predictions for educational scenarios';

  @override
  String get closeButton => 'Close';

  @override
  String get collapsedState => 'collapsed';

  @override
  String get collisionsSection => 'Collisions';

  @override
  String get colorsLabel => 'Colors';

  @override
  String get companyName => 'Chipper Technologies LLC';

  @override
  String get coolTrails => '❄️ Cool';

  @override
  String copiedToClipboard(String text) {
    return 'Copied to clipboard: $text';
  }

  @override
  String get copyButton => 'Copy';

  @override
  String get copyrightLabel => 'Copyright';

  @override
  String couldNotOpenUrl(String url) {
    return 'Could not open $url';
  }

  @override
  String get crosshairsDescription => 'Show center screen indicator';

  @override
  String get crosshairsTitle => 'Crosshairs';

  @override
  String get currentScenario => 'Current scenario';

  @override
  String get currentStatisticsTitle => 'Current Statistics';

  @override
  String get currentlySelected => 'Currently selected';

  @override
  String get cyanColor => 'cyan';

  @override
  String get deactivate => 'Deactivate';

  @override
  String get describeWhatThisScenarioDemonstratesEditorHint =>
      'Describe what this scenario demonstrates';

  @override
  String get detailsEditorLabel => 'Details';

  @override
  String get developerToolsMenuDescription => 'Debug tools for development';

  @override
  String get developerToolsTitle => 'Developer Tools';

  @override
  String get difficultyEditorLabel => 'Difficulty';

  @override
  String get discardButton => 'Discard';

  @override
  String get dragToRotateCameraView => 'Drag to rotate camera view';

  @override
  String get dualOrbitalPaths => 'Dual Orbital Paths';

  @override
  String get dualOrbitalPathsDescription =>
      'Show both ideal circular and actual elliptical orbital paths';

  @override
  String duplicateBodyNameTemplate(String bodyName) {
    return 'Duplicate $bodyName';
  }

  @override
  String get duplicateBodyTooltip => 'Duplicate Body';

  @override
  String get dynamicFramingDescription => 'AI dynamically frames all objects';

  @override
  String get earthBlueColor => 'earth blue';

  @override
  String earthYearsFormatted(String years) {
    return '$years yr';
  }

  @override
  String get earthYearsLabel => 'Earth Years';

  @override
  String get educationalFocusBinaryOrbits => 'binary orbits';

  @override
  String get educationalFocusChaoticDynamics => 'chaotic dynamics';

  @override
  String get educationalFocusManyBodyDynamics => 'many-body dynamics';

  @override
  String get educationalFocusPlanetaryMotion => 'planetary motion';

  @override
  String get educationalFocusRealWorldSystem => 'real-world system';

  @override
  String get educationalFocusStructureFormation => 'structure formation';

  @override
  String get educationalObjectivesEditortitle => 'Educational Objectives';

  @override
  String get educationalObjectivesFutureMessage =>
      'Educational objectives and challenges can be configured here in future versions.';

  @override
  String get educationalObjectivesListMessage =>
      'This will include:\n• Learning goals\n• Success criteria\n• Guided challenges\n• Assessment rubrics';

  @override
  String get emergencyNotificationTitle => 'Important Notice';

  @override
  String get enterScenarioNameEditorHint => 'Enter scenario name';

  @override
  String get equipotentialSurfacesDescription =>
      'Show surfaces of equal gravitational potential energy';

  @override
  String get equipotentialSurfacesLabel => 'Equipotential Surfaces';

  @override
  String get exit => 'Exit';

  @override
  String get exitAppMessage => 'Are you sure you want to exit Graviton?';

  @override
  String get exitAppTitle => 'Exit App';

  @override
  String get expandedState => 'expanded';

  @override
  String failedToSwitchScenarioError(String error) {
    return 'Failed to switch scenario: $error';
  }

  @override
  String get fieldOfViewLabel => 'Field of View';

  @override
  String get focusOnNearestTooltip => 'Focus on Nearest Body';

  @override
  String get followLabel => 'Follow';

  @override
  String get followObjectTooltip => 'Follow Selected Object';

  @override
  String get getStarted => 'Get Started!';

  @override
  String get globalGravityFieldsDescription =>
      'Enable gravity field visualization for all massive objects';

  @override
  String get globalGravityFieldsLabel => 'Global Gravity Fields';

  @override
  String get gotItButton => 'Got it!';

  @override
  String get gravitationalConstant => 'Gravitational Constant';

  @override
  String get greenColor => 'green';

  @override
  String get habitabilityHabitable => 'Habitable';

  @override
  String get habitabilityIndicatorsDescription =>
      'Display color-coded status rings around planets based on their habitability';

  @override
  String get habitabilityIndicatorsLabel => 'Planet Status';

  @override
  String get stellarCoronasTitle => 'Stellar Coronas';

  @override
  String get stellarCoronasDescription =>
      'Show glowing plasma atmospheres around stars';

  @override
  String get atmosphericEffectsTitle => 'Atmospheric Effects';

  @override
  String get atmosphericEffectsDescription =>
      'Display atmospheric halos and scattering on planets';

  @override
  String get hemisphereLightingTitle => 'Hemisphere Lighting';

  @override
  String get hemisphereLightingDescription =>
      'Simulate realistic 3D lighting on spherical bodies';

  @override
  String get castShadowsTitle => 'Cast Shadows';

  @override
  String get castShadowsDescription =>
      'Show shadows when bodies occlude light sources';

  @override
  String get specularHighlightsTitle => 'Specular Highlights';

  @override
  String get specularHighlightsDescription =>
      'Display reflective highlights on icy and water surfaces';

  @override
  String get lightingEffectsLabel => 'Lighting & Shadows';

  @override
  String get habitabilityLabel => 'Habitability';

  @override
  String get habitabilityTooCold => 'Too Cold';

  @override
  String get habitabilityTooHot => 'Too Hot';

  @override
  String get habitabilityUnknown => 'Unknown';

  @override
  String get habitabilityGasGiant => 'Gas Giant';

  @override
  String get habitabilityTooSmall => 'Too Small';

  @override
  String get habitabilityNoAtmosphere => 'No Atmosphere';

  @override
  String get habitabilityToxicAtmosphere => 'Toxic Atmosphere';

  @override
  String get habitabilityHighRadiation => 'High Radiation';

  @override
  String get habitabilityTidallyLocked => 'Tidally Locked';

  @override
  String get habitabilityExtremeGravity => 'Extreme Gravity';

  @override
  String get habitableZonesDescription =>
      'Show colored zones around stars indicating habitable regions';

  @override
  String get habitableZonesLabel => 'Habitable Zones';

  @override
  String get hapticsSection => 'Haptics';

  @override
  String get hideUIInScreenshotMode => 'Hide Navigation';

  @override
  String get hideUIInScreenshotModeSubtitle =>
      'Hide app bar, bottom navigation, and copyright when screenshot mode is active';

  @override
  String get initialMotionVectorsDescription =>
      'Initial motion vectors determining orbital paths';

  @override
  String invalidJsonFormat(String error) {
    return 'Invalid JSON format: $error';
  }

  @override
  String get invertPitchControlsDescription => 'Reverse up/down drag direction';

  @override
  String get invertPitchControlsLabel => 'Invert Pitch Controls';

  @override
  String get jupiterTanColor => 'jupiter tan';

  @override
  String get keyboardShortcutsHint =>
      'Use Space to pause/resume, R to reset, C to center camera, A to toggle auto-rotation';

  @override
  String get languageChinese => '中文';

  @override
  String get languageDescription => 'Change the app language';

  @override
  String get languageSelectionHint => 'Choose your preferred display language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get languageJapanese => '日本語';

  @override
  String get languageKorean => '한국어';

  @override
  String get languageLabel => 'General';

  @override
  String get temperatureUnitsLabel => 'Temperature Units';

  @override
  String get temperatureUnitsDescription =>
      'Preferred units for displaying temperatures throughout the app';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageSystem => 'System Default';

  @override
  String get lightEnergyOutputDescription =>
      'Light energy output - affects heating and visibility';

  @override
  String get loadingVersion => 'Loading version...';

  @override
  String get luminosityEditorLabel => 'Luminosity';

  @override
  String get luminosityWEditorhint => 'Luminosity (W)';

  @override
  String get maintenanceTitle => 'Maintenance';

  @override
  String get manualControlDescription => 'Full manual camera control';

  @override
  String get manualControlsTitle => 'Manual Controls';

  @override
  String get marketingLabel => 'Marketing';

  @override
  String get marsRedColor => 'mars red';

  @override
  String get maxTrailPointsInvalid =>
      'maxTrailPoints must be between 10 and 5000';

  @override
  String get maximum50BodiesAllowed => 'Maximum 50 bodies allowed';

  @override
  String get mercuryGrayColor => 'mercury gray';

  @override
  String get missingRequiredFieldBodies => 'Missing required field: bodies';

  @override
  String get missingRequiredFieldConfiguration =>
      'Missing required field: configuration';

  @override
  String get missingRequiredFieldMetadata => 'Missing required field: metadata';

  @override
  String get missingRequiredFieldParticleSystems =>
      'Missing required field: particleSystems';

  @override
  String get missingRequiredFieldPhysics => 'Missing required field: physics';

  @override
  String get missingRequiredFieldVersion => 'Missing required field: version';

  @override
  String get moreOptionsTooltip => 'More options';

  @override
  String get navigationAidsTitle => 'Navigation Aids';

  @override
  String get neptuneBlueColor => 'neptune blue';

  @override
  String get newsTitle => 'News';

  @override
  String get nextPreset => 'Next preset';

  @override
  String get nextSceneTooltip => 'Next Scene';

  @override
  String get noActionsAvailable => 'No actions available';

  @override
  String get noBodiesInSimulation =>
      'No celestial bodies currently in the simulation';

  @override
  String get noChangelogsAvailable => 'No changelogs available';

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
  String get objectivesDescription =>
      '• Understand how gravity shapes the cosmos\n• Observe stable vs. chaotic orbital systems\n• Learn why planets move in elliptical orbits\n• Discover how binary stars interact\n• See what happens when objects collide\n• Appreciate the three-body problem\'s complexity';

  @override
  String get objectivesTitle => 'Learning Objectives';

  @override
  String get offScreenIndicatorsDescription =>
      'Show arrows pointing to objects outside the visible area';

  @override
  String get offScreenIndicatorsTitle => 'Off-Screen Indicators';

  @override
  String get orangeColor => 'orange';

  @override
  String get particleSystemsEditortitle => 'Particle Systems';

  @override
  String get pathVisualizationTitle => 'Path Visualization';

  @override
  String get physicalPropertiesDescription =>
      'Physical properties that determine gravitational influence and size';

  @override
  String get pinchToZoomInOut => 'Pinch to zoom in/out';

  @override
  String get pitchLabel => 'Pitch';

  @override
  String get positionEditorLabel => 'Position';

  @override
  String get predictiveOrbitalDescription =>
      'AI predicts optimal orbital views';

  @override
  String get previousPreset => 'Previous preset';

  @override
  String get previousSceneTooltip => 'Previous Scene';

  @override
  String get privacyPolicyLabel => 'Privacy Policy';

  @override
  String get promotionTitle => 'Promotion';

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
  String get quickStartDescription =>
      '1. Choose a scenario (Solar System recommended for beginners)\n2. Press Play to start the simulation\n3. Drag to rotate your view, pinch to zoom\n4. Tap the Speed slider to control time\n5. Try Reset for new random configurations\n6. Enable Trails to see orbital paths';

  @override
  String get quickStartTitle => 'Quick Start Guide';

  @override
  String get quickTutorialButton => 'Quick Tutorial';

  @override
  String get radiusMEditorhint => 'Radius (m)';

  @override
  String get realisticColors => 'Realistic Colors';

  @override
  String get realisticColorsDescription =>
      'Use scientifically accurate colors based on temperature and stellar classification';

  @override
  String get redColor => 'red';

  @override
  String get rollLabel => 'Roll';

  @override
  String get saturnCreamColor => 'saturn cream';

  @override
  String get scenarioAsteroidBelt => 'Asteroid Belt';

  @override
  String get scenarioAsteroidBeltDescription =>
      'Central star surrounded by a belt of rocky asteroids and debris';

  @override
  String get scenarioBestBinary => 'Best for: Advanced physics exploration';

  @override
  String get scenarioBestEarthMoon =>
      'Best for: Understanding Earth-Moon system';

  @override
  String get scenarioBestEmoji => '⭐';

  @override
  String get scenarioBestRandom => 'Best for: Exploration and experimentation';

  @override
  String get scenarioBestSolar => 'Best for: Beginners, astronomy enthusiasts';

  @override
  String get scenarioBestThreeBody =>
      'Best for: Mathematical physics enthusiasts';

  @override
  String get scenarioBinaryStars => 'Binary Stars';

  @override
  String get scenarioBinaryStarsDescription =>
      'Two massive stars orbiting each other with circumbinary planets';

  @override
  String get scenarioCustom => 'Custom Scenario';

  @override
  String get scenarioCustomDescription =>
      'User-created custom gravitational scenario with personalized celestial bodies';

  @override
  String get scenarioEarthMoonSun => 'Earth-Moon-Sun';

  @override
  String get scenarioEarthMoonSunDescription =>
      'Educational simulation of our familiar Earth-Moon-Sun system';

  @override
  String get scenarioGalaxyFormation => 'Galaxy Formation';

  @override
  String get scenarioGalaxyFormationDescription =>
      'Watch matter organize into spiral structures around a central black hole';

  @override
  String get scenarioInformationEditortitle => 'Scenario Information';

  @override
  String get scenarioLearnBinary =>
      'Learn: Stellar evolution, binary systems, extreme gravity';

  @override
  String get scenarioLearnEarthMoon =>
      'Learn: Three-body dynamics, lunar mechanics, tidal forces';

  @override
  String get scenarioLearnEmoji => '🎯';

  @override
  String get scenarioLearnRandom =>
      'Learn: Discover unknown configurations, experimental physics';

  @override
  String get scenarioLearnSolar =>
      'Learn: Planetary motion, orbital mechanics, familiar celestial bodies';

  @override
  String get scenarioLearnThreeBody =>
      'Learn: Chaos theory, unpredictable motion, unstable systems';

  @override
  String get scenarioNameRequired =>
      'Scenario name is required and cannot be empty';

  @override
  String get scenarioNameTooLong =>
      'Scenario name must be 100 characters or less';

  @override
  String get scenarioPlanetaryRings => 'Planetary Rings';

  @override
  String get scenarioPlanetaryRingsDescription =>
      'Ring system dynamics around a massive planet like Saturn';

  @override
  String get scenarioRandom => 'Random System';

  @override
  String get scenarioRandomDescription =>
      'Randomly generated chaotic three-body system with unpredictable dynamics';

  @override
  String scenarioSaveFailedMessage(String error) {
    return 'Failed to save scenario: $error';
  }

  @override
  String get scenarioSavedSuccessMessage => 'Scenario saved successfully';

  @override
  String get scenarioSelectorFocused =>
      'Scenario selector focused - choose different simulations';

  @override
  String get scenarioSolarSystem => 'Solar System';

  @override
  String get scenarioSolarSystemDescription =>
      'Simplified version of our solar system with inner and outer planets';

  @override
  String get scenarioSpecial => 'Special Scenario';

  @override
  String get scenarioSpecialDescription =>
      'Special scenario for screenshot mode';

  @override
  String get scenariosAvailable => 'scenarios available';

  @override
  String get scenariosMenuDescription => 'Explore different scenarios';

  @override
  String get sceneActive =>
      'Scene active - simulation paused for screenshot capture';

  @override
  String get scenePreset => 'Scene Preset';

  @override
  String get scheduledMaintenanceInProgress =>
      'Scheduled maintenance in progress';

  @override
  String screenshotCountdown(int seconds) {
    return 'Screenshot in ${seconds}s';
  }

  @override
  String get screenshotMode => 'Screenshot Mode';

  @override
  String get screenshotModeSubtitle =>
      'Enable preset scenes for capturing marketing screenshots';

  @override
  String get selectAColorForTheCelestialBody =>
      'Select a color for the celestial body';

  @override
  String get selectNearestTitle => 'Select Nearest';

  @override
  String get selectObjectToFollowTooltip => 'Select Object to Follow';

  @override
  String get selectScenarioTooltip => 'Select Scenario';

  @override
  String get selectTheTypeOfCelestialBody =>
      'Select the type of celestial body';

  @override
  String get selectedStatLabel => 'Selected';

  @override
  String get showHelpTooltip => 'Help & Objectives';

  @override
  String get showLabelsDescription =>
      'Show celestial body names in the simulation';

  @override
  String get showLabelsTitle => 'Show Labels';

  @override
  String get showOrbitalPaths => 'Show Orbital Paths';

  @override
  String get showOrbitalPathsDescription =>
      'Display predicted orbital paths in scenarios with stable orbits';

  @override
  String get showStatisticsDescription =>
      'Display performance and physics stats';

  @override
  String get showStatisticsTitle => 'Show Statistics';

  @override
  String get showTrails => 'Show Trails';

  @override
  String get showTrailsDescription => 'Display motion trails behind objects';

  @override
  String get showTutorialTooltip => 'Show Tutorial';

  @override
  String get skipTutorial => 'Skip';

  @override
  String get softeningParameter => 'Softening Parameter';

  @override
  String get spatialCoordinatesDescription =>
      'Spatial coordinates in 3D space (X, Y, Z axes)';

  @override
  String get statusError => 'Error';

  @override
  String get statusLabel => 'Status';

  @override
  String get statusPaused => 'Paused';

  @override
  String get statusRunning => 'Running';

  @override
  String get statusStopped => 'Stopped';

  @override
  String get stellarColorBlue => 'Blue';

  @override
  String get stellarColorBlueWhite => 'Blue-white';

  @override
  String get stellarColorOrange => 'Orange';

  @override
  String get stellarColorRed => 'Red';

  @override
  String get stellarColorWhite => 'White';

  @override
  String get stellarColorYellow => 'Yellow';

  @override
  String get stellarColorYellowWhite => 'Yellow-white';

  @override
  String get stellarTemperatureDescription =>
      'Stellar temperature affecting light and heat emission';

  @override
  String stepsCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString';
  }

  @override
  String get stepsLabel => 'Steps';

  @override
  String get successTitle => 'Success';

  @override
  String get swipeUpToExpand => 'Swipe up to expand';

  @override
  String get tapPlayPauseButton => 'Tap play/pause button';

  @override
  String get tapResetButton => 'Tap reset button';

  @override
  String get tapToCenterCamera => 'Tap to center camera';

  @override
  String get tapToChangeScenario => 'Tap to change scenario';

  @override
  String get tapToInteractWithSimulation => 'Tap to interact with simulation';

  @override
  String get tapToOpenSettings => 'Tap to open settings';

  @override
  String get tapToSelect => 'Tap to select';

  @override
  String get tapToToggleAutoRotation => 'Tap to toggle auto-rotation';

  @override
  String get tapToToggleFullscreen => 'Tap to toggle fullscreen';

  @override
  String
  tapToViewAndEditDetailsBodyBodyTypeNameWithNumberUtilsFormatMassBodyMassEditorhint(
    String bodyType,
    String mass,
  ) {
    return 'Tap to view and edit details. $bodyType with $mass.';
  }

  @override
  String get trackingModeEssential => 'Essential Only';

  @override
  String get trackingModeEssentialDescription =>
      'Critical crashes and errors only';

  @override
  String get trackingModeFull => 'Full Tracking';

  @override
  String get trackingModeFullDescription =>
      'All analytics, crashes, and interactions';

  @override
  String get trackingModeLimited => 'Limited Tracking';

  @override
  String get trackingModeLimitedDescription => 'User interactions only';

  @override
  String get trackingModeNone => 'No Tracking';

  @override
  String get trackingModeNoneDescription => 'No data collection';

  @override
  String get trailColorLabel => 'Trail Color';

  @override
  String get trailFadeRate => 'Trail Fade Rate';

  @override
  String get trailLength => 'Trail Length';

  @override
  String get typeEditorLabel => 'Type';

  @override
  String get uiHapticFeedback => 'UI Haptic Feedback';

  @override
  String get unsavedChangesMessage =>
      'You have unsaved changes. Are you sure you want to leave?';

  @override
  String get unsavedChangesTitle => 'Unsaved Changes';

  @override
  String get uranusCyanColor => 'uranus cyan';

  @override
  String get useKeyboardShortcutsForControls =>
      'Use keyboard shortcuts for controls';

  @override
  String get useZoomControls => 'Use zoom controls';

  @override
  String get venusYellowColor => 'venus yellow';

  @override
  String get versionLabel => 'Version';

  @override
  String get versionStatusCurrent => 'Current';

  @override
  String get versionStatusOutdated => 'Out-of-Date';

  @override
  String get vibrationEnabled => 'Vibration Enabled';

  @override
  String get vibrationThrottle => 'Vibration Throttle';

  @override
  String get warmTrails => '🔥 Warm';

  @override
  String get websiteLabel => 'Website';

  @override
  String get whatToDoDescription =>
      'Graviton is a physics playground where you can:\n\n🪐 Explore realistic orbital mechanics\n🌟 Watch stellar evolution and collisions\n🎯 Learn about gravitational forces\n🎮 Experiment with different scenarios\n📚 Understand celestial dynamics\n🔄 Create endless random configurations';

  @override
  String get whatToDoTitle => 'What to Do in Graviton';

  @override
  String get whiteColor => 'white';

  @override
  String get xCoordinateEditorhint => 'X coordinate';

  @override
  String get xCoordinateLabel => 'X';

  @override
  String get xVelocityEditorhint => 'X velocity';

  @override
  String get yCoordinateEditorhint => 'Y coordinate';

  @override
  String get yCoordinateLabel => 'Y';

  @override
  String get yVelocityEditorhint => 'Y velocity';

  @override
  String get yawLabel => 'Yaw';

  @override
  String get yellowColor => 'yellow';

  @override
  String get zCoordinateEditorhint => 'Z coordinate';

  @override
  String get zCoordinateLabel => 'Z';

  @override
  String get zVelocityEditorhint => 'Z velocity';

  @override
  String orbitalEventCloseApproach(String distance) {
    return 'Close approach: $distance units';
  }

  @override
  String get accessibilityBodiesCombined =>
      'The combined mass creates a new celestial body';

  @override
  String get accessibilityBodiesInMotion =>
      'Celestial bodies are now in motion';

  @override
  String get accessibilityBodiesStopped =>
      'All celestial bodies have stopped moving';

  @override
  String get accessibilityBodiesResumed => 'Celestial bodies are moving again';

  @override
  String get accessibilityBodiesReset => 'All celestial bodies have been reset';

  @override
  String get accessibilityNewScenarioLoaded =>
      'New scenario loaded with fresh celestial bodies';

  @override
  String get accessibilityNewParametersLoaded =>
      'New celestial bodies and physics parameters loaded';

  @override
  String get scenarioTabPresets => 'Presets';

  @override
  String get scenarioTabCustom => 'Custom';

  @override
  String get savedScenariosTitle => 'Saved Scenarios';

  @override
  String get experimentsTitle => 'Experiments';

  @override
  String get experimentsSubtitle => 'Explore interesting physics concepts';

  @override
  String customScenarioBodyCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bodies',
      one: '1 body',
      zero: '0 bodies',
    );
    return '$_temp0';
  }

  @override
  String get customScenarioCreatedToday => 'Today';

  @override
  String get customScenarioCreatedYesterday => 'Yesterday';

  @override
  String customScenarioCreatedDaysAgo(int count, Object days) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '1 day ago',
    );
    return '$_temp0';
  }

  @override
  String customScenarioCreatedWeeksAgo(int count, Object weeks) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count weeks ago',
      one: '1 week ago',
    );
    return '$_temp0';
  }

  @override
  String customScenarioCreatedMonthsAgo(int count, Object months) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count months ago',
      one: '1 month ago',
    );
    return '$_temp0';
  }

  @override
  String get customScenarioCreatedUnknown => 'Unknown';

  @override
  String get orbitalPlacementEditor => 'Orbital Placement';

  @override
  String get placeInOrbitButton => 'Place in Orbit';

  @override
  String get centralBodySelector => 'Central Body';

  @override
  String get orbitRadiusEditor => 'Orbit Radius';

  @override
  String get orbitPhaseEditor => 'Orbit Phase';

  @override
  String get orbitInclinationEditor => 'Inclination';

  @override
  String get circularOrbitOption => 'Circular Orbit';

  @override
  String get ellipticalOrbitOption => 'Elliptical Orbit';

  @override
  String orbitalPeriodDisplay(String period) {
    return 'Period: $period';
  }

  @override
  String get noAvailableCentralBodies =>
      'No other bodies available for orbital placement';

  @override
  String get orbitalPlacementDescription =>
      'Configure this body to orbit around another celestial body with realistic physics';

  @override
  String get orbitalPlacementActiveDescription =>
      'Orbital placement is active. Position and velocity will be calculated automatically based on the orbit parameters below.';

  @override
  String get showGravitationalFieldVisualization =>
      'Show gravitational field visualization for this body';

  @override
  String get cancelOrbitalPlacement => 'Cancel Orbital Placement';

  @override
  String get makeStable => 'Make Stable';

  @override
  String get orbitalWarningMassiveBody =>
      '⚠️ Warning: Orbiting body is very massive relative to central body. This may cause unstable orbits or the bodies may orbit each other.';

  @override
  String get orbitalTipSignificantMass =>
      '💡 Tip: This is a significant mass ratio. Consider increasing orbital distance for stability.';

  @override
  String get orbitalWarningCloseOrbit =>
      '⚠️ Warning: Very close orbit. Risk of collision or tidal disruption.';

  @override
  String get orbitalTipDistantOrbit =>
      '💡 Tip: Distant orbit. Gravitational influence from other bodies may perturb this orbit.';

  @override
  String get orbitalGoodConfiguration =>
      '✅ Good orbital configuration for a stable system.';

  @override
  String get orbitalError => 'Error';

  @override
  String get orbitalConfigurationWarning =>
      'This orbital configuration may lead to collisions or ejections. Consider using the \"Make Stable\" button.';

  @override
  String get defaultBodyName => 'Celestial Body';

  @override
  String get orbitalPeriodLabel => 'Orbital Period';

  @override
  String get orbitIsStable => 'Orbit is Stable';

  @override
  String get orbitMayBeUnstable => 'Orbit May Be Unstable';

  @override
  String bodyTypeGeneric(String bodyType) {
    return '$bodyType body';
  }

  @override
  String orbitalRadiusIncreasedFeedback(String amount) {
    return 'increased by $amount units';
  }

  @override
  String orbitalRadiusDecreasedFeedback(String amount) {
    return 'decreased by $amount units';
  }

  @override
  String get orbitalRadiusFineTunedFeedback => 'fine-tuned';

  @override
  String orbitStabilizedMessage(String changeDescription, String finalRadius) {
    return 'Orbit stabilized! Radius $changeDescription to $finalRadius units. Phase and inclination reset for stability.';
  }

  @override
  String get experimentBinaryPulsarName => 'Binary Pulsar';

  @override
  String get experimentBinaryPulsarDescription =>
      'Two neutron stars spiraling inward due to gravitational waves';

  @override
  String get experimentBinaryPulsarDuration => '100 years';

  @override
  String get binaryPulsarPulsarA => 'Pulsar A';

  @override
  String get binaryPulsarNeutronStarB => 'Neutron Star B';

  @override
  String get binaryPulsarScenarioDescription =>
      'This scenario demonstrates: extreme gravitational fields, relativistic effects, gravitational wave emission, and orbital decay. The neutron stars will slowly spiral inward over time, eventually merging in a catastrophic collision that produces gravitational waves.';

  @override
  String get binaryPulsarAuthor => 'Graviton Physics Experiments';

  @override
  String get binaryPulsarEducationalFocus =>
      'Relativity and Gravitational Waves';

  @override
  String get experimentTrojanAsteroidsName => 'Trojan Asteroids';

  @override
  String get experimentTrojanAsteroidsDescription =>
      'Stable points in Jupiter\'s orbit where asteroids accumulate';

  @override
  String get experimentTrojanAsteroidsDuration => '50 years';

  @override
  String get trojanAsteroidsSun => 'Sun';

  @override
  String get trojanAsteroidsJupiter => 'Jupiter';

  @override
  String trojanAsteroidsL4Name(int number) {
    return 'L4 Trojan $number';
  }

  @override
  String trojanAsteroidsL5Name(int number) {
    return 'L5 Trojan $number';
  }

  @override
  String get trojanAsteroidsScenarioDescription =>
      'This scenario demonstrates: Lagrange points, stable orbital mechanics, three-body dynamics, and gravitational equilibrium. The Trojan asteroids remain in stable positions 60° ahead and behind Jupiter, trapped in gravitational balance.';

  @override
  String get trojanAsteroidsEducationalFocus =>
      'Lagrange Points and Orbital Stability';

  @override
  String get experimentDoubleStarEclipseName => 'Double Star Eclipse';

  @override
  String get experimentDoubleStarEclipseDescription =>
      'Binary star system where one star regularly eclipses the other';

  @override
  String get experimentDoubleStarEclipseDuration => '30 days';

  @override
  String get experimentRoguePlanetName => 'Rogue Planet';

  @override
  String get experimentRoguePlanetDescription =>
      'A planet ejected from its system encounters a new solar system';

  @override
  String get experimentRoguePlanetDuration => '500 years';

  @override
  String get experimentGravitationalSlingshotName => 'Gravitational Slingshot';

  @override
  String get experimentGravitationalSlingshotDescription =>
      'A spacecraft uses Jupiter\'s moon Io to gain speed and reach Europa';

  @override
  String get experimentGravitationalSlingshotDuration => '2 years';

  @override
  String get experimentDifficultyAdvanced => 'advanced';

  @override
  String get experimentDifficultyIntermediate => 'intermediate';

  @override
  String get experimentDifficultyBeginner => 'beginner';

  @override
  String experimentComingSoon(String scenarioName) {
    return 'Experimental scenario \"$scenarioName\" - Coming soon!';
  }

  @override
  String get unknownValue => 'Unknown';

  @override
  String get bodyPrimaryStar => 'Primary Star';

  @override
  String get bodySecondaryStar => 'Secondary Star';

  @override
  String get bodyInnerRockyPlanet => 'Inner Rocky Planet';

  @override
  String get bodyHabitablePlanet => 'Habitable Planet';

  @override
  String get bodyGasGiant => 'Gas Giant';

  @override
  String get bodyIceGiant => 'Ice Giant';

  @override
  String get bodyRoguePlanet => 'Rogue Planet';

  @override
  String get authorGravitonPhysicsTeam => 'Graviton Physics Team';

  @override
  String get doubleStarEclipseScenarioDescription =>
      'Watch as two stars orbit each other in a close binary system. Observe how the smaller secondary star regularly passes in front of the larger primary star, causing periodic eclipses. This demonstrates stellar photometry, binary orbital mechanics, and how astronomers discover exoplanets using similar transit methods.';

  @override
  String get doubleStarEclipseEducationalFocus =>
      'Binary stars, eclipses, stellar photometry';

  @override
  String get roguePlanetScenarioDescription =>
      'A stable solar system with well-spaced planetary orbits encounters a massive rogue planet approaching from interstellar space. Watch as the intruder\'s gravity disrupts the delicate orbital balance, potentially ejecting planets or creating chaotic gravitational interactions. This scenario demonstrates planetary system dynamics, gravitational slingshot effects, and how rogue planets can reshape entire solar systems.';

  @override
  String get roguePlanetEducationalFocus =>
      'Rogue planets, gravitational encounters, orbital disruption';

  @override
  String get simulationInfoTitle => 'Simulation Info';

  @override
  String get scenarioInfoTitle => 'Scenario Information';

  @override
  String get scenarioNameLabel => 'Scenario';

  @override
  String get bodyStatisticsTitle => 'Body Statistics';

  @override
  String get totalBodiesLabel => 'Total Bodies';

  @override
  String get starsLabel => 'Stars';

  @override
  String get planetsLabel => 'Planets';

  @override
  String get asteroidsLabel => 'Asteroids & Moons';

  @override
  String get blackHolesLabel => 'Black Holes';

  @override
  String get totalMassLabel => 'Total Mass';

  @override
  String get habitableWorldsLabel => 'Habitable Worlds';

  @override
  String get physicsInfoTitle => 'Physics Parameters';

  @override
  String get timeScaleLabel => 'Time Scale';

  @override
  String get gravitationalConstantLabel => 'Gravitational Constant';

  @override
  String get softeningParameterLabel => 'Softening Parameter';

  @override
  String get collisionRadiusLabel => 'Collision Radius';

  @override
  String get scenarioThreeBodyClassic => 'Three-Body Classic';

  @override
  String get scenarioThreeBodyClassicDescription =>
      'Classic three-body problem demonstrating chaotic gravitational dynamics';

  @override
  String get scenarioCollisionDemo => 'Collision Demo';

  @override
  String get scenarioCollisionDemoDescription =>
      'Collision demonstration with orbital mechanics and body interactions';

  @override
  String get scenarioDeepSpace => 'Deep Space';

  @override
  String get scenarioDeepSpaceDescription =>
      'Deep space exploration with distant objects and sparse gravitational fields';

  @override
  String get systemEnergyLabel => 'Total Energy';

  @override
  String get kineticEnergyLabel => 'Kinetic Energy';

  @override
  String get potentialEnergyLabel => 'Potential Energy';

  @override
  String get angularMomentumLabel => 'Angular Momentum';

  @override
  String get centerOfMassLabel => 'Center of Mass';

  @override
  String get velocityRangeLabel => 'Velocity Range';

  @override
  String get averageVelocityLabel => 'Average Velocity';

  @override
  String get temperatureRangeLabel => 'Temperature Range';

  @override
  String get systemMomentumLabel => 'System Momentum';

  @override
  String get energyDynamicsTitle => 'Energy & Dynamics';

  @override
  String get orbitalMechanicsTitle => 'Orbital Mechanics';

  @override
  String get celestialBodiesTitle => 'Celestial Bodies';

  @override
  String get bodyNameLabel => 'Name';

  @override
  String get bodyMassLabel => 'Mass';

  @override
  String get bodyRadiusLabel => 'Radius';

  @override
  String get bodyVelocityLabel => 'Velocity';

  @override
  String get bodyTemperatureLabel => 'Temperature';

  @override
  String get bodyLuminosityLabel => 'Luminosity';

  @override
  String get bodyPositionLabel => 'Position';

  @override
  String get bodyTypeLabel => 'Type';

  @override
  String get bodyHabitabilityLabel => 'Habitability';

  @override
  String get bodyKineticEnergyLabel => 'Kinetic Energy';

  @override
  String get bodyEscapeVelocityLabel => 'Escape Velocity';

  @override
  String get bodyDistanceFromCenterLabel => 'Distance from Center';

  @override
  String get bodyOrbitalPeriodLabel => 'Orbital Period';

  @override
  String get notApplicableValue => 'N/A';

  @override
  String get habitableStatus => 'Habitable';

  @override
  String get unknownHabitabilityStatus => 'Unknown';

  @override
  String get tooHotStatus => 'Too Hot';

  @override
  String get tooColdStatus => 'Too Cold';

  @override
  String get noAtmosphereStatus => 'No Atmosphere';

  @override
  String get selectBody => 'Select Body';

  @override
  String get noBodiesAvailable => 'No bodies available';

  @override
  String get share => 'Share';

  @override
  String get shareSimulation => 'Share Simulation';

  @override
  String get shareImage => 'Share Image';

  @override
  String get shareImageDescription => 'Capture and share the current view';

  @override
  String get shareState => 'Share State';

  @override
  String get shareStateDescription =>
      'Export simulation data as importable file';

  @override
  String get shareSuccess => 'Shared successfully';

  @override
  String get shareFailed => 'Failed to share';

  @override
  String get shareImageError => 'Cannot capture image. Please try again.';

  @override
  String get shareSubject => 'Graviton Simulation';

  @override
  String get shareSnapshotSubject => 'Graviton Simulation Snapshot';

  @override
  String get shareText => 'Check out this gravitational simulation!';

  @override
  String get importScenario => 'Import Scenario';

  @override
  String get importScenarioDescription => 'Load a scenario from a JSON file';

  @override
  String get importSuccess => 'Scenario imported successfully';

  @override
  String get importFailed => 'Failed to import scenario';

  @override
  String get importInvalidFile =>
      'Invalid file format. Please select a valid JSON file.';

  @override
  String get importFileNotFound => 'File not found. Please try again.';

  @override
  String get importCancelled => 'Import cancelled';

  @override
  String get accountManagementTitle => 'Account';

  @override
  String get accountButtonTooltip => 'Account & Profile';

  @override
  String get signInPromptTitle => 'Sign In to Your Account';

  @override
  String get signInPromptMessage =>
      'Create an account or sign in to sync your data and preferences across devices.';

  @override
  String get signInButton => 'Sign In';

  @override
  String get signOutButton => 'Sign Out';

  @override
  String get resetSessionButton => 'Reset Session';

  @override
  String get signOutSuccess => 'Successfully signed out';

  @override
  String get operationTimeout => 'Operation timed out. Please try again.';

  @override
  String get operationFailed => 'Operation failed. Please try again.';

  @override
  String get couldNotOpenLink => 'Could not open link. Please try again.';

  @override
  String get pleaseWaitBeforeRetrying =>
      'Please wait a moment before trying again.';

  @override
  String rateLimitWithCooldown(int seconds) {
    return 'Please wait $seconds seconds before trying again.';
  }

  @override
  String get networkError =>
      'Network error. Please check your connection and try again.';

  @override
  String get continueAsGuestButton => 'Continue as Guest';

  @override
  String get signInAnonymousSuccess => 'Signed in as guest';

  @override
  String get anonymousUserLabel => 'Guest User';

  @override
  String get guestAccountLabel => 'Guest Account';

  @override
  String get authenticatedLabel => 'Account';

  @override
  String get changeAvatarTooltip => 'Change Avatar';

  @override
  String get editDisplayNameTooltip => 'Edit Name';

  @override
  String get accountActionsSection => 'Account Actions';

  @override
  String get upgradeAccountTitle => 'Upgrade to Full Account';

  @override
  String get upgradeAccountDescription =>
      'Save your data and access it from any device';

  @override
  String get accountManagementSection => 'Account Management';

  @override
  String get dangerZoneSection => 'Danger Zone';

  @override
  String get deleteAccountButton => 'Delete Account';

  @override
  String get avatarChangedSuccess => 'Avatar updated successfully';

  @override
  String get avatarChangedError => 'Failed to update avatar';

  @override
  String get accountMenuDescription => 'Manage your account and profile';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get createAccountButton => 'Create Account';

  @override
  String get pleaseEnterEmail => 'Please enter your email';

  @override
  String get pleaseEnterValidEmail => 'Please enter a valid email';

  @override
  String get pleaseEnterPassword => 'Please enter your password';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters';

  @override
  String get alreadyHaveAccount => 'Already have an account? Sign In';

  @override
  String get needAccount => 'Need an account? Create One';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get continueWithGitHub => 'Continue with GitHub';

  @override
  String get continueWithApple => 'Continue with Apple';

  @override
  String get moreProviders => 'More Providers';

  @override
  String get chooseProvider => 'Choose Provider';

  @override
  String get selectAvatarTitle => 'Select Avatar';

  @override
  String get editAccountInformationTitle => 'Edit Account Information';

  @override
  String get displayNameLabel => 'Display Name';

  @override
  String get pleaseEnterDisplayName => 'Please enter a display name';

  @override
  String get displayNameMinLength => 'Name must be at least 2 characters';

  @override
  String get deleteAccountTitle => 'Delete Account';

  @override
  String get deleteAccountWarning => 'This action cannot be undone.';

  @override
  String get deleteAccountMessage =>
      'Deleting your account will permanently remove any data associated with it.';

  @override
  String get deleteAccountItem1 => 'Your profile and avatar';

  @override
  String get deleteAccountItem2 => 'All saved preferences';

  @override
  String get deleteAccountItem3 => 'Custom scenarios and settings';

  @override
  String get deleteAccountItem4 => 'Account authentication';

  @override
  String get deleteAccountPasswordPrompt =>
      'Please enter your password to confirm:';

  @override
  String get orDivider => 'OR';

  @override
  String get displayNameHint => 'Enter your name (optional)';

  @override
  String get emailHint => 'Your email address';

  @override
  String get passwordHint => 'Your password';

  @override
  String get alreadyHaveAccountSignIn => 'Already have an account? Sign in';

  @override
  String get needAccountCreateOne => 'Don\'t have an account? Create one';

  @override
  String get useGoogleProfilePhoto => 'Use Google Profile Photo';

  @override
  String get customAvatars => 'Custom Avatars';

  @override
  String get saveAvatar => 'Save Avatar';

  @override
  String get displayNameFieldLabel => 'Display Name';

  @override
  String get displayNameFieldHint => 'Enter your display name';

  @override
  String get saveAccountInformation => 'Save Account Information';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get emailInvalid => 'Please enter a valid email address';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get passwordTooShort => 'Password must be at least 8 characters';

  @override
  String get passwordMissingUppercase =>
      'Password must contain at least one uppercase letter';

  @override
  String get passwordMissingLowercase =>
      'Password must contain at least one lowercase letter';

  @override
  String get passwordMissingNumber =>
      'Password must contain at least one number';

  @override
  String get passwordMissingSpecialChar =>
      'Password must contain at least one special character (!@#\$%^&*...)';

  @override
  String get tooManyAttempts =>
      'Too many failed sign-in attempts. Please try again in 15 minutes.';

  @override
  String get emailVerificationRequired =>
      'Please verify your email address before accessing this feature. Check your inbox for the verification link.';

  @override
  String get defaultUserName => 'User';

  @override
  String get googleSignInError =>
      'Google sign-in was canceled or failed. Please try again.';

  @override
  String get gitHubSignInError =>
      'GitHub sign-in was canceled or failed. Please try again.';

  @override
  String get appleSignInError =>
      'Apple sign-in was canceled or failed. Please try again.';

  @override
  String get displayNameUpdated => 'Display name updated';

  @override
  String get displayNameUpdateFailed => 'Failed to update display name';

  @override
  String get sessionResetSuccess => 'Session reset successfully';

  @override
  String get accountDeletedSuccess => 'Account deleted successfully';

  @override
  String get errorUserNotFound => 'No account found with this email address.';

  @override
  String get errorWrongPassword => 'Incorrect password. Please try again.';

  @override
  String get errorInvalidEmail => 'Invalid email address format.';

  @override
  String get errorUserDisabled => 'This account has been disabled.';

  @override
  String get errorEmailInUse =>
      'An account already exists with this email address.';

  @override
  String get errorWeakPassword =>
      'Password is too weak. Please use a stronger password.';

  @override
  String get errorOperationNotAllowed => 'This sign-in method is not enabled.';

  @override
  String get errorRequiresRecentLogin =>
      'Please sign in again to perform this action.';

  @override
  String get errorNetworkFailed =>
      'Network error. Please check your connection.';

  @override
  String errorUnknown(String message) {
    return 'An error occurred: $message';
  }

  @override
  String get exceptionGoogleSignInNotInitialized =>
      'Google Sign-In not initialized';

  @override
  String get exceptionGoogleSignInTimeout => 'Google sign-in timed out';

  @override
  String get exceptionAppleSignInPlatform =>
      'Apple Sign-In is only available on Apple platforms';

  @override
  String get exceptionNoAnonymousUser => 'No anonymous user to link';

  @override
  String get exceptionNoUserSignedIn => 'No user signed in';

  @override
  String get firebaseErrorUserNotFound =>
      'No account found with this email address.';

  @override
  String get firebaseErrorWrongPassword =>
      'Incorrect password. Please try again.';

  @override
  String get firebaseErrorInvalidEmail => 'Invalid email address format.';

  @override
  String get firebaseErrorUserDisabled => 'This account has been disabled.';

  @override
  String get firebaseErrorEmailInUse =>
      'An account already exists with this email address.';

  @override
  String get firebaseErrorWeakPassword =>
      'Password is too weak. Please use a stronger password.';

  @override
  String get firebaseErrorOperationNotAllowed =>
      'This sign-in method is not enabled.';

  @override
  String get firebaseErrorRequiresRecentLogin =>
      'Please sign in again to perform this action.';

  @override
  String get firebaseErrorNetworkFailed =>
      'Network error. Please check your connection.';

  @override
  String get firebaseErrorAccountExistsWithDifferentCredential =>
      'An account already exists with this email using a different sign-in method. Please sign in with the original method.';

  @override
  String firebaseErrorDefault(String message) {
    return 'An error occurred: $message';
  }

  @override
  String get integrityErrorDeviceIntegrityTitle => 'Device Security Issue';

  @override
  String get integrityErrorDeviceIntegrity =>
      'Your device does not meet the security requirements for this operation.';

  @override
  String integrityGuidanceDeviceIntegrity(String reference) {
    return 'Please ensure your device passes Google Play Protect checks and is not rooted or modified. If you believe this is an error, contact support with reference: $reference';
  }

  @override
  String get integrityErrorAppIntegrityTitle => 'App Installation Issue';

  @override
  String get integrityErrorAppIntegrity =>
      'The app installation could not be verified.';

  @override
  String integrityGuidanceAppIntegrity(String reference) {
    return 'Please ensure you\'re using the official app from Google Play Store. Sideloaded or modified apps are not supported. Reference: $reference';
  }

  @override
  String get integrityErrorNetworkTitle => 'Connection Error';

  @override
  String get integrityErrorNetwork =>
      'Could not verify device security due to a network error.';

  @override
  String integrityGuidanceNetwork(String reference) {
    return 'Please check your internet connection and try again. If the problem persists, contact support with reference: $reference';
  }

  @override
  String get integrityErrorBackendVerificationTitle => 'Verification Failed';

  @override
  String get integrityErrorBackendVerification =>
      'Security verification could not be completed.';

  @override
  String integrityGuidanceBackendVerification(String reference) {
    return 'There was an issue verifying your device. Please try again later. If this continues, contact support with reference: $reference';
  }

  @override
  String get integrityErrorTokenRequestTitle => 'Security Check Failed';

  @override
  String get integrityErrorTokenRequest =>
      'Could not perform security verification.';

  @override
  String integrityGuidanceTokenRequest(String reference) {
    return 'Unable to generate security token. Please restart the app and try again. If the issue persists, contact support with reference: $reference';
  }

  @override
  String get integrityErrorUnknownTitle => 'Verification Error';

  @override
  String get integrityErrorUnknown =>
      'An unexpected error occurred during security verification.';

  @override
  String integrityGuidanceUnknown(String reference) {
    return 'Please try again. If the problem continues, contact support with reference: $reference';
  }

  @override
  String get emailVerificationSent =>
      'Verification email sent! Please check your inbox.';

  @override
  String get emailVerificationResent =>
      'Verification email resent successfully.';

  @override
  String get emailNotVerified => 'Email not verified';

  @override
  String get emailVerified => 'Email verified';

  @override
  String get verifyEmailAddress => 'Verify Email Address';

  @override
  String get verifyEmailMessage =>
      'Please verify your email address to access all features. Check your inbox for the verification link.';

  @override
  String get sendVerificationEmail => 'Send Verification Email';

  @override
  String get resendVerificationEmail => 'Resend Verification Email';

  @override
  String get checkVerificationStatus => 'Check Verification Status';

  @override
  String get emailVerificationPending => 'Email verification pending';

  @override
  String verificationEmailCooldown(int seconds) {
    return 'Please wait $seconds seconds before requesting another verification email.';
  }

  @override
  String get termsAndPrivacy => 'Terms & Privacy';

  @override
  String get acceptTermsAndPrivacy =>
      'I accept the Terms of Service and Privacy Policy';

  @override
  String get mustAcceptTerms =>
      'You must accept the Terms of Service and Privacy Policy to continue.';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get viewTermsOfService => 'View Terms of Service';

  @override
  String get viewPrivacyPolicy => 'View Privacy Policy';

  @override
  String termsLastUpdated(String date) {
    return 'Last updated: $date';
  }

  @override
  String privacyLastUpdated(String date) {
    return 'Last updated: $date';
  }

  @override
  String get ageRequirement =>
      'You must be 13 years or older to create an account.';

  @override
  String get confirmAge => 'I confirm that I am 13 years or older';

  @override
  String get exceptionEmailVerificationFailed =>
      'exceptionEmailVerificationFailed';

  @override
  String get exceptionEmailVerificationCooldown =>
      'exceptionEmailVerificationCooldown';

  @override
  String get exceptionTermsNotAccepted => 'exceptionTermsNotAccepted';

  @override
  String get collisionEffectsTitle => 'Collision Effects';

  @override
  String get showCollisionDebris => 'Debris Particles';

  @override
  String get showCollisionDebrisDescription =>
      'Ejected particles from collision impacts with physics-based trajectories';

  @override
  String get showCollisionShockwaves => 'Shockwave Rings';

  @override
  String get showCollisionShockwavesDescription =>
      'Expanding energy rings from collision points scaled by impact force';

  @override
  String get showCollisionEjection => 'Material Ejection';

  @override
  String get showCollisionEjectionDescription =>
      'Billowing clouds of material expelled during high-energy impacts';

  @override
  String get showCollisionPlasmaJets => 'Plasma Jets';

  @override
  String get showCollisionPlasmaJetsDescription =>
      'Directional superheated streams from massive star collisions (experimental)';

  @override
  String get liveSessionHosting => 'Hosting Live Session';

  @override
  String get liveSessionNotHosting => 'Share Live Session';

  @override
  String get liveSessionStartHosting => 'Start Hosting';

  @override
  String get liveSessionStopHosting => 'Stop Sharing';

  @override
  String get liveSessionUpdateSession => 'Update Session';

  @override
  String liveSessionViewerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count viewers',
      one: '1 viewer',
      zero: 'No viewers',
    );
    return '$_temp0';
  }

  @override
  String get liveSessionNoViewers => 'No one is watching yet';

  @override
  String get liveSessionBrowseSessions => 'Browse Sessions';

  @override
  String get liveSessionNoSessions => 'No active sessions';

  @override
  String get liveSessionJoin => 'Join';

  @override
  String get liveSessionYourSession => 'Your Session';

  @override
  String get liveSessionLeave => 'Leave Session';

  @override
  String get liveSessionViewing => 'Viewing Live Session';

  @override
  String liveSessionHostedBy(String hostName) {
    return 'Hosted by $hostName';
  }

  @override
  String liveSessionScenario(String scenarioName) {
    return 'Scenario: $scenarioName';
  }

  @override
  String get liveSessionRequiresAuth =>
      'Sign in to share or view live sessions';

  @override
  String get liveSessionStatusDisconnected => 'Disconnected';

  @override
  String get liveSessionStatusConnecting => 'Connecting...';

  @override
  String get liveSessionStatusConnected => 'Connected';

  @override
  String get liveSessionStatusReconnecting => 'Reconnecting...';

  @override
  String get liveSessionStatusError => 'Connection Error';

  @override
  String liveSessionConnectionStatusLabel(String status) {
    return 'Connection status: $status';
  }

  @override
  String get liveSessionTapForSettings => 'Tap for session settings';

  @override
  String get liveSessionIndicatorTooltip => 'Live Session';

  @override
  String get liveSessionErrorHostingFailed =>
      'Failed to start hosting. Please try again.';

  @override
  String get liveSessionErrorJoinFailed =>
      'Failed to join session. Please try again.';

  @override
  String get liveSessionErrorConnectionLost =>
      'Connection lost. Attempting to reconnect...';

  @override
  String get liveSessionTitle => 'Live Session';

  @override
  String get liveSessionDescription =>
      'Share your simulation or join others in real-time';

  @override
  String get liveSessionHostingDescription =>
      'Broadcasting your simulation to viewers';

  @override
  String get liveSessionViewingDescription =>
      'Watching a live simulation broadcast';

  @override
  String get liveSessionMenuTitle => 'Live Sessions';

  @override
  String get liveSessionMenuDescription =>
      'Share or join real-time simulations';

  @override
  String get liveSessionBrowseTab => 'Browse';

  @override
  String get liveSessionStartSharingTab => 'Sharing';

  @override
  String get liveSessionBrowseDescription =>
      'Join a live session to watch another user\'s simulation in real-time';

  @override
  String get liveSessionShareDescription =>
      'Share your current simulation with others in real-time';

  @override
  String get liveSessionScenarioToShare => 'Scenario to share';

  @override
  String get liveSessionPasswordProtection => 'Password Protection';

  @override
  String get liveSessionSetPassword => 'Enter password';

  @override
  String get liveSessionPasswordDescription =>
      'Viewers will need to enter this password to join your session';

  @override
  String get liveSessionCameraSync => 'Camera Sync';

  @override
  String get liveSessionCameraSyncDescription =>
      'Viewers will see the same camera angle and movements as you';

  @override
  String get liveSessionPasswordRequired => 'Please enter a password';

  @override
  String get liveSessionEnterPassword => 'Enter Password';

  @override
  String get liveSessionPasswordHint => 'Session password';

  @override
  String get liveSessionPasswordProtected => 'Password protected';

  @override
  String get liveSessionPasswordEnabled => 'Password required to join';

  @override
  String get liveSessionPasswordDisabled => 'Anyone can join';

  @override
  String get liveSessionIncorrectPassword => 'Incorrect password';

  @override
  String get liveSessionRequiresAccountTitle => 'Account Required';

  @override
  String get liveSessionRequiresAccountMessage =>
      'Live sessions are available to registered users. Create a free account to share your simulations with others.';

  @override
  String get liveSessionCreateAccount => 'Create Account';

  @override
  String get liveSessionSessionName => 'Session Name';

  @override
  String get liveSessionSessionNameHint => 'Give your session a name';

  @override
  String get liveSessionSettings => 'Session Settings';
}
