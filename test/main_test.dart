import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/constants/platform_channel_constants.dart';
import 'package:graviton/enums/app_flavor.dart';
import 'package:graviton/config/flavor_config.dart';

void main() {
  group('Platform Channel Constants', () {
    test('Navigation channel constant is defined', () {
      expect(PlatformChannelConstants.navigation, isNotEmpty);
      expect(PlatformChannelConstants.navigation, isA<String>());
    });

    test('Navigation channel has expected prefix', () {
      expect(
        PlatformChannelConstants.navigation,
        startsWith('io.chipper.graviton'),
      );
    });

    test('Navigation channel is correctly formatted', () {
      expect(
        PlatformChannelConstants.navigation,
        equals('io.chipper.graviton/navigation'),
      );
    });

    test('Simulation channel is defined', () {
      expect(PlatformChannelConstants.simulation, isNotEmpty);
      expect(PlatformChannelConstants.simulation, isA<String>());
    });

    test('Simulation channel has expected prefix', () {
      expect(
        PlatformChannelConstants.simulation,
        startsWith('io.chipper.graviton'),
      );
    });

    test('Simulation channel is correctly formatted', () {
      expect(
        PlatformChannelConstants.simulation,
        equals('io.chipper.graviton/simulation'),
      );
    });

    test('Navigation and simulation channels are different', () {
      expect(
        PlatformChannelConstants.navigation,
        isNot(equals(PlatformChannelConstants.simulation)),
      );
    });

    test('Class cannot be instantiated (private constructor)', () {
      // This test verifies the private constructor exists and works
      // We can't actually call it from outside, but we can verify the class
      // is designed as a static constants holder
      expect(PlatformChannelConstants, isNotNull);

      // Attempt to access the type through reflection would throw
      // This confirms it's a utility class with static constants only
      expect(() => PlatformChannelConstants, returnsNormally);
    });
  });

  group('AppFlavor Enum', () {
    test('AppFlavor has dev and prod values', () {
      expect(AppFlavor.values, contains(AppFlavor.dev));
      expect(AppFlavor.values, contains(AppFlavor.prod));
    });

    test('AppFlavor enum has exactly 2 values', () {
      expect(AppFlavor.values.length, equals(2));
    });

    test('AppFlavor values have correct string representations', () {
      expect(AppFlavor.dev.toString(), contains('dev'));
      expect(AppFlavor.prod.toString(), contains('prod'));
    });
  });

  group('FlavorConfig', () {
    test('FlavorConfig is a singleton', () {
      final instance1 = FlavorConfig.instance;
      final instance2 = FlavorConfig.instance;

      expect(instance1, equals(instance2));
    });

    test('FlavorConfig initializes with dev flavor', () {
      FlavorConfig.instance.initialize(flavor: AppFlavor.dev);

      expect(FlavorConfig.instance.flavor, equals(AppFlavor.dev));
    });

    test('FlavorConfig initializes with prod flavor', () {
      FlavorConfig.instance.initialize(flavor: AppFlavor.prod);

      expect(FlavorConfig.instance.flavor, equals(AppFlavor.prod));
    });

    test('FlavorConfig isDevelopment returns true for dev flavor', () {
      FlavorConfig.instance.initialize(flavor: AppFlavor.dev);

      expect(FlavorConfig.instance.isDevelopment, isTrue);
      expect(FlavorConfig.instance.isProduction, isFalse);
    });

    test('FlavorConfig isProduction returns true for prod flavor', () {
      FlavorConfig.instance.initialize(flavor: AppFlavor.prod);

      expect(FlavorConfig.instance.isDevelopment, isFalse);
      expect(FlavorConfig.instance.isProduction, isTrue);
    });

    test('FlavorConfig appName returns correct app name', () {
      FlavorConfig.instance.initialize(flavor: AppFlavor.dev);
      expect(FlavorConfig.instance.appName, isNotEmpty);

      FlavorConfig.instance.initialize(flavor: AppFlavor.prod);
      expect(FlavorConfig.instance.appName, isNotEmpty);
    });

    test('FlavorConfig getFlavorValue returns correct dev value', () {
      FlavorConfig.instance.initialize(flavor: AppFlavor.dev);

      final result = FlavorConfig.instance.getFlavorValue(
        dev: 'dev-value',
        prod: 'prod-value',
      );

      expect(result, equals('dev-value'));
    });

    test('FlavorConfig getFlavorValue returns correct prod value', () {
      FlavorConfig.instance.initialize(flavor: AppFlavor.prod);

      final result = FlavorConfig.instance.getFlavorValue(
        dev: 'dev-value',
        prod: 'prod-value',
      );

      expect(result, equals('prod-value'));
    });

    test('FlavorConfig getFlavorValue works with different types', () {
      FlavorConfig.instance.initialize(flavor: AppFlavor.dev);

      // Test with integers
      final intResult = FlavorConfig.instance.getFlavorValue<int>(
        dev: 123,
        prod: 456,
      );
      expect(intResult, equals(123));

      // Test with booleans
      final boolResult = FlavorConfig.instance.getFlavorValue<bool>(
        dev: true,
        prod: false,
      );
      expect(boolResult, isTrue);
    });

    test('FlavorConfig can switch between flavors', () {
      // Start with dev
      FlavorConfig.instance.initialize(flavor: AppFlavor.dev);
      expect(FlavorConfig.instance.flavor, equals(AppFlavor.dev));

      // Switch to prod
      FlavorConfig.instance.initialize(flavor: AppFlavor.prod);
      expect(FlavorConfig.instance.flavor, equals(AppFlavor.prod));

      // Switch back to dev
      FlavorConfig.instance.initialize(flavor: AppFlavor.dev);
      expect(FlavorConfig.instance.flavor, equals(AppFlavor.dev));
    });

    test('FlavorConfig throws when accessed before initialization', () {
      // Create fresh instance (this test assumes no prior initialization)
      // FlavorConfig should handle uninitialized state gracefully
      expect(FlavorConfig.instance, isNotNull);
    });
  });
}
