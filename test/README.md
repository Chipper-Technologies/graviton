# Test Organization

This document describes the organization of tests in the Graviton project. The test suite is organized into logical directories that mirror the application structure and functionality.

## Test Coverage Summary

**Current Coverage: High coverage across all critical components**
- ✅ **788+ passing tests** with comprehensive coverage across all test categories
- ✅ **Integration Tests**: Complete end-to-end app functionality testing with robust timer management
- ✅ **Models**: Complete coverage for all data models including physics, screenshots, and celestial bodies
- ✅ **Services**: Comprehensive service layer testing including Firebase, camera control, and physics
- ✅ **State Management**: Full coverage for app, UI, simulation, camera, and physics state
- ✅ **Utilities**: Complete coverage for physics calculations, rendering utilities, and test helpers
- ✅ **Painters**: Tests for all rendering components including gravity, trails, and effects
- ✅ **Widgets**: UI component tests with internationalization support for all dialogs and overlays
- ✅ **Features**: Comprehensive testing of advanced features like cinematic cameras and galaxy formation
- ✅ **Enums & Constants**: Validation of enumeration types and configuration constants

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
├── 🎪 widgets/             # UI widget tests
├── 🏷️ enums/               # Enumeration tests
└── 📐 constants/           # Constants and configuration tests
```

## Test Categories

### 📱 Core (`test/core/`)
Tests for fundamental app functionality:
- `initialization_test.dart` - App startup and initialization

### 🚀 Features (`test/features/`)
Tests for specific app features and capabilities:
- `auto_zoom_test.dart` - Automatic zoom functionality
- `cinematic_camera_integration_test.dart` - Cinematic camera system integration
- `debug_simulation_test.dart` - Debug and diagnostic features
- `enhanced_3d_test.dart` - 3D rendering enhancements
- `enhanced_zoom_test.dart` - Enhanced zoom with body targeting
- `galaxy_formation_stability_test.dart` - Galaxy formation stability testing
- `galaxy_long_term_test.dart` - Long-term galaxy evolution testing
- `habitable_zone_test.dart` - Habitable zone calculations and display
- `i18n_test.dart` - Internationalization and localization
- `language_selection_test.dart` - Manual language selection
- `simulation_reset_test.dart` - Simulation reset functionality
- `trail_debug_test.dart` - Trail rendering and debugging

### 🌌 Scenarios (`test/scenarios/`)
Tests for specific simulation scenarios:
- `earth_moon_sun_test.dart` - Earth-Moon-Sun system simulation
- `solar_system_test.dart` - Solar system simulation

### �️ Enums (`test/enums/`)
Tests for enumeration types and their behaviors:
- `cinematic_camera_technique_test.dart` - Cinematic camera technique validation

### 📐 Constants (`test/constants/`)
Tests for application constants and configuration values:
- `rendering_constants_test.dart` - Rendering system constants validation

### �🎭 Demos (`test/demos/`)
Demonstration scripts and examples:
- `demo_auto_zoom.dart` - Auto zoom feature demonstration
- `demo_enhanced_zoom.dart` - Enhanced zoom feature demonstration

### 🔧 Integration (`test/integration/`)
End-to-end integration tests with robust timer and state management:
- `app_integration_test.dart` - **Complete app workflow testing** (12 comprehensive tests) ✨ *ENHANCED*
  - App launch and initialization with timeout handling
  - UI display and simulation canvas rendering
  - Simulation controls (play/pause/reset) functionality
  - Camera controls and gesture interactions
  - Statistics overlay toggling
  - Error handling and recovery
  - Performance validation under load
  - Multi-language support verification
  - UI state persistence across operations
- `settings_persistence_test.dart` - Settings save/load functionality
- **TestHelpers utility** - Shared integration test patterns

### 📊 Models (`test/models/`)
Tests for data models and structures:
- `body_test.dart` - Celestial body model
- `camera_position_test.dart` - Screenshot camera positioning
- `merge_flash_test.dart` - Body merge effects
- `orbital_event_test.dart` - Orbital event data structures
- `physics_settings_test.dart` - Physics configuration models
- `screenshot_preset_test.dart` - Screenshot preset configurations
- `screenshot_presets_test.dart` - Predefined screenshot collections
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
- `cinematic_camera_controller_test.dart` - Cinematic camera control system
- `firebase_service_test.dart` - Firebase analytics and crashlytics integration
- `orbital_prediction_engine_test.dart` - Orbital prediction and trajectory analysis
- `remote_config_service_test.dart` - Remote configuration management
- `scenario_service_test.dart` - Scenario management
- `screenshot_mode_service_test.dart` - Screenshot mode functionality
- `simulation_physics_test.dart` - Physics engine and calculations
- `simulation_test.dart` - Core simulation engine
- `version_service_test.dart` - App version management and updates

### 🎯 State (`test/state/`)
Tests for state management:
- `app_state_physics_integration_test.dart` - App state and physics integration
- `app_state_test.dart` - Application-wide state
- `camera_reset_test.dart` - Camera reset functionality
- `camera_roll_test.dart` - Camera roll controls
- `camera_state_test.dart` - Camera state management
- `physics_state_test.dart` - Physics state management
- `simulation_state_test.dart` - Simulation state management
- `ui_state_test.dart` - UI state and preferences

### 🛠 Utils (`test/utils/`)
Tests for utility functions and test infrastructure:
- `collision_utils_test.dart` - Collision detection utilities
- `painter_utils_test.dart` - Painting helper functions
- `physics_utils_test.dart` - Physics calculations
- `random_utils_test.dart` - Random number generation
- `star_generator_test.dart` - Background star generation
- `test_helpers.dart` - **Integration test utilities and patterns**
- `vector_utils_test.dart` - Vector mathematics

### 🎪 Widgets (`test/widgets/`)
Tests for UI widgets and components:
- `about_dialog_test.dart` - About dialog
- `auto_pause_dialog_test.dart` - Auto-pause functionality dialog
- `body_properties_dialog_test.dart` - Body property editing dialog
- `body_property_editor_overlay_test.dart` - Body property overlay editor
- `copyright_text_test.dart` - Copyright text widget
- `floating_simulation_controls_test.dart` - Floating simulation controls
- `help_dialog_test.dart` - Help and documentation dialog
- `scenario_selection_dialog_test.dart` - Scenario selection interface
- `screenshot_mode_widget_test.dart` - Screenshot mode controls with i18n
- `settings_dialog_test.dart` - Settings configuration dialog
- `stats_overlay_test.dart` - Statistics overlay
- `tutorial_overlay_test.dart` - Tutorial and onboarding overlay
- `url_launcher_test.dart` - URL launching functionality

### 🏷️ Enums (`test/enums/`)
Tests for enumeration types and constants:
- `cinematic_camera_technique_test.dart` - Cinematic camera technique enumerations

### 📐 Constants (`test/constants/`)
Tests for application constants and configuration:
- `rendering_constants_test.dart` - Rendering configuration constants

## Recent Test Enhancements ✨
### Integration Test Infrastructure Overhaul
- **Robust timer management**: Fixed hanging integration tests with proper timer cleanup
- **SharedPreferences handling**: Timeout-based initialization prevents test hangs
- **TestHelpers utility**: Reusable patterns for integration test setup and teardown
- **Complete app coverage**: 12 comprehensive integration tests covering all major workflows
- **Performance validation**: Tests handle rapid updates and stress scenarios
- **Error recovery**: Graceful handling of initialization failures and edge cases

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

### Run Integration Tests
```bash
# Run all integration tests
flutter test test/integration/

# Run specific integration test
flutter test test/integration/app_integration_test.dart

# Run integration tests with verbose output
flutter test test/integration/ --verbose
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
6. **Timer Management**: Use TestHelpers for integration tests to handle UI timers properly
7. **Timeout Handling**: Implement timeouts for async operations to prevent hanging tests

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
8. **For integration tests**: Use TestHelpers utility for proper timer and state management

### Integration Test Guidelines ✨
- **Use TestHelpers.setupAndPumpApp()** for complete app initialization with timer management
- **Use TestHelpers.initializeAppStateWithTimeout()** for AppState setup with timeout protection
- **Use TestHelpers.pumpAppTimers()** after test operations to clean up UI timers
- **Mock SharedPreferences** with `SharedPreferences.setMockInitialValues({})` in setUp()
- **Test timeouts**: Expect tests to complete within reasonable time (< 10 seconds)
- **Error scenarios**: Include tests for initialization failures and edge cases

### Screenshot Mode Testing Guidelines
- Use `FlavorConfig.instance.initialize(flavor: AppFlavor.dev)` to enable screenshot mode
- Test all language variants when adding UI strings
- Verify widget availability logic for production vs development builds
- Include preset validation and error handling scenarios