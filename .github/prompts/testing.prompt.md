# Testing Prompt

You are working on Graviton's test suite. Maintain comprehensive coverage for this physics simulation app:

## Test Categories

1. **Unit Tests**: Individual functions and classes
2. **Widget Tests**: UI components and interactions  
3. **Integration Tests**: End-to-end scenarios
4. **Physics Tests**: Numerical accuracy and stability

## Physics Testing Patterns

```dart
// Test gravitational force calculation
testWidgets('gravitational force follows inverse square law', (tester) async {
  final body1 = Body.star(mass: 10.0, position: Vector3.zero());
  final body2 = Body.star(mass: 5.0, position: Vector3(10.0, 0.0, 0.0));
  
  final force = calculateGravitationalForce(body1, body2);
  
  // Verify magnitude follows F = G*m1*m2/r²
  final expectedMagnitude = SimulationConstants.gravitationalConstant * 
    body1.mass * body2.mass / 100.0; // distance² = 100
  
  expect(force.length, closeTo(expectedMagnitude, 0.001));
});

// Test energy conservation
test('total energy is conserved in two-body system', () {
  final simulation = Simulation();
  simulation.addBody(Body.star(mass: 10.0));
  simulation.addBody(Body.planet(mass: 1.0));
  
  final initialEnergy = simulation.getTotalEnergy();
  
  // Run simulation for many steps
  for (int i = 0; i < 1000; i++) {
    simulation.updatePhysics(0.01);
  }
  
  final finalEnergy = simulation.getTotalEnergy();
  
  // Energy should be conserved within numerical precision
  expect(finalEnergy, closeTo(initialEnergy, 0.01));
});
```

## State Management Testing

```dart
testWidgets('simulation state notifies listeners on body addition', (tester) async {
  final simulationState = SimulationState();
  bool notified = false;
  
  simulationState.addListener(() {
    notified = true;
  });
  
  simulationState.addBody(Body.star());
  
  expect(notified, isTrue);
  expect(simulationState.bodies.length, equals(1));
});
```

## Widget Testing

```dart
testWidgets('space painter renders without crashing', (tester) async {
  final bodies = [
    Body.star(position: Vector3.zero()),
    Body.planet(position: Vector3(10.0, 0.0, 0.0)),
  ];
  
  await tester.pumpWidget(
    MaterialApp(
      home: CustomPaint(
        painter: SpacePainter(
          bodies: bodies,
          trails: {},
          cameraPosition: CameraPosition.initial(),
        ),
      ),
    ),
  );
  
  expect(tester.takeException(), isNull);
});
```

## Performance Testing

```dart
test('simulation performs at target framerate with many bodies', () {
  final simulation = Simulation();
  
  // Add many bodies
  for (int i = 0; i < 100; i++) {
    simulation.addBody(Body.randomStar());
  }
  
  final stopwatch = Stopwatch()..start();
  const targetFrameTime = Duration(milliseconds: 16); // 60fps
  
  for (int frame = 0; frame < 60; frame++) {
    final frameStart = stopwatch.elapsed;
    
    simulation.updatePhysics(1.0 / 60.0);
    
    final frameTime = stopwatch.elapsed - frameStart;
    expect(frameTime, lessThan(targetFrameTime));
  }
});
```

## Mock Services

```dart
// Mock Firebase for testing
class MockFirebaseService extends Mock implements FirebaseService {}

// Mock preferences
class MockSharedPreferences extends Mock implements SharedPreferences {
  final Map<String, dynamic> _store = {};
  
  @override
  Future<bool> setDouble(String key, double value) async {
    _store[key] = value;
    return true;
  }
  
  @override
  double? getDouble(String key) => _store[key] as double?;
}
```

## Test Coverage Goals

- **Overall**: >90% line coverage
- **Physics calculations**: 100% coverage
- **State management**: 100% coverage  
- **UI widgets**: >85% coverage
- **Service layer**: >90% coverage

## Running Tests

```bash
# Run all tests with coverage
flutter test --coverage

# Generate coverage report
genhtml coverage/lcov.info -o coverage/html

# Run specific test file
flutter test test/services/simulation_test.dart

# Run integration tests
flutter test integration_test/
```

## File Locations

- Unit tests: `test/`
- Widget tests: `test/widgets/`
- Integration tests: `test/integration/`
- Test utilities: `test/test_utils.dart`, `test/test_mocks.dart`
- Coverage tools: `tools/analyze_coverage.py`