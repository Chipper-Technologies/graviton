import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/services/firebase/live_session_service.dart';

// Generate mocks for testing
@GenerateMocks([
  // Localization
  AppLocalizations,

  // Firebase Auth
  User,
  UserInfo,
  UserMetadata,
  FirebaseAuth,
  UserCredential,

  // Firebase Realtime Database
  FirebaseDatabase,
  DatabaseReference,
  DataSnapshot,
  DatabaseEvent,

  // Live Session
  LiveSessionService,

  // Google Sign In
  GoogleSignIn,
  GoogleSignInAccount,
  GoogleSignInAuthentication,

  // Storage
  SharedPreferences,
])
void main() {}
