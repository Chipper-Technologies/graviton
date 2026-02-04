import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/config/flavor_config.dart';
import 'package:graviton/core/enums/app_flavor.dart';

void main() {
  group('FlavorConfig', () {
    late FlavorConfig flavorConfig;

    setUp(() {
      // Get the singleton instance for testing
      flavorConfig = FlavorConfig.instance;
      // Reset to default state for predictable testing
      flavorConfig.initialize(flavor: AppFlavor.prod);
    });

    group('Singleton Pattern', () {
      test('should return same instance on multiple calls', () {
        final instance1 = FlavorConfig.instance;
        final instance2 = FlavorConfig.instance;

        expect(instance1, isA<FlavorConfig>());
        expect(instance2, isA<FlavorConfig>());
        expect(identical(instance1, instance2), isTrue);
      });

      test('should maintain singleton behavior across the application', () {
        final instance1 = FlavorConfig.instance;
        final instance2 = FlavorConfig.instance;

        // Modify one instance
        instance1.initialize(flavor: AppFlavor.dev, appName: 'Test App');

        // Both should reflect the same state
        expect(instance2.flavor, equals(AppFlavor.dev));
        expect(instance2.appName, equals('Test App'));
      });
    });

    group('Default Values', () {
      test('should have default production flavor', () {
        expect(flavorConfig.flavor, equals(AppFlavor.prod));
      });

      test('should have default app name', () {
        expect(flavorConfig.appName, equals('Graviton'));
      });

      test('should indicate production by default', () {
        expect(flavorConfig.isProduction, isTrue);
        expect(flavorConfig.isDevelopment, isFalse);
      });
    });

    group('Initialization', () {
      test('should initialize with dev flavor', () {
        flavorConfig.initialize(flavor: AppFlavor.dev);

        expect(flavorConfig.flavor, equals(AppFlavor.dev));
        expect(flavorConfig.isDevelopment, isTrue);
        expect(flavorConfig.isProduction, isFalse);
      });

      test('should initialize with prod flavor', () {
        flavorConfig.initialize(flavor: AppFlavor.prod);

        expect(flavorConfig.flavor, equals(AppFlavor.prod));
        expect(flavorConfig.isProduction, isTrue);
        expect(flavorConfig.isDevelopment, isFalse);
      });

      test('should initialize with custom app name', () {
        const customName = 'Custom Graviton';
        flavorConfig.initialize(flavor: AppFlavor.dev, appName: customName);

        expect(flavorConfig.appName, equals(customName));
        expect(flavorConfig.flavor, equals(AppFlavor.dev));
      });

      test(
        'should use default app name with suffix when no custom name provided',
        () {
          flavorConfig.initialize(flavor: AppFlavor.dev);
          expect(flavorConfig.appName, equals('Graviton Dev'));

          flavorConfig.initialize(flavor: AppFlavor.prod);
          expect(flavorConfig.appName, equals('Graviton'));
        },
      );

      test('should allow multiple initializations', () {
        // First initialization
        flavorConfig.initialize(flavor: AppFlavor.dev, appName: 'Test App');
        expect(flavorConfig.flavor, equals(AppFlavor.dev));
        expect(flavorConfig.appName, equals('Test App'));

        // Second initialization should override
        flavorConfig.initialize(
          flavor: AppFlavor.prod,
          appName: 'Production App',
        );
        expect(flavorConfig.flavor, equals(AppFlavor.prod));
        expect(flavorConfig.appName, equals('Production App'));
      });
    });

    group('getFlavorValue Method', () {
      test('should return dev value when flavor is dev', () {
        flavorConfig.initialize(flavor: AppFlavor.dev);

        final result = flavorConfig.getFlavorValue<String>(
          dev: 'development_value',
          prod: 'production_value',
        );

        expect(result, equals('development_value'));
      });

      test('should return prod value when flavor is prod', () {
        flavorConfig.initialize(flavor: AppFlavor.prod);

        final result = flavorConfig.getFlavorValue<String>(
          dev: 'development_value',
          prod: 'production_value',
        );

        expect(result, equals('production_value'));
      });

      test('should work with different types - bool', () {
        flavorConfig.initialize(flavor: AppFlavor.dev);

        final result = flavorConfig.getFlavorValue<bool>(
          dev: true,
          prod: false,
        );

        expect(result, isTrue);
      });

      test('should work with different types - int', () {
        flavorConfig.initialize(flavor: AppFlavor.prod);

        final result = flavorConfig.getFlavorValue<int>(dev: 1, prod: 2);

        expect(result, equals(2));
      });

      test('should work with different types - Duration', () {
        flavorConfig.initialize(flavor: AppFlavor.dev);

        const devDuration = Duration(minutes: 1);
        const prodDuration = Duration(hours: 1);

        final result = flavorConfig.getFlavorValue<Duration>(
          dev: devDuration,
          prod: prodDuration,
        );

        expect(result, equals(devDuration));
      });

      test('should work with null values', () {
        flavorConfig.initialize(flavor: AppFlavor.dev);

        final result = flavorConfig.getFlavorValue<String?>(
          dev: null,
          prod: 'production_value',
        );

        expect(result, isNull);
      });
    });

    group('Property Consistency', () {
      test('isDevelopment and isProduction should be mutually exclusive', () {
        // Test dev flavor
        flavorConfig.initialize(flavor: AppFlavor.dev);
        expect(flavorConfig.isDevelopment, isTrue);
        expect(flavorConfig.isProduction, isFalse);

        // Test prod flavor
        flavorConfig.initialize(flavor: AppFlavor.prod);
        expect(flavorConfig.isDevelopment, isFalse);
        expect(flavorConfig.isProduction, isTrue);
      });

      test('should maintain consistency after multiple initializations', () {
        // Start with dev
        flavorConfig.initialize(flavor: AppFlavor.dev);
        expect(flavorConfig.flavor, equals(AppFlavor.dev));
        expect(flavorConfig.isDevelopment, isTrue);

        // Switch to prod
        flavorConfig.initialize(flavor: AppFlavor.prod);
        expect(flavorConfig.flavor, equals(AppFlavor.prod));
        expect(flavorConfig.isProduction, isTrue);

        // Back to dev
        flavorConfig.initialize(flavor: AppFlavor.dev);
        expect(flavorConfig.flavor, equals(AppFlavor.dev));
        expect(flavorConfig.isDevelopment, isTrue);
      });
    });

    group('getPackageName Method', () {
      test('should return dev package name when flavor is dev', () {
        flavorConfig.initialize(flavor: AppFlavor.dev);
        expect(
          flavorConfig.getPackageName(),
          equals('io.chipper.graviton.dev'),
        );
      });

      test('should return prod package name when flavor is prod', () {
        flavorConfig.initialize(flavor: AppFlavor.prod);
        expect(flavorConfig.getPackageName(), equals('io.chipper.graviton'));
      });

      test('should return different package names for different flavors', () {
        flavorConfig.initialize(flavor: AppFlavor.dev);
        final devPackageName = flavorConfig.getPackageName();

        flavorConfig.initialize(flavor: AppFlavor.prod);
        final prodPackageName = flavorConfig.getPackageName();

        expect(devPackageName, isNot(equals(prodPackageName)));
      });
    });

    group('Edge Cases', () {
      test('should handle empty app name string', () {
        flavorConfig.initialize(flavor: AppFlavor.dev, appName: '');
        expect(flavorConfig.appName, equals(''));
      });

      test('should handle app name with special characters', () {
        const specialName = 'Graviton™ [Dev] 🚀';
        flavorConfig.initialize(flavor: AppFlavor.dev, appName: specialName);
        expect(flavorConfig.appName, equals(specialName));
      });

      test('should handle very long app name', () {
        final longName = 'Graviton ${'a' * 1000}';
        flavorConfig.initialize(flavor: AppFlavor.dev, appName: longName);
        expect(flavorConfig.appName, equals(longName));
      });
    });
  });

  group('AppConfig', () {
    late FlavorConfig flavorConfig;

    setUp(() {
      flavorConfig = FlavorConfig.instance;
      // Reset to default state for predictable testing
      flavorConfig.initialize(flavor: AppFlavor.prod);
    });

    test('should access FlavorConfig instance', () {
      expect(AppConfig.flavor, isA<FlavorConfig>());
      expect(identical(AppConfig.flavor, flavorConfig), isTrue);
    });

    group('Configuration Values', () {
      test(
        'should return correct apiUrl for dev flavor',
        () {
          flavorConfig.initialize(flavor: AppFlavor.dev);
          // Environment variables are not set during test execution
          // In production, these are set via --dart-define-from-file
          expect(AppConfig.apiUrl, isA<String>());
        },
        skip: 'Environment variables not available in test environment',
      );

      test(
        'should return correct apiUrl for prod flavor',
        () {
          flavorConfig.initialize(flavor: AppFlavor.prod);
          // Environment variables are not set during test execution
          // In production, these are set via --dart-define-from-file
          expect(AppConfig.apiUrl, isA<String>());
        },
        skip: 'Environment variables not available in test environment',
      );

      test('should return correct analytics setting for dev flavor', () {
        flavorConfig.initialize(flavor: AppFlavor.dev);
        expect(AppConfig.enableAnalytics, isTrue);
      });

      test('should return correct analytics setting for prod flavor', () {
        flavorConfig.initialize(flavor: AppFlavor.prod);
        expect(AppConfig.enableAnalytics, isTrue);
      });

      test('should return correct crashlytics setting for dev flavor', () {
        flavorConfig.initialize(flavor: AppFlavor.dev);
        expect(AppConfig.enableCrashlytics, isFalse);
      });

      test('should return correct crashlytics setting for prod flavor', () {
        flavorConfig.initialize(flavor: AppFlavor.prod);
        expect(AppConfig.enableCrashlytics, isTrue);
      });

      test('should return correct verbose logging setting for dev flavor', () {
        flavorConfig.initialize(flavor: AppFlavor.dev);
        expect(AppConfig.enableVerboseLogging, isTrue);
      });

      test('should return correct verbose logging setting for prod flavor', () {
        flavorConfig.initialize(flavor: AppFlavor.prod);
        expect(AppConfig.enableVerboseLogging, isFalse);
      });

      test('should return correct debug banner setting for dev flavor', () {
        flavorConfig.initialize(flavor: AppFlavor.dev);
        expect(AppConfig.showDebugBanner, isTrue);
      });

      test('should return correct debug banner setting for prod flavor', () {
        flavorConfig.initialize(flavor: AppFlavor.prod);
        expect(AppConfig.showDebugBanner, isFalse);
      });

      test('should return correct remote config interval for dev flavor', () {
        flavorConfig.initialize(flavor: AppFlavor.dev);
        expect(
          AppConfig.remoteConfigFetchInterval,
          equals(const Duration(minutes: 1)),
        );
      });

      test('should return correct remote config interval for prod flavor', () {
        flavorConfig.initialize(flavor: AppFlavor.prod);
        expect(
          AppConfig.remoteConfigFetchInterval,
          equals(const Duration(hours: 1)),
        );
      });

      test('should return correct screenshot mode setting for dev flavor', () {
        flavorConfig.initialize(flavor: AppFlavor.dev);
        expect(AppConfig.enableScreenshotMode, isTrue);
      });

      test('should return correct screenshot mode setting for prod flavor', () {
        flavorConfig.initialize(flavor: AppFlavor.prod);
        expect(AppConfig.enableScreenshotMode, isFalse);
      });
    });

    group('Configuration Consistency', () {
      test('should maintain configuration consistency when flavor changes', () {
        // Test dev configuration
        flavorConfig.initialize(flavor: AppFlavor.dev);
        expect(AppConfig.enableVerboseLogging, isTrue);
        expect(AppConfig.showDebugBanner, isTrue);
        expect(AppConfig.enableCrashlytics, isFalse);

        // Test prod configuration
        flavorConfig.initialize(flavor: AppFlavor.prod);
        expect(AppConfig.enableVerboseLogging, isFalse);
        expect(AppConfig.showDebugBanner, isFalse);
        expect(AppConfig.enableCrashlytics, isTrue);
      });

      test('should return appropriate values for development features', () {
        flavorConfig.initialize(flavor: AppFlavor.dev);

        // Development features should be enabled
        expect(AppConfig.enableVerboseLogging, isTrue);
        expect(AppConfig.showDebugBanner, isTrue);
        expect(AppConfig.enableScreenshotMode, isTrue);

        // Production-only features should be disabled
        expect(AppConfig.enableCrashlytics, isFalse);
      });

      test('should return appropriate values for production features', () {
        flavorConfig.initialize(flavor: AppFlavor.prod);

        // Production features should be enabled
        expect(AppConfig.enableCrashlytics, isTrue);
        expect(AppConfig.enableAnalytics, isTrue);

        // Development-only features should be disabled
        expect(AppConfig.enableVerboseLogging, isFalse);
        expect(AppConfig.showDebugBanner, isFalse);
        expect(AppConfig.enableScreenshotMode, isFalse);
      });
    });

    group('Performance and Memory', () {
      test('should handle rapid flavor switching', () {
        for (int i = 0; i < 100; i++) {
          final flavor = i % 2 == 0 ? AppFlavor.dev : AppFlavor.prod;
          flavorConfig.initialize(flavor: flavor);

          // Verify configuration is consistent
          expect(flavorConfig.flavor, equals(flavor));
          expect(flavorConfig.isDevelopment, equals(flavor == AppFlavor.dev));
          expect(flavorConfig.isProduction, equals(flavor == AppFlavor.prod));
        }
      });

      test('should maintain singleton behavior under stress', () {
        final instances = <FlavorConfig>[];

        for (int i = 0; i < 50; i++) {
          instances.add(FlavorConfig.instance);
        }

        // All instances should be identical
        for (int i = 1; i < instances.length; i++) {
          expect(identical(instances[0], instances[i]), isTrue);
        }
      });
    });

    group('AppFlavor Integration', () {
      test('should properly use AppFlavor suffix property', () {
        // Test dev suffix
        flavorConfig.initialize(flavor: AppFlavor.dev);
        expect(flavorConfig.appName, equals('Graviton Dev'));
        expect(AppFlavor.dev.suffix, equals(' Dev'));

        // Test prod suffix
        flavorConfig.initialize(flavor: AppFlavor.prod);
        expect(flavorConfig.appName, equals('Graviton'));
        expect(AppFlavor.prod.suffix, equals(''));
      });

      test('should properly use AppFlavor boolean properties', () {
        // Test dev properties
        expect(AppFlavor.dev.isDevelopment, isTrue);
        expect(AppFlavor.dev.isProduction, isFalse);

        // Test prod properties
        expect(AppFlavor.prod.isDevelopment, isFalse);
        expect(AppFlavor.prod.isProduction, isTrue);
      });

      test(
        'should maintain consistency between FlavorConfig and AppFlavor',
        () {
          flavorConfig.initialize(flavor: AppFlavor.dev);
          expect(
            flavorConfig.isDevelopment,
            equals(AppFlavor.dev.isDevelopment),
          );
          expect(flavorConfig.isProduction, equals(AppFlavor.dev.isProduction));

          flavorConfig.initialize(flavor: AppFlavor.prod);
          expect(
            flavorConfig.isDevelopment,
            equals(AppFlavor.prod.isDevelopment),
          );
          expect(
            flavorConfig.isProduction,
            equals(AppFlavor.prod.isProduction),
          );
        },
      );
    });

    group('Environment Constants', () {
      test('should have default appVersion', () {
        expect(AppConfig.appVersion, isNotEmpty);
        expect(AppConfig.appVersion, equals('1.0.0'));
      });

      test('should have default buildNumber', () {
        expect(AppConfig.buildNumber, isNotEmpty);
        expect(AppConfig.buildNumber, equals('1'));
      });

      test(
        'should have default githubUrl',
        () {
          // These are compile-time constants, so they should have values
          // But in tests, environment variables are not available
          if (AppConfig.githubUrl.isNotEmpty) {
            expect(
              AppConfig.githubUrl,
              equals('https://github.com/Chipper-Technologies/graviton'),
            );
          }
        },
        skip: 'Environment variables not available in test environment',
      );

      test(
        'should have default websiteUrl',
        () {
          // These are compile-time constants, so they should have values
          // But in tests, environment variables are not available
          if (AppConfig.websiteUrl.isNotEmpty) {
            expect(
              AppConfig.websiteUrl,
              equals('https://chippertechnology.com'),
            );
          }
        },
        skip: 'Environment variables not available in test environment',
      );

      test(
        'should have default privacyPolicyUrl',
        () {
          // These are compile-time constants, so they should have values
          // But in tests, environment variables are not available
          if (AppConfig.privacyPolicyUrl.isNotEmpty) {
            expect(
              AppConfig.privacyPolicyUrl,
              equals('https://chippertechnology.com/privacy-policy/graviton'),
            );
          }
        },
        skip: 'Environment variables not available in test environment',
      );

      test(
        'should have default companyWebsiteUrl',
        () {
          // These are compile-time constants, so they should have values
          // But in tests, environment variables are not available
          if (AppConfig.companyWebsiteUrl.isNotEmpty) {
            expect(
              AppConfig.companyWebsiteUrl,
              equals('https://chippertechnology.com'),
            );
          }
        },
        skip: 'Environment variables not available in test environment',
      );

      test('should have default appLogoPath', () {
        expect(AppConfig.appLogoPath, isNotEmpty);
        expect(AppConfig.appLogoPath, equals('assets/images/app-logo.png'));
      });

      test('should have default chipperLogoPath', () {
        expect(AppConfig.chipperLogoPath, isNotEmpty);
        expect(
          AppConfig.chipperLogoPath,
          equals('assets/images/chipper-logo.svg'),
        );
      });

      test('should have default gravitonLogoPath', () {
        expect(AppConfig.gravitonLogoPath, isNotEmpty);
        expect(
          AppConfig.gravitonLogoPath,
          equals('assets/images/graviton-logo.svg'),
        );
      });

      test('should return valid URLs format', () {
        // Test URL format for non-empty URLs
        // Some URLs may be empty if environment variables aren't set
        if (AppConfig.githubUrl.isNotEmpty) {
          expect(AppConfig.githubUrl.startsWith('https://'), isTrue);
        }
        if (AppConfig.websiteUrl.isNotEmpty) {
          expect(AppConfig.websiteUrl.startsWith('https://'), isTrue);
        }
        if (AppConfig.privacyPolicyUrl.isNotEmpty) {
          expect(AppConfig.privacyPolicyUrl.startsWith('https://'), isTrue);
        }
        if (AppConfig.companyWebsiteUrl.isNotEmpty) {
          expect(AppConfig.companyWebsiteUrl.startsWith('https://'), isTrue);
        }
      });

      test('should return valid asset paths format', () {
        // Test asset path format
        expect(AppConfig.appLogoPath.startsWith('assets/'), isTrue);
        expect(AppConfig.chipperLogoPath.startsWith('assets/'), isTrue);
        expect(AppConfig.gravitonLogoPath.startsWith('assets/'), isTrue);
      });
    });

    group('RevenueCat Configuration', () {
      test('revenueCatApiKey should return a string', () {
        // In test environment, this returns empty string (no dart-define)
        expect(AppConfig.revenueCatApiKey, isA<String>());
      });

      test('revenueCatApiKey defaults to empty string when not configured', () {
        // When no environment variable is set, it should return empty string
        expect(AppConfig.revenueCatApiKey, equals(''));
      });

      test('revenueCatApiKey is accessible as a compile-time constant', () {
        // This tests that the getter doesn't throw
        const apiKey = String.fromEnvironment('revenuecat.apiKey');
        expect(apiKey, isA<String>());
        expect(AppConfig.revenueCatApiKey, equals(apiKey));
      });
    });

    group('Stripe Configuration', () {
      test('stripeMonthlyPaymentLink should return a string', () {
        expect(AppConfig.stripeMonthlyPaymentLink, isA<String>());
      });

      test('stripeYearlyPaymentLink should return a string', () {
        expect(AppConfig.stripeYearlyPaymentLink, isA<String>());
      });

      test('stripeLifetimePaymentLink should return a string', () {
        expect(AppConfig.stripeLifetimePaymentLink, isA<String>());
      });

      test('Stripe Payment Links default to empty when not configured', () {
        // When no environment variable is set, they should return empty string
        expect(AppConfig.stripeMonthlyPaymentLink, equals(''));
        expect(AppConfig.stripeYearlyPaymentLink, equals(''));
        expect(AppConfig.stripeLifetimePaymentLink, equals(''));
      });

      test('Stripe Payment Links are accessible as compile-time constants', () {
        const monthly = String.fromEnvironment('stripe.monthlyPaymentLink');
        const yearly = String.fromEnvironment('stripe.yearlyPaymentLink');
        const lifetime = String.fromEnvironment('stripe.lifetimePaymentLink');

        expect(AppConfig.stripeMonthlyPaymentLink, equals(monthly));
        expect(AppConfig.stripeYearlyPaymentLink, equals(yearly));
        expect(AppConfig.stripeLifetimePaymentLink, equals(lifetime));
      });
    });
  });
}
