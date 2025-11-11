# Flutter State Management Prompt

You are working on Graviton, a Flutter app using Provider pattern for state management. Follow these patterns:

## State Architecture

1. **AppState** (`lib/state/app_state.dart`): UI state, settings, user preferences
2. **SimulationState**: Physics simulation state, bodies, trails
3. **Service Layer**: Business logic encapsulation

## Provider Patterns

```dart
// Correct: Using ChangeNotifier for state with AppTypography constants
class SimulationState extends ChangeNotifier {
  List<Body> _bodies = [];
  
  List<Body> get bodies => List.unmodifiable(_bodies);
  
  void addBody(Body body) {
    _bodies.add(body);
    notifyListeners(); // Always notify after state changes
  }
  
  @override
  void dispose() {
    // Clean up resources
    _clearTrails();
    super.dispose();
  }
}

// ✅ CORRECT: Use AppTypography constants for UI styling
Container(
  padding: EdgeInsets.all(AppTypography.spacingMedium),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(AppTypography.radiusLarge),
    color: AppColors.deepSpace.withValues(
      alpha: AppTypography.opacityMedium,
    ),
  ),
  child: Consumer<SimulationState>(
    builder: (context, state, child) => Text(
      '${state.bodies.length} bodies',
      style: TextStyle(
        fontSize: AppTypography.fontSizeMedium,
        color: AppColors.starWhite.withValues(
          alpha: AppTypography.opacityHigh,
        ),
      ),
    ),
  ),
)

// ❌ WRONG: Magic numbers
Container(
  padding: EdgeInsets.all(12.0), // Use AppTypography.spacingMedium
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(8.0), // Use AppTypography.radiusMedium
    color: Colors.black.withOpacity(0.5), // Use AppTypography constants
  ),
  // ...
)

// Consumer usage
Consumer<SimulationState>(
  builder: (context, simulationState, child) {
    return CustomPaint(
      painter: SpacePainter(bodies: simulationState.bodies),
    );
  },
)
```

## Best Practices

1. **Immutable Getters**: Return unmodifiable collections
2. **Resource Cleanup**: Always dispose of resources in `dispose()`
3. **Selective Rebuilds**: Use `Consumer` over `Provider.of` when possible
4. **State Separation**: Keep UI state separate from simulation state
5. **Listener Management**: Properly remove listeners to prevent memory leaks

## Common Patterns

```dart
// Reading state without rebuilding
final simulationState = Provider.of<SimulationState>(context, listen: false);

// Watching for changes
final bodies = context.watch<SimulationState>().bodies;

// Selective watching
final bodyCount = context.select<SimulationState, int>((state) => state.bodies.length);
```

## Testing

```dart
testWidgets('should update when simulation state changes', (tester) async {
  final simulationState = SimulationState();
  
  await tester.pumpWidget(
    ChangeNotifierProvider.value(
      value: simulationState,
      child: MyWidget(),
    ),
  );
  
  simulationState.addBody(Body.star());
  await tester.pump();
  
  expect(find.text('1 body'), findsOneWidget);
});
```

## File Organization

**CRITICAL**: Each class must be in its own file with corresponding unit tests:

```
lib/state/
├── app_state.dart              # AppState class only
├── simulation_state.dart       # SimulationState class only  
└── camera_state.dart           # CameraState class only

test/state/
├── app_state_test.dart         # Tests for AppState
├── simulation_state_test.dart  # Tests for SimulationState
└── camera_state_test.dart      # Tests for CameraState
```

**Never put multiple state classes in a single file.**