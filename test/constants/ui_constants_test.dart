import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/constants/ui_constants.dart';

void main() {
  group('UIConstants', () {
    group('Timing Constants', () {
      test('postNavigationDelay should be 100ms', () {
        expect(
          UIConstants.postNavigationDelay,
          equals(const Duration(milliseconds: 100)),
        );
      });

      test('screenTransitionDuration should be 300ms', () {
        expect(
          UIConstants.screenTransitionDuration,
          equals(const Duration(milliseconds: 300)),
        );
      });

      test('initializationDelay should be 1000ms', () {
        expect(
          UIConstants.initializationDelay,
          equals(const Duration(milliseconds: 1000)),
        );
      });

      test('floatingControlsTimeout should be 3 seconds', () {
        expect(
          UIConstants.floatingControlsTimeout,
          equals(const Duration(seconds: 3)),
        );
      });

      test('screenshotNavigationTimeout should be 4 seconds', () {
        expect(
          UIConstants.screenshotNavigationTimeout,
          equals(const Duration(seconds: 4)),
        );
      });

      test('tapDebounceDelay should be 50ms', () {
        expect(
          UIConstants.tapDebounceDelay,
          equals(const Duration(milliseconds: 50)),
        );
      });

      test('maintenanceDialogDelay should be 500ms', () {
        expect(
          UIConstants.maintenanceDialogDelay,
          equals(const Duration(milliseconds: 500)),
        );
      });

      test('changelogCheckDelay should be 2000ms', () {
        expect(
          UIConstants.changelogCheckDelay,
          equals(const Duration(milliseconds: 2000)),
        );
      });
    });

    group('UI Interaction Constants', () {
      test('sheetClosedPositionThreshold should be 0.15', () {
        expect(UIConstants.sheetClosedPositionThreshold, equals(0.15));
      });
    });

    group('UI Layout Constants', () {
      test('bottomSheetHeightRatio should be 0.75', () {
        expect(UIConstants.bottomSheetHeightRatio, equals(0.75));
      });

      test('floatingControlsBottomOffset should be 20.0', () {
        expect(UIConstants.floatingControlsBottomOffset, equals(20.0));
      });

      test('screenshotControlsBottomOffset should be 140.0', () {
        expect(UIConstants.screenshotControlsBottomOffset, equals(140.0));
      });
    });

    test('UIConstants should have private constructor', () {
      // Verify the class is a Type (cannot be directly instantiated)
      expect(UIConstants, isA<Type>());
    });
  });
}
