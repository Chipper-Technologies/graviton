import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/enums/habitability_status.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/body.dart';
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
}
