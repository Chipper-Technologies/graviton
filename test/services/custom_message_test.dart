import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/custom_message_type.dart';

void main() {
  group('Custom Message System', () {
    test('should parse custom message type from string using extension', () {
      expect(
        CustomMessageTypeExtension.fromString('info'),
        equals(CustomMessageType.info),
      );
      expect(
        CustomMessageTypeExtension.fromString('warning'),
        equals(CustomMessageType.warning),
      );
      expect(
        CustomMessageTypeExtension.fromString('success'),
        equals(CustomMessageType.success),
      );
      expect(
        CustomMessageTypeExtension.fromString('announcement'),
        equals(CustomMessageType.announcement),
      );
      expect(
        CustomMessageTypeExtension.fromString('promotion'),
        equals(CustomMessageType.promotion),
      );
      expect(
        CustomMessageTypeExtension.fromString('update'),
        equals(CustomMessageType.update),
      );
      expect(
        CustomMessageTypeExtension.fromString('invalid'),
        equals(CustomMessageType.info),
      );
    });

    test('should handle case insensitive parsing', () {
      expect(
        CustomMessageTypeExtension.fromString('INFO'),
        equals(CustomMessageType.info),
      );
      expect(
        CustomMessageTypeExtension.fromString('WARNING'),
        equals(CustomMessageType.warning),
      );
      expect(
        CustomMessageTypeExtension.fromString('Success'),
        equals(CustomMessageType.success),
      );
      expect(
        CustomMessageTypeExtension.fromString('ANNOUNCEMENT'),
        equals(CustomMessageType.announcement),
      );
    });

    test('should provide display names for message types', () {
      expect(CustomMessageType.info.displayName, equals('Info'));
      expect(CustomMessageType.warning.displayName, equals('Warning'));
      expect(CustomMessageType.success.displayName, equals('Success'));
      expect(
        CustomMessageType.announcement.displayName,
        equals('Announcement'),
      );
      expect(CustomMessageType.promotion.displayName, equals('Promotion'));
      expect(CustomMessageType.update.displayName, equals('Update'));
    });

    test('should provide consistent localization keys for titles', () {
      expect(CustomMessageType.info.localizationKey, equals('newsTitle'));
      expect(CustomMessageType.warning.localizationKey, equals('warningTitle'));
      expect(CustomMessageType.success.localizationKey, equals('successTitle'));
      expect(
        CustomMessageType.announcement.localizationKey,
        equals('announcementTitle'),
      );
      expect(
        CustomMessageType.promotion.localizationKey,
        equals('promotionTitle'),
      );
      expect(
        CustomMessageType.update.localizationKey,
        equals('updateRequiredTitle'),
      );
    });

    test('should provide config values for message types', () {
      expect(CustomMessageType.info.configValue, equals('info'));
      expect(CustomMessageType.warning.configValue, equals('warning'));
      expect(CustomMessageType.success.configValue, equals('success'));
      expect(
        CustomMessageType.announcement.configValue,
        equals('announcement'),
      );
      expect(CustomMessageType.promotion.configValue, equals('promotion'));
      expect(CustomMessageType.update.configValue, equals('update'));
    });

    test('should handle round trip conversion correctly', () {
      for (final type in CustomMessageType.values) {
        final configValue = type.configValue;
        final parsed = CustomMessageTypeExtension.fromString(configValue);
        expect(
          parsed,
          equals(type),
          reason: 'Round trip failed for $type: $configValue -> $parsed',
        );
      }
    });
  });
}
