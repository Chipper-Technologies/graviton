# Code Quality & Standards Prompt

You are working on Graviton with strict code quality standards. Follow these non-negotiable practices:

## Typography & Constants Usage

**ALWAYS use AppTypography constants** - Never use magic numbers for:
- Font sizes: `AppTypography.fontSizeMedium`, `AppTypography.fontSizeTitle`
- Opacity: `AppTypography.opacityMedium`, `AppTypography.opacityFaint`  
- Spacing: `AppTypography.spacingLarge`, `AppTypography.spacingXSmall`
- Icon sizes: `AppTypography.iconSizeMedium`, `AppTypography.iconSizeXLarge`
- Border radius: `AppTypography.radiusMedium`, `AppTypography.radiusLarge`
- Dimensions: `AppTypography.dropdownItemHeight`

```dart
// ✅ CORRECT: Using AppTypography constants
Container(
  padding: EdgeInsets.all(AppTypography.spacingMedium),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(AppTypography.radiusLarge),
    border: AppTypography.createBorder(
      opacity: AppTypography.opacityFaint,
    ),
  ),
  child: Text(
    'Gravitational Force',
    style: TextStyle(
      fontSize: AppTypography.fontSizeMedium,
      color: AppColors.starWhite.withValues(
        alpha: AppTypography.opacityHigh,
      ),
    ),
  ),
)

// ❌ WRONG: Magic numbers
Container(
  padding: EdgeInsets.all(12.0), // Should be AppTypography.spacingMedium
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(8.0), // Should be AppTypography.radiusMedium
  ),
  child: Text(
    'Gravitational Force',
    style: TextStyle(
      fontSize: 14.0, // Should be AppTypography.fontSizeMedium
      color: Colors.white.withOpacity(0.7), // Should use AppTypography.opacityHigh
    ),
  ),
)
```

## File Organization - One Class Per File

**NEVER put multiple classes, models, or enums in a single file.** Each deserves its own categorized file with proper unit tests.

```dart
// ✅ CORRECT: Separate files
// lib/models/body.dart - Contains only Body class
// lib/models/trail_point.dart - Contains only TrailPoint class
// lib/enums/body_type.dart - Contains only BodyType enum
// lib/enums/simulation_state.dart - Contains only SimulationState enum

// test/models/body_test.dart - Tests for Body class
// test/models/trail_point_test.dart - Tests for TrailPoint class
// test/enums/body_type_test.dart - Tests for BodyType enum

// ❌ WRONG: Multiple classes in one file
// lib/models/simulation_models.dart - Contains Body, TrailPoint, CameraPosition, etc.
```

## Utility Functions - Extract Common Logic

**Use utility files for reusable functions.** Avoid putting private utilities inside classes or models.

```dart
// ✅ CORRECT: Extracted utility functions
// lib/utils/physics_utils.dart
class PhysicsUtils {
  /// Calculate distance between two 3D points
  static double calculateDistance(Vector3 point1, Vector3 point2) {
    return (point2 - point1).length;
  }
  
  /// Convert simulation units to display units
  static double toDisplayUnits(double simulationValue) {
    return simulationValue * SimulationConstants.displayScale;
  }
  
  /// Check if two bodies are colliding
  static bool areColliding(Body body1, Body body2) {
    final distance = calculateDistance(body1.position, body2.position);
    return distance <= (body1.radius + body2.radius);
  }
}

// Usage in classes
class SimulationService {
  void updatePhysics() {
    for (int i = 0; i < bodies.length; i++) {
      for (int j = i + 1; j < bodies.length; j++) {
        if (PhysicsUtils.areColliding(bodies[i], bodies[j])) {
          _handleCollision(bodies[i], bodies[j]);
        }
      }
    }
  }
}

// ❌ WRONG: Utility functions inside classes
class Body {
  Vector3 position;
  double radius;
  
  // This should be in PhysicsUtils
  bool _isCollidingWith(Body other) {
    final distance = (other.position - position).length;
    return distance <= (radius + other.radius);
  }
}
```

## No Magic Numbers Policy

**Every numeric value must be a named constant** from appropriate constants files:

```dart
// ✅ CORRECT: Named constants
class SimulationConstants {
  static const double gravitationalConstant = 1.2;
  static const double collisionSoftening = 0.01;
  static const int maxTrailPoints = 500;
  static const double trailFadeRate = 0.5;
}

class RenderingConstants {
  static const double glowIntensity = 2.5;
  static const double minimumBodySize = 3.0;
  static const double trailStrokeWidth = 1.2;
}

// Usage
final force = SimulationConstants.gravitationalConstant * mass1 * mass2 / distanceSquared;

// ❌ WRONG: Magic numbers
final force = 1.2 * mass1 * mass2 / distanceSquared; // What is 1.2?
```

## Documentation Requirements

**Keep documentation updated and accurate.** Every public API must have comprehensive documentation:

```dart
/// Calculates gravitational force between two celestial bodies.
/// 
/// Uses Newton's law of universal gravitation with collision softening
/// to prevent numerical singularities when bodies are very close.
/// 
/// **Physics Formula**: F = G * m1 * m2 / (r² + softening²)
/// 
/// **Parameters**:
/// - [body1]: First celestial body
/// - [body2]: Second celestial body
/// 
/// **Returns**: Force vector pointing from body1 toward body2
/// 
/// **Example**:
/// ```dart
/// final earth = Body.planet(mass: 1.0);
/// final moon = Body.moon(mass: 0.012);
/// final force = PhysicsUtils.calculateGravitationalForce(earth, moon);
/// ```
/// 
/// **See also**:
/// - [SimulationConstants.gravitationalConstant]
/// - [SimulationConstants.collisionSoftening]
static Vector3 calculateGravitationalForce(Body body1, Body body2) {
  final displacement = body2.position - body1.position;
  final distance = displacement.length;
  
  // Apply collision softening to prevent singularities
  final softenedDistance = math.sqrt(
    distance * distance + 
    SimulationConstants.collisionSoftening * SimulationConstants.collisionSoftening
  );
  
  final forceMagnitude = SimulationConstants.gravitationalConstant * 
    body1.mass * body2.mass / (softenedDistance * softenedDistance * softenedDistance);
  
  return displacement * forceMagnitude;
}
```

## File Naming & Structure

```
lib/
├── constants/
│   ├── simulation_constants.dart    # Physics constants only
│   ├── rendering_constants.dart     # Rendering constants only
│   └── ui_constants.dart           # UI-specific constants only
├── models/
│   ├── body.dart                   # Body class only
│   ├── trail_point.dart            # TrailPoint class only
│   └── camera_position.dart        # CameraPosition class only
├── enums/
│   ├── body_type.dart              # BodyType enum only
│   ├── simulation_state.dart       # SimulationState enum only
│   └── orbital_event_type.dart     # OrbitalEventType enum only
├── utils/
│   ├── physics_utils.dart          # Physics calculations
│   ├── math_utils.dart             # Mathematical operations
│   ├── validation_utils.dart       # Input validation
│   └── format_utils.dart           # String formatting
└── services/
    ├── simulation.dart             # Main simulation service
    └── orbital_mechanics_service.dart # Orbital calculations
```

## Testing Requirements

**Every file must have corresponding unit tests:**

```
test/
├── constants/
│   ├── simulation_constants_test.dart
│   └── rendering_constants_test.dart
├── models/
│   ├── body_test.dart
│   └── trail_point_test.dart
├── enums/
│   ├── body_type_test.dart
│   └── simulation_state_test.dart
├── utils/
│   ├── physics_utils_test.dart
│   └── math_utils_test.dart
└── services/
    └── simulation_test.dart
```

## Code Review Checklist

Before submitting code, verify:

- [ ] All numeric values use named constants from AppTypography or appropriate constants files
- [ ] Each class/model/enum is in its own file with corresponding unit test
- [ ] Common utility functions are extracted to utils/ directory  
- [ ] All public APIs have comprehensive documentation with examples
- [ ] File names are descriptive and follow snake_case convention
- [ ] No magic numbers anywhere in the codebase
- [ ] AppTypography constants are used for all UI dimensions and styling

## Migration Pattern

When refactoring existing code:

```dart
// 1. Extract magic numbers to constants
const double _MAGIC_PADDING = 16.0; // TODO: Use AppTypography.spacingLarge

// 2. Update to use AppTypography
padding: EdgeInsets.all(AppTypography.spacingLarge),

// 3. Extract utility functions
// Move _calculateDistance() to PhysicsUtils.calculateDistance()

// 4. Split large files
// Move CameraPosition class from simulation_models.dart to camera_position.dart

// 5. Add comprehensive tests
// Create camera_position_test.dart with full coverage
```