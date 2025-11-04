import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/app_flavor.dart';

void main() {
  group('AppFlavor Enum', () {
    test('should have all expected app flavors', () {
      expect(AppFlavor.values.length, equals(2));
      expect(AppFlavor.values, contains(AppFlavor.dev));
      expect(AppFlavor.values, contains(AppFlavor.prod));
    });

    group('localizationKey extension', () {
      test('should return correct localization keys', () {
        expect(AppFlavor.dev.localizationKey, equals('appFlavorDevelopment'));
        expect(AppFlavor.prod.localizationKey, equals('appFlavorProduction'));
      });

      test('should have unique localization keys', () {
        final keys = AppFlavor.values
            .map((flavor) => flavor.localizationKey)
            .toSet();
        expect(
          keys.length,
          equals(AppFlavor.values.length),
          reason: 'All app flavors should have unique localization keys',
        );
      });
    });

    group('suffix extension', () {
      test('should return appropriate suffixes', () {
        expect(AppFlavor.dev.suffix, equals(' Dev'));
        expect(AppFlavor.prod.suffix, equals(''));
      });

      test('should differentiate development builds', () {
        expect(
          AppFlavor.dev.suffix,
          isNotEmpty,
          reason: 'Development flavor should have a suffix to distinguish it',
        );
        expect(
          AppFlavor.prod.suffix,
          isEmpty,
          reason: 'Production flavor should have no suffix',
        );
      });
    });

    group('boolean properties', () {
      test('isDevelopment should be correct', () {
        expect(AppFlavor.dev.isDevelopment, isTrue);
        expect(AppFlavor.prod.isDevelopment, isFalse);
      });

      test('isProduction should be correct', () {
        expect(AppFlavor.dev.isProduction, isFalse);
        expect(AppFlavor.prod.isProduction, isTrue);
      });

      test('should be mutually exclusive', () {
        for (final flavor in AppFlavor.values) {
          expect(
            flavor.isDevelopment && flavor.isProduction,
            isFalse,
            reason: 'Flavors should not be both development and production',
          );
          expect(
            flavor.isDevelopment || flavor.isProduction,
            isTrue,
            reason: 'Flavors should be either development or production',
          );
        }
      });
    });

    test('should cover essential build types', () {
      // Should have development flavor for testing/debugging
      expect(
        AppFlavor.values,
        contains(AppFlavor.dev),
        reason: 'Should have development flavor for testing',
      );

      // Should have production flavor for release
      expect(
        AppFlavor.values,
        contains(AppFlavor.prod),
        reason: 'Should have production flavor for release',
      );
    });

    test('should have exactly two flavors', () {
      expect(
        AppFlavor.values.length,
        equals(2),
        reason: 'Should have exactly development and production flavors',
      );
    });

    test('should use semantic enum names', () {
      expect(AppFlavor.dev.toString(), contains('dev'));
      expect(AppFlavor.prod.toString(), contains('prod'));
    });

    test('should provide clear distinction between flavors', () {
      // Development should be clearly identified
      expect(AppFlavor.dev.isDevelopment, isTrue);
      expect(AppFlavor.dev.localizationKey, equals('appFlavorDevelopment'));
      expect(AppFlavor.dev.suffix, isNotEmpty);

      // Production should be clearly identified
      expect(AppFlavor.prod.isProduction, isTrue);
      expect(AppFlavor.prod.localizationKey, equals('appFlavorProduction'));
      expect(AppFlavor.prod.suffix, isEmpty);
    });

    test('should handle app identification scenarios', () {
      // Each flavor should have distinct properties for identification
      final devProperties = {
        'isDevelopment': AppFlavor.dev.isDevelopment,
        'isProduction': AppFlavor.dev.isProduction,
        'name': AppFlavor.dev.name,
        'suffix': AppFlavor.dev.suffix,
      };

      final prodProperties = {
        'isDevelopment': AppFlavor.prod.isDevelopment,
        'isProduction': AppFlavor.prod.isProduction,
        'name': AppFlavor.prod.name,
        'suffix': AppFlavor.prod.suffix,
      };

      expect(
        devProperties,
        isNot(equals(prodProperties)),
        reason: 'Flavors should have distinct property sets',
      );
    });
  });
}
