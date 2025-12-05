// Firebase configuration loaded from platform-specific JSON files via --dart-define-from-file
// Configuration files: config/{env}-{platform}.json
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Configuration is loaded from JSON files in config/ directory via --dart-define-from-file:
/// - config/dev-web.json / config/prod-web.json
/// - config/dev-android.json / config/prod-android.json
/// - config/dev-ios.json / config/prod-ios.json
/// - config/dev-macos.json / config/prod-macos.json
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static const FirebaseOptions currentPlatform = FirebaseOptions(
    apiKey: String.fromEnvironment('firebase.apiKey'),
    appId: String.fromEnvironment('firebase.appId'),
    messagingSenderId: String.fromEnvironment('firebase.messagingSenderId'),
    projectId: String.fromEnvironment('firebase.projectId'),
    authDomain: String.fromEnvironment('firebase.authDomain'),
    storageBucket: String.fromEnvironment('firebase.storageBucket'),
    measurementId: String.fromEnvironment('firebase.measurementId'),
    iosBundleId: String.fromEnvironment('firebase.iosBundleId'),
  );
}
