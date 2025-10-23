fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Firebase Crashlytics Integration

This project includes Firebase Crashlytics for crash reporting. The Fastlane configuration automatically uploads dSYM files to Firebase Crashlytics during the build and deployment process to enable crash symbolication.

## Environment Configuration

The project supports two environments:
- **Dev**: Uses `ios/Config/Dev/GoogleService-Info.plist`
- **Prod**: Uses `ios/Config/Prod/GoogleService-Info.plist`

Most lanes accept a `flavor` parameter to specify which environment to use.

# Available Actions

## iOS

### ios build_flutter

```sh
[bundle exec] fastlane ios build_flutter
```

Build Flutter iOS app

### ios test

```sh
[bundle exec] fastlane ios test
```

Runs all the tests

### ios beta

```sh
[bundle exec] fastlane ios beta
```

Submit a new Beta Build to TestFlight

This lane now automatically uploads dSYMs to Firebase Crashlytics for crash symbolication.

Options:
- `flavor`: Specify the environment (dev/prod). Defaults to "dev"

Examples:
```sh
# Submit beta build for dev environment (default)
[bundle exec] fastlane ios beta

# Submit beta build for production environment
[bundle exec] fastlane ios beta flavor:prod
```

### ios deploy

```sh
[bundle exec] fastlane ios deploy
```

Deploy a new version to the App Store

This lane now automatically uploads dSYMs to Firebase Crashlytics for crash symbolication.

Options:
- `flavor`: Specify the environment (dev/prod). Defaults to "prod"

Examples:
```sh
# Deploy to App Store for production environment (default)
[bundle exec] fastlane ios deploy

# Deploy to App Store for dev environment
[bundle exec] fastlane ios deploy flavor:dev
```

### ios screenshots

```sh
[bundle exec] fastlane ios screenshots
```

Generate and download new screenshots

### ios metadata

```sh
[bundle exec] fastlane ios metadata
```

Update app metadata on App Store Connect

### ios certificates

```sh
[bundle exec] fastlane ios certificates
```

Sync certificates and profiles

### ios upload_dsyms

```sh
[bundle exec] fastlane ios upload_dsyms
```

Upload dSYMs to Firebase Crashlytics

Options:
- `flavor`: Specify the environment (dev/prod). Defaults to "dev"

Examples:
```sh
# Upload dSYMs for dev environment (default)
[bundle exec] fastlane ios upload_dsyms

# Upload dSYMs for production environment
[bundle exec] fastlane ios upload_dsyms flavor:prod
```

### ios build_and_upload_dsyms

```sh
[bundle exec] fastlane ios build_and_upload_dsyms
```

Build and upload dSYMs to Crashlytics

Options:
- `flavor`: Specify the environment (dev/prod). Defaults to "dev"

Examples:
```sh
# Build app and upload dSYMs for dev environment
[bundle exec] fastlane ios build_and_upload_dsyms flavor:dev

# Build app and upload dSYMs for production environment
[bundle exec] fastlane ios build_and_upload_dsyms flavor:prod
```

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
