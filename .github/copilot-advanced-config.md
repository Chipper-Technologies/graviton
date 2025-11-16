# GitHub Copilot Advanced Review Configuration

## CRITICAL CODE QUALITY STANDARDS (Non-Negotiable)

### AppTypography Constants Review Pattern
When reviewing ANY file with UI code:
```
BLOCKING ISSUES - Flag immediately:
- Magic numbers in UI: fontSize: 14.0 → AppTypography.fontSizeMedium
- Magic padding: EdgeInsets.all(16.0) → EdgeInsets.all(AppTypography.spacingLarge) 
- Magic opacity: opacity: 0.7 → AppTypography.opacityHigh
- Magic icon sizes: size: 24.0 → AppTypography.iconSizeXXLarge
- Any hardcoded dimensions that should use AppTypography constants

Required replacement patterns:
- padding: 8.0 → AppTypography.spacingSmall
- padding: 12.0 → AppTypography.spacingMedium  
- padding: 16.0 → AppTypography.spacingLarge
- fontSize: 12.0 → AppTypography.fontSizeSmall
- fontSize: 14.0 → AppTypography.fontSizeMedium
- fontSize: 16.0 → AppTypography.fontSizeLarge
- borderRadius: 8.0 → AppTypography.radiusMedium
```

### File Organization Review Pattern
When reviewing ANY new file:
```
BLOCKING ISSUES - Flag immediately:
- Multiple classes in single file → Split into separate files
- Multiple models in single file → Each model gets own file
- Multiple enums in single file → Each enum gets own file
- Missing unit test file → Each file needs corresponding test
- Private utility methods → Extract to utils/ files

Required file structure:
- lib/models/body.dart → Body class only
- lib/models/trail_point.dart → TrailPoint class only  
- lib/enums/body_type.dart → BodyType enum only
- test/models/body_test.dart → Body tests only
- lib/utils/physics_utils.dart → Common physics calculations
```

## Project-Specific Review Patterns

### Physics & Mathematics Review Prompts

When reviewing files in `lib/services/simulation.dart` or physics-related code:
```
Focus on:
- Numerical stability of integration methods
- Correct implementation of gravitational formulas (F = G * m1 * m2 / r²)
- Proper handling of collision detection and response
- Unit consistency throughout calculations
- Performance implications of mathematical operations in render loops
- Proper encapsulation of physics parameters with private fields and public getters
```

### UI/UX Review Prompts

When reviewing files in `lib/widgets/` or `lib/screens/`:
```
Focus on (in priority order):
1. AppTypography constants usage - FLAG ALL magic numbers in UI dimensions
2. File organization - Each widget class in separate file with unit tests
3. Utility extraction - Common UI utilities in utils/ not private methods
4. Accessibility compliance (semantics, contrast, navigation)
5. Proper state management using Provider pattern
6. Localization completeness (no hardcoded strings)
7. Responsive design across different screen sizes
8. Loading states and error handling for user interactions
9. Performance of custom painters and animations

CRITICAL examples to flag:
- fontSize: 14.0 → AppTypography.fontSizeMedium
- padding: EdgeInsets.all(16.0) → EdgeInsets.all(AppTypography.spacingLarge)
- Icon(Icons.star, size: 24.0) → Icon(Icons.star, size: AppTypography.iconSizeXXLarge)
- opacity: 0.7 → AppTypography.opacityHigh
```

### Localization Review Prompts

When reviewing files in `lib/l10n/`:
```
Focus on:
- Consistency across all 7 supported languages
- Proper context and pluralization handling
- Cultural appropriateness of educational content
- Missing translations or placeholder text
- ARB key naming conventions and organization
```

### Test Review Prompts

When reviewing files in `test/`:
```
Focus on:
- Coverage of critical physics calculations
- Edge cases in orbital mechanics
- Performance testing for rendering components  
- Accessibility testing for UI components
- Proper test organization and naming
- Mock usage for external dependencies
```

## Contextual Review Instructions

### For Pull Requests with "physics" label:
```
This PR involves physics calculations. Pay special attention to:
1. Mathematical accuracy of formulas
2. Numerical stability and precision
3. Unit conversions and scaling
4. Performance impact of calculations
5. Test coverage for edge cases
6. Documentation of complex algorithms
```

### For Pull Requests with "ui" label:
```
This PR involves user interface changes. Pay special attention to:
1. **AppTypography constants usage** - BLOCK if any magic numbers in UI dimensions
2. **File organization** - Each widget class must be in separate file with unit tests
3. **Utility extraction** - Common UI functions in utils/ files, not private methods
4. Material Design compliance
5. Accessibility features
6. Localization completeness
7. Responsive design
8. State management patterns
9. Loading and error states

BLOCKING CHECKS:
- Search for magic numbers: 8.0, 12.0, 14.0, 16.0, 20.0, 24.0 in UI code
- Verify AppTypography.* usage for all dimensions and typography
- Confirm each widget class has own file and test file
- Check for private helper methods that should be in utils/
```

### For Pull Requests with "performance" label:
```
This PR involves performance optimizations. Pay special attention to:
1. Frame rate impact (target: 60fps)
2. Memory usage and potential leaks
3. Efficient rendering techniques
4. Algorithmic complexity improvements
5. Profiling and benchmarking needs
6. Trade-offs between performance and readability
```

### For Pull Requests with "localization" label:
```
This PR involves internationalization. Pay special attention to:
1. Completeness across all 7 languages
2. Proper ARB file structure
3. Context-appropriate translations
4. Cultural sensitivity
5. Pluralization handling
6. Text overflow and layout considerations
```

## Review Quality Standards

### Code Complexity Thresholds
- **Magic numbers in UI**: Flag immediately - must use AppTypography constants
- **Multiple classes per file**: Flag immediately - split into separate files
- **Private utilities in classes**: Flag immediately - extract to utils/ files
- **Missing unit tests**: Flag for any new file without corresponding test
- **Undocumented public APIs**: Flag any public method without comprehensive docs
- Methods > 50 lines: Suggest decomposition
- Classes > 500 lines: Suggest refactoring
- Cyclomatic complexity > 10: Flag for simplification
- Nesting depth > 4: Suggest early returns or extraction

### Performance Standards
- Render loop operations: Must be O(1) or O(n) where n is small
- Physics calculations: Document time complexity
- Memory allocations: Minimize in hot paths
- File I/O: Always async, proper error handling

### Documentation Requirements
- Public APIs: Comprehensive doc comments
- Physics formulas: Mathematical notation and references
- Complex algorithms: Step-by-step explanation
- Configuration options: Clear usage examples

## Language-Specific Guidelines

### Dart/Flutter Best Practices
- Prefer const constructors where possible
- Use named parameters for readability
- Implement proper dispose methods
- Follow effective dart style guide
- Use null safety consistently

### Physics Simulation Specifics
- All physics constants in `SimulationConstants`
- Immutable data structures where possible
- Clear separation between model and view
- Deterministic behavior for testing
- Proper error propagation

## Review Automation Rules

### Auto-approve conditions:
- Only formatting changes (dart format)
- Documentation-only updates
- Translation updates with no code changes
- Version bumps in pubspec.yaml

### Require human review:
- **Any UI code with magic numbers** - AppTypography constants violations
- **Files with multiple classes** - File organization standard violations  
- **Private utility methods in classes** - Utility extraction violations
- **Missing comprehensive documentation** - Public API documentation violations
- Changes to physics calculation logic
- New UI components or significant changes
- Performance-critical modifications
- Security-related updates
- Breaking API changes

### Flag for expert review:
- **Code quality standard violations** - Multiple issues with AppTypography, file org, utils
- Orbital mechanics algorithms
- 3D rendering optimizations
- State management architecture changes
- Accessibility implementation
- Internationalization infrastructure

## Automated Quality Checks

### Magic Number Detection Patterns
```regex
# UI Dimensions (flag these patterns)
fontSize:\s*\d+\.?\d*(?!\s*[*/])  # fontSize: 14.0
padding:\s*EdgeInsets\.all\(\d+\.?\d*\)  # EdgeInsets.all(16.0)
margin:\s*EdgeInsets\.all\(\d+\.?\d*\)   # EdgeInsets.all(8.0)
size:\s*\d+\.?\d*(?!\s*[*/])  # Icon size: 24.0
opacity:\s*0\.\d+(?!\s*[*/])  # opacity: 0.7
borderRadius:\s*BorderRadius\.circular\(\d+\.?\d*\)  # BorderRadius.circular(8.0)
```

### File Organization Violations
```regex
# Multiple class definitions in single file
class\s+\w+.*?\{.*?class\s+\w+  # Multiple class declarations
enum\s+\w+.*?\{.*?enum\s+\w+    # Multiple enum declarations  
```

### Documentation Requirements Check
```regex
# Missing documentation for public methods
^\s*(static\s+)?(Future<\w+>|[A-Z]\w*|\w+)\s+\w+\s*\([^)]*\)\s*\{(?!.*///)
```

## Quality Gate Enforcement

### Pre-commit Requirements
- No magic numbers in UI code (must use AppTypography)
- Each new class/model/enum in separate file
- Unit test file for each new source file  
- Public methods have documentation
- No hardcoded strings (use AppLocalizations)

### PR Merge Requirements  
- All quality gates must pass
- Code review approval from maintainer
- CI/CD pipeline success (tests, linting, coverage)
- Documentation updates for API changes
- Translation updates for new user-facing text

### Escalation Triggers
- 3+ AppTypography violations in single PR
- Multiple file organization violations  
- Missing tests for physics calculations
- Performance regression >10ms per frame
- Accessibility violations