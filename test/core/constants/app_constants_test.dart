import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/core/constants/app_constants.dart';

void main() {
  group('AppConstants', () {
    test('packageNameProd should be correct', () {
      expect(AppConstants.packageNameProd, equals('io.chipper.graviton'));
    });

    test('packageNameDev should be correct', () {
      expect(AppConstants.packageNameDev, equals('io.chipper.graviton.dev'));
    });

    test('prod and dev package names should be different', () {
      expect(
        AppConstants.packageNameProd,
        isNot(equals(AppConstants.packageNameDev)),
      );
    });
  });
}
