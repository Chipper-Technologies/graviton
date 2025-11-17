# Quick Start Guide: Running Graviton on macOS

## Prerequisites
✅ Flutter SDK installed and configured  
✅ Xcode installed (for macOS development)  
✅ macOS support enabled (already done)

## Running the App

### Option 1: VS Code Tasks (Easiest)
1. Open Command Palette: `Cmd + Shift + P`
2. Type: "Tasks: Run Task"
3. Select:
   - **🖥️ Run macOS (Dev)** - for development version
   - **🖥️ Run macOS (Prod)** - for production version

### Option 2: Terminal Commands

#### Development Version
```bash
flutter run -d macos --dart-define-from-file config/dev.json
```

#### Production Version
```bash
flutter run -d macos --dart-define-from-file config/prod.json
```

### Option 3: VS Code Debug/Run
1. Select "macOS (desktop)" from the device selector
2. Press F5 or click the Run button
3. The app will run with the default (debug) configuration

## Building for Distribution

### Development Build
```bash
flutter build macos --dart-define-from-file config/dev.json --release
```
Output: `build/macos/Build/Products/Release/graviton.app`

### Production Build
```bash
flutter build macos --dart-define-from-file config/prod.json --release
```
Output: `build/macos/Build/Products/Release/graviton.app`

## Differences Between Dev and Prod

| Aspect | Development | Production |
|--------|-------------|------------|
| App Name | Graviton Dev | Graviton |
| Bundle ID | io.chipper.graviton.dev | io.chipper.graviton |
| Firebase Config | Config/Dev/GoogleService-Info.plist | Config/Prod/GoogleService-Info.plist |
| Environment | dev (from config/dev.json) | prod (from config/prod.json) |

## Complete Xcode Configuration (Optional)

For full dev/prod support with different Xcode schemes:

```bash
cd macos
./configure_xcode.sh
```

Follow the on-screen instructions to:
1. Create additional build configurations
2. Set up custom schemes
3. Link configuration files

See `macos/README.md` for detailed instructions.

## Troubleshooting

### "No devices found"
```bash
# Check if macOS is enabled
flutter config --enable-macos-desktop

# Verify devices
flutter devices
```

### Build Errors
```bash
# Clean and rebuild
flutter clean
flutter pub get
cd macos
rm -rf Pods/ Podfile.lock
cd ..
flutter run -d macos --dart-define-from-file config/dev.json
```

### Firebase Not Working
1. Verify GoogleService-Info.plist exists in:
   - `macos/Config/Dev/GoogleService-Info.plist`
   - `macos/Config/Prod/GoogleService-Info.plist`
2. Make sure your Firebase project includes a macOS app
3. Download the correct GoogleService-Info.plist from Firebase Console if needed

## Next Steps

1. ✅ Run the app: `flutter run -d macos --dart-define-from-file config/dev.json`
2. ⚙️ Configure Xcode (optional): `cd macos && ./configure_xcode.sh`
3. 🧪 Test both dev and prod configurations
4. 🔥 Update Firebase settings if needed
5. 📦 Build and test the release version

## Resources

- **Detailed Setup**: `macos/SETUP_SUMMARY.md`
- **Configuration Guide**: `macos/README.md`
- **Flutter macOS docs**: https://docs.flutter.dev/platform-integration/macos/building

---

**Ready to run!** 🎉

Try it now:
```bash
flutter run -d macos --dart-define-from-file config/dev.json
```
