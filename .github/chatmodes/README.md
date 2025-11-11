# GitHub Copilot Chat Modes

This directory contains specialized chat mode files for the Graviton physics simulation app. Each mode provides focused expertise and enforces critical code quality standards.

## 🚨 CRITICAL CODE QUALITY STANDARDS (Non-Negotiable)

All chat modes enforce these **blocking requirements**:

1. **AppTypography Constants** - ALL UI dimensions must use `AppTypography` constants, zero tolerance for magic numbers
2. **One Class Per File** - Each class, model, enum gets its own file with corresponding unit test  
3. **Utility Extraction** - Common logic extracted to `utils/` files, not private methods in classes
4. **Comprehensive Documentation** - All public APIs documented with examples
5. **No Magic Numbers** - All numeric values must be named constants

## Available Chat Modes

### 🔍 `quality.chatmode.md`
**Strict code quality reviewer** - Blocks magic numbers, enforces AppTypography usage, file organization
- **Use for**: Code reviews, refactoring, quality enforcement
- **Key Features**: AppTypography compliance checking, file organization patterns

### ⚗️ `physics.chatmode.md`  
**Physics simulation expert** - Gravitational mechanics, numerical integration, energy conservation
- **Use for**: Physics calculations, simulation accuracy, orbital mechanics
- **Key Features**: Real physics constants, numerical stability, conservation laws

### 🎨 `ui.chatmode.md`
**UI designer & theme expert** - Space-themed interface, cosmic colors, responsive design  
- **Use for**: Widget design, theming, visual consistency
- **Key Features**: Cosmic color palette, stellar classifications, Material Design patterns

### ⚡ `performance.chatmode.md`
**Performance optimization specialist** - 60fps rendering, memory management, optimization patterns
- **Use for**: Performance issues, optimization, custom painter efficiency
- **Key Features**: Frame timing, memory profiling, spatial partitioning

### 🌍 `i18n.chatmode.md`  
**Internationalization expert** - Multi-language support, cultural adaptation, ARB files
- **Use for**: Localization, text externalization, cultural considerations
- **Key Features**: 7-language support, scientific notation formatting, cultural number formats

### 🧪 `testing.chatmode.md`
**Testing specialist** - Unit tests, integration tests, physics validation
- **Use for**: Test creation, coverage analysis, quality assurance
- **Key Features**: Physics test precision, widget testing, performance validation

### 🎓 `scenarios.chatmode.md`
**Educational content manager** - Astronomy scenarios, lesson plans, realistic data
- **Use for**: Educational content, scenario creation, physics accuracy
- **Key Features**: Real astronomical data, adaptive difficulty, educational progression

### ♿ `accessibility.chatmode.md` 
**Accessibility expert** - WCAG compliance, inclusive design, assistive technology
- **Use for**: Accessibility compliance, inclusive design, screen reader support
- **Key Features**: WCAG 2.1 AA compliance, haptic feedback, high contrast support

## Usage Examples

### Code Quality Review
```
@quality Review this widget for AppTypography compliance and file organization issues.
```

### Physics Implementation
```  
@physics Help me implement realistic orbital mechanics for the Earth-Moon system.
```

### UI Component Design
```
@ui Create a cosmic-themed button component following our design system.
```

### Performance Optimization
```
@performance This custom painter is dropping frames - help optimize for 60fps.
```

### Internationalization
```
@i18n Add proper localization support for scientific number formatting.
```

### Test Creation
```
@testing Generate comprehensive unit tests for this physics utility class.
```

### Educational Content
```
@scenarios Design a three-body problem scenario for intermediate students.
```

### Accessibility Compliance
```
@accessibility Make this simulation interface accessible to screen reader users.
```

## Integration with Existing Prompts

These chat modes work alongside the comprehensive prompts in `.github/prompts/`:

- Chat modes provide **interactive guidance** during development
- Prompts provide **reference documentation** for complex topics
- Both enforce the same critical code quality standards

## Code Quality Enforcement Hierarchy

1. **Blocking Standards** (🚨 **Non-Negotiable**)
   - AppTypography constants usage
   - One class per file organization  
   - Utility extraction patterns
   - Comprehensive documentation

2. **High Priority Standards**
   - Physics accuracy and conservation laws
   - Performance optimization (60fps target)
   - Accessibility compliance (WCAG 2.1 AA)

3. **Standard Requirements**
   - Internationalization support
   - Educational value optimization
   - Proper testing coverage

## Quick Reference

| Mode | Primary Focus | Key Constants |
|------|---------------|---------------|
| quality | Code standards | `AppTypography.*` |
| physics | Simulation accuracy | `PhysicsConstants.*` |
| ui | Visual design | `AppColors.*`, `AppTypography.*` |
| performance | Optimization | `PerformanceConstants.*` |  
| i18n | Localization | `LocalizationUtils.*` |
| testing | Quality assurance | `TestUtils.*` |
| scenarios | Education | `AstronomicalData.*` |
| accessibility | Inclusive design | `AccessibilityConstants.*` |

## File Organization Pattern

Each mode expects this file structure:
```
lib/[category]/
├── example_class.dart           # Single class per file
└── another_class.dart           

lib/utils/  
├── [category]_utils.dart        # Extracted common logic
└── helper_utils.dart

test/[category]/
├── example_class_test.dart      # Corresponding unit tests  
└── another_class_test.dart
```

## Getting Help

- Use `@[mode]` prefix to activate specific expertise
- Each mode includes extensive examples and anti-patterns  
- All modes enforce AppTypography usage and file organization
- Reference `.github/prompts/` for detailed implementation guidance