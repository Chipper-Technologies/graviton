import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/models/chaos_events.dart';

void main() {
  group('ChaosEvents', () {
    group('constructor and properties', () {
      test('creates chaos events with required parameters', () {
        const chaosEvents = ChaosEvents(
          enabled: true,
          frequency: 50,
          types: ['collision', 'gravitational_anomaly'],
        );

        expect(chaosEvents.enabled, isTrue);
        expect(chaosEvents.frequency, equals(50));
        expect(
          chaosEvents.types,
          equals(['collision', 'gravitational_anomaly']),
        );
      });

      test('creates chaos events with disabled state', () {
        const chaosEvents = ChaosEvents(
          enabled: false,
          frequency: 0,
          types: [],
        );

        expect(chaosEvents.enabled, isFalse);
        expect(chaosEvents.frequency, equals(0));
        expect(chaosEvents.types, isEmpty);
      });

      test('creates chaos events with single event type', () {
        const chaosEvents = ChaosEvents(
          enabled: true,
          frequency: 25,
          types: ['supernova'],
        );

        expect(chaosEvents.enabled, isTrue);
        expect(chaosEvents.frequency, equals(25));
        expect(chaosEvents.types, hasLength(1));
        expect(chaosEvents.types.first, equals('supernova'));
      });

      test('creates chaos events with multiple event types', () {
        const chaosEvents = ChaosEvents(
          enabled: true,
          frequency: 75,
          types: [
            'collision',
            'gravitational_anomaly',
            'stellar_explosion',
            'black_hole_formation',
            'wormhole',
          ],
        );

        expect(chaosEvents.types, hasLength(5));
        expect(chaosEvents.types, contains('collision'));
        expect(chaosEvents.types, contains('gravitational_anomaly'));
        expect(chaosEvents.types, contains('stellar_explosion'));
        expect(chaosEvents.types, contains('black_hole_formation'));
        expect(chaosEvents.types, contains('wormhole'));
      });

      test('handles extreme frequency values', () {
        const lowFrequency = ChaosEvents(
          enabled: true,
          frequency: 1,
          types: ['rare_event'],
        );

        const highFrequency = ChaosEvents(
          enabled: true,
          frequency: 1000,
          types: ['common_event'],
        );

        expect(lowFrequency.frequency, equals(1));
        expect(highFrequency.frequency, equals(1000));
      });
    });

    group('fromJson factory constructor', () {
      test('creates from complete JSON map', () {
        final json = {
          'enabled': true,
          'frequency': 30,
          'types': ['collision', 'explosion', 'anomaly'],
        };

        final chaosEvents = ChaosEvents.fromJson(json);

        expect(chaosEvents.enabled, isTrue);
        expect(chaosEvents.frequency, equals(30));
        expect(
          chaosEvents.types,
          equals(['collision', 'explosion', 'anomaly']),
        );
      });

      test('creates from JSON with disabled state', () {
        final json = {'enabled': false, 'frequency': 0, 'types': <String>[]};

        final chaosEvents = ChaosEvents.fromJson(json);

        expect(chaosEvents.enabled, isFalse);
        expect(chaosEvents.frequency, equals(0));
        expect(chaosEvents.types, isEmpty);
      });

      test('creates from JSON with empty types list', () {
        final json = {'enabled': true, 'frequency': 25, 'types': <String>[]};

        final chaosEvents = ChaosEvents.fromJson(json);

        expect(chaosEvents.enabled, isTrue);
        expect(chaosEvents.frequency, equals(25));
        expect(chaosEvents.types, isEmpty);
      });

      test('creates from JSON with single type', () {
        final json = {
          'enabled': true,
          'frequency': 15,
          'types': ['gravitational_wave'],
        };

        final chaosEvents = ChaosEvents.fromJson(json);

        expect(chaosEvents.types, hasLength(1));
        expect(chaosEvents.types.first, equals('gravitational_wave'));
      });

      test('creates from JSON with complex event types', () {
        final json = {
          'enabled': true,
          'frequency': 42,
          'types': [
            'three_body_instability',
            'rogue_planet_insertion',
            'stellar_collision',
            'galactic_merger',
            'dark_matter_interaction',
          ],
        };

        final chaosEvents = ChaosEvents.fromJson(json);

        expect(chaosEvents.types, hasLength(5));
        expect(chaosEvents.types, contains('three_body_instability'));
        expect(chaosEvents.types, contains('rogue_planet_insertion'));
        expect(chaosEvents.types, contains('stellar_collision'));
        expect(chaosEvents.types, contains('galactic_merger'));
        expect(chaosEvents.types, contains('dark_matter_interaction'));
      });

      test('handles various data types in JSON', () {
        final json = {
          'enabled': true,
          'frequency': 100,
          'types': [
            'event_with_underscores',
            'event-with-dashes',
            'EventWithCamelCase',
            'event with spaces',
            '123_numeric_event',
          ],
        };

        final chaosEvents = ChaosEvents.fromJson(json);

        expect(chaosEvents.types, contains('event_with_underscores'));
        expect(chaosEvents.types, contains('event-with-dashes'));
        expect(chaosEvents.types, contains('EventWithCamelCase'));
        expect(chaosEvents.types, contains('event with spaces'));
        expect(chaosEvents.types, contains('123_numeric_event'));
      });
    });

    group('toJson method', () {
      test('converts to JSON correctly', () {
        const chaosEvents = ChaosEvents(
          enabled: true,
          frequency: 60,
          types: ['collision', 'supernova'],
        );

        final json = chaosEvents.toJson();

        expect(json['enabled'], isTrue);
        expect(json['frequency'], equals(60));
        expect(json['types'], equals(['collision', 'supernova']));
      });

      test('converts disabled state to JSON', () {
        const chaosEvents = ChaosEvents(
          enabled: false,
          frequency: 0,
          types: [],
        );

        final json = chaosEvents.toJson();

        expect(json['enabled'], isFalse);
        expect(json['frequency'], equals(0));
        expect(json['types'], isEmpty);
      });

      test('converts empty types to JSON', () {
        const chaosEvents = ChaosEvents(
          enabled: true,
          frequency: 10,
          types: [],
        );

        final json = chaosEvents.toJson();

        expect(json['enabled'], isTrue);
        expect(json['frequency'], equals(10));
        expect(json['types'], isEmpty);
        expect(json['types'], isA<List<String>>());
      });

      test('returns map with correct keys', () {
        const chaosEvents = ChaosEvents(
          enabled: false,
          frequency: 5,
          types: ['test'],
        );

        final json = chaosEvents.toJson();

        expect(json.keys, containsAll(['enabled', 'frequency', 'types']));
        expect(json.keys.length, equals(3));
      });

      test('handles complex event types in JSON output', () {
        const chaosEvents = ChaosEvents(
          enabled: true,
          frequency: 88,
          types: [
            'quantum_fluctuation',
            'temporal_anomaly',
            'dimensional_rift',
            'cosmic_ray_burst',
          ],
        );

        final json = chaosEvents.toJson();

        expect(json['types'], isA<List<String>>());
        expect(json['types'], hasLength(4));
        expect(json['types'], contains('quantum_fluctuation'));
        expect(json['types'], contains('temporal_anomaly'));
        expect(json['types'], contains('dimensional_rift'));
        expect(json['types'], contains('cosmic_ray_burst'));
      });
    });

    group('round-trip serialization', () {
      test('maintains data integrity through fromJson/toJson cycle', () {
        const originalChaosEvents = ChaosEvents(
          enabled: true,
          frequency: 45,
          types: [
            'gravitational_wave',
            'neutron_star_merger',
            'gamma_ray_burst',
          ],
        );

        final json = originalChaosEvents.toJson();
        final reconstructedChaosEvents = ChaosEvents.fromJson(json);

        expect(
          reconstructedChaosEvents.enabled,
          equals(originalChaosEvents.enabled),
        );
        expect(
          reconstructedChaosEvents.frequency,
          equals(originalChaosEvents.frequency),
        );
        expect(
          reconstructedChaosEvents.types,
          equals(originalChaosEvents.types),
        );
      });

      test('handles disabled state in round-trip', () {
        const originalChaosEvents = ChaosEvents(
          enabled: false,
          frequency: 0,
          types: [],
        );

        final json = originalChaosEvents.toJson();
        final reconstructedChaosEvents = ChaosEvents.fromJson(json);

        expect(
          reconstructedChaosEvents.enabled,
          equals(originalChaosEvents.enabled),
        );
        expect(
          reconstructedChaosEvents.frequency,
          equals(originalChaosEvents.frequency),
        );
        expect(
          reconstructedChaosEvents.types,
          equals(originalChaosEvents.types),
        );
      });

      test('preserves order of event types', () {
        const originalChaosEvents = ChaosEvents(
          enabled: true,
          frequency: 20,
          types: ['first_event', 'second_event', 'third_event', 'fourth_event'],
        );

        final json = originalChaosEvents.toJson();
        final reconstructedChaosEvents = ChaosEvents.fromJson(json);

        expect(reconstructedChaosEvents.types[0], equals('first_event'));
        expect(reconstructedChaosEvents.types[1], equals('second_event'));
        expect(reconstructedChaosEvents.types[2], equals('third_event'));
        expect(reconstructedChaosEvents.types[3], equals('fourth_event'));
      });
    });

    group('realistic chaos scenarios', () {
      test('early universe chaos events', () {
        const earlyUniverseChaos = ChaosEvents(
          enabled: true,
          frequency: 90, // High frequency in early universe
          types: [
            'primordial_black_hole_formation',
            'cosmic_inflation_fluctuation',
            'dark_matter_clumping',
            'first_star_formation',
          ],
        );

        expect(earlyUniverseChaos.enabled, isTrue);
        expect(earlyUniverseChaos.frequency, equals(90));
        expect(
          earlyUniverseChaos.types,
          contains('primordial_black_hole_formation'),
        );
        expect(
          earlyUniverseChaos.types,
          contains('cosmic_inflation_fluctuation'),
        );
        expect(earlyUniverseChaos.types, contains('dark_matter_clumping'));
        expect(earlyUniverseChaos.types, contains('first_star_formation'));
      });

      test('galactic evolution chaos events', () {
        const galacticChaos = ChaosEvents(
          enabled: true,
          frequency: 35,
          types: [
            'spiral_arm_instability',
            'central_black_hole_feeding',
            'stellar_nursery_collapse',
            'supermassive_black_hole_merger',
          ],
        );

        expect(galacticChaos.frequency, equals(35));
        expect(galacticChaos.types, contains('spiral_arm_instability'));
        expect(galacticChaos.types, contains('central_black_hole_feeding'));
      });

      test('stellar system chaos events', () {
        const stellarChaos = ChaosEvents(
          enabled: true,
          frequency: 15,
          types: [
            'planetary_orbital_decay',
            'asteroid_belt_disruption',
            'comet_shower_event',
            'stellar_flare_activity',
            'binary_star_instability',
          ],
        );

        expect(stellarChaos.frequency, equals(15));
        expect(stellarChaos.types, hasLength(5));
        expect(stellarChaos.types, contains('planetary_orbital_decay'));
        expect(stellarChaos.types, contains('asteroid_belt_disruption'));
      });

      test('late universe chaos events', () {
        const lateUniverseChaos = ChaosEvents(
          enabled: true,
          frequency: 5, // Lower frequency in mature universe
          types: [
            'heat_death_acceleration',
            'proton_decay_event',
            'vacuum_metastability',
            'quantum_tunnel_effect',
          ],
        );

        expect(lateUniverseChaos.frequency, equals(5));
        expect(lateUniverseChaos.types, contains('heat_death_acceleration'));
        expect(lateUniverseChaos.types, contains('proton_decay_event'));
        expect(lateUniverseChaos.types, contains('vacuum_metastability'));
        expect(lateUniverseChaos.types, contains('quantum_tunnel_effect'));
      });

      test('disabled chaos for stable simulation', () {
        const stableChaos = ChaosEvents(
          enabled: false,
          frequency: 0,
          types: [],
        );

        expect(stableChaos.enabled, isFalse);
        expect(stableChaos.frequency, equals(0));
        expect(stableChaos.types, isEmpty);
      });

      test('extreme chaos scenario', () {
        const extremeChaos = ChaosEvents(
          enabled: true,
          frequency: 100, // Maximum chaos
          types: [
            'reality_breakdown',
            'physics_constant_fluctuation',
            'dimensional_barrier_collapse',
            'causality_violation',
            'entropy_reversal',
            'spacetime_fracture',
            'multiverse_collision',
            'information_paradox',
          ],
        );

        expect(extremeChaos.frequency, equals(100));
        expect(extremeChaos.types, hasLength(8));
        expect(extremeChaos.types, contains('reality_breakdown'));
        expect(extremeChaos.types, contains('physics_constant_fluctuation'));
        expect(extremeChaos.types, contains('multiverse_collision'));
      });
    });

    group('edge cases and validation', () {
      test('handles edge case frequencies', () {
        const minFrequency = ChaosEvents(
          enabled: true,
          frequency: 1,
          types: ['minimal_event'],
        );

        const maxFrequency = ChaosEvents(
          enabled: true,
          frequency: 999999,
          types: ['maximum_event'],
        );

        expect(minFrequency.frequency, equals(1));
        expect(maxFrequency.frequency, equals(999999));
      });

      test('handles very long event type names', () {
        const longNameChaos = ChaosEvents(
          enabled: true,
          frequency: 25,
          types: [
            'extremely_long_and_descriptive_chaos_event_name_that_describes_complex_astrophysical_phenomena',
            'another_incredibly_verbose_event_type_name_for_testing_purposes_only',
          ],
        );

        expect(longNameChaos.types.first.length, greaterThan(50));
        expect(longNameChaos.types.last.length, greaterThan(50));
      });

      test('handles large number of event types', () {
        final manyTypes = List.generate(100, (index) => 'event_type_$index');
        final largeChaos = ChaosEvents(
          enabled: true,
          frequency: 50,
          types: manyTypes,
        );

        expect(largeChaos.types, hasLength(100));
        expect(largeChaos.types.first, equals('event_type_0'));
        expect(largeChaos.types.last, equals('event_type_99'));
      });

      test('preserves immutability of types list', () {
        const originalTypes = ['event_a', 'event_b'];
        const chaosEvents = ChaosEvents(
          enabled: true,
          frequency: 10,
          types: originalTypes,
        );

        // Verify original list is preserved
        expect(chaosEvents.types, equals(originalTypes));
        expect(chaosEvents.types, hasLength(2));
      });
    });
  });
}
