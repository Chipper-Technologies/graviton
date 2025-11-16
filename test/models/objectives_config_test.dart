import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/models/objectives_config.dart';
import 'package:graviton/models/success_criteria.dart';
import 'package:graviton/models/chaos_events.dart';

void main() {
  group('ObjectivesConfig', () {
    group('constructor and properties', () {
      test('creates objectives config with required parameters only', () {
        const objectivesConfig = ObjectivesConfig(
          enabled: true,
          primary: 'Maintain stable orbits',
        );

        expect(objectivesConfig.enabled, isTrue);
        expect(objectivesConfig.primary, equals('Maintain stable orbits'));
        expect(objectivesConfig.secondary, isNull);
        expect(objectivesConfig.timeLimit, isNull);
        expect(objectivesConfig.successCriteria, isNull);
        expect(objectivesConfig.chaosEvents, isNull);
      });

      test('creates objectives config with all parameters', () {
        const successCriteria = SuccessCriteria(
          stabilityThreshold: 0.1,
          minimumTime: 60,
          allowedCollisions: 0,
        );

        const chaosEvents = ChaosEvents(
          enabled: true,
          frequency: 25,
          types: ['collision', 'gravity_wave'],
        );

        const objectivesConfig = ObjectivesConfig(
          enabled: true,
          primary: 'Complete orbital simulation',
          secondary: 'Observe gravitational effects',
          timeLimit: 300,
          successCriteria: successCriteria,
          chaosEvents: chaosEvents,
        );

        expect(objectivesConfig.enabled, isTrue);
        expect(objectivesConfig.primary, equals('Complete orbital simulation'));
        expect(
          objectivesConfig.secondary,
          equals('Observe gravitational effects'),
        );
        expect(objectivesConfig.timeLimit, equals(300));
        expect(objectivesConfig.successCriteria, equals(successCriteria));
        expect(objectivesConfig.chaosEvents, equals(chaosEvents));
      });

      test('creates disabled objectives config', () {
        const objectivesConfig = ObjectivesConfig(enabled: false, primary: '');

        expect(objectivesConfig.enabled, isFalse);
        expect(objectivesConfig.primary, equals(''));
        expect(objectivesConfig.secondary, isNull);
        expect(objectivesConfig.timeLimit, isNull);
        expect(objectivesConfig.successCriteria, isNull);
        expect(objectivesConfig.chaosEvents, isNull);
      });

      test('handles complex objective descriptions', () {
        const complexObjectives = ObjectivesConfig(
          enabled: true,
          primary:
              'Demonstrate three-body orbital mechanics with Lagrange point stability',
          secondary:
              'Analyze chaotic behavior in gravitational systems under perturbation',
          timeLimit: 1800, // 30 minutes
        );

        expect(complexObjectives.primary.length, greaterThan(50));
        expect(complexObjectives.secondary!.length, greaterThan(50));
        expect(complexObjectives.timeLimit, equals(1800));
      });
    });

    group('fromJson factory constructor', () {
      test('creates from minimal JSON', () {
        final json = {'enabled': true, 'primary': 'Basic objective'};

        final objectivesConfig = ObjectivesConfig.fromJson(json);

        expect(objectivesConfig.enabled, isTrue);
        expect(objectivesConfig.primary, equals('Basic objective'));
        expect(objectivesConfig.secondary, isNull);
        expect(objectivesConfig.timeLimit, isNull);
        expect(objectivesConfig.successCriteria, isNull);
        expect(objectivesConfig.chaosEvents, isNull);
      });

      test('creates from complete JSON', () {
        final json = {
          'enabled': true,
          'primary': 'Primary objective',
          'secondary': 'Secondary objective',
          'timeLimit': 600,
          'successCriteria': {
            'stabilityThreshold': 0.2,
            'minimumTime': 120,
            'allowedCollisions': 1,
          },
          'chaosEvents': {
            'enabled': false,
            'frequency': 15,
            'types': ['asteroid', 'solar_flare'],
          },
        };

        final objectivesConfig = ObjectivesConfig.fromJson(json);

        expect(objectivesConfig.enabled, isTrue);
        expect(objectivesConfig.primary, equals('Primary objective'));
        expect(objectivesConfig.secondary, equals('Secondary objective'));
        expect(objectivesConfig.timeLimit, equals(600));

        expect(objectivesConfig.successCriteria, isNotNull);
        expect(
          objectivesConfig.successCriteria!.stabilityThreshold,
          equals(0.2),
        );
        expect(objectivesConfig.successCriteria!.minimumTime, equals(120));
        expect(objectivesConfig.successCriteria!.allowedCollisions, equals(1));

        expect(objectivesConfig.chaosEvents, isNotNull);
        expect(objectivesConfig.chaosEvents!.enabled, isFalse);
        expect(objectivesConfig.chaosEvents!.frequency, equals(15));
        expect(
          objectivesConfig.chaosEvents!.types,
          equals(['asteroid', 'solar_flare']),
        );
      });

      test('creates from JSON with disabled state', () {
        final json = {'enabled': false, 'primary': 'Disabled objective'};

        final objectivesConfig = ObjectivesConfig.fromJson(json);

        expect(objectivesConfig.enabled, isFalse);
        expect(objectivesConfig.primary, equals('Disabled objective'));
      });

      test('handles null optional fields in JSON', () {
        final json = {
          'enabled': true,
          'primary': 'Main objective',
          'secondary': null,
          'timeLimit': null,
          'successCriteria': null,
          'chaosEvents': null,
        };

        final objectivesConfig = ObjectivesConfig.fromJson(json);

        expect(objectivesConfig.enabled, isTrue);
        expect(objectivesConfig.primary, equals('Main objective'));
        expect(objectivesConfig.secondary, isNull);
        expect(objectivesConfig.timeLimit, isNull);
        expect(objectivesConfig.successCriteria, isNull);
        expect(objectivesConfig.chaosEvents, isNull);
      });

      test('creates success criteria from nested JSON', () {
        final json = {
          'enabled': true,
          'primary': 'Test objective',
          'successCriteria': {
            'stabilityThreshold': 0.05,
            'minimumTime': 180,
            'allowedCollisions': 2,
          },
        };

        final objectivesConfig = ObjectivesConfig.fromJson(json);

        expect(objectivesConfig.successCriteria, isNotNull);
        expect(
          objectivesConfig.successCriteria!.stabilityThreshold,
          equals(0.05),
        );
        expect(objectivesConfig.successCriteria!.minimumTime, equals(180));
        expect(objectivesConfig.successCriteria!.allowedCollisions, equals(2));
      });

      test('creates chaos events from nested JSON', () {
        final json = {
          'enabled': true,
          'primary': 'Chaos test',
          'chaosEvents': {
            'enabled': true,
            'frequency': 50,
            'types': ['gravitational_anomaly', 'supernova', 'black_hole'],
          },
        };

        final objectivesConfig = ObjectivesConfig.fromJson(json);

        expect(objectivesConfig.chaosEvents, isNotNull);
        expect(objectivesConfig.chaosEvents!.enabled, isTrue);
        expect(objectivesConfig.chaosEvents!.frequency, equals(50));
        expect(
          objectivesConfig.chaosEvents!.types,
          equals(['gravitational_anomaly', 'supernova', 'black_hole']),
        );
      });
    });

    group('toJson method', () {
      test('converts minimal config to JSON', () {
        const objectivesConfig = ObjectivesConfig(
          enabled: true,
          primary: 'Simple objective',
        );

        final json = objectivesConfig.toJson();

        expect(json['enabled'], isTrue);
        expect(json['primary'], equals('Simple objective'));
        expect(json.keys, hasLength(2));
        expect(json.containsKey('secondary'), isFalse);
        expect(json.containsKey('timeLimit'), isFalse);
        expect(json.containsKey('successCriteria'), isFalse);
        expect(json.containsKey('chaosEvents'), isFalse);
      });

      test('converts complete config to JSON', () {
        const successCriteria = SuccessCriteria(
          stabilityThreshold: 0.15,
          minimumTime: 90,
          allowedCollisions: 1,
        );

        const chaosEvents = ChaosEvents(
          enabled: true,
          frequency: 35,
          types: ['collision', 'explosion'],
        );

        const objectivesConfig = ObjectivesConfig(
          enabled: true,
          primary: 'Complete test',
          secondary: 'Secondary goal',
          timeLimit: 450,
          successCriteria: successCriteria,
          chaosEvents: chaosEvents,
        );

        final json = objectivesConfig.toJson();

        expect(json['enabled'], isTrue);
        expect(json['primary'], equals('Complete test'));
        expect(json['secondary'], equals('Secondary goal'));
        expect(json['timeLimit'], equals(450));
        expect(json['successCriteria'], isA<Map<String, dynamic>>());
        expect(json['chaosEvents'], isA<Map<String, dynamic>>());

        // Verify nested objects are correctly serialized
        final successJson = json['successCriteria'] as Map<String, dynamic>;
        expect(successJson['stabilityThreshold'], equals(0.15));
        expect(successJson['minimumTime'], equals(90));
        expect(successJson['allowedCollisions'], equals(1));

        final chaosJson = json['chaosEvents'] as Map<String, dynamic>;
        expect(chaosJson['enabled'], isTrue);
        expect(chaosJson['frequency'], equals(35));
        expect(chaosJson['types'], equals(['collision', 'explosion']));
      });

      test('omits null optional fields', () {
        const objectivesConfig = ObjectivesConfig(
          enabled: false,
          primary: 'Test with nulls',
          secondary: null,
          timeLimit: null,
          successCriteria: null,
          chaosEvents: null,
        );

        final json = objectivesConfig.toJson();

        expect(json['enabled'], isFalse);
        expect(json['primary'], equals('Test with nulls'));
        expect(json.containsKey('secondary'), isFalse);
        expect(json.containsKey('timeLimit'), isFalse);
        expect(json.containsKey('successCriteria'), isFalse);
        expect(json.containsKey('chaosEvents'), isFalse);
      });

      test('includes only non-null optional fields', () {
        const objectivesConfig = ObjectivesConfig(
          enabled: true,
          primary: 'Partial config',
          secondary: 'Secondary objective',
          timeLimit: null, // This should be omitted
          successCriteria: null, // This should be omitted
        );

        final json = objectivesConfig.toJson();

        expect(json.containsKey('secondary'), isTrue);
        expect(json['secondary'], equals('Secondary objective'));
        expect(json.containsKey('timeLimit'), isFalse);
        expect(json.containsKey('successCriteria'), isFalse);
        expect(json.containsKey('chaosEvents'), isFalse);
      });
    });

    group('round-trip serialization', () {
      test('maintains data integrity for minimal config', () {
        const original = ObjectivesConfig(
          enabled: true,
          primary: 'Round trip test',
        );

        final json = original.toJson();
        final reconstructed = ObjectivesConfig.fromJson(json);

        expect(reconstructed.enabled, equals(original.enabled));
        expect(reconstructed.primary, equals(original.primary));
        expect(reconstructed.secondary, equals(original.secondary));
        expect(reconstructed.timeLimit, equals(original.timeLimit));
        expect(reconstructed.successCriteria, equals(original.successCriteria));
        expect(reconstructed.chaosEvents, equals(original.chaosEvents));
      });

      test('maintains data integrity for complete config', () {
        const successCriteria = SuccessCriteria(
          stabilityThreshold: 0.08,
          minimumTime: 150,
          allowedCollisions: 0,
        );

        const chaosEvents = ChaosEvents(
          enabled: false,
          frequency: 20,
          types: ['meteor_shower', 'solar_storm'],
        );

        const original = ObjectivesConfig(
          enabled: true,
          primary: 'Complex round trip test',
          secondary: 'Verify all nested objects',
          timeLimit: 720,
          successCriteria: successCriteria,
          chaosEvents: chaosEvents,
        );

        final json = original.toJson();
        final reconstructed = ObjectivesConfig.fromJson(json);

        expect(reconstructed.enabled, equals(original.enabled));
        expect(reconstructed.primary, equals(original.primary));
        expect(reconstructed.secondary, equals(original.secondary));
        expect(reconstructed.timeLimit, equals(original.timeLimit));

        expect(reconstructed.successCriteria, isNotNull);
        expect(
          reconstructed.successCriteria!.stabilityThreshold,
          equals(original.successCriteria!.stabilityThreshold),
        );
        expect(
          reconstructed.successCriteria!.minimumTime,
          equals(original.successCriteria!.minimumTime),
        );
        expect(
          reconstructed.successCriteria!.allowedCollisions,
          equals(original.successCriteria!.allowedCollisions),
        );

        expect(reconstructed.chaosEvents, isNotNull);
        expect(
          reconstructed.chaosEvents!.enabled,
          equals(original.chaosEvents!.enabled),
        );
        expect(
          reconstructed.chaosEvents!.frequency,
          equals(original.chaosEvents!.frequency),
        );
        expect(
          reconstructed.chaosEvents!.types,
          equals(original.chaosEvents!.types),
        );
      });

      test('preserves disabled state', () {
        const original = ObjectivesConfig(
          enabled: false,
          primary: 'Disabled objective test',
        );

        final json = original.toJson();
        final reconstructed = ObjectivesConfig.fromJson(json);

        expect(reconstructed.enabled, isFalse);
        expect(reconstructed.primary, equals(original.primary));
      });
    });

    group('realistic objective scenarios', () {
      test('educational orbital mechanics scenario', () {
        const educationalObjectives = ObjectivesConfig(
          enabled: true,
          primary: 'Demonstrate Kepler\'s laws of planetary motion',
          secondary:
              'Observe how orbital period relates to distance from central body',
          timeLimit: 600, // 10 minutes
          successCriteria: SuccessCriteria(
            stabilityThreshold: 0.05, // Low threshold for educational stability
            minimumTime: 300, // 5 minutes minimum observation
            allowedCollisions: 0, // No collisions for clean demonstration
          ),
        );

        expect(educationalObjectives.enabled, isTrue);
        expect(educationalObjectives.primary, contains('Kepler'));
        expect(educationalObjectives.secondary, contains('orbital period'));
        expect(educationalObjectives.timeLimit, equals(600));
        expect(
          educationalObjectives.successCriteria!.allowedCollisions,
          equals(0),
        );
      });

      test('chaotic three-body problem scenario', () {
        const chaoticObjectives = ObjectivesConfig(
          enabled: true,
          primary:
              'Observe chaotic behavior in three-body gravitational system',
          secondary: 'Document sensitivity to initial conditions',
          timeLimit: 1200, // 20 minutes
          successCriteria: SuccessCriteria(
            stabilityThreshold: 0.5, // Higher threshold allows for chaos
            minimumTime: 180,
            allowedCollisions: 2, // Some collisions acceptable in chaos
          ),
          chaosEvents: ChaosEvents(
            enabled: true,
            frequency: 40,
            types: [
              'gravitational_perturbation',
              'small_body_injection',
              'orbital_resonance_disruption',
            ],
          ),
        );

        expect(chaoticObjectives.primary, contains('chaotic'));
        expect(
          chaoticObjectives.successCriteria!.stabilityThreshold,
          equals(0.5),
        );
        expect(chaoticObjectives.chaosEvents!.enabled, isTrue);
        expect(chaoticObjectives.chaosEvents!.types, hasLength(3));
      });

      test('solar system formation scenario', () {
        const formationObjectives = ObjectivesConfig(
          enabled: true,
          primary: 'Simulate early solar system formation and accretion',
          secondary: 'Observe planetary migration and resonance capture',
          timeLimit: 1800, // 30 minutes for long-term evolution
          successCriteria: SuccessCriteria(
            stabilityThreshold: 0.2, // Moderate threshold for dynamic system
            minimumTime: 600, // 10 minutes minimum
            allowedCollisions:
                5, // Multiple collisions expected during formation
          ),
          chaosEvents: ChaosEvents(
            enabled: true,
            frequency: 25,
            types: [
              'planetesimal_collision',
              'gas_giant_migration',
              'asteroid_bombardment',
            ],
          ),
        );

        expect(formationObjectives.primary, contains('formation'));
        expect(formationObjectives.timeLimit, equals(1800));
        expect(
          formationObjectives.successCriteria!.allowedCollisions,
          equals(5),
        );
        expect(
          formationObjectives.chaosEvents!.types,
          contains('gas_giant_migration'),
        );
      });

      test('binary star system scenario', () {
        const binaryObjectives = ObjectivesConfig(
          enabled: true,
          primary: 'Maintain stable binary star orbit with circumbinary planet',
          secondary: 'Demonstrate S-type and P-type planetary orbits',
          timeLimit: 900, // 15 minutes
          successCriteria: SuccessCriteria(
            stabilityThreshold: 0.1,
            minimumTime: 450, // 7.5 minutes
            allowedCollisions: 0, // Stable system should avoid collisions
          ),
          chaosEvents: ChaosEvents(
            enabled: false, // Stable demonstration
            frequency: 0,
            types: [],
          ),
        );

        expect(binaryObjectives.primary, contains('binary star'));
        expect(binaryObjectives.secondary, contains('S-type'));
        expect(binaryObjectives.successCriteria!.allowedCollisions, equals(0));
        expect(binaryObjectives.chaosEvents!.enabled, isFalse);
      });

      test('asteroid belt disruption scenario', () {
        const asteroidObjectives = ObjectivesConfig(
          enabled: true,
          primary:
              'Study asteroid belt dynamics under Jupiter\'s gravitational influence',
          secondary: 'Identify Kirkwood gaps and resonance effects',
          timeLimit: 2400, // 40 minutes for long-term effects
          successCriteria: SuccessCriteria(
            stabilityThreshold: 0.3, // Allow for asteroid scattering
            minimumTime: 1200, // 20 minutes observation
            allowedCollisions: 10, // Many collisions expected
          ),
          chaosEvents: ChaosEvents(
            enabled: true,
            frequency: 60,
            types: [
              'asteroid_collision',
              'jupiter_perturbation',
              'resonance_capture',
              'trojan_formation',
            ],
          ),
        );

        expect(asteroidObjectives.primary, contains('asteroid belt'));
        expect(asteroidObjectives.secondary, contains('Kirkwood gaps'));
        expect(
          asteroidObjectives.successCriteria!.allowedCollisions,
          equals(10),
        );
        expect(asteroidObjectives.chaosEvents!.frequency, equals(60));
      });

      test('disabled objectives for free exploration', () {
        const freeExploration = ObjectivesConfig(
          enabled: false,
          primary: 'Free exploration mode - no specific objectives',
        );

        expect(freeExploration.enabled, isFalse);
        expect(freeExploration.primary, contains('Free exploration'));
        expect(freeExploration.secondary, isNull);
        expect(freeExploration.timeLimit, isNull);
        expect(freeExploration.successCriteria, isNull);
        expect(freeExploration.chaosEvents, isNull);
      });
    });

    group('edge cases and validation', () {
      test('handles empty objective strings', () {
        const emptyObjectives = ObjectivesConfig(
          enabled: true,
          primary: '',
          secondary: '',
        );

        expect(emptyObjectives.primary, equals(''));
        expect(emptyObjectives.secondary, equals(''));
      });

      test('handles very long objective descriptions', () {
        final longDescription = 'A' * 1000; // 1000 character string

        final longObjectives = ObjectivesConfig(
          enabled: true,
          primary: longDescription,
          secondary: longDescription,
        );

        expect(longObjectives.primary.length, equals(1000));
        expect(longObjectives.secondary!.length, equals(1000));
      });

      test('handles extreme time limits', () {
        const shortTimeLimit = ObjectivesConfig(
          enabled: true,
          primary: 'Quick test',
          timeLimit: 1, // 1 second
        );

        const longTimeLimit = ObjectivesConfig(
          enabled: true,
          primary: 'Long test',
          timeLimit: 86400, // 24 hours
        );

        expect(shortTimeLimit.timeLimit, equals(1));
        expect(longTimeLimit.timeLimit, equals(86400));
      });

      test('handles zero time limit', () {
        const zeroTimeLimit = ObjectivesConfig(
          enabled: true,
          primary: 'No time limit',
          timeLimit: 0,
        );

        expect(zeroTimeLimit.timeLimit, equals(0));
      });

      test('handles complex nested object combinations', () {
        final complexConfig = ObjectivesConfig(
          enabled: true,
          primary: 'Complex scenario',
          successCriteria: const SuccessCriteria(
            stabilityThreshold: 0.001, // Very strict
            minimumTime: 3600, // 1 hour
            allowedCollisions: 999, // Many collisions allowed
          ),
          chaosEvents: ChaosEvents(
            enabled: true,
            frequency: 100, // Maximum chaos
            types: List.generate(20, (i) => 'chaos_type_$i'), // Many types
          ),
        );

        expect(
          complexConfig.successCriteria!.stabilityThreshold,
          equals(0.001),
        );
        expect(complexConfig.successCriteria!.minimumTime, equals(3600));
        expect(complexConfig.chaosEvents!.frequency, equals(100));
        expect(complexConfig.chaosEvents!.types.length, equals(20));
      });
    });
  });
}
