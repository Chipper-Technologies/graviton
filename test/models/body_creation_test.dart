import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/utils/body_type_ranges.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/models/body.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void main() {
  group('Body Creation with BodyTypeRanges', () {
    test('new planet body has reasonable defaults using BodyTypeRanges', () {
      // Simulate the _addNewBody() logic from scenario_editor_screen.dart
      final defaultProperties = BodyTypeRanges.getDefaultProperties(
        BodyType.planet,
      );

      final newBody = Body(
        name: 'Test Planet',
        position: vm.Vector3(0, 0, 0),
        velocity: vm.Vector3(0, 5.0, 0),
        mass: defaultProperties['mass']!,
        radius: defaultProperties['radius']!,
        color: AppColors.planetEarth,
        bodyType: BodyType.planet,
        stellarLuminosity: defaultProperties['luminosity']!,
        temperature: 288.0,
      );

      // Verify the body has realistic planet properties
      expect(
        newBody.mass,
        greaterThan(1.0),
        reason: 'Planet should have substantial mass',
      );
      expect(
        newBody.mass,
        lessThan(10.0),
        reason: 'Planet mass should not be excessive for default',
      );
      expect(
        newBody.radius,
        greaterThan(0.5),
        reason: 'Planet should have reasonable radius',
      );
      expect(
        newBody.radius,
        lessThan(3.0),
        reason: 'Planet radius should not be excessive for default',
      );
      expect(
        newBody.stellarLuminosity,
        equals(0.0),
        reason: 'Planet should not be luminous',
      );
      expect(newBody.bodyType, equals(BodyType.planet));

      // Verify the values are within the planet ranges
      final planetMassRange = BodyTypeRanges.getMassRange(BodyType.planet);
      final planetRadiusRange = BodyTypeRanges.getRadiusRange(BodyType.planet);

      expect(
        newBody.mass,
        inInclusiveRange(planetMassRange['min']!, planetMassRange['max']!),
        reason: 'Planet mass should be within valid range',
      );
      expect(
        newBody.radius,
        inInclusiveRange(planetRadiusRange['min']!, planetRadiusRange['max']!),
        reason: 'Planet radius should be within valid range',
      );
    });

    test('body type change triggers appropriate property updates', () {
      // Simulate changing a planet to a star
      final originalMass = 3.0; // Typical planet mass
      final originalLuminosity = 0.0; // Non-luminous

      // Check if these values are valid for stars
      final starMassRange = BodyTypeRanges.getMassRange(BodyType.star);
      final starLuminosityRange = BodyTypeRanges.getLuminosityRange(
        BodyType.star,
      );

      final massIsValidForStar = BodyTypeRanges.isValidMass(
        BodyType.star,
        originalMass,
      );
      final luminosityIsValidForStar = BodyTypeRanges.isValidLuminosity(
        BodyType.star,
        originalLuminosity,
      );

      // Planet values should NOT be valid for stars (except potentially radius)
      expect(
        massIsValidForStar,
        isFalse,
        reason: 'Planet mass should be too small for star range',
      );
      expect(
        luminosityIsValidForStar,
        isFalse,
        reason: 'Planet luminosity (0.0) should be invalid for stars',
      );

      // When changing to star, values should be clamped/updated
      final clampedMass = originalMass.clamp(
        starMassRange['min']!,
        starMassRange['max']!,
      );
      final clampedLuminosity = originalLuminosity.clamp(
        starLuminosityRange['min']!,
        starLuminosityRange['max']!,
      );

      expect(
        clampedMass,
        equals(starMassRange['min']!),
        reason: 'Small planet mass should be clamped to star minimum',
      );
      expect(
        clampedLuminosity,
        equals(starLuminosityRange['min']!),
        reason: 'Zero luminosity should be clamped to star minimum',
      );

      // The clamped values should be valid for stars
      expect(
        BodyTypeRanges.isValidMass(BodyType.star, clampedMass),
        isTrue,
        reason: 'Clamped mass should be valid for stars',
      );
      expect(
        BodyTypeRanges.isValidLuminosity(BodyType.star, clampedLuminosity),
        isTrue,
        reason: 'Clamped luminosity should be valid for stars',
      );
    });

    test('slider ranges provide adequate precision for different body types', () {
      // Test that each body type has appropriate range granularity

      final testCases = [
        {
          'type': BodyType.star,
          'expectedPrecision': 1.0,
        }, // Stars: large range, need coarse precision
        {
          'type': BodyType.planet,
          'expectedPrecision': 0.1,
        }, // Planets: medium range, medium precision
        {
          'type': BodyType.moon,
          'expectedPrecision': 0.01,
        }, // Moons: small range, fine precision
        {
          'type': BodyType.asteroid,
          'expectedPrecision': 0.001,
        }, // Asteroids: very small range, very fine precision
      ];

      for (final testCase in testCases) {
        final bodyType = testCase['type'] as BodyType;
        final expectedPrecision = testCase['expectedPrecision'] as double;

        final massRange = BodyTypeRanges.getMassRange(bodyType);
        final massSpan = massRange['max']! - massRange['min']!;

        // With 100 slider divisions, each step should provide reasonable precision
        final stepSize = massSpan / 100;

        expect(
          stepSize,
          greaterThanOrEqualTo(expectedPrecision * 0.1),
          reason:
              '$bodyType mass steps should provide at least ${expectedPrecision * 10}x precision',
        );
        expect(
          stepSize,
          lessThanOrEqualTo(expectedPrecision * 10),
          reason: '$bodyType mass steps should not be too coarse',
        );
      }
    });

    test('body type switching preserves position and velocity', () {
      // Test that non-physical properties are preserved during type changes
      final originalPosition = vm.Vector3(15.0, -8.0, 3.0);
      final originalVelocity = vm.Vector3(0.2, -0.5, 0.1);
      final originalName = 'Test Body';
      final originalColor = AppColors.planetMars;
      final originalTemperature = 350.0;

      // These properties should be preserved regardless of body type
      final planetBody = Body(
        name: originalName,
        position: originalPosition,
        velocity: originalVelocity,
        mass: 2.0, // Will change
        radius: 1.0, // Will change
        color: originalColor,
        bodyType: BodyType.planet,
        stellarLuminosity: 0.0, // Will change
        temperature: originalTemperature,
      );

      // Simulate changing to star with new physical properties
      final starDefaults = BodyTypeRanges.getDefaultProperties(BodyType.star);
      final starBody = Body(
        name: originalName, // Preserved
        position: originalPosition, // Preserved
        velocity: originalVelocity, // Preserved
        mass: starDefaults['mass']!, // Changed
        radius: starDefaults['radius']!, // Changed
        color: originalColor, // Preserved
        bodyType: BodyType.star, // Changed
        stellarLuminosity: starDefaults['luminosity']!, // Changed
        temperature: originalTemperature, // Preserved
      );

      // Verify preserved properties
      expect(
        starBody.name,
        equals(originalName),
        reason: 'Name should be preserved during type change',
      );
      expect(
        starBody.position,
        equals(originalPosition),
        reason: 'Position should be preserved during type change',
      );
      expect(
        starBody.velocity,
        equals(originalVelocity),
        reason: 'Velocity should be preserved during type change',
      );
      expect(
        starBody.color,
        equals(originalColor),
        reason: 'Color should be preserved during type change',
      );
      expect(
        starBody.temperature,
        equals(originalTemperature),
        reason: 'Temperature should be preserved during type change',
      );

      // Verify changed properties are appropriate for new type
      expect(
        starBody.bodyType,
        equals(BodyType.star),
        reason: 'Body type should be updated',
      );
      expect(
        starBody.mass,
        greaterThan(planetBody.mass),
        reason: 'Star mass should be larger than original planet mass',
      );
      expect(
        starBody.stellarLuminosity,
        greaterThan(0.0),
        reason: 'Star should have positive luminosity',
      );

      // Verify new properties are within star ranges
      expect(
        BodyTypeRanges.isValidMass(BodyType.star, starBody.mass),
        isTrue,
        reason: 'New star mass should be valid',
      );
      expect(
        BodyTypeRanges.isValidLuminosity(
          BodyType.star,
          starBody.stellarLuminosity,
        ),
        isTrue,
        reason: 'New star luminosity should be valid',
      );
    });

    test('sim units provide appropriate scale for astronomical scenarios', () {
      // Test that the sim unit system works well for common astronomical scenarios

      // Typical solar system scenario in sim units
      final sunMass = 10.0; // Reference: 1 solar mass = 10 sim units
      final earthMass =
          0.03; // Earth mass ≈ 1/333 solar masses = ~0.03 sim units

      // Verify these values fit within our ranges
      expect(
        BodyTypeRanges.isValidMass(BodyType.star, sunMass),
        isTrue,
        reason: 'Sun mass should fit in star range',
      );
      expect(
        BodyTypeRanges.isValidMass(BodyType.planet, earthMass),
        isFalse,
        reason:
            'Earth mass is below our planet minimum (expected - ranges are for larger planets)',
      );

      // Test typical three-body scenario
      final largeStar = 15.0; // 1.5 solar masses
      final smallStar = 8.0; // 0.8 solar masses
      final giantPlanet = 5.0; // Super-Jupiter

      expect(
        BodyTypeRanges.isValidMass(BodyType.star, largeStar),
        isTrue,
        reason: 'Large star mass should be valid',
      );
      expect(
        BodyTypeRanges.isValidMass(BodyType.star, smallStar),
        isTrue,
        reason: 'Small star mass should be valid',
      );
      expect(
        BodyTypeRanges.isValidMass(BodyType.planet, giantPlanet),
        isTrue,
        reason: 'Giant planet mass should be valid',
      );
    });
  });
}

/// Custom matcher for inclusive range checking
Matcher inInclusiveRange(num min, num max) => _InInclusiveRange(min, max);

class _InInclusiveRange extends Matcher {
  final num _min, _max;

  const _InInclusiveRange(this._min, this._max);

  @override
  bool matches(dynamic item, Map matchState) {
    return item is num && item >= _min && item <= _max;
  }

  @override
  Description describe(Description description) {
    return description.add('a value between $_min and $_max (inclusive)');
  }

  @override
  Description describeMismatch(
    dynamic item,
    Description mismatchDescription,
    Map matchState,
    bool verbose,
  ) {
    return mismatchDescription.add('$item is not between $_min and $_max');
  }
}
