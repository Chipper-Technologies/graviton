# macOS Configuration Setup

This Flutter app now supports macOS with development and production configurations similar to iOS and Android.

## Configuration Structure

### Configurations
The macOS target supports the following build configurations:
- **Debug**: Standard debug build (default bundle ID: `io.chipper.graviton`)
- **Debug-Dev**: Development debug build (bundle ID: `io.chipper.graviton.dev`)
- **Release-Dev**: Development release build (bundle ID: `io.chipper.graviton.dev`)
- **Release-Prod**: Production release build (bundle ID: `io.chipper.graviton`)
- **Profile**: Profile mode for performance testing

### Config Files
Configuration files are located in `macos/Runner/Configs/`:
- `Debug.xcconfig`: Standard debug configuration
- `Debug-Dev.xcconfig`: Development debug configuration
- `Release-Dev.xcconfig`: Development release configuration
- `Release-Prod.xcconfig`: Production release configuration
- `AppInfo.xcconfig`: Base app information
- `AppInfo-Dev.xcconfig`: Development-specific app information
- `AppInfo-Prod.xcconfig`: Production-specific app information
- `Warnings.xcconfig`: Compiler warnings configuration

### Firebase Configuration
Firebase GoogleService-Info.plist files are stored in:
- `macos/Config/Dev/GoogleService-Info.plist` (Development)
- `macos/Config/Prod/GoogleService-Info.plist` (Production)

## Running the App

### Using Flutter Commands

#### Development
```bash
flutter run -d macos --dart-define-from-file config/dev.json
```

#### Production
```bash
flutter run -d macos --dart-define-from-file config/prod.json
```

### Using VS Code Tasks
The following tasks are available in VS Code:
- **🖥️ Run macOS (Dev)**: Run the app on macOS with dev configuration
- **🖥️ Run macOS (Prod)**: Run the app on macOS with prod configuration
- **🖥️ Build macOS (Dev)**: Build macOS app for development
- **🖥️ Build macOS (Prod)**: Build macOS app for production

## Building for Release

### Development Build
```bash
flutter build macos --dart-define-from-file config/dev.json --release
```

### Production Build
```bash
flutter build macos --dart-define-from-file config/prod.json --release
```

## Additional Configuration Steps

### To fully enable dev/prod configurations in Xcode:

1. Open the Xcode project:
   ```bash
   open macos/Runner.xcodeproj
   ```

2. Select the **Runner** project in the Project Navigator

3. In the **Info** tab under **Configurations**:
   - Duplicate the Debug configuration and name it **Debug-Dev**
   - Duplicate the Release configuration and name it **Release-Dev**
   - Duplicate the Release configuration and name it **Release-Prod**

4. For each configuration, update the **Based on configuration file**:
   - Debug-Dev: `Runner/Configs/Debug-Dev.xcconfig`
   - Release-Dev: `Runner/Configs/Release-Dev.xcconfig`
   - Release-Prod: `Runner/Configs/Release-Prod.xcconfig`

5. Update **Run Script** phases to use the appropriate GoogleService-Info.plist:
   - Add a build phase to copy the correct GoogleService-Info.plist based on configuration
   
6. Create build schemes:
   - Create a scheme named "Runner Dev" using Debug-Dev and Release-Dev
   - Create a scheme named "Runner Prod" using Debug and Release-Prod

## Bundle Identifiers

- **Development**: `io.chipper.graviton.dev`
- **Production**: `io.chipper.graviton`

## App Names

- **Development**: "Graviton Dev"
- **Production**: "Graviton"

## Troubleshooting

### Firebase Not Working
Make sure the correct GoogleService-Info.plist is being copied to the app bundle during build.

### Wrong Bundle Identifier
Verify that the correct .xcconfig file is being used for your build configuration.

### Build Errors
Try cleaning the build:
```bash
flutter clean
flutter pub get
flutter build macos --dart-define-from-file config/dev.json
```
