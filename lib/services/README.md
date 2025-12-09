# Services Organization

This directory is being reorganized into logical subdirectories to improve maintainability and reduce complexity.

## New Structure

```
services/
├── firebase/                   # Firebase integration services
│   ├── firebase_service.dart
│   ├── app_check_service.dart
│   ├── auth_service.dart
│   ├── remote_config_service.dart
│   └── user_data_sync_service.dart
├── simulation/                 # Physics & simulation services
│   ├── simulation.dart
│   ├── orbital_mechanics_service.dart
│   ├── orbital_prediction_engine.dart
│   ├── collision_effects_service.dart
│   ├── temperature_service.dart
│   ├── stellar_color_service.dart
│   ├── habitable_zone_service.dart
│   ├── asteroid_belt_system.dart
│   ├── body_interaction_service.dart
│   ├── body_movement_service.dart
│   └── body_placement_service.dart
├── ui/                         # User interface services
│   ├── fullscreen_service.dart
│   ├── haptic_feedback_service.dart
│   ├── accessibility_service.dart
│   ├── screenshot_mode_service.dart
│   ├── keyboard_navigation_service.dart
│   ├── semantic_focus_service.dart
│   ├── navigation_service.dart
│   └── onboarding_service.dart
├── camera/                     # Camera control services
│   ├── camera_gesture_service.dart
│   └── cinematic_camera_controller.dart
├── scenarios/                  # Scenario management services
│   ├── scenario_service.dart
│   ├── custom_scenario_manager.dart
│   ├── custom_scenario_storage.dart
│   ├── scenario_serialization_service.dart
│   └── simulation_share_service.dart
└── platform/                   # Platform integration services
    ├── platform_channel_service.dart
    ├── play_integrity_service.dart
    ├── play_integrity_backend_service.dart
    ├── version_service.dart
    └── changelog_service.dart
```

## Migration Status

🚧 **Phase 1**: Directory structure created alongside existing code
- Existing services remain in `lib/services/` root
- New subdirectories created for future organization
- Both flat and hierarchical structures coexist

## Purpose of Each Category

### Firebase Services
All services that interact with Firebase (Auth, Firestore, Remote Config, App Check, Analytics).

### Simulation Services
Core physics engine and simulation logic, including:
- Gravitational calculations
- Orbital mechanics
- Collision detection and effects
- Temperature and color calculations
- Body interaction and placement

### UI Services
User interface and interaction services:
- Haptic feedback
- Accessibility support
- Fullscreen management
- Screenshot mode
- Navigation
- Keyboard controls

### Camera Services
Camera control and cinematic movement:
- Gesture handling
- Camera animations
- Cinematic techniques

### Scenario Services
Scenario creation, management, and persistence:
- Preset scenarios
- Custom scenario CRUD
- Serialization/deserialization
- Sharing functionality

### Platform Services
Platform-specific integrations:
- Native platform channels
- Play Integrity (Android)
- Version checking
- Changelog management

## Service Design Guidelines

- **Single Responsibility**: Each service has one clear purpose
- **Dependency Injection**: Services should be injectable
- **Testability**: All services should be easily testable
- **State Management**: Use Provider or appropriate state management
- **Error Handling**: Comprehensive error handling and logging

## Example Service Structure

```dart
// services/simulation/orbital_mechanics_service.dart
class OrbitalMechanicsService {
  /// Calculate orbital parameters for a body
  OrbitalParameters calculateOrbit(Body body, Body parent) {
    // Implementation
  }
  
  /// Predict future orbital path
  List<Vector3> predictOrbit(Body body, {int steps = 100}) {
    // Implementation
  }
}
```

## Related Documentation

- See `features/README.md` for feature-specific service organization
- See `.github/copilot-instructions.md` for code standards
- See individual service files for API documentation
