# Graviton Context-Aware Tool Set

Dynamic tool set that adapts to current development context in the Graviton physics simulation project.

## Context Detection System

### File Type Context
- **Physics Files** (`*_physics.dart`, `*_calculation.dart`): Activate physics validation tools
- **UI Components** (`*_widget.dart`, `*_screen.dart`): Activate AppTypography enforcement
- **Service Classes** (`*_service.dart`): Activate architecture pattern validation
- **Test Files** (`*_test.dart`): Activate test enhancement and coverage tools
- **Configuration** (`config/*.json`, `*_config.dart`): Activate environment management tools

### Development Phase Context
- **Feature Development**: Emphasize standards compliance and testing
- **Bug Fixing**: Focus on debugging tools and issue isolation
- **Performance Optimization**: Activate profiling and optimization tools
- **Educational Content**: Emphasize accuracy and accessibility tools
- **Deployment Preparation**: Activate build validation and quality checks

### Code Pattern Context
- **Provider State Management**: Validate state architecture patterns
- **Custom Painters**: Optimize rendering performance
- **Physics Calculations**: Validate numerical accuracy and stability
- **Firebase Integration**: Check environment configuration compliance
- **Internationalization**: Validate multi-language consistency

## Adaptive Tool Suggestions

### When Editing Physics Calculations
```
🔬 Physics Context Detected
Recommended tools:
- @graviton-physics: Validate calculation accuracy
- @graviton-performance: Check numerical stability
- @graviton-test: Generate physics unit tests
- @graviton-standards: Ensure proper documentation

Auto-suggestions:
- Use SimulationConstants for all physics values
- Add mathematical formula documentation
- Implement energy conservation checks
- Consider numerical precision limits
```

### When Editing UI Components
```
🎨 UI Component Context Detected
Recommended tools:
- @graviton-standards: Enforce AppTypography usage
- @graviton-accessibility: Add inclusive design features
- @graviton-i18n: Ensure localization support
- @graviton-test: Generate widget tests

Auto-suggestions:
- Replace magic numbers with AppTypography constants
- Add semantic labels for screen readers
- Implement haptic feedback patterns
- Consider cosmic theme consistency
```

### When Working with State Management
```
📊 State Management Context Detected
Recommended tools:
- @graviton-build: Test state persistence
- @graviton-performance: Monitor state update performance
- @graviton-test: Validate state transitions
- @graviton-standards: Check Provider pattern compliance

Auto-suggestions:
- Ensure proper dispose() implementation
- Validate state synchronization patterns
- Check for memory leaks in listeners
- Consider state update frequency optimization
```

### When Creating Educational Content
```
📚 Educational Context Detected
Recommended tools:
- @graviton-education: Validate scientific accuracy
- @graviton-accessibility: Ensure inclusive learning
- @graviton-scenarios: Create realistic simulations
- @graviton-i18n: Support global learners

Auto-suggestions:
- Verify astronomical data accuracy
- Design progressive difficulty levels
- Add multiple learning modalities
- Consider cultural sensitivity
```

## Smart Code Completion

### Physics-Aware Completions
```
// When typing physics calculations
gravitational → SimulationConstants.gravitationalConstant
mass1 * mass2 → PhysicsUtils.calculateGravitationalForce(body1, body2)
velocity → Vector3 orbital velocity with proper units

// When creating scenarios
threebody → Complete three-body problem template with stable configuration
orbit → Orbital parameters with realistic eccentricity and inclination
```

### UI-Aware Completions
```
// When styling widgets
padding: 16.0 → EdgeInsets.all(AppTypography.spacingLarge)
fontSize: 14.0 → fontSize: AppTypography.fontSizeMedium
opacity: 0.7 → opacity: AppTypography.opacityHigh

// When creating cosmic-themed UI
Icon(Icons.star → CosmicIcons.celestialBody with proper sizing
Colors.blue → AppTheme.cosmicBlue with accessibility contrast
```

### Test-Aware Completions
```
// When writing physics tests
expect(energy → EnergyConservationMatcher with tolerance
testWidgets( → Full widget test template with cosmic theme setup
verify( → Physics calculation verification with numerical precision
```

## Dynamic Documentation

### Context-Sensitive Help
```
Current Context: Physics Calculation - Orbital Mechanics
Relevant Documentation:
- Kepler's Laws implementation guide
- Numerical integration stability patterns
- Energy conservation validation methods
- Performance optimization for N-body systems

Quick References:
- SimulationConstants.gravitationalConstant usage
- Vector3 operations for 3D space
- Proper coordinate system transformations
- Error handling for edge cases
```

### Live Code Analysis
```
Real-time Analysis: UI Component Development
Issues Detected:
⚠️  Line 23: Magic number 12.0 detected
   Suggestion: Use AppTypography.spacingMedium
⚠️  Line 45: Missing semantic label for accessibility
   Suggestion: Add Semantics widget wrapper
✅ Line 67: Proper AppTypography usage
✅ Line 89: Correct Provider pattern implementation

Performance Notes:
- Widget rebuild frequency: Optimal
- Memory allocation: No leaks detected
- Render performance: Meeting 60fps target
```

## Workflow Integration

### Commit Context Analysis
```
Changes Detected: Physics Service + UI Components + Tests
Recommended Pre-Commit Actions:
1. @graviton-standards: Validate all files for compliance
2. @graviton-test: Run affected test suites
3. @graviton-performance: Check performance impact
4. @graviton-i18n: Validate new UI text for localization

Automated Checks:
✅ No magic numbers detected
✅ All classes in separate files
✅ Comprehensive test coverage
✅ Documentation complete
```

### Build Context Optimization
```
Build Target: Production APK
Context-Aware Optimizations:
- Enable physics calculation optimizations
- Apply aggressive tree shaking for unused scenarios
- Optimize image assets for cosmic themes
- Configure Firebase for production environment

Performance Considerations:
- Trail rendering optimization enabled
- Memory pooling for particle systems
- LOD rendering for distant celestial bodies
- Haptic feedback pattern compression
```

## Learning & Adaptation

### Usage Pattern Recognition
```
Development Patterns Detected:
- Primary focus: Physics accuracy (73% of interactions)
- Secondary focus: Educational content (18% of interactions)
- Optimization focus: Rendering performance (9% of interactions)

Personalized Suggestions:
- Frequent physics work → Auto-suggest numerical precision tools
- Regular UI development → Emphasize AppTypography enforcement
- Educational content creation → Prioritize accessibility tools
```

### Project Evolution Tracking
```
Project Maturity Assessment:
- Physics Engine: Mature (minimal changes suggested)
- UI Components: Active development (enforce standards strictly)
- Educational Content: Growth phase (suggest expansion tools)
- Performance: Optimization phase (focus on profiling tools)

Recommended Focus Areas:
1. Accessibility enhancement for broader educational reach
2. Performance optimization for complex N-body simulations
3. Advanced scenario creation for higher education levels
```

## Context-Aware Debugging

### Physics Debugging Context
```
Physics Issue Detected: Energy Conservation Violation
Context-Aware Analysis:
- Numerical integration stability check
- Time step size validation
- Collision detection accuracy review
- Gravitational calculation precision audit

Debug Tools Activated:
- Energy monitoring dashboard
- Trajectory validation plots
- Numerical precision analyzers
- Performance profiling hooks
```

### UI Debugging Context
```
UI Issue Detected: Accessibility Compliance
Context-Aware Analysis:
- Screen reader compatibility check
- Haptic feedback pattern validation
- Color contrast ratio verification
- Keyboard navigation audit

Debug Tools Activated:
- Accessibility inspector overlay
- Semantic tree visualization
- Haptic pattern simulator
- Multi-language text overflow detection
```

## Implementation Instructions

1. **Install Context Detection**: Add to VS Code settings for automatic activation
2. **Configure File Associations**: Link file patterns to appropriate tool sets
3. **Enable Smart Completions**: Integrate with IntelliSense for dynamic suggestions
4. **Set Up Workflow Hooks**: Connect to Git hooks and build processes
5. **Train Pattern Recognition**: Allow system to learn from development patterns

This context-aware system ensures that the right tools are available at the right time, making Graviton development more efficient while maintaining high standards for physics accuracy, code quality, and educational value.