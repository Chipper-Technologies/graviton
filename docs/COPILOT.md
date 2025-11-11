# GitHub Copilot Configuration Guide

This document provides comprehensive information about GitHub Copilot integration and configuration for the Graviton project.

## 🤖 Overview

Graviton includes extensive GitHub Copilot configuration to ensure high-quality, consistent code generation that follows the project's strict standards and physics accuracy requirements.

## 📁 Configuration Structure

```
.github/
├── instructions/
│   └── graviton.md                   # Main project instructions (auto-loaded)
├── chatmodes/
│   ├── README.md                     # Chat modes overview
│   ├── quality.chatmode.md           # Code quality reviewer
│   ├── physics.chatmode.md           # Physics simulation expert  
│   ├── ui.chatmode.md                # UI designer & theme expert
│   ├── performance.chatmode.md       # Performance optimization
│   ├── i18n.chatmode.md              # Internationalization expert
│   ├── testing.chatmode.md           # Testing specialist
│   ├── scenarios.chatmode.md         # Educational content manager
│   └── accessibility.chatmode.md     # Accessibility expert
├── prompts/
│   ├── README.md                     # Prompts overview
│   ├── code-quality-standards.md     # Core coding standards (start here!)
│   ├── physics-calculations.md       # Physics implementation guidelines
│   ├── flutter-state-management.md   # Provider patterns
│   ├── custom-painter-rendering.md   # Performance rendering
│   ├── internationalization.md       # i18n patterns
│   ├── accessibility.md              # WCAG compliance
│   ├── theme-visual-design.md        # Space-themed UI
│   ├── scenario-management.md        # Educational scenarios
│   ├── firebase-integration.md       # Backend services
│   ├── performance-optimization.md   # 60fps optimization
│   └── testing.md                    # Comprehensive testing
├── copilot-advanced-config.md        # Advanced review patterns
└── copilot-review-config.md          # Review automation
```

## 🚨 Critical Code Quality Standards

All GitHub Copilot configurations enforce these **NON-NEGOTIABLE** standards:

### 1. AppTypography Constants Usage
- **ALL** UI dimensions must use `AppTypography` constants
- **Zero tolerance** for magic numbers in UI code
- Examples:
  - ❌ `fontSize: 14.0` → ✅ `AppTypography.fontSizeMedium`  
  - ❌ `padding: 16.0` → ✅ `AppTypography.spacingLarge`
  - ❌ `opacity: 0.7` → ✅ `AppTypography.opacityHigh`

### 2. One Class Per File
- Each class, model, enum gets its own file
- Corresponding unit test file required
- No exceptions - even small enums get separate files

### 3. Utility Extraction
- Common logic goes in `utils/` files
- No private utility methods in classes
- Patterns: `PhysicsUtils`, `MathUtils`, `ValidationUtils`

### 4. No Magic Numbers
- Every numeric value must be a named constant
- Physics: `SimulationConstants.*` 
- UI: `AppTypography.*`
- Rendering: `RenderingConstants.*`

### 5. Comprehensive Documentation
- All public APIs documented with examples
- Physics formulas with mathematical notation
- Parameter descriptions and units

## 🔄 How Configurations Are Used

### Automatically Applied by VS Code

#### ✅ Instructions (`/.github/instructions/graviton.md`)
- **Purpose**: Main project guidelines applied to all Copilot interactions
- **Scope**: All code suggestions, completions, and chat responses
- **Content**: Critical standards, architecture patterns, anti-patterns
- **Usage**: Automatic - no action required

#### ✅ Chat Modes (`/.github/chatmodes/*.chatmode.md`)
- **Purpose**: Specialized expertise for specific development tasks
- **Scope**: Interactive chat sessions with focused assistance
- **Content**: Domain-specific guidance with examples and patterns
- **Usage**: Via `@mode` syntax in Copilot Chat

### Manual Reference Required

#### 📚 Prompts (`/.github/prompts/*.md`)
- **Purpose**: Comprehensive reference documentation
- **Scope**: Detailed implementation guidance for complex topics
- **Content**: In-depth patterns, examples, best practices
- **Usage**: Copy content or reference when asking for specific help

#### ⚙️ Advanced Configs
- **Purpose**: Specialized review patterns and automation
- **Scope**: Advanced code review and quality gates
- **Content**: Automated detection patterns, escalation triggers
- **Usage**: May require manual activation depending on VS Code version

## 🎯 Chat Mode Quick Reference

### Interactive Development Assistance

Use the `@mode` syntax in Copilot Chat for specialized help:

```
@quality    - Strict code quality reviewer (AppTypography enforcement)
@physics    - Physics simulation expert (gravitational mechanics)  
@ui         - UI designer (cosmic theme, space colors)
@performance- Performance optimization (60fps target)
@i18n       - Internationalization (7-language support)
@testing    - Testing specialist (comprehensive coverage)
@scenarios  - Educational content manager (astronomy scenarios)
@accessibility - Accessibility expert (WCAG 2.1 AA compliance)
```

### Example Usage

```
@quality Review this widget for AppTypography compliance and file organization issues.

@physics Help me implement realistic orbital mechanics for the Earth-Moon system with proper energy conservation.

@ui Create a cosmic-themed button component following our space design system.

@performance This custom painter is dropping frames - help optimize for 60fps rendering.

@i18n Add proper localization support for scientific number formatting across our 7 languages.

@testing Generate comprehensive unit tests for this physics utility class with edge cases.

@scenarios Design a three-body problem scenario for intermediate astronomy students.

@accessibility Make this simulation interface accessible to screen reader users with haptic feedback.
```

## 📚 Reference Documentation (Prompts)

### Starting Points

#### 🚨 [code-quality-standards.md](.github/prompts/code-quality-standards.md)
**START HERE** - Essential coding standards that all other configurations enforce.

#### ⚗️ [physics-calculations.md](.github/prompts/physics-calculations.md)  
Gravitational mechanics, N-body algorithms, numerical stability, energy conservation.

#### 🎨 [theme-visual-design.md](.github/prompts/theme-visual-design.md)
Space-themed design system, cosmic colors, stellar classifications.

### Specialized Topics

#### 🏗️ [flutter-state-management.md](.github/prompts/flutter-state-management.md)
Provider patterns, state architecture, simulation state management.

#### 🎭 [custom-painter-rendering.md](.github/prompts/custom-painter-rendering.md)
Performance-optimized rendering, 3D transformations, trail visualization.

#### 🌍 [internationalization.md](.github/prompts/internationalization.md)
Multi-language support, ARB files, scientific terminology, cultural considerations.

#### ♿ [accessibility.md](.github/prompts/accessibility.md)
WCAG compliance, screen readers, haptic feedback, keyboard navigation.

#### ⚡ [performance-optimization.md](.github/prompts/performance-optimization.md)
60fps targets, memory management, spatial optimization, level-of-detail rendering.

#### 🧪 [testing.md](.github/prompts/testing.md)
Unit tests, physics validation, widget testing, performance benchmarks.

#### 🎓 [scenario-management.md](.github/prompts/scenario-management.md)
Educational scenarios, astronomy accuracy, custom scenario validation.

#### 🔥 [firebase-integration.md](.github/prompts/firebase-integration.md)
Analytics, crash reporting, remote config, feature flags.

## 💡 Best Practices for Using GitHub Copilot with Graviton

### 1. Start with Quality Standards
Always reference the code quality standards first:
```
"Following the code-quality-standards.md guidelines, help me create a..."
```

### 2. Use Domain-Specific Chat Modes
Choose the appropriate chat mode for your task:
- UI work → `@ui`
- Physics calculations → `@physics` 
- Performance issues → `@performance`
- Testing → `@testing`

### 3. Reference Relevant Prompts
When working on complex features, copy relevant sections from prompt files:
```
"Using the physics-calculations.md patterns for orbital mechanics, implement..."
```

### 4. Combine Configurations
Use multiple sources for comprehensive guidance:
```
"Following @ui mode guidelines and the theme-visual-design.md cosmic color palette, create..."
```

### 5. Validate Against Standards
Always check generated code against the critical standards:
- ✅ Uses AppTypography constants
- ✅ One class per file
- ✅ Utilities extracted properly
- ✅ No magic numbers
- ✅ Comprehensive documentation

## 🔧 Advanced Configuration Details

### Custom Instructions Scope

The main instructions file (`graviton.md`) covers:
- **Architecture Patterns**: Provider state management, service layer separation
- **Code Quality**: AppTypography enforcement, file organization, documentation
- **Physics Standards**: Numerical stability, conservation laws, realistic constants
- **Performance**: 60fps targets, memory management, optimization patterns
- **Flutter Best Practices**: Widget composition, lifecycle management, testing

### Chat Mode Specialization

Each chat mode provides:
- **Focused Expertise**: Domain-specific knowledge and patterns
- **Practical Examples**: Both correct ✅ and incorrect ❌ implementations
- **Integration Points**: How to work with other systems and standards
- **Reference Links**: Connections to relevant prompt documentation

### Prompt Documentation Depth

Prompt files provide:
- **Comprehensive Patterns**: Detailed implementation guidance
- **Real-World Examples**: Production-ready code samples
- **Edge Cases**: Error handling and validation patterns
- **Testing Strategies**: How to validate implementations
- **Educational Context**: Why certain approaches are chosen

## 🚀 Getting Started with Copilot in Graviton

### 1. Install GitHub Copilot Extension
Ensure you have the GitHub Copilot extension installed in VS Code.

### 2. Familiarize with Standards
Read `.github/prompts/code-quality-standards.md` to understand the critical requirements.

### 3. Try Chat Modes
Open Copilot Chat and experiment with different modes:
```
@quality - Start here for code reviews
@ui - For any UI/design work
@physics - For simulation calculations
```

### 4. Reference Documentation
Keep the `.github/prompts/` directory handy for detailed guidance on complex topics.

### 5. Validate Output
Always check that generated code follows the AppTypography standards and file organization requirements.

## 🤝 Contributing to Copilot Configuration

When updating or adding to the GitHub Copilot configuration:

### 1. Maintain Standards Consistency
All configurations must enforce the same critical code quality standards.

### 2. Provide Examples
Include both correct ✅ and incorrect ❌ implementation examples.

### 3. Reference Integration
Ensure new configurations reference existing prompts and chat modes appropriately.

### 4. Test Thoroughly
Verify that new configurations provide helpful, accurate guidance.

### 5. Update Documentation
Keep this guide updated with any changes to the configuration structure.

## 🔗 Related Documentation

- **[Architecture Overview](ARCHITECTURE.md)** - Technical architecture details
- **[Contributing Guidelines](../CONTRIBUTING.md)** - How to contribute to the project
- **[Testing Guide](../test/README.md)** - Comprehensive testing strategy
- **[Development Tools](../tools/README.md)** - Build and deployment tools

## 📞 Support

For questions about GitHub Copilot configuration or usage:

1. **Check existing configurations** - Most questions are answered in the prompt files
2. **Reference chat modes** - Use appropriate `@mode` for specific guidance  
3. **Review examples** - Look at existing code that follows the patterns
4. **Ask in discussions** - Use GitHub Discussions for configuration questions

The Graviton GitHub Copilot configuration is designed to maintain high code quality while supporting educational physics accuracy. All configurations work together to ensure consistent, maintainable, and scientifically accurate code.