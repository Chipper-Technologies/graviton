import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/auth_provider_type.dart';
import 'package:graviton/enums/user_avatar.dart';
import 'package:graviton/models/user_profile.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../test_mocks.mocks.dart';

@GenerateMocks([User, UserInfo])
void main() {
  group('UserProfile', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('fromFirebaseUser creates profile with all fields', () async {
      final mockUser = MockUser();
      final mockProviderData = [MockUserInfo()];
      final mockMetadata = MockUserMetadata();

      when(mockUser.uid).thenReturn('test-uid');
      when(mockUser.email).thenReturn('test@example.com');
      when(mockUser.displayName).thenReturn('Test User');
      when(mockUser.photoURL).thenReturn('https://example.com/photo.jpg');
      when(mockUser.isAnonymous).thenReturn(false);
      when(mockUser.providerData).thenReturn(mockProviderData);
      when(mockUser.metadata).thenReturn(mockMetadata);
      when(mockMetadata.creationTime).thenReturn(DateTime(2023, 1, 1));
      when(mockMetadata.lastSignInTime).thenReturn(DateTime(2023, 6, 1));
      when(mockProviderData.first.providerId).thenReturn('google.com');

      final profile = await UserProfile.fromFirebaseUser(
        mockUser,
        avatar: UserAvatar.earth,
      );

      expect(profile.uid, 'test-uid');
      expect(profile.email, 'test@example.com');
      expect(profile.displayName, 'Test User');
      expect(profile.photoUrl, 'https://example.com/photo.jpg');
      expect(profile.isAnonymous, false);
      expect(profile.avatar, UserAvatar.earth);
      expect(profile.authProvider, AuthProviderType.google);
    });

    test('fromFirebaseUser handles anonymous user', () async {
      final mockUser = MockUser();
      final mockMetadata = MockUserMetadata();

      when(mockUser.uid).thenReturn('anon-uid');
      when(mockUser.email).thenReturn(null);
      when(mockUser.displayName).thenReturn(null);
      when(mockUser.photoURL).thenReturn(null);
      when(mockUser.isAnonymous).thenReturn(true);
      when(mockUser.providerData).thenReturn([]);
      when(mockUser.metadata).thenReturn(mockMetadata);
      when(mockMetadata.creationTime).thenReturn(DateTime(2023, 1, 1));
      when(mockMetadata.lastSignInTime).thenReturn(DateTime(2023, 6, 1));

      final profile = await UserProfile.fromFirebaseUser(mockUser);

      expect(profile.uid, 'anon-uid');
      expect(profile.email, null);
      expect(profile.displayName, null);
      expect(profile.photoUrl, null);
      expect(profile.isAnonymous, true);
      expect(profile.avatar, null);
      expect(profile.authProvider, AuthProviderType.anonymous);
    });

    test('fromFirebaseUser handles email/password user', () async {
      final mockUser = MockUser();
      final mockProviderData = [MockUserInfo()];
      final mockMetadata = MockUserMetadata();

      when(mockUser.uid).thenReturn('email-uid');
      when(mockUser.email).thenReturn('user@example.com');
      when(mockUser.displayName).thenReturn('Email User');
      when(mockUser.photoURL).thenReturn(null);
      when(mockUser.isAnonymous).thenReturn(false);
      when(mockUser.providerData).thenReturn(mockProviderData);
      when(mockUser.metadata).thenReturn(mockMetadata);
      when(mockMetadata.creationTime).thenReturn(DateTime(2023, 1, 1));
      when(mockMetadata.lastSignInTime).thenReturn(DateTime(2023, 6, 1));
      when(mockProviderData.first.providerId).thenReturn('password');

      final profile = await UserProfile.fromFirebaseUser(
        mockUser,
        avatar: UserAvatar.mars,
      );

      expect(profile.authProvider, AuthProviderType.emailPassword);
      expect(profile.avatar, UserAvatar.mars);
    });

    test(
      'fromFirebaseUser uses last auth provider from SharedPreferences',
      () async {
        // Setup: User has both Google and Apple linked
        final mockUser = MockUser();
        final mockProviderData = [
          MockUserInfo(), // Google (first in list)
          MockUserInfo(), // Apple (second in list)
        ];
        final mockMetadata = MockUserMetadata();

        when(mockUser.uid).thenReturn('multi-provider-uid');
        when(mockUser.email).thenReturn('user@example.com');
        when(mockUser.displayName).thenReturn('Multi User');
        when(mockUser.photoURL).thenReturn(null);
        when(mockUser.isAnonymous).thenReturn(false);
        when(mockUser.providerData).thenReturn(mockProviderData);
        when(mockUser.metadata).thenReturn(mockMetadata);
        when(mockMetadata.creationTime).thenReturn(DateTime(2023, 1, 1));
        when(mockMetadata.lastSignInTime).thenReturn(DateTime(2023, 6, 1));
        when(mockProviderData[0].providerId).thenReturn('google.com');
        when(mockProviderData[1].providerId).thenReturn('apple.com');

        // Save Apple as the last used provider
        SharedPreferences.setMockInitialValues({
          'last_auth_provider_multi-provider-uid': 'apple.com',
        });

        final profile = await UserProfile.fromFirebaseUser(mockUser);

        // Should use Apple (from SharedPreferences) not Google (first in providerData)
        expect(profile.authProvider, AuthProviderType.apple);
      },
    );

    test(
      'fromFirebaseUser falls back to first provider when no saved preference',
      () async {
        // Setup: User has both Google and Apple linked
        final mockUser = MockUser();
        final mockProviderData = [
          MockUserInfo(), // Google (first in list)
          MockUserInfo(), // Apple (second in list)
        ];
        final mockMetadata = MockUserMetadata();

        when(mockUser.uid).thenReturn('multi-provider-uid-2');
        when(mockUser.email).thenReturn('user2@example.com');
        when(mockUser.displayName).thenReturn('User 2');
        when(mockUser.photoURL).thenReturn(null);
        when(mockUser.isAnonymous).thenReturn(false);
        when(mockUser.providerData).thenReturn(mockProviderData);
        when(mockUser.metadata).thenReturn(mockMetadata);
        when(mockMetadata.creationTime).thenReturn(DateTime(2023, 1, 1));
        when(mockMetadata.lastSignInTime).thenReturn(DateTime(2023, 6, 1));
        when(mockProviderData[0].providerId).thenReturn('google.com');
        when(mockProviderData[1].providerId).thenReturn('apple.com');

        // No saved preference - SharedPreferences is empty
        final profile = await UserProfile.fromFirebaseUser(mockUser);

        // Should fall back to first provider (Google)
        expect(profile.authProvider, AuthProviderType.google);
      },
    );

    test(
      'fromFirebaseUser handles invalid saved provider ID gracefully',
      () async {
        final mockUser = MockUser();
        final mockProviderData = [MockUserInfo()];
        final mockMetadata = MockUserMetadata();

        when(mockUser.uid).thenReturn('test-uid-3');
        when(mockUser.email).thenReturn('user3@example.com');
        when(mockUser.displayName).thenReturn('User 3');
        when(mockUser.photoURL).thenReturn(null);
        when(mockUser.isAnonymous).thenReturn(false);
        when(mockUser.providerData).thenReturn(mockProviderData);
        when(mockUser.metadata).thenReturn(mockMetadata);
        when(mockMetadata.creationTime).thenReturn(DateTime(2023, 1, 1));
        when(mockMetadata.lastSignInTime).thenReturn(DateTime(2023, 6, 1));
        when(mockProviderData.first.providerId).thenReturn('google.com');

        // Save an invalid/unknown provider ID
        SharedPreferences.setMockInitialValues({
          'last_auth_provider_test-uid-3': 'invalid-provider.com',
        });

        final profile = await UserProfile.fromFirebaseUser(mockUser);

        // Should handle invalid provider and fall back to actual provider
        // (fromProviderId returns null for unknown IDs, so it falls back to first provider)
        expect(profile.authProvider, isNotNull);
      },
    );

    test('toJson serializes correctly', () {
      final profile = UserProfile(
        uid: 'test-uid',
        email: 'test@example.com',
        displayName: 'Test User',
        photoUrl: 'https://example.com/photo.jpg',
        isAnonymous: false,
        avatar: UserAvatar.jupiter,
        authProvider: AuthProviderType.google,
      );

      final json = profile.toJson();

      expect(json['uid'], 'test-uid');
      expect(json['email'], 'test@example.com');
      expect(json['displayName'], 'Test User');
      expect(json['photoUrl'], 'https://example.com/photo.jpg');
      expect(json['isAnonymous'], false);
      expect(json['avatar'], 'jupiter');
      expect(json['authProvider'], 'google.com');
    });

    test('toJson handles null values', () {
      final profile = UserProfile(
        uid: 'test-uid',
        email: null,
        displayName: null,
        photoUrl: null,
        isAnonymous: true,
        avatar: null,
        authProvider: AuthProviderType.anonymous,
      );

      final json = profile.toJson();

      expect(json['uid'], 'test-uid');
      expect(json['email'], null);
      expect(json['displayName'], null);
      expect(json['photoUrl'], null);
      expect(json['isAnonymous'], true);
      expect(json['avatar'], null);
      expect(json['authProvider'], 'anonymous');
    });

    test('fromJson deserializes correctly', () {
      final json = {
        'uid': 'test-uid',
        'email': 'test@example.com',
        'displayName': 'Test User',
        'photoUrl': 'https://example.com/photo.jpg',
        'isAnonymous': false,
        'avatar': 'saturn',
        'authProvider': 'apple.com',
      };

      final profile = UserProfile.fromJson(json);

      expect(profile.uid, 'test-uid');
      expect(profile.email, 'test@example.com');
      expect(profile.displayName, 'Test User');
      expect(profile.photoUrl, 'https://example.com/photo.jpg');
      expect(profile.isAnonymous, false);
      expect(profile.avatar, UserAvatar.saturn);
      expect(profile.authProvider, AuthProviderType.apple);
    });

    test('fromJson handles null avatar', () {
      final json = {
        'uid': 'test-uid',
        'email': null,
        'displayName': null,
        'photoUrl': null,
        'isAnonymous': true,
        'avatar': null,
        'authProvider': 'anonymous',
      };

      final profile = UserProfile.fromJson(json);

      expect(profile.avatar, null);
    });

    test('copyWith updates specified fields', () {
      final original = UserProfile(
        uid: 'test-uid',
        email: 'test@example.com',
        displayName: 'Test User',
        photoUrl: 'https://example.com/photo.jpg',
        isAnonymous: false,
        avatar: UserAvatar.earth,
        authProvider: AuthProviderType.google,
      );

      final updated = original.copyWith(
        displayName: 'Updated User',
        avatar: UserAvatar.mars,
      );

      expect(updated.uid, 'test-uid');
      expect(updated.email, 'test@example.com');
      expect(updated.displayName, 'Updated User');
      expect(updated.photoUrl, 'https://example.com/photo.jpg');
      expect(updated.isAnonymous, false);
      expect(updated.avatar, UserAvatar.mars);
      expect(updated.authProvider, AuthProviderType.google);
    });

    test('copyWith with no arguments returns identical profile', () {
      final original = UserProfile(
        uid: 'test-uid',
        email: 'test@example.com',
        displayName: 'Test User',
        photoUrl: null,
        isAnonymous: false,
        avatar: UserAvatar.neptune,
        authProvider: AuthProviderType.emailPassword,
      );

      final copied = original.copyWith();

      expect(copied.uid, original.uid);
      expect(copied.email, original.email);
      expect(copied.displayName, original.displayName);
      expect(copied.photoUrl, original.photoUrl);
      expect(copied.isAnonymous, original.isAnonymous);
      expect(copied.avatar, original.avatar);
      expect(copied.authProvider, original.authProvider);
    });

    test('toJson includes timestamps when present', () {
      final createdAt = DateTime(2023, 1, 1);
      final lastSignInAt = DateTime(2023, 6, 1);

      final profile = UserProfile(
        uid: 'test-uid',
        email: 'test@example.com',
        displayName: 'Test User',
        photoUrl: null,
        isAnonymous: false,
        avatar: UserAvatar.sun,
        authProvider: AuthProviderType.google,
        createdAt: createdAt,
        lastSignInAt: lastSignInAt,
      );

      final json = profile.toJson();

      expect(json['createdAt'], createdAt.toIso8601String());
      expect(json['lastSignInAt'], lastSignInAt.toIso8601String());
    });

    test('toJson handles null timestamps', () {
      final profile = UserProfile(
        uid: 'test-uid',
        email: 'test@example.com',
        displayName: 'Test User',
        photoUrl: null,
        isAnonymous: false,
        avatar: UserAvatar.moon,
        authProvider: AuthProviderType.emailPassword,
        createdAt: null,
        lastSignInAt: null,
      );

      final json = profile.toJson();

      expect(json['createdAt'], null);
      expect(json['lastSignInAt'], null);
    });

    test('fromJson parses timestamps correctly', () {
      final createdAt = DateTime(2023, 1, 1);
      final lastSignInAt = DateTime(2023, 6, 1);

      final json = {
        'uid': 'test-uid',
        'email': 'test@example.com',
        'displayName': 'Test User',
        'photoUrl': null,
        'isAnonymous': false,
        'avatar': 'comet',
        'authProvider': 'google.com',
        'createdAt': createdAt.toIso8601String(),
        'lastSignInAt': lastSignInAt.toIso8601String(),
      };

      final profile = UserProfile.fromJson(json);

      expect(profile.createdAt, createdAt);
      expect(profile.lastSignInAt, lastSignInAt);
    });

    test('fromJson handles missing timestamps', () {
      final json = {
        'uid': 'test-uid',
        'email': 'test@example.com',
        'displayName': 'Test User',
        'photoUrl': null,
        'isAnonymous': false,
        'avatar': 'asteroid',
        'authProvider': 'password',
      };

      final profile = UserProfile.fromJson(json);

      expect(profile.createdAt, null);
      expect(profile.lastSignInAt, null);
    });

    test('toString returns formatted string', () {
      final profile = UserProfile(
        uid: 'test-uid',
        email: 'test@example.com',
        displayName: 'Test User',
        photoUrl: null,
        isAnonymous: false,
        avatar: UserAvatar.nebula,
        authProvider: AuthProviderType.google,
      );

      final string = profile.toString();

      expect(string, contains('test-uid'));
      expect(string, contains('test@example.com'));
      expect(string, contains('Test User'));
      expect(string, contains('false'));
      expect(string, contains('Google'));
    });

    test('toString handles anonymous user', () {
      final profile = UserProfile(
        uid: 'anon-uid',
        email: null,
        displayName: null,
        photoUrl: null,
        isAnonymous: true,
        avatar: null,
        authProvider: AuthProviderType.anonymous,
      );

      final string = profile.toString();

      expect(string, contains('anon-uid'));
      expect(string, contains('true'));
      expect(string, contains('Anonymous'));
    });

    test('equality operator compares all fields', () {
      final profile1 = UserProfile(
        uid: 'test-uid',
        email: 'test@example.com',
        displayName: 'Test User',
        photoUrl: 'https://example.com/photo.jpg',
        isAnonymous: false,
        avatar: UserAvatar.blackHole,
        authProvider: AuthProviderType.google,
      );

      final profile2 = UserProfile(
        uid: 'test-uid',
        email: 'test@example.com',
        displayName: 'Test User',
        photoUrl: 'https://example.com/photo.jpg',
        isAnonymous: false,
        avatar: UserAvatar.blackHole,
        authProvider: AuthProviderType.google,
      );

      expect(profile1, equals(profile2));
    });

    test('equality operator returns false for different profiles', () {
      final profile1 = UserProfile(
        uid: 'test-uid-1',
        email: 'test1@example.com',
        displayName: 'Test User 1',
        photoUrl: null,
        isAnonymous: false,
        avatar: UserAvatar.star,
        authProvider: AuthProviderType.google,
      );

      final profile2 = UserProfile(
        uid: 'test-uid-2',
        email: 'test2@example.com',
        displayName: 'Test User 2',
        photoUrl: null,
        isAnonymous: false,
        avatar: UserAvatar.galaxy,
        authProvider: AuthProviderType.apple,
      );

      expect(profile1, isNot(equals(profile2)));
    });

    test('equality operator handles identical reference', () {
      final profile = UserProfile(
        uid: 'test-uid',
        email: 'test@example.com',
        displayName: 'Test User',
        photoUrl: null,
        isAnonymous: false,
        avatar: UserAvatar.supernova,
        authProvider: AuthProviderType.emailPassword,
      );

      expect(profile, equals(profile));
    });

    test('hashCode is consistent for equal objects', () {
      final profile1 = UserProfile(
        uid: 'test-uid',
        email: 'test@example.com',
        displayName: 'Test User',
        photoUrl: null,
        isAnonymous: false,
        avatar: UserAvatar.neutronStar,
        authProvider: AuthProviderType.google,
      );

      final profile2 = UserProfile(
        uid: 'test-uid',
        email: 'test@example.com',
        displayName: 'Test User',
        photoUrl: null,
        isAnonymous: false,
        avatar: UserAvatar.neutronStar,
        authProvider: AuthProviderType.google,
      );

      expect(profile1.hashCode, equals(profile2.hashCode));
    });

    test('hashCode differs for different objects', () {
      final profile1 = UserProfile(
        uid: 'test-uid-1',
        email: 'test1@example.com',
        displayName: 'Test User 1',
        photoUrl: null,
        isAnonymous: false,
        avatar: UserAvatar.mercury,
        authProvider: AuthProviderType.google,
      );

      final profile2 = UserProfile(
        uid: 'test-uid-2',
        email: 'test2@example.com',
        displayName: 'Test User 2',
        photoUrl: null,
        isAnonymous: false,
        avatar: UserAvatar.venus,
        authProvider: AuthProviderType.apple,
      );

      expect(profile1.hashCode, isNot(equals(profile2.hashCode)));
    });

    test('fromFirebaseUser handles all auth provider types', () async {
      final testCases = [
        ('google.com', AuthProviderType.google),
        ('apple.com', AuthProviderType.apple),
        ('facebook.com', AuthProviderType.facebook),
        ('password', AuthProviderType.emailPassword),
      ];

      for (final testCase in testCases) {
        final mockUser = MockUser();
        final mockProviderData = [MockUserInfo()];
        final mockMetadata = MockUserMetadata();

        when(mockUser.uid).thenReturn('test-uid');
        when(mockUser.email).thenReturn('test@example.com');
        when(mockUser.displayName).thenReturn('Test User');
        when(mockUser.photoURL).thenReturn(null);
        when(mockUser.isAnonymous).thenReturn(false);
        when(mockUser.providerData).thenReturn(mockProviderData);
        when(mockUser.metadata).thenReturn(mockMetadata);
        when(mockMetadata.creationTime).thenReturn(DateTime(2023, 1, 1));
        when(mockMetadata.lastSignInTime).thenReturn(DateTime(2023, 6, 1));
        when(mockProviderData.first.providerId).thenReturn(testCase.$1);

        final profile = await UserProfile.fromFirebaseUser(mockUser);

        expect(
          profile.authProvider,
          testCase.$2,
          reason: 'Provider ${testCase.$1} should map to ${testCase.$2}',
        );
      }
    });

    test('copyWith allows updating timestamps', () {
      final original = UserProfile(
        uid: 'test-uid',
        email: 'test@example.com',
        displayName: 'Test User',
        photoUrl: null,
        isAnonymous: false,
        avatar: UserAvatar.jupiter,
        authProvider: AuthProviderType.google,
        createdAt: DateTime(2023, 1, 1),
        lastSignInAt: DateTime(2023, 6, 1),
      );

      final newLastSignIn = DateTime(2023, 12, 1);
      final updated = original.copyWith(lastSignInAt: newLastSignIn);

      expect(updated.createdAt, original.createdAt);
      expect(updated.lastSignInAt, newLastSignIn);
    });

    test('fromJson handles invalid avatar ID gracefully', () {
      final json = {
        'uid': 'test-uid',
        'email': 'test@example.com',
        'displayName': 'Test User',
        'photoUrl': null,
        'isAnonymous': false,
        'avatar': 'invalid_avatar_id',
        'authProvider': 'google.com',
      };

      final profile = UserProfile.fromJson(json);

      expect(profile.avatar, null);
    });

    test('fromJson handles invalid provider ID gracefully', () {
      final json = {
        'uid': 'test-uid',
        'email': 'test@example.com',
        'displayName': 'Test User',
        'photoUrl': null,
        'isAnonymous': false,
        'avatar': 'earth',
        'authProvider': 'invalid_provider_id',
      };

      final profile = UserProfile.fromJson(json);

      expect(profile.authProvider, null);
    });
  });
}
