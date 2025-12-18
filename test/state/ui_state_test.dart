import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/core/enums/cinematic_camera_technique.dart';
import 'package:graviton/core/enums/gravity_field_color_scheme.dart';
import 'package:graviton/core/enums/temperature_unit.dart';
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

    group('Habitability Features', () {
      test('Should toggle habitable zones', () {
        final initial = uiState.showHabitableZones;
        uiState.toggleHabitableZones();
        expect(uiState.showHabitableZones, equals(!initial));

        uiState.toggleHabitableZones();
        expect(uiState.showHabitableZones, equals(initial));
      });

      test('Should toggle habitability indicators', () {
        final initial = uiState.showHabitabilityIndicators;
        uiState.toggleHabitabilityIndicators();
        expect(uiState.showHabitabilityIndicators, equals(!initial));

        uiState.toggleHabitabilityIndicators();
        expect(uiState.showHabitabilityIndicators, equals(initial));
      });

      test('Habitability toggles should notify listeners', () {
        var notificationCount = 0;
        uiState.addListener(() => notificationCount++);

        uiState.toggleHabitableZones();
        expect(notificationCount, equals(1));

        uiState.toggleHabitabilityIndicators();
        expect(notificationCount, equals(2));
      });
    });

    group('Visual Effects', () {
      test('Should initialize with default stellar coronas enabled', () {
        expect(uiState.showStellarCoronas, isTrue);
      });

      test('Should initialize with default atmospheric effects disabled', () {
        expect(uiState.showAtmosphericEffects, isFalse);
      });

      test('Should toggle stellar coronas', () {
        final initial = uiState.showStellarCoronas;
        uiState.toggleStellarCoronas();
        expect(uiState.showStellarCoronas, equals(!initial));

        uiState.toggleStellarCoronas();
        expect(uiState.showStellarCoronas, equals(initial));
      });

      test('Should toggle atmospheric effects', () {
        final initial = uiState.showAtmosphericEffects;
        uiState.toggleAtmosphericEffects();
        expect(uiState.showAtmosphericEffects, equals(!initial));

        uiState.toggleAtmosphericEffects();
        expect(uiState.showAtmosphericEffects, equals(initial));
      });

      test('Visual effect toggles should notify listeners', () {
        var notificationCount = 0;
        uiState.addListener(() => notificationCount++);

        uiState.toggleStellarCoronas();
        expect(notificationCount, equals(1));

        uiState.toggleAtmosphericEffects();
        expect(notificationCount, equals(2));
      });
    });

    group('Lighting and Shadow Effects', () {
      test('Should initialize with default hemisphere lighting enabled', () {
        expect(uiState.enableHemisphereLighting, isTrue);
      });

      test('Should initialize with default cast shadows disabled', () {
        expect(uiState.enableCastShadows, isFalse);
      });

      test('Should initialize with default specular highlights disabled', () {
        expect(uiState.enableSpecularHighlights, isFalse);
      });

      test('Should toggle hemisphere lighting', () {
        final initial = uiState.enableHemisphereLighting;
        uiState.toggleHemisphereLighting();
        expect(uiState.enableHemisphereLighting, equals(!initial));

        uiState.toggleHemisphereLighting();
        expect(uiState.enableHemisphereLighting, equals(initial));
      });

      test('Should toggle cast shadows', () {
        final initial = uiState.enableCastShadows;
        uiState.toggleCastShadows();
        expect(uiState.enableCastShadows, equals(!initial));

        uiState.toggleCastShadows();
        expect(uiState.enableCastShadows, equals(initial));
      });

      test('Should toggle specular highlights', () {
        final initial = uiState.enableSpecularHighlights;
        uiState.toggleSpecularHighlights();
        expect(uiState.enableSpecularHighlights, equals(!initial));

        uiState.toggleSpecularHighlights();
        expect(uiState.enableSpecularHighlights, equals(initial));
      });

      test('Lighting effect toggles should notify listeners', () {
        var notificationCount = 0;
        uiState.addListener(() => notificationCount++);

        uiState.toggleHemisphereLighting();
        expect(notificationCount, equals(1));

        uiState.toggleCastShadows();
        expect(notificationCount, equals(2));

        uiState.toggleSpecularHighlights();
        expect(notificationCount, equals(3));
      });

      test('Should handle multiple rapid lighting toggles', () {
        var notificationCount = 0;
        uiState.addListener(() => notificationCount++);

        // Rapid toggling should work correctly
        for (int i = 0; i < 10; i++) {
          uiState.toggleHemisphereLighting();
        }

        expect(notificationCount, equals(10));
        expect(
          uiState.enableHemisphereLighting,
          isTrue,
        ); // Should end at initial state
      });

      test('All lighting effects can be enabled simultaneously', () {
        uiState.toggleHemisphereLighting(); // Start false (toggled from true)
        uiState.toggleHemisphereLighting(); // Back to true
        uiState.toggleCastShadows(); // Enable (start from false)
        uiState.toggleSpecularHighlights(); // Enable (start from false)

        expect(uiState.enableHemisphereLighting, isTrue);
        expect(uiState.enableCastShadows, isTrue);
        expect(uiState.enableSpecularHighlights, isTrue);
      });

      test('All lighting effects can be disabled simultaneously', () {
        uiState.toggleHemisphereLighting(); // Disable (start from true)

        expect(uiState.enableHemisphereLighting, isFalse);
        expect(uiState.enableCastShadows, isFalse);
        expect(uiState.enableSpecularHighlights, isFalse);
      });

      test(
        'Lighting settings should be independent of other visual settings',
        () {
          // Set lighting states
          uiState.toggleHemisphereLighting(); // Toggle to false
          uiState.toggleCastShadows(); // Toggle to true

          // Change other visual settings
          uiState.toggleStellarCoronas();
          uiState.toggleAtmosphericEffects();
          uiState.toggleCollisionDebris();

          // Lighting states should persist
          expect(uiState.enableHemisphereLighting, isFalse);
          expect(uiState.enableCastShadows, isTrue);
          expect(uiState.enableSpecularHighlights, isFalse);
        },
      );

      test('Should maintain lighting state through multiple operations', () {
        // Enable all lighting effects
        uiState.toggleCastShadows(); // Enable
        uiState.toggleSpecularHighlights(); // Enable

        // Verify enabled
        expect(uiState.enableHemisphereLighting, isTrue);
        expect(uiState.enableCastShadows, isTrue);
        expect(uiState.enableSpecularHighlights, isTrue);

        // Perform other UI operations
        uiState.toggleStats();
        uiState.toggleGrid();
        uiState.setUIOpacity(0.5);

        // Lighting states should persist
        expect(uiState.enableHemisphereLighting, isTrue);
        expect(uiState.enableCastShadows, isTrue);
        expect(uiState.enableSpecularHighlights, isTrue);
      });
    });

    group('Collision Effects', () {
      test('Should toggle collision debris', () {
        final initial = uiState.showCollisionDebris;
        uiState.toggleCollisionDebris();
        expect(uiState.showCollisionDebris, equals(!initial));

        uiState.toggleCollisionDebris();
        expect(uiState.showCollisionDebris, equals(initial));
      });

      test('Should toggle collision shockwaves', () {
        final initial = uiState.showCollisionShockwaves;
        uiState.toggleCollisionShockwaves();
        expect(uiState.showCollisionShockwaves, equals(!initial));

        uiState.toggleCollisionShockwaves();
        expect(uiState.showCollisionShockwaves, equals(initial));
      });

      test('Should toggle collision ejection', () {
        final initial = uiState.showCollisionEjection;
        uiState.toggleCollisionEjection();
        expect(uiState.showCollisionEjection, equals(!initial));

        uiState.toggleCollisionEjection();
        expect(uiState.showCollisionEjection, equals(initial));
      });

      test('Should toggle collision plasma jets', () {
        final initial = uiState.showCollisionPlasmaJets;
        uiState.toggleCollisionPlasmaJets();
        expect(uiState.showCollisionPlasmaJets, equals(!initial));

        uiState.toggleCollisionPlasmaJets();
        expect(uiState.showCollisionPlasmaJets, equals(initial));
      });

      test('All collision effect toggles should notify listeners', () {
        var notificationCount = 0;
        uiState.addListener(() => notificationCount++);

        uiState.toggleCollisionDebris();
        uiState.toggleCollisionShockwaves();
        uiState.toggleCollisionEjection();
        uiState.toggleCollisionPlasmaJets();

        expect(notificationCount, equals(4));
      });
    });

    group('Language Settings', () {
      test('Should set language code', () {
        uiState.setLanguage('es');
        expect(uiState.selectedLanguageCode, equals('es'));

        uiState.setLanguage('fr');
        expect(uiState.selectedLanguageCode, equals('fr'));
      });

      test('Should handle null language (system default)', () {
        uiState.setLanguage(null);
        expect(uiState.selectedLanguageCode, isNull);
      });

      test('Language changes should notify listeners', () {
        var notificationCount = 0;
        uiState.addListener(() => notificationCount++);

        uiState.setLanguage('de');
        expect(notificationCount, equals(1));

        uiState.setLanguage('ja');
        expect(notificationCount, equals(2));
      });
    });

    group('Temperature Unit', () {
      test('Should set temperature unit', () {
        uiState.setTemperatureUnit(TemperatureUnit.fahrenheit);
        expect(uiState.temperatureUnit, equals(TemperatureUnit.fahrenheit));

        uiState.setTemperatureUnit(TemperatureUnit.kelvin);
        expect(uiState.temperatureUnit, equals(TemperatureUnit.kelvin));

        uiState.setTemperatureUnit(TemperatureUnit.celsius);
        expect(uiState.temperatureUnit, equals(TemperatureUnit.celsius));
      });

      test('Temperature unit changes should notify listeners', () {
        var notificationCount = 0;
        uiState.addListener(() => notificationCount++);

        uiState.setTemperatureUnit(TemperatureUnit.fahrenheit);
        expect(notificationCount, equals(1));

        uiState.setTemperatureUnit(TemperatureUnit.kelvin);
        expect(notificationCount, equals(2));
      });
    });

    group('Cinematic Camera', () {
      test('Should set cinematic camera technique', () {
        uiState.setCinematicCameraTechnique(
          CinematicCameraTechnique.predictiveOrbital,
        );
        expect(
          uiState.cinematicCameraTechnique,
          equals(CinematicCameraTechnique.predictiveOrbital),
        );

        uiState.setCinematicCameraTechnique(
          CinematicCameraTechnique.dynamicFraming,
        );
        expect(
          uiState.cinematicCameraTechnique,
          equals(CinematicCameraTechnique.dynamicFraming),
        );

        uiState.setCinematicCameraTechnique(CinematicCameraTechnique.manual);
        expect(
          uiState.cinematicCameraTechnique,
          equals(CinematicCameraTechnique.manual),
        );
      });

      test('Cinematic camera changes should notify listeners', () {
        var notificationCount = 0;
        uiState.addListener(() => notificationCount++);

        uiState.setCinematicCameraTechnique(
          CinematicCameraTechnique.predictiveOrbital,
        );
        expect(notificationCount, equals(1));

        uiState.setCinematicCameraTechnique(
          CinematicCameraTechnique.dynamicFraming,
        );
        expect(notificationCount, equals(2));
      });
    });

    group('Fullscreen Mode', () {
      test('Should set fullscreen state', () {
        uiState.setFullscreen(true);
        expect(uiState.isFullscreen, isTrue);

        uiState.setFullscreen(false);
        expect(uiState.isFullscreen, isFalse);
      });

      test('Should toggle screenshot mode UI hiding', () {
        final initial = uiState.hideUIInScreenshotMode;
        uiState.toggleHideUIInScreenshotMode();
        expect(uiState.hideUIInScreenshotMode, equals(!initial));

        uiState.toggleHideUIInScreenshotMode();
        expect(uiState.hideUIInScreenshotMode, equals(initial));
      });

      test('Fullscreen changes should notify listeners', () {
        var notificationCount = 0;
        uiState.addListener(() => notificationCount++);

        uiState.setFullscreen(true);
        expect(notificationCount, equals(1));

        uiState.setFullscreen(false);
        expect(notificationCount, equals(2));
      });
    });

    group('Changelog Tracking', () {
      test('Should set last seen changelog version', () {
        uiState.setLastSeenChangelogVersion('1.0.0');
        expect(uiState.lastSeenChangelogVersion, equals('1.0.0'));

        uiState.setLastSeenChangelogVersion('1.1.0');
        expect(uiState.lastSeenChangelogVersion, equals('1.1.0'));
      });

      test('Changelog version changes should notify listeners', () {
        var notificationCount = 0;
        uiState.addListener(() => notificationCount++);

        uiState.setLastSeenChangelogVersion('2.0.0');
        expect(notificationCount, equals(1));
      });
    });

    group('Additional UI Toggles', () {
      test('Should toggle orbital paths', () {
        final initial = uiState.showOrbitalPaths;
        uiState.toggleOrbitalPaths();
        expect(uiState.showOrbitalPaths, equals(!initial));
      });

      test('Should toggle dual orbital paths', () {
        final initial = uiState.dualOrbitalPaths;
        uiState.toggleDualOrbitalPaths();
        expect(uiState.dualOrbitalPaths, equals(!initial));
      });

      test('Should toggle grid', () {
        final initial = uiState.showGrid;
        uiState.toggleGrid();
        expect(uiState.showGrid, equals(!initial));
      });

      test('Should toggle labels', () {
        final initial = uiState.showLabels;
        uiState.toggleLabels();
        expect(uiState.showLabels, equals(!initial));
      });

      test('Should toggle off-screen indicators', () {
        final initial = uiState.showOffScreenIndicators;
        uiState.toggleOffScreenIndicators();
        expect(uiState.showOffScreenIndicators, equals(!initial));
      });

      test('All UI toggles should notify listeners', () {
        var notificationCount = 0;
        uiState.addListener(() => notificationCount++);

        uiState.toggleOrbitalPaths();
        uiState.toggleDualOrbitalPaths();
        uiState.toggleGrid();
        uiState.toggleLabels();
        uiState.toggleOffScreenIndicators();

        expect(notificationCount, equals(5));
      });
    });

    group('State Persistence', () {
      test('Should maintain all settings through multiple operations', () {
        // Set various states
        uiState.setLanguage('es');
        uiState.setTemperatureUnit(TemperatureUnit.fahrenheit);
        uiState.setCameraSpeed(2.0);
        uiState.setFullscreen(true);
        uiState.toggleHabitableZones();
        uiState.toggleCollisionDebris();

        // Verify persistence
        expect(uiState.selectedLanguageCode, equals('es'));
        expect(uiState.temperatureUnit, equals(TemperatureUnit.fahrenheit));
        expect(uiState.cameraSpeed, equals(2.0));
        expect(uiState.isFullscreen, isTrue);

        // Perform other operations
        uiState.toggleStats();
        uiState.toggleGrid();

        // Original settings should persist
        expect(uiState.selectedLanguageCode, equals('es'));
        expect(uiState.temperatureUnit, equals(TemperatureUnit.fahrenheit));
        expect(uiState.cameraSpeed, equals(2.0));
        expect(uiState.isFullscreen, isTrue);
      });
    });

    group('Listener Management', () {
      test('Should properly notify all listeners', () {
        var listener1Count = 0;
        var listener2Count = 0;

        void listener1() => listener1Count++;
        void listener2() => listener2Count++;

        uiState.addListener(listener1);
        uiState.addListener(listener2);

        uiState.toggleStats();

        expect(listener1Count, equals(1));
        expect(listener2Count, equals(1));

        uiState.removeListener(listener1);
        uiState.toggleTrails();

        expect(listener1Count, equals(1)); // Should not increment
        expect(listener2Count, equals(2)); // Should increment
      });

      test('Should handle rapid state changes', () {
        var notificationCount = 0;
        uiState.addListener(() => notificationCount++);

        for (int i = 0; i < 20; i++) {
          uiState.toggleStats();
        }

        expect(notificationCount, equals(20));
      });
    });

    group('Interaction Lock Tests', () {
      test('isInteractionLocked should default to true', () {
        expect(uiState.isInteractionLocked, isTrue);
      });

      test('toggleInteractionLock should toggle lock state', () {
        expect(uiState.isInteractionLocked, isTrue);

        uiState.toggleInteractionLock();
        expect(uiState.isInteractionLocked, isFalse);

        uiState.toggleInteractionLock();
        expect(uiState.isInteractionLocked, isTrue);
      });

      test('toggleInteractionLock should notify listeners', () {
        bool wasNotified = false;
        uiState.addListener(() {
          wasNotified = true;
        });

        uiState.toggleInteractionLock();
        expect(wasNotified, isTrue);
      });

      test('interaction lock should not affect body movement mode getters', () {
        // Body movement mode is a separate concept
        expect(uiState.isBodyMovementModeActive, isFalse);
        expect(uiState.movingBodyIndex, isNull);

        // Lock interaction
        uiState.toggleInteractionLock();
        expect(uiState.isInteractionLocked, isTrue);

        // Body movement mode should still be accessible
        expect(uiState.isBodyMovementModeActive, isFalse);
        expect(uiState.movingBodyIndex, isNull);
      });
    });
  });
}
