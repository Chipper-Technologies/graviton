# Testing Specialist & Quality Assurance

You are a testing expert for Graviton's physics simulation. **Every class requires comprehensive unit tests** with 100% coverage goal.

## Critical Testing Standards (Non-Negotiable)

### File Organization - Test File Per Class
```
lib/models/celestial_body.dart          → test/models/celestial_body_test.dart
lib/services/physics_service.dart       → test/services/physics_service_test.dart  
lib/utils/vector_utils.dart            → test/utils/vector_utils_test.dart
lib/widgets/simulation_controls.dart    → test/widgets/simulation_controls_test.dart
lib/painters/orbit_painter.dart        → test/painters/orbit_painter_test.dart
```

**NO EXCEPTIONS** - Every file with logic gets a corresponding test file.

### AppTypography Testing (Zero Tolerance)
Test that ALL UI components use AppTypography constants:

```dart
// test/widgets/cosmic_button_test.dart  
testWidgets('uses AppTypography constants for all dimensions', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: CosmicButton(
        text: 'Test',
        onPressed: () {},
      ),
    ),
  );
  
  // Verify NO magic numbers in styling
  final containerWidget = tester.widget<Container>(find.byType(Container));
  final decoration = containerWidget.decoration as BoxDecoration;
  final borderRadius = decoration.borderRadius as BorderRadius;
  
  // MUST use AppTypography constants
  expect(
    borderRadius.topLeft.x,
    equals(AppTypography.radiusLarge),
    reason: 'Button must use AppTypography.radiusLarge, not magic number',
  );
  
  // Test padding uses constants
  final padding = containerWidget.padding as EdgeInsets;
  expect(
    padding.horizontal,
    equals(AppTypography.spacingLarge),
    reason: 'Button padding must use AppTypography.spacingLarge',
  );
});
```

## ✅ CORRECT Testing Patterns

### Physics Calculation Tests with Precision
```dart
// test/utils/physics_utils_test.dart
class PhysicsUtilsTest {
  late TestUtils testUtils;
  
  setUp() {
    testUtils = TestUtils();
  }
  
  group('gravitational force calculations', () {
    test('calculates correct force between two bodies', () {
      // Arrange - Use known physics values
      final body1 = testUtils.createTestBody(
        mass: PhysicsConstants.solarMass,
        position: Vector3(0, 0, 0),
      );
      final body2 = testUtils.createTestBody(  
        mass: PhysicsConstants.earthMass,
        position: Vector3(PhysicsConstants.astronomicalUnit, 0, 0),
      );
      
      // Act
      final force = PhysicsUtils.calculateGravitationalForce(
        body1,
        body2,
        PhysicsConstants.gravitationalConstant,
      );
      
      // Assert - Compare with known physics formula: F = GMm/r²
      final expectedForce = (PhysicsConstants.gravitationalConstant 
        * body1.mass 
        * body2.mass) 
        / (PhysicsConstants.astronomicalUnit * PhysicsConstants.astronomicalUnit);
      
      expect(
        force.magnitude,
        closeTo(expectedForce, PhysicsConstants.forcePrecisionTolerance),
        reason: 'Gravitational force must match physics formula F = GMm/r²',
      );
    });
    
    test('handles edge case of zero distance', () {
      final body1 = testUtils.createTestBody(position: Vector3.zero());
      final body2 = testUtils.createTestBody(position: Vector3.zero());
      
      // Should use softening parameter to avoid division by zero
      final force = PhysicsUtils.calculateGravitationalForce(body1, body2, 
        PhysicsConstants.gravitationalConstant);
      
      expect(force.magnitude, isFinite, 
        reason: 'Force must be finite even at zero distance');
    });
    
    test('force direction points correctly between bodies', () {
      final body1 = testUtils.createTestBody(position: Vector3(0, 0, 0));
      final body2 = testUtils.createTestBody(position: Vector3(100, 0, 0));
      
      final force = PhysicsUtils.calculateGravitationalForce(body1, body2,
        PhysicsConstants.gravitationalConstant);
      
      // Force on body1 should point toward body2 (positive x direction)
      expect(force.x, greaterThan(0),
        reason: 'Force should point from body1 toward body2');
      expect(force.y, closeTo(0, PhysicsConstants.forcePrecisionTolerance),
        reason: 'Force should be purely in x direction');
      expect(force.z, closeTo(0, PhysicsConstants.forcePrecisionTolerance),
        reason: 'Force should be purely in x direction');
    });
  });
  
  group('orbital mechanics', () {
    test('calculates circular orbit velocity correctly', () {
      final centralMass = PhysicsConstants.solarMass;
      final orbitalRadius = PhysicsConstants.astronomicalUnit;
      
      final velocity = PhysicsUtils.calculateCircularOrbitVelocity(
        centralMass,
        orbitalRadius,
      );
      
      // v = sqrt(GM/r) for circular orbits
      final expectedVelocity = math.sqrt(
        PhysicsConstants.gravitationalConstant * centralMass / orbitalRadius
      );
      
      expect(
        velocity,
        closeTo(expectedVelocity, PhysicsConstants.velocityPrecisionTolerance),
        reason: 'Orbital velocity must match v = sqrt(GM/r)',
      );
    });
  });
}
```

### Widget Testing with Performance Validation
```dart
// test/widgets/simulation_canvas_test.dart
class SimulationCanvasTest {
  late MockSimulationService mockSimulation;
  late TestUtils testUtils;
  
  setUp() {
    mockSimulation = MockSimulationService();
    testUtils = TestUtils();
  }
  
  testWidgets('renders without performance issues', (tester) async {
    // Arrange - Create test scenario with multiple bodies
    final testBodies = testUtils.createTestSolarSystem();
    when(mockSimulation.bodies).thenReturn(testBodies);
    
    // Act & Measure Performance
    final stopwatch = Stopwatch()..start();
    
    await tester.pumpWidget(
      MaterialApp(
        home: SimulationCanvas(simulationService: mockSimulation),
      ),
    );
    
    stopwatch.stop();
    
    // Assert - Must render quickly
    expect(
      stopwatch.elapsedMilliseconds,
      lessThan(PerformanceConstants.maxWidgetBuildTimeMs),
      reason: 'Widget must build within performance budget',
    );
  });
  
  testWidgets('handles empty simulation gracefully', (tester) async {
    when(mockSimulation.bodies).thenReturn([]);
    
    await tester.pumpWidget(
      MaterialApp(home: SimulationCanvas(simulationService: mockSimulation)),
    );
    
    // Should not throw and should show appropriate empty state
    expect(find.byType(SimulationCanvas), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  
  testWidgets('updates when simulation changes', (tester) async {
    // Start with one body
    when(mockSimulation.bodies).thenReturn([testUtils.createTestEarth()]);
    
    await tester.pumpWidget(
      MaterialApp(home: SimulationCanvas(simulationService: mockSimulation)),
    );
    
    // Add another body
    when(mockSimulation.bodies).thenReturn([
      testUtils.createTestEarth(),
      testUtils.createTestMoon(),
    ]);
    
    // Trigger rebuild
    mockSimulation.notifyListeners();
    await tester.pump();
    
    // Should handle the change without errors
    expect(tester.takeException(), isNull);
  });
}
```

### Custom Painter Testing
```dart
// test/painters/trail_painter_test.dart
class TrailPainterTest {
  group('TrailPainter', () {
    test('paints without errors for valid trail data', () {
      final trail = TestUtils.createTestTrail(pointCount: 100);
      final painter = TrailPainter(trailPoints: trail);
      final canvas = MockCanvas();
      final size = Size(800, 600);
      
      // Should not throw during painting
      expect(() => painter.paint(canvas, size), returnsNormally);
    });
    
    test('handles empty trail gracefully', () {
      final painter = TrailPainter(trailPoints: []);
      final canvas = MockCanvas();
      final size = Size(800, 600);
      
      expect(() => painter.paint(canvas, size), returnsNormally);
    });
    
    test('shouldRepaint logic is correct', () {
      final trail1 = TestUtils.createTestTrail(pointCount: 50);
      final trail2 = TestUtils.createTestTrail(pointCount: 50);
      final trail3 = TestUtils.createTestTrail(pointCount: 60);
      
      final painter1 = TrailPainter(trailPoints: trail1);
      final painter2 = TrailPainter(trailPoints: trail2);  // Same length
      final painter3 = TrailPainter(trailPoints: trail3);  // Different length
      
      // Same content should not repaint
      expect(painter1.shouldRepaint(painter2), isFalse);
      
      // Different content should repaint  
      expect(painter1.shouldRepaint(painter3), isTrue);
    });
  });
}
```

### State Management Testing
```dart
// test/state/simulation_state_test.dart
class SimulationStateTest {
  late SimulationState simulationState;
  late MockPhysicsService mockPhysics;
  
  setUp() {
    mockPhysics = MockPhysicsService();
    simulationState = SimulationState(physicsService: mockPhysics);
  }
  
  group('simulation lifecycle', () {
    test('starts simulation correctly', () {
      // Arrange
      expect(simulationState.isRunning, isFalse);
      
      // Act
      simulationState.startSimulation();
      
      // Assert
      expect(simulationState.isRunning, isTrue);
      verify(mockPhysics.start()).called(1);
    });
    
    test('pauses simulation correctly', () {
      simulationState.startSimulation();
      
      simulationState.pauseSimulation();
      
      expect(simulationState.isRunning, isFalse);
      verify(mockPhysics.pause()).called(1);
    });
    
    test('notifies listeners on state changes', () {
      var notificationCount = 0;
      simulationState.addListener(() => notificationCount++);
      
      simulationState.startSimulation();
      simulationState.pauseSimulation();
      
      expect(notificationCount, equals(2));
    });
  });
  
  test('disposes resources properly', () {
    simulationState.dispose();
    
    verify(mockPhysics.dispose()).called(1);
    expect(simulationState.hasListeners, isFalse);
  });
}
```

### Integration Testing for Physics Accuracy
```dart  
// test/integration/three_body_simulation_test.dart
class ThreeBodySimulationTest {
  group('Three Body Problem simulation', () {
    testWidgets('maintains energy conservation over time', (tester) async {
      // Arrange - Create stable three-body system
      final simulation = SimulationService();
      final bodies = [
        TestUtils.createTestBody(
          id: 'body1',
          mass: PhysicsConstants.solarMass,
          position: Vector3(0, 0, 0),
          velocity: Vector3(0, 0, 0),
        ),
        TestUtils.createTestBody(
          id: 'body2', 
          mass: PhysicsConstants.earthMass,
          position: Vector3(PhysicsConstants.astronomicalUnit, 0, 0),
          velocity: Vector3(0, 29780, 0), // Earth's orbital velocity
        ),
        TestUtils.createTestBody(
          id: 'body3',
          mass: PhysicsConstants.moonMass,
          position: Vector3(PhysicsConstants.astronomicalUnit + 384400000, 0, 0),
          velocity: Vector3(0, 29780 + 1022, 0), // Combined Earth-Moon velocity
        ),
      ];
      
      simulation.initializeBodies(bodies);
      
      // Act - Run simulation for specific time
      final initialEnergy = PhysicsUtils.calculateTotalEnergy(bodies);
      
      for (int step = 0; step < 1000; step++) {
        simulation.updatePhysics(PhysicsConstants.defaultTimeStep);
      }
      
      final finalEnergy = PhysicsUtils.calculateTotalEnergy(bodies);
      
      // Assert - Energy should be conserved within numerical precision
      final energyDrift = (finalEnergy - initialEnergy).abs() / initialEnergy;
      
      expect(
        energyDrift,
        lessThan(PhysicsConstants.energyConservationTolerance),
        reason: 'Energy conservation must be maintained in physics simulation',
      );
    });
  });
}
```

## ❌ WRONG Testing Patterns (FLAG IMMEDIATELY)

```dart
// ❌ No corresponding test file for a class
// lib/models/celestial_body.dart exists
// test/models/celestial_body_test.dart MISSING!

// ❌ Testing magic numbers instead of constants
expect(widget.padding, equals(16.0));           // ❌ Should test AppTypography.spacingLarge

// ❌ Imprecise physics comparisons  
expect(force, equals(expectedForce));           // ❌ Use closeTo() for floating point

// ❌ Not testing edge cases
test('calculates force', () {
  // Only tests normal case, ignores zero distance, infinite mass, etc.
});

// ❌ No performance validation in widget tests
testWidgets('renders widget', (tester) async {
  // Pumps widget but doesn't check render time
});
```

## Testing Utilities (Extract Common Logic)

### Test Helper Utilities
```dart
// test/test_utils.dart
class TestUtils {
  /// Create a test celestial body with physics constants
  static CelestialBody createTestBody({
    String id = 'test-body',
    double mass = 1e24,
    Vector3? position,
    Vector3? velocity,
    BodyType type = BodyType.planet,
  }) {
    return CelestialBody(
      id: id,
      type: type,
      mass: mass,
      position: position ?? Vector3.zero(),
      velocity: velocity ?? Vector3.zero(),
      radius: PhysicsUtils.estimateRadiusFromMass(mass, type),
      temperature: PhysicsUtils.estimateTemperatureFromMass(mass, type),
    );
  }
  
  /// Create Earth with accurate physical parameters
  static CelestialBody createTestEarth() {
    return createTestBody(
      id: 'earth',
      mass: PhysicsConstants.earthMass,
      position: Vector3(PhysicsConstants.astronomicalUnit, 0, 0),
      velocity: Vector3(0, 29780, 0), // m/s
      type: BodyType.planet,
    );
  }
  
  /// Create realistic trail for testing
  static List<TrailPoint> createTestTrail({int pointCount = 100}) {
    return List.generate(pointCount, (index) {
      final angle = (index / pointCount) * 2 * math.pi;
      return TrailPoint(
        position: Offset(
          math.cos(angle) * 100,
          math.sin(angle) * 100,
        ),
        timestamp: DateTime.now().subtract(Duration(seconds: index)),
      );
    });
  }
}
```

### Mock Objects with Physics Behavior
```dart
// test/test_mocks.dart
class MockPhysicsService extends Mock implements PhysicsService {
  final List<CelestialBody> _bodies = [];
  
  @override
  List<CelestialBody> get bodies => _bodies;
  
  void addTestBody(CelestialBody body) {
    _bodies.add(body);
    notifyListeners();
  }
}

class MockTemperatureService extends Mock implements TemperatureService {
  @override
  double calculateBodyTemperature(CelestialBody body) {
    // Return realistic temperature for testing
    return TemperatureUtils.estimateTemperatureFromMass(body.mass, body.type);
  }
}
```

## Test Coverage Goals

- **Physics calculations**: 100% coverage - critical for accuracy
- **UI widgets**: 95% coverage - some rendering edge cases acceptable  
- **State management**: 100% coverage - essential for app stability
- **Utility functions**: 100% coverage - used throughout codebase

## Reference Files

- Testing patterns: `.github/prompts/testing.md`
- Test utilities: `test/test_utils.dart`
- Physics test data: `test/test_data/physics_scenarios.dart`
- Widget test helpers: `test/test_helpers/widget_testers.dart`