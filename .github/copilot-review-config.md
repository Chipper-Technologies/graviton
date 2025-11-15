# Copilot Code Review Configuration

## Custom Instructions for Pull Request Reviews

When reviewing code for this Flutter gravitational physics simulation project, please focus on:

### High Priority Issues (BLOCKING)
- **AppTypography Constants**: Flag ANY magic numbers in UI code - fontSize, spacing, opacity, iconSize must use AppTypography constants
- **File Organization**: Flag multiple classes/models/enums in single files - each needs own file with unit tests
- **Utility Extraction**: Flag private utility methods in classes - extract to utils/ files for reusability
- **Physics Accuracy**: Flag incorrect gravitational formulas, unit inconsistencies, or numerical instability
- **Performance Critical**: Identify expensive operations in render loops, memory leaks in trail management
- **Security**: Validate input sanitization, proper error handling for edge cases
- **Accessibility**: Missing semantics, poor contrast, inadequate screen reader support

### Medium Priority Issues  
- **Documentation**: Missing docs for public APIs, incomplete physics formula explanations
- **Constants Usage**: Magic numbers in physics calculations (should use SimulationConstants)
- **Code Organization**: Suggest better separation of concerns, proper use of services vs widgets
- **Testing**: Identify missing test coverage for critical physics calculations
- **Localization**: Hardcoded strings that should use AppLocalizations

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
- **CRITICAL**: All UI dimensions must use AppTypography constants (fontSize, spacing, opacity, iconSize)
- Flag magic numbers: `padding: 16.0` → `AppTypography.spacingLarge`, `fontSize: 14.0` → `AppTypography.fontSizeMedium`
- Widgets should be properly decomposed and reusable
- State management should follow Provider patterns
- All text must be localized via `AppLocalizations`
- Loading states and error handling required
- Each widget class in separate file with unit tests

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

#### Must Fix (BLOCKING)
- **Magic numbers in UI code** - Any fontSize, spacing, opacity, iconSize not using AppTypography constants
- **Multiple classes per file** - Each class/model/enum must have own file with unit tests  
- **Private utilities in classes** - Common functions must be extracted to utils/ files
- **Missing documentation** - All public APIs need comprehensive docs with examples
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
- **Consistent code quality standards** - AppTypography usage, proper file organization
- **Well-documented utilities** - extract common functions to utils/ for learning
- Prioritize code clarity over micro-optimizations
- Encourage proper scientific naming conventions
- Suggest learning resources for complex physics concepts
- Emphasize the importance of accurate simulations for education

## Integration with GitHub Copilot Prompts

This configuration works with specialized prompts in `.github/prompts/`:
- **code-quality-standards.md** - Detailed examples of AppTypography usage and file organization
- **physics-calculations.md** - Physics accuracy and utility extraction patterns
- **custom-painter-rendering.md** - Performance optimization for 60fps rendering
- **flutter-state-management.md** - Provider patterns and state organization
- **theme-visual-design.md** - UI consistency and AppTypography examples
- **testing.md** - Comprehensive test coverage requirements
- **internationalization.md** - Localization patterns and ARB management
- **accessibility.md** - Inclusive design and semantic requirements

## Chat Mode Integration

Use specialized chat modes for focused reviews:
- `/mode quality` - Strict enforcement of AppTypography and file organization
- `/mode physics` - Physics accuracy and numerical stability  
- `/mode ui` - UI design system and AppTypography compliance
- `/mode performance` - 60fps optimization and memory management
- `/mode testing` - Test coverage and validation patterns
- `/mode accessibility` - Inclusive design and screen reader support

## Context Files for Review

Reference these files during code reviews:
- `lib/theme/app_typography.dart` - Source of truth for all UI constants
- `lib/constants/simulation_constants.dart` - Physics constants reference
- `.github/copilot-instructions.md` - Overall project guidelines
- `docs/ARCHITECTURE.md` - Project structure and patterns