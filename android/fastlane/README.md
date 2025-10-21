fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## Android

### android build_flutter

```sh
[bundle exec] fastlane android build_flutter
```

Build the Flutter app for Android

### android test

```sh
[bundle exec] fastlane android test
```

Runs all the tests

### android beta

```sh
[bundle exec] fastlane android beta
```

Submit a new Beta Build to Play Console Internal Testing

### android deploy

```sh
[bundle exec] fastlane android deploy
```

Deploy a new version to the Google Play Store

### android alpha

```sh
[bundle exec] fastlane android alpha
```

Deploy to alpha testing

### android build_apk

```sh
[bundle exec] fastlane android build_apk
```

Build release APK

### android build_aab

```sh
[bundle exec] fastlane android build_aab
```

Build release AAB

### android build_aab_dev

```sh
[bundle exec] fastlane android build_aab_dev
```

Build dev AAB

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
