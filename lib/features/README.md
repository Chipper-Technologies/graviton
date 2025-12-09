# Features Module

This directory contains feature-specific code organized by domain, following Clean Architecture principles.

## Structure

```
features/
├── auth/              # Authentication & authorization
│   ├── data/         # Auth services, Firebase integration
│   ├── domain/       # User models, auth entities
│   ├── presentation/ # Login screens, auth widgets
│   └── state/        # Auth state management
├── simulation/        # Physics simulation engine
│   ├── data/         # Simulation services, physics calculations
│   ├── domain/       # Body models, orbital mechanics
│   ├── presentation/ # Simulation viewport, controls
│   └── state/        # Simulation state management
├── scenarios/         # Scenario management
│   ├── data/         # Scenario services, storage
│   ├── domain/       # Scenario models, configurations
│   ├── presentation/ # Scenario selection, editor screens
│   └── state/        # Scenario state
├── settings/          # Application settings
│   ├── data/         # Settings services
│   ├── domain/       # Settings models
│   ├── presentation/ # Settings screens
│   └── state/        # Settings state
└── account/           # User account management
    ├── data/         # User data services
    ├── domain/       # User profile models
    ├── presentation/ # Account screens, profile widgets
    └── state/        # Account state
```

## Architecture Layers

### Data Layer
- **Services**: Business logic implementation
- **Repositories**: Data access abstraction (if needed)
- **Data Sources**: External APIs, Firebase, local storage

### Domain Layer
- **Models**: Core business entities
- **Enums**: Feature-specific enumerations
- **Interfaces**: Abstract contracts (if needed)

### Presentation Layer
- **Screens**: Full-page views
- **Widgets**: Feature-specific UI components
- **Dialogs**: Feature-specific dialogs

### State Layer
- **State Management**: Provider, ChangeNotifier, etc.
- **State Models**: UI state classes

## Guidelines

- **Features should be independent**: Minimize dependencies between features
- **Use core for shared code**: Don't duplicate utilities or constants
- **Follow single responsibility**: Each feature has one clear purpose
- **Dependency direction**: Presentation → Domain ← Data
- **Import from shared**: Use `shared/` for truly shared widgets

## Migration Status

🚧 **Phase 1**: Directory structure created alongside existing code
- Existing code remains in original locations
- New structure being prepared for gradual migration
- Both structures will coexist during transition

## Example Feature Structure

```dart
// features/auth/domain/user.dart
class User {
  final String id;
  final String email;
  // ...
}

// features/auth/data/auth_service.dart
class AuthService {
  Future<User?> signIn() { /* ... */ }
}

// features/auth/presentation/login_screen.dart
class LoginScreen extends StatelessWidget {
  // Uses AuthService, displays UI
}

// features/auth/state/auth_state.dart
class AuthState extends ChangeNotifier {
  // Manages auth state
}
```

## Related Documentation

- See `core/README.md` for shared functionality
- See `shared/README.md` for shared widgets
- See `.github/copilot-instructions.md` for code standards
