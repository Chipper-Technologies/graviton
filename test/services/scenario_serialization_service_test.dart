import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/constants/simulation_constants.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/enums/habitability_status.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/models/particle_systems_config.dart';
import 'package:graviton/models/scenario_configuration.dart';
import 'package:graviton/models/scenario_metadata.dart';
import 'package:graviton/models/scenario_physics_settings.dart';
import 'package:graviton/services/scenario_serialization_service.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

import '../test_utils.dart';

void main() {
  group('ScenarioSerializationService Tests', () {
    late Body testBody;
    late List<Body> testBodies;
    late ScenarioMetadata testMetadata;
    late ScenarioPhysicsSettings testPhysics;
    late dynamic mockL10n;

    setUp(() {
      mockL10n = TestUtils.createMockAppLocalizations();

      // Create test data that matches real physics
      testBody = Body(
        name: 'Test Earth',
        position: vm.Vector3(100.0, 0, 0), // Typical distance for simulation
        velocity: vm.Vector3(
          0,
          0.1,
          0,
        ), // Typical orbital velocity for simulation
        mass: 3.0, // Earth-like mass in simulation units
        radius: 1.0, // Earth radius in simulation units
        color: AppColors.primaryColor,
        bodyType: BodyType.planet,
        stellarLuminosity: 0.0,
        temperature: 288.0, // Earth's average temperature
        showGravityWell: true,
        isPlanet: true,
        habitabilityStatus: HabitabilityStatus.habitable,
      );

      testBodies = [
        testBody,
        Body(
          name: 'Test Sun',
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 10.0, // Star mass in simulation units
          radius: 2.0, // Sun radius in simulation units
          color: AppColors.stellarGType,
          bodyType: BodyType.star,
          stellarLuminosity: 1.0,
          temperature: 5778.0, // Sun's surface temperature
          showGravityWell: true,
          isPlanet: false,
          habitabilityStatus: HabitabilityStatus.tooHot,
        ),
      ];

      testMetadata = ScenarioMetadata(
        name: 'Test Scenario',
        description: 'A test scenario for physics validation',
        author: 'Test Author',
        createdAt: DateTime(2024, 1, 1),
        educationalFocus: 'Testing gravitational physics',
        tags: ['test', 'physics'],
        difficulty: 'beginner',
      );

      testPhysics = const ScenarioPhysicsSettings(
        gravitationalConstant: SimulationConstants.gravitationalConstant,
        softening: SimulationConstants.softening,
        timeScale: 1.0,
        collisionRadiusMultiplier: 1.0,
        maxTrailPoints: 500,
        trailFadeRate: 0.95,
      );
    });

    group('Body to CustomScenario Conversion', () {
      test('should convert bodies to CustomScenario correctly', () {
        final scenario = ScenarioSerializationService.fromBodies(
          bodies: testBodies,
          metadata: testMetadata,
          physics: testPhysics,
        );

        expect(scenario.version, equals('1.0.0'));
        expect(scenario.metadata.name, equals('Test Scenario'));
        expect(scenario.bodies.length, equals(2));
        expect(
          scenario.physics.gravitationalConstant,
          equals(SimulationConstants.gravitationalConstant),
        );
      });

      test('should use default configuration when none provided', () {
        final scenario = ScenarioSerializationService.fromBodies(
          bodies: testBodies,
          metadata: testMetadata,
          physics: testPhysics,
        );

        expect(scenario.configuration.expectedBodyCount, equals(2));
        expect(scenario.configuration.cameraDistanceMultiplier, equals(1.2));
      });

      test('should use default physics when none provided', () {
        final scenario = ScenarioSerializationService.fromBodies(
          bodies: testBodies,
          metadata: testMetadata,
        );

        expect(scenario.physics.gravitationalConstant, equals(1.2));
        expect(scenario.physics.softening, equals(0.1));
        expect(scenario.physics.timeScale, equals(1.0));
        expect(scenario.physics.maxTrailPoints, equals(500));
      });

      test('should use default particle systems when none provided', () {
        final scenario = ScenarioSerializationService.fromBodies(
          bodies: testBodies,
          metadata: testMetadata,
        );

        expect(scenario.particleSystems, isA<ParticleSystemsConfig>());
      });

      test('should accept custom configuration and physics', () {
        final customConfig = ScenarioConfiguration(
          cameraDistanceMultiplier: 2.0,
          expectedBodyCount: 3,
        );

        final customPhysics = ScenarioPhysicsSettings(
          gravitationalConstant: 2.0,
          softening: 0.2,
          timeScale: 2.0,
          collisionRadiusMultiplier: 2.0,
          maxTrailPoints: 1000,
          trailFadeRate: 0.8,
        );

        final scenario = ScenarioSerializationService.fromBodies(
          bodies: testBodies,
          metadata: testMetadata,
          configuration: customConfig,
          physics: customPhysics,
        );

        expect(scenario.configuration.cameraDistanceMultiplier, equals(2.0));
        expect(scenario.physics.gravitationalConstant, equals(2.0));
        expect(scenario.physics.maxTrailPoints, equals(1000));
      });
    });

    group('CustomScenario to Bodies Conversion', () {
      test('should convert CustomScenario back to bodies correctly', () {
        final scenario = ScenarioSerializationService.fromBodies(
          bodies: testBodies,
          metadata: testMetadata,
          physics: testPhysics,
        );

        final convertedBodies = ScenarioSerializationService.toBodies(scenario);

        expect(convertedBodies.length, equals(2));

        // Test first body (Earth)
        final earth = convertedBodies[0];
        expect(earth.name, equals('Test Earth'));
        expect(earth.mass, closeTo(3.0, 0.001));
        expect(earth.position.x, closeTo(100.0, 0.1));
        expect(
          earth.velocity.y,
          closeTo(0.1, 0.001),
        ); // Simulation orbital velocity
        expect(earth.bodyType, equals(BodyType.planet));
        expect(earth.isPlanet, isTrue);
        expect(earth.habitabilityStatus, equals(HabitabilityStatus.habitable));

        // Test second body (Sun)
        final sun = convertedBodies[1];
        expect(sun.name, equals('Test Sun'));
        expect(sun.mass, closeTo(10.0, 0.001));
        expect(sun.position.length, closeTo(0, 0.001)); // At origin
        expect(sun.bodyType, equals(BodyType.star));
        expect(sun.isPlanet, isFalse);
        expect(sun.stellarLuminosity, closeTo(1.0, 0.001));
      });

      test('should preserve vector precision in conversions', () {
        // Test high precision vectors
        final preciseBody = Body(
          name: 'Precise Body',
          position: vm.Vector3(1.23456789, -9.87654321, 0.11111111),
          velocity: vm.Vector3(-0.12345678, 0.98765432, -0.55555555),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.uiRed,
          bodyType: BodyType.planet,
        );

        final scenario = ScenarioSerializationService.fromBodies(
          bodies: [preciseBody],
          metadata: testMetadata,
        );

        final convertedBodies = ScenarioSerializationService.toBodies(scenario);
        final converted = convertedBodies[0];

        expect(converted.position.x, closeTo(1.23456789, 0.00001));
        expect(converted.position.y, closeTo(-9.87654321, 0.00001));
        expect(converted.position.z, closeTo(0.11111111, 0.00001));
        expect(converted.velocity.x, closeTo(-0.12345678, 0.00001));
        expect(converted.velocity.y, closeTo(0.98765432, 0.00001));
        expect(converted.velocity.z, closeTo(-0.55555555, 0.00001));
      });
    });

    group('JSON Serialization', () {
      test('should serialize CustomScenario to JSON string correctly', () {
        final scenario = ScenarioSerializationService.fromBodies(
          bodies: testBodies,
          metadata: testMetadata,
          physics: testPhysics,
        );

        final jsonString = ScenarioSerializationService.toJsonString(scenario);

        expect(jsonString, isA<String>());
        expect(jsonString.contains('"version": "1.0.0"'), isTrue);
        expect(jsonString.contains('"name": "Test Scenario"'), isTrue);
        expect(jsonString.contains('"Test Earth"'), isTrue);
        expect(jsonString.contains('"Test Sun"'), isTrue);

        // Should be formatted with indentation
        expect(jsonString.contains('  '), isTrue);
      });

      test('should deserialize JSON string to CustomScenario correctly', () {
        final scenario = ScenarioSerializationService.fromBodies(
          bodies: testBodies,
          metadata: testMetadata,
          physics: testPhysics,
        );

        final jsonString = ScenarioSerializationService.toJsonString(scenario);
        final deserializedScenario =
            ScenarioSerializationService.fromJsonString(jsonString);

        expect(deserializedScenario.version, equals('1.0.0'));
        expect(deserializedScenario.metadata.name, equals('Test Scenario'));
        expect(deserializedScenario.bodies.length, equals(2));
        expect(
          deserializedScenario.physics.gravitationalConstant,
          closeTo(SimulationConstants.gravitationalConstant, 0.001),
        );
      });

      test('should maintain physics precision through JSON conversion', () {
        final scenario = ScenarioSerializationService.fromBodies(
          bodies: testBodies,
          metadata: testMetadata,
          physics: testPhysics,
        );

        final jsonString = ScenarioSerializationService.toJsonString(scenario);
        final deserializedScenario =
            ScenarioSerializationService.fromJsonString(jsonString);
        final convertedBodies = ScenarioSerializationService.toBodies(
          deserializedScenario,
        );

        // Verify physics constants maintained through conversion
        expect(convertedBodies[0].mass, closeTo(3.0, 0.0001));
        expect(convertedBodies[1].mass, closeTo(10.0, 0.0001));
        expect(convertedBodies[0].position.x, closeTo(100.0, 0.1));
      });
    });

    group('Color Conversion', () {
      test('should convert colors to hex and back correctly', () {
        final colors = [
          AppColors.uiRed,
          AppColors.uiGreen,
          AppColors.primaryColor,
          AppColors.stellarGType,
          AppColors.stellarOType,
          const Color(0xFF123456),
          const Color(0x80ABCDEF), // With alpha
        ];

        for (final color in colors) {
          final body = Body(
            name: 'Color Test',
            position: vm.Vector3.zero(),
            velocity: vm.Vector3.zero(),
            mass: 1.0,
            radius: 1.0,
            color: color,
            bodyType: BodyType.planet,
          );

          final scenario = ScenarioSerializationService.fromBodies(
            bodies: [body],
            metadata: testMetadata,
          );

          final convertedBodies = ScenarioSerializationService.toBodies(
            scenario,
          );
          final convertedColor = convertedBodies[0].color;

          // Check color components are preserved (with some tolerance for floating point)
          expect(
            (convertedColor.r * 255.0).round() & 0xff,
            closeTo((color.r * 255.0).round() & 0xff, 2),
          );
          expect(
            (convertedColor.g * 255.0).round() & 0xff,
            closeTo((color.g * 255.0).round() & 0xff, 2),
          );
          expect(
            (convertedColor.b * 255.0).round() & 0xff,
            closeTo((color.b * 255.0).round() & 0xff, 2),
          );
          expect(
            (convertedColor.a * 255.0).round() & 0xff,
            closeTo((color.a * 255.0).round() & 0xff, 2),
          );
        }
      });

      test('should handle opaque colors correctly', () {
        final opaqueColor = const Color(0xFF123456);
        final body = Body(
          name: 'Opaque Color Test',
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: opaqueColor,
          bodyType: BodyType.planet,
        );

        final scenario = ScenarioSerializationService.fromBodies(
          bodies: [body],
          metadata: testMetadata,
        );

        final convertedBodies = ScenarioSerializationService.toBodies(scenario);
        final convertedColor = convertedBodies[0].color;

        expect((convertedColor.a * 255.0).round() & 0xff, equals(255));
      });

      test('should handle transparent colors correctly', () {
        final transparentColor = const Color(0x80123456);
        final body = Body(
          name: 'Transparent Color Test',
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: transparentColor,
          bodyType: BodyType.planet,
        );

        final scenario = ScenarioSerializationService.fromBodies(
          bodies: [body],
          metadata: testMetadata,
        );

        final convertedBodies = ScenarioSerializationService.toBodies(scenario);
        final convertedColor = convertedBodies[0].color;

        expect(
          (convertedColor.a * 255.0).round() & 0xff,
          closeTo(128, 2),
        ); // 0x80 = 128
      });
    });

    group('JSON Validation', () {
      test('should validate correct JSON successfully', () {
        final scenario = ScenarioSerializationService.fromBodies(
          bodies: testBodies,
          metadata: testMetadata,
          physics: testPhysics,
        );

        final jsonString = ScenarioSerializationService.toJsonString(scenario);
        final result = ScenarioSerializationService.validateJsonString(
          jsonString,
          mockL10n,
        );

        // Debug: Check errors if validation fails
        if (!result.isValid) {
          fail('Validation failed with errors: ${result.errors}');
        }

        expect(result.isValid, isTrue);
        expect(result.errors, isEmpty);
      });

      test('should detect malformed JSON', () {
        const malformedJson = '{ "version": "1.0.0", "invalid": }';

        final result = ScenarioSerializationService.validateJsonString(
          malformedJson,
          mockL10n,
        );

        expect(result.isValid, isFalse);
        expect(result.errors, isNotEmpty);
        expect(result.errors[0], contains('Invalid JSON format'));
      });

      test('should detect missing required fields', () {
        const incompleteJson = '''
        {
          "version": "1.0.0"
        }
        ''';

        final result = ScenarioSerializationService.validateJsonString(
          incompleteJson,
          mockL10n,
        );

        expect(result.isValid, isFalse);
        expect(result.errors, isNotEmpty);
        expect(
          result.errors.any((error) => error.contains('metadata')),
          isTrue,
        );
        expect(result.errors.any((error) => error.contains('bodies')), isTrue);
        expect(result.errors.any((error) => error.contains('physics')), isTrue);
      });

      test('should validate scenario name requirements', () {
        const jsonWithEmptyName = '''
        {
          "version": "1.0.0",
          "metadata": {
            "name": "",
            "description": "Test",
            "author": "Test",
            "createdAt": "2024-01-01T00:00:00.000Z",
            "educationalFocus": "Test",
            "tags": [],
            "difficulty": "beginner"
          },
          "configuration": {"cameraDistanceMultiplier": 1.2, "expectedBodyCount": 1},
          "physics": {"gravitationalConstant": 1.2, "softening": 0.1, "timeScale": 1.0, "collisionRadiusMultiplier": 1.0, "maxTrailPoints": 500, "trailFadeRate": 0.95},
          "bodies": [{"name": "Test", "position": [0,0,0], "velocity": [0,0,0], "mass": 1.0, "radius": 1.0, "color": "#FF0000FF", "bodyType": "planet"}],
          "particleSystems": {}
        }
        ''';

        final result = ScenarioSerializationService.validateJsonString(
          jsonWithEmptyName,
          mockL10n,
        );

        expect(result.isValid, isFalse);
        expect(result.errors.any((error) => error.contains('name')), isTrue);
      });

      test('should validate scenario name length', () {
        final longName = 'a' * 101; // 101 characters
        final jsonWithLongName =
            '''
        {
          "version": "1.0.0",
          "metadata": {
            "name": "$longName",
            "description": "Test",
            "author": "Test",
            "createdAt": "2024-01-01T00:00:00.000Z",
            "educationalFocus": "Test",
            "tags": [],
            "difficulty": "beginner"
          },
          "configuration": {"cameraDistanceMultiplier": 1.2, "expectedBodyCount": 1},
          "physics": {"gravitationalConstant": 1.2, "softening": 0.1, "timeScale": 1.0, "collisionRadiusMultiplier": 1.0, "maxTrailPoints": 500, "trailFadeRate": 0.95},
          "bodies": [{"name": "Test", "position": [0,0,0], "velocity": [0,0,0], "mass": 1.0, "radius": 1.0, "color": "#FF0000FF", "bodyType": "planet"}],
          "particleSystems": {}
        }
        ''';

        final result = ScenarioSerializationService.validateJsonString(
          jsonWithLongName,
          mockL10n,
        );

        expect(result.isValid, isFalse);
        expect(
          result.errors.any((error) => error.contains('100 characters')),
          isTrue,
        );
      });

      test('should require at least one body', () {
        const jsonWithNoBodies = '''
        {
          "version": "1.0.0",
          "metadata": {
            "name": "Test",
            "description": "Test",
            "author": "Test",
            "createdAt": "2024-01-01T00:00:00.000Z",
            "educationalFocus": "Test",
            "tags": [],
            "difficulty": "beginner"
          },
          "configuration": {"cameraDistanceMultiplier": 1.2, "expectedBodyCount": 0},
          "physics": {"gravitationalConstant": 1.2, "softening": 0.1, "timeScale": 1.0, "collisionRadiusMultiplier": 1.0, "maxTrailPoints": 500, "trailFadeRate": 0.95},
          "bodies": [],
          "particleSystems": {}
        }
        ''';

        final result = ScenarioSerializationService.validateJsonString(
          jsonWithNoBodies,
          mockL10n,
        );

        expect(result.isValid, isFalse);
        expect(
          result.errors.any((error) => error.contains('At least one body')),
          isTrue,
        );
      });

      test('should limit maximum number of bodies', () {
        final manyBodies = List.generate(
          51,
          (i) => {
            "name": "Body$i",
            "position": [0, 0, 0],
            "velocity": [0, 0, 0],
            "mass": 1.0,
            "radius": 1.0,
            "color": "#FF0000FF",
            "bodyType": "planet",
          },
        );

        final jsonWithManyBodies = jsonEncode({
          "version": "1.0.0",
          "metadata": {
            "name": "Test",
            "description": "Test",
            "author": "Test",
            "createdAt": "2024-01-01T00:00:00.000Z",
            "educationalFocus": "Test",
            "tags": [],
            "difficulty": "beginner",
          },
          "configuration": {
            "cameraDistanceMultiplier": 1.2,
            "expectedBodyCount": 51,
          },
          "physics": {
            "gravitationalConstant": 1.2,
            "softening": 0.1,
            "timeScale": 1.0,
            "collisionRadiusMultiplier": 1.0,
            "maxTrailPoints": 500,
            "trailFadeRate": 0.95,
          },
          "bodies": manyBodies,
          "particleSystems": {},
        });

        final result = ScenarioSerializationService.validateJsonString(
          jsonWithManyBodies,
          mockL10n,
        );

        expect(result.isValid, isFalse);
        expect(
          result.errors.any((error) => error.contains('Maximum 50 bodies')),
          isTrue,
        );
      });
    });

    group('Body Validation', () {
      test('should validate body name requirement', () {
        const jsonWithNoBodyName = '''
        {
          "version": "1.0.0",
          "metadata": {
            "name": "Test",
            "description": "Test",
            "author": "Test",
            "createdAt": "2024-01-01T00:00:00.000Z",
            "educationalFocus": "Test",
            "tags": [],
            "difficulty": "beginner"
          },
          "configuration": {"cameraDistanceMultiplier": 1.2, "expectedBodyCount": 1},
          "physics": {"gravitationalConstant": 1.2, "softening": 0.1, "timeScale": 1.0, "collisionRadiusMultiplier": 1.0, "maxTrailPoints": 500, "trailFadeRate": 0.95},
          "bodies": [{"position": [0,0,0], "velocity": [0,0,0], "mass": 1.0, "radius": 1.0, "color": "#FF0000FF", "bodyType": "planet"}],
          "particleSystems": {}
        }
        ''';

        final result = ScenarioSerializationService.validateJsonString(
          jsonWithNoBodyName,
          mockL10n,
        );

        expect(result.isValid, isFalse);
        expect(
          result.errors.any((error) => error.contains('name is required')),
          isTrue,
        );
      });

      test('should validate 3D position arrays', () {
        const jsonWithInvalidPosition = '''
        {
          "version": "1.0.0",
          "metadata": {
            "name": "Test",
            "description": "Test",
            "author": "Test",
            "createdAt": "2024-01-01T00:00:00.000Z",
            "educationalFocus": "Test",
            "tags": [],
            "difficulty": "beginner"
          },
          "configuration": {"cameraDistanceMultiplier": 1.2, "expectedBodyCount": 1},
          "physics": {"gravitationalConstant": 1.2, "softening": 0.1, "timeScale": 1.0, "collisionRadiusMultiplier": 1.0, "maxTrailPoints": 500, "trailFadeRate": 0.95},
          "bodies": [{"name": "Test", "position": [0,0], "velocity": [0,0,0], "mass": 1.0, "radius": 1.0, "color": "#FF0000FF", "bodyType": "planet"}],
          "particleSystems": {}
        }
        ''';

        final result = ScenarioSerializationService.validateJsonString(
          jsonWithInvalidPosition,
          mockL10n,
        );

        expect(result.isValid, isFalse);
        expect(
          result.errors.any((error) => error.contains('3D array [x, y, z]')),
          isTrue,
        );
      });

      test('should validate finite position values', () {
        const jsonWithInfinitePosition = '''
        {
          "version": "1.0.0",
          "metadata": {
            "name": "Test",
            "description": "Test",
            "author": "Test",
            "createdAt": "2024-01-01T00:00:00.000Z",
            "educationalFocus": "Test",
            "tags": [],
            "difficulty": "beginner"
          },
          "configuration": {"cameraDistanceMultiplier": 1.2, "expectedBodyCount": 1},
          "physics": {"gravitationalConstant": 1.2, "softening": 0.1, "timeScale": 1.0, "collisionRadiusMultiplier": 1.0, "maxTrailPoints": 500, "trailFadeRate": 0.95},
          "bodies": [{"name": "Test", "position": ["infinity", 0, 0], "velocity": [0,0,0], "mass": 1.0, "radius": 1.0, "color": "#FF0000FF", "bodyType": "planet"}],
          "particleSystems": {}
        }
        ''';

        final result = ScenarioSerializationService.validateJsonString(
          jsonWithInfinitePosition,
          mockL10n,
        );

        expect(result.isValid, isFalse);
        expect(
          result.errors.any((error) => error.contains('finite number')),
          isTrue,
        );
      });

      test('should validate 3D velocity arrays', () {
        const jsonWithInvalidVelocity = '''
        {
          "version": "1.0.0",
          "metadata": {
            "name": "Test",
            "description": "Test",
            "author": "Test",
            "createdAt": "2024-01-01T00:00:00.000Z",
            "educationalFocus": "Test",
            "tags": [],
            "difficulty": "beginner"
          },
          "configuration": {"cameraDistanceMultiplier": 1.2, "expectedBodyCount": 1},
          "physics": {"gravitationalConstant": 1.2, "softening": 0.1, "timeScale": 1.0, "collisionRadiusMultiplier": 1.0, "maxTrailPoints": 500, "trailFadeRate": 0.95},
          "bodies": [{"name": "Test", "position": [0,0,0], "velocity": [0], "mass": 1.0, "radius": 1.0, "color": "#FF0000FF", "bodyType": "planet"}],
          "particleSystems": {}
        }
        ''';

        final result = ScenarioSerializationService.validateJsonString(
          jsonWithInvalidVelocity,
          mockL10n,
        );

        expect(result.isValid, isFalse);
        expect(
          result.errors.any((error) => error.contains('3D array [vx, vy, vz]')),
          isTrue,
        );
      });

      test('should validate mass ranges', () {
        const jsonWithInvalidMass = '''
        {
          "version": "1.0.0",
          "metadata": {
            "name": "Test",
            "description": "Test",
            "author": "Test",
            "createdAt": "2024-01-01T00:00:00.000Z",
            "educationalFocus": "Test",
            "tags": [],
            "difficulty": "beginner"
          },
          "configuration": {"cameraDistanceMultiplier": 1.2, "expectedBodyCount": 1},
          "physics": {"gravitationalConstant": 1.2, "softening": 0.1, "timeScale": 1.0, "collisionRadiusMultiplier": 1.0, "maxTrailPoints": 500, "trailFadeRate": 0.95},
          "bodies": [{"name": "Test", "position": [0,0,0], "velocity": [0,0,0], "mass": -1.0, "radius": 1.0, "color": "#FF0000FF", "bodyType": "planet"}],
          "particleSystems": {}
        }
        ''';

        final result = ScenarioSerializationService.validateJsonString(
          jsonWithInvalidMass,
          mockL10n,
        );

        expect(result.isValid, isFalse);
        expect(
          result.errors.any((error) => error.contains('mass must be between')),
          isTrue,
        );
      });

      test('should validate radius ranges', () {
        const jsonWithInvalidRadius = '''
        {
          "version": "1.0.0",
          "metadata": {
            "name": "Test",
            "description": "Test",
            "author": "Test",
            "createdAt": "2024-01-01T00:00:00.000Z",
            "educationalFocus": "Test",
            "tags": [],
            "difficulty": "beginner"
          },
          "configuration": {"cameraDistanceMultiplier": 1.2, "expectedBodyCount": 1},
          "physics": {"gravitationalConstant": 1.2, "softening": 0.1, "timeScale": 1.0, "collisionRadiusMultiplier": 1.0, "maxTrailPoints": 500, "trailFadeRate": 0.95},
          "bodies": [{"name": "Test", "position": [0,0,0], "velocity": [0,0,0], "mass": 1.0, "radius": 100.0, "color": "#FF0000FF", "bodyType": "planet"}],
          "particleSystems": {}
        }
        ''';

        final result = ScenarioSerializationService.validateJsonString(
          jsonWithInvalidRadius,
          mockL10n,
        );

        expect(result.isValid, isFalse);
        expect(
          result.errors.any(
            (error) => error.contains('radius must be between'),
          ),
          isTrue,
        );
      });

      test('should validate hex color format', () {
        const jsonWithInvalidColor = '''
        {
          "version": "1.0.0",
          "metadata": {
            "name": "Test",
            "description": "Test",
            "author": "Test",
            "createdAt": "2024-01-01T00:00:00.000Z",
            "educationalFocus": "Test",
            "tags": [],
            "difficulty": "beginner"
          },
          "configuration": {"cameraDistanceMultiplier": 1.2, "expectedBodyCount": 1},
          "physics": {"gravitationalConstant": 1.2, "softening": 0.1, "timeScale": 1.0, "collisionRadiusMultiplier": 1.0, "maxTrailPoints": 500, "trailFadeRate": 0.95},
          "bodies": [{"name": "Test", "position": [0,0,0], "velocity": [0,0,0], "mass": 1.0, "radius": 1.0, "color": "invalid", "bodyType": "planet"}],
          "particleSystems": {}
        }
        ''';

        final result = ScenarioSerializationService.validateJsonString(
          jsonWithInvalidColor,
          mockL10n,
        );

        expect(result.isValid, isFalse);
        expect(
          result.errors.any((error) => error.contains('hex format')),
          isTrue,
        );
      });

      test('should validate body type enum', () {
        const jsonWithInvalidBodyType = '''
        {
          "version": "1.0.0",
          "metadata": {
            "name": "Test",
            "description": "Test",
            "author": "Test",
            "createdAt": "2024-01-01T00:00:00.000Z",
            "educationalFocus": "Test",
            "tags": [],
            "difficulty": "beginner"
          },
          "configuration": {"cameraDistanceMultiplier": 1.2, "expectedBodyCount": 1},
          "physics": {"gravitationalConstant": 1.2, "softening": 0.1, "timeScale": 1.0, "collisionRadiusMultiplier": 1.0, "maxTrailPoints": 500, "trailFadeRate": 0.95},
          "bodies": [{"name": "Test", "position": [0,0,0], "velocity": [0,0,0], "mass": 1.0, "radius": 1.0, "color": "#FF0000FF", "bodyType": "invalidType"}],
          "particleSystems": {}
        }
        ''';

        final result = ScenarioSerializationService.validateJsonString(
          jsonWithInvalidBodyType,
          mockL10n,
        );

        expect(result.isValid, isFalse);
        expect(
          result.errors.any((error) => error.contains('invalid bodyType')),
          isTrue,
        );
      });
    });

    group('Physics Settings Validation', () {
      test('should validate gravitational constant range', () {
        const jsonWithInvalidGravity = '''
        {
          "version": "1.0.0",
          "metadata": {
            "name": "Test",
            "description": "Test",
            "author": "Test",
            "createdAt": "2024-01-01T00:00:00.000Z",
            "educationalFocus": "Test",
            "tags": [],
            "difficulty": "beginner"
          },
          "configuration": {"cameraDistanceMultiplier": 1.2, "expectedBodyCount": 1},
          "physics": {"gravitationalConstant": 20.0, "softening": 0.1, "timeScale": 1.0, "collisionRadiusMultiplier": 1.0, "maxTrailPoints": 500, "trailFadeRate": 0.95},
          "bodies": [{"name": "Test", "position": [0,0,0], "velocity": [0,0,0], "mass": 1.0, "radius": 1.0, "color": "#FF0000FF", "bodyType": "planet"}],
          "particleSystems": {}
        }
        ''';

        final result = ScenarioSerializationService.validateJsonString(
          jsonWithInvalidGravity,
          mockL10n,
        );

        expect(result.isValid, isFalse);
        expect(
          result.errors.any((error) => error.contains('gravitationalConstant')),
          isTrue,
        );
      });

      test('should validate time scale range', () {
        const jsonWithInvalidTimeScale = '''
        {
          "version": "1.0.0",
          "metadata": {
            "name": "Test",
            "description": "Test",
            "author": "Test",
            "createdAt": "2024-01-01T00:00:00.000Z",
            "educationalFocus": "Test",
            "tags": [],
            "difficulty": "beginner"
          },
          "configuration": {"cameraDistanceMultiplier": 1.2, "expectedBodyCount": 1},
          "physics": {"gravitationalConstant": 1.2, "softening": 0.1, "timeScale": 50.0, "collisionRadiusMultiplier": 1.0, "maxTrailPoints": 500, "trailFadeRate": 0.95},
          "bodies": [{"name": "Test", "position": [0,0,0], "velocity": [0,0,0], "mass": 1.0, "radius": 1.0, "color": "#FF0000FF", "bodyType": "planet"}],
          "particleSystems": {}
        }
        ''';

        final result = ScenarioSerializationService.validateJsonString(
          jsonWithInvalidTimeScale,
          mockL10n,
        );

        expect(result.isValid, isFalse);
        expect(
          result.errors.any((error) => error.contains('timeScale')),
          isTrue,
        );
      });

      test('should validate trail points range', () {
        const jsonWithInvalidTrailPoints = '''
        {
          "version": "1.0.0",
          "metadata": {
            "name": "Test",
            "description": "Test",
            "author": "Test",
            "createdAt": "2024-01-01T00:00:00.000Z",
            "educationalFocus": "Test",
            "tags": [],
            "difficulty": "beginner"
          },
          "configuration": {"cameraDistanceMultiplier": 1.2, "expectedBodyCount": 1},
          "physics": {"gravitationalConstant": 1.2, "softening": 0.1, "timeScale": 1.0, "collisionRadiusMultiplier": 1.0, "maxTrailPoints": 10000, "trailFadeRate": 0.95},
          "bodies": [{"name": "Test", "position": [0,0,0], "velocity": [0,0,0], "mass": 1.0, "radius": 1.0, "color": "#FF0000FF", "bodyType": "planet"}],
          "particleSystems": {}
        }
        ''';

        final result = ScenarioSerializationService.validateJsonString(
          jsonWithInvalidTrailPoints,
          mockL10n,
        );

        expect(result.isValid, isFalse);
        expect(
          result.errors.any((error) => error.contains('maxTrailPoints')),
          isTrue,
        );
      });
    });

    group('Error Handling', () {
      test('should handle invalid hex color gracefully', () {
        expect(
          () => ScenarioSerializationService.validateJsonString(
            '{"color": "invalid"}',
            mockL10n,
          ),
          returnsNormally,
        );
      });

      test('should validate hex color format correctly', () {
        const jsonWithShortHexColor = '''
        {
          "version": "1.0.0",
          "metadata": {
            "name": "Test",
            "description": "Test",
            "author": "Test",
            "createdAt": "2024-01-01T00:00:00.000Z",
            "educationalFocus": "Test",
            "tags": [],
            "difficulty": "beginner"
          },
          "configuration": {"cameraDistanceMultiplier": 1.2, "expectedBodyCount": 1},
          "physics": {"gravitationalConstant": 1.2, "softening": 0.1, "timeScale": 1.0, "collisionRadiusMultiplier": 1.0, "maxTrailPoints": 500, "trailFadeRate": 0.95},
          "bodies": [{"name": "Test", "position": [0.0,0.0,0.0], "velocity": [0.0,0.0,0.0], "mass": 1.0, "radius": 1.0, "color": "#12", "bodyType": "planet"}],
          "particleSystems": {}
        }
        ''';

        // This should trigger validation error for invalid hex color format
        final result = ScenarioSerializationService.validateJsonString(
          jsonWithShortHexColor,
          mockL10n,
        );

        expect(result.isValid, isFalse);
        expect(
          result.errors.any((error) => error.contains('hex format')),
          isTrue,
        );
      });

      test('should handle malformed JSON gracefully', () {
        const malformedJson = '{ invalid json }';

        final result = ScenarioSerializationService.validateJsonString(
          malformedJson,
          mockL10n,
        );

        expect(result.isValid, isFalse);
        expect(result.errors, isNotEmpty);
      });

      test('should handle null values gracefully', () {
        final result = ScenarioSerializationService.validateJsonString(
          'null',
          mockL10n,
        );

        expect(result.isValid, isFalse);
        expect(result.errors, isNotEmpty);
        expect(result.errors[0], contains('Invalid JSON format'));
      });

      test('should handle missing particleSystems field', () {
        const jsonWithoutParticleSystems = '''
        {
          "version": "1.0.0",
          "metadata": {
            "name": "Test",
            "description": "Test",
            "author": "Test",
            "createdAt": "2024-01-01T00:00:00.000Z",
            "educationalFocus": "Test",
            "tags": [],
            "difficulty": "beginner"
          },
          "configuration": {"cameraDistanceMultiplier": 1.2, "expectedBodyCount": 1},
          "physics": {"gravitationalConstant": 1.2, "softening": 0.1, "timeScale": 1.0, "collisionRadiusMultiplier": 1.0, "maxTrailPoints": 500, "trailFadeRate": 0.95},
          "bodies": [{"name": "Test", "position": [0,0,0], "velocity": [0,0,0], "mass": 1.0, "radius": 1.0, "color": "#FF0000FF", "bodyType": "planet"}]
        }
        ''';

        final result = ScenarioSerializationService.validateJsonString(
          jsonWithoutParticleSystems,
          mockL10n,
        );

        expect(result.isValid, isFalse);
        expect(
          result.errors.any((error) => error.contains('particleSystems')),
          isTrue,
        );
      });
    });

    group('Real World Scenarios', () {
      test('should handle Earth-Moon system correctly', () {
        final earthMoonBodies = [
          Body(
            name: 'Earth',
            position: vm.Vector3.zero(),
            velocity: vm.Vector3.zero(),
            mass: 3.0, // Earth-like mass in simulation units
            radius: 1.0,
            color: AppColors.primaryColor,
            bodyType: BodyType.planet,
            stellarLuminosity: 0.0,
            temperature: 288.0,
            habitabilityStatus: HabitabilityStatus.habitable,
          ),
          Body(
            name: 'Moon',
            position: vm.Vector3(
              20.0,
              0,
              0,
            ), // Moon distance in simulation units
            velocity: vm.Vector3(
              0,
              0.1,
              0,
            ), // Moon's orbital velocity in simulation
            mass: 0.5, // Moon mass in simulation units
            radius: 0.3,
            color: AppColors.uiTextGrey,
            bodyType: BodyType.moon,
            stellarLuminosity: 0.0,
            temperature: 220.0,
            habitabilityStatus: HabitabilityStatus.tooHot,
          ),
        ];

        final scenario = ScenarioSerializationService.fromBodies(
          bodies: earthMoonBodies,
          metadata: testMetadata,
          physics: testPhysics,
        );

        final jsonString = ScenarioSerializationService.toJsonString(scenario);
        final result = ScenarioSerializationService.validateJsonString(
          jsonString,
          mockL10n,
        );

        expect(result.isValid, isTrue);

        final deserializedScenario =
            ScenarioSerializationService.fromJsonString(jsonString);
        final convertedBodies = ScenarioSerializationService.toBodies(
          deserializedScenario,
        );

        expect(convertedBodies.length, equals(2));
        expect(convertedBodies[0].name, equals('Earth'));
        expect(convertedBodies[1].name, equals('Moon'));
        expect(convertedBodies[0].mass, closeTo(3.0, 0.001));
        expect(convertedBodies[1].mass, closeTo(0.5, 0.001));
      });

      test('should handle binary star system correctly', () {
        final binaryStarBodies = [
          Body(
            name: 'Star A',
            position: vm.Vector3(-5, 0, 0),
            velocity: vm.Vector3(0, 10, 0),
            mass: 10.0, // Solar mass in simulation units
            radius: 2.0,
            color: AppColors.stellarGType,
            bodyType: BodyType.star,
            stellarLuminosity: 1.0,
            temperature: 5778.0,
            habitabilityStatus: HabitabilityStatus.tooHot,
          ),
          Body(
            name: 'Star B',
            position: vm.Vector3(5, 0, 0),
            velocity: vm.Vector3(0, -10, 0),
            mass: 8.0, // Smaller star mass in simulation units
            radius: 1.8, // Smaller star
            color: AppColors.uiOrangeAccent,
            bodyType: BodyType.star,
            stellarLuminosity: 0.6,
            temperature: 4900.0,
            habitabilityStatus: HabitabilityStatus.tooHot,
          ),
        ];

        final scenario = ScenarioSerializationService.fromBodies(
          bodies: binaryStarBodies,
          metadata: testMetadata,
          physics: testPhysics,
        );

        final jsonString = ScenarioSerializationService.toJsonString(scenario);
        final result = ScenarioSerializationService.validateJsonString(
          jsonString,
          mockL10n,
        );

        expect(result.isValid, isTrue);

        final convertedBodies = ScenarioSerializationService.toBodies(
          ScenarioSerializationService.fromJsonString(jsonString),
        );

        expect(convertedBodies.length, equals(2));
        expect(
          convertedBodies.every((body) => body.bodyType == BodyType.star),
          isTrue,
        );
        expect(convertedBodies[0].stellarLuminosity, closeTo(1.0, 0.001));
        expect(convertedBodies[1].stellarLuminosity, closeTo(0.6, 0.001));
      });
    });

    group('Edge Cases and Boundary Testing', () {
      test('should handle minimum valid mass', () {
        final body = Body(
          name: 'Tiny Body',
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 0.001, // Minimum valid mass
          radius: 0.1,
          color: AppColors.uiWhite,
          bodyType: BodyType.planet,
        );

        final scenario = ScenarioSerializationService.fromBodies(
          bodies: [body],
          metadata: testMetadata,
        );

        final jsonString = ScenarioSerializationService.toJsonString(scenario);
        final result = ScenarioSerializationService.validateJsonString(
          jsonString,
          mockL10n,
        );

        expect(result.isValid, isTrue);
      });

      test('should handle maximum valid mass', () {
        final body = Body(
          name: 'Massive Body',
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1000.0, // Maximum valid mass
          radius: 50.0,
          color: AppColors.backgroundBlack,
          bodyType: BodyType.blackHole,
        );

        final scenario = ScenarioSerializationService.fromBodies(
          bodies: [body],
          metadata: testMetadata,
        );

        final jsonString = ScenarioSerializationService.toJsonString(scenario);
        final result = ScenarioSerializationService.validateJsonString(
          jsonString,
          mockL10n,
        );

        expect(result.isValid, isTrue);
      });

      test('should handle all body types correctly', () {
        final bodyTypes = BodyType.values;
        final bodies = bodyTypes
            .map(
              (type) => Body(
                name: 'Test ${type.name}',
                position: vm.Vector3.zero(),
                velocity: vm.Vector3.zero(),
                mass: 1.0,
                radius: 1.0,
                color: AppColors.uiRed,
                bodyType: type,
              ),
            )
            .toList();

        final scenario = ScenarioSerializationService.fromBodies(
          bodies: bodies,
          metadata: testMetadata,
        );

        final jsonString = ScenarioSerializationService.toJsonString(scenario);
        final result = ScenarioSerializationService.validateJsonString(
          jsonString,
          mockL10n,
        );

        expect(result.isValid, isTrue);

        final convertedBodies = ScenarioSerializationService.toBodies(
          ScenarioSerializationService.fromJsonString(jsonString),
        );

        expect(convertedBodies.length, equals(bodyTypes.length));
        for (int i = 0; i < bodyTypes.length; i++) {
          expect(convertedBodies[i].bodyType, equals(bodyTypes[i]));
        }
      });

      test('should validate position component values', () {
        const jsonWithInfinitePosition = '''
        {
          "version": "1.0.0",
          "metadata": {
            "name": "Test",
            "description": "Test",
            "author": "Test",
            "createdAt": "2024-01-01T00:00:00.000Z",
            "educationalFocus": "Test",
            "tags": [],
            "difficulty": "beginner"
          },
          "configuration": {"cameraDistanceMultiplier": 1.2, "expectedBodyCount": 1},
          "physics": {"gravitationalConstant": 1.2, "softening": 0.1, "timeScale": 1.0, "collisionRadiusMultiplier": 1.0, "maxTrailPoints": 500, "trailFadeRate": 0.95},
          "bodies": [{"name": "Test", "position": [1, "infinity", 0], "velocity": [0.0,0.0,0.0], "mass": 1.0, "radius": 1.0, "color": "#FF0000FF", "bodyType": "planet"}],
          "particleSystems": {}
        }
        ''';

        final result = ScenarioSerializationService.validateJsonString(
          jsonWithInfinitePosition,
          mockL10n,
        );

        expect(result.isValid, isFalse);
        expect(
          result.errors.any((error) => error.contains('position[1]')),
          isTrue,
        );
      });

      test('should validate velocity component values', () {
        const jsonWithInfiniteVelocity = '''
        {
          "version": "1.0.0",
          "metadata": {
            "name": "Test",
            "description": "Test",
            "author": "Test",
            "createdAt": "2024-01-01T00:00:00.000Z",
            "educationalFocus": "Test",
            "tags": [],
            "difficulty": "beginner"
          },
          "configuration": {"cameraDistanceMultiplier": 1.2, "expectedBodyCount": 1},
          "physics": {"gravitationalConstant": 1.2, "softening": 0.1, "timeScale": 1.0, "collisionRadiusMultiplier": 1.0, "maxTrailPoints": 500, "trailFadeRate": 0.95},
          "bodies": [{"name": "Test", "position": [0.0,0.0,0.0], "velocity": [0, "NaN", 0], "mass": 1.0, "radius": 1.0, "color": "#FF0000FF", "bodyType": "planet"}],
          "particleSystems": {}
        }
        ''';

        final result = ScenarioSerializationService.validateJsonString(
          jsonWithInfiniteVelocity,
          mockL10n,
        );

        expect(result.isValid, isFalse);
        expect(
          result.errors.any((error) => error.contains('velocity[1]')),
          isTrue,
        );
      });
    });
  });
}
