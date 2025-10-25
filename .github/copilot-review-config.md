# Copilot Code Review Configuration

## Custom Instructions for Pull Request Reviews

When reviewing code for this Flutter gravitational physics simulation project, please focus on:

### High Priority Issues
- **Physics Accuracy**: Flag incorrect gravitational formulas, unit inconsistencies, or numerical instability
- **Performance Critical**: Identify expensive operations in render loops, memory leaks in trail management
- **Security**: Validate input sanitization, proper error handling for edge cases
- **Accessibility**: Missing semantics, poor contrast, inadequate screen reader support

### Medium Priority Issues  
- **Code Organization**: Suggest better separation of concerns, proper use of services vs widgets
- **Maintainability**: Flag magic numbers, suggest extracting constants, improve naming
- **Testing**: Identify missing test coverage for critical physics calculations
- **Documentation**: Request clarification for complex physics algorithms

### Low Priority (Nitpicks)
- **Style Consistency**: Formatting, naming conventions, import organization
- **Minor Optimizations**: Small performance improvements that don't affect core functionality
- **Code Simplification**: Opportunities to reduce complexity without changing behavior

### Context-Specific Guidelines

#### For `/lib/services/simulation.dart`
- Physics parameters should be private with public getters
- All constants should reference `SimulationConstants`
- Numerical integration should be stable and well-documented
- Performance-critical sections need optimization comments

#### For `/lib/painters/` files
- Custom painters must be optimized for 60fps
- Coordinate transformations should be mathematically sound
- Memory usage in trail rendering needs monitoring
- Canvas operations should be minimized

#### For `/lib/widgets/` files  
- Widgets should be properly decomposed and reusable
- State management should follow Provider patterns
- All text must be localized via `AppLocalizations`
- Loading states and error handling required

#### For `/test/` files
- Physics calculations need comprehensive test coverage
- UI tests should cover accessibility features
- Performance tests for rendering components
- Edge cases in orbital mechanics must be tested

#### For `/lib/l10n/` files
- ARB keys should be descriptive and consistent
- All 7 languages must have complete translations
- Cultural sensitivity in educational content
- Proper pluralization and context handling

### Review Standards

#### Must Fix (Blocking)
- Incorrect physics calculations
- Performance regressions affecting 60fps target  
- Breaking changes to public API
- Missing error handling for user inputs
- Security vulnerabilities or data exposure
- Accessibility violations

#### Should Fix (Important)
- Missing test coverage for new features
- Inconsistent state management patterns
- Hardcoded strings that should be localized
- Magic numbers that should use constants
- Memory leaks or resource management issues

#### Consider (Suggestions)
- Code simplification opportunities
- Better variable naming
- Additional documentation for complex algorithms
- Minor performance optimizations
- Improved error messages

### Educational Focus
Remember this is an educational physics simulation:
- Prioritize code clarity over micro-optimizations
- Encourage proper scientific naming conventions
- Suggest learning resources for complex physics concepts
- Emphasize the importance of accurate simulations for education