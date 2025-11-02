import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/habitability_status.dart';

void main() {
  group('HabitabilityStatus Enum', () {
    test('should have all expected habitability statuses', () {
      expect(HabitabilityStatus.values.length, equals(4));
      expect(HabitabilityStatus.values, contains(HabitabilityStatus.habitable));
      expect(HabitabilityStatus.values, contains(HabitabilityStatus.tooHot));
      expect(HabitabilityStatus.values, contains(HabitabilityStatus.tooCold));
      expect(HabitabilityStatus.values, contains(HabitabilityStatus.unknown));
    });

    group('statusColor extension', () {
      test('should return correct colors for each status', () {
        expect(
          HabitabilityStatus.habitable.statusColor,
          equals(0xFF4CAF50),
        ); // Green
        expect(
          HabitabilityStatus.tooHot.statusColor,
          equals(0xFFF44336),
        ); // Red
        expect(
          HabitabilityStatus.tooCold.statusColor,
          equals(0xFF2196F3),
        ); // Blue
        expect(
          HabitabilityStatus.unknown.statusColor,
          equals(0xFF9E9E9E),
        ); // Grey
      });

      test('should use semantically appropriate colors', () {
        // Green for habitable (positive) - check that green component is significant
        final habitableColor = HabitabilityStatus.habitable.statusColor;
        final habitableGreen = (habitableColor >> 8) & 0xFF;
        final habitableRed = (habitableColor >> 16) & 0xFF;
        final habitableBlue = habitableColor & 0xFF;
        expect(
          habitableGreen,
          greaterThan(habitableBlue),
          reason: 'Habitable should have more green than blue',
        );
        expect(
          habitableGreen,
          greaterThan(habitableRed),
          reason: 'Habitable should have more green than red',
        );

        // Red for too hot - check that red component is significant
        final hotColor = HabitabilityStatus.tooHot.statusColor;
        final hotRed = (hotColor >> 16) & 0xFF;
        final hotGreen = (hotColor >> 8) & 0xFF;
        final hotBlue = hotColor & 0xFF;
        expect(
          hotRed,
          greaterThan(hotGreen),
          reason: 'Too hot should have more red than green',
        );
        expect(
          hotRed,
          greaterThan(hotBlue),
          reason: 'Too hot should have more red than blue',
        );

        // Blue for too cold - check that blue component is significant
        final coldColor = HabitabilityStatus.tooCold.statusColor;
        final coldBlue = coldColor & 0xFF;
        final coldRed = (coldColor >> 16) & 0xFF;
        final coldGreen = (coldColor >> 8) & 0xFF;
        expect(
          coldBlue,
          greaterThan(coldRed),
          reason: 'Too cold should have more blue than red',
        );
        expect(
          coldBlue,
          greaterThan(coldGreen),
          reason: 'Too cold should have more blue than green',
        );
      });

      test('should have unique colors', () {
        final colors = HabitabilityStatus.values
            .map((status) => status.statusColor)
            .toSet();
        expect(
          colors.length,
          equals(HabitabilityStatus.values.length),
          reason: 'All habitability statuses should have unique colors',
        );
      });
    });

    group('displayName extension', () {
      test('should return correct display names', () {
        expect(HabitabilityStatus.habitable.displayName, equals('Habitable'));
        expect(HabitabilityStatus.tooHot.displayName, equals('Too Hot'));
        expect(HabitabilityStatus.tooCold.displayName, equals('Too Cold'));
        expect(HabitabilityStatus.unknown.displayName, equals('Unknown'));
      });

      test('should use proper capitalization', () {
        for (final status in HabitabilityStatus.values) {
          final displayName = status.displayName;
          expect(
            displayName[0],
            equals(displayName[0].toUpperCase()),
            reason: '$displayName should start with uppercase',
          );
        }
      });

      test('should have unique display names', () {
        final names = HabitabilityStatus.values
            .map((status) => status.displayName)
            .toSet();
        expect(
          names.length,
          equals(HabitabilityStatus.values.length),
          reason: 'All habitability statuses should have unique display names',
        );
      });
    });

    group('localizationKey extension', () {
      test('should return correct localization keys', () {
        expect(
          HabitabilityStatus.habitable.localizationKey,
          equals('habitabilityHabitable'),
        );
        expect(
          HabitabilityStatus.tooHot.localizationKey,
          equals('habitabilityTooHot'),
        );
        expect(
          HabitabilityStatus.tooCold.localizationKey,
          equals('habitabilityTooCold'),
        );
        expect(
          HabitabilityStatus.unknown.localizationKey,
          equals('habitabilityUnknown'),
        );
      });

      test('should follow consistent naming pattern', () {
        for (final status in HabitabilityStatus.values) {
          final key = status.localizationKey;
          expect(
            key,
            startsWith('habitability'),
            reason: '$key should start with "habitability" prefix',
          );
          expect(
            key,
            matches(RegExp(r'^habitability[A-Z][a-zA-Z]*$')),
            reason: '$key should follow camelCase pattern after prefix',
          );
        }
      });

      test('should have unique localization keys', () {
        final keys = HabitabilityStatus.values
            .map((status) => status.localizationKey)
            .toSet();
        expect(
          keys.length,
          equals(HabitabilityStatus.values.length),
          reason:
              'All habitability statuses should have unique localization keys',
        );
      });
    });

    test('should cover all potential habitability scenarios', () {
      // Should have positive case
      expect(HabitabilityStatus.values, contains(HabitabilityStatus.habitable));

      // Should have temperature-based negative cases
      expect(HabitabilityStatus.values, contains(HabitabilityStatus.tooHot));
      expect(HabitabilityStatus.values, contains(HabitabilityStatus.tooCold));

      // Should have fallback for undetermined cases
      expect(HabitabilityStatus.values, contains(HabitabilityStatus.unknown));
    });

    test('should have extension methods for all enum values', () {
      for (final status in HabitabilityStatus.values) {
        // Verify all extension methods work without throwing
        expect(() => status.statusColor, returnsNormally);
        expect(() => status.displayName, returnsNormally);
        expect(() => status.localizationKey, returnsNormally);

        // Verify return types
        expect(status.statusColor, isA<int>());
        expect(status.displayName, isA<String>());
        expect(status.localizationKey, isA<String>());

        // Verify non-empty returns
        expect(status.displayName, isNotEmpty);
        expect(status.localizationKey, isNotEmpty);
      }
    });
  });
}
