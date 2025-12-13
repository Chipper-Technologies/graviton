import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/core/enums/auto_rotate_status.dart';

void main() {
  group('AutoRotateStatus Enum', () {
    test('should have all expected auto-rotate statuses', () {
      expect(AutoRotateStatus.values.length, equals(2));
      expect(AutoRotateStatus.values, contains(AutoRotateStatus.on));
      expect(AutoRotateStatus.values, contains(AutoRotateStatus.off));
    });

    group('isEnabled extension', () {
      test('should return correct enabled status', () {
        expect(AutoRotateStatus.on.isEnabled, isTrue);
        expect(AutoRotateStatus.off.isEnabled, isFalse);
      });
    });

    group('toggle extension', () {
      test('should toggle between on and off', () {
        expect(AutoRotateStatus.on.toggle, equals(AutoRotateStatus.off));
        expect(AutoRotateStatus.off.toggle, equals(AutoRotateStatus.on));
      });

      test('should be reversible', () {
        expect(AutoRotateStatus.on.toggle.toggle, equals(AutoRotateStatus.on));
        expect(
          AutoRotateStatus.off.toggle.toggle,
          equals(AutoRotateStatus.off),
        );
      });
    });

    group('localizationKey extension', () {
      test('should return correct localization keys', () {
        expect(AutoRotateStatus.on.localizationKey, equals('autoRotateOn'));
        expect(AutoRotateStatus.off.localizationKey, equals('autoRotateOff'));
      });

      test('should follow consistent naming pattern', () {
        for (final status in AutoRotateStatus.values) {
          final key = status.localizationKey;
          expect(
            key,
            startsWith('autoRotate'),
            reason: '$key should start with "autoRotate" prefix',
          );
          expect(
            key,
            matches(RegExp(r'^autoRotate[A-Z][a-z]*$')),
            reason: '$key should follow camelCase pattern after prefix',
          );
        }
      });

      test('should have unique localization keys', () {
        final keys = AutoRotateStatus.values
            .map((status) => status.localizationKey)
            .toSet();
        expect(
          keys.length,
          equals(AutoRotateStatus.values.length),
          reason:
              'All auto-rotate statuses should have unique localization keys',
        );
      });
    });

    group('fromBool static method', () {
      test('should create correct status from boolean', () {
        expect(
          AutoRotateStatusExtension.fromBool(true),
          equals(AutoRotateStatus.on),
        );
        expect(
          AutoRotateStatusExtension.fromBool(false),
          equals(AutoRotateStatus.off),
        );
      });

      test('should be consistent with isEnabled', () {
        for (final status in AutoRotateStatus.values) {
          final recreated = AutoRotateStatusExtension.fromBool(
            status.isEnabled,
          );
          expect(
            recreated,
            equals(status),
            reason: 'fromBool should be consistent with isEnabled',
          );
        }
      });
    });

    group('toBool extension', () {
      test('should convert to correct boolean values', () {
        expect(AutoRotateStatus.on.toBool(), isTrue);
        expect(AutoRotateStatus.off.toBool(), isFalse);
      });

      test('should be consistent with isEnabled', () {
        for (final status in AutoRotateStatus.values) {
          expect(
            status.toBool(),
            equals(status.isEnabled),
            reason: 'toBool should be consistent with isEnabled',
          );
        }
      });

      test('should be reversible with fromBool', () {
        for (final status in AutoRotateStatus.values) {
          final recreated = AutoRotateStatusExtension.fromBool(status.toBool());
          expect(
            recreated,
            equals(status),
            reason: 'toBool and fromBool should be reversible',
          );
        }
      });
    });

    test('should be a simple binary state', () {
      expect(
        AutoRotateStatus.values.length,
        equals(2),
        reason: 'Auto-rotate should be a simple on/off state',
      );

      // Should have both states
      expect(AutoRotateStatus.values, contains(AutoRotateStatus.on));
      expect(AutoRotateStatus.values, contains(AutoRotateStatus.off));
    });

    test('should have clear semantic naming', () {
      expect(AutoRotateStatus.on.name, equals('on'));
      expect(AutoRotateStatus.off.name, equals('off'));
    });

    test('should provide comprehensive boolean interoperability', () {
      // Should convert to boolean
      expect(AutoRotateStatus.on.isEnabled, isA<bool>());
      expect(AutoRotateStatus.off.isEnabled, isA<bool>());

      // Should create from boolean
      expect(AutoRotateStatusExtension.fromBool(true), isA<AutoRotateStatus>());
      expect(
        AutoRotateStatusExtension.fromBool(false),
        isA<AutoRotateStatus>(),
      );

      // Should have toBool method
      expect(AutoRotateStatus.on.toBool(), isA<bool>());
      expect(AutoRotateStatus.off.toBool(), isA<bool>());
    });

    test('should have toggle functionality for UI controls', () {
      // Each state should toggle to the opposite
      expect(AutoRotateStatus.on.toggle, isNot(equals(AutoRotateStatus.on)));
      expect(AutoRotateStatus.off.toggle, isNot(equals(AutoRotateStatus.off)));

      // Should have exactly two possible toggle results
      final toggleResults = AutoRotateStatus.values
          .map((status) => status.toggle)
          .toSet();
      expect(toggleResults.length, equals(2));
      expect(toggleResults, containsAll(AutoRotateStatus.values));
    });
  });
}
