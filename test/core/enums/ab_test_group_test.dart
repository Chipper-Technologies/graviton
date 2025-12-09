import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/core/enums/ab_test_group.dart';

void main() {
  group('ABTestGroup Enum', () {
    test('should have all expected A/B test groups', () {
      expect(ABTestGroup.values.length, equals(4));
      expect(ABTestGroup.values, contains(ABTestGroup.control));
      expect(ABTestGroup.values, contains(ABTestGroup.experimental));
      expect(ABTestGroup.values, contains(ABTestGroup.variantA));
      expect(ABTestGroup.values, contains(ABTestGroup.variantB));
    });

    group('configValue extension', () {
      test('should return correct config values', () {
        expect(ABTestGroup.control.configValue, equals('control'));
        expect(ABTestGroup.experimental.configValue, equals('experimental'));
        expect(ABTestGroup.variantA.configValue, equals('variant_a'));
        expect(ABTestGroup.variantB.configValue, equals('variant_b'));
      });

      test('should have unique config values', () {
        final values = ABTestGroup.values
            .map((group) => group.configValue)
            .toSet();
        expect(
          values.length,
          equals(ABTestGroup.values.length),
          reason: 'All A/B test groups should have unique config values',
        );
      });

      test('should use snake_case for config values', () {
        for (final group in ABTestGroup.values) {
          expect(
            group.configValue,
            matches(RegExp(r'^[a-z]+(_[a-z]+)*$')),
            reason: '${group.configValue} should follow snake_case convention',
          );
        }
      });
    });

    group('fromString static method', () {
      test('should parse correct values', () {
        expect(
          ABTestGroupExtension.fromString('control'),
          equals(ABTestGroup.control),
        );
        expect(
          ABTestGroupExtension.fromString('experimental'),
          equals(ABTestGroup.experimental),
        );
        expect(
          ABTestGroupExtension.fromString('variant_a'),
          equals(ABTestGroup.variantA),
        );
        expect(
          ABTestGroupExtension.fromString('variant_b'),
          equals(ABTestGroup.variantB),
        );
      });

      test('should be case insensitive', () {
        expect(
          ABTestGroupExtension.fromString('CONTROL'),
          equals(ABTestGroup.control),
        );
        expect(
          ABTestGroupExtension.fromString('Experimental'),
          equals(ABTestGroup.experimental),
        );
        expect(
          ABTestGroupExtension.fromString('VARIANT_A'),
          equals(ABTestGroup.variantA),
        );
        expect(
          ABTestGroupExtension.fromString('Variant_B'),
          equals(ABTestGroup.variantB),
        );
      });

      test('should return safe default for unknown values', () {
        expect(
          ABTestGroupExtension.fromString('unknown'),
          equals(ABTestGroup.control),
        );
        expect(
          ABTestGroupExtension.fromString('invalid'),
          equals(ABTestGroup.control),
        );
        expect(
          ABTestGroupExtension.fromString(''),
          equals(ABTestGroup.control),
        );
      });

      test('should round-trip with configValue', () {
        for (final group in ABTestGroup.values) {
          final recreated = ABTestGroupExtension.fromString(group.configValue);
          expect(
            recreated,
            equals(group),
            reason: 'fromString should round-trip with configValue',
          );
        }
      });
    });

    group('isExperimental extension', () {
      test('should identify experimental groups correctly', () {
        expect(ABTestGroup.control.isExperimental, isFalse);
        expect(ABTestGroup.experimental.isExperimental, isTrue);
        expect(ABTestGroup.variantA.isExperimental, isTrue);
        expect(ABTestGroup.variantB.isExperimental, isTrue);
      });

      test('should be mutually exclusive with control', () {
        for (final group in ABTestGroup.values) {
          expect(
            group.isExperimental && group.isControl,
            isFalse,
            reason: 'Groups should not be both experimental and control',
          );
        }
      });
    });

    group('isControl extension', () {
      test('should identify control group correctly', () {
        expect(ABTestGroup.control.isControl, isTrue);
        expect(ABTestGroup.experimental.isControl, isFalse);
        expect(ABTestGroup.variantA.isControl, isFalse);
        expect(ABTestGroup.variantB.isControl, isFalse);
      });

      test('should have exactly one control group', () {
        final controlGroups = ABTestGroup.values
            .where((group) => group.isControl)
            .toList();
        expect(
          controlGroups.length,
          equals(1),
          reason: 'Should have exactly one control group',
        );
        expect(controlGroups.first, equals(ABTestGroup.control));
      });
    });

    test('should cover comprehensive A/B testing scenarios', () {
      // Should have control group (baseline)
      expect(
        ABTestGroup.values,
        contains(ABTestGroup.control),
        reason: 'Should have control group for baseline comparison',
      );

      // Should have experimental groups
      expect(
        ABTestGroup.values,
        contains(ABTestGroup.experimental),
        reason: 'Should have experimental group for feature testing',
      );

      // Should have multiple variants for complex testing
      expect(
        ABTestGroup.values,
        contains(ABTestGroup.variantA),
        reason: 'Should have variant A for comparative testing',
      );
      expect(
        ABTestGroup.values,
        contains(ABTestGroup.variantB),
        reason: 'Should have variant B for comparative testing',
      );
    });

    test('should support statistical significance', () {
      // Should have enough groups for meaningful A/B testing
      expect(
        ABTestGroup.values.length,
        greaterThanOrEqualTo(2),
        reason: 'Should have at least control and experimental groups',
      );

      // Should have balanced number of experimental vs control
      final experimentalGroups = ABTestGroup.values
          .where((group) => group.isExperimental)
          .length;
      final controlGroups = ABTestGroup.values
          .where((group) => group.isControl)
          .length;

      expect(
        experimentalGroups,
        greaterThanOrEqualTo(1),
        reason: 'Should have at least one experimental group',
      );
      expect(
        controlGroups,
        equals(1),
        reason: 'Should have exactly one control group',
      );
    });

    test('should use safe default in fromString', () {
      final defaultGroup = ABTestGroupExtension.fromString('invalid');
      expect(
        defaultGroup,
        equals(ABTestGroup.control),
        reason: 'Should default to control group for safety',
      );
      expect(defaultGroup.isControl, isTrue);
      expect(defaultGroup.isExperimental, isFalse);
    });

    test('should have clear group identification', () {
      // Control group should be clearly identifiable
      expect(ABTestGroup.control.isControl, isTrue);
      expect(ABTestGroup.control.isExperimental, isFalse);
      expect(ABTestGroup.control.configValue, equals('control'));

      // All experimental groups should be clearly identifiable
      for (final group in ABTestGroup.values) {
        if (group != ABTestGroup.control) {
          expect(
            group.isExperimental,
            isTrue,
            reason: '${group.configValue} should be experimental',
          );
          expect(
            group.isControl,
            isFalse,
            reason: '${group.configValue} should not be control',
          );
        }
      }
    });

    test('should support remote configuration', () {
      // Config values should be suitable for remote config systems
      for (final group in ABTestGroup.values) {
        final configValue = group.configValue;

        // Should not contain spaces or special characters
        expect(configValue, isNot(contains(' ')));
        expect(configValue, isNot(contains('.')));
        expect(configValue, isNot(contains('-')));

        // Should be machine-readable
        expect(
          configValue,
          matches(RegExp(r'^[a-z_]+$')),
          reason: '$configValue should be machine-readable',
        );

        // Should be descriptive
        expect(
          configValue.length,
          greaterThan(2),
          reason: '$configValue should be descriptive',
        );
      }
    });

    test('should maintain group distribution logic', () {
      // Control should be single group for baseline
      final controlCount = ABTestGroup.values.where((g) => g.isControl).length;
      expect(
        controlCount,
        equals(1),
        reason: 'Should have exactly one control group',
      );

      // Should have multiple experimental variants for comparison
      final experimentalCount = ABTestGroup.values
          .where((g) => g.isExperimental)
          .length;
      expect(
        experimentalCount,
        greaterThanOrEqualTo(1),
        reason: 'Should have experimental groups',
      );

      // Total should be reasonable for A/B testing
      expect(
        ABTestGroup.values.length,
        lessThanOrEqualTo(10),
        reason: 'Should not have too many groups (affects statistical power)',
      );
    });
  });
}
