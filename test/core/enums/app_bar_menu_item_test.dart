import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/core/enums/app_bar_menu_item.dart';

void main() {
  group('AppBarMenuItem Enum', () {
    test('should have all expected menu items', () {
      expect(AppBarMenuItem.values.length, equals(6));
      expect(AppBarMenuItem.values, contains(AppBarMenuItem.scenarios));
      expect(AppBarMenuItem.values, contains(AppBarMenuItem.physics));
      expect(AppBarMenuItem.values, contains(AppBarMenuItem.settings));
      expect(AppBarMenuItem.values, contains(AppBarMenuItem.help));
      expect(AppBarMenuItem.values, contains(AppBarMenuItem.about));
      expect(AppBarMenuItem.values, contains(AppBarMenuItem.developerTools));
    });

    test('should have correct string values', () {
      expect(AppBarMenuItem.scenarios.value, equals('scenarios'));
      expect(AppBarMenuItem.physics.value, equals('physics'));
      expect(AppBarMenuItem.settings.value, equals('settings'));
      expect(AppBarMenuItem.help.value, equals('help'));
      expect(AppBarMenuItem.about.value, equals('about'));
      expect(AppBarMenuItem.developerTools.value, equals('developer_tools'));
    });

    test('should convert from string value correctly', () {
      expect(
        AppBarMenuItem.fromValue('scenarios'),
        equals(AppBarMenuItem.scenarios),
      );
      expect(
        AppBarMenuItem.fromValue('physics'),
        equals(AppBarMenuItem.physics),
      );
      expect(
        AppBarMenuItem.fromValue('settings'),
        equals(AppBarMenuItem.settings),
      );
      expect(AppBarMenuItem.fromValue('help'), equals(AppBarMenuItem.help));
      expect(AppBarMenuItem.fromValue('about'), equals(AppBarMenuItem.about));
      expect(
        AppBarMenuItem.fromValue('developer_tools'),
        equals(AppBarMenuItem.developerTools),
      );
    });

    test('should return null for invalid string values', () {
      expect(AppBarMenuItem.fromValue('invalid'), isNull);
      expect(AppBarMenuItem.fromValue(''), isNull);
      expect(AppBarMenuItem.fromValue('SCENARIOS'), isNull); // Case sensitive
    });

    test('should implement toString correctly', () {
      expect(AppBarMenuItem.scenarios.toString(), equals('scenarios'));
      expect(AppBarMenuItem.physics.toString(), equals('physics'));
      expect(AppBarMenuItem.settings.toString(), equals('settings'));
      expect(AppBarMenuItem.help.toString(), equals('help'));
      expect(AppBarMenuItem.about.toString(), equals('about'));
      expect(
        AppBarMenuItem.developerTools.toString(),
        equals('developer_tools'),
      );
    });

    test('should handle all values in fromValue method', () {
      for (final item in AppBarMenuItem.values) {
        final result = AppBarMenuItem.fromValue(item.value);
        expect(
          result,
          equals(item),
          reason: 'fromValue should work for ${item.value}',
        );
      }
    });
  });
}
