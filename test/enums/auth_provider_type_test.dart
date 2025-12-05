import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/auth_provider_type.dart';

void main() {
  group('AuthProviderType', () {
    test('has correct number of provider types', () {
      expect(AuthProviderType.values.length, 6);
    });

    test('emailPassword has correct provider ID', () {
      expect(AuthProviderType.emailPassword.providerId, 'password');
    });

    test('google has correct provider ID', () {
      expect(AuthProviderType.google.providerId, 'google.com');
    });

    test('apple has correct provider ID', () {
      expect(AuthProviderType.apple.providerId, 'apple.com');
    });

    test('facebook has correct provider ID', () {
      expect(AuthProviderType.facebook.providerId, 'facebook.com');
    });

    test('anonymous has correct provider ID', () {
      expect(AuthProviderType.anonymous.providerId, 'anonymous');
    });

    test('all provider types have non-empty display names', () {
      for (final provider in AuthProviderType.values) {
        expect(provider.displayName.isNotEmpty, true);
      }
    });

    test('fromProviderId returns correct provider type', () {
      expect(
        AuthProviderType.fromProviderId('password'),
        AuthProviderType.emailPassword,
      );
      expect(
        AuthProviderType.fromProviderId('google.com'),
        AuthProviderType.google,
      );
      expect(
        AuthProviderType.fromProviderId('apple.com'),
        AuthProviderType.apple,
      );
      expect(
        AuthProviderType.fromProviderId('facebook.com'),
        AuthProviderType.facebook,
      );
      expect(
        AuthProviderType.fromProviderId('anonymous'),
        AuthProviderType.anonymous,
      );
    });

    test('fromProviderId returns null for unknown provider ID', () {
      expect(AuthProviderType.fromProviderId('unknown'), null);
      expect(AuthProviderType.fromProviderId(''), null);
      expect(AuthProviderType.fromProviderId('twitter.com'), null);
    });

    test('all provider IDs are unique', () {
      final providerIds = AuthProviderType.values
          .map((provider) => provider.providerId)
          .toSet();
      expect(providerIds.length, AuthProviderType.values.length);
    });
  });
}
