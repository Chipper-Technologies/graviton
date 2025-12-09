import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/features/scenarios/domain/scenario_metadata.dart';

void main() {
  group('ScenarioMetadata', () {
    test('should create instance with required fields', () {
      final creationTime = DateTime(2023, 11, 8);
      final metadata = ScenarioMetadata(
        name: 'Test Scenario',
        description: 'A test scenario for unit testing',
        createdAt: creationTime,
        educationalFocus: 'orbital mechanics',
        tags: ['test', 'orbital'],
        difficulty: 'beginner',
      );

      expect(metadata.name, equals('Test Scenario'));
      expect(metadata.description, equals('A test scenario for unit testing'));
      expect(metadata.author, isNull);
      expect(metadata.createdAt, equals(creationTime));
      expect(metadata.educationalFocus, equals('orbital mechanics'));
      expect(metadata.tags, equals(['test', 'orbital']));
      expect(metadata.difficulty, equals('beginner'));
    });

    test('should create instance with all fields', () {
      final creationTime = DateTime(2023, 11, 8);
      final metadata = ScenarioMetadata(
        name: 'Advanced Scenario',
        description: 'Complex multi-body system',
        author: 'Test Author',
        createdAt: creationTime,
        educationalFocus: 'three-body problem',
        tags: ['advanced', 'chaotic', 'multi-body'],
        difficulty: 'advanced',
      );

      expect(metadata.name, equals('Advanced Scenario'));
      expect(metadata.description, equals('Complex multi-body system'));
      expect(metadata.author, equals('Test Author'));
      expect(metadata.createdAt, equals(creationTime));
      expect(metadata.educationalFocus, equals('three-body problem'));
      expect(metadata.tags, equals(['advanced', 'chaotic', 'multi-body']));
      expect(metadata.difficulty, equals('advanced'));
    });

    test('should serialize to JSON correctly', () {
      final creationTime = DateTime(2023, 11, 8);
      final metadata = ScenarioMetadata(
        name: 'JSON Test',
        description: 'Testing JSON serialization',
        author: 'JSON Tester',
        createdAt: creationTime,
        educationalFocus: 'serialization',
        tags: ['json', 'test'],
        difficulty: 'intermediate',
      );

      final json = metadata.toJson();

      expect(json['name'], equals('JSON Test'));
      expect(json['description'], equals('Testing JSON serialization'));
      expect(json['author'], equals('JSON Tester'));
      expect(json['createdAt'], equals(creationTime.toIso8601String()));
      expect(json['educationalFocus'], equals('serialization'));
      expect(json['tags'], equals(['json', 'test']));
      expect(json['difficulty'], equals('intermediate'));
    });

    test('should serialize to JSON without optional fields', () {
      final creationTime = DateTime(2023, 11, 8);
      final metadata = ScenarioMetadata(
        name: 'Minimal Test',
        description: 'Testing minimal JSON',
        createdAt: creationTime,
        educationalFocus: 'basics',
        tags: ['minimal'],
        difficulty: 'beginner',
      );

      final json = metadata.toJson();

      expect(json['name'], equals('Minimal Test'));
      expect(json['description'], equals('Testing minimal JSON'));
      expect(json.containsKey('author'), isFalse);
      expect(json['createdAt'], equals(creationTime.toIso8601String()));
      expect(json['educationalFocus'], equals('basics'));
      expect(json['tags'], equals(['minimal']));
      expect(json['difficulty'], equals('beginner'));
    });

    test('should deserialize from JSON correctly', () {
      final json = {
        'name': 'Deserialized Test',
        'description': 'Testing JSON deserialization',
        'author': 'Deserializer',
        'createdAt': '2023-11-08T10:30:00.000Z',
        'educationalFocus': 'deserialization',
        'tags': ['json', 'deserialize'],
        'difficulty': 'advanced',
      };

      final metadata = ScenarioMetadata.fromJson(json);

      expect(metadata.name, equals('Deserialized Test'));
      expect(metadata.description, equals('Testing JSON deserialization'));
      expect(metadata.author, equals('Deserializer'));
      expect(
        metadata.createdAt,
        equals(DateTime.parse('2023-11-08T10:30:00.000Z')),
      );
      expect(metadata.educationalFocus, equals('deserialization'));
      expect(metadata.tags, equals(['json', 'deserialize']));
      expect(metadata.difficulty, equals('advanced'));
    });

    test('should deserialize from JSON without optional fields', () {
      final json = {
        'name': 'Minimal Deserialize',
        'description': 'Testing minimal deserialization',
        'createdAt': DateTime(2024, 1, 1).toIso8601String(),
        'educationalFocus': 'minimal',
        'tags': ['basic'],
        'difficulty': 'beginner',
      };

      final metadata = ScenarioMetadata.fromJson(json);

      expect(metadata.name, equals('Minimal Deserialize'));
      expect(metadata.description, equals('Testing minimal deserialization'));
      expect(metadata.author, isNull);
      expect(metadata.createdAt, equals(DateTime(2024, 1, 1)));
      expect(metadata.educationalFocus, equals('minimal'));
      expect(metadata.tags, equals(['basic']));
      expect(metadata.difficulty, equals('beginner'));
    });

    test('should handle round-trip serialization', () {
      final original = ScenarioMetadata(
        name: 'Round Trip Test',
        description: 'Testing serialization round trip',
        author: 'Round Tripper',
        createdAt: DateTime.now(),
        educationalFocus: 'round-trip',
        tags: ['test', 'serialization', 'round-trip'],
        difficulty: 'intermediate',
      );

      final json = original.toJson();
      final deserialized = ScenarioMetadata.fromJson(json);

      expect(deserialized.name, equals(original.name));
      expect(deserialized.description, equals(original.description));
      expect(deserialized.author, equals(original.author));
      expect(deserialized.createdAt, equals(original.createdAt));
      expect(deserialized.educationalFocus, equals(original.educationalFocus));
      expect(deserialized.tags, equals(original.tags));
      expect(deserialized.difficulty, equals(original.difficulty));
    });

    test('should handle empty tags list', () {
      final creationTime = DateTime(2023, 11, 8);
      final metadata = ScenarioMetadata(
        name: 'No Tags',
        description: 'Scenario without tags',
        createdAt: creationTime,
        educationalFocus: 'basics',
        tags: [],
        difficulty: 'beginner',
      );

      expect(metadata.tags, isEmpty);

      final json = metadata.toJson();
      expect(json['tags'], equals([]));

      final deserialized = ScenarioMetadata.fromJson(json);
      expect(deserialized.tags, isEmpty);
    });
  });
}
