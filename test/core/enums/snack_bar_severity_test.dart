import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/core/enums/snack_bar_severity.dart';

void main() {
  group('SnackBarSeverity', () {
    test('should have four severity levels', () {
      expect(SnackBarSeverity.values.length, equals(4));
    });

    test('should contain all expected values', () {
      expect(SnackBarSeverity.values, contains(SnackBarSeverity.info));
      expect(SnackBarSeverity.values, contains(SnackBarSeverity.success));
      expect(SnackBarSeverity.values, contains(SnackBarSeverity.warning));
      expect(SnackBarSeverity.values, contains(SnackBarSeverity.error));
    });

    test('should have correct string representations', () {
      expect(SnackBarSeverity.info.toString(), equals('SnackBarSeverity.info'));
      expect(
        SnackBarSeverity.success.toString(),
        equals('SnackBarSeverity.success'),
      );
      expect(
        SnackBarSeverity.warning.toString(),
        equals('SnackBarSeverity.warning'),
      );
      expect(
        SnackBarSeverity.error.toString(),
        equals('SnackBarSeverity.error'),
      );
    });

    test('should have correct index values', () {
      expect(SnackBarSeverity.info.index, equals(0));
      expect(SnackBarSeverity.success.index, equals(1));
      expect(SnackBarSeverity.warning.index, equals(2));
      expect(SnackBarSeverity.error.index, equals(3));
    });

    test('should be comparable', () {
      expect(SnackBarSeverity.info == SnackBarSeverity.info, isTrue);
      expect(SnackBarSeverity.info == SnackBarSeverity.success, isFalse);
      expect(SnackBarSeverity.success == SnackBarSeverity.warning, isFalse);
      expect(SnackBarSeverity.warning == SnackBarSeverity.error, isFalse);
    });

    test('should maintain order from least to most severe', () {
      final severities = SnackBarSeverity.values;
      expect(severities[0], equals(SnackBarSeverity.info));
      expect(severities[1], equals(SnackBarSeverity.success));
      expect(severities[2], equals(SnackBarSeverity.warning));
      expect(severities[3], equals(SnackBarSeverity.error));
    });
  });
}
