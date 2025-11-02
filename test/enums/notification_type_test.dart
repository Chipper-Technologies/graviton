import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/notification_type.dart';

void main() {
  group('NotificationType Enum', () {
    test('should have all expected notification types', () {
      expect(NotificationType.values.length, equals(5));
      expect(NotificationType.values, contains(NotificationType.error));
      expect(NotificationType.values, contains(NotificationType.warning));
      expect(NotificationType.values, contains(NotificationType.info));
      expect(NotificationType.values, contains(NotificationType.success));
      expect(NotificationType.values, contains(NotificationType.debug));
    });

    group('value extension', () {
      test('should return correct string values', () {
        expect(NotificationType.error.value, equals('error'));
        expect(NotificationType.warning.value, equals('warning'));
        expect(NotificationType.info.value, equals('info'));
        expect(NotificationType.success.value, equals('success'));
        expect(NotificationType.debug.value, equals('debug'));
      });

      test('should have unique string values', () {
        final values = NotificationType.values
            .map((type) => type.value)
            .toSet();
        expect(
          values.length,
          equals(NotificationType.values.length),
          reason: 'All notification types should have unique string values',
        );
      });
    });

    group('fromString static method', () {
      test('should parse correct values', () {
        expect(
          NotificationTypeExtension.fromString('error'),
          equals(NotificationType.error),
        );
        expect(
          NotificationTypeExtension.fromString('warning'),
          equals(NotificationType.warning),
        );
        expect(
          NotificationTypeExtension.fromString('info'),
          equals(NotificationType.info),
        );
        expect(
          NotificationTypeExtension.fromString('success'),
          equals(NotificationType.success),
        );
        expect(
          NotificationTypeExtension.fromString('debug'),
          equals(NotificationType.debug),
        );
      });

      test('should be case insensitive', () {
        expect(
          NotificationTypeExtension.fromString('ERROR'),
          equals(NotificationType.error),
        );
        expect(
          NotificationTypeExtension.fromString('Warning'),
          equals(NotificationType.warning),
        );
        expect(
          NotificationTypeExtension.fromString('INFO'),
          equals(NotificationType.info),
        );
        expect(
          NotificationTypeExtension.fromString('SUCCESS'),
          equals(NotificationType.success),
        );
        expect(
          NotificationTypeExtension.fromString('Debug'),
          equals(NotificationType.debug),
        );
      });

      test('should return safe default for unknown values', () {
        expect(
          NotificationTypeExtension.fromString('unknown'),
          equals(NotificationType.info),
        );
        expect(
          NotificationTypeExtension.fromString('invalid'),
          equals(NotificationType.info),
        );
        expect(
          NotificationTypeExtension.fromString(''),
          equals(NotificationType.info),
        );
      });
    });

    group('priority extension', () {
      test('should return correct priority levels', () {
        expect(NotificationType.error.priority, equals(0)); // Highest priority
        expect(NotificationType.warning.priority, equals(1));
        expect(NotificationType.success.priority, equals(2));
        expect(NotificationType.info.priority, equals(3));
        expect(NotificationType.debug.priority, equals(4)); // Lowest priority
      });

      test('should have unique priority levels', () {
        final priorities = NotificationType.values
            .map((type) => type.priority)
            .toSet();
        expect(
          priorities.length,
          equals(NotificationType.values.length),
          reason: 'All notification types should have unique priorities',
        );
      });

      test('should order types by severity', () {
        expect(
          NotificationType.error.priority,
          lessThan(NotificationType.warning.priority),
        );
        expect(
          NotificationType.warning.priority,
          lessThan(NotificationType.success.priority),
        );
        expect(
          NotificationType.success.priority,
          lessThan(NotificationType.info.priority),
        );
        expect(
          NotificationType.info.priority,
          lessThan(NotificationType.debug.priority),
        );
      });
    });

    group('showInProduction extension', () {
      test('should show appropriate types in production', () {
        expect(NotificationType.error.showInProduction, isTrue);
        expect(NotificationType.warning.showInProduction, isTrue);
        expect(NotificationType.info.showInProduction, isTrue);
        expect(NotificationType.success.showInProduction, isTrue);
        expect(NotificationType.debug.showInProduction, isFalse);
      });
    });

    group('autoDismiss extension', () {
      test('should configure auto-dismiss appropriately', () {
        // Critical notifications should not auto-dismiss
        expect(NotificationType.error.autoDismiss, isFalse);
        expect(NotificationType.warning.autoDismiss, isFalse);

        // Informational notifications should auto-dismiss
        expect(NotificationType.success.autoDismiss, isTrue);
        expect(NotificationType.info.autoDismiss, isTrue);
        expect(NotificationType.debug.autoDismiss, isTrue);
      });
    });

    group('dismissDurationSeconds extension', () {
      test('should return appropriate durations', () {
        expect(NotificationType.success.dismissDurationSeconds, equals(3));
        expect(NotificationType.info.dismissDurationSeconds, equals(5));
        expect(NotificationType.debug.dismissDurationSeconds, equals(2));

        // Non-auto-dismissing types should return 0
        expect(NotificationType.error.dismissDurationSeconds, equals(0));
        expect(NotificationType.warning.dismissDurationSeconds, equals(0));
      });

      test('should have positive durations for auto-dismissing types', () {
        for (final type in NotificationType.values) {
          if (type.autoDismiss) {
            expect(
              type.dismissDurationSeconds,
              greaterThan(0),
              reason:
                  '${type.displayName} should have positive dismiss duration',
            );
          }
        }
      });

      test('should have zero duration for non-auto-dismissing types', () {
        for (final type in NotificationType.values) {
          if (!type.autoDismiss) {
            expect(
              type.dismissDurationSeconds,
              equals(0),
              reason: '${type.displayName} should have zero dismiss duration',
            );
          }
        }
      });
    });

    group('displayName extension', () {
      test('should return correct display names', () {
        expect(NotificationType.error.displayName, equals('Error'));
        expect(NotificationType.warning.displayName, equals('Warning'));
        expect(NotificationType.info.displayName, equals('Info'));
        expect(NotificationType.success.displayName, equals('Success'));
        expect(NotificationType.debug.displayName, equals('Debug'));
      });

      test('should use proper capitalization', () {
        for (final type in NotificationType.values) {
          final displayName = type.displayName;
          expect(
            displayName[0],
            equals(displayName[0].toUpperCase()),
            reason: '$displayName should start with uppercase',
          );
        }
      });

      test('should have unique display names', () {
        final names = NotificationType.values
            .map((type) => type.displayName)
            .toSet();
        expect(
          names.length,
          equals(NotificationType.values.length),
          reason: 'All notification types should have unique display names',
        );
      });
    });

    group('iconName extension', () {
      test('should return appropriate icon names', () {
        expect(NotificationType.error.iconName, equals('error'));
        expect(NotificationType.warning.iconName, equals('warning'));
        expect(NotificationType.info.iconName, equals('info'));
        expect(NotificationType.success.iconName, equals('check_circle'));
        expect(NotificationType.debug.iconName, equals('bug_report'));
      });

      test('should have unique icon names', () {
        final icons = NotificationType.values
            .map((type) => type.iconName)
            .toSet();
        expect(
          icons.length,
          equals(NotificationType.values.length),
          reason: 'All notification types should have unique icons',
        );
      });

      test('should use semantic icon names', () {
        expect(NotificationType.success.iconName, contains('check'));
        expect(NotificationType.debug.iconName, contains('bug'));
      });
    });

    test('should have comprehensive notification coverage', () {
      // Should have error types
      expect(NotificationType.values, contains(NotificationType.error));
      expect(NotificationType.values, contains(NotificationType.warning));

      // Should have positive feedback
      expect(NotificationType.values, contains(NotificationType.success));

      // Should have informational type
      expect(NotificationType.values, contains(NotificationType.info));

      // Should have development type
      expect(NotificationType.values, contains(NotificationType.debug));
    });

    test('should have logical priority ordering', () {
      // Error should be highest priority (lowest number)
      final errorPriority = NotificationType.error.priority;
      for (final type in NotificationType.values) {
        if (type != NotificationType.error) {
          expect(
            type.priority,
            greaterThan(errorPriority),
            reason: 'Error should have highest priority',
          );
        }
      }

      // Debug should be lowest priority (highest number)
      final debugPriority = NotificationType.debug.priority;
      for (final type in NotificationType.values) {
        if (type != NotificationType.debug) {
          expect(
            type.priority,
            lessThan(debugPriority),
            reason: 'Debug should have lowest priority',
          );
        }
      }
    });

    test('should have consistent auto-dismiss behavior', () {
      for (final type in NotificationType.values) {
        if (type.autoDismiss) {
          expect(
            type.dismissDurationSeconds,
            greaterThan(0),
            reason: 'Auto-dismissing types should have positive duration',
          );
        } else {
          expect(
            type.dismissDurationSeconds,
            equals(0),
            reason: 'Non-auto-dismissing types should have zero duration',
          );
        }
      }
    });
  });
}
