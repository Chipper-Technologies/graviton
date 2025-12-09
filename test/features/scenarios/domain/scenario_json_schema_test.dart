import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/features/scenarios/domain/scenario_json_schema.dart';

void main() {
  group('CustomScenarioJsonSchema', () {
    group('example JSON schema', () {
      test('contains valid JSON structure', () {
        // Verify the example string is valid JSON
        expect(() {
          json.decode(CustomScenarioJsonSchema.example);
        }, returnsNormally);
      });

      test('has all required top-level keys', () {
        final parsedJson =
            json.decode(CustomScenarioJsonSchema.example)
                as Map<String, dynamic>;

        expect(parsedJson, containsPair('version', isA<String>()));
        expect(
          parsedJson,
          containsPair('metadata', isA<Map<String, dynamic>>()),
        );
        expect(
          parsedJson,
          containsPair('configuration', isA<Map<String, dynamic>>()),
        );
        expect(
          parsedJson,
          containsPair('physics', isA<Map<String, dynamic>>()),
        );
        expect(parsedJson, containsPair('bodies', isA<List<dynamic>>()));
        expect(
          parsedJson,
          containsPair('particleSystems', isA<Map<String, dynamic>>()),
        );
        expect(
          parsedJson,
          containsPair('objectives', isA<Map<String, dynamic>>()),
        );
      });

      test('has correct version format', () {
        final parsedJson =
            json.decode(CustomScenarioJsonSchema.example)
                as Map<String, dynamic>;
        final version = parsedJson['version'] as String;

        expect(version, matches(r'^\d+\.\d+\.\d+$')); // Semantic versioning
        expect(version, equals('1.0.0'));
      });
    });

    group('metadata section', () {
      test('contains all required metadata fields', () {
        final parsedJson =
            json.decode(CustomScenarioJsonSchema.example)
                as Map<String, dynamic>;
        final metadata = parsedJson['metadata'] as Map<String, dynamic>;

        expect(metadata, containsPair('name', isA<String>()));
        expect(metadata, containsPair('description', isA<String>()));
        expect(metadata, containsPair('author', isA<String>()));
        expect(metadata, containsPair('createdAt', isA<String>()));
        expect(metadata, containsPair('educationalFocus', isA<String>()));
        expect(metadata, containsPair('tags', isA<List<dynamic>>()));
        expect(metadata, containsPair('difficulty', isA<String>()));
      });

      test('has valid ISO 8601 timestamp', () {
        final parsedJson =
            json.decode(CustomScenarioJsonSchema.example)
                as Map<String, dynamic>;
        final metadata = parsedJson['metadata'] as Map<String, dynamic>;
        final createdAt = metadata['createdAt'] as String;

        expect(() {
          DateTime.parse(createdAt);
        }, returnsNormally);

        final parsedDate = DateTime.parse(createdAt);
        expect(parsedDate.isUtc, isTrue);
      });

      test('has meaningful metadata values', () {
        final parsedJson =
            json.decode(CustomScenarioJsonSchema.example)
                as Map<String, dynamic>;
        final metadata = parsedJson['metadata'] as Map<String, dynamic>;

        expect(metadata['name'], equals('Custom Solar System'));
        expect(metadata['description'], isNot(isEmpty));
        expect(metadata['author'], equals('John Doe'));
        expect(metadata['educationalFocus'], equals('orbital mechanics'));
        expect(metadata['difficulty'], equals('intermediate'));

        final tags = metadata['tags'] as List<dynamic>;
        expect(tags, isNotEmpty);
        expect(tags, contains('solar system'));
        expect(tags, contains('planets'));
        expect(tags, contains('education'));
      });
    });

    group('configuration section', () {
      test('contains all configuration fields', () {
        final parsedJson =
            json.decode(CustomScenarioJsonSchema.example)
                as Map<String, dynamic>;
        final configuration =
            parsedJson['configuration'] as Map<String, dynamic>;

        expect(
          configuration,
          containsPair('optimalCameraDistance', isA<num>()),
        );
        expect(
          configuration,
          containsPair('cameraDistanceMultiplier', isA<num>()),
        );
        expect(configuration, containsPair('expectedBodyCount', isA<int>()));
      });

      test('has reasonable configuration values', () {
        final parsedJson =
            json.decode(CustomScenarioJsonSchema.example)
                as Map<String, dynamic>;
        final configuration =
            parsedJson['configuration'] as Map<String, dynamic>;

        expect(configuration['optimalCameraDistance'], equals(1200.0));
        expect(configuration['cameraDistanceMultiplier'], equals(1.2));
        expect(configuration['expectedBodyCount'], equals(9));

        // Verify values are positive
        expect(configuration['optimalCameraDistance'], greaterThan(0));
        expect(configuration['cameraDistanceMultiplier'], greaterThan(0));
        expect(configuration['expectedBodyCount'], greaterThan(0));
      });
    });

    group('physics section', () {
      test('contains all physics parameters', () {
        final parsedJson =
            json.decode(CustomScenarioJsonSchema.example)
                as Map<String, dynamic>;
        final physics = parsedJson['physics'] as Map<String, dynamic>;

        expect(physics, containsPair('gravitationalConstant', isA<num>()));
        expect(physics, containsPair('softening', isA<num>()));
        expect(physics, containsPair('timeScale', isA<num>()));
        expect(physics, containsPair('collisionRadiusMultiplier', isA<num>()));
        expect(physics, containsPair('maxTrailPoints', isA<int>()));
        expect(physics, containsPair('trailFadeRate', isA<num>()));
      });

      test('has realistic physics values', () {
        final parsedJson =
            json.decode(CustomScenarioJsonSchema.example)
                as Map<String, dynamic>;
        final physics = parsedJson['physics'] as Map<String, dynamic>;

        expect(physics['gravitationalConstant'], equals(1.2));
        expect(physics['softening'], equals(0.1));
        expect(physics['timeScale'], equals(1.0));
        expect(physics['collisionRadiusMultiplier'], equals(1.0));
        expect(physics['maxTrailPoints'], equals(500));
        expect(physics['trailFadeRate'], equals(0.95));

        // Verify trail fade rate is valid (0-1 range)
        expect(physics['trailFadeRate'], greaterThanOrEqualTo(0.0));
        expect(physics['trailFadeRate'], lessThanOrEqualTo(1.0));
      });
    });

    group('bodies section', () {
      test('contains array of celestial bodies', () {
        final parsedJson =
            json.decode(CustomScenarioJsonSchema.example)
                as Map<String, dynamic>;
        final bodies = parsedJson['bodies'] as List<dynamic>;

        expect(bodies, isNotEmpty);
        expect(
          bodies.length,
          greaterThanOrEqualTo(2),
        ); // At least Sun and Earth
      });

      test('each body has required fields', () {
        final parsedJson =
            json.decode(CustomScenarioJsonSchema.example)
                as Map<String, dynamic>;
        final bodies = parsedJson['bodies'] as List<dynamic>;

        for (final body in bodies) {
          final bodyMap = body as Map<String, dynamic>;

          expect(bodyMap, containsPair('name', isA<String>()));
          expect(bodyMap, containsPair('position', isA<List<dynamic>>()));
          expect(bodyMap, containsPair('velocity', isA<List<dynamic>>()));
          expect(bodyMap, containsPair('mass', isA<num>()));
          expect(bodyMap, containsPair('radius', isA<num>()));
          expect(bodyMap, containsPair('color', isA<String>()));
          expect(bodyMap, containsPair('bodyType', isA<String>()));
          expect(bodyMap, containsPair('stellarLuminosity', isA<num>()));
          expect(bodyMap, containsPair('temperature', isA<num>()));
          expect(bodyMap, containsPair('showGravityWell', isA<bool>()));
          expect(bodyMap, containsPair('isPlanet', isA<bool>()));
          expect(bodyMap, containsPair('habitabilityStatus', isA<String>()));
        }
      });

      test('Sun has correct properties', () {
        final parsedJson =
            json.decode(CustomScenarioJsonSchema.example)
                as Map<String, dynamic>;
        final bodies = parsedJson['bodies'] as List<dynamic>;

        final sun =
            bodies.firstWhere(
                  (body) => (body as Map<String, dynamic>)['name'] == 'Sun',
                )
                as Map<String, dynamic>;

        expect(sun['name'], equals('Sun'));
        expect(sun['position'], equals([0.0, 0.0, 0.0]));
        expect(sun['velocity'], equals([0.0, 0.0, 0.0]));
        expect(sun['mass'], equals(50.0));
        expect(sun['bodyType'], equals('star'));
        expect(sun['color'], equals('#FFD700'));
        expect(sun['stellarLuminosity'], equals(1.0));
        expect(sun['temperature'], equals(5778.0));
        expect(sun['isPlanet'], isFalse);
        expect(sun['habitabilityStatus'], equals('notApplicable'));
      });

      test('Earth has correct properties', () {
        final parsedJson =
            json.decode(CustomScenarioJsonSchema.example)
                as Map<String, dynamic>;
        final bodies = parsedJson['bodies'] as List<dynamic>;

        final earth =
            bodies.firstWhere(
                  (body) => (body as Map<String, dynamic>)['name'] == 'Earth',
                )
                as Map<String, dynamic>;

        expect(earth['name'], equals('Earth'));
        expect(earth['position'], equals([200.0, 0.0, 0.0]));
        expect(earth['velocity'], equals([0.0, 10.95, 0.0]));
        expect(earth['mass'], equals(0.30));
        expect(earth['bodyType'], equals('planet'));
        expect(earth['color'], equals('#4169E1'));
        expect(earth['stellarLuminosity'], equals(0.0));
        expect(earth['temperature'], equals(288.0));
        expect(earth['isPlanet'], isTrue);
        expect(earth['habitabilityStatus'], equals('habitable'));
      });

      test('position and velocity are 3D vectors', () {
        final parsedJson =
            json.decode(CustomScenarioJsonSchema.example)
                as Map<String, dynamic>;
        final bodies = parsedJson['bodies'] as List<dynamic>;

        for (final body in bodies) {
          final bodyMap = body as Map<String, dynamic>;
          final position = bodyMap['position'] as List<dynamic>;
          final velocity = bodyMap['velocity'] as List<dynamic>;

          expect(position.length, equals(3));
          expect(velocity.length, equals(3));

          for (final coord in position) {
            expect(coord, isA<num>());
          }
          for (final vel in velocity) {
            expect(vel, isA<num>());
          }
        }
      });

      test('color values are valid hex format', () {
        final parsedJson =
            json.decode(CustomScenarioJsonSchema.example)
                as Map<String, dynamic>;
        final bodies = parsedJson['bodies'] as List<dynamic>;

        for (final body in bodies) {
          final bodyMap = body as Map<String, dynamic>;
          final color = bodyMap['color'] as String;

          expect(color, matches(r'^#[0-9A-Fa-f]{6}$'));
        }
      });
    });

    group('particle systems section', () {
      test('contains asteroid belt and Kuiper belt configurations', () {
        final parsedJson =
            json.decode(CustomScenarioJsonSchema.example)
                as Map<String, dynamic>;
        final particleSystems =
            parsedJson['particleSystems'] as Map<String, dynamic>;

        expect(
          particleSystems,
          containsPair('asteroidBelt', isA<Map<String, dynamic>>()),
        );
        expect(
          particleSystems,
          containsPair('kuiperBelt', isA<Map<String, dynamic>>()),
        );
      });

      test('particle systems have all required fields', () {
        final parsedJson =
            json.decode(CustomScenarioJsonSchema.example)
                as Map<String, dynamic>;
        final particleSystems =
            parsedJson['particleSystems'] as Map<String, dynamic>;

        for (final systemName in ['asteroidBelt', 'kuiperBelt']) {
          final system = particleSystems[systemName] as Map<String, dynamic>;

          expect(system, containsPair('enabled', isA<bool>()));
          expect(system, containsPair('innerRadius', isA<num>()));
          expect(system, containsPair('outerRadius', isA<num>()));
          expect(system, containsPair('particleCount', isA<int>()));
          expect(system, containsPair('centralMass', isA<num>()));
          expect(system, containsPair('gravitationalConstant', isA<num>()));
          expect(system, containsPair('baseColor', isA<String>()));
          expect(system, containsPair('colorVariation', isA<num>()));
          expect(system, containsPair('useXZPlane', isA<bool>()));
          expect(system, containsPair('minSize', isA<num>()));
          expect(system, containsPair('maxSize', isA<num>()));
        }
      });

      test('asteroid belt has appropriate values', () {
        final parsedJson =
            json.decode(CustomScenarioJsonSchema.example)
                as Map<String, dynamic>;
        final particleSystems =
            parsedJson['particleSystems'] as Map<String, dynamic>;
        final asteroidBelt =
            particleSystems['asteroidBelt'] as Map<String, dynamic>;

        expect(asteroidBelt['enabled'], isFalse);
        expect(asteroidBelt['innerRadius'], equals(110.0));
        expect(asteroidBelt['outerRadius'], equals(200.0));
        expect(asteroidBelt['particleCount'], equals(3000));
        expect(asteroidBelt['baseColor'], equals('#8B4513'));
        expect(asteroidBelt['useXZPlane'], isFalse);

        // Verify outer > inner radius
        expect(
          asteroidBelt['outerRadius'],
          greaterThan(asteroidBelt['innerRadius']),
        );
      });

      test('Kuiper belt has appropriate values', () {
        final parsedJson =
            json.decode(CustomScenarioJsonSchema.example)
                as Map<String, dynamic>;
        final particleSystems =
            parsedJson['particleSystems'] as Map<String, dynamic>;
        final kuiperBelt =
            particleSystems['kuiperBelt'] as Map<String, dynamic>;

        expect(kuiperBelt['enabled'], isFalse);
        expect(kuiperBelt['innerRadius'], equals(400.0));
        expect(kuiperBelt['outerRadius'], equals(600.0));
        expect(kuiperBelt['particleCount'], equals(1000));
        expect(kuiperBelt['baseColor'], equals('#87CEEB'));
        expect(kuiperBelt['useXZPlane'], isTrue);

        // Verify outer > inner radius
        expect(
          kuiperBelt['outerRadius'],
          greaterThan(kuiperBelt['innerRadius']),
        );
      });
    });

    group('objectives section', () {
      test('contains all objective fields', () {
        final parsedJson =
            json.decode(CustomScenarioJsonSchema.example)
                as Map<String, dynamic>;
        final objectives = parsedJson['objectives'] as Map<String, dynamic>;

        expect(objectives, containsPair('enabled', isA<bool>()));
        expect(objectives, containsPair('primary', isA<String>()));
        expect(objectives, containsPair('secondary', isA<String>()));
        expect(objectives, containsPair('timeLimit', isA<int>()));
        expect(
          objectives,
          containsPair('successCriteria', isA<Map<String, dynamic>>()),
        );
        expect(
          objectives,
          containsPair('chaosEvents', isA<Map<String, dynamic>>()),
        );
      });

      test('success criteria has required fields', () {
        final parsedJson =
            json.decode(CustomScenarioJsonSchema.example)
                as Map<String, dynamic>;
        final objectives = parsedJson['objectives'] as Map<String, dynamic>;
        final successCriteria =
            objectives['successCriteria'] as Map<String, dynamic>;

        expect(successCriteria, containsPair('stabilityThreshold', isA<num>()));
        expect(successCriteria, containsPair('minimumTime', isA<int>()));
        expect(successCriteria, containsPair('allowedCollisions', isA<int>()));

        expect(successCriteria['stabilityThreshold'], equals(0.1));
        expect(successCriteria['minimumTime'], equals(60));
        expect(successCriteria['allowedCollisions'], equals(0));
      });

      test('chaos events has required fields', () {
        final parsedJson =
            json.decode(CustomScenarioJsonSchema.example)
                as Map<String, dynamic>;
        final objectives = parsedJson['objectives'] as Map<String, dynamic>;
        final chaosEvents = objectives['chaosEvents'] as Map<String, dynamic>;

        expect(chaosEvents, containsPair('enabled', isA<bool>()));
        expect(chaosEvents, containsPair('frequency', isA<int>()));
        expect(chaosEvents, containsPair('types', isA<List<dynamic>>()));

        expect(chaosEvents['enabled'], isFalse);
        expect(chaosEvents['frequency'], equals(30));

        final types = chaosEvents['types'] as List<dynamic>;
        expect(types, contains('asteroid'));
        expect(types, contains('gravity_wave'));
        expect(types, contains('solar_flare'));
      });
    });

    group('schema consistency', () {
      test('schema is internally consistent', () {
        final parsedJson =
            json.decode(CustomScenarioJsonSchema.example)
                as Map<String, dynamic>;

        // Expected body count should match actual bodies
        final configuration =
            parsedJson['configuration'] as Map<String, dynamic>;
        final bodies = parsedJson['bodies'] as List<dynamic>;

        // Note: This is a loose check since particle systems add virtual bodies
        expect(
          bodies.length,
          lessThanOrEqualTo(configuration['expectedBodyCount'] as int),
        );

        // Physics constants should be consistent between main physics and particle systems
        final physics = parsedJson['physics'] as Map<String, dynamic>;
        final particleSystems =
            parsedJson['particleSystems'] as Map<String, dynamic>;

        for (final systemName in ['asteroidBelt', 'kuiperBelt']) {
          final system = particleSystems[systemName] as Map<String, dynamic>;
          expect(
            system['gravitationalConstant'],
            equals(physics['gravitationalConstant']),
          );
        }
      });

      test('all required sections are present and complete', () {
        final parsedJson =
            json.decode(CustomScenarioJsonSchema.example)
                as Map<String, dynamic>;

        // Verify no null values in critical sections
        expect(parsedJson['version'], isNotNull);
        expect(parsedJson['metadata'], isNotNull);
        expect(parsedJson['configuration'], isNotNull);
        expect(parsedJson['physics'], isNotNull);
        expect(parsedJson['bodies'], isNotNull);
        expect(parsedJson['particleSystems'], isNotNull);
        expect(parsedJson['objectives'], isNotNull);
      });

      test('example represents a valid simulation scenario', () {
        final parsedJson =
            json.decode(CustomScenarioJsonSchema.example)
                as Map<String, dynamic>;
        final bodies = parsedJson['bodies'] as List<dynamic>;

        // Should have at least one star
        final stars = bodies
            .where(
              (body) => (body as Map<String, dynamic>)['bodyType'] == 'star',
            )
            .toList();
        expect(stars, isNotEmpty);

        // Should have at least one planet
        final planets = bodies
            .where((body) => (body as Map<String, dynamic>)['isPlanet'] == true)
            .toList();
        expect(planets, isNotEmpty);

        // All masses should be positive
        for (final body in bodies) {
          final mass = (body as Map<String, dynamic>)['mass'] as num;
          expect(mass, greaterThan(0));
        }
      });
    });

    group('JSON format validation', () {
      test('example string is properly formatted', () {
        final exampleString = CustomScenarioJsonSchema.example;

        // Should not have any syntax errors
        expect(() => json.decode(exampleString), returnsNormally);

        // Should be properly indented (contains newlines and spaces)
        expect(exampleString, contains('\n'));
        expect(exampleString, contains('  ')); // Indentation
      });

      test('can be used as template for new scenarios', () {
        final templateJson =
            json.decode(CustomScenarioJsonSchema.example)
                as Map<String, dynamic>;

        // Modify metadata for a new scenario
        final metadata = templateJson['metadata'] as Map<String, dynamic>;
        metadata['name'] = 'Test Custom Scenario';
        metadata['author'] = 'Test Author';
        metadata['description'] = 'A test scenario based on the template';

        // Should still be valid JSON after modification
        expect(() => json.encode(templateJson), returnsNormally);

        final modifiedJsonString = json.encode(templateJson);
        expect(modifiedJsonString, contains('Test Custom Scenario'));
        expect(modifiedJsonString, contains('Test Author'));
      });
    });
  });
}
