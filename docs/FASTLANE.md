# 🚀 Fastlane Setup & Security Guide for Graviton

This comprehensive guide covers Fastlane automation setup, security best practices, and deployment processes for both Android and iOS platforms.

## � Table of Contents

- [�🔒 Security First](#-security-first)
- [Prerequisites](#prerequisites)
- [🛡️ Security Setup](#️-security-setup)
- [Android Configuration](#android-configuration)
- [iOS Configuration](#ios-configuration)
- [🔥 Firebase Crashlytics Integration](#-firebase-crashlytics-integration)
- [Getting Started](#getting-started)
- [Available Commands](#available-commands)
- [🔑 Credential Management](#-credential-management)
- [Troubleshooting](#troubleshooting)

## 🔒 Security First

**⚠️ CRITICAL**: Never commit sensitive credentials to version control!

### 🚨 Never Commit These Files:
- `android/fastlane/Appfile`
- `ios/fastlane/Appfile`  
- Any files in `keys/` directory
- Service account JSON files
- Apple API key `.p8` files

### What's Protected:
- Google Play Console service account credentials
- App Store Connect API keys
- Package names and app identifiers
- File paths that could expose system structure

## Prerequisites

1. **Flutter**: Make sure Flutter is installed and configured
2. **Fastlane**: Already installed via Homebrew
3. **Android Studio**: For Android development
4. **Xcode**: For iOS development (macOS only)
5. **Apple Developer Account**: For iOS distribution
6. **Google Play Console Account**: For Android distribution

## 🛡️ Security Setup

### Initial Security Setup:
1. **Copy templates to create Appfiles:**
   ```bash
   cp android/fastlane/Appfile.template android/fastlane/Appfile
   cp ios/fastlane/Appfile.template ios/fastlane/Appfile
   ```

2. **Verify security setup:**
   - ✅ Ensure Appfiles are gitignored (check `.gitignore`)
   - ✅ Verify key files are gitignored 
   - ✅ Confirm templates are available
   - ✅ Check directory structure is correct

## Android Configuration

### Configuration Files
- `android/fastlane/Appfile.template`: Template for package name and service account configuration
- `android/fastlane/Appfile`: **Your local config** (not in version control)
- `android/fastlane/Fastfile`: Contains lane definitions for build and deployment
- `android/Gemfile`: Ruby dependencies

### Service Account Setup
1. Go to Google Cloud Console
2. Create a service account for the Google Play Console
3. Download the JSON key file
4. Place it in `keys/graviton-prod-[hash].json`

### Configure Android Appfile:
Edit your local `android/fastlane/Appfile`:
```ruby
json_key_file("../keys/your-service-account-key.json")
package_name("io.chipper.graviton")
```

## iOS Configuration

```bash
cd android

# Build Flutter app and create AAB
fastlane build_aab

# Build Flutter app and create APK
fastlane build_apk

# Run tests
fastlane test

# Deploy to internal testing
fastlane beta

# Deploy to alpha testing
fastlane alpha

# Deploy to production (creates draft)
fastlane deploy
```

### Configuration Files
- `ios/fastlane/Appfile.template`: Template for bundle identifier and Apple ID configuration
- `ios/fastlane/Appfile`: **Your local config** (not in version control)
- `ios/fastlane/Fastfile`: Contains lane definitions for build and deployment
- `ios/Gemfile`: Ruby dependencies

### Apple Developer Setup
1. Update your local `ios/fastlane/Appfile`:
   ```ruby
   app_identifier("io.chipper.graviton")
   apple_id("your.apple.id@email.com")
   
   # For App Store Connect API (recommended):
   for_platform :ios do
     api_key_path("../keys/AuthKey_YOUR_KEY_ID.p8")
     api_key_id("YOUR_KEY_ID") 
     api_key_issuer_id("your-issuer-id")
   end
   ```

2. Set up certificates and provisioning profiles using Match (recommended) or manual setup

## 🔥 Firebase Crashlytics Integration

The project includes Firebase Crashlytics for crash reporting and analytics. The Fastlane configuration automatically handles dSYM uploads to Firebase Crashlytics for crash symbolication.

### Environment Configuration

The project supports two Firebase environments:

- **Development (`dev`)**: Uses `ios/Config/Dev/GoogleService-Info.plist`
- **Production (`prod`)**: Uses `ios/Config/Prod/GoogleService-Info.plist`

### Automatic dSYM Upload

The `beta` and `deploy` lanes automatically upload dSYM files to Firebase Crashlytics:

- **`fastlane beta`**: Uploads to dev environment by default
- **`fastlane deploy`**: Uploads to prod environment by default
- Both support the `flavor` parameter to override the environment

### Manual dSYM Upload

For manual dSYM uploads or troubleshooting:

```bash
# Upload dSYMs for development environment
fastlane upload_dsyms

# Upload dSYMs for production environment  
fastlane upload_dsyms flavor:prod

# Build app and upload dSYMs in one command
fastlane build_and_upload_dsyms flavor:dev
```

### Requirements

1. **Firebase Project Setup**: Ensure Firebase is properly configured in your project
2. **GoogleService-Info.plist**: Both dev and prod configurations must be present
3. **Firebase Crashlytics SDK**: Already included in the Flutter dependencies
4. **Upload Symbols Script**: Located at `./Pods/FirebaseCrashlytics/upload-symbols`

### Troubleshooting dSYM Upload

If dSYM upload fails:

1. **Check Firebase Configuration**:
   ```bash
   # Verify GoogleService-Info.plist exists
   ls ios/Config/Dev/GoogleService-Info.plist
   ls ios/Config/Prod/GoogleService-Info.plist
   ```

2. **Verify dSYM Generation**: Ensure your build generates dSYM files
3. **Check Upload Script**: Verify the Firebase upload script exists after pod install
4. **Manual Upload**: Use the Firebase console if automated upload fails

## Getting Started

### First Time Setup

1. **Security First:**
   ```bash
   # Copy templates
   cp android/fastlane/Appfile.template android/fastlane/Appfile
   cp ios/fastlane/Appfile.template ios/fastlane/Appfile
   ```

2. **For Android:**
   ```bash
   cd android
   bundle install
   # Edit Appfile with your service account key path
   fastlane test  # Verify setup
   ```

3. **For iOS:**
   ```bash
   cd ios
   bundle install
   # Edit Appfile with your Apple ID and API key details
   fastlane certificates  # Set up certificates
   fastlane test  # Verify setup
   ```

## Available Commands

### Android Lanes

```bash
cd android

# Build Flutter app and create AAB
fastlane build_aab

# Build Flutter app and create APK
fastlane build_apk

# Run tests
fastlane test

# Deploy to internal testing
fastlane beta

# Deploy to alpha testing
fastlane alpha

# Deploy to production (creates draft)
fastlane deploy
```

### iOS Lanes

```bash
cd ios

# Build Flutter app for iOS
fastlane build_flutter

# Run tests
fastlane test

# Deploy to TestFlight (includes automatic dSYM upload to Crashlytics)
fastlane beta                          # Uses dev flavor by default
fastlane beta flavor:prod             # Use production environment

# Deploy to App Store (includes automatic dSYM upload to Crashlytics)
fastlane deploy                        # Uses prod flavor by default
fastlane deploy flavor:dev            # Use development environment

# Firebase Crashlytics dSYM upload
fastlane upload_dsyms                  # Upload dSYMs for dev environment
fastlane upload_dsyms flavor:prod     # Upload dSYMs for production environment
fastlane build_and_upload_dsyms       # Build app and upload dSYMs for dev
fastlane build_and_upload_dsyms flavor:prod  # Build app and upload dSYMs for prod

# Take screenshots
fastlane screenshots

# Upload metadata only
fastlane metadata

# Sync certificates and provisioning profiles
fastlane certificates
```

### Building and Testing

1. **Build both platforms:**
   ```bash
   # Android AAB
   cd android && fastlane build_aab
   
   # iOS
   cd ios && fastlane build_flutter
   ```

2. **Run tests:**
   ```bash
   # Android
   cd android && fastlane test
   
   # iOS
   cd ios && fastlane test
   ```

### Beta Distribution

1. **Android Internal Testing:**
   ```bash
   cd android && fastlane beta
   ```

2. **iOS TestFlight:**
   ```bash
   cd ios && fastlane beta
   ```

### Production Deployment

1. **Android Play Store:**
   ```bash
   cd android && fastlane deploy
   ```

2. **iOS App Store:**
   ```bash
   cd ios && fastlane deploy
   ```

## 🔑 Credential Management

### Google Play Console:
- **Service Account Key**: Store in `keys/graviton-prod-[hash].json`
- **Permissions**: Ensure service account has proper Google Play Console access
- **Path Configuration**: Reference in `android/fastlane/Appfile`

### App Store Connect:
- **API Key**: Store in `keys/AuthKey_[KEY_ID].p8`
- **Key ID**: 10-character identifier (e.g., `YJXLZSZ968`)
- **Issuer ID**: UUID format (e.g., `b178bb0e-00b4-430a-8e52-a966fcf1d329`)
- **Configuration**: Reference in `ios/fastlane/Appfile`

### Environment Variables (CI/CD)

For automated environments, use environment variables:

```bash
# .env file (add to .gitignore)
FASTLANE_GOOGLE_SERVICE_ACCOUNT_KEY_PATH="path/to/key.json"
FASTLANE_APPLE_API_KEY_PATH="path/to/AuthKey.p8"
APPLE_ID="your-apple-id@example.com"
FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD="xxxx-xxxx-xxxx-xxxx"
MATCH_PASSWORD="your-match-password"
```

## ⚠️ Security Incident Response

### If Credentials Are Exposed

#### If Appfiles were committed:
1. **Remove from git history:**
   ```bash
   git filter-branch --index-filter 'git rm --cached --ignore-unmatch android/fastlane/Appfile ios/fastlane/Appfile' HEAD
   ```
2. **Force push** (if safe to do so)
3. **Rotate all credentials** mentioned in the files

#### If keys were committed:
1. **Immediately revoke** the compromised credentials
2. **Generate new service accounts/API keys**
3. **Remove from git history** using tools like BFG Repo-Cleaner
4. **Update all team members**

### Best Practices

1. **Development workflow**:
   - Always use templates for new team members
   - Verify `.gitignore` is working before committing
   - Manually verify security setup periodically

2. **Regular security audits**:
   - Check git history for accidentally committed secrets
   - Rotate credentials periodically
   - Review team access permissions

## Troubleshooting

### Common Issues

1. **"Command not found: fastlane"**
   - Make sure Fastlane is installed: `brew install fastlane`
   - Or use: `bundle exec fastlane`

2. **iOS code signing issues**
   - Use `fastlane match` for automatic certificate management
   - Or manually manage certificates in Xcode

3. **Android signing issues**
   - Ensure `upload-keystore.jks` exists
   - Check `key.properties` configuration

4. **Flutter build issues**
   - Run `flutter clean && flutter pub get`
   - Check Flutter doctor: `flutter doctor`

### Security Troubleshooting

#### "Appfile not found" errors:
- Ensure you've copied from templates
- Check file paths are correct
- Verify you're in the right directory

#### Authentication failures:
- Verify key files exist and have correct permissions
- Check API key IDs and issuer IDs are accurate
- Ensure service account has proper permissions

#### Git ignoring issues:
- Run `git check-ignore filename` to test
- Clear git cache: `git rm --cached filename`
- Verify `.gitignore` patterns are correct

### Additional Resources

- [Fastlane Documentation](https://docs.fastlane.tools/)
- [Flutter Deployment Guide](https://docs.flutter.dev/deployment)
- [Google Play Console Help](https://support.google.com/googleplay/android-developer)
- [App Store Connect Help](https://developer.apple.com/help/app-store-connect/)

---

**Remember**: Security is everyone's responsibility. When in doubt, don't commit sensitive files!

- Never commit service account JSON files to version control
- Use environment variables for sensitive information
- Consider using Fastlane Match for iOS certificate management
- Regularly rotate API keys and passwords