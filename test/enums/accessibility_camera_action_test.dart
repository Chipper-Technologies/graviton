import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/accessibility_camera_action.dart';

void main() {
  group('AccessibilityCameraAction', () {
    test('should have correct string values', () {
      expect(AccessibilityCameraAction.reset.value, 'reset');
      expect(AccessibilityCameraAction.focus.value, 'focus');
      expect(AccessibilityCameraAction.follow.value, 'follow');
      expect(AccessibilityCameraAction.unfollow.value, 'unfollow');
    });

    test('fromString should return correct enum values', () {
      expect(
        AccessibilityCameraAction.fromString('reset'),
        AccessibilityCameraAction.reset,
      );
      expect(
        AccessibilityCameraAction.fromString('RESET'),
        AccessibilityCameraAction.reset,
      );
      expect(
        AccessibilityCameraAction.fromString('focus'),
        AccessibilityCameraAction.focus,
      );
      expect(
        AccessibilityCameraAction.fromString('FOCUS'),
        AccessibilityCameraAction.focus,
      );
      expect(
        AccessibilityCameraAction.fromString('follow'),
        AccessibilityCameraAction.follow,
      );
      expect(
        AccessibilityCameraAction.fromString('FOLLOW'),
        AccessibilityCameraAction.follow,
      );
      expect(
        AccessibilityCameraAction.fromString('unfollow'),
        AccessibilityCameraAction.unfollow,
      );
      expect(
        AccessibilityCameraAction.fromString('UNFOLLOW'),
        AccessibilityCameraAction.unfollow,
      );
    });

    test('fromString should return reset as default for unknown values', () {
      expect(
        AccessibilityCameraAction.fromString('unknown'),
        AccessibilityCameraAction.reset,
      );
      expect(
        AccessibilityCameraAction.fromString(''),
        AccessibilityCameraAction.reset,
      );
      expect(
        AccessibilityCameraAction.fromString('invalid_action'),
        AccessibilityCameraAction.reset,
      );
    });

    test('should handle case insensitive matching', () {
      expect(
        AccessibilityCameraAction.fromString('Reset'),
        AccessibilityCameraAction.reset,
      );
      expect(
        AccessibilityCameraAction.fromString('Focus'),
        AccessibilityCameraAction.focus,
      );
      expect(
        AccessibilityCameraAction.fromString('Follow'),
        AccessibilityCameraAction.follow,
      );
      expect(
        AccessibilityCameraAction.fromString('Unfollow'),
        AccessibilityCameraAction.unfollow,
      );
    });
  });
}
