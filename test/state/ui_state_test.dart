import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/gravity_field_color_scheme.dart';
import 'package:graviton/state/ui_state.dart';

void main() {
  group('UIState Tests', () {
    late UIState uiState;

    setUp(() {
      uiState = UIState();
    });

    tearDown(() {
      uiState.dispose();
    });

    test('UIState should initialize with default values', () {
      expect(uiState.showStats, isFalse);
      expect(uiState.showTrails, isTrue);
      expect(uiState.useWarmTrails, isTrue);
      expect(uiState.uiOpacity, equals(0.8));

      // Gravity field defaults
      expect(uiState.globalGravityFields, isTrue);
      expect(
        uiState.gravityFieldColorScheme,
        equals(GravityFieldColorScheme.classic),
      );
      expect(uiState.showGravityFieldIndicators, isFalse);
      expect(uiState.showEquipotentialSurfaces, isFalse); // Default is false
    });

    test('ToggleStats should change showStats state', () {
      final initialState = uiState.showStats;
      uiState.toggleStats();
      expect(uiState.showStats, equals(!initialState));

      uiState.toggleStats();
      expect(uiState.showStats, equals(initialState));
    });

    test('ToggleTrails should change showTrails state', () {
      final initialState = uiState.showTrails;
      uiState.toggleTrails();
      expect(uiState.showTrails, equals(!initialState));

      uiState.toggleTrails();
      expect(uiState.showTrails, equals(initialState));
    });

    test('ToggleWarmTrails should change useWarmTrails state', () {
      final initialState = uiState.useWarmTrails;
      uiState.toggleWarmTrails();
      expect(uiState.useWarmTrails, equals(!initialState));

      uiState.toggleWarmTrails();
      expect(uiState.useWarmTrails, equals(initialState));
    });

    test('SetUIOpacity should update opacity within valid range', () {
      uiState.setUIOpacity(0.5);
      expect(uiState.uiOpacity, equals(0.5));

      uiState.setUIOpacity(1.0);
      expect(uiState.uiOpacity, equals(1.0));

      uiState.setUIOpacity(0.0);
      expect(uiState.uiOpacity, equals(0.0));
    });

    test('SetUIOpacity should clamp values outside valid range', () {
      uiState.setUIOpacity(-0.5);
      expect(uiState.uiOpacity, equals(0.0));

      uiState.setUIOpacity(1.5);
      expect(uiState.uiOpacity, equals(1.0));

      uiState.setUIOpacity(100.0);
      expect(uiState.uiOpacity, equals(1.0));
    });

    test('State changes should notify listeners', () {
      bool wasNotified = false;
      uiState.addListener(() {
        wasNotified = true;
      });

      uiState.toggleStats();
      expect(wasNotified, isTrue);

      wasNotified = false;
      uiState.toggleTrails();
      expect(wasNotified, isTrue);

      wasNotified = false;
      uiState.toggleWarmTrails();
      expect(wasNotified, isTrue);

      wasNotified = false;
      uiState.setUIOpacity(0.5);
      expect(wasNotified, isTrue);
    });

    test('Multiple toggles should work correctly', () {
      // Test multiple toggles in sequence
      expect(uiState.showStats, isFalse);
      uiState.toggleStats();
      expect(uiState.showStats, isTrue);
      uiState.toggleStats();
      expect(uiState.showStats, isFalse);
      uiState.toggleStats();
      expect(uiState.showStats, isTrue);
    });

    test('State should persist between method calls', () {
      uiState.toggleStats();
      uiState.setUIOpacity(0.3);
      uiState.toggleWarmTrails();

      expect(uiState.showStats, isTrue);
      expect(uiState.uiOpacity, equals(0.3));
      expect(uiState.useWarmTrails, isFalse);
    });

    test(
      'ToggleHideUIInScreenshotMode should change hideUIInScreenshotMode state',
      () {
        final initialState = uiState.hideUIInScreenshotMode;
        expect(initialState, isFalse); // Default should be false

        uiState.toggleHideUIInScreenshotMode();
        expect(uiState.hideUIInScreenshotMode, equals(!initialState));

        uiState.toggleHideUIInScreenshotMode();
        expect(uiState.hideUIInScreenshotMode, equals(initialState));
      },
    );

    test('HideUIInScreenshotMode should notify listeners', () {
      bool wasNotified = false;
      uiState.addListener(() {
        wasNotified = true;
      });

      uiState.toggleHideUIInScreenshotMode();
      expect(wasNotified, isTrue);
    });

    group('Gravity Field Tests', () {
      test(
        'toggleGlobalGravityFields should change globalGravityFields state',
        () {
          final initialState = uiState.globalGravityFields;
          expect(initialState, isTrue); // Default should be true

          uiState.toggleGlobalGravityFields();
          expect(uiState.globalGravityFields, equals(!initialState));

          uiState.toggleGlobalGravityFields();
          expect(uiState.globalGravityFields, equals(initialState));
        },
      );

      test('setGravityFieldColorScheme should update color scheme', () {
        expect(
          uiState.gravityFieldColorScheme,
          equals(GravityFieldColorScheme.classic),
        );

        uiState.setGravityFieldColorScheme(GravityFieldColorScheme.spectral);
        expect(
          uiState.gravityFieldColorScheme,
          equals(GravityFieldColorScheme.spectral),
        );

        uiState.setGravityFieldColorScheme(GravityFieldColorScheme.neon);
        expect(
          uiState.gravityFieldColorScheme,
          equals(GravityFieldColorScheme.neon),
        );
      });

      test('toggleGravityFieldIndicators should change indicators state', () {
        final initialState = uiState.showGravityFieldIndicators;
        expect(initialState, isFalse); // Default should be false

        uiState.toggleGravityFieldIndicators();
        expect(uiState.showGravityFieldIndicators, equals(!initialState));

        uiState.toggleGravityFieldIndicators();
        expect(uiState.showGravityFieldIndicators, equals(initialState));
      });

      test('toggleEquipotentialSurfaces should change surfaces state', () {
        final initialState = uiState.showEquipotentialSurfaces;
        expect(initialState, isFalse); // Default should be false

        uiState.toggleEquipotentialSurfaces();
        expect(uiState.showEquipotentialSurfaces, equals(!initialState));

        uiState.toggleEquipotentialSurfaces();
        expect(uiState.showEquipotentialSurfaces, equals(initialState));
      });

      test('gravity field methods should notify listeners', () {
        int notificationCount = 0;
        uiState.addListener(() {
          notificationCount++;
        });

        uiState.toggleGlobalGravityFields();
        uiState.setGravityFieldColorScheme(GravityFieldColorScheme.emerald);
        uiState.toggleGravityFieldIndicators();
        uiState.toggleEquipotentialSurfaces();

        expect(notificationCount, equals(4));
      });

      test('gravity field state should persist between method calls', () {
        uiState.toggleGlobalGravityFields();
        uiState.setGravityFieldColorScheme(GravityFieldColorScheme.monochrome);
        uiState.toggleGravityFieldIndicators();
        uiState.toggleEquipotentialSurfaces();

        expect(
          uiState.globalGravityFields,
          isFalse,
        ); // Was toggled from true to false
        expect(
          uiState.gravityFieldColorScheme,
          equals(GravityFieldColorScheme.monochrome),
        );
        expect(
          uiState.showGravityFieldIndicators,
          isTrue,
        ); // Was toggled from false to true
        expect(
          uiState.showEquipotentialSurfaces,
          isTrue,
        ); // Was toggled from false to true
      });

      test('should handle all color scheme values', () {
        for (final scheme in GravityFieldColorScheme.values) {
          uiState.setGravityFieldColorScheme(scheme);
          expect(uiState.gravityFieldColorScheme, equals(scheme));
        }
      });

      test('should have proper getter/setter consistency', () {
        // Test each gravity field property
        uiState.toggleGlobalGravityFields();
        final globalState = uiState.globalGravityFields;
        expect(globalState, isA<bool>());

        uiState.setGravityFieldColorScheme(GravityFieldColorScheme.spectral);
        final colorScheme = uiState.gravityFieldColorScheme;
        expect(colorScheme, isA<GravityFieldColorScheme>());

        uiState.toggleGravityFieldIndicators();
        final indicatorsState = uiState.showGravityFieldIndicators;
        expect(indicatorsState, isA<bool>());

        uiState.toggleEquipotentialSurfaces();
        final surfacesState = uiState.showEquipotentialSurfaces;
        expect(surfacesState, isA<bool>());
      });
    });

    group('Camera Speed Tests', () {
      test('Camera speed should initialize with default value', () {
        expect(uiState.cameraSpeed, equals(0.5));
      });

      test('SetCameraSpeed should update camera speed within bounds', () {
        uiState.setCameraSpeed(1.5);
        expect(uiState.cameraSpeed, equals(1.5));

        uiState.setCameraSpeed(2.0);
        expect(uiState.cameraSpeed, equals(2.0));

        uiState.setCameraSpeed(0.2);
        expect(uiState.cameraSpeed, equals(0.2));
      });

      test('SetCameraSpeed should clamp values outside valid range', () {
        // Test lower bound
        uiState.setCameraSpeed(-0.5);
        expect(uiState.cameraSpeed, equals(0.1));

        uiState.setCameraSpeed(0.05);
        expect(uiState.cameraSpeed, equals(0.1));

        // Test upper bound
        uiState.setCameraSpeed(5.0);
        expect(uiState.cameraSpeed, equals(3.0));

        uiState.setCameraSpeed(10.0);
        expect(uiState.cameraSpeed, equals(3.0));
      });

      test('Camera speed changes should notify listeners', () {
        bool wasNotified = false;
        uiState.addListener(() {
          wasNotified = true;
        });

        uiState.setCameraSpeed(1.0);
        expect(wasNotified, isTrue);

        wasNotified = false;
        uiState.setCameraSpeed(2.5);
        expect(wasNotified, isTrue);
      });

      test('Camera speed should persist valid values', () {
        const testSpeed = 1.8;
        uiState.setCameraSpeed(testSpeed);
        expect(uiState.cameraSpeed, equals(testSpeed));

        // Verify value is still accessible after multiple operations
        uiState.toggleStats();
        uiState.toggleTrails();
        expect(uiState.cameraSpeed, equals(testSpeed));
      });

      test('Camera speed should handle edge case values', () {
        // Test exact boundary values
        uiState.setCameraSpeed(0.1);
        expect(uiState.cameraSpeed, equals(0.1));

        uiState.setCameraSpeed(3.0);
        expect(uiState.cameraSpeed, equals(3.0));

        // Test very close to boundaries
        uiState.setCameraSpeed(0.10001);
        expect(uiState.cameraSpeed, equals(0.10001));

        uiState.setCameraSpeed(2.99999);
        expect(uiState.cameraSpeed, equals(2.99999));
      });
    });
  });
}
