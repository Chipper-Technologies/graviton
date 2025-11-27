# Tools Documentation

This directory contains development and build tools for the Graviton app.

## Files

### Screenshot Processing
- `generate_screenshots.py` - Main Python script for image processing
- `generate_screenshots.sh` - Shell wrapper for screenshot processing
- `requirements.txt` - Python dependencies for screenshot tools

### Android Build Tools  
- `generate_keystore.sh` - Interactive Android release keystore generator
- `README.md` - This documentation file

### Code Quality Tools
- `analyze_coverage.py` - Enhanced Flutter test coverage analysis with exclusions
- `i18n_manager.py` - Internationalization management for detecting hardcoded strings
- `arb_auditor.py` - ARB file analysis and reorganization tool
- `arb_duplicate_cleaner.py` - Intelligent duplicate value removal for ARB files

### Web Configuration Tools
- `inject_web_config.dart` - Injects environment-specific Google OAuth Client ID into web/index.html
- `restore_web_template.dart` - Restores template variables in web/index.html for version control

## Screenshot Generation

### Features

#### 1. README Images
- Generates low-resolution images (300px width) for README display
- Optimized for web viewing with enhanced clarity
- Maintains aspect ratio
- Output: `assets/screenshots/readme/`

#### 2. App Store Feature Images
- **Android**: Configurable aspect ratios with cosmic background (defaults to highest resolution)
  - Available: 1920×1080, 1080×1920, 2560×1440, 1440×2560
  - Default: 2560×1440 (QHD landscape - highest resolution)
- **iOS**: Configurable App Store dimensions with cosmic background (defaults to highest resolution)
  - Available: 1242×2688, 2688×1242, 1284×2778, 2778×1284
  - Default: 2778×1284 (iPhone 12 Pro landscape - highest resolution)

#### 3. Markdown Generation
- Creates ready-to-use markdown with clickable thumbnails
- Thumbnails link to full-resolution images
- Organized in responsive grid layout

### Usage

#### Quick Start
```bash
# Generate highest resolution feature images + README thumbnails (default)
./tools/generate_screenshots.sh

# Or using Python directly (highest resolution only)
python3 tools/generate_screenshots.py
```

#### Size Configuration
```bash
# Generate all available sizes for both platforms
python3 tools/generate_screenshots.py --all-sizes

# Custom Android sizes only
python3 tools/generate_screenshots.py --android-sizes 2560x1440 1920x1080

# Custom iOS sizes only  
python3 tools/generate_screenshots.py --ios-sizes 2778x1284 2688x1242

# Both platforms with custom sizes
python3 tools/generate_screenshots.py --android-sizes 2560x1440 --ios-sizes 2778x1284 2688x1242
```

#### Processing Options
```bash
# Generate only README images
python3 tools/generate_screenshots.py --readme-only

# Generate only feature images (with custom sizes)
python3 tools/generate_screenshots.py --feature-only --all-sizes

# Custom thumbnail width (default: 300px)
python3 tools/generate_screenshots.py --max-width 400

# All sizes but only feature images
python3 tools/generate_screenshots.py --all-sizes --feature-only
```

#### Virtual Environment Setup (Recommended)
For isolated Python dependencies, use a virtual environment:

```bash
# Create virtual environment (one-time setup)
python3 -m venv .venv

# Activate virtual environment (required for each session)
source .venv/bin/activate

# Install dependencies in virtual environment
pip install Pillow

# Run screenshot processing with virtual environment
python tools/generate_screenshots.py

# Deactivate when done (optional)
deactivate
```

For subsequent runs, you only need to activate and run:
```bash
source .venv/bin/activate && python tools/generate_screenshots.py
```

#### Setup (if needed)
```bash
# Install dependencies globally (alternative to virtual environment)
pip3 install -r tools/requirements.txt
```

### Input Structure
Place your raw screenshots in:
```
assets/screenshots/
├── android/          # Raw Android screenshots
│   ├── android-1.png
│   ├── android-2.png
│   └── ...
└── ios/              # Raw iOS screenshots
    ├── ios-1.png
    ├── ios-2.png
    └── ...
```

### Output Structure
```
assets/screenshots/
├── android/             # Platform-first organization
│   ├── readme/          # Low-res thumbnails for README
│   │   ├── android-1.png
│   │   └── android-2.png
│   └── feature/         # App store feature images
│       ├── android-1_2560x1440.png  # Default: highest resolution only
│       └── android-2_2560x1440.png  # (or multiple sizes with --all-sizes)
├── ios/                 # Platform-first organization  
│   ├── readme/          # Low-res thumbnails for README
│   │   ├── ios-1.png
│   │   └── ios-2.png
│   └── feature/         # App store feature images
│       ├── ios-1_2778x1284.png      # Default: highest resolution only
│       └── ios-2_2778x1284.png      # (or multiple sizes with --all-sizes)
├── android/             # Original raw screenshots
│   ├── android-1.png
│   └── android-2.png
└── ios/                 # Original raw screenshots
    ├── ios-1.png
    └── ios-2.png
```

## Android Keystore Generation

### Overview
The `generate_keystore.sh` script creates a release keystore for Android app signing, required for Google Play Store distribution.

## Coverage Analysis

### Overview
The `analyze_coverage.py` script provides enhanced Flutter test coverage analysis with intelligent exclusions for auto-generated files. It filters out localization files and other generated code to give you a cleaner view of actual code coverage.

### Quick Start
```bash
# Generate coverage and analyze (complete workflow)
flutter test --coverage && python3 tools/analyze_coverage.py

# Or analyze existing coverage data
python3 tools/analyze_coverage.py
```

### Key Features
- 🎯 **Smart exclusions**: Auto-filters generated localization and build files
- 📊 **Visual indicators**: Color-coded coverage levels (🔴🟡🟢✅)
- 🚀 **Improvement recommendations**: ROI-based suggestions for which files to target
- 📈 **Real coverage**: Shows actual testable code coverage (excluding generated files)

### Example Output
```
Flutter Coverage Analysis (Excluding Generated Files)
============================================================
Overall Coverage: 75.7% (8859/11699 lines)
Files Analyzed: 119
Files Excluded: 7

🎯 Improvement Recommendations:
• Focus on files with moderate size (50-200 lines) for best ROI
• Consider these priorities:
  1. changelog_service.dart - 31.2% coverage, 77 lines
  2. gravity_field_color_scheme.dart - 31.2% coverage, 64 lines
```

📚 **[Complete Coverage Analysis Documentation](../docs/COVERAGE.md)**

## Internationalization (i18n) Management

### Overview
The `i18n_manager.py` script helps maintain proper internationalization throughout the Graviton app by detecting hardcoded English strings and suggesting proper localized replacements. It ensures all user-facing text uses the ARB (Application Resource Bundle) localization system.

### Quick Start
```bash
# Scan entire project for hardcoded strings
python3 tools/i18n_manager.py --scan

# Scan specific file
python3 tools/i18n_manager.py --file lib/screens/home_screen.dart

# Generate replacement suggestions
python3 tools/i18n_manager.py --scan --generate-keys
```

### Key Features
- 🔍 **Smart Detection**: Identifies hardcoded strings in Text widgets, tooltips, labels, and more
- 🎯 **Context-Aware**: Generates appropriate key names based on file location and usage context
- 🔑 **Duplicate Prevention**: Checks existing ARB keys to prevent duplicates
- 🚫 **Intelligent Filtering**: Skips technical terms, debug messages, and non-user-facing text
- 📝 **Code Suggestions**: Provides exact Dart code replacements using `l10n.keyName`

### Example Output
```
🔍 Scanning for hardcoded strings...
📊 Found 12 hardcoded strings in 3 files:

📁 lib/screens/scenario_editor_screen.dart:
  Line 45: 'Physics Settings' → physicsSettingsEditor (new)
    Replace with: l10n.physicsSettingsEditor
  Line 78: 'Add Body' → addBodyEditor (exists: addBodyEditor)
    Replace with: l10n.addBodyEditor

📁 lib/widgets/custom_button.dart:
  Line 23: 'Save Changes' → saveChanges (new)
    Replace with: l10n.saveChanges
```

### Detection Patterns

#### Text Widgets
- `Text('Hardcoded String')` - Single and multi-line patterns
- `const Text('Label Text')` - Const text widgets
- Nested text in other widgets (AlertDialog, AppBar, etc.)

#### Widget Properties
- `tooltip: 'Help text'`
- `hintText: 'Enter value'`
- `labelText: 'Field name'`
- `title: 'Dialog title'`
- Custom widget parameters like `SectionDivider.labeled('Section', bottomSpacing: AppTypography.spacingMedium)`

#### Object Properties
- Constructor parameters: `name: 'Custom Scenario'`
- Default values: `difficulty: 'beginner'`
- List items: `['Advanced', 'Intermediate']`

### Intelligent Filtering

The tool automatically skips non-translatable content:

#### Technical Terms
- Constants: `'DEV'`, `'PROD'`
- URLs: `'https://example.com'`
- Property access: `'widget.property'`
- Universal terms: `'Jupiter'`, `'Earth'`, celestial body names

#### System Messages
- Debug output: `debugPrint('System message')`
- Error handling: `Exception('Internal error')`
- Development identifiers: `'test preset'`, `'body index'`

#### Code Patterns
- Boolean values: `'true'`, `'false'`
- Numbers: `'123'`, `'45.67'`
- Short strings: Single characters or very brief text

### Key Generation Rules

#### Naming Convention
- **camelCase**: First word lowercase, subsequent words capitalized
- **Context Suffixes**: Added based on file location and usage
  - `Editor` for scenario editor files
  - `Home` for home screen components
  - `Tooltip`, `Label`, `Button` for specific UI elements

#### Examples
- `'Physics Settings'` → `physicsSettingsEditor` (in scenario editor)
- `'Save Changes'` → `saveChangesButton` (button context)
- `'Enter name'` → `enterNameHint` (hint text context)
- `'Advanced'` → `advanced` (simple terms)

### Context Detection

The tool determines appropriate context based on:

#### File Location
- `scenario_editor_screen.dart` → `Editor` suffix
- `home_screen.dart` → `Home` suffix  
- `custom_scenarios.dart` → `CustomScenario` suffix

#### Usage Pattern
- `tooltip:` → `Tooltip` suffix
- `hintText:` → `Hint` suffix
- `labelText:` → `Label` suffix
- Button-related → `Button` suffix

### Command Options

#### Basic Usage
```bash
# Scan all files in lib/ directory
python3 tools/i18n_manager.py

# Same as above (explicit)
python3 tools/i18n_manager.py --scan
```

#### Specific File Analysis
```bash
# Scan individual file
python3 tools/i18n_manager.py --file lib/screens/home_screen.dart

# Scan file with relative path from project root
python3 tools/i18n_manager.py --file lib/widgets/scenario_card.dart
```

#### Code Generation
```bash
# Show replacement code suggestions
python3 tools/i18n_manager.py --scan --generate-keys

# Generate suggestions for specific file
python3 tools/i18n_manager.py --file lib/screens/settings.dart --generate-keys
```

### Integration Workflow

#### 1. Development Phase
```bash
# Before committing new features
python3 tools/i18n_manager.py --scan --generate-keys
```

#### 2. Code Review
- Run i18n scan on changed files
- Ensure new hardcoded strings are identified
- Verify suggested keys follow naming conventions

#### 3. Localization Update
- Add new keys to `lib/l10n/app_en.arb`
- Update corresponding translation files
- Replace hardcoded strings with `l10n.keyName` calls

### ARB Integration

#### Existing Key Detection
The tool loads existing keys from `lib/l10n/app_en.arb` to:
- Prevent duplicate key generation
- Suggest existing keys when appropriate
- Maintain consistency with current localization

#### Key Format
Generated keys follow ARB best practices:
```json
{
  "physicsSettingsEditor": "Physics Settings",
  "@physicsSettingsEditor": {
    "description": "Text for physicsSettingsEditor"
  }
}
```

### Best Practices

#### When to Run
- **Before each commit**: Ensure no new hardcoded strings
- **During code review**: Verify i18n compliance
- **Before releases**: Complete project scan
- **After UI changes**: Check affected screens and widgets

#### Key Naming Guidelines
- Use descriptive, context-specific names
- Follow camelCase convention consistently
- Include context suffixes for clarity
- Keep keys concise but meaningful

#### Common Patterns to Fix
```dart
// ❌ Hardcoded
Text('Save Changes')

// ✅ Localized
Text(l10n.saveChangesButton)

// ❌ Hardcoded tooltip
IconButton(
  tooltip: 'Add new body',
  onPressed: onAdd,
)

// ✅ Localized tooltip
IconButton(
  tooltip: l10n.addNewBodyTooltip,
  onPressed: onAdd,
)
```

### Troubleshooting

#### Common Issues
1. **False Positives**: Tool flags technical terms as translatable
   - Update skip patterns in `_should_skip_text()` method
   - Add specific terms to `technical_terms` list

2. **Missing Context**: Generated keys lack appropriate context
   - Verify file naming matches context patterns
   - Check `_determine_context()` method mappings

3. **Key Conflicts**: Suggested keys already exist
   - Tool will show existing key and suggest reuse
   - Verify the existing key has appropriate text

#### Advanced Usage
```bash
# Debug specific patterns (modify source as needed)
python3 -c "
from tools.i18n_manager import I18nManager
from pathlib import Path
manager = I18nManager(Path('.'))
results = manager.find_hardcoded_strings(Path('lib/screens/test.dart'))
for result in results: print(result)
"
```

### Example Integration

#### CI/CD Pipeline
```yaml
# GitHub Actions example
- name: Check i18n Compliance
  run: |
    pip install -r tools/requirements.txt 2>/dev/null || true
    python3 tools/i18n_manager.py --scan > i18n_report.txt
    if grep -q "hardcoded strings" i18n_report.txt; then
      echo "Hardcoded strings found - please localize:"
      cat i18n_report.txt
      exit 1
    fi
```

#### Pre-commit Hook
```bash
#!/bin/bash
# .git/hooks/pre-commit
python3 tools/i18n_manager.py --scan --generate-keys | grep -E "(new|exists)" && {
  echo "Please address hardcoded strings before committing"
  exit 1
}
```

## ARB File Management

### Overview
The ARB (Application Resource Bundle) management tools help maintain clean, organized, and efficient localization files. These tools work together to audit, reorganize, and optimize the `app_en.arb` file by removing duplicates and organizing content logically.

### Tools
- `arb_auditor.py` - Comprehensive ARB file analysis and reorganization
- `arb_duplicate_cleaner.py` - Intelligent duplicate value removal and cleanup

### Quick Start
```bash
# Audit ARB file for duplicates and organization issues
python3 tools/arb_auditor.py

# Clean up duplicate values automatically
python3 tools/arb_duplicate_cleaner.py

# Audit and reorganize in one step
echo "y" | python3 tools/arb_auditor.py
```

### ARB Auditor (`arb_auditor.py`)

#### Features
- 📊 **Comprehensive Analysis**: Reports total keys, metadata, and categorization breakdown
- 🔍 **Duplicate Detection**: Identifies duplicate values across different keys
- 📁 **Smart Categorization**: Organizes keys into logical sections (Core App, Navigation, etc.)
- 🔄 **File Reorganization**: Restructures ARB file with clean category-based organization
- 💾 **Safe Operations**: Automatic backups before making changes

#### Example Output
```
ARB File Audit Report
==================================================

Total translation keys: 651
Total entries (including metadata): 1267

✅ No duplicate keys found
✅ No duplicate values found

📊 CATEGORIZATION BREAKDOWN:
  Core App: 5 keys
  Navigation: 9 keys
  Simulation Controls: 56 keys
  Camera Controls: 23 keys
  Visual Settings: 4 keys
  Physics Settings: 40 keys
  Scenario Editor: 30 keys
  Custom Scenarios: 7 keys
  [... more categories ...]
  Uncategorized: 377 keys
```

#### Usage
```bash
# Basic audit (shows report only)
python3 tools/arb_auditor.py

# Audit with automatic reorganization
echo "y" | python3 tools/arb_auditor.py

# Interactive mode (asks for confirmation)
python3 tools/arb_auditor.py --scan
```

#### Categories
The auditor organizes keys into logical sections:

**Core Categories:**
- **Core App**: App title, description, version info
- **Navigation**: Bottom nav, drawers, screen navigation
- **Simulation Controls**: Play, pause, reset, speed controls
- **Camera Controls**: Camera modes, zoom, rotation
- **Visual Settings**: Themes, colors, display options
- **Physics Settings**: Gravity, mass, collision parameters

**Feature Categories:**
- **Preset Scenarios**: Solar system, binary stars, three-body problems
- **Scenario Editor**: Create, edit, modify custom scenarios
- **Custom Scenarios**: Save, load, import, export functionality
- **Settings Screen**: App preferences and configuration
- **Tutorial**: Guided learning and help content

**Technical Categories:**
- **Statistics**: Performance metrics and data analysis
- **Accessibility**: Screen reader and voice announcements
- **Time & Date**: Temporal formatting and display
- **Units**: Measurement units and conversions
- **Errors & Messages**: User notifications and alerts
- **Debug**: Development and testing strings

### ARB Duplicate Cleaner (`arb_duplicate_cleaner.py`)

#### Features
- 🧹 **Intelligent Cleanup**: Automatically identifies and removes duplicate values
- 🎯 **Smart Key Selection**: Uses quality scoring to keep the best key for each value
- 📋 **Change Planning**: Provides detailed plan before making modifications
- 🔄 **Code Migration**: Lists all key replacements needed in Dart files
- 💾 **Safe Operations**: Multiple backup layers before cleanup

#### Key Quality Scoring
The tool uses intelligent scoring to select the best key to keep:

**Higher Quality (Keep):**
- Shorter, cleaner key names
- Generic, reusable patterns (`playButton`, `closeButton`)
- Consistent naming conventions
- Accessibility-specific keys for screen reader content

**Lower Quality (Remove):**
- Overly long or complex names
- Keys with bad suffixes (`customscenario`, `hometitle`)
- Multiple camelCase transitions
- Context-specific duplicates of generic terms

#### Example Cleanup
```
ARB Cleanup Plan
========================================

📊 Found 61 sets of duplicates to clean
🗑️  Will remove 134 keys

'Physics':
  ✅ Keep: physicsSection
  ❌ Remove: bottomNavPhysicsLabel
  ❌ Remove: physicsEditortitle

'Close':
  ✅ Keep: closeButton
  ❌ Remove: closeDialog
  ❌ Remove: closeHome

'Create Custom Scenario':
  ✅ Keep: createCustomScenarioButton
  ❌ Remove: createCustomScenarioCustomscenario
```

#### Usage
```bash
# Analyze duplicates (dry run)
python3 tools/arb_duplicate_cleaner.py

# Apply cleanup automatically
echo "y" | python3 tools/arb_duplicate_cleaner.py

# Interactive mode with confirmation
python3 tools/arb_duplicate_cleaner.py
```

#### Code Migration
After cleanup, update Dart files with the provided key mappings:

```dart
// Before cleanup
Text(l10n.physicsEditortitle)           // ❌ Remove
Text(l10n.bottomNavPhysicsLabel)        // ❌ Remove

// After cleanup  
Text(l10n.physicsSection)               // ✅ Use this
Text(l10n.physicsSection)               // ✅ Use this
```

### Workflow Integration

#### Development Workflow
```bash
# 1. Audit current state
python3 tools/arb_auditor.py

# 2. Clean up duplicates if found
python3 tools/arb_duplicate_cleaner.py

# 3. Update Dart files with key changes
# (Use the provided mapping list)

# 4. Test app functionality
flutter test

# 5. Final reorganization
python3 tools/arb_auditor.py
```

#### Maintenance Schedule
- **Weekly**: Run auditor to check for new duplicates
- **Before releases**: Complete audit + cleanup cycle
- **After major UI changes**: Verify key organization
- **Code reviews**: Include ARB file changes in review process

#### CI/CD Integration
```yaml
# GitHub Actions example
- name: ARB File Quality Check
  run: |
    python3 tools/arb_auditor.py > arb_report.txt
    if grep -q "DUPLICATE VALUES FOUND" arb_report.txt; then
      echo "Duplicate values found in ARB file:"
      cat arb_report.txt
      exit 1
    fi
```

### Best Practices

#### Key Naming Conventions
- **Use consistent suffixes**: `Button`, `Label`, `Title`, `Tooltip`
- **Avoid redundant context**: Don't repeat screen names in every key
- **Group related keys**: Use common prefixes for feature areas
- **Keep keys concise**: Prefer `saveButton` over `saveChangesButton`

#### File Organization
- **Regular auditing**: Run tools monthly or after major changes
- **Category completeness**: Ensure all keys are properly categorized
- **Backup strategy**: Keep backups before automated changes
- **Documentation**: Update key usage documentation

#### Common Issues to Avoid
```dart
// ❌ Don't create multiple keys for same text
"closeButton": "Close",
"closeDialog": "Close",
"closeHome": "Close",

// ✅ Use one key consistently
"closeButton": "Close",
// Use l10n.closeButton everywhere
```

### Troubleshooting

#### Common Issues
1. **JSON Validation Errors**: Run `flutter packages get` to validate ARB syntax
2. **Missing Keys**: Use auditor to find uncategorized keys
3. **Build Failures**: Update all Dart files before testing
4. **Category Mismatches**: Check pattern matching in auditor categories

#### Recovery Options
```bash
# Restore from backup if needed
cp lib/l10n/app_en.arb.backup lib/l10n/app_en.arb

# Validate JSON syntax
python3 -m json.tool lib/l10n/app_en.arb > /dev/null && echo "Valid JSON"

# Check Flutter localization
flutter pub get && flutter analyze
```

#### Performance Impact
- **Audit time**: ~2-3 seconds for large ARB files (700+ keys)
- **Cleanup time**: ~1 second for duplicate removal
- **File size reduction**: Typical 10-15% reduction after cleanup
- **Build impact**: No performance impact on app build times

## Android Keystore Generation

### Features
- **Interactive Setup**: Guided prompts for keystore configuration
- **Security Focused**: Secure password handling and validation
- **Auto-Configuration**: Automatically updates `android/key.properties`
- **Validation**: Checks for existing keystores and Java installation
- **Documentation**: Provides clear next steps and warnings

### Usage

#### Basic Usage
```bash
# Run the interactive keystore generator
./tools/generate_keystore.sh
```

#### Requirements
- Java Development Kit (JDK) with `keytool` command
- Write access to `android/` directory

### Process Flow

#### 1. Pre-flight Checks
- Verifies `keytool` is available
- Checks for existing keystore files
- Prompts for overwrite confirmation if needed

#### 2. Password Collection
- Store password (minimum 6 characters)
- Key password (minimum 6 characters)  
- Password confirmation for both
- Secure input (passwords hidden during typing)

#### 3. Certificate Information
The script prompts for standard certificate details:
- **CN (Common Name)**: Your name or organization
- **OU (Organizational Unit)**: Department (optional)
- **O (Organization)**: Company name (optional)
- **L (Locality)**: City
- **ST (State)**: State or province
- **C (Country Code)**: Two-letter country code

#### 4. Keystore Generation
- Creates RSA 2048-bit key pair
- Sets 10,000-day validity period
- Uses `upload` as key alias
- Stores in `android/upload-keystore.jks`

#### 5. Configuration Update
Automatically creates/updates `android/key.properties`:
```properties
storeFile=upload-keystore.jks
storePassword=<your_store_password>
keyAlias=upload
keyPassword=<your_key_password>
```

### Security Notes

#### Critical Information
- **Never lose your keystore**: Google Play requires the same keystore for all app updates
- **Backup everything**: Store keystore and passwords in multiple secure locations
- **Version control**: Never commit `key.properties` to git (already in .gitignore)
- **Access control**: Limit keystore file access to authorized personnel only

#### Backup Recommendations
1. Store keystore file in secure cloud storage
2. Document passwords in password manager
3. Create physical backup for critical releases
4. Test keystore before first production release

### Generated Files

#### `android/upload-keystore.jks`
- Binary keystore file containing your signing certificate
- Required for all release builds
- Must be kept secure and backed up

#### `android/key.properties`
- Configuration file for Gradle build system
- Contains keystore path and credentials
- Automatically excluded from version control

### Integration with Build Process

The generated keystore integrates with your existing build tasks:

```bash
# Build signed release App Bundle
flutter build appbundle --flavor prod --dart-define-from-file config/prod.json --release

# Build signed release APK  
flutter build apk --flavor prod --dart-define-from-file config/prod.json --release
```

### Troubleshooting

#### Common Issues

1. **keytool not found**
   ```bash
   # Install JDK on macOS
   brew install openjdk
   
   # Install JDK on Ubuntu/Debian
   sudo apt install default-jdk
   ```

2. **Permission denied**
   ```bash
   chmod +x tools/generate_keystore.sh
   ```

3. **Keystore already exists**
   - Script will prompt for overwrite confirmation
   - Backup existing keystore before overwriting
   - Consider versioning keystores for safety

4. **Password requirements**
   - Minimum 6 characters for both passwords
   - Passwords must match confirmation
   - Use strong, unique passwords

#### Recovery Options

If keystore generation fails:
1. Check Java installation: `java -version`
2. Verify write permissions to `android/` directory
3. Ensure no other processes are using keystore file
4. Run script with elevated permissions if needed

### Example Session

```bash
$ ./tools/generate_keystore.sh

🔐 Graviton Android Release Keystore Generator
==============================================

📝 Please provide keystore passwords:

Store password (min 6 characters): ********
Confirm store password: ********
Key password (min 6 characters): ********  
Confirm key password: ********

🔧 Generating keystore...
You will be prompted to enter certificate information.

What is your first and last name?
  [Unknown]:  Scott Developer
What is the name of your organizational unit?
  [Unknown]:  Development
What is the name of your organization?
  [Unknown]:  Chipper Technologies
What is the name of your City or Locality?
  [Unknown]:  San Francisco
What is the name of your State or Province?
  [Unknown]:  CA
What is the two-letter country code for this unit?
  [Unknown]:  US
Is CN=Scott Developer, OU=Development, O=Chipper Technologies, L=San Francisco, ST=CA, C=US correct?
  [no]:  yes

✅ Keystore generated successfully!

📝 Updating android/key.properties...

🎉 Setup complete!

📋 Next steps:
1. Keep your keystore file (android/upload-keystore.jks) secure
2. Back up your keystore and passwords in a safe location
3. Never commit android/key.properties to version control
4. Build your release app bundle: flutter build appbundle --flavor prod --dart-define-from-file config/prod.json --release

⚠️  IMPORTANT: If you lose your keystore, you won't be able to update your app on Google Play!
```

### Technical Details

#### Screenshot Image Processing

##### README Images
- **Resize**: Max width 300px, maintaining aspect ratio
- **Enhancement**: Subtle sharpening and contrast boost for clarity
- **Optimization**: PNG with 85% quality for fast loading
- **Purpose**: Responsive thumbnails for documentation

##### Feature Images
- **Background**: Cosmic theme (#1a1a2e) with subtle gradient effects
- **Scaling**: Screenshots scaled to 85% of target size with proper padding
- **Quality**: PNG with 95% quality for app store submission
- **Enhancement**: Maintains original screenshot quality with cosmic branding
- **Sizing**: Configurable dimensions (defaults to highest resolution per platform)

##### Available Feature Image Sizes
- **Android**: 1920×1080, 1080×1920, 2560×1440, 1440×2560
- **iOS**: 1242×2688, 2688×1242, 1284×2778, 2778×1284
- **Default**: Android 2560×1440, iOS 2778×1284 (highest resolution)

#### Cosmic Background Features
- Deep space color scheme matching app theme
- Subtle gradient effect simulating space depth
- Sparse star field effect for visual interest
- Proper centering and padding for screenshots

### Requirements

#### Screenshot Tools
- Python 3.6+
- Pillow (PIL) library (`pip install Pillow`)
- macOS/Linux environment (Windows compatible with minor modifications)
- Virtual environment recommended (`.venv` for isolated dependencies)

#### Keystore Generation
- Java Development Kit (JDK) with keytool
- Bash-compatible shell (macOS, Linux, WSL on Windows)
- Write access to android/ directory

### Performance & Optimization

#### Screenshot Processing
- Processes screenshots efficiently (varies by number of images and selected sizes)
- Default: ~1-2 seconds for 12 screenshots with highest resolution only
- All sizes: ~3-5 seconds for 24 feature images (12 Android + 12 iOS) with all 4 sizes each
- Memory efficient processing with automatic cleanup
- Parallel processing for different image types
- Optimized for batch operations

#### Error Handling
- Comprehensive error handling for both tools
- Missing directories created automatically
- Invalid images skipped with error messages
- Processing continues even if individual operations fail
- Detailed progress reporting and summary statistics

## Troubleshooting

### Coverage Analysis

#### Common Issues
1. **Coverage file not found**: 
   - Run `flutter test --coverage` first to generate coverage data
   - Check that `coverage/lcov.info` exists in project root
2. **Permission denied**: Run `chmod +x tools/analyze_coverage.py`
3. **Python not found**: Ensure Python 3.6+ is installed (`python3 --version`)
4. **No files analyzed**: Verify project has Dart files outside test/build directories
5. **Empty coverage data**: Ensure tests run successfully before coverage generation

#### Integration Issues
```bash
# Complete workflow for troubleshooting
flutter clean                              # Clean build cache
flutter test                              # Verify tests pass
flutter test --coverage                   # Generate fresh coverage
python3 tools/analyze_coverage.py         # Analyze coverage
```

### Screenshot Tools

#### Common Issues
1. **Pillow not installed**: 
   - Global: Run `pip3 install Pillow`
   - Virtual environment: `source .venv/bin/activate && pip install Pillow`
2. **Permission denied**: Run `chmod +x tools/generate_screenshots.sh`
3. **Python not found**: Ensure Python 3.6+ is installed
4. **Virtual environment not activated**: Run `source .venv/bin/activate` before using the script
5. **Memory issues**: Process smaller batches of images

#### Debug Mode
Add verbose logging for detailed processing information:
```bash
# Note: --verbose flag not yet implemented, but processing shows detailed progress
python3 tools/generate_screenshots.py --all-sizes
```

#### Common Options
```bash
# See all available options
python3 tools/generate_screenshots.py --help

# Example combinations
python3 tools/generate_screenshots.py --android-sizes 2560x1440 --readme-only
python3 tools/generate_screenshots.py --all-sizes --max-width 250
```

### Keystore Generation

#### Common Issues
1. **keytool not found**: Install JDK (`brew install openjdk` on macOS)
2. **Permission denied**: Run `chmod +x tools/generate_keystore.sh`
3. **Keystore exists**: Script prompts for overwrite confirmation
4. **Password requirements**: Minimum 6 characters, matching confirmation

### Integration with CI/CD

All tools can be integrated into automated build processes:

```yaml
# GitHub Actions example
- name: Run Tests with Coverage Analysis
  run: |
    flutter test --coverage
    python3 tools/analyze_coverage.py
    # Optional: Fail build if coverage below threshold
    COVERAGE=$(python3 tools/analyze_coverage.py | grep "Overall Coverage" | grep -o '[0-9.]*%' | head -1 | sed 's/%//')
    if (( $(echo "$COVERAGE < 70.0" | bc -l) )); then
      echo "Coverage $COVERAGE% is below 70% threshold"
      exit 1
    fi

- name: Generate Screenshots
  run: |
    pip install Pillow
    python3 tools/generate_screenshots.py
    git add assets/screenshots/

- name: Setup Android Signing (Manual keystore)
  run: |
    # Keystore generation requires interactive input
    # Store keystore and key.properties as secrets
    echo "${{ secrets.ANDROID_KEYSTORE }}" | base64 -d > android/upload-keystore.jks
    echo "${{ secrets.KEY_PROPERTIES }}" > android/key.properties
```

## Best Practices

### Screenshot Management
1. **Consistent naming**: Use sequential numbering (android-1.png, ios-1.png, etc.)
2. **Quality control**: Review screenshots before processing
3. **Regular updates**: Refresh screenshots when UI changes significantly
4. **Platform parity**: Maintain similar screenshot sets for both platforms

### Keystore Security
1. **Backup strategy**: Multiple secure locations for keystore and passwords
2. **Access control**: Limit keystore access to authorized team members
3. **Version control**: Never commit signing credentials to repositories
4. **Testing**: Verify keystore before production releases
5. **Documentation**: Maintain clear records of keystore details

### Development Workflow
1. **Screenshot collection**: Use dev builds with screenshot mode
2. **Processing**: Run screenshot tools after collecting new images
3. **Review**: Check generated thumbnails and feature images
4. **Integration**: Update README with new screenshot markdown
5. **Keystore**: Generate once per project, backup immediately

## Web Configuration Injection

### Problem

The `google_sign_in_web` package requires a Google OAuth Client ID to be present in `web/index.html` as a meta tag at page load time (before Flutter code runs). However, we have different client IDs for dev and prod environments, so we cannot hardcode a single value.

### Solution

We use build-time injection to substitute the correct client ID based on the configuration file being used.

### Configuration Files

The Google Web Client ID must be added to the web config files:

**`config/dev-web.json`**:
```json
{
  "google.webClientId": "645841860075-om0guja4l633a3hic1lms1h38rfmvfj7.apps.googleusercontent.com"
}
```

**`config/prod-web.json`**:
```json
{
  "google.webClientId": "YOUR_PROD_CLIENT_ID.apps.googleusercontent.com"
}
```

### Getting the Client ID

The Web Client ID (OAuth 2.0 Client ID type 3) can be found in:
1. **Google Cloud Console**: https://console.cloud.google.com/apis/credentials?project=graviton-dev
2. **Firebase `google-services.json`**: Under `oauth_client` array with `"client_type": 3`

Example from `android/app/src/dev/google-services.json`:
```json
{
  "client_id": "645841860075-om0guja4l633a3hic1lms1h38rfmvfj7.apps.googleusercontent.com",
  "client_type": 3
}
```

### Usage

#### Automated (Recommended)

The VS Code tasks automatically inject the config before running/building:

```bash
# Via VS Code tasks
[DEV][WEB] Run App     # Automatically injects dev config
[PROD][WEB] Run App    # Automatically injects prod config
[DEV][WEB] Build App   # Automatically injects dev config
[PROD][WEB] Build App  # Automatically injects prod config
```

These tasks have a `dependsOn` relationship that runs the injection script first.

#### Manual Injection

```bash
# Inject dev config
dart run tools/inject_web_config.dart config/dev-web.json

# Inject prod config
dart run tools/inject_web_config.dart config/prod-web.json

# Restore template (before committing)
dart run tools/restore_web_template.dart
```

### Version Control

The `web/index.html` file should be committed with the template variable `$GOOGLE_WEB_CLIENT_ID`, not a hardcoded value.

**Pre-commit hook**: A git pre-commit hook (`.git/hooks/pre-commit`) automatically restores the template variable before each commit to prevent accidentally committing credentials.

### How It Works

1. **Template in HTML**: `web/index.html` contains `<meta name="google-signin-client_id" content="$GOOGLE_WEB_CLIENT_ID">`
2. **Config file**: The client ID is stored in `config/dev-web.json` or `config/prod-web.json`
3. **Injection script**: `inject_web_config.dart` reads the config and replaces `$GOOGLE_WEB_CLIENT_ID` with the actual value
4. **Build process**: VS Code tasks run the injection before `flutter run` or `flutter build web`
5. **Restoration**: `restore_web_template.dart` puts the template variable back before commits

### Troubleshooting

**Error: "google.webClientId not found in config file"**
- Add the `google.webClientId` key to your config JSON file with the correct OAuth 2.0 Web Client ID

**Google Sign-In not working on web**
- Ensure the client ID in the meta tag matches your Google Cloud Console OAuth 2.0 Web Client
- Verify **Authorized JavaScript Origins** includes your domain:
  - `http://localhost`
  - `http://localhost:7357` (or your dev port)
  - `https://graviton-dev.firebaseapp.com`
  - `https://graviton-dev.web.app`
- Check browser console for detailed error messages

**Template variable still in HTML after injection**
- The injection script may have failed - check the terminal output
- Ensure the config file has the correct key name: `google.webClientId`
- Try running the injection script manually

**Hardcoded client ID in web/index.html after git pull**
- Run `dart run tools/restore_web_template.dart` to restore the template variable
- This can happen if someone committed without the pre-commit hook running

### Why Not Use Firebase Auth Directly?

While Firebase Auth has OAuth providers, the `google_sign_in` package provides:
- **Consistent API** across all platforms (mobile, desktop, web)
- **Better session management** with lightweight authentication
- **Access to Google APIs** beyond just authentication
- **Event-based flows** for better user experience

The 7.x API requires proper initialization and the web platform specifically requires the meta tag approach per Google Identity Services requirements.

### AWS Amplify / Firebase Hosting Deployment

For CI/CD deployments, add the injection step to your build configuration:

**AWS Amplify** (`amplify.yml`):
```yaml
frontend:
  phases:
    preBuild:
      commands:
        - flutter pub get
        - dart run tools/inject_web_config.dart config/prod-web.json
    build:
      commands:
        - flutter build web --release --dart-define-from-file=config/prod-web.json
```

**Firebase Hosting** (GitHub Actions `.github/workflows/deploy-web.yml`):
```yaml
- name: Inject Web Config
  run: dart run tools/inject_web_config.dart config/prod-web.json

- name: Build Web
  run: flutter build web --release --dart-define-from-file=config/prod-web.json
```

**Important**: Set the correct config file for each environment (dev vs prod branch).