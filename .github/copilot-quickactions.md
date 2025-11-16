# Graviton Quick Actions Tool Set

Predefined quick actions for common development tasks in the Graviton physics simulation project.

## Development Commands

### Physics Development Quick Actions

```
/physics-setup - Set up new physics calculation with proper constants and documentation
/scenario-create - Create a new educational astronomy scenario with validation
/orbit-calculate - Calculate orbital parameters for celestial bodies
/collision-detect - Implement collision detection for gravitational interactions
/energy-validate - Validate energy conservation in N-body system
```

### Build & Deploy Quick Actions

```
/dev-run - Start development build with Firebase dev configuration
/prod-build - Build production APK/IPA with obfuscation and optimization
/test-all - Run comprehensive test suite (unit, widget, integration)
/analyze-code - Run Flutter analysis and check code quality standards
/coverage-check - Generate code coverage report and analyze completeness
```

### Code Quality Quick Actions

```
/fix-typography - Find and fix all magic numbers using AppTypography constants
/split-files - Identify classes that need to be split into separate files
/extract-utils - Extract common logic into utility functions
/doc-physics - Generate comprehensive documentation for physics formulas
/validate-standards - Check compliance with Graviton coding standards
```

### Internationalization Quick Actions

```
/i18n-audit - Check translation completeness across all 7 languages
/arb-generate - Generate ARB keys for new UI elements
/translate-physics - Ensure consistent physics terminology across languages
/format-numbers - Implement locale-specific number and unit formatting
/cultural-validate - Validate cultural appropriateness of scientific content
```

### Performance & Rendering Quick Actions

```
/optimize-painter - Optimize CustomPainter for 60fps performance
/memory-check - Analyze memory usage during extended simulations
/lod-implement - Implement level-of-detail rendering for distant objects
/trail-optimize - Optimize particle trail rendering and cleanup
/camera-smooth - Implement smooth camera transitions and controls
```

### Testing & Validation Quick Actions

```
/test-physics - Generate unit tests for physics calculations
/test-ui - Create widget tests for cosmic-themed UI components
/test-integration - Write integration tests for simulation workflows
/test-accessibility - Validate screen reader and haptic feedback support
/test-performance - Profile simulation performance and identify bottlenecks
```

### Educational Content Quick Actions

```
/tutorial-create - Design interactive physics tutorial with difficulty levels
/lesson-plan - Generate lesson plan for specific physics concept
/scenario-validate - Validate educational scenario for astronomical accuracy
/explanation-generate - Create clear explanations for complex physics phenomena
/accessibility-enhance - Add inclusive design features for physics content
```

### Firebase & Backend Quick Actions

```
/firebase-setup - Configure Firebase services for dev/prod environments
/analytics-implement - Add analytics tracking for simulation interactions
/remote-config - Set up remote configuration for physics parameters
/crashlytics-debug - Debug Firebase crashlytics integration
/ab-test - Implement A/B testing for educational features
```

## Composite Quick Actions

### Complete Feature Development
```
/feature-physics-complete [feature-name]
- Create physics calculation with proper constants
- Extract utility functions to appropriate files
- Generate comprehensive unit tests
- Add documentation with mathematical formulas
- Validate AppTypography compliance
- Add internationalization support
```

### New Scenario Development
```
/scenario-complete [scenario-name]
- Create scenario class in separate file
- Implement physics calculations with validation
- Generate educational content and explanations
- Add multi-language support
- Create integration tests
- Validate astronomical accuracy
```

### UI Component Development
```
/widget-complete [component-name]
- Create widget with AppTypography constants
- Implement proper state management
- Add accessibility features
- Generate widget tests
- Add internationalization keys
- Validate cosmic theme compliance
```

### Performance Optimization
```
/optimize-complete [target-area]
- Profile current performance
- Identify bottlenecks and memory leaks
- Implement optimization strategies
- Add performance monitoring
- Generate performance tests
- Document optimization decisions
```

## Context-Aware Quick Actions

### File-Specific Actions
```
/physics-review [file.dart] - Review physics file for accuracy and standards
/ui-review [widget.dart] - Check UI component for AppTypography compliance
/test-generate [class.dart] - Generate comprehensive test file for class
/doc-enhance [service.dart] - Improve documentation for public APIs
```

### Scenario-Specific Actions
```
/solar-system - Set up realistic solar system simulation
/binary-stars - Create binary star system with proper mass ratios
/three-body - Design stable three-body configuration
/asteroid-field - Implement asteroid belt with collision dynamics
```

### Platform-Specific Actions
```
/ios-setup - Configure iOS-specific build settings and capabilities
/android-setup - Configure Android-specific build settings and signing
/web-optimize - Optimize for web deployment and performance
/desktop-prepare - Prepare for desktop platform deployment
```

## Custom Quick Action Templates

### Physics Calculation Template
```
@quick-action physics-new
Parameters: [calculation-type] [body-count] [accuracy-level]
Generates:
- Physics service class with proper constants
- Comprehensive unit tests with numerical precision
- Documentation with mathematical formulas
- Integration with existing simulation state
- Performance monitoring hooks
```

### Educational Content Template
```
@quick-action education-new
Parameters: [topic] [difficulty] [target-audience]
Generates:
- Scenario configuration with realistic parameters
- Tutorial flow with progressive complexity
- Multi-language content structure
- Accessibility features
- Assessment and validation methods
```

### UI Component Template
```
@quick-action widget-new
Parameters: [component-type] [theme-variant] [interaction-level]
Generates:
- Widget class using AppTypography constants
- Proper state management integration
- Accessibility semantics
- Haptic feedback patterns
- Comprehensive widget tests
```

## Usage Instructions

1. **Basic Usage**: Type `/action-name` in GitHub Copilot chat
2. **With Parameters**: Use `/action-name [param1] [param2]` format
3. **File Context**: Select file/code before using file-specific actions
4. **Composite Actions**: Will execute multiple related tasks in sequence

## Integration with Development Workflow

These quick actions work alongside:
- **Flavor System**: Automatically detect dev/prod environment
- **Testing Framework**: Generate appropriate test types for context
- **Firebase Config**: Use correct environment configurations
- **Build System**: Trigger appropriate build commands
- **Code Standards**: Automatically apply AppTypography and file organization rules

## Examples

```bash
# Start development with physics scenario
/dev-run
/scenario-create "Jupiter-Moons"
/physics-setup orbital-resonance

# Complete UI development cycle
/widget-complete simulation-controls
/test-ui SimulationControlsWidget
/i18n-audit simulation-controls

# Performance optimization session
/optimize-complete trail-rendering
/memory-check
/test-performance rendering

# Educational content creation
/tutorial-create gravitational-slingshot beginner
/scenario-validate educational-accuracy
/accessibility-enhance tutorial-content
```

These quick actions are designed to streamline Graviton development while maintaining the project's high standards for physics accuracy, code quality, and educational value.