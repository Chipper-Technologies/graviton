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