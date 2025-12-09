import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/core/enums/user_avatar.dart';

void main() {
  group('UserAvatar', () {
    test('has correct number of avatars', () {
      expect(UserAvatar.values.length, 18);
    });

    test('all avatars have unique IDs', () {
      final ids = UserAvatar.values.map((avatar) => avatar.id).toSet();
      expect(ids.length, UserAvatar.values.length);
    });

    test('all avatars have non-empty emojis', () {
      for (final avatar in UserAvatar.values) {
        expect(avatar.emoji.isNotEmpty, true);
      }
    });

    test('fromId returns correct avatar', () {
      expect(UserAvatar.fromId('sun'), UserAvatar.sun);
      expect(UserAvatar.fromId('earth'), UserAvatar.earth);
      expect(UserAvatar.fromId('mars'), UserAvatar.mars);
      expect(UserAvatar.fromId('jupiter'), UserAvatar.jupiter);
      expect(UserAvatar.fromId('saturn'), UserAvatar.saturn);
      expect(UserAvatar.fromId('neptune'), UserAvatar.neptune);
    });

    test('fromId returns null for unknown ID', () {
      expect(UserAvatar.fromId('unknown'), null);
      expect(UserAvatar.fromId(''), null);
      expect(UserAvatar.fromId('invalid_avatar'), null);
    });

    test('random returns valid avatar', () {
      for (int i = 0; i < 100; i++) {
        final randomAvatar = UserAvatar.random();
        expect(UserAvatar.values.contains(randomAvatar), true);
      }
    });

    test('all expected avatars exist', () {
      final expectedAvatars = [
        'sun',
        'mercury',
        'venus',
        'earth',
        'mars',
        'jupiter',
        'saturn',
        'uranus',
        'neptune',
        'moon',
        'star',
        'comet',
        'galaxy',
        'black_hole',
        'neutron_star',
        'asteroid',
        'nebula',
        'supernova',
      ];

      for (final id in expectedAvatars) {
        final avatar = UserAvatar.fromId(id);
        expect(avatar?.id, id);
      }
    });
  });
}
