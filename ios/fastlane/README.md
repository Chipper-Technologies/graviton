fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

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

### ios deploy

```sh
[bundle exec] fastlane ios deploy
```

Deploy a new version to the App Store

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

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
