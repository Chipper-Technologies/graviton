# Graviton Tool Set Integration Guide

Complete guide for integrating and using all GitHub Copilot tool sets for the Graviton physics simulation project.

## Tool Set Overview

The Graviton GitHub Copilot tool sets provide comprehensive support for developing a physics-accurate educational simulation app. Each tool set serves specific aspects of development while maintaining consistency with project standards.

### Available Tool Sets

| Tool Set | File | Purpose | Primary Use Cases |
|----------|------|---------|------------------|
| **Core Tools** | `copilot-tools.md` | Physics calculations, build management, code quality | Development workflow, physics validation |
| **Quick Actions** | `copilot-quickactions.md` | Predefined commands for common tasks | Rapid development, standardized workflows |
| **Context-Aware** | `copilot-contextaware.md` | Adaptive tools based on current work context | Smart suggestions, automated quality checks |
| **Educational** | `copilot-educational.md` | Creating scientifically accurate learning content | Educational design, accessibility, assessment |

## Tool Set Activation

### Basic Activation Commands
```
@graviton-[tool-name] [specific-request]
/[quick-action-name] [parameters]
```

### Context-Aware Activation
The context-aware tool set activates automatically based on:
- **File Types**: Detects physics files, UI components, tests, configuration
- **Development Phase**: Adapts to feature development, debugging, optimization
- **Code Patterns**: Recognizes Provider state management, Custom Painters, Firebase integration

### Combined Tool Usage
```
# Multiple tool sets working together
@graviton-physics @graviton-standards Calculate orbital mechanics with AppTypography compliance

# Quick action with educational focus
/scenario-create "Binary-Stars" --educational-level=intermediate

# Context-aware optimization
# (Automatically activates when editing CustomPainter files)
```

## Development Workflows

### 1. New Feature Development Workflow

#### Phase 1: Planning & Setup
```bash
# Quick setup for new physics feature
/physics-setup gravitational-waves advanced

# Generate comprehensive planning
@graviton-lesson Create lesson plan for gravitational wave detection
@graviton-validate Check scientific accuracy of wave propagation models
```

#### Phase 2: Implementation
```bash
# Create feature with proper standards
@graviton-physics Calculate gravitational wave amplitude effects on orbital motion
@graviton-standards Ensure all calculations use SimulationConstants

# Build and test
/dev-run
@graviton-test Generate unit tests for gravitational wave calculations
```

#### Phase 3: Quality Assurance
```bash
# Comprehensive quality check
/fix-typography
/validate-standards
@graviton-accessibility Add screen reader support for wave visualization
@graviton-i18n Generate ARB keys for gravitational wave terminology
```

#### Phase 4: Educational Integration
```bash
# Educational content creation
@graviton-tutorial Create interactive tutorial for gravitational wave concept
@graviton-assessment Generate assessment questions for wave understanding
@graviton-multilingual Ensure consistent terminology across 7 languages
```

### 2. Performance Optimization Workflow

#### Phase 1: Analysis
```bash
# Performance profiling
/optimize-complete trail-rendering
@graviton-performance Analyze CustomPainter performance bottlenecks
@graviton-3d Optimize 3D coordinate transformations
```

#### Phase 2: Implementation
```bash
# Apply optimizations
@graviton-performance Implement level-of-detail rendering for distant objects
@graviton-3d Create efficient camera frustum culling

# Validate improvements
/test-performance
@graviton-standards Document optimization decisions with performance metrics
```

#### Phase 3: Validation
```bash
# Comprehensive testing
/test-all
@graviton-physics Ensure optimizations don't affect physics accuracy
@graviton-accessibility Verify performance improvements don't break accessibility
```

### 3. Educational Content Development Workflow

#### Phase 1: Content Planning
```bash
# Educational design
@graviton-lesson Create comprehensive lesson plan for [topic]
@graviton-research Incorporate latest astronomical discoveries
@graviton-cultural Ensure global perspective and cultural sensitivity
```

#### Phase 2: Interactive Development
```bash
# Tutorial creation
@graviton-tutorial Design step-by-step interactive experience
@graviton-accessibility Implement inclusive design features
@graviton-explanation Create multi-level explanations for diverse audiences
```

#### Phase 3: Assessment & Validation
```bash
# Educational validation
@graviton-assessment Create comprehensive evaluation tools
@graviton-validate Verify scientific accuracy against peer-reviewed sources
@graviton-progress Implement learning tracking and achievement systems
```

### 4. Internationalization Workflow

#### Phase 1: Content Audit
```bash
# I18n preparation
/i18n-audit
@graviton-multilingual Ensure physics terminology consistency across languages
@graviton-cultural Validate cultural appropriateness of content
```

#### Phase 2: Translation Implementation
```bash
# Translation execution
/arb-generate
@graviton-i18n Generate ARB keys for new educational content
@graviton-multilingual Adapt mathematical notation for different cultures
```

#### Phase 3: Quality Assurance
```bash
# Translation validation
@graviton-cultural Check for cultural sensitivity in all languages
@graviton-accessibility Ensure accessibility features work across languages
/format-numbers
```

## Code Quality Standards Integration

### Automatic Standards Enforcement

All tool sets automatically enforce Graviton's critical code quality standards:

#### AppTypography Constants Usage
```bash
# Automatic detection and correction
@graviton-standards Review widget for AppTypography compliance
# Automatically suggests: fontSize: 14.0 → fontSize: AppTypography.fontSizeMedium

# Quick fix command
/fix-typography
# Scans entire codebase for magic numbers and suggests AppTypography constants
```

#### File Organization - One Class Per File
```bash
# Automatic file splitting suggestions
@graviton-standards Check if this class needs separate files
# Detects multiple classes and suggests file structure

# Quick action for file organization
/split-files
# Automatically identifies files with multiple classes
```

#### Utility Function Extraction
```bash
# Common logic detection
@graviton-standards Extract common calculations to utilities
# Identifies repeated logic across classes

# Quick extraction command
/extract-utils
# Automatically extracts common functions to appropriate utils/ files
```

### Quality Assurance Checklist

Before any commit or feature completion:

```bash
# Comprehensive quality check
/validate-standards          # Check all code quality standards
@graviton-physics           # Validate physics accuracy
@graviton-accessibility     # Ensure inclusive design
@graviton-i18n             # Check internationalization
@graviton-performance      # Verify performance standards
@graviton-test             # Ensure comprehensive test coverage
```

## Integration with Existing Project Configuration

### Coordination with Existing Files

The tool sets integrate seamlessly with existing project configuration:

#### `.github/instructions/graviton.instructions.md`
- **Relationship**: Tool sets implement the coding standards defined in instructions
- **Integration**: Instructions provide the rules, tool sets provide enforcement mechanisms
- **Usage**: Tool sets automatically reference instruction standards

#### Configuration Files
```
config/dev.json          → @graviton-firebase automatically uses dev configuration
config/prod.json         → @graviton-build switches to production settings
pubspec.yaml            → @graviton-build understands dependency structure
analysis_options.yaml   → @graviton-standards aligns with Flutter analysis rules
```

#### Build System Integration
```
tasks.json (VS Code)     → Tool sets understand available build tasks
build.gradle.kts        → @graviton-build coordinates with Android build
ios/Runner.xcodeproj    → @graviton-build manages iOS build processes
```

### Continuous Integration Integration

Tool sets can be integrated into CI/CD pipelines:

```yaml
# GitHub Actions integration example
- name: Graviton Quality Check
  run: |
    @graviton-standards --validate-all
    @graviton-physics --accuracy-check
    @graviton-test --comprehensive-coverage
    @graviton-accessibility --compliance-check
```

## Best Practices

### 1. Tool Set Combinations

**Effective combinations for common scenarios:**

```bash
# New physics feature
@graviton-physics @graviton-standards @graviton-test

# UI development
@graviton-standards @graviton-accessibility @graviton-i18n

# Educational content
@graviton-lesson @graviton-validate @graviton-multilingual

# Performance optimization
@graviton-performance @graviton-3d @graviton-test
```

### 2. Development Phase Optimization

**Match tool sets to development phases:**

```bash
# Planning phase
@graviton-lesson @graviton-research @graviton-validate

# Implementation phase
@graviton-physics @graviton-standards @graviton-build

# Testing phase
@graviton-test @graviton-accessibility @graviton-performance

# Release phase
@graviton-i18n @graviton-cultural @graviton-assessment
```

### 3. Error Prevention

**Proactive quality assurance:**

```bash
# Before making changes
@graviton-standards --pre-check     # Understand current standards
@graviton-physics --validate-state  # Verify physics integrity

# During development
# (Context-aware tools activate automatically)

# Before committing
/validate-standards                 # Comprehensive quality check
```

## Troubleshooting

### Common Issues and Solutions

#### Tool Set Not Responding
```bash
# Check activation syntax
@graviton-physics [specific request]  # ✅ Correct
graviton-physics [request]           # ❌ Missing @ symbol

# Verify context
# Some tools require specific file context or development phase
```

#### Conflicting Tool Suggestions
```bash
# Use tool precedence
# Physics accuracy > Performance > Code style
@graviton-physics takes precedence over @graviton-performance
@graviton-standards takes precedence over quick formatting
```

#### Performance Impact
```bash
# Optimize tool usage
# Use specific tool sets instead of running all tools
@graviton-physics --specific-calculation  # ✅ Targeted
@graviton-all --everything               # ❌ Excessive
```

## Getting Started

### 1. Initial Setup
```bash
# Verify tool set availability
@graviton-standards --health-check
/validate-standards

# Run comprehensive project audit
@graviton-physics --project-audit
@graviton-accessibility --baseline-check
@graviton-i18n --completeness-audit
```

### 2. First Feature Development
```bash
# Start with a simple feature
/physics-setup simple-orbit beginner
@graviton-tutorial Create basic orbital mechanics tutorial
@graviton-test Generate tests for orbital calculations
```

### 3. Gradual Integration
- **Week 1**: Focus on `@graviton-standards` and basic quality checks
- **Week 2**: Add `@graviton-physics` for calculation validation
- **Week 3**: Integrate `@graviton-educational` for content creation
- **Week 4**: Use full tool set ecosystem for complex features

This integration guide ensures effective use of all Graviton tool sets while maintaining the project's high standards for physics accuracy, code quality, and educational value.