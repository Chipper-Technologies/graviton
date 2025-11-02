import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/body_type.dart';

void main() {
  group('BodyType Enum', () {
    test('should have all expected body types', () {
      expect(BodyType.values.length, equals(4));
      expect(BodyType.values, contains(BodyType.star));
      expect(BodyType.values, contains(BodyType.planet));
      expect(BodyType.values, contains(BodyType.moon));
      expect(BodyType.values, contains(BodyType.asteroid));
    });

    test('should correctly identify luminous bodies', () {
      expect(BodyType.star.isLuminous, isTrue);
      expect(BodyType.planet.isLuminous, isFalse);
      expect(BodyType.moon.isLuminous, isFalse);
      expect(BodyType.asteroid.isLuminous, isFalse);
    });

    test('should correctly identify potentially habitable bodies', () {
      expect(BodyType.star.canBeHabitable, isFalse);
      expect(BodyType.planet.canBeHabitable, isTrue);
      expect(BodyType.moon.canBeHabitable, isTrue);
      expect(BodyType.asteroid.canBeHabitable, isFalse);
    });

    test('should have correct localization keys', () {
      expect(BodyType.star.localizationKey, equals('bodyTypeStar'));
      expect(BodyType.planet.localizationKey, equals('bodyTypePlanet'));
      expect(BodyType.moon.localizationKey, equals('bodyTypeMoon'));
      expect(BodyType.asteroid.localizationKey, equals('bodyTypeAsteroid'));
    });

    test('should have unique localization keys', () {
      final localizationKeys = BodyType.values
          .map((type) => type.localizationKey)
          .toSet();
      expect(
        localizationKeys.length,
        equals(BodyType.values.length),
        reason: 'All body types should have unique localization keys',
      );
    });

    test('should have consistent properties', () {
      // Stars should be luminous but not habitable
      expect(BodyType.star.isLuminous, isTrue);
      expect(BodyType.star.canBeHabitable, isFalse);

      // Asteroids should be neither luminous nor habitable
      expect(BodyType.asteroid.isLuminous, isFalse);
      expect(BodyType.asteroid.canBeHabitable, isFalse);

      // Planets and moons should be potentially habitable but not luminous
      expect(BodyType.planet.isLuminous, isFalse);
      expect(BodyType.planet.canBeHabitable, isTrue);
      expect(BodyType.moon.isLuminous, isFalse);
      expect(BodyType.moon.canBeHabitable, isTrue);
    });
  });
}
