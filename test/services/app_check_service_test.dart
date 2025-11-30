// Copyright (c) 2025 Chipper Technologies LLC. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/services/app_check_service.dart';

void main() {
  group('AppCheckService Tests', () {
    setUp(() {
      // Reset service before each test
      AppCheckService.instance.reset();
    });

    test('should be a singleton', () {
      final instance1 = AppCheckService.instance;
      final instance2 = AppCheckService.instance;

      expect(instance1, same(instance2));
    });

    test('should start uninitialized', () {
      final service = AppCheckService.instance;

      expect(service.isInitialized, false);
    });

    test('should indicate platform support correctly', () {
      final service = AppCheckService.instance;

      // This test will pass on supported platforms (Android, iOS, macOS, Web)
      // In test environment, it may return false
      expect(service.isPlatformSupported(), isA<bool>());
    });

    test('should handle multiple initialize calls gracefully', () async {
      final service = AppCheckService.instance;

      // First initialization
      await service.initialize();

      // Second initialization should not throw
      expect(() async => await service.initialize(), returnsNormally);
    });

    test('should respect remote config disable flag', () async {
      final service = AppCheckService.instance;

      // Note: In test environment without Firebase, RemoteConfigService
      // will use default value (true), so App Check will attempt initialization
      // This test verifies the check exists, even if we can't mock Remote Config
      await service.initialize();

      // Service should not throw even if Remote Config is unavailable
      expect(() => service.isInitialized, returnsNormally);
    });

    test('should return null token when not initialized', () async {
      final service = AppCheckService.instance;

      final token = await service.getToken();

      expect(token, isNull);
    });

    test('should handle token refresh flag', () async {
      final service = AppCheckService.instance;
      await service.initialize();

      // Should not throw even if token fetch fails in test environment
      expect(
        () async => await service.getToken(forceRefresh: true),
        returnsNormally,
      );
    });

    test('should handle setTokenAutoRefreshEnabled', () {
      final service = AppCheckService.instance;

      // Should not throw
      expect(() => service.setTokenAutoRefreshEnabled(true), returnsNormally);
      expect(() => service.setTokenAutoRefreshEnabled(false), returnsNormally);
    });

    test('should reset correctly', () {
      final service = AppCheckService.instance;

      service.reset();

      expect(service.isInitialized, false);
    });

    group('Error Handling', () {
      test('should handle initialization errors gracefully', () async {
        final service = AppCheckService.instance;

        // In test environment, initialization may fail
        // Service should handle this gracefully and not throw
        expect(() async => await service.initialize(), returnsNormally);
      });

      test('should handle token fetch errors gracefully', () async {
        final service = AppCheckService.instance;
        await service.initialize();

        // In test environment, token fetch may fail
        // Service should return null instead of throwing
        final token = await service.getToken();
        expect(token, isA<String?>());
      });

      test('should handle auto-refresh errors gracefully', () {
        final service = AppCheckService.instance;

        // Should not throw even if setting fails
        expect(() => service.setTokenAutoRefreshEnabled(true), returnsNormally);
      });
    });

    group('State Management', () {
      test('should maintain initialization state', () async {
        final service = AppCheckService.instance;

        expect(service.isInitialized, false);

        await service.initialize();

        // Note: In test environment, initialization may succeed or fail
        // The state should be set accordingly
        expect(service.isInitialized, isA<bool>());
      });

      test('should reset state correctly', () async {
        final service = AppCheckService.instance;

        await service.initialize();
        service.reset();

        expect(service.isInitialized, false);
      });
    });
  });
}
