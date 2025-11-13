import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/enums/habitability_status.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/models/body_data.dart';
import 'package:graviton/models/custom_scenario.dart';
import 'package:graviton/models/objectives_config.dart';
import 'package:graviton/models/particle_systems_config.dart';
import 'package:graviton/models/scenario_configuration.dart';
import 'package:graviton/models/scenario_metadata.dart';
import 'package:graviton/models/scenario_physics_settings.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

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
}
