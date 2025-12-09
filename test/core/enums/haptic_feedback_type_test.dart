import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/core/enums/haptic_feedback_type.dart';

void main() {
  group('HapticFeedbackType', () {
    test('should have all expected values', () {
      expect(HapticFeedbackType.values.length, equals(5));
      expect(
        HapticFeedbackType.values,
        contains(HapticFeedbackType.lightImpact),
      );
      expect(
        HapticFeedbackType.values,
        contains(HapticFeedbackType.mediumImpact),
      );
      expect(
        HapticFeedbackType.values,
        contains(HapticFeedbackType.heavyImpact),
      );
      expect(
        HapticFeedbackType.values,
        contains(HapticFeedbackType.selectionClick),
      );
      expect(HapticFeedbackType.values, contains(HapticFeedbackType.vibrate));
    });

    test('should have correct enum names', () {
      expect(HapticFeedbackType.lightImpact.name, equals('lightImpact'));
      expect(HapticFeedbackType.mediumImpact.name, equals('mediumImpact'));
      expect(HapticFeedbackType.heavyImpact.name, equals('heavyImpact'));
      expect(HapticFeedbackType.selectionClick.name, equals('selectionClick'));
      expect(HapticFeedbackType.vibrate.name, equals('vibrate'));
    });

    test('should be comparable', () {
      expect(
        HapticFeedbackType.lightImpact == HapticFeedbackType.lightImpact,
        isTrue,
      );
      expect(
        HapticFeedbackType.lightImpact == HapticFeedbackType.mediumImpact,
        isFalse,
      );
      expect(
        HapticFeedbackType.heavyImpact == HapticFeedbackType.heavyImpact,
        isTrue,
      );
    });

    test('should support switch statements', () {
      String getDescription(HapticFeedbackType type) {
        switch (type) {
          case HapticFeedbackType.lightImpact:
            return 'Light Impact';
          case HapticFeedbackType.mediumImpact:
            return 'Medium Impact';
          case HapticFeedbackType.heavyImpact:
            return 'Heavy Impact';
          case HapticFeedbackType.selectionClick:
            return 'Selection Click';
          case HapticFeedbackType.vibrate:
            return 'Vibrate';
        }
      }

      expect(
        getDescription(HapticFeedbackType.lightImpact),
        equals('Light Impact'),
      );
      expect(
        getDescription(HapticFeedbackType.mediumImpact),
        equals('Medium Impact'),
      );
      expect(
        getDescription(HapticFeedbackType.heavyImpact),
        equals('Heavy Impact'),
      );
      expect(
        getDescription(HapticFeedbackType.selectionClick),
        equals('Selection Click'),
      );
      expect(getDescription(HapticFeedbackType.vibrate), equals('Vibrate'));
    });

    test('should have correct index values', () {
      expect(HapticFeedbackType.lightImpact.index, equals(0));
      expect(HapticFeedbackType.mediumImpact.index, equals(1));
      expect(HapticFeedbackType.heavyImpact.index, equals(2));
      expect(HapticFeedbackType.selectionClick.index, equals(3));
      expect(HapticFeedbackType.vibrate.index, equals(4));
    });

    test('should support iteration', () {
      final types = <HapticFeedbackType>[];
      for (final type in HapticFeedbackType.values) {
        types.add(type);
      }
      expect(types.length, equals(5));
      expect(types[0], equals(HapticFeedbackType.lightImpact));
      expect(types[1], equals(HapticFeedbackType.mediumImpact));
      expect(types[2], equals(HapticFeedbackType.heavyImpact));
      expect(types[3], equals(HapticFeedbackType.selectionClick));
      expect(types[4], equals(HapticFeedbackType.vibrate));
    });

    test('should support toString', () {
      expect(
        HapticFeedbackType.lightImpact.toString(),
        equals('HapticFeedbackType.lightImpact'),
      );
      expect(
        HapticFeedbackType.mediumImpact.toString(),
        equals('HapticFeedbackType.mediumImpact'),
      );
      expect(
        HapticFeedbackType.heavyImpact.toString(),
        equals('HapticFeedbackType.heavyImpact'),
      );
      expect(
        HapticFeedbackType.selectionClick.toString(),
        equals('HapticFeedbackType.selectionClick'),
      );
      expect(
        HapticFeedbackType.vibrate.toString(),
        equals('HapticFeedbackType.vibrate'),
      );
    });

    test('should be usable in collections', () {
      final set = {
        HapticFeedbackType.lightImpact,
        HapticFeedbackType.mediumImpact,
        // ignore: equal_elements_in_set
        HapticFeedbackType.lightImpact,
      };
      expect(set.length, equals(2)); // Duplicates removed

      final map = {
        HapticFeedbackType.lightImpact: 'light',
        HapticFeedbackType.heavyImpact: 'heavy',
      };
      expect(map[HapticFeedbackType.lightImpact], equals('light'));
      expect(map[HapticFeedbackType.heavyImpact], equals('heavy'));
    });

    test('should maintain value order', () {
      final values = HapticFeedbackType.values;
      expect(values[0], equals(HapticFeedbackType.lightImpact));
      expect(values[1], equals(HapticFeedbackType.mediumImpact));
      expect(values[2], equals(HapticFeedbackType.heavyImpact));
      expect(values[3], equals(HapticFeedbackType.selectionClick));
      expect(values[4], equals(HapticFeedbackType.vibrate));
    });

    test('should represent intensity levels correctly', () {
      // Verify the order represents increasing intensity (excluding special cases)
      final impactTypes = [
        HapticFeedbackType.lightImpact,
        HapticFeedbackType.mediumImpact,
        HapticFeedbackType.heavyImpact,
      ];

      // Verify they're in ascending index order (light < medium < heavy)
      expect(impactTypes[0].index < impactTypes[1].index, isTrue);
      expect(impactTypes[1].index < impactTypes[2].index, isTrue);
    });
  });
}
