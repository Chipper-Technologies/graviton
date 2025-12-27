import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/features/premium/domain/premium_feature.dart';

void main() {
  group('PremiumFeature', () {
    group('values', () {
      test('should have exactly 5 features', () {
        expect(PremiumFeature.values.length, equals(5));
      });

      test('should contain cameraSync', () {
        expect(PremiumFeature.values, contains(PremiumFeature.cameraSync));
      });

      test('should contain passwordProtection', () {
        expect(
          PremiumFeature.values,
          contains(PremiumFeature.passwordProtection),
        );
      });

      test('should contain unlimitedSessionDuration', () {
        expect(
          PremiumFeature.values,
          contains(PremiumFeature.unlimitedSessionDuration),
        );
      });

      test('should contain unlimitedViewers', () {
        expect(
          PremiumFeature.values,
          contains(PremiumFeature.unlimitedViewers),
        );
      });

      test('should contain unlimitedSessionsPerDay', () {
        expect(
          PremiumFeature.values,
          contains(PremiumFeature.unlimitedSessionsPerDay),
        );
      });
    });

    group('index', () {
      test('cameraSync should have index 0', () {
        expect(PremiumFeature.cameraSync.index, equals(0));
      });

      test('passwordProtection should have index 1', () {
        expect(PremiumFeature.passwordProtection.index, equals(1));
      });

      test('unlimitedSessionDuration should have index 2', () {
        expect(PremiumFeature.unlimitedSessionDuration.index, equals(2));
      });

      test('unlimitedViewers should have index 3', () {
        expect(PremiumFeature.unlimitedViewers.index, equals(3));
      });

      test('unlimitedSessionsPerDay should have index 4', () {
        expect(PremiumFeature.unlimitedSessionsPerDay.index, equals(4));
      });
    });

    group('name', () {
      test('cameraSync should have correct name', () {
        expect(PremiumFeature.cameraSync.name, equals('cameraSync'));
      });

      test('passwordProtection should have correct name', () {
        expect(
          PremiumFeature.passwordProtection.name,
          equals('passwordProtection'),
        );
      });

      test('unlimitedSessionDuration should have correct name', () {
        expect(
          PremiumFeature.unlimitedSessionDuration.name,
          equals('unlimitedSessionDuration'),
        );
      });

      test('unlimitedViewers should have correct name', () {
        expect(
          PremiumFeature.unlimitedViewers.name,
          equals('unlimitedViewers'),
        );
      });

      test('unlimitedSessionsPerDay should have correct name', () {
        expect(
          PremiumFeature.unlimitedSessionsPerDay.name,
          equals('unlimitedSessionsPerDay'),
        );
      });
    });

    group('equality', () {
      test('same enum values should be equal', () {
        expect(PremiumFeature.cameraSync, equals(PremiumFeature.cameraSync));
        expect(
          PremiumFeature.unlimitedViewers,
          equals(PremiumFeature.unlimitedViewers),
        );
      });

      test('different enum values should not be equal', () {
        expect(
          PremiumFeature.cameraSync,
          isNot(equals(PremiumFeature.passwordProtection)),
        );
        expect(
          PremiumFeature.unlimitedSessionDuration,
          isNot(equals(PremiumFeature.unlimitedSessionsPerDay)),
        );
      });
    });

    group('toString', () {
      test('should return prefixed name for each value', () {
        for (final feature in PremiumFeature.values) {
          expect(feature.toString(), equals('PremiumFeature.${feature.name}'));
        }
      });
    });

    group('iteration', () {
      test('should be iterable in defined order', () {
        final expectedOrder = [
          PremiumFeature.cameraSync,
          PremiumFeature.passwordProtection,
          PremiumFeature.unlimitedSessionDuration,
          PremiumFeature.unlimitedViewers,
          PremiumFeature.unlimitedSessionsPerDay,
        ];

        expect(PremiumFeature.values, orderedEquals(expectedOrder));
      });
    });

    group('switch exhaustiveness', () {
      test('all enum values can be handled in switch expression', () {
        for (final feature in PremiumFeature.values) {
          final description = switch (feature) {
            PremiumFeature.cameraSync => 'camera sync',
            PremiumFeature.passwordProtection => 'password protection',
            PremiumFeature.unlimitedSessionDuration => 'unlimited duration',
            PremiumFeature.unlimitedViewers => 'unlimited viewers',
            PremiumFeature.unlimitedSessionsPerDay => 'unlimited sessions',
          };

          expect(description, isNotEmpty);
        }
      });
    });
  });
}
