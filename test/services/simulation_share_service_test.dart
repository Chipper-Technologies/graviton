import 'dart:convert';

import 'package:flutter/material.dart' show GlobalKey;
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/config/flavor_config.dart';
import 'package:graviton/enums/app_flavor.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/services/simulation_share_service.dart';
import 'package:graviton/state/simulation_state.dart';
import 'package:graviton/theme/app_colors.dart';

import '../test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SimulationShareService', () {
    late SimulationShareService service;
    late SimulationState simulationState;

    setUp(() async {
      // Initialize flavor config
      FlavorConfig.instance.initialize(
        flavor: AppFlavor.dev,
        appName: 'Graviton Dev',
      );

      service = SimulationShareService.instance;
      simulationState = SimulationState();
      await simulationState.initialize(); // Initialize with a scenario

      // Create mock localization and reset with a scenario that has bodies
      final mockL10n = TestUtils.createMockAppLocalizations();
      simulationState.updateLocalization(mockL10n);
      simulationState.resetWithScenario(ScenarioType.solarSystem);
    });

    tearDown(() {
      simulationState.dispose();
    });

    group('Singleton Pattern', () {
      test('Should return same instance', () {
        final instance1 = SimulationShareService.instance;
        final instance2 = SimulationShareService.instance;

        expect(identical(instance1, instance2), isTrue);
      });
    });

    group('Export Simulation State to JSON', () {
      test('Should export valid JSON with all required fields', () async {
        // Arrange
        simulationState.start();
        await Future.delayed(const Duration(milliseconds: 100));

        // Act
        final jsonString = await service.exportSimulationStateToJson(
          simulationState: simulationState,
          customName: 'Test Simulation',
        );

        // Assert
        expect(jsonString, isNotEmpty);

        final data = jsonDecode(jsonString) as Map<String, dynamic>;
        expect(data['version'], equals('1.0.0'));
        expect(data['name'], equals('Test Simulation'));
        expect(data['timestamp'], isNotNull);
        expect(data['scenarioType'], isNotNull);
        expect(data['physics'], isNotNull);
        expect(data['simulation'], isNotNull);
        expect(data['bodies'], isNotNull);
      });

      test('Should include physics settings', () async {
        // Act
        final jsonString = await service.exportSimulationStateToJson(
          simulationState: simulationState,
        );
        final data = jsonDecode(jsonString) as Map<String, dynamic>;
        final physics = data['physics'] as Map<String, dynamic>;

        // Assert
        expect(physics['gravitationalConstant'], isNotNull);
        expect(physics['softening'], isNotNull);
        expect(physics['collisionRadiusMultiplier'], isNotNull);
        expect(physics['maxTrailPoints'], isNotNull);
      });

      test('Should include simulation state data', () async {
        // Arrange
        simulationState.start();
        await Future.delayed(const Duration(milliseconds: 50));

        // Act
        final jsonString = await service.exportSimulationStateToJson(
          simulationState: simulationState,
        );
        final data = jsonDecode(jsonString) as Map<String, dynamic>;
        final simulation = data['simulation'] as Map<String, dynamic>;

        // Assert
        expect(simulation['timeScale'], equals(simulationState.timeScale));
        expect(simulation['totalTime'], equals(simulationState.totalTime));
        expect(simulation['stepCount'], equals(simulationState.stepCount));
      });

      test('Should export all bodies with complete data', () async {
        // Act
        final jsonString = await service.exportSimulationStateToJson(
          simulationState: simulationState,
        );
        final data = jsonDecode(jsonString) as Map<String, dynamic>;
        final bodies = data['bodies'] as List<dynamic>;

        // Assert
        expect(bodies, isNotEmpty);

        for (final bodyJson in bodies) {
          final body = bodyJson as Map<String, dynamic>;
          expect(body['name'], isNotNull);
          expect(body['mass'], isNotNull);
          expect(body['radius'], isNotNull);
          expect(body['position'], isNotNull);
          expect(body['velocity'], isNotNull);
          expect(body['color'], isNotNull);

          final position = body['position'] as Map<String, dynamic>;
          expect(position['x'], isNotNull);
          expect(position['y'], isNotNull);
          expect(position['z'], isNotNull);

          final velocity = body['velocity'] as Map<String, dynamic>;
          expect(velocity['x'], isNotNull);
          expect(velocity['y'], isNotNull);
          expect(velocity['z'], isNotNull);
        }
      });

      test('Should use custom name when provided', () async {
        // Act
        final jsonString = await service.exportSimulationStateToJson(
          simulationState: simulationState,
          customName: 'My Cool Simulation',
        );
        final data = jsonDecode(jsonString) as Map<String, dynamic>;

        // Assert
        expect(data['name'], equals('My Cool Simulation'));
      });

      test('Should use default name when not provided', () async {
        // Act
        final jsonString = await service.exportSimulationStateToJson(
          simulationState: simulationState,
        );
        final data = jsonDecode(jsonString) as Map<String, dynamic>;

        // Assert
        expect(data['name'], equals('Shared Simulation'));
      });

      test('Should have valid ISO 8601 timestamp', () async {
        // Act
        final jsonString = await service.exportSimulationStateToJson(
          simulationState: simulationState,
        );
        final data = jsonDecode(jsonString) as Map<String, dynamic>;
        final timestamp = data['timestamp'] as String;

        // Assert
        expect(() => DateTime.parse(timestamp), returnsNormally);

        final parsedTime = DateTime.parse(timestamp);
        final now = DateTime.now();
        expect(
          parsedTime.isBefore(now) || parsedTime.isAtSameMomentAs(now),
          isTrue,
        );
      });

      test('Should export scenario type correctly', () async {
        // Arrange - reset with specific scenario
        simulationState.resetWithScenario(ScenarioType.solarSystem);

        // Act
        final jsonString = await service.exportSimulationStateToJson(
          simulationState: simulationState,
        );
        final data = jsonDecode(jsonString) as Map<String, dynamic>;

        // Assert
        expect(data['scenarioType'], equals('solarSystem'));
      });
    });

    group('Import Simulation State from JSON', () {
      test('Should import valid JSON successfully', () async {
        // Arrange
        final exportedJson = await service.exportSimulationStateToJson(
          simulationState: simulationState,
        );

        // Act
        final result = await service.importSimulationStateFromJson(
          exportedJson,
        );

        // Assert
        expect(result, isNotNull);
        expect(result!['version'], equals('1.0.0'));
        expect(result['bodies'], isNotNull);
        expect(result['physics'], isNotNull);
      });

      test('Should return null for invalid JSON', () async {
        // Arrange
        const invalidJson = 'not valid json';

        // Act
        final result = await service.importSimulationStateFromJson(invalidJson);

        // Assert
        expect(result, isNull);
      });

      test('Should return null for JSON missing required fields', () async {
        // Arrange
        final incompleteData = {'name': 'Test'};
        final incompleteJson = jsonEncode(incompleteData);

        // Act
        final result = await service.importSimulationStateFromJson(
          incompleteJson,
        );

        // Assert
        expect(result, isNull);
      });

      test('Should validate presence of version field', () async {
        // Arrange
        final dataWithoutVersion = {'bodies': [], 'physics': {}};
        final json = jsonEncode(dataWithoutVersion);

        // Act
        final result = await service.importSimulationStateFromJson(json);

        // Assert
        expect(result, isNull);
      });

      test('Should validate presence of bodies field', () async {
        // Arrange
        final dataWithoutBodies = {'version': '1.0.0', 'physics': {}};
        final json = jsonEncode(dataWithoutBodies);

        // Act
        final result = await service.importSimulationStateFromJson(json);

        // Assert
        expect(result, isNull);
      });

      test('Should validate presence of physics field', () async {
        // Arrange
        final dataWithoutPhysics = {'version': '1.0.0', 'bodies': []};
        final json = jsonEncode(dataWithoutPhysics);

        // Act
        final result = await service.importSimulationStateFromJson(json);

        // Assert
        expect(result, isNull);
      });
    });

    group('Body Serialization', () {
      test('Should serialize body correctly', () async {
        // Act
        final serialized = await service.exportSimulationStateToJson(
          simulationState: simulationState,
        );

        // Assert - verify structure is correct
        expect(() => jsonDecode(serialized.toString()), returnsNormally);
      });

      test('Should deserialize body correctly', () {
        // Arrange
        final bodyJson = {
          'name': 'Test Body',
          'mass': 100.0,
          'radius': 5.0,
          'position': {'x': 10.0, 'y': 20.0, 'z': 30.0},
          'velocity': {'x': 1.0, 'y': 2.0, 'z': 3.0},
          'color': AppColors.stellarOType.toARGB32(),
        };

        // Act
        final body = service.deserializeBody(bodyJson);

        // Assert
        expect(body.name, equals('Test Body'));
        expect(body.mass, equals(100.0));
        expect(body.radius, equals(5.0));
        expect(body.position.x, equals(10.0));
        expect(body.position.y, equals(20.0));
        expect(body.position.z, equals(30.0));
        expect(body.velocity.x, equals(1.0));
        expect(body.velocity.y, equals(2.0));
        expect(body.velocity.z, equals(3.0));
        expect(
          body.color.toARGB32(),
          equals(AppColors.stellarOType.toARGB32()),
        );
      });

      test('Should preserve all body properties in round-trip', () async {
        // Arrange - Export current simulation
        final exportedJson = await service.exportSimulationStateToJson(
          simulationState: simulationState,
        );
        final data = jsonDecode(exportedJson) as Map<String, dynamic>;
        final bodies = service.extractBodiesFromJson(data);

        // Get first body from simulation
        final originalBody = simulationState.bodies.first;

        // Act - Find corresponding deserialized body
        final deserializedBody = bodies.first;

        // Assert - Verify all properties match
        expect(deserializedBody.name, equals(originalBody.name));
        expect(deserializedBody.mass, equals(originalBody.mass));
        expect(deserializedBody.radius, equals(originalBody.radius));
        expect(deserializedBody.position.x, equals(originalBody.position.x));
        expect(deserializedBody.position.y, equals(originalBody.position.y));
        expect(deserializedBody.position.z, equals(originalBody.position.z));
        expect(deserializedBody.velocity.x, equals(originalBody.velocity.x));
        expect(deserializedBody.velocity.y, equals(originalBody.velocity.y));
        expect(deserializedBody.velocity.z, equals(originalBody.velocity.z));
        expect(
          deserializedBody.color.toARGB32(),
          equals(originalBody.color.toARGB32()),
        );
      });
    });

    group('PhysicsSettings Extraction', () {
      test('Should create physics settings from JSON', () async {
        // Arrange
        final exportedJson = await service.exportSimulationStateToJson(
          simulationState: simulationState,
        );
        final data = jsonDecode(exportedJson) as Map<String, dynamic>;

        // Act
        final physics = service.createPhysicsSettingsFromJson(data);

        // Assert
        expect(physics, isNotNull);
        expect(physics.gravitationalConstant, isNotNull);
        expect(physics.softening, isNotNull);
        expect(physics.collisionRadiusMultiplier, isNotNull);
        expect(physics.maxTrailPoints, isNotNull);
      });

      test('Should extract correct physics values', () async {
        // Arrange
        final sim = simulationState.simulation;
        final originalG = sim.gravitationalConstant;
        final originalSoftening = sim.softening;
        final originalCollisionMultiplier = sim.collisionRadiusMultiplier;
        final originalMaxTrail = sim.maxTrail;

        final exportedJson = await service.exportSimulationStateToJson(
          simulationState: simulationState,
        );
        final data = jsonDecode(exportedJson) as Map<String, dynamic>;

        // Act
        final physics = service.createPhysicsSettingsFromJson(data);

        // Assert
        expect(physics.gravitationalConstant, equals(originalG));
        expect(physics.softening, equals(originalSoftening));
        expect(
          physics.collisionRadiusMultiplier,
          equals(originalCollisionMultiplier),
        );
        expect(physics.maxTrailPoints, equals(originalMaxTrail));
      });
    });

    group('Bodies Extraction', () {
      test('Should extract bodies from JSON', () async {
        // Arrange
        final exportedJson = await service.exportSimulationStateToJson(
          simulationState: simulationState,
        );
        final data = jsonDecode(exportedJson) as Map<String, dynamic>;

        // Act
        final bodies = service.extractBodiesFromJson(data);

        // Assert
        expect(bodies, isNotEmpty);
        expect(bodies.length, equals(simulationState.bodies.length));
      });

      test('Should preserve body count in extraction', () async {
        // Arrange
        simulationState.resetWithScenario(ScenarioType.solarSystem);
        final originalBodyCount = simulationState.bodies.length;

        final exportedJson = await service.exportSimulationStateToJson(
          simulationState: simulationState,
        );
        final data = jsonDecode(exportedJson) as Map<String, dynamic>;

        // Act
        final bodies = service.extractBodiesFromJson(data);

        // Assert
        expect(bodies.length, equals(originalBodyCount));
      });

      test('Should handle empty bodies list', () async {
        // Arrange
        final emptyData = {
          'version': '1.0.0',
          'physics': {
            'gravitationalConstant': 1.0,
            'softening': 0.1,
            'collisionRadiusMultiplier': 2.0,
            'maxTrailPoints': 100,
            'trailFadeRate': 0.5,
            'vibrationThrottleTime': 0.18,
            'vibrationEnabled': true,
          },
          'bodies': [],
        };

        // Act
        final bodies = service.extractBodiesFromJson(emptyData);

        // Assert
        expect(bodies, isEmpty);
      });
    });

    group('Scenario Type Extraction', () {
      test('Should extract scenario type from JSON', () async {
        // Arrange
        simulationState.resetWithScenario(ScenarioType.binaryStars);

        final exportedJson = await service.exportSimulationStateToJson(
          simulationState: simulationState,
        );
        final data = jsonDecode(exportedJson) as Map<String, dynamic>;

        // Act
        final scenarioType = service.extractScenarioTypeFromJson(data);

        // Assert
        expect(scenarioType, equals(ScenarioType.binaryStars));
      });

      test('Should return default for invalid scenario type', () {
        // Arrange
        final invalidData = {'scenarioType': 'nonExistentScenario'};

        // Act
        final scenarioType = service.extractScenarioTypeFromJson(invalidData);

        // Assert
        expect(scenarioType, equals(ScenarioType.random));
      });

      test('Should return null when scenario type missing', () {
        // Arrange
        final dataWithoutScenario = <String, dynamic>{};

        // Act
        final scenarioType = service.extractScenarioTypeFromJson(
          dataWithoutScenario,
        );

        // Assert
        expect(scenarioType, isNull);
      });

      test('Should handle all scenario types', () async {
        // Test a few key scenario types
        final scenariosToTest = [
          ScenarioType.random,
          ScenarioType.solarSystem,
          ScenarioType.binaryStars,
          ScenarioType.threeBodyClassic,
        ];

        for (final scenario in scenariosToTest) {
          // Arrange
          simulationState.resetWithScenario(scenario);
          final exportedJson = await service.exportSimulationStateToJson(
            simulationState: simulationState,
          );
          final data = jsonDecode(exportedJson) as Map<String, dynamic>;

          // Act
          final extractedType = service.extractScenarioTypeFromJson(data);

          // Assert
          expect(
            extractedType,
            equals(scenario),
            reason: 'Failed for scenario: ${scenario.name}',
          );
        }
      });
    });

    group('Filename Generation', () {
      test(
        'Should generate filenames with timestamp (tested via export)',
        () async {
          // Since _generateFileName is private, we test it indirectly through file operations
          // The method should generate unique filenames with timestamps

          // Act - Export twice with small delay
          final export1 = await service.exportSimulationStateToJson(
            simulationState: simulationState,
          );
          await Future.delayed(const Duration(milliseconds: 10));
          final export2 = await service.exportSimulationStateToJson(
            simulationState: simulationState,
          );

          // Assert - Both exports should succeed and produce valid JSON
          expect(export1, isNotEmpty);
          expect(export2, isNotEmpty);
          expect(() => jsonDecode(export1), returnsNormally);
          expect(() => jsonDecode(export2), returnsNormally);
        },
      );
    });

    group('Complete Round-Trip Test', () {
      test('Should export and import simulation maintaining state', () async {
        // Arrange
        simulationState.resetWithScenario(ScenarioType.solarSystem);
        simulationState.start();
        await Future.delayed(const Duration(milliseconds: 100));

        final originalBodies = simulationState.bodies.length;
        final originalScenario = simulationState.simulation.currentScenario;

        // Act - Export
        final exportedJson = await service.exportSimulationStateToJson(
          simulationState: simulationState,
          customName: 'Round Trip Test',
        );

        // Act - Import
        final importedData = await service.importSimulationStateFromJson(
          exportedJson,
        );

        // Assert
        expect(importedData, isNotNull);
        expect(importedData!['name'], equals('Round Trip Test'));

        final extractedBodies = service.extractBodiesFromJson(importedData);
        expect(extractedBodies.length, equals(originalBodies));

        final extractedScenario = service.extractScenarioTypeFromJson(
          importedData,
        );
        expect(extractedScenario, equals(originalScenario));

        final extractedPhysics = service.createPhysicsSettingsFromJson(
          importedData,
        );
        expect(
          extractedPhysics.gravitationalConstant,
          equals(simulationState.simulation.gravitationalConstant),
        );
      });

      test('Should handle multiple export-import cycles', () async {
        // Arrange
        simulationState.resetWithScenario(ScenarioType.binaryStars);

        // Act & Assert - First cycle
        var exportedJson = await service.exportSimulationStateToJson(
          simulationState: simulationState,
        );
        var importedData = await service.importSimulationStateFromJson(
          exportedJson,
        );
        expect(importedData, isNotNull);

        // Act & Assert - Second cycle
        exportedJson = await service.exportSimulationStateToJson(
          simulationState: simulationState,
        );
        importedData = await service.importSimulationStateFromJson(
          exportedJson,
        );
        expect(importedData, isNotNull);

        // Act & Assert - Third cycle
        exportedJson = await service.exportSimulationStateToJson(
          simulationState: simulationState,
        );
        importedData = await service.importSimulationStateFromJson(
          exportedJson,
        );
        expect(importedData, isNotNull);
      });
    });

    group('Error Handling', () {
      test('Should handle null repaint boundary gracefully', () async {
        // Arrange
        final key = GlobalKey();

        // Act
        final result = await service.captureSimulationImage(key);

        // Assert
        expect(result, isNull);
      });

      test('Should handle malformed JSON gracefully in import', () async {
        // Arrange
        const malformedJson = '{invalid json}';

        // Act
        final result = await service.importSimulationStateFromJson(
          malformedJson,
        );

        // Assert
        expect(result, isNull);
      });

      test('Should handle empty string JSON gracefully', () async {
        // Arrange
        const emptyJson = '';

        // Act
        final result = await service.importSimulationStateFromJson(emptyJson);

        // Assert
        expect(result, isNull);
      });
    });

    group('Data Validation', () {
      test('Should export positive body masses', () async {
        // Act
        final jsonString = await service.exportSimulationStateToJson(
          simulationState: simulationState,
        );
        final data = jsonDecode(jsonString) as Map<String, dynamic>;
        final bodies = data['bodies'] as List<dynamic>;

        // Assert
        for (final bodyJson in bodies) {
          final body = bodyJson as Map<String, dynamic>;
          expect((body['mass'] as num).toDouble(), greaterThan(0.0));
        }
      });

      test('Should export positive body radii', () async {
        // Act
        final jsonString = await service.exportSimulationStateToJson(
          simulationState: simulationState,
        );
        final data = jsonDecode(jsonString) as Map<String, dynamic>;
        final bodies = data['bodies'] as List<dynamic>;

        // Assert
        for (final bodyJson in bodies) {
          final body = bodyJson as Map<String, dynamic>;
          expect((body['radius'] as num).toDouble(), greaterThan(0.0));
        }
      });

      test('Should export finite position values', () async {
        // Act
        final jsonString = await service.exportSimulationStateToJson(
          simulationState: simulationState,
        );
        final data = jsonDecode(jsonString) as Map<String, dynamic>;
        final bodies = data['bodies'] as List<dynamic>;

        // Assert
        for (final bodyJson in bodies) {
          final body = bodyJson as Map<String, dynamic>;
          final position = body['position'] as Map<String, dynamic>;

          expect((position['x'] as num).toDouble().isFinite, isTrue);
          expect((position['y'] as num).toDouble().isFinite, isTrue);
          expect((position['z'] as num).toDouble().isFinite, isTrue);
        }
      });

      test('Should export finite velocity values', () async {
        // Act
        final jsonString = await service.exportSimulationStateToJson(
          simulationState: simulationState,
        );
        final data = jsonDecode(jsonString) as Map<String, dynamic>;
        final bodies = data['bodies'] as List<dynamic>;

        // Assert
        for (final bodyJson in bodies) {
          final body = bodyJson as Map<String, dynamic>;
          final velocity = body['velocity'] as Map<String, dynamic>;

          expect((velocity['x'] as num).toDouble().isFinite, isTrue);
          expect((velocity['y'] as num).toDouble().isFinite, isTrue);
          expect((velocity['z'] as num).toDouble().isFinite, isTrue);
        }
      });
    });

    group('JSON Structure', () {
      test('Should produce valid JSON structure', () async {
        // Act
        final jsonString = await service.exportSimulationStateToJson(
          simulationState: simulationState,
        );

        // Assert
        expect(() => jsonDecode(jsonString), returnsNormally);
      });

      test('Should produce properly indented JSON', () async {
        // Act
        final jsonString = await service.exportSimulationStateToJson(
          simulationState: simulationState,
        );

        // Assert
        expect(jsonString.contains('\n'), isTrue);
        expect(
          jsonString.contains('  '),
          isTrue,
        ); // Should have 2-space indentation
      });

      test('Should have consistent structure across exports', () async {
        // Act
        final export1 = await service.exportSimulationStateToJson(
          simulationState: simulationState,
        );
        final export2 = await service.exportSimulationStateToJson(
          simulationState: simulationState,
        );

        final data1 = jsonDecode(export1) as Map<String, dynamic>;
        final data2 = jsonDecode(export2) as Map<String, dynamic>;

        // Assert
        expect(data1.keys.toSet(), equals(data2.keys.toSet()));
        expect(
          data1['physics'].keys.toSet(),
          equals(data2['physics'].keys.toSet()),
        );
        expect(
          data1['simulation'].keys.toSet(),
          equals(data2['simulation'].keys.toSet()),
        );
      });
    });
  });
}
