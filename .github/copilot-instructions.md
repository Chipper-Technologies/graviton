# GitHub Copilot Custom Instructions for Graviton

## Project Context
This is a Flutter-based gravitational physics simulation app called "Graviton" that provides:
- Real-time 3D visualization of celestial body interactions
- Multiple astronomical scenarios (solar system, binary stars, three-body problems)
- Interactive camera controls and physics parameter adjustments
- Multi-language support (7 languages)
- Educational features with tutorials and guided experiences

## Code Review Guidelines

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
1. **Physics Accuracy**: Gravitational calculations, collision detection, temperature modeling
2. **Performance**: Smooth 60fps rendering with multiple bodies and trails
3. **Maintainability**: Clear separation of concerns, well-documented physics constants
4. **Internationalization**: Consistent localization patterns across all UI elements
5. **User Experience**: Intuitive controls, helpful tutorials, responsive interactions

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
- Verify consistent Material Design patterns
- Check for proper error states and loading indicators
- Ensure responsive design across screen sizes
- Validate accessibility features

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
- Code clarity and documentation
- Proper separation of physics concepts
- Consistent naming conventions for scientific terms
- Comprehensive error handling for edge cases
- Performance optimization without sacrificing readability

### Review Tone
- Be constructive and educational
- Explain the "why" behind suggestions
- Provide specific examples and alternatives
- Focus on both correctness and learning opportunities
- Consider the educational nature of the codebase