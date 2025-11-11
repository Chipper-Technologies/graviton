# GitHub Copilot Custom Instructions for Graviton

## Project Context
This is a Flutter-based gravitational physics simulation app called "Graviton" that provides:
- Real-time 3D visualization of celestial body interactions
- Multiple astronomical scenarios (solar system, binary stars, three-body problems)
- Interactive camera controls and physics parameter adjustments
- Multi-language support (7 languages)
- Educational features with tutorials and guided experiences

## Code Review Guidelines

### **CRITICAL CODE QUALITY STANDARDS** (Non-Negotiable)

#### AppTypography Constants Usage
- **ALWAYS use AppTypography constants** for font sizes, opacity, spacing, icon sizes, dimensions
- **Flag ALL magic numbers** in UI code - use `AppTypography.fontSizeMedium`, `AppTypography.opacityHigh`, etc.
- **Example violations**: `fontSize: 14.0` (should be `AppTypography.fontSizeMedium`), `padding: 16.0` (should be `AppTypography.spacingLarge`)

#### File Organization - One Class Per File
- **Each class, model, enum MUST be in its own file** with corresponding unit test
- **Flag multiple classes in single files** - split immediately
- **Enforce naming**: `body.dart` contains only `Body` class, `body_test.dart` contains only `Body` tests
- **No exceptions** - even small enums get their own files

#### Utility Functions - Extract Common Logic  
- **Flag private utility methods in classes** - extract to `utils/` files
- **Common patterns**: `PhysicsUtils`, `MathUtils`, `ValidationUtils`, `RenderingUtils`
- **No duplicated calculations** across classes - centralize in utilities

#### No Magic Numbers Policy
- **Every numeric value must be a named constant** from appropriate constants files
- **Physics**: Use `SimulationConstants.gravitationalConstant`, not `1.2`
- **UI**: Use `AppTypography.spacingMedium`, not `12.0`
- **Rendering**: Use `RenderingConstants.minimumBodySize`, not `3.0`

#### Documentation Requirements
- **All public APIs must have comprehensive documentation** with examples
- **Physics formulas must be documented** with mathematical notation
- **Include parameter descriptions, return values, and usage examples**
- **Flag missing or outdated documentation**

### Architecture & Patterns
- **State Management**: Use Provider pattern consistently. Look for proper separation between UI state (`AppState`) and simulation state (`SimulationState`)
- **Service Layer**: Validate that business logic is properly encapsulated in services (physics, temperature, scenario management)
- **Constants**: Ensure physics constants are defined in `SimulationConstants` class rather than magic numbers
- **Localization**: All user-facing text should use `AppLocalizations` with proper ARB keys

### Physics & Performance
- **Numerical Stability**: Review physics calculations for precision issues, especially in orbital mechanics
- **Performance**: Flag expensive operations in render loops, suggest optimization for 60fps target
- **Memory Management**: Watch for memory leaks in trail rendering and body management
- **Threading**: Ensure UI updates happen on main thread, physics calculations can be optimized

### Flutter Best Practices
- **Widget Composition**: Prefer composition over inheritance, suggest breaking down complex widgets
- **State Lifecycles**: Validate proper `initState`, `dispose`, and `didUpdateWidget` usage
- **Testing**: Encourage comprehensive test coverage, especially for physics calculations
- **Accessibility**: Ensure proper semantics for screen readers and navigation

### Code Quality Priorities
1. **AppTypography Constants**: ALL UI dimensions use AppTypography - zero tolerance for magic numbers
2. **File Organization**: One class per file with dedicated unit tests - no exceptions
3. **Utility Extraction**: Common functions in utils/ files, not private methods in classes
4. **Physics Accuracy**: Gravitational calculations, collision detection, temperature modeling
5. **Performance**: Smooth 60fps rendering with multiple bodies and trails
6. **Documentation**: Comprehensive docs for all public APIs with examples
7. **Maintainability**: Clear separation of concerns, well-documented physics constants
8. **Internationalization**: Consistent localization patterns across all UI elements
9. **User Experience**: Intuitive controls, helpful tutorials, responsive interactions

### Specific Review Focus Areas

#### Physics & Simulation (`lib/services/simulation.dart`)
- Validate numerical integration stability
- Check for proper unit conversions and scaling
- Ensure physics parameters are properly encapsulated
- Review collision detection algorithms for accuracy

#### Rendering (`lib/painters/`)
- Monitor performance of custom painters
- Check for unnecessary redraws and expensive calculations
- Validate 3D coordinate transformations
- Ensure proper trail management and memory cleanup

#### UI Components (`lib/widgets/`)
- **CRITICAL**: Verify all UI uses AppTypography constants (fonts, spacing, opacity, icons)
- Flag any magic numbers like `padding: 16.0` or `fontSize: 14.0`
- Verify consistent Material Design patterns
- Check for proper error states and loading indicators
- Ensure responsive design across screen sizes
- Validate accessibility features
- **Example checks**:
  - `EdgeInsets.all(12.0)` → should be `EdgeInsets.all(AppTypography.spacingMedium)`
  - `Icon(Icons.star, size: 24.0)` → should be `Icon(Icons.star, size: AppTypography.iconSizeXXLarge)`
  - `opacity: 0.7` → should be `AppTypography.opacityHigh`

#### State Management (`lib/state/`)
- Review Provider usage patterns
- Check for potential memory leaks in listeners
- Validate state synchronization between UI and simulation
- Ensure proper disposal of resources

#### Localization (`lib/l10n/`)
- Verify ARB file consistency across all 7 languages
- Check for missing translations or placeholder text
- Validate proper pluralization and context usage
- Ensure cultural appropriateness of translations

### Common Anti-Patterns to Flag
- **Magic numbers anywhere** - especially UI dimensions (should use `AppTypography` constants)
- **Multiple classes in single files** - each class/model/enum needs its own file
- **Private utility methods in classes** - extract to utils/ files for reusability
- **Missing unit tests** - every file should have corresponding test file
- **Undocumented public APIs** - all public methods need comprehensive docs
- Magic numbers in physics calculations (should use `SimulationConstants`)
- Direct widget tree mutations (use proper state management)
- Hardcoded strings (should be localized)
- Blocking operations on UI thread
- Memory leaks in animation controllers or listeners
- Inconsistent error handling patterns
- Missing null safety annotations
- Improper test coverage for critical physics calculations

### Educational Context
This app is designed for educational purposes, so prioritize:
- **Consistent code quality standards** - AppTypography usage, proper file organization
- **Well-documented utilities** - extract common functions to utils/ for learning
- Code clarity and documentation
- Proper separation of physics concepts
- Consistent naming conventions for scientific terms
- Comprehensive error handling for edge cases
- Performance optimization without sacrificing readability

### Review Tone
- Be constructive and educational
- **Emphasize code quality standards first** - AppTypography, file organization, utilities
- Explain the "why" behind suggestions
- Provide specific examples and alternatives
- Focus on both correctness and learning opportunities
- Consider the educational nature of the codebase
- **Reference the detailed prompts in .github/prompts/ for specific guidance**