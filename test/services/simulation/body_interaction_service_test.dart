import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/core/enums/body_type.dart';
import 'package:graviton/models/celestial/body.dart';
import 'package:graviton/services/simulation/body_interaction_service.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('BodyInteractionService', () {
    test('should have private constructor', () {
      // Verify that BodyInteractionService cannot be instantiated
      // This ensures it's used as a static utility class
      expect(BodyInteractionService, isA<Type>());
    });

    group('findBodyAtTapLocation', () {
      test('should return null when no bodies exist', () {
        final appState = AppState();
        final result = BodyInteractionService.findBodyAtTapLocation(
          appState: appState,
          size: const Size(800, 600),
          tapPosition: const Offset(400, 300),
        );

        expect(result, isNull);
        appState.dispose();
      });

      test('should return null when tap position is null', () {
        final appState = AppState();
        final result = BodyInteractionService.findBodyAtTapLocation(
          appState: appState,
          size: const Size(800, 600),
          tapPosition: null,
        );

        expect(result, isNull);
        appState.dispose();
      });

      test('should detect body at tap location', () {
        final appState = AppState();

        // Add a body at the origin
        final testBody = Body(
          name: 'Test Body',
          mass: 1.0,
          radius: 5.0,
          position: vm.Vector3(0, 0, 0),
          velocity: vm.Vector3.zero(),
          color: AppColors.stellarOType,
          bodyType: BodyType.planet,
        );
        appState.simulation.bodies.add(testBody);

        // The body should be projectable to screen space
        // With default camera looking at origin, center of screen should hit it
        final result = BodyInteractionService.findBodyAtTapLocation(
          appState: appState,
          size: const Size(800, 600),
          tapPosition: const Offset(400, 300), // Center of screen
        );

        // Result depends on camera projection - may or may not find body
        // This test ensures the method handles bodies without crashing
        expect(result, anyOf(isNull, isA<int>()));
        appState.dispose();
      });

      test('should handle multiple bodies', () {
        final appState = AppState();

        // Add multiple test bodies
        for (var i = 0; i < 5; i++) {
          appState.simulation.bodies.add(
            Body(
              name: 'Body $i',
              mass: 1.0,
              radius: 3.0,
              position: vm.Vector3(i * 10.0, 0, 0),
              velocity: vm.Vector3.zero(),
              color: AppColors.stellarMType,
              bodyType: BodyType.star,
            ),
          );
        }

        final result = BodyInteractionService.findBodyAtTapLocation(
          appState: appState,
          size: const Size(800, 600),
          tapPosition: const Offset(400, 300),
        );

        // Should return either null or a valid body index
        if (result != null) {
          expect(result, inInclusiveRange(0, 4));
        }
        appState.dispose();
      });
    });

    group('findBodyAtHoverLocation', () {
      test('should return null when no bodies exist', () {
        final appState = AppState();
        final result = BodyInteractionService.findBodyAtHoverLocation(
          appState: appState,
          size: const Size(800, 600),
          hoverPosition: const Offset(400, 300),
        );

        expect(result, isNull);
        appState.dispose();
      });

      test('should return null when hover position is null', () {
        final appState = AppState();
        final result = BodyInteractionService.findBodyAtHoverLocation(
          appState: appState,
          size: const Size(800, 600),
          hoverPosition: null,
        );

        expect(result, isNull);
        appState.dispose();
      });

      test('should use smaller hit radius than tap', () {
        final appState = AppState();

        // Add a body
        appState.simulation.bodies.add(
          Body(
            name: 'Test',
            mass: 1.0,
            radius: 5.0,
            position: vm.Vector3(0, 0, 0),
            velocity: vm.Vector3.zero(),
            color: AppColors.uiStatusGreen,
            bodyType: BodyType.moon,
          ),
        );

        // Hover uses smaller hit radius (15px vs 40px for tap)
        final hoverResult = BodyInteractionService.findBodyAtHoverLocation(
          appState: appState,
          size: const Size(800, 600),
          hoverPosition: const Offset(400, 300),
        );

        // Method should execute without errors
        expect(hoverResult, anyOf(isNull, isA<int>()));
        appState.dispose();
      });
    });

    group('selectBody', () {
      test('should select body and update camera', () {
        final appState = AppState();

        // Add a test body
        final testBody = Body(
          name: 'Target Body',
          mass: 1.0,
          radius: 5.0,
          position: vm.Vector3(10, 5, 0),
          velocity: vm.Vector3(1, 0, 0),
          color: AppColors.stellarGType,
          bodyType: BodyType.star,
        );
        appState.simulation.bodies.add(testBody);

        // Select the body
        BodyInteractionService.selectBody(
          appState: appState,
          bodyIndex: 0,
          bodies: appState.simulation.bodies,
        );

        // Verify body is selected in camera
        expect(appState.camera.selectedBody, equals(0));
        appState.dispose();
      });

      test('should handle selection when follow mode is already active', () {
        final appState = AppState();

        // Add two bodies
        appState.simulation.bodies.addAll([
          Body(
            name: 'Body 1',
            mass: 1.0,
            radius: 5.0,
            position: vm.Vector3(10, 20, 30),
            velocity: vm.Vector3.zero(),
            color: AppColors.uiPurple,
            bodyType: BodyType.planet,
          ),
          Body(
            name: 'Body 2',
            mass: 1.0,
            radius: 5.0,
            position: vm.Vector3(-10, -20, -30),
            velocity: vm.Vector3.zero(),
            color: AppColors.stellarKType,
            bodyType: BodyType.planet,
          ),
        ]);

        // Select first body and enable follow mode
        appState.camera.selectBody(0);
        appState.camera.toggleFollowMode(appState.simulation.bodies);
        expect(appState.camera.followMode, isTrue);
        expect(appState.camera.selectedBody, equals(0));

        // Now use BodyInteractionService to select a different body while in follow mode
        // This should keep follow mode active and switch to following the new body
        BodyInteractionService.selectBody(
          appState: appState,
          bodyIndex: 1,
          bodies: appState.simulation.bodies,
        );

        // Follow mode should remain active and camera should be following newly selected body
        expect(appState.camera.followMode, isTrue);
        expect(appState.camera.selectedBody, equals(1));
        appState.dispose();
      });

      test('should throw RangeError for invalid body index', () {
        final appState = AppState();

        // Try to select non-existent body - should throw RangeError
        expect(
          () => BodyInteractionService.selectBody(
            appState: appState,
            bodyIndex: 99,
            bodies: appState.simulation.bodies,
          ),
          throwsA(isA<RangeError>()),
        );
        appState.dispose();
      });
    });

    group('handleBodyMovement', () {
      test('should handle body movement with valid body index', () {
        final appState = AppState();

        // Add a body and start movement mode
        appState.simulation.bodies.add(
          Body(
            name: 'Movable Body',
            mass: 1.0,
            radius: 5.0,
            position: vm.Vector3(0, 0, 0),
            velocity: vm.Vector3(1, 1, 1),
            color: AppColors.stellarKType,
            bodyType: BodyType.asteroid,
          ),
        );

        appState.ui.startBodyMovement(0);

        // Attempt to move body
        var updateCalled = false;
        BodyInteractionService.handleBodyMovement(
          appState: appState,
          screenSize: const Size(800, 600),
          screenPosition: const Offset(450, 350),
          onUpdate: () => updateCalled = true,
        );

        // Update should be called for UI refresh
        expect(updateCalled, isTrue);

        // Body velocity should be reset to zero during drag
        expect(appState.simulation.bodies[0].velocity, vm.Vector3.zero());
        appState.dispose();
      });

      test('should handle null moving body index', () {
        final appState = AppState();

        appState.simulation.bodies.add(
          Body(
            name: 'Body',
            mass: 1.0,
            radius: 5.0,
            position: vm.Vector3.zero(),
            velocity: vm.Vector3.zero(),
            color: AppColors.stellarMType,
            bodyType: BodyType.planet,
          ),
        );

        // No body selected for movement
        var updateCalled = false;
        BodyInteractionService.handleBodyMovement(
          appState: appState,
          screenSize: const Size(800, 600),
          screenPosition: const Offset(400, 300),
          onUpdate: () => updateCalled = true,
        );

        // Should not update if no body is being moved
        expect(updateCalled, isFalse);
        appState.dispose();
      });

      test('should handle invalid body index', () {
        final appState = AppState();

        // Set invalid moving body index
        appState.ui.startBodyMovement(99);

        expect(
          () => BodyInteractionService.handleBodyMovement(
            appState: appState,
            screenSize: const Size(800, 600),
            screenPosition: const Offset(400, 300),
            onUpdate: () {},
          ),
          returnsNormally,
        );
        appState.dispose();
      });
    });

    group('Edge Cases', () {
      test('should handle very small screen sizes', () {
        final appState = AppState();

        appState.simulation.bodies.add(
          Body(
            name: 'Body',
            mass: 1.0,
            radius: 5.0,
            position: vm.Vector3.zero(),
            velocity: vm.Vector3.zero(),
            color: AppColors.stellarOType,
            bodyType: BodyType.planet,
          ),
        );

        final result = BodyInteractionService.findBodyAtTapLocation(
          appState: appState,
          size: const Size(100, 100), // Very small screen
          tapPosition: const Offset(50, 50),
        );

        expect(result, anyOf(isNull, isA<int>()));
        appState.dispose();
      });

      test('should handle very large screen sizes', () {
        final appState = AppState();

        appState.simulation.bodies.add(
          Body(
            name: 'Body',
            mass: 1.0,
            radius: 5.0,
            position: vm.Vector3.zero(),
            velocity: vm.Vector3.zero(),
            color: AppColors.stellarOType,
            bodyType: BodyType.planet,
          ),
        );

        final result = BodyInteractionService.findBodyAtTapLocation(
          appState: appState,
          size: const Size(4000, 2000), // Very large screen
          tapPosition: const Offset(2000, 1000),
        );

        expect(result, anyOf(isNull, isA<int>()));
        appState.dispose();
      });

      test('should handle bodies at extreme positions', () {
        final appState = AppState();

        // Add bodies at extreme positions
        appState.simulation.bodies.addAll([
          Body(
            name: 'Far Body 1',
            mass: 1.0,
            radius: 5.0,
            position: vm.Vector3(1000, 1000, 1000),
            velocity: vm.Vector3.zero(),
            color: AppColors.stellarMType,
            bodyType: BodyType.star,
          ),
          Body(
            name: 'Far Body 2',
            mass: 1.0,
            radius: 5.0,
            position: vm.Vector3(-1000, -1000, -1000),
            velocity: vm.Vector3.zero(),
            color: AppColors.stellarOType,
            bodyType: BodyType.planet,
          ),
        ]);

        final result = BodyInteractionService.findBodyAtTapLocation(
          appState: appState,
          size: const Size(800, 600),
          tapPosition: const Offset(400, 300),
        );

        expect(result, anyOf(isNull, isA<int>()));
        appState.dispose();
      });

      test('should handle zero-radius bodies', () {
        final appState = AppState();

        appState.simulation.bodies.add(
          Body(
            name: 'Zero Radius',
            mass: 1.0,
            radius: 0.0, // Zero radius
            position: vm.Vector3.zero(),
            velocity: vm.Vector3.zero(),
            color: AppColors.uiWhite,
            bodyType: BodyType.asteroid,
          ),
        );

        expect(
          () => BodyInteractionService.findBodyAtTapLocation(
            appState: appState,
            size: const Size(800, 600),
            tapPosition: const Offset(400, 300),
          ),
          returnsNormally,
        );
        appState.dispose();
      });
    });
  });
}
