# Firebase Configuration

This directory contains Firebase configuration for the Graviton app.

## Files

- `firebase_options.dart` - Firebase configuration loader that reads from `--dart-define-from-file`
- `README.md` - This file

## Configuration Files

Firebase configurations are stored as JSON files in the `config/` directory:

```
config/{env}-{platform}.json
```

Where:
- `{env}` is either: `dev` or `prod`
- `{platform}` is one of: `web`, `android`, `ios`, `macos`

### Available Config Files

- `config/dev-web.json` - Web development
- `config/prod-web.json` - Web production
- `config/dev-android.json` - Android development
- `config/prod-android.json` - Android production
- `config/dev-ios.json` - iOS development
- `config/prod-ios.json` - iOS production
- `config/dev-macos.json` - macOS development
- `config/prod-macos.json` - macOS production

### JSON Format

Each configuration file contains environment properties, URLs, assets, and a nested Firebase object:

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
    "apiKey": "your-api-key",
    "appId": "your-app-id",
    "messagingSenderId": "your-sender-id",
    "projectId": "your-project-id",
    "authDomain": "your-domain.firebaseapp.com",
    "storageBucket": "your-bucket.firebasestorage.app",
    "measurementId": "your-measurement-id",
    "iosBundleId": "io.chipper.graviton.dev"
  }
}
```

## Setup Instructions

### 1. Update Configuration Files

Edit the appropriate JSON files in `config/` directory with your Firebase credentials.

#### Getting Firebase Configuration

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project (graviton-dev or graviton-prod)
3. Click the gear icon ⚙️ > Project Settings
4. Scroll down to "Your apps" section
5. For each platform (Web, Android, iOS/macOS):
   - Click on the app (or add it if not exists)
   - Copy the configuration values into the `firebase` object in the corresponding JSON file

### 2. Build with Configuration

The configuration is loaded at compile time via `--dart-define-from-file`:

```bash
# Development - macOS
flutter run -d macos --dart-define-from-file config/dev-macos.json --flavor dev

# Development - Web
flutter run -d chrome --dart-define-from-file config/dev-web.json

# Production - Android APK
flutter build apk --dart-define-from-file config/prod-android.json --flavor prod --release

# Production - Web
flutter build web --dart-define-from-file config/prod-web.json --release
```

The `--dart-define-from-file` flag loads the JSON and makes nested values available as compile-time constants. For example, `firebase.apiKey` reads the `apiKey` from the `firebase` object.

### 3. CI/CD Integration

For CI/CD pipelines, store the config JSON files as secrets:

#### GitHub Actions

```yaml
- name: Create Firebase Config
  run: echo '${{ secrets.PROD_WEB_CONFIG }}' > config/prod-web.json

- name: Build
  run: flutter build web --dart-define-from-file config/prod-web.json --release
```

#### AWS Amplify

Store configs in AWS Secrets Manager and retrieve in `amplify.yml`:

```yaml
preBuild:
  commands:
    - aws secretsmanager get-secret-value --secret-id firebase-prod-web \
        --query SecretString --output text > config/prod-web.json
build:
  commands:
    - flutter build web --dart-define-from-file config/prod-web.json --release
```

## Firebase Projects

- **graviton-dev**: Development Firebase project
  - Used for testing and development
  - Bundle ID: `io.chipper.graviton.dev`
  
- **graviton-prod**: Production Firebase project
  - Used for production releases
  - Bundle ID: `io.chipper.graviton`
  - Service account: `keys/graviton-prod-b626b733702d.json`

## Security Notes

- Config files in `config/dev-*.json` and `config/prod-*.json` are gitignored
- Only `config/README.md` is committed to version control
- Firebase security rules should be configured to restrict access
- Production API keys should be restricted by:
  - iOS bundle ID / Android package name
  - Referrer URLs (for web)
  - IP addresses (if applicable)
- **Never commit** Firebase config files to version control
- Use secure secret storage for CI/CD

## Troubleshooting

### Firebase not initialized

If you see "Firebase not initialized" errors:

1. Check that the config file exists (e.g., `config/dev-macos.json`)
2. Verify you're using `--dart-define-from-file` with the correct path
3. Ensure all required Firebase fields are present in the JSON

### Wrong Firebase project

If the wrong Firebase project is being used:

1. Verify you're passing the correct config file (dev vs prod, correct platform)
2. Check the `projectId` in the config file
3. Make sure you're using the correct `--flavor` flag with the matching config

### Platform-specific issues

- **iOS/macOS**: Verify `iosBundleId` in the config matches your app's bundle identifier
- **Android**: Check that package name matches Firebase app registration
- **Web**: Ensure `authDomain` and `measurementId` are correctly configured

## Resources

- [Firebase Console](https://console.firebase.google.com/)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Flutter --dart-define-from-file](https://docs.flutter.dev/deployment/flavors#using---dart-define-from-file)
