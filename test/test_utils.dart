import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:graviton/core/enums/body_type.dart';
import 'package:graviton/core/enums/habitability_status.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/celestial/body.dart';
import 'package:graviton/models/celestial/body_data.dart';
import 'package:graviton/features/scenarios/domain/custom_scenario.dart';
import 'package:graviton/features/scenarios/domain/objectives_config.dart';
import 'package:graviton/features/scenarios/domain/particle_systems_config.dart';
import 'package:graviton/features/scenarios/domain/scenario_configuration.dart';
import 'package:graviton/features/scenarios/domain/scenario_metadata.dart';
import 'package:graviton/features/scenarios/domain/scenario_physics_settings.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:vector_math/vector_math_64.dart' as vm;
import 'package:mockito/mockito.dart';

import 'test_mocks.mocks.dart';

/// Test utilities for widget testing
class TestUtils {
  /// Wraps a widget with MaterialApp and localization support for testing
  static Widget wrapWithMaterialApp({required Widget child, ThemeData? theme}) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: theme,
      home: Scaffold(body: child),
    );
  }

  /// Wraps a widget with MaterialApp in a Scaffold for drawer testing
  static Widget wrapWithScaffold({
    required Widget child,
    Widget? endDrawer,
    ThemeData? theme,
  }) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: theme,
      home: Scaffold(body: child, endDrawer: endDrawer),
    );
  }

  /// Creates a test star for use in tests
  static Body createTestStar({
    String name = 'Test Star',
    double mass = 1.989e30, // Solar mass
    double radius = 6.96e8, // Solar radius
    vm.Vector3? position,
    vm.Vector3? velocity,
    double temperature = 5778,
    double stellarLuminosity = 3.828e26,
    Color? color,
  }) {
    return Body(
      name: name,
      mass: mass,
      radius: radius,
      position: position ?? vm.Vector3.zero(),
      velocity: velocity ?? vm.Vector3.zero(),
      color: color ?? AppColors.stellarGType,
      bodyType: BodyType.star,
      temperature: temperature,
      stellarLuminosity: stellarLuminosity,
    );
  }

  /// Creates a test planet for use in tests
  static Body createTestPlanet({
    String name = 'Test Planet',
    double mass = 5.972e24, // Earth mass
    double radius = 6.371e6, // Earth radius
    vm.Vector3? position,
    vm.Vector3? velocity,
    double temperature = 288,
    HabitabilityStatus habitabilityStatus = HabitabilityStatus.unknown,
    Color? color,
  }) {
    return Body(
      name: name,
      mass: mass,
      radius: radius,
      position: position ?? vm.Vector3(1.496e11, 0, 0), // 1 AU from origin
      velocity: velocity ?? vm.Vector3(0, 29780, 0), // Earth orbital velocity
      color: color ?? AppColors.terrestrialEarthLike,
      bodyType: BodyType.planet,
      temperature: temperature,
      habitabilityStatus: habitabilityStatus,
    );
  }

  /// Creates a test moon for use in tests
  static Body createTestMoon({
    String name = 'Test Moon',
    double mass = 7.342e22, // Luna mass
    double radius = 1.737e6, // Luna radius
    vm.Vector3? position,
    vm.Vector3? velocity,
    double temperature = 220,
    Color? color,
  }) {
    return Body(
      name: name,
      mass: mass,
      radius: radius,
      position:
          position ??
          vm.Vector3(1.496e11 + 3.844e8, 0, 0), // Earth + Moon distance
      velocity:
          velocity ??
          vm.Vector3(
            0,
            29780 + 1022,
            0,
          ), // Earth velocity + Moon orbital velocity
      color: color ?? AppColors.moonRocky,
      bodyType: BodyType.moon,
      temperature: temperature,
    );
  }

  /// Creates a test asteroid for use in tests
  static Body createTestAsteroid({
    String name = 'Test Asteroid',
    double mass = 9.39e20, // Ceres mass
    double radius = 4.73e5, // Ceres radius
    vm.Vector3? position,
    vm.Vector3? velocity,
    double temperature = 168,
    Color? color,
  }) {
    return Body(
      name: name,
      mass: mass,
      radius: radius,
      position: position ?? vm.Vector3(4.14e11, 0, 0), // Asteroid belt distance
      velocity: velocity ?? vm.Vector3(0, 17900, 0), // Asteroid belt velocity
      color: color ?? AppColors.asteroidBrownish,
      bodyType: BodyType.asteroid,
      temperature: temperature,
    );
  }

  /// Creates a test black hole for use in tests
  static Body createTestBlackHole({
    String name = 'Test Black Hole',
    double mass = 1.989e31, // 10 solar masses
    double radius = 2.95e4, // Schwarzschild radius for 10 solar masses
    vm.Vector3? position,
    vm.Vector3? velocity,
    double temperature = 0,
    Color? color,
  }) {
    return Body(
      name: name,
      mass: mass,
      radius: radius,
      position: position ?? vm.Vector3.zero(),
      velocity: velocity ?? vm.Vector3.zero(),
      color: color ?? AppColors.spacePureBlack,
      bodyType: BodyType.blackHole,
      temperature: temperature,
    );
  }

  /// Creates a test custom scenario for testing purposes
  static CustomScenario createTestCustomScenario({
    String name = 'Test Scenario',
    String description = 'A test scenario for unit testing',
    List<BodyData>? bodies,
  }) {
    return CustomScenario(
      version: '1.0.0',
      metadata: ScenarioMetadata(
        name: name,
        description: description,
        author: 'Test Author',
        createdAt: DateTime.now(),
        educationalFocus: 'orbital mechanics',
        tags: ['test', 'unit-test'],
        difficulty: 'intermediate',
      ),
      configuration: ScenarioConfiguration(
        optimalCameraDistance: 1e12,
        cameraDistanceMultiplier: 1.0,
        expectedBodyCount: 3,
      ),
      physics: ScenarioPhysicsSettings(
        gravitationalConstant: 6.67430e-11,
        softening: 0.1,
        timeScale: 1.0,
        collisionRadiusMultiplier: 1.0,
        maxTrailPoints: 1000,
        trailFadeRate: 0.01,
      ),
      bodies: bodies ?? _createTestBodies(),
      particleSystems: const ParticleSystemsConfig(),
      objectives: null,
    );
  }

  /// Creates a complex test custom scenario with all optional fields
  static CustomScenario createComplexCustomScenario() {
    return CustomScenario(
      version: '1.0.0',
      metadata: ScenarioMetadata(
        name: 'Complex Test Scenario',
        description: 'A complex scenario with all features enabled',
        author: 'Test Author',
        createdAt: DateTime.now(),
        educationalFocus: 'complex orbital mechanics',
        tags: ['test', 'complex', 'educational'],
        difficulty: 'advanced',
      ),
      configuration: ScenarioConfiguration(
        optimalCameraDistance: 2e12,
        cameraDistanceMultiplier: 1.5,
        expectedBodyCount: 5,
      ),
      physics: ScenarioPhysicsSettings(
        gravitationalConstant: 6.67430e-11,
        softening: 0.05,
        timeScale: 2.0,
        collisionRadiusMultiplier: 1.2,
        maxTrailPoints: 5000,
        trailFadeRate: 0.005,
      ),
      bodies: _createComplexTestBodies(),
      particleSystems: const ParticleSystemsConfig(),
      objectives: const ObjectivesConfig(
        enabled: true,
        primary: 'Test primary objective',
        secondary: 'Test secondary objective',
        timeLimit: 3600,
      ),
    );
  }

  /// Creates a minimal test custom scenario
  static CustomScenario createMinimalCustomScenario() {
    return CustomScenario(
      version: '1.0.0',
      metadata: ScenarioMetadata(
        name: 'Minimal Test Scenario',
        description: 'A minimal scenario for testing',
        author: 'Test Author',
        createdAt: DateTime.now(),
        educationalFocus: '',
        tags: [],
        difficulty: 'beginner',
      ),
      configuration: ScenarioConfiguration(
        cameraDistanceMultiplier: 1.0,
        expectedBodyCount: 1,
      ),
      physics: ScenarioPhysicsSettings(
        gravitationalConstant: 6.67430e-11,
        softening: 0.1,
        timeScale: 1.0,
        collisionRadiusMultiplier: 1.0,
        maxTrailPoints: 100,
        trailFadeRate: 0.01,
      ),
      bodies: [_createMinimalTestBody()],
      particleSystems: const ParticleSystemsConfig(),
      objectives: null,
    );
  }

  /// Creates test bodies for custom scenarios
  static List<BodyData> _createTestBodies() {
    return [
      BodyData(
        name: 'Test Star',
        position: [0.0, 0.0, 0.0],
        velocity: [0.0, 0.0, 0.0],
        mass: 1.989e30,
        radius: 6.96e8,
        color: '#FFA500',
        bodyType: BodyType.star,
        stellarLuminosity: 3.828e26,
        temperature: 5778.0,
        showGravityWell: false,
        isPlanet: false,
        habitabilityStatus: HabitabilityStatus.unknown,
      ),
      BodyData(
        name: 'Test Planet',
        position: [1.496e11, 0.0, 0.0],
        velocity: [0.0, 29780.0, 0.0],
        mass: 5.972e24,
        radius: 6.371e6,
        color: '#4169E1',
        bodyType: BodyType.planet,
        stellarLuminosity: 0.0,
        temperature: 288.0,
        showGravityWell: false,
        isPlanet: true,
        habitabilityStatus: HabitabilityStatus.habitable,
      ),
      BodyData(
        name: 'Test Moon',
        position: [1.496e11 + 3.844e8, 0.0, 0.0],
        velocity: [0.0, 29780.0 + 1022.0, 0.0],
        mass: 7.342e22,
        radius: 1.737e6,
        color: '#C0C0C0',
        bodyType: BodyType.moon,
        stellarLuminosity: 0.0,
        temperature: 250.0,
        showGravityWell: false,
        isPlanet: false,
        habitabilityStatus: HabitabilityStatus.unknown,
      ),
    ];
  }

  /// Creates complex test bodies for advanced scenarios
  static List<BodyData> _createComplexTestBodies() {
    final basicBodies = _createTestBodies();

    // Add additional complex bodies
    basicBodies.addAll([
      BodyData(
        name: 'Test Asteroid',
        position: [4.14e11, 0.0, 0.0],
        velocity: [0.0, 17900.0, 0.0],
        mass: 9.393e20,
        radius: 4.73e5,
        color: '#8B4513',
        bodyType: BodyType.asteroid,
        stellarLuminosity: 0.0,
        temperature: 168.0,
        showGravityWell: false,
        isPlanet: false,
        habitabilityStatus: HabitabilityStatus.unknown,
      ),
      BodyData(
        name: 'Test Comet',
        position: [5.9e12, 0.0, 0.0],
        velocity: [0.0, 5000.0, 0.0],
        mass: 2.2e14,
        radius: 2.2e3,
        color: '#87CEEB',
        bodyType: BodyType.asteroid,
        stellarLuminosity: 0.0,
        temperature: 50.0,
        showGravityWell: false,
        isPlanet: false,
        habitabilityStatus: HabitabilityStatus.unknown,
      ),
    ]);

    return basicBodies;
  }

  /// Creates a minimal test body
  static BodyData _createMinimalTestBody() {
    return BodyData(
      name: 'Minimal Body',
      position: [0.0, 0.0, 0.0],
      velocity: [0.0, 0.0, 0.0],
      mass: 1e24,
      radius: 1e6,
      color: '#FFFFFF',
      bodyType: BodyType.planet,
      stellarLuminosity: 0.0,
      temperature: 273.0,
      showGravityWell: false,
      isPlanet: true,
      habitabilityStatus: HabitabilityStatus.unknown,
    );
  }

  /// Creates a mock AppLocalizations for testing with default implementations
  /// This mock provides basic English strings for all localization methods
  static MockAppLocalizations createMockAppLocalizations() {
    final mockL10n = MockAppLocalizations();

    // Setup basic scenario and body naming methods
    when(mockL10n.bodyAlpha).thenReturn('Alpha');
    when(mockL10n.bodyBeta).thenReturn('Beta');
    when(mockL10n.bodyGamma).thenReturn('Gamma');
    when(mockL10n.bodyRockyPlanet).thenReturn('Rocky Planet');
    when(mockL10n.bodyEarthLike).thenReturn('Earth-Like');
    when(mockL10n.bodySuperEarth).thenReturn('Super Earth');
    when(mockL10n.bodySun).thenReturn('Sun');
    when(mockL10n.bodyEarth).thenReturn('Earth');
    when(mockL10n.bodyMoon).thenReturn('Moon');
    when(mockL10n.bodyMercury).thenReturn('Mercury');
    when(mockL10n.bodyVenus).thenReturn('Venus');
    when(mockL10n.bodyMars).thenReturn('Mars');
    when(mockL10n.bodyJupiter).thenReturn('Jupiter');
    when(mockL10n.bodySaturn).thenReturn('Saturn');
    when(mockL10n.bodyUranus).thenReturn('Uranus');
    when(mockL10n.bodyNeptune).thenReturn('Neptune');
    when(mockL10n.bodyStarA).thenReturn('Star A');
    when(mockL10n.bodyStarB).thenReturn('Star B');
    when(mockL10n.bodyPlanetP).thenReturn('Planet P');
    when(mockL10n.bodyMoonM).thenReturn('Moon M');
    when(mockL10n.bodyCentralStar).thenReturn('Central Star');
    when(mockL10n.bodyOuterPlanet).thenReturn('Outer Planet');
    when(mockL10n.bodyInnerPlanet).thenReturn('Inner Planet');
    when(mockL10n.bodyBlackHole).thenReturn('Supermassive Black Hole');
    when(mockL10n.bodyPrimaryStar).thenReturn('Primary Star');
    when(mockL10n.bodySecondaryStar).thenReturn('Secondary Star');

    // Setup methods that take parameters
    when(mockL10n.bodyStarNumber(any)).thenReturn('Star');

    // Setup accessibility methods
    when(
      mockL10n.accessibilityMergeEvent(any, any),
    ).thenReturn('Bodies merged');
    when(
      mockL10n.accessibilityMergeEventContext,
    ).thenReturn('Collision detected');
    when(
      mockL10n.accessibilitySimulationStarted,
    ).thenReturn('Simulation started');
    when(
      mockL10n.accessibilitySimulationPaused,
    ).thenReturn('Simulation paused');
    when(
      mockL10n.accessibilitySimulationResumed,
    ).thenReturn('Simulation resumed');
    when(
      mockL10n.accessibilitySimulationStopped,
    ).thenReturn('Simulation stopped');
    when(mockL10n.accessibilitySimulationReset).thenReturn('Simulation reset');

    // Add missing accessibility methods that were causing test failures
    when(mockL10n.accessibilitySpeedChange(any)).thenReturn('Speed changed');
    when(
      mockL10n.accessibilityGravityChange(any),
    ).thenReturn('Gravity changed');
    when(
      mockL10n.accessibilityCollisionRadiusChange(any),
    ).thenReturn('Collision radius changed');
    when(mockL10n.accessibilityCameraReset).thenReturn('Camera reset');
    when(mockL10n.accessibilityCameraFocus).thenReturn('Camera focused');
    when(mockL10n.accessibilityCameraFollow).thenReturn('Camera following');
    when(
      mockL10n.simulationCanvasFocused,
    ).thenReturn('Simulation canvas focused');
    when(
      mockL10n.simulationControlsFocused,
    ).thenReturn('Simulation controls focused');
    when(mockL10n.tapToInteractWithSimulation).thenReturn('Tap to interact');
    when(mockL10n.tapToCenterCamera).thenReturn('Tap to center camera');
    when(mockL10n.bottomSheetFocused).thenReturn('Bottom sheet focused');
    when(mockL10n.cameraControlsFocused).thenReturn('Camera controls focused');

    // Add missing JSON validation methods
    when(mockL10n.invalidJsonFormat(any)).thenReturn('Invalid JSON format');
    when(mockL10n.bodyIndex(any)).thenReturn('Body index');
    when(
      mockL10n.missingRequiredFieldVersion,
    ).thenReturn('Missing version field');
    when(
      mockL10n.missingRequiredFieldParticleSystems,
    ).thenReturn('Missing particle systems field');

    // Add missing remote config methods
    when(
      mockL10n.scheduledMaintenanceInProgress,
    ).thenReturn('Scheduled maintenance in progress');
    when(
      mockL10n.accessibilitySimulationStartedContext,
    ).thenReturn('Physics running');
    when(
      mockL10n.accessibilitySimulationPausedContext,
    ).thenReturn('Physics paused');
    when(
      mockL10n.accessibilitySimulationResumedContext,
    ).thenReturn('Physics resumed');
    when(
      mockL10n.accessibilitySimulationStoppedContext,
    ).thenReturn('Physics stopped');
    when(
      mockL10n.accessibilitySimulationResetContext,
    ).thenReturn('Physics reset');
    when(
      mockL10n.accessibilityScenarioChange(any),
    ).thenReturn('Scenario changed');
    when(
      mockL10n.accessibilityScenarioChangeContext,
    ).thenReturn('New scenario loaded');
    when(mockL10n.accessibilityError(any)).thenReturn('Error occurred');
    when(
      mockL10n.accessibilitySettingEnabled(any),
    ).thenReturn('Setting enabled');
    when(
      mockL10n.accessibilitySettingDisabled(any),
    ).thenReturn('Setting disabled');
    when(
      mockL10n.accessibilityTutorialProgress(any, any, any),
    ).thenReturn('Tutorial progress');

    // Temperature and habitability methods (only the ones that exist)
    when(mockL10n.habitabilityUnknown).thenReturn('Unknown');
    when(mockL10n.stellarColorBlue).thenReturn('Blue');
    when(mockL10n.stellarColorBlueWhite).thenReturn('Blue-white');
    when(mockL10n.stellarColorYellowWhite).thenReturn('Yellow-white');
    when(mockL10n.stellarColorYellow).thenReturn('Yellow');
    when(mockL10n.stellarColorOrange).thenReturn('Orange');
    when(mockL10n.stellarColorRed).thenReturn('Red');
    when(mockL10n.stellarColorWhite).thenReturn('White');

    // Screenshot mode preset names and descriptions
    when(
      mockL10n.presetGalaxyFormationOverview,
    ).thenReturn('Galaxy Formation Overview');
    when(
      mockL10n.presetGalaxyFormationOverviewDesc,
    ).thenReturn('Watch stars form into galactic structures');
    when(mockL10n.presetGalaxyCoreDetail).thenReturn('Galaxy Core Detail');
    when(
      mockL10n.presetGalaxyCoreDetailDesc,
    ).thenReturn('Detailed view of galaxy center');
    when(mockL10n.presetGalaxyBlackHole).thenReturn('Galaxy Black Hole');
    when(
      mockL10n.presetGalaxyBlackHoleDesc,
    ).thenReturn('Central black hole in galaxy formation');
    when(
      mockL10n.presetCompleteSolarSystem,
    ).thenReturn('Complete Solar System');
    when(
      mockL10n.presetCompleteSolarSystemDesc,
    ).thenReturn('All planets orbiting the Sun');
    when(mockL10n.presetInnerSolarSystem).thenReturn('Inner Solar System');
    when(
      mockL10n.presetInnerSolarSystemDesc,
    ).thenReturn('Mercury, Venus, Earth, Mars');
    when(mockL10n.presetEarthView).thenReturn('Earth View');
    when(
      mockL10n.presetEarthViewDesc,
    ).thenReturn('Close view of Earth and Moon');
    when(mockL10n.presetSaturnRings).thenReturn('Saturn Rings');
    when(
      mockL10n.presetSaturnRingsDesc,
    ).thenReturn('Saturn and its ring system');
    when(mockL10n.presetEarthMoonSystem).thenReturn('Earth-Moon System');
    when(
      mockL10n.presetEarthMoonSystemDesc,
    ).thenReturn('Earth and Moon orbital dance');
    when(mockL10n.presetBinaryStarDrama).thenReturn('Binary Star Drama');
    when(
      mockL10n.presetBinaryStarDramaDesc,
    ).thenReturn('Two stars in orbital dance');
    when(
      mockL10n.presetBinaryStarPlanetMoon,
    ).thenReturn('Binary Star Planet Moon');
    when(
      mockL10n.presetBinaryStarPlanetMoonDesc,
    ).thenReturn('Complex binary star system');
    when(mockL10n.presetAsteroidBeltChaos).thenReturn('Asteroid Belt Chaos');
    when(
      mockL10n.presetAsteroidBeltChaosDesc,
    ).thenReturn('Chaotic asteroid interactions');
    when(mockL10n.presetThreeBodyBallet).thenReturn('Three-Body Ballet');
    when(
      mockL10n.presetThreeBodyBalletDesc,
    ).thenReturn('Classic three-body gravitational dance');

    // Add missing accessibility methods for semantic focus service
    when(mockL10n.accessibilityCameraUnfollow).thenReturn('Camera unfollowing');
    when(
      mockL10n.scenarioSelectorFocused,
    ).thenReturn('Scenario selector focused');
    when(
      mockL10n.useKeyboardShortcutsForControls,
    ).thenReturn('Use keyboard shortcuts for controls');
    when(
      mockL10n.tapToToggleAutoRotation,
    ).thenReturn('Tap to toggle auto rotation');
    when(mockL10n.swipeUpToExpand).thenReturn('Swipe up to expand');
    when(mockL10n.settingsButtonFocused).thenReturn('Settings button focused');
    when(
      mockL10n.dragToRotateCameraView,
    ).thenReturn('Drag to rotate camera view');
    when(mockL10n.pinchToZoomInOut).thenReturn('Pinch to zoom in/out');
    when(mockL10n.useZoomControls).thenReturn('Use zoom controls');
    when(mockL10n.tapPlayPauseButton).thenReturn('Tap play/pause button');
    when(mockL10n.tapResetButton).thenReturn('Tap reset button');
    when(mockL10n.adjustSimulationSpeed).thenReturn('Adjust simulation speed');
    when(mockL10n.accessScenarioOptions).thenReturn('Access scenario options');
    when(mockL10n.viewPhysicsSettings).thenReturn('View physics settings');
    when(mockL10n.tapToChangeScenario).thenReturn('Tap to change scenario');
    when(
      mockL10n.browseAvailableSimulations,
    ).thenReturn('Browse available simulations');
    when(mockL10n.tapToOpenSettings).thenReturn('Tap to open settings');
    when(mockL10n.accessAppPreferences).thenReturn('Access app preferences');
    // Scenario Serialization validation messages
    when(
      mockL10n.bodyIndex(any),
    ).thenAnswer((invocation) => 'Body ${invocation.positionalArguments[0]}:');
    when(mockL10n.bodyNameRequired(any)).thenAnswer(
      (invocation) => '${invocation.positionalArguments[0]} name is required',
    );
    when(mockL10n.bodyPositionInvalid(any)).thenAnswer(
      (invocation) =>
          '${invocation.positionalArguments[0]} position must be a 3D array [x, y, z]',
    );
    when(mockL10n.bodyPositionComponentInvalid(any, any)).thenAnswer(
      (invocation) =>
          '${invocation.positionalArguments[0]} position[${invocation.positionalArguments[1]}] must be a finite number',
    );
    when(mockL10n.bodyVelocityInvalid(any)).thenAnswer(
      (invocation) =>
          '${invocation.positionalArguments[0]} velocity must be a 3D array [vx, vy, vz]',
    );
    when(mockL10n.bodyVelocityComponentInvalid(any, any)).thenAnswer(
      (invocation) =>
          '${invocation.positionalArguments[0]} velocity[${invocation.positionalArguments[1]}] must be a finite number',
    );
    when(mockL10n.bodyMassInvalid(any)).thenAnswer(
      (invocation) =>
          '${invocation.positionalArguments[0]} mass must be between 0 and 1000',
    );
    when(mockL10n.bodyRadiusInvalid(any)).thenAnswer(
      (invocation) =>
          '${invocation.positionalArguments[0]} radius must be between 0 and 50',
    );
    when(mockL10n.bodyColorInvalid(any)).thenAnswer(
      (invocation) =>
          '${invocation.positionalArguments[0]} color must be valid hex format',
    );
    when(mockL10n.bodyTypeInvalid(any, any)).thenAnswer(
      (invocation) =>
          '${invocation.positionalArguments[0]} invalid bodyType ${invocation.positionalArguments[1]}',
    );

    // More serialization validation messages
    when(
      mockL10n.missingRequiredFieldVersion,
    ).thenReturn('Missing required field: version');
    when(
      mockL10n.missingRequiredFieldMetadata,
    ).thenReturn('Missing required field: metadata');
    when(
      mockL10n.missingRequiredFieldConfiguration,
    ).thenReturn('Missing required field: configuration');
    when(
      mockL10n.missingRequiredFieldPhysics,
    ).thenReturn('Missing required field: physics');
    when(
      mockL10n.missingRequiredFieldBodies,
    ).thenReturn('Missing required field: bodies');
    when(
      mockL10n.missingRequiredFieldParticleSystems,
    ).thenReturn('Missing required field: particleSystems');
    when(mockL10n.invalidJsonFormat(any)).thenAnswer(
      (invocation) =>
          'Invalid JSON format: ${invocation.positionalArguments[0]}',
    );
    when(mockL10n.physicsFieldRangeError(any, any, any)).thenAnswer(
      (invocation) =>
          '${invocation.positionalArguments[0]} must be between ${invocation.positionalArguments[1]} and ${invocation.positionalArguments[2]}',
    );
    when(
      mockL10n.maxTrailPointsInvalid,
    ).thenReturn('maxTrailPoints must be between 10 and 5000');

    // Add missing scenario name validation methods
    when(mockL10n.scenarioNameRequired).thenReturn('Scenario name is required');
    when(
      mockL10n.scenarioNameTooLong,
    ).thenReturn('Scenario name must be 100 characters or fewer');

    // Add missing body count validation methods
    when(
      mockL10n.atLeastOneBodyIsRequired,
    ).thenReturn('At least one body is required');
    when(
      mockL10n.maximum50BodiesAllowed,
    ).thenReturn('Maximum 50 bodies allowed');

    when(mockL10n.noActionsAvailable).thenReturn('No actions available');

    return mockL10n;
  }
}
