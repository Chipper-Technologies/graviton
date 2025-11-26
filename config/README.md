# Configuration Directory

This directory contains platform and environment-specific configuration files for the Graviton app.

## File Structure

Configuration files follow the naming convention: `{env}-{platform}.json`

Where:
- `{env}` is either `dev` or `prod`
- `{platform}` is one of `web`, `android`, `ios`, `macos`

### Configuration Files

- `dev-web.json` - Web development configuration
- `prod-web.json` - Web production configuration
- `dev-android.json` - Android development configuration
- `prod-android.json` - Android production configuration
- `dev-ios.json` - iOS development configuration
- `prod-ios.json` - iOS production configuration
- `dev-macos.json` - macOS development configuration
- `prod-macos.json` - macOS production configuration

## Configuration Format

Each configuration file contains environment settings, URLs, assets, and Firebase configuration:

```json
{
  "environment": "dev",
  "urls": {
    "github": "https://github.com/Chipper-Technologies/graviton",
    "website": "https://chippertechnology.com",
    "privacyPolicy": "https://chippertechnology.com/privacy-policy/graviton",
    "termsOfService": "https://chippertechnology.com/terms-of-service/graviton",
    "companyWebsite": "https://chippertechnology.com"
  },
  "assets": {
    "appLogo": "assets/images/app-logo.png",
    "chipperLogo": "assets/images/chipper-logo.svg",
    "gravitonLogo": "assets/images/graviton-logo.svg"
  },
  "firebase": {
    "apiKey": "AIzaSy...",
    "appId": "1:123456789:platform:abc123...",
    "messagingSenderId": "123456789",
    "projectId": "graviton-dev",
    "authDomain": "graviton-dev.firebaseapp.com",
    "storageBucket": "graviton-dev.firebasestorage.app",
    "measurementId": "G-XXXXXXXXXX",
    "iosBundleId": "io.chipper.graviton.dev"
  }
}
```

### Top-Level Fields

- `environment` - Environment identifier (`"dev"` or `"prod"`)
- `urls` - Application URLs (GitHub, website, privacy policy, terms of service)
- `assets` - Asset paths for app resources
- `firebase` - Nested Firebase configuration object

### Firebase Fields (All Platforms)

- `apiKey` - Firebase API key
- `appId` - Firebase app ID
- `messagingSenderId` - Firebase Cloud Messaging sender ID
- `projectId` - Firebase project ID
- `storageBucket` - Firebase Storage bucket URL

### Firebase Platform-Specific Fields

- `authDomain` - (Web only) Firebase Auth domain
- `measurementId` - (Web only) Google Analytics measurement ID
- `iosBundleId` - (iOS/macOS only) Bundle identifier

## Usage

Configuration files are loaded at compile time using `--dart-define-from-file`:

### Development Builds

```bash
# macOS development
flutter run -d macos --dart-define-from-file config/dev-macos.json --flavor dev

# Web development
flutter run -d chrome --dart-define-from-file config/dev-web.json

# Android development
flutter run --dart-define-from-file config/dev-android.json --flavor dev
```

### Production Builds

```bash
# Web production
flutter build web --dart-define-from-file config/prod-web.json --release

# Android production
flutter build apk --dart-define-from-file config/prod-android.json --flavor prod --release

# iOS production
flutter build ipa --dart-define-from-file config/prod-ios.json --flavor prod --release
```

### Accessing Configuration in Code

The `--dart-define-from-file` flag makes nested JSON values available as compile-time constants using dot notation:

```dart
// Access environment
const environment = String.fromEnvironment('environment');

// Access URLs
const githubUrl = String.fromEnvironment('urls.github');

// Access Firebase config
const apiKey = String.fromEnvironment('firebase.apiKey');
const projectId = String.fromEnvironment('firebase.projectId');
```

## CI/CD Integration

For CI/CD pipelines, store configuration files as secrets and create them during the build process.

### GitHub Actions

```yaml
- name: Create Configuration File
  run: echo '${{ secrets.PROD_WEB_CONFIG }}' > config/prod-web.json

- name: Build Web App
  run: flutter build web --dart-define-from-file config/prod-web.json --release
```

### AWS Amplify

Store configs in AWS Secrets Manager:

```yaml
preBuild:
  commands:
    - aws secretsmanager get-secret-value --secret-id graviton-prod-web \
        --query SecretString --output text > config/prod-web.json
build:
  commands:
    - flutter build web --dart-define-from-file config/prod-web.json --release
```

## Getting Firebase Configuration

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project (graviton-dev or graviton-prod)
3. Click the gear icon ⚙️ > Project Settings
4. Scroll down to "Your apps" section
5. For each platform:
   - Click on the app (or add it if it doesn't exist)
   - Copy the configuration values
   - Add them to the `firebase` object in the corresponding JSON file

## Security

**Important**: These configuration files contain sensitive credentials and should be:

1. **Added to `.gitignore`** (already ignored via `config/dev-*.json` and `config/prod-*.json` patterns)
2. **Stored securely** in your CI/CD secrets manager
3. **Never committed** to version control
4. **Rotated regularly** if compromised

Only this `README.md` is committed to version control. All `{env}-{platform}.json` files are gitignored.

## Firebase Projects

- **graviton-dev**: Development Firebase project
  - Used for testing and development
  - Bundle ID: `io.chipper.graviton.dev`
  
- **graviton-prod**: Production Firebase project
  - Used for production releases
  - Bundle ID: `io.chipper.graviton`
