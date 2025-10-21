# Test Organization

This document describes the organization of tests in the Graviton project. The test suite is organized into logical directories that mirror the application structure and functionality.

## Test Coverage Summary

**Current Coverage: 41% (2,288 out of 5,581 lines)**
- ✅ **473 passing tests** with comprehensive unit test coverage
- ✅ **Models**: Complete coverage for screenshot models, body models, trail points
- ✅ **Services**: Comprehensive service layer testing with graceful error handling  
- ✅ **State Management**: Full coverage for app, UI, simulation, and camera state
- ✅ **Utilities**: Complete coverage for physics calculations and rendering utilities
- ✅ **Painters**: Tests for gravitational rendering and visual effects
- ✅ **Widgets**: UI component tests with internationalization support

## Directory Structure

```
test/
├── 📱 core/                # Core application functionality
├── 🚀 features/            # Feature-specific tests
├── 🌌 scenarios/           # Simulation scenario tests
├── 🎭 demos/               # Demo scripts and examples
├── 🔧 integration/         # Integration tests
├── 📊 models/              # Data model tests
├── 🎨 painters/            # Rendering and painting tests
├── 🔌 services/            # Service layer tests
├── 🎯 state/               # State management tests
├── 🛠 utils/               # Utility function tests
└── 🎪 widgets/             # UI widget tests
```

## Test Categories

### 📱 Core (`test/core/`)
Tests for fundamental app functionality:
- `initialization_test.dart` - App startup and initialization

### 🚀 Features (`test/features/`)
Tests for specific app features and capabilities:
- `auto_zoom_test.dart` - Automatic zoom functionality
- `enhanced_zoom_test.dart` - Enhanced zoom with body targeting
- `debug_simulation_test.dart` - Debug and diagnostic features
- `enhanced_3d_test.dart` - 3D rendering enhancements
- `habitable_zone_test.dart` - Habitable zone calculations and display
- `i18n_test.dart` - Internationalization and localization
- `language_selection_test.dart` - Manual language selection
- `simulation_reset_test.dart` - Simulation reset functionality
- `trail_debug_test.dart` - Trail rendering and debugging

### 🌌 Scenarios (`test/scenarios/`)
Tests for specific simulation scenarios:
- `earth_moon_sun_test.dart` - Earth-Moon-Sun system simulation
- `solar_system_test.dart` - Solar system simulation

### 🎭 Demos (`test/demos/`)
Demonstration scripts and examples:
- `demo_auto_zoom.dart` - Auto zoom feature demonstration
- `demo_enhanced_zoom.dart` - Enhanced zoom feature demonstration

### 🔧 Integration (`test/integration/`)
End-to-end integration tests:
- Tests that verify complete app workflows

### 📊 Models (`test/models/`)
Tests for data models and structures:
- `body_test.dart` - Celestial body model
- `camera_position_test.dart` - Screenshot camera positioning ✨ *NEW*
- `merge_flash_test.dart` - Body merge effects
- `screenshot_preset_test.dart` - Screenshot preset configurations ✨ *NEW*
- `screenshot_presets_test.dart` - Predefined screenshot collections ✨ *NEW*
- `trail_point_test.dart` - Trail point data

### 🎨 Painters (`test/painters/`)
Tests for rendering and visual components:
- `background_painter_test.dart` - Background rendering
- `celestial_body_painter_test.dart` - Body rendering
- `effects_painter_test.dart` - Visual effects
- `graviton_painter_test.dart` - Main painter orchestration
- `gravity_painter_test.dart` - Gravity field visualization
- `habitability_painter_test.dart` - Habitability visualization
- `trail_painter_test.dart` - Trail rendering

### 🔌 Services (`test/services/`)
Tests for service layer components:
- `firebase_service_test.dart` - Firebase analytics and crashlytics integration ✨ *NEW*
- `remote_config_service_test.dart` - Remote configuration management ✨ *NEW*
- `scenario_service_test.dart` - Scenario management
- `screenshot_mode_service_test.dart` - Screenshot mode functionality ✨ *NEW*
- `simulation_test.dart` - Core simulation engine
- `version_service_test.dart` - App version management and updates ✨ *NEW*

### 🎯 State (`test/state/`)
Tests for state management:
- `app_state_test.dart` - Application-wide state
- `camera_reset_test.dart` - Camera reset functionality
- `camera_roll_test.dart` - Camera roll controls
- `camera_state_test.dart` - Camera state management
- `simulation_state_test.dart` - Simulation state management
- `ui_state_test.dart` - UI state and preferences

### 🛠 Utils (`test/utils/`)
Tests for utility functions:
- `collision_utils_test.dart` - Collision detection utilities
- `painter_utils_test.dart` - Painting helper functions
- `physics_utils_test.dart` - Physics calculations
- `random_utils_test.dart` - Random number generation
- `star_generator_test.dart` - Background star generation
- `vector_utils_test.dart` - Vector mathematics

### 🎪 Widgets (`test/widgets/`)
Tests for UI widgets and components:
- `about_dialog_test.dart` - About dialog
- `copyright_text_test.dart` - Copyright text widget
- `screenshot_mode_widget_test.dart` - Screenshot mode controls with i18n ✨ *NEW*
- `stats_overlay_test.dart` - Statistics overlay

## Recent Test Additions ✨

### Screenshot Mode Testing
- **Comprehensive i18n testing**: All 7 supported languages verified
- **Service layer integration**: Screenshot mode service with state management
- **Model validation**: Camera positioning and preset configurations
- **Error handling**: Graceful degradation when services unavailable

### Firebase Integration Testing  
- **Analytics tracking**: Event logging with fallback for test environment
- **Crashlytics integration**: Error reporting with proper initialization
- **Service availability**: Graceful handling when Firebase not configured

### Version Management Testing
- **Update detection**: Semantic version comparison and store integration
- **Platform handling**: iOS App Store and Google Play Store support
- **Remote configuration**: Integration with Firebase Remote Config

## Running Tests

### Run All Tests
```bash
flutter test
```

### Run Tests by Category
```bash
# Run feature tests
flutter test test/features/

# Run state management tests
flutter test test/state/

# Run widget tests
flutter test test/widgets/

# Run scenario tests
flutter test test/scenarios/
```

### Run Specific Test
```bash
flutter test test/features/enhanced_zoom_test.dart
```

### Run Tests with Coverage
```bash
flutter test --coverage
```

## Test Naming Conventions

- **Test files**: End with `_test.dart`
- **Demo files**: Start with `demo_` and end with `.dart`
- **Group names**: Use descriptive names that match the functionality being tested
- **Test names**: Use clear, descriptive phrases starting with "should"

## Best Practices

1. **Isolation**: Each test should be independent and not rely on other tests
2. **Descriptive Names**: Test names should clearly describe what is being tested
3. **Arrange-Act-Assert**: Structure tests with clear setup, execution, and verification phases
4. **Mock External Dependencies**: Use mocks for Firebase, file system, and other external services
5. **Test Edge Cases**: Include tests for boundary conditions and error scenarios

## Coverage Goals

- **Unit Tests**: All public methods and critical business logic
- **Widget Tests**: All custom widgets and UI components
- **Integration Tests**: Key user workflows and app functionality
- **Feature Tests**: Complete feature functionality from end to end

## Contributing

When adding new tests:
1. Place them in the appropriate directory based on functionality
2. Follow the existing naming conventions
3. Include both positive and negative test cases
4. Update this README if adding new test categories
5. For i18n tests, verify all 7 supported languages (en, de, es, fr, ja, ko, zh)
6. Mock external dependencies (Firebase, file system) for reliable testing
7. Test both success and error scenarios for service integration

### Screenshot Mode Testing Guidelines
- Use `FlavorConfig.instance.initialize(flavor: AppFlavor.dev)` to enable screenshot mode
- Test all language variants when adding UI strings
- Verify widget availability logic for production vs development builds
- Include preset validation and error handling scenarios