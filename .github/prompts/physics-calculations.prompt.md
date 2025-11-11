# Physics Calculations Prompt

You are working on Graviton, a Flutter-based gravitational physics simulation app. When implementing physics calculations:

## Requirements

1. **Use SimulationConstants**: Always use constants from `lib/constants/simulation_constants.dart` instead of magic numbers
2. **Numerical Stability**: Ensure calculations remain stable for long-term simulations
3. **Performance**: Optimize for 60fps with multiple bodies and trails
4. **Units**: Maintain consistent units throughout calculations
5. **Documentation**: Document complex physics formulas with comments

## Key Physics Concepts

- **Gravitational Force**: F = G * m1 * m2 / r²
- **Softening Parameter**: Use `SimulationConstants.softening` to prevent singularities
- **Orbital Mechanics**: Consider elliptical orbits, escape velocities, and Lagrange points
- **N-Body Problem**: Implement efficient algorithms for multiple body interactions
- **Collision Detection**: Handle both elastic and inelastic collisions
- **Temperature Modeling**: Stellar temperature based on mass and composition

## Code Patterns

```dart
// ✅ CORRECT: Proper file organization and utility extraction
// lib/utils/physics_utils.dart
class PhysicsUtils {
  /// Calculate gravitational force between two celestial bodies.
  /// 
  /// Uses Newton's law with collision softening to prevent singularities.
  /// Formula: F = G * m1 * m2 / (r² + softening²)
  static Vector3 calculateGravitationalForce(Body body1, Body body2) {
    final displacement = body2.position - body1.position;
    final distance = displacement.length;
    
    // Apply softening to prevent singularities - use constants!
    final softenedDistance = math.sqrt(
      distance * distance + 
      SimulationConstants.collisionSoftening * SimulationConstants.collisionSoftening
    );
    
    final forceMagnitude = SimulationConstants.gravitationalConstant * 
      body1.mass * body2.mass / (softenedDistance * softenedDistance * softenedDistance);
    
    return displacement * forceMagnitude;
  }
  
  /// Check if two bodies have collided
  static bool areColliding(Body body1, Body body2) {
    final distance = MathUtils.calculateDistance(body1.position, body2.position);
    return distance <= (body1.radius + body2.radius);
  }
}

// lib/utils/math_utils.dart - Mathematical operations
class MathUtils {
  /// Calculate 3D distance between two points
  static double calculateDistance(Vector3 point1, Vector3 point2) {
    return (point2 - point1).length;
  }
}

// ❌ WRONG: Private utility in Body class
class Body {
  // This should be in PhysicsUtils!
  bool _isCollidingWith(Body other) {
    final distance = (other.position - position).length;
    return distance <= (radius + other.radius);
  }
}

// ❌ WRONG: Magic numbers
final force = 1.2 * mass1 * mass2 / distanceSquared; // Use SimulationConstants.gravitationalConstant!
```

## Testing Requirements

- Unit tests for all physics calculations
- Verify conservation of energy and momentum
- Test edge cases (very close bodies, high velocities)
- Performance benchmarks for complex scenarios

## File Organization

**CRITICAL**: One class per file with comprehensive tests:

```
lib/
├── constants/
│   ├── simulation_constants.dart     # Physics constants only
│   └── rendering_constants.dart      # Rendering constants only
├── models/
│   ├── body.dart                     # Body class only  
│   ├── trail_point.dart              # TrailPoint class only
│   └── orbital_parameters.dart       # OrbitalParameters class only
├── utils/
│   ├── physics_utils.dart            # Physics calculations
│   ├── math_utils.dart               # Mathematical operations
│   └── validation_utils.dart         # Physics validation
└── services/
    ├── simulation.dart               # Main simulation service
    └── orbital_mechanics_service.dart # Orbital calculations

test/
├── constants/
│   ├── simulation_constants_test.dart
│   └── rendering_constants_test.dart
├── models/
│   ├── body_test.dart
│   ├── trail_point_test.dart
│   └── orbital_parameters_test.dart
├── utils/
│   ├── physics_utils_test.dart
│   ├── math_utils_test.dart
│   └── validation_utils_test.dart
└── services/
    ├── simulation_test.dart
    └── orbital_mechanics_service_test.dart
```

**Never put multiple physics classes in a single file.**