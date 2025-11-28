# Test Organization

This document describes the organization of tests in the Graviton project. The test suite is organized into logical directories that mirror the application structure and functionality.

## Test Coverage Summary

**Current Coverage: Comprehensive coverage across all architectural layers**
- ✅ **5300+ passing tests** with extensive coverage across all test categories
- ✅ **Authentication & Account Management**: Complete Firebase Authentication integration with multi-provider support
- ✅ **Integration Tests**: Complete end-to-end app functionality testing with robust timer management
- ✅ **Models**: Complete coverage for all data models including physics, scenarios, custom content, and celestial bodies
- ✅ **Services**: Comprehensive service layer testing including authentication, user data sync, haptic feedback, accessibility, scenario management, and fullscreen services
- ✅ **State Management**: Full coverage for app, UI, simulation, camera, physics, accessibility, and authentication state management
- ✅ **Utilities**: Complete coverage for physics calculations, rendering utilities, accessibility coordination, and test helpers
- ✅ **Painters**: Tests for all rendering components including gravity, trails, effects, and habitability visualization
- ✅ **Widgets**: Comprehensive UI component tests with authentication UI, account management, haptic feedback, accessibility support, and internationalization
- ✅ **Haptic System**: Complete testing of haptic feedback widgets and service integration
- ✅ **Accessibility**: Full coverage for semantic widgets, focus management, and screen reader support
- ✅ **Scenario Editor**: Comprehensive testing of custom scenario creation, editing, and validation
- ✅ **Features**: Comprehensive testing of advanced features like cinematic cameras, galaxy formation, and immersive modes
- ✅ **Experiments**: Physics experiments for advanced celestial mechanics (binary pulsars, Trojan asteroids)

## Directory Structure

```
test/
├── ⚙️ config/              # Configuration management tests
├── 📋 constants/           # Constants and configuration tests
├── 📱 core/                # Core application functionality
├── 🧪 experiments/         # Physics experiments and advanced mechanics
├── 🏷️ enums/               # Enumeration tests
├── 🚀 features/            # Feature-specific tests
├── 🔧 integration/         # Integration tests
├── 📊 models/              # Data model tests
├── 🎨 painters/            # Rendering and painting tests
├── 🌌 scenarios/           # Simulation scenario tests
├── 📱 screens/             # Screen-level component tests
├── 🔌 services/            # Service layer tests
├── 🎯 state/               # State management tests
├── 🎨 theme/               # Theming and visual styling tests
├── 🛠 utils/               # Utility function tests
└── 🎪 widgets/             # UI widget tests
```

## Test Categories

### ⚙️ Config (`test/config/`)
Tests for configuration management:
- `flavor_config_test.dart` - Application flavor configuration testing

### � Constants (`test/constants/`)
Tests for application constants and configuration values:
- `rendering_constants_test.dart` - Rendering system constants validation

### 📱 Core (`test/core/`)
Tests for fundamental app functionality:
- `initialization_test.dart` - App startup and initialization

### 🧪 Experiments (`test/experiments/`)
Tests for advanced physics experiments and celestial mechanics:
- `binary_pulsar_physics_test.dart` - Binary pulsar gravitational wave physics
- `trojan_asteroids_physics_test.dart` - Trojan asteroid Lagrange point stability

### 🏷️ Enums (`test/enums/`)
Tests for enumeration types and their behaviors:
- `auth_provider_type_test.dart` - Authentication provider type validation
- `cinematic_camera_technique_test.dart` - Cinematic camera technique validation

### 🚀 Features (`test/features/`)
Feature-specific test suites for major application capabilities:
- `auto_zoom_test.dart` - Automatic camera zoom functionality
- `camera_haptic_feedback_test.dart` - Camera control haptic feedback
- `cinematic_camera_integration_test.dart` - Cinematic camera system integration
- `debug_simulation_test.dart` - Debug and development simulation features
- `enhanced_3d_test.dart` - Enhanced 3D rendering features
- `enhanced_zoom_test.dart` - Enhanced zoom capabilities
- `galaxy_formation_stability_test.dart` - Galaxy formation physics stability
- `galaxy_long_term_test.dart` - Long-term galaxy simulation stability
- `galaxy_realistic_colors_test.dart` - Realistic stellar colors in galaxies
- `galaxy_stellar_temperature_test.dart` - Stellar temperature calculations
- `habitable_zone_test.dart` - Habitable zone visualization and calculations
- `i18n_test.dart` - Internationalization and localization
- `language_selection_test.dart` - Language selection functionality
- `realistic_colors_test.dart` - Realistic color rendering system
- `simulation_reset_test.dart` - Simulation reset functionality
- `star_color_mode_test.dart` - Star color rendering modes
- `star_merger_realistic_colors_test.dart` - Star merger color effects
- `stellar_sunspot_physics_test.dart` - Stellar sunspot physics
- `trail_debug_test.dart` - Trail rendering debug features

These feature tests ensure:
- Complete user workflows function correctly
- Cross-component integration works seamlessly
- Performance requirements are met across features
- Accessibility standards are maintained throughout
- Feature interactions don't cause conflicts
- Platform-specific behavior is consistent

### 🌌 Scenarios (`test/scenarios/`)
Tests for specific simulation scenarios:
- `earth_moon_sun_test.dart` - Earth-Moon-Sun system simulation
- `solar_system_test.dart` - Solar system simulation

### 📱 Screens (`test/screens/`)
Tests for screen-level components and navigation:
- `about_screen_test.dart` - About screen functionality
- `account_management_error_handling_test.dart` - Account management error scenarios
- `account_management_screen_test.dart` - Account management interface
- `application_settings_screen_haptic_test.dart` - Application settings with haptic feedback
- `application_settings_screen_test.dart` - Application settings screen
- `developer_tools_screen_test.dart` - Developer tools interface
- `help_screen_test.dart` - Help and documentation screen
- `home_screen_back_button_test.dart` - Home screen navigation behavior
- `home_screen_tap_test.dart` - Home screen interaction testing
- `physics_settings_screen_test.dart` - Physics settings configuration
- `scenario_editor_screen_test.dart` - Custom scenario editor interface
- `scenario_selection_screen_test.dart` - Scenario selection interface

### 🎨 Theme (`test/theme/`)
Tests for theming and visual styling:
- `app_colors_test.dart` - Application color scheme testing
- `app_constraints_test.dart` - Layout constraint testing

### 🧪 Integration Tests (`test/integration/`)
End-to-end testing scenarios that validate complete user workflows:

- `app_integration_test.dart` - Full application lifecycle testing
- `body_editor_astronomical_units_test.dart` - Scenario editor astronomical unit handling
- `camera_rotate_speed_integration_test.dart` - Camera rotation speed control
- `description_field_integration_test.dart` - Scenario description field validation
- `experimental_scenarios_integration_test.dart` - Experimental scenario functionality
- `i18n_custom_scenarios_test.dart` - Custom scenario internationalization
- `scenario_selection_behavior_test.dart` - Scenario selection interface behavior
- `settings_persistence_test.dart` - Settings persistence across sessions
- `solar_system_habitability_integration_test.dart` - Solar system habitability features
- `three_finger_pan_integration_test.dart` - Three-finger pan gesture functionality

#### Authentication Integration (`test/integration/auth/`)
- `auth_state_integration_test.dart` - Authentication state management and persistence
- `auth_ui_integration_test.dart` - Authentication UI components and workflows

These integration tests verify:
- App startup and initialization across all configurations
- Authentication flows with multiple providers (Google, Apple, email)
- User account management and profile editing
- Complete scenario loading and simulation lifecycle
- User onboarding experience from start to finish
- Scenario selection process including custom scenarios
- Physics parameter adjustments and their effects
- Camera controls and interaction workflows
- Settings persistence across app restarts
- Tutorial system progression and completion
- Cross-feature interactions and data flow
- Authentication state persistence across sessions
- User data sync with cloud storage

### 📊 Models (`test/models/`)
Tests for data models and structures:
- `body_creation_test.dart` - Celestial body creation and configuration
- `body_data_test.dart` - Body data structure validation
- `body_test.dart` - Celestial body model
- `camera_movement_test.dart` - Camera animation and movement data
- `camera_position_test.dart` - Screenshot camera positioning
- `changelog_version_test.dart` - Version changelog data structures
- `custom_scenario_summary_test.dart` - Custom scenario summary information
- `indicator_data_test.dart` - UI indicator data structures
- `merge_flash_test.dart` - Body merge effects
- `orbital_event_test.dart` - Orbital event data structures
- `orbital_parameters_test.dart` - Keplerian orbital elements
- `physics_settings_test.dart` - Physics configuration models
- `scenario_configuration_test.dart` - Complete scenario configuration
- `scenario_metadata_test.dart` - Scenario metadata and information
- `scenario_physics_settings_test.dart` - Per-scenario physics parameters
- `scenario_validation_result_test.dart` - Scenario validation results
- `screenshot_preset_test.dart` - Screenshot preset configurations
- `screenshot_presets_test.dart` - Predefined screenshot collections
- `trail_point_test.dart` - Trail point data
- `tutorial_step_test.dart` - Tutorial and onboarding step data

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
- `accessibility_service_test.dart` - Accessibility service and screen reader support
- `auth_service_test.dart` - Firebase Authentication service (email, Google, Apple, GitHub)
- `changelog_service_test.dart` - Version changelog management
- `cinematic_camera_controller_test.dart` - Cinematic camera control system
- `custom_message_test.dart` - Custom message handling system
- `email_verification_test.dart` - Email verification functionality
- `firebase_service_test.dart` - Firebase analytics and crashlytics integration
- `fullscreen_service_test.dart` - Fullscreen system UI management
- `haptic_feedback_service_test.dart` - Haptic feedback coordination and patterns
- `keyboard_navigation_service_test.dart` - Keyboard accessibility and navigation
- `onboarding_service_test.dart` - User onboarding and tutorial coordination
- `orbital_mechanics_service_test.dart` - Orbital mechanics calculations
- `orbital_prediction_engine_test.dart` - Orbital prediction and trajectory analysis
- `remote_config_service_test.dart` - Remote configuration management
- `scenario_service_test.dart` - Scenario management and educational content
- `screenshot_mode_service_test.dart` - Screenshot mode functionality
- `semantic_focus_service_test.dart` - Semantic focus management for accessibility
- `simulation_physics_test.dart` - Physics engine and calculations
- `simulation_share_service_test.dart` - Simulation export and sharing
- `simulation_test.dart` - Core simulation engine
- `temperature_service_constants_test.dart` - Temperature calculation constants
- `temperature_service_test.dart` - Temperature calculations and stellar radiation modeling
- `user_data_sync_service_test.dart` - Cloud data synchronization with Firestore
- `version_service_test.dart` - App version management and updates

### 🎯 State (`test/state/`)
Tests for state management:
- `app_state_physics_integration_test.dart` - App state and physics integration
- `app_state_test.dart` - Application-wide state
- `auth_state_test.dart` - Authentication state management
- `camera_reset_test.dart` - Camera reset functionality
- `camera_roll_test.dart` - Camera roll controls
- `camera_state_test.dart` - Camera state management
- `gravity_well_reset_test.dart` - Gravity well reset preservation
- `physics_state_test.dart` - Physics state management
- `simulation_state_test.dart` - Simulation state management
- `ui_state_test.dart` - UI state and preferences
- `ui_state_fullscreen_test.dart` - Fullscreen UI state management

### 🛠 Utils (`test/utils/`)
Tests for utility functions and test infrastructure:
- `collision_utils_test.dart` - Collision detection utilities
- `fullscreen_utils_test.dart` - Fullscreen mode coordination utilities
- `painter_utils_test.dart` - Painting helper functions
- `physics_utils_test.dart` - Physics calculations
- `random_utils_test.dart` - Random number generation
- `star_generator_test.dart` - Background star generation
- `vector_utils_test.dart` - Vector mathematics

### Test Infrastructure (`test/`)
Core test utilities and mocks:
- `test_helpers.dart` - **Integration test utilities and patterns**
- `test_mocks.dart` - Centralized mock object definitions
- `test_mocks.mocks.dart` - Generated mock implementations
- `test_utils.dart` - Shared test helper functions and assertions

### 🎪 Widgets (`test/widgets/`)
Tests for UI widgets and components organized by functionality:

#### Core Widgets
- `auto_pause_dialog_test.dart` - Auto-pause functionality dialog
- `body_property_editor_overlay_test.dart` - Body property overlay editor
- `bottom_sheet_handle_test.dart` - Bottom sheet drag handle
- `bottom_sheet_header_test.dart` - Bottom sheet header component
- `camera_controls_constants_test.dart` - Camera control constants
- `camera_controls_test.dart` - Camera control panel
- `camera_mode_option_test.dart` - Camera mode selection
- `changelog_dialog_test.dart` - Version changelog display
- `copyright_text_test.dart` - Copyright text widget
- `dev_ribbon_test.dart` - Development mode indicator
- `maintenance_dialog_test.dart` - Maintenance mode dialog
- `maintenance_dialog_widget_test.dart` - Maintenance dialog widget
- `offscreen_indicators_overlay_test.dart` - Off-screen object indicators
- `options_drawer_test.dart` - Settings drawer
- `physics_controls_test.dart` - Physics parameter controls
- `screenshot_countdown_test.dart` - Screenshot countdown timer
- `screenshot_mode_widget_test.dart` - Screenshot mode controls with i18n
- `section_title_test.dart` - Section header component
- `sliding_panel_bottom_sheet_back_button_test.dart` - Bottom sheet back navigation
- `sliding_panel_bottom_sheet_test.dart` - Sliding panel bottom controls
- `stats_overlay_test.dart` - Statistics overlay
- `tutorial_overlay_test.dart` - Tutorial and onboarding overlay
- `url_launcher_test.dart` - URL launching functionality
- `version_check_dialog_test.dart` - Version update dialog
- `visuals_controls_test.dart` - Visual settings controls

#### Account Management Widgets (`test/widgets/account/`)
- `account_management_options_test.dart` - Account management action options
- `avatar_display_test.dart` - Avatar display component
- `avatar_selection_grid_test.dart` - Avatar selection grid interface
- `danger_zone_section_test.dart` - Account deletion controls
- `delete_confirmation_dialog_test.dart` - Deletion confirmation dialog
- `edit_name_form_test.dart` - Display name editing form
- `email_verification_banner_test.dart` - Email verification banner
- `profile_card_test.dart` - User profile card component
- `sign_in_form_test.dart` - Email/password sign-in form
- `terms_acceptance_checkbox_test.dart` - Terms of service acceptance

#### Authentication Widgets (`test/widgets/auth/`)
- `avatar_button_test.dart` - Avatar button with authentication state
- `social_auth_button_test.dart` - Social authentication provider buttons

#### Haptic Widgets (`test/widgets/haptics/`)
- `haptic_app_bar_test.dart` - Haptic-enabled app bar
- `haptic_circular_button_test.dart` - Haptic circular button with factory constructors
- `haptic_elevated_button_test.dart` - Haptic elevated button
- `haptic_floating_action_button_test.dart` - Haptic floating action button
- `haptic_gesture_detector_test.dart` - Haptic gesture detection
- `haptic_icon_button_test.dart` - Haptic icon button
- `haptic_ink_well_test.dart` - Haptic ink well
- `haptic_list_tile_test.dart` - Haptic list tile
- `haptic_slider_option_test.dart` - Haptic slider control
- `haptic_switch_list_tile_test.dart` - Haptic switch list tile
- `haptic_switch_test.dart` - Haptic switch widget
- `haptic_text_button_test.dart` - Haptic text button

#### Common Widgets (`test/widgets/common/`)
- `action_option_test.dart` - Action button component
- `body_type_picker_test.dart` - Body type selection widget
- `color_picker_test.dart` - Color selection widget
- `delete_confirmation_dialog_test.dart` - Deletion confirmation dialog
- `dialog_title_test.dart` - Standardized dialog titles
- `graviton_popup_menu_test.dart` - Custom popup menu
- `graviton_tab_bar_test.dart` - Custom tab bar
- `graviton_tab_test.dart` - Custom tab widget
- `graviton_tabbed_view_test.dart` - Tabbed interface
- `section_divider_test.dart` - Section separator
- `styled_dropdown_test.dart` - Styled dropdown menu
- `styled_text_field_test.dart` - Styled text input
- `toggle_option_test.dart` - Toggle control component

#### Scenario Selection Widgets (`test/widgets/scenario_selection/`)
- `create_scenario_tile_test.dart` - New scenario creation tile
- `custom_scenario_tile_test.dart` - Custom scenario display
- `custom_scenarios_tab_test.dart` - User scenarios tab
- `preset_scenario_tile_test.dart` - Preset scenario display
- `preset_scenarios_tab_test.dart` - Educational scenarios tab
- `scenario_body_tile_test.dart` - Body management in editor
- `scenario_editor_body_details_bottom_sheet_test.dart` - Body editing interface
- `scenario_editor_body_list_test.dart` - Body list management
- `scenario_editor_metadata_panel_test.dart` - Scenario metadata editing
- `scenario_editor_physics_panel_test.dart` - Physics parameter editing

#### Semantic Accessibility Widgets (`test/widgets/semantics/`)
- `semantic_app_wrapper_test.dart` - App-level accessibility wrapper
- `semantic_bottom_sheet_test.dart` - Bottom sheet accessibility
- `semantic_camera_controls_test.dart` - Camera control accessibility
- `semantic_live_region_test.dart` - Live region announcements
- `semantic_scenario_selector_test.dart` - Scenario selector accessibility
- `semantic_settings_button_test.dart` - Settings button accessibility
- `semantic_simulation_canvas_test.dart` - Canvas accessibility
- `semantic_simulation_controls_test.dart` - Simulation control accessibility

#### Overlay Widgets (`test/widgets/overlays/`)
- `body_property_editor_overlay_test.dart` - Body property editing overlay
- `camera_visual_aids_overlay_test.dart` - Camera visual aids overlay
- `offscreen_indicators_overlay_test.dart` - Off-screen body indicators
- `stats_overlay_test.dart` - Statistics display overlay
- `tutorial_overlay_test.dart` - Tutorial and onboarding overlay

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

## 🔄 Running Tests

The Graviton project uses multiple testing strategies to ensure comprehensive coverage:

### Quick Test Commands
```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test categories
flutter test test/services/
flutter test test/widgets/haptics/
flutter test test/features/physics/

# Run integration tests
flutter test test/integration/

# Run tests for accessibility
flutter test test/features/accessibility/
flutter test test/widgets/semantics/
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

### VS Code Tasks
Use the predefined VS Code tasks for convenient testing:
- **🧪 Run Tests** - Execute all unit and widget tests
- **🔍 Analyze Code** - Run static analysis for code quality

### Test Configuration
- **Coverage Target**: 85%+ across all critical components
- **Performance Testing**: Physics calculations and rendering performance
- **Accessibility Testing**: Screen reader and keyboard navigation support
- **Platform Testing**: iOS and Android-specific functionality
- **Localization Testing**: All 7 supported languages

### Test Data and Mocks
- `test_mocks.dart` - Centralized mock object definitions and annotations
- `test_mocks.mocks.dart` - Auto-generated mock implementations (via mockito)
- `test_utils.dart` - Shared test helper functions, assertions, and test data
- `test_helpers.dart` - Integration test patterns and utilities (in utils/)
- Mock scenarios and physics configurations for consistent testing
- Accessibility testing utilities for semantic validation

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