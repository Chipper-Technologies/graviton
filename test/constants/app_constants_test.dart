import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/constants/app_constants.dart';

void main() {
  group('AppConstants', () {
    test('packageNameProd should be correct', () {
      expect(AppConstants.packageNameProd, equals('io.chipper.graviton'));
    });

    test('packageNameDev should be correct', () {
      expect(AppConstants.packageNameDev, equals('io.chipper.graviton.dev'));
    });

    test('bundleIdProd should be correct', () {
      expect(AppConstants.bundleIdProd, equals('io.chipper.graviton'));
    });

    test('bundleIdDev should be correct', () {
      expect(AppConstants.bundleIdDev, equals('io.chipper.graviton.dev'));
    });

    test('prod and dev package names should be different', () {
      expect(
        AppConstants.packageNameProd,
        isNot(equals(AppConstants.packageNameDev)),
      );
    });

    test('prod and dev bundle IDs should be different', () {
      expect(
        AppConstants.bundleIdProd,
        isNot(equals(AppConstants.bundleIdDev)),
      );
    });
  });
}
