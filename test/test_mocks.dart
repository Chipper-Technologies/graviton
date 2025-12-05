import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:graviton/l10n/app_localizations.dart';

// Generate mocks for testing
@GenerateMocks([
  AppLocalizations,
  User,
  UserInfo,
  UserMetadata,
  FirebaseAuth,
  UserCredential,
  GoogleSignIn,
  GoogleSignInAccount,
  GoogleSignInAuthentication,
  SharedPreferences,
])
void main() {}
