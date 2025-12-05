import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/screen_mode.dart';

void main() {
  group('ScreenMode', () {
    test('should have all expected values', () {
      expect(ScreenMode.values.length, equals(5));
      expect(ScreenMode.values, contains(ScreenMode.accountView));
      expect(ScreenMode.values, contains(ScreenMode.signIn));
      expect(ScreenMode.values, contains(ScreenMode.avatarSelection));
      expect(ScreenMode.values, contains(ScreenMode.editName));
      expect(ScreenMode.values, contains(ScreenMode.deleteConfirmation));
    });

    test('should have correct enum names', () {
      expect(ScreenMode.accountView.name, equals('accountView'));
      expect(ScreenMode.signIn.name, equals('signIn'));
      expect(ScreenMode.avatarSelection.name, equals('avatarSelection'));
      expect(ScreenMode.editName.name, equals('editName'));
      expect(ScreenMode.deleteConfirmation.name, equals('deleteConfirmation'));
    });

    test('should be comparable', () {
      expect(ScreenMode.accountView == ScreenMode.accountView, isTrue);
      expect(ScreenMode.accountView == ScreenMode.signIn, isFalse);
      expect(ScreenMode.signIn == ScreenMode.signIn, isTrue);
    });

    test('should support switch statements', () {
      String getDescription(ScreenMode mode) {
        switch (mode) {
          case ScreenMode.accountView:
            return 'Account View';
          case ScreenMode.signIn:
            return 'Sign In';
          case ScreenMode.avatarSelection:
            return 'Avatar Selection';
          case ScreenMode.editName:
            return 'Edit Name';
          case ScreenMode.deleteConfirmation:
            return 'Delete Confirmation';
        }
      }

      expect(getDescription(ScreenMode.accountView), equals('Account View'));
      expect(getDescription(ScreenMode.signIn), equals('Sign In'));
      expect(
        getDescription(ScreenMode.avatarSelection),
        equals('Avatar Selection'),
      );
      expect(getDescription(ScreenMode.editName), equals('Edit Name'));
      expect(
        getDescription(ScreenMode.deleteConfirmation),
        equals('Delete Confirmation'),
      );
    });

    test('should have correct index values', () {
      expect(ScreenMode.accountView.index, equals(0));
      expect(ScreenMode.signIn.index, equals(1));
      expect(ScreenMode.avatarSelection.index, equals(2));
      expect(ScreenMode.editName.index, equals(3));
      expect(ScreenMode.deleteConfirmation.index, equals(4));
    });

    test('should support iteration', () {
      final modes = <ScreenMode>[];
      for (final mode in ScreenMode.values) {
        modes.add(mode);
      }
      expect(modes.length, equals(5));
      expect(modes[0], equals(ScreenMode.accountView));
      expect(modes[1], equals(ScreenMode.signIn));
      expect(modes[2], equals(ScreenMode.avatarSelection));
      expect(modes[3], equals(ScreenMode.editName));
      expect(modes[4], equals(ScreenMode.deleteConfirmation));
    });

    test('should support toString', () {
      expect(
        ScreenMode.accountView.toString(),
        equals('ScreenMode.accountView'),
      );
      expect(ScreenMode.signIn.toString(), equals('ScreenMode.signIn'));
      expect(
        ScreenMode.avatarSelection.toString(),
        equals('ScreenMode.avatarSelection'),
      );
      expect(ScreenMode.editName.toString(), equals('ScreenMode.editName'));
      expect(
        ScreenMode.deleteConfirmation.toString(),
        equals('ScreenMode.deleteConfirmation'),
      );
    });

    test('should be usable in collections', () {
      final set = {
        ScreenMode.accountView,
        ScreenMode.signIn,
        ScreenMode.accountView, // ignore: equal_elements_in_set
      };
      expect(set.length, equals(2)); // Duplicates removed

      final map = {ScreenMode.accountView: 'view', ScreenMode.signIn: 'auth'};
      expect(map[ScreenMode.accountView], equals('view'));
      expect(map[ScreenMode.signIn], equals('auth'));
    });

    test('should maintain value order', () {
      final values = ScreenMode.values;
      expect(values[0], equals(ScreenMode.accountView));
      expect(values[1], equals(ScreenMode.signIn));
      expect(values[2], equals(ScreenMode.avatarSelection));
      expect(values[3], equals(ScreenMode.editName));
      expect(values[4], equals(ScreenMode.deleteConfirmation));
    });
  });
}
