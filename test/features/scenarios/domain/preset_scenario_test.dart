import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/core/enums/scenario_type.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/models/celestial/body.dart';
import 'package:graviton/features/scenarios/domain/preset_scenario.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void main() {
  group('PresetScenario', () {
    late List<Body> testBodies;

    setUp(() {
      testBodies = [
        Body(
          name: 'Sun',
          mass: 1.989e30,
          radius: 696340000,
          position: vm.Vector3(0, 0, 0),
          velocity: vm.Vector3.zero(),
          color: AppColors.stellarGType,
        ),
        Body(
          name: 'Earth',
          mass: 5.972e24,
          radius: 6371000,
          position: vm.Vector3(149597870700, 0, 0),
          velocity: vm.Vector3(0, 29780, 0),
          color: AppColors.planetEarth,
        ),
        Body(
          name: 'Moon',
          mass: 7.342e22,
          radius: 1737000,
          position: vm.Vector3(149597870700 + 384400000, 0, 0),
          velocity: vm.Vector3(0, 29780 + 1022, 0),
          color: AppColors.uiTextGrey,
        ),
      ];
    });

    group('constructor and properties', () {
      test('creates instance with all required properties', () {
        final scenario = PresetScenario(
          type: ScenarioType.solarSystem,
          name: 'Solar System',
          description: 'Our solar system with major planets',
          bodies: testBodies,
          icon: Icons.public,
          primaryColor: AppColors.stellarKType,
        );

        expect(scenario.type, equals(ScenarioType.solarSystem));
        expect(scenario.name, equals('Solar System'));
        expect(
          scenario.description,
          equals('Our solar system with major planets'),
        );
        expect(scenario.bodies, equals(testBodies));
        expect(scenario.icon, equals(Icons.public));
        expect(scenario.primaryColor, equals(AppColors.stellarKType));
      });

      test('creates instance with empty bodies list', () {
        final scenario = PresetScenario(
          type: ScenarioType.custom,
          name: 'Empty Space',
          description: 'A void scenario for testing',
          bodies: const [],
          icon: Icons.clear,
          primaryColor: AppColors.backgroundBlack,
        );

        expect(scenario.bodies, isEmpty);
        expect(scenario.type, equals(ScenarioType.custom));
        expect(scenario.name, equals('Empty Space'));
        expect(scenario.description, equals('A void scenario for testing'));
        expect(
          scenario.icon,
          equals(Icons.clear),
        ); // Fixed: should match the input icon
        expect(scenario.primaryColor, equals(AppColors.backgroundBlack));
      });

      test('creates instance with single body', () {
        final singleBody = [testBodies.first];

        final scenario = PresetScenario(
          type: ScenarioType.custom,
          name: 'Lone Star',
          description: 'Single star in space',
          bodies: singleBody,
          icon: Icons.star,
          primaryColor: AppColors.stellarGType,
        );

        expect(scenario.bodies, hasLength(1));
        expect(scenario.bodies.first, equals(testBodies.first));
        expect(scenario.name, equals('Lone Star'));
        expect(scenario.icon, equals(Icons.star));
      });

      test('handles long description text', () {
        const longDescription =
            'This is a very long description that might be used in a real scenario. It could contain multiple lines, detailed explanations about the astronomical setup, historical context, physical parameters, and educational information that helps users understand the complexity and beauty of celestial mechanics. The description might also include mathematical formulas, references to real astronomical observations, and guidance for users exploring the simulation.';

        final scenario = PresetScenario(
          type: ScenarioType.binaryStars,
          name: 'Detailed Binary System',
          description: longDescription,
          bodies: testBodies.take(2).toList(),
          icon: Icons.compare_arrows,
          primaryColor: AppColors.stellarOType,
        );

        expect(scenario.description, equals(longDescription));
        expect(scenario.description.length, greaterThan(100));
        expect(scenario.bodies, hasLength(2));
      });
    });

    group('realistic astronomical scenarios', () {
      test('solar system scenario configuration', () {
        final scenario = PresetScenario(
          type: ScenarioType.solarSystem,
          name: 'Inner Solar System',
          description: 'Sun, Mercury, Venus, Earth, and Mars',
          bodies: testBodies,
          icon: Icons.wb_sunny,
          primaryColor: AppColors.stellarKType,
        );

        expect(scenario.type, equals(ScenarioType.solarSystem));
        expect(scenario.bodies, hasLength(3));
        expect(scenario.name, contains('Solar'));
        expect(scenario.icon, equals(Icons.wb_sunny));
        expect(scenario.primaryColor, equals(AppColors.stellarKType));

        // Validate bodies have realistic masses (in kg)
        final sun = scenario.bodies.firstWhere((b) => b.name == 'Sun');
        expect(sun.mass, greaterThan(1e30)); // Solar mass

        final earth = scenario.bodies.firstWhere((b) => b.name == 'Earth');
        expect(earth.mass, inInclusiveRange(5e24, 6e24)); // Earth mass
      });

      test('binary star system scenario', () {
        final binaryBodies = [
          Body(
            name: 'Alpha Centauri A',
            mass: 2.2e30,
            radius: 853400000,
            position: vm.Vector3(-100000000000, 0, 0),
            velocity: vm.Vector3(0, -15000, 0),
            color: AppColors.stellarGType,
          ),
          Body(
            name: 'Alpha Centauri B',
            mass: 1.8e30,
            radius: 602700000,
            position: vm.Vector3(100000000000, 0, 0),
            velocity: vm.Vector3(0, 15000, 0),
            color: AppColors.stellarKType,
          ),
        ];

        final scenario = PresetScenario(
          type: ScenarioType.binaryStars,
          name: 'Alpha Centauri',
          description: 'Binary star system with orbital dynamics',
          bodies: binaryBodies,
          icon: Icons.group_work,
          primaryColor: AppColors.planetEarth,
        );

        expect(scenario.type, equals(ScenarioType.binaryStars));
        expect(scenario.bodies, hasLength(2));
        expect(scenario.name, equals('Alpha Centauri'));
        expect(scenario.icon, equals(Icons.group_work));
        expect(scenario.primaryColor, equals(AppColors.planetEarth));

        // Both bodies should have stellar masses
        for (final body in scenario.bodies) {
          expect(body.mass, greaterThan(1e29));
        }
      });

      test('three-body problem scenario', () {
        final threeBodyBodies = [
          Body(
            name: 'Body 1',
            mass: 1e30,
            radius: 696340000,
            position: vm.Vector3(-1e11, 0, 0),
            velocity: vm.Vector3(0, -10000, 0),
            color: AppColors.planetMars,
          ),
          Body(
            name: 'Body 2',
            mass: 1e30,
            radius: 696340000,
            position: vm.Vector3(1e11, 0, 0),
            velocity: vm.Vector3(0, 10000, 0),
            color: AppColors.planetEarth,
          ),
          Body(
            name: 'Body 3',
            mass: 1e30,
            radius: 696340000,
            position: vm.Vector3(0, 1e11, 0),
            velocity: vm.Vector3(15000, 0, 0),
            color: AppColors.habitabilityHabitable,
          ),
        ];

        final scenario = PresetScenario(
          type: ScenarioType.threeBodyClassic,
          name: 'Three Body Chaos',
          description: 'Classic chaotic three-body gravitational system',
          bodies: threeBodyBodies,
          icon: Icons.scatter_plot,
          primaryColor: AppColors.planetMars,
        );

        expect(scenario.type, equals(ScenarioType.threeBodyClassic));
        expect(scenario.bodies, hasLength(3));
        expect(scenario.name, contains('Three'));
        expect(scenario.description, contains('chaotic'));
        expect(scenario.icon, equals(Icons.scatter_plot));
        expect(scenario.primaryColor, equals(AppColors.planetMars));
      });
    });

    group('scenario types and icons', () {
      test('each scenario type has appropriate icon', () {
        final scenarios = [
          (ScenarioType.solarSystem, Icons.wb_sunny),
          (ScenarioType.binaryStars, Icons.group_work),
          (ScenarioType.threeBodyClassic, Icons.scatter_plot),
          (ScenarioType.earthMoonSun, Icons.brightness_3),
          (ScenarioType.asteroidBelt, Icons.grain),
          (ScenarioType.custom, Icons.edit),
        ];

        for (final (type, expectedIcon) in scenarios) {
          final scenario = PresetScenario(
            type: type,
            name: 'Test Scenario',
            description: 'Test description',
            bodies: testBodies,
            icon: expectedIcon,
            primaryColor: AppColors.uiTextGrey,
          );

          expect(scenario.type, equals(type));
          expect(scenario.icon, equals(expectedIcon));
        }
      });

      test('scenario colors match theme appropriately', () {
        final colorfulScenarios = [
          (ScenarioType.solarSystem, AppColors.stellarKType), // Sun-like
          (ScenarioType.binaryStars, AppColors.planetEarth), // Binary star
          (
            ScenarioType.threeBodyClassic,
            AppColors.planetMars,
          ), // Chaotic/dangerous
          (ScenarioType.earthMoonSun, AppColors.planetEarth), // Earth-like
          (ScenarioType.asteroidBelt, AppColors.asteroidRockyBrown), // Rocky
          (ScenarioType.custom, AppColors.stellarOType), // Unique/creative
        ];

        for (final (type, color) in colorfulScenarios) {
          final scenario = PresetScenario(
            type: type,
            name: 'Test Scenario',
            description: 'Test description',
            bodies: testBodies,
            icon: Icons.star,
            primaryColor: color,
          );

          expect(scenario.primaryColor, equals(color));
          // Color value is valid as an integer representation
        }
      });

      test('handles all available material icons', () {
        final iconVariations = [
          Icons.public,
          Icons.star,
          Icons.brightness_3,
          Icons.scatter_plot,
          Icons.grain,
          Icons.group_work,
          Icons.wb_sunny,
          Icons.nights_stay,
          Icons.flare,
          Icons.blur_circular,
        ];

        for (final icon in iconVariations) {
          final scenario = PresetScenario(
            type: ScenarioType.custom,
            name: 'Icon Test',
            description: 'Testing icon variety',
            bodies: testBodies,
            icon: icon,
            primaryColor: AppColors.uiTextGrey,
          );

          expect(scenario.icon, equals(icon));
          expect(scenario.icon.codePoint, isA<int>());
        }
      });
    });

    group('body configuration validation', () {
      test('validates massive bodies come first in list', () {
        final sortedBodies = testBodies
          ..sort((a, b) => b.mass.compareTo(a.mass));

        final scenario = PresetScenario(
          type: ScenarioType.solarSystem,
          name: 'Properly Ordered System',
          description: 'Bodies sorted by mass for stability',
          bodies: sortedBodies,
          icon: Icons.sort,
          primaryColor: AppColors.habitabilityHabitable,
        );

        expect(
          scenario.bodies.first.mass,
          greaterThanOrEqualTo(scenario.bodies.last.mass),
        );
      });

      test('handles bodies with identical properties', () {
        final identicalBodies = List.generate(
          3,
          (index) => Body(
            name: 'Twin $index',
            mass: 1e24,
            radius: 6371000,
            position: vm.Vector3(index * 1000000.0, 0, 0),
            velocity: vm.Vector3(0, 10000, 0),
            color: AppColors.planetEarth,
          ),
        );

        final scenario = PresetScenario(
          type: ScenarioType.custom,
          name: 'Identical Triplets',
          description: 'Three identical bodies',
          bodies: identicalBodies,
          icon: Icons.content_copy,
          primaryColor: AppColors.primaryColor,
        );

        expect(scenario.bodies, hasLength(3));
        expect(scenario.bodies.every((b) => b.mass == 1e24), isTrue);

        // Ensure they have different positions
        final positions = scenario.bodies.map((b) => b.position).toSet();
        expect(positions, hasLength(3)); // All unique positions
      });

      test('validates body physics parameters are realistic', () {
        final realisticBodies = [
          // Sun-like star
          Body(
            name: 'Central Star',
            mass: 2e30, // Solar mass
            radius: 696e6, // Solar radius in meters
            position: vm.Vector3.zero(),
            velocity: vm.Vector3.zero(),
            color: AppColors.stellarGType,
          ),
          // Earth-like planet
          Body(
            name: 'Habitable World',
            mass: 6e24, // Earth mass
            radius: 6e6, // Earth radius in meters
            position: vm.Vector3(150e9, 0, 0), // ~1 AU
            velocity: vm.Vector3(0, 30000, 0), // ~30 km/s orbital speed
            color: AppColors.habitabilityHabitable,
          ),
        ];

        final scenario = PresetScenario(
          type: ScenarioType.custom,
          name: 'Realistic System',
          description: 'Physically accurate star-planet system',
          bodies: realisticBodies,
          icon: Icons.verified,
          primaryColor: AppColors.habitabilityHabitable,
        );

        final star = scenario.bodies[0];
        final planet = scenario.bodies[1];

        // Validate mass ratios
        expect(
          star.mass / planet.mass,
          inInclusiveRange(300000, 350000),
        ); // ~333,333 for our test masses

        // Validate orbital velocity is appropriate for distance
        final distance = planet.position.length;
        expect(distance, inInclusiveRange(1e11, 2e11)); // ~1 AU
        expect(
          planet.velocity.length,
          inInclusiveRange(25000, 35000),
        ); // Orbital speed
      });
    });

    group('edge cases and boundary conditions', () {
      test('handles extreme body counts', () {
        // Minimal scenario (single body)
        final minimalScenario = PresetScenario(
          type: ScenarioType.custom,
          name: 'Lone Object',
          description: 'Single body in space',
          bodies: [testBodies.first],
          icon: Icons.radio_button_unchecked,
          primaryColor: AppColors.uiTextGrey,
        );

        expect(minimalScenario.bodies, hasLength(1));

        // Large scenario (many bodies)
        final manyBodies = List.generate(
          20,
          (i) => Body(
            name: 'Body $i',
            mass: 1e20 + i * 1e18,
            radius: 1e6,
            position: vm.Vector3(i * 1e8, 0, 0),
            velocity: vm.Vector3(0, 1000, 0),
            color: AppColors.uiTextGrey,
          ),
        );

        final largeScenario = PresetScenario(
          type: ScenarioType.asteroidBelt,
          name: 'Large Field',
          description: 'Many small bodies',
          bodies: manyBodies,
          icon: Icons.apps,
          primaryColor: AppColors.asteroidRockyBrown,
        );

        expect(largeScenario.bodies, hasLength(20));
      });

      test('handles extreme mass ranges', () {
        final extremeBodies = [
          // Supermassive body
          Body(
            name: 'Supermassive Object',
            mass: 1e40,
            radius: 1e10,
            position: vm.Vector3.zero(),
            velocity: vm.Vector3.zero(),
            color: AppColors.backgroundBlack,
          ),
          // Tiny body
          Body(
            name: 'Dust Particle',
            mass: 1e10,
            radius: 1,
            position: vm.Vector3(1e12, 0, 0),
            velocity: vm.Vector3(0, 100000, 0),
            color: AppColors.uiTextGrey,
          ),
        ];

        final extremeScenario = PresetScenario(
          type: ScenarioType.custom,
          name: 'Extreme Masses',
          description: 'Bodies with extreme mass differences',
          bodies: extremeBodies,
          icon: Icons.compare,
          primaryColor: AppColors.stellarOType,
        );

        final massRatio =
            extremeScenario.bodies[0].mass / extremeScenario.bodies[1].mass;
        expect(massRatio, greaterThan(1e20)); // Huge difference
      });

      test('handles special unicode and characters in names/descriptions', () {
        final scenario = PresetScenario(
          type: ScenarioType.custom,
          name: '🌟 Stellar System αβγ',
          description: '''
          Special characters: αβγδε, ♂♀☿♃♄⛢♆⚳
          Unicode: 🌟🌍🌙✨💫⭐
          Math: E=mc², F=GMm/r², v=√(GM/r)
          Greek: α Centauri, β Orionis, γ Draconis
          ''',
          bodies: testBodies,
          icon: Icons.star,
          primaryColor: AppColors.stellarGType,
        );

        expect(scenario.name, contains('🌟'));
        expect(scenario.name, contains('αβγ'));
        expect(scenario.description, contains('♂♀☿'));
        expect(scenario.description, contains('√'));
        expect(scenario.description, contains('α Centauri'));
      });

      test('handles very long names', () {
        const veryLongName =
            'This is an extremely long scenario name that might be used in some educational context where the full descriptive title needs to explain exactly what astronomical phenomenon or celestial configuration is being demonstrated in this particular gravitational simulation';

        final scenario = PresetScenario(
          type: ScenarioType.custom,
          name: veryLongName,
          description: 'Test description',
          bodies: testBodies,
          icon: Icons.text_fields,
          primaryColor: AppColors.habitabilityHabitable,
        );

        expect(scenario.name, equals(veryLongName));
        expect(scenario.name.length, greaterThan(100));
      });
    });
  });
}
