import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/cinematic_camera_technique.dart';

void main() {
  group('CinematicCameraTechnique Enum Tests', () {
    test('enum should have all expected values', () {
      expect(CinematicCameraTechnique.values, hasLength(3));
      expect(
        CinematicCameraTechnique.values,
        contains(CinematicCameraTechnique.manual),
      );
      expect(
        CinematicCameraTechnique.values,
        contains(CinematicCameraTechnique.predictiveOrbital),
      );
      expect(
        CinematicCameraTechnique.values,
        contains(CinematicCameraTechnique.dynamicFraming),
      );
    });

    test('displayName should return correct strings', () {
      expect(
        CinematicCameraTechnique.manual.displayName,
        equals('Manual Control'),
      );
      expect(
        CinematicCameraTechnique.predictiveOrbital.displayName,
        equals('Predictive Orbital'),
      );
      expect(
        CinematicCameraTechnique.dynamicFraming.displayName,
        equals('Dynamic Framing'),
      );
    });

    test('description should return descriptive strings', () {
      // Test that all descriptions are non-empty and descriptive
      for (final technique in CinematicCameraTechnique.values) {
        final description = technique.description;
        expect(description, isNotNull);
        expect(description, isNotEmpty);
        expect(description, isA<String>());
        // Descriptions should be longer than display names
        expect(description.length, greaterThan(technique.displayName.length));
      }

      // Test specific descriptions
      expect(
        CinematicCameraTechnique.manual.description,
        equals('Traditional manual camera controls with follow mode'),
      );
      expect(
        CinematicCameraTechnique.predictiveOrbital.description,
        equals('AI predicts orbital paths for dramatic camera movements'),
      );
      expect(
        CinematicCameraTechnique.dynamicFraming.description,
        equals('Automatically adjusts framing based on scene content'),
      );
    });

    test('requiresAI should return correct values', () {
      // Manual should not require AI
      expect(CinematicCameraTechnique.manual.requiresAI, isFalse);

      // All other techniques should require AI
      expect(CinematicCameraTechnique.predictiveOrbital.requiresAI, isTrue);
      expect(CinematicCameraTechnique.dynamicFraming.requiresAI, isTrue);
    });

    test('value property should return correct string values', () {
      expect(CinematicCameraTechnique.manual.value, equals('manual'));
      expect(
        CinematicCameraTechnique.predictiveOrbital.value,
        equals('predictive_orbital'),
      );
      expect(
        CinematicCameraTechnique.dynamicFraming.value,
        equals('dynamic_framing'),
      );
    });

    test('fromValue should parse string values correctly', () {
      expect(
        CinematicCameraTechnique.fromValue('manual'),
        equals(CinematicCameraTechnique.manual),
      );
      expect(
        CinematicCameraTechnique.fromValue('predictive_orbital'),
        equals(CinematicCameraTechnique.predictiveOrbital),
      );
      expect(
        CinematicCameraTechnique.fromValue('dynamic_framing'),
        equals(CinematicCameraTechnique.dynamicFraming),
      );
    });

    test('fromValue should return manual for unknown values', () {
      expect(
        CinematicCameraTechnique.fromValue('unknown'),
        equals(CinematicCameraTechnique.manual),
      );
      expect(
        CinematicCameraTechnique.fromValue(''),
        equals(CinematicCameraTechnique.manual),
      );
      expect(
        CinematicCameraTechnique.fromValue('invalid_technique'),
        equals(CinematicCameraTechnique.manual),
      );
    });

    test('technique categories should be logically grouped', () {
      // Test that we have the expected distribution of AI vs non-AI techniques
      final aiTechniques = CinematicCameraTechnique.values
          .where((t) => t.requiresAI)
          .toList();
      final nonAiTechniques = CinematicCameraTechnique.values
          .where((t) => !t.requiresAI)
          .toList();

      expect(nonAiTechniques, hasLength(1)); // Only manual
      expect(
        aiTechniques,
        hasLength(2),
      ); // predictiveOrbital and dynamicFraming
      expect(nonAiTechniques.first, equals(CinematicCameraTechnique.manual));
    });

    test('enum values should be in logical order', () {
      final values = CinematicCameraTechnique.values;

      // Manual should be first (simplest)
      expect(values.first, equals(CinematicCameraTechnique.manual));

      // Predictive orbital should be second (it's our main implementation)
      expect(values[1], equals(CinematicCameraTechnique.predictiveOrbital));

      // All values should be unique
      final uniqueValues = values.toSet();
      expect(uniqueValues.length, equals(values.length));
    });

    test('toString should return meaningful representation', () {
      for (final technique in CinematicCameraTechnique.values) {
        final stringRep = technique.toString();
        expect(stringRep, isNotEmpty);
        expect(stringRep, contains(technique.name));
      }
    });

    test('value strings should be valid for analytics and storage', () {
      for (final technique in CinematicCameraTechnique.values) {
        final value = technique.value;
        // Should be lowercase and use underscores
        expect(value, equals(value.toLowerCase()));
        expect(value, matches(RegExp(r'^[a-z_]+$')));
        // Should not be empty
        expect(value, isNotEmpty);
      }
    });

    test('displayName and description pairs should be consistent', () {
      for (final technique in CinematicCameraTechnique.values) {
        final displayName = technique.displayName;
        final description = technique.description;

        // Both should be non-empty
        expect(displayName, isNotEmpty);
        expect(description, isNotEmpty);

        // Description should be longer and more detailed
        expect(description.length, greaterThan(displayName.length));

        // Display name should use title case
        expect(displayName, matches(RegExp(r'^[A-Z]')));

        // Description should start with uppercase and be sentence-like
        expect(description, matches(RegExp(r'^[A-Z]')));
      }
    });
  });
}
