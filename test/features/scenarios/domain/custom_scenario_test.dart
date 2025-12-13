import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/features/scenarios/domain/custom_scenario.dart';
import 'package:graviton/features/scenarios/domain/scenario_metadata.dart';
import 'package:graviton/features/scenarios/domain/scenario_configuration.dart';
import 'package:graviton/features/scenarios/domain/scenario_physics_settings.dart';
import 'package:graviton/models/celestial/body_data.dart';
import 'package:graviton/features/scenarios/domain/particle_systems_config.dart';
import 'package:graviton/features/scenarios/domain/objectives_config.dart';
import 'package:graviton/features/scenarios/domain/success_criteria.dart';
import 'package:graviton/models/physics/chaos_events.dart';
import 'package:graviton/models/particles/particle_system_data.dart';
import 'package:graviton/core/enums/body_type.dart';
import 'package:graviton/core/enums/habitability_status.dart';
import 'dart:convert';

void main() {
  group('CustomScenario', () {
    late ScenarioMetadata testMetadata;
    late ScenarioConfiguration testConfiguration;
    late ScenarioPhysicsSettings testPhysics;
    late List<BodyData> testBodies;
    late ParticleSystemsConfig testParticleSystems;

    setUp(() {
      testMetadata = ScenarioMetadata(
        name: 'Test Scenario',
        description: 'A test scenario for unit testing',
        educationalFocus: 'orbital mechanics',
        tags: const ['test', 'physics'],
        difficulty: 'easy',
        createdAt: DateTime(2024, 1, 1),
        author: 'Test Author',
      );

      testConfiguration = const ScenarioConfiguration(
        cameraDistanceMultiplier: 1.0,
        expectedBodyCount: 1,
        optimalCameraDistance: 100.0,
      );

      testPhysics = const ScenarioPhysicsSettings(
        gravitationalConstant: 6.67430e-11,
        softening: 0.01,
        timeScale: 1.0,
        collisionRadiusMultiplier: 1.0,
        maxTrailPoints: 1000,
        trailFadeRate: 0.95,
      );

      testBodies = [
        const BodyData(
          name: 'Sun',
          mass: 1.989e30,
          radius: 695700000.0,
          position: [0.0, 0.0, 0.0],
          velocity: [0.0, 0.0, 0.0],
          color: '#FFFF00',
          bodyType: BodyType.star,
          temperature: 5778.0,
          stellarLuminosity: 3.828e26,
          showGravityWell: false,
          isPlanet: false,
          habitabilityStatus: HabitabilityStatus.tooHot,
        ),
      ];

      testParticleSystems = const ParticleSystemsConfig(
        asteroidBelt: ParticleSystemData(
          enabled: true,
          particleCount: 1000,
          innerRadius: 2.2,
          outerRadius: 3.2,
          centralMass: 1.989e30,
          gravitationalConstant: 6.67430e-11,
          baseColor: '#888888',
          colorVariation: 0.2,
          useXZPlane: false,
          minSize: 0.5,
          maxSize: 2.0,
        ),
      );
    });

    group('constructor and properties', () {
      test('creates instance with all required properties', () {
        final scenario = CustomScenario(
          version: '2.1.0',
          metadata: testMetadata,
          configuration: testConfiguration,
          physics: testPhysics,
          bodies: testBodies,
          particleSystems: testParticleSystems,
        );

        expect(scenario.version, equals('2.1.0'));
        expect(scenario.metadata, equals(testMetadata));
        expect(scenario.configuration, equals(testConfiguration));
        expect(scenario.physics, equals(testPhysics));
        expect(scenario.bodies, equals(testBodies));
        expect(scenario.particleSystems, equals(testParticleSystems));
        expect(scenario.objectives, isNull);
      });

      test('creates instance with optional objectives', () {
        final objectives = ObjectivesConfig(
          enabled: true,
          primary: 'Test objective',
          secondary: 'Secondary objective',
          timeLimit: 3600,
          successCriteria: const SuccessCriteria(
            stabilityThreshold: 0.95,
            minimumTime: 3600,
            allowedCollisions: 0,
          ),
          chaosEvents: const ChaosEvents(
            enabled: false,
            frequency: 0,
            types: [],
          ),
        );

        final scenario = CustomScenario(
          version: '2.1.0',
          metadata: testMetadata,
          configuration: testConfiguration,
          physics: testPhysics,
          bodies: testBodies,
          particleSystems: testParticleSystems,
          objectives: objectives,
        );

        expect(scenario.objectives, equals(objectives));
        expect(scenario.objectives?.primary, equals('Test objective'));
        expect(scenario.objectives?.enabled, isTrue);
      });

      test('handles empty bodies list', () {
        final scenario = CustomScenario(
          version: '1.0.0',
          metadata: testMetadata,
          configuration: testConfiguration,
          physics: testPhysics,
          bodies: [],
          particleSystems: testParticleSystems,
        );

        expect(scenario.bodies, isEmpty);
      });
    });

    group('fromJson factory constructor', () {
      test('creates from complete JSON map', () {
        final json = {
          'version': '2.1.0',
          'metadata': testMetadata.toJson(),
          'configuration': testConfiguration.toJson(),
          'physics': testPhysics.toJson(),
          'bodies': testBodies.map((body) => body.toJson()).toList(),
          'particleSystems': testParticleSystems.toJson(),
        };

        final scenario = CustomScenario.fromJson(json);

        expect(scenario.version, equals('2.1.0'));
        expect(scenario.metadata.name, equals(testMetadata.name));
        expect(
          scenario.configuration.cameraDistanceMultiplier,
          equals(testConfiguration.cameraDistanceMultiplier),
        );
        expect(
          scenario.physics.gravitationalConstant,
          equals(testPhysics.gravitationalConstant),
        );
        expect(scenario.bodies.length, equals(1));
        expect(scenario.bodies[0].name, equals('Sun'));
        expect(scenario.particleSystems.asteroidBelt?.enabled, isTrue);
        expect(scenario.objectives, isNull);
      });
    });

    group('toJson method', () {
      test('converts to JSON without objectives', () {
        final scenario = CustomScenario(
          version: '1.0.0',
          metadata: testMetadata,
          configuration: testConfiguration,
          physics: testPhysics,
          bodies: testBodies,
          particleSystems: testParticleSystems,
        );

        final json = scenario.toJson();

        expect(json['version'], equals('1.0.0'));
        expect(json.containsKey('objectives'), isFalse);
      });
    });

    group('round-trip serialization', () {
      test('maintains data integrity through fromJson/toJson cycle', () {
        final original = CustomScenario(
          version: '2.1.0',
          metadata: testMetadata,
          configuration: testConfiguration,
          physics: testPhysics,
          bodies: testBodies,
          particleSystems: testParticleSystems,
        );

        final json = original.toJson();
        final restored = CustomScenario.fromJson(json);

        expect(restored.version, equals(original.version));
        expect(restored.metadata.name, equals(original.metadata.name));
        expect(restored.bodies.length, equals(original.bodies.length));
        expect(restored.bodies[0].name, equals(original.bodies[0].name));
      });
    });

    group('edge cases and validation', () {
      test('handles version format variations', () {
        final testVersions = ['1.0.0', '2.1.0-beta', '3.0.0-alpha.1', '1.0'];

        for (final version in testVersions) {
          final scenario = CustomScenario(
            version: version,
            metadata: testMetadata,
            configuration: testConfiguration,
            physics: testPhysics,
            bodies: testBodies,
            particleSystems: testParticleSystems,
          );
          expect(scenario.version, equals(version));
        }
      });

      test('validates JSON structure integrity', () {
        final scenario = CustomScenario(
          version: '1.0.0',
          metadata: testMetadata,
          configuration: testConfiguration,
          physics: testPhysics,
          bodies: testBodies,
          particleSystems: testParticleSystems,
        );

        final json = scenario.toJson();

        // Verify all required top-level fields are present
        expect(
          json.keys,
          containsAll([
            'version',
            'metadata',
            'configuration',
            'physics',
            'bodies',
            'particleSystems',
          ]),
        );

        // Verify structure can be serialized to JSON string
        expect(() => jsonEncode(json), returnsNormally);
      });
    });
  });
}
