# Firebase Configuration

This directory contains Firebase configuration files for the Graviton app.

## Files

- `firebase_options.dart` - Firebase configuration for dev and prod environments (gitignored)
- `firebase_options.dart.template` - Template with instructions for setting up Firebase
- `README.md` - This file

## Setup Instructions

### 1. Create firebase_options.dart

If you don't have `firebase_options.dart`, copy the template:

```bash
cp lib/firebase/firebase_options.dart.template lib/firebase/firebase_options.dart
```

### 2. Get Firebase Configuration

You need to configure both **dev** and **prod** Firebase projects.

#### Option A: Using Firebase Console (Recommended)

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project (graviton-dev or graviton-prod)
3. Click the gear icon ⚙️ > Project Settings
4. Scroll down to "Your apps" section
5. For each platform (Web, Android, iOS/macOS):
   - Click on the app (or add it if not exists)
   - Copy the configuration values:
     - `apiKey`
     - `appId`
     - `messagingSenderId`
     - `projectId`
     - `authDomain` (web only)
     - `storageBucket`
     - `iosBundleId` (iOS/macOS only)

#### Option B: Using FlutterFire CLI

Install the FlutterFire CLI:

```bash
dart pub global activate flutterfire_cli
```

Configure Firebase for dev environment:

```bash
flutterfire configure \
  --project=graviton-dev \
  --out=lib/firebase/firebase_options_dev.dart \
  --platforms=web,android,ios,macos
```

Configure Firebase for prod environment:

```bash
flutterfire configure \
  --project=graviton-prod \
  --out=lib/firebase/firebase_options_prod.dart \
  --platforms=web,android,ios,macos
```

Then manually merge the two files into `lib/firebase/firebase_options.dart` following the template structure.

### 3. Update Bundle IDs

Make sure the bundle IDs match your app configuration:

- **Dev iOS/macOS**: `io.chipper.graviton.dev`
- **Prod iOS/macOS**: `io.chipper.graviton`

### 4. Verify Configuration

Run the dev build to ensure Firebase initializes correctly:

```bash
flutter run -d macos --dart-define-from-file config/dev.json --flavor dev
```

Check the console for any Firebase initialization errors.

## Flavor Support

The app automatically selects the appropriate Firebase configuration based on the current flavor:

- **Dev builds** (`--flavor dev`): Uses `*Dev` Firebase options
- **Prod builds** (`--flavor prod`): Uses `*Prod` Firebase options

The flavor is determined by `FlavorConfig.instance.isDevelopment` at runtime.

## Firebase Projects

- **graviton-dev**: Development Firebase project
  - Used for testing and development
  - Bundle ID: `io.chipper.graviton.dev`
  
- **graviton-prod**: Production Firebase project
  - Used for production releases
  - Bundle ID: `io.chipper.graviton`
  - Service account: `keys/graviton-prod-b626b733702d.json`

## Security Notes

- `firebase_options.dart` is gitignored to protect API keys
- Firebase security rules should be configured to restrict access
- Production API keys should be restricted by:
  - iOS bundle ID / Android package name
  - Referrer URLs (for web)
  - IP addresses (if applicable)

## Troubleshooting

### Firebase not initialized

If you see "Firebase not initialized" errors:

1. Check that `firebase_options.dart` exists
2. Verify all placeholder values are replaced with real config
3. Ensure the flavor matches your build command

### Wrong Firebase project

If the wrong Firebase project is being used:

1. Check the current flavor: Look for `FlavorConfig.instance.flavor` logs
2. Verify dev/prod configurations are correct in `firebase_options.dart`
3. Make sure you're running with the correct `--flavor` flag

### Platform-specific issues

- **iOS/macOS**: Verify `iosBundleId` matches your app's bundle identifier
- **Android**: Check that package name matches Firebase app registration
- **Web**: Ensure `authDomain` is correctly configured

## Resources

- [Firebase Console](https://console.firebase.google.com/)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firebase iOS Setup](https://firebase.google.com/docs/ios/setup)
- [Firebase Android Setup](https://firebase.google.com/docs/android/setup)
- [Firebase Web Setup](https://firebase.google.com/docs/web/setup)
