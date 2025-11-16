import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/enums/habitability_status.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/services/habitable_zone_service.dart';
import 'package:graviton/services/scenario_service.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:vector_math/vector_math_64.dart' as vm;
import '../test_utils.dart';

void main() {
  group('Enhanced Habitability Classifications', () {
    late HabitableZoneService habitableZoneService;
    late ScenarioService scenarioService;

    setUp(() {
      habitableZoneService = HabitableZoneService();
      scenarioService = ScenarioService();
    });

    test(
      'Solar system should have appropriate habitability classifications',
      () {
        final mockL10n = TestUtils.createMockAppLocalizations();

        // Generate solar system
        final bodies = scenarioService.generateScenario(
          ScenarioType.solarSystem,
          l10n: mockL10n,
        );

        // Find planets by name and verify their initial classifications
        final planets = bodies
            .where((body) => body.bodyType == BodyType.planet)
            .toList();

        expect(
          planets.length,
          greaterThanOrEqualTo(8),
        ); // Should have at least 8 planets

        // Check for gas giants
        final gasGiants = planets
            .where(
              (planet) =>
                  planet.habitabilityStatus == HabitabilityStatus.gasGiant,
            )
            .toList();

        expect(gasGiants.length, equals(4)); // Jupiter, Saturn, Uranus, Neptune

        // Check Earth is classified as habitable initially
        final earth = planets.firstWhere(
          (planet) => planet.name.toLowerCase().contains('earth'),
          orElse: () => throw Exception('Earth not found in solar system'),
        );
        expect(earth.habitabilityStatus, equals(HabitabilityStatus.habitable));

        // Check Venus has toxic atmosphere classification
        final venus = planets.firstWhere(
          (planet) => planet.name.toLowerCase().contains('venus'),
          orElse: () => throw Exception('Venus not found in solar system'),
        );
        expect(
          venus.habitabilityStatus,
          equals(HabitabilityStatus.toxicAtmosphere),
        );
      },
    );

    test('Gas giant detection works correctly', () {
      // Create a large, low-density body (gas giant characteristics)
      final gasGiant = Body(
        position: vm.Vector3.zero(),
        velocity: vm.Vector3.zero(),
        mass: 0.1, // Low mass relative to size
        radius: 5.0, // Large radius
        color: AppColors.planetJupiter,
        name: 'Test Gas Giant',
        bodyType: BodyType.planet,
      );

      // Add a star for comparison
      final star = Body(
        position: vm.Vector3(100, 0, 0),
        velocity: vm.Vector3.zero(),
        mass: 50.0,
        radius: 4.0,
        color: AppColors.celestialGold,
        name: 'Test Star',
        bodyType: BodyType.star,
        stellarLuminosity: 1.0,
      );

      final allBodies = [gasGiant, star];
      final status = habitableZoneService.calculateHabitabilityStatus(
        gasGiant,
        allBodies,
      );

      expect(status, equals(HabitabilityStatus.gasGiant));
    });

    test('Small body detection works correctly', () {
      // Create a very small body
      final smallBody = Body(
        position: vm.Vector3.zero(),
        velocity: vm.Vector3.zero(),
        mass: 0.001, // Very small mass
        radius: 0.1, // Very small radius
        color: AppColors.planetMercury,
        name: 'Test Small Body',
        bodyType: BodyType.planet,
      );

      // Add a star
      final star = Body(
        position: vm.Vector3(50, 0, 0),
        velocity: vm.Vector3.zero(),
        mass: 50.0,
        radius: 4.0,
        color: AppColors.celestialGold,
        name: 'Test Star',
        bodyType: BodyType.star,
        stellarLuminosity: 1.0,
      );

      final allBodies = [smallBody, star];
      final status = habitableZoneService.calculateHabitabilityStatus(
        smallBody,
        allBodies,
      );

      expect(status, equals(HabitabilityStatus.tooSmall));
    });

    test('Extreme gravity detection works correctly', () {
      // Create a very dense, massive body
      final superEarth = Body(
        position: vm.Vector3.zero(),
        velocity: vm.Vector3.zero(),
        mass: 10.0, // Very high mass
        radius: 0.8, // Small radius (high density)
        color: AppColors.planetEarth,
        name: 'Test Super Earth',
        bodyType: BodyType.planet,
      );

      // Add a star in habitable zone distance
      final star = Body(
        position: vm.Vector3(50, 0, 0),
        velocity: vm.Vector3.zero(),
        mass: 50.0,
        radius: 4.0,
        color: AppColors.celestialGold,
        name: 'Test Star',
        bodyType: BodyType.star,
        stellarLuminosity: 1.0,
      );

      final allBodies = [superEarth, star];
      final status = habitableZoneService.calculateHabitabilityStatus(
        superEarth,
        allBodies,
      );

      expect(status, equals(HabitabilityStatus.extremeGravity));
    });

    test('High radiation detection works correctly', () {
      // Create a normal planet very close to a very bright star
      final closePlanet = Body(
        position: vm.Vector3.zero(),
        velocity: vm.Vector3.zero(),
        mass: 0.02, // Earth-like mass
        radius: 0.6, // Earth-like radius
        color: AppColors.planetEarth,
        name: 'Test Close Planet',
        bodyType: BodyType.planet,
      );

      // Add a very bright star very close
      final brightStar = Body(
        position: vm.Vector3(5, 0, 0), // Very close
        velocity: vm.Vector3.zero(),
        mass: 50.0,
        radius: 4.0,
        color: AppColors.celestialGold,
        name: 'Test Bright Star',
        bodyType: BodyType.star,
        stellarLuminosity: 100.0, // Very bright
      );

      final allBodies = [closePlanet, brightStar];
      final status = habitableZoneService.calculateHabitabilityStatus(
        closePlanet,
        allBodies,
      );

      expect(status, equals(HabitabilityStatus.highRadiation));
    });

    test('Tidal locking detection works correctly', () {
      // Create a planet very close to a star
      final closePlanet = Body(
        position: vm.Vector3.zero(),
        velocity: vm.Vector3.zero(),
        mass: 0.02, // Earth-like mass
        radius: 0.6, // Earth-like radius
        color: AppColors.planetEarth,
        name: 'Test Close Planet',
        bodyType: BodyType.planet,
      );

      // Add a star very close (within tidal locking distance)
      final star = Body(
        position: vm.Vector3(3, 0, 0), // Very close (< 0.1 AU equivalent)
        velocity: vm.Vector3.zero(),
        mass: 50.0,
        radius: 4.0,
        color: AppColors.celestialGold,
        name: 'Test Star',
        bodyType: BodyType.star,
        stellarLuminosity: 1.0,
      );

      final allBodies = [closePlanet, star];
      final status = habitableZoneService.calculateHabitabilityStatus(
        closePlanet,
        allBodies,
      );

      expect(status, equals(HabitabilityStatus.tidallyLocked));
    });

    test('All new habitability status types have proper colors', () {
      // Verify all new status types have assigned colors
      final newStatusTypes = [
        HabitabilityStatus.gasGiant,
        HabitabilityStatus.tooSmall,
        HabitabilityStatus.noAtmosphere,
        HabitabilityStatus.toxicAtmosphere,
        HabitabilityStatus.highRadiation,
        HabitabilityStatus.tidallyLocked,
        HabitabilityStatus.extremeGravity,
      ];

      for (final status in newStatusTypes) {
        expect(status.statusColor, isNotNull);
        expect(
          status.statusColor,
          isNot(equals(0x00000000)),
        ); // Not transparent black
      }
    });
  });
}
