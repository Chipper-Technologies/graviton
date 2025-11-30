# Firebase App Check Implementation Guide

## Overview

Firebase App Check protects your Firebase backend resources from abuse by verifying that incoming requests come from legitimate instances of your app. It works alongside Play Integrity API to provide comprehensive security.

**Key Differences:**
- **Play Integrity**: Device/app verification with detailed signals for custom business logic
- **App Check**: Backend protection with automatic enforcement by Firebase services

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     Graviton App                            │
├─────────────────────────────────────────────────────────────┤
│  App Check Service                                          │
│  ├─ Android: Play Integrity Provider                        │
│  ├─ iOS: DeviceCheck Provider                               │
│  ├─ Web: reCAPTCHA v3 Provider                              │
│  └─ Debug: Debug Token Provider                             │
├─────────────────────────────────────────────────────────────┤
│  Firebase Services (Protected by App Check)                 │
│  ├─ Cloud Firestore (user data, scenarios, leaderboards)    │
│  ├─ Cloud Functions (custom logic, webhooks)                │
│  ├─ Remote Config (feature flags, rollout)                  │
│  └─ Cloud Storage (user-generated content)                  │
└─────────────────────────────────────────────────────────────┘
```

## Platform-Specific Providers

### Android: Play Integrity API
- **Requirement**: Google Play Services
- **Configuration**: Automatic (uses existing Play Integrity setup)
- **Token Lifetime**: 1 hour (auto-refreshed)
- **Benefits**: Leverages Play Integrity verdicts for App Check

### iOS/macOS: DeviceCheck API
- **Requirement**: iOS 11+, macOS 10.15+
- **Configuration**: Automatic (no additional setup)
- **Token Lifetime**: 1 hour (auto-refreshed)
- **Benefits**: Apple's built-in device attestation

### Web: reCAPTCHA v3
- **Requirement**: reCAPTCHA v3 site key
- **Configuration**: Add site key to `AppCheckService.initialize()`
- **Token Lifetime**: 1 hour (auto-refreshed)
- **Benefits**: Bot detection without user interaction

### Debug: Debug Token Provider
- **Requirement**: Debug token from Firebase Console
- **Configuration**: Automatic in debug builds
- **Token Lifetime**: No expiration
- **Benefits**: Local testing without production attestation

## Setup Instructions

### 1. Add Dependencies

✅ **COMPLETED** - Already added to `pubspec.yaml`:
```yaml
dependencies:
  firebase_app_check: ^0.4.1+2
```

### 2. Enable App Check in Firebase Console

✅ **COMPLETED** - App Check has been configured for:
- ✅ Android (Play Integrity) - Dev & Prod
- ✅ iOS/macOS (DeviceCheck) - Dev & Prod
- ✅ Web (reCAPTCHA v3) - Dev & Prod

#### Step 1: Register App Check Providers ✅ COMPLETED

**For Android:** ✅
1. ~~Go to Firebase Console → App Check~~
2. ~~Select your Android app~~
3. ~~Click "Play Integrity" → Enable~~
4. ~~No additional configuration needed (uses Play Console integration)~~

**For iOS:** ✅
1. ~~Go to Firebase Console → App Check~~
2. ~~Select your iOS app~~
3. ~~Click "DeviceCheck" → Enable~~
4. ~~No additional configuration needed (automatic)~~

**For Web:** ✅
1. ~~Go to Firebase Console → App Check~~
2. ~~Select your web app~~
3. ~~Click "reCAPTCHA v3" → Enable~~
4. ~~Register site at https://www.google.com/recaptcha/admin~~
5. Add reCAPTCHA site key to configuration files:
   - `config/dev-web.json`: Add `"firebase.recaptchaSiteKey": "YOUR_DEV_RECAPTCHA_SITE_KEY"`
   - `config/prod-web.json`: Add `"firebase.recaptchaSiteKey": "YOUR_PROD_RECAPTCHA_SITE_KEY"`

#### Step 2: Enable Enforcement for Firebase Services

**Cloud Firestore:**
1. Firebase Console → App Check → APIs
2. Find "Cloud Firestore"
3. Click "Enforce"
4. Choose enforcement mode:
   - **Monitor**: Log unauthenticated requests (recommended for rollout)
   - **Enforce**: Block unauthenticated requests

**Cloud Functions:**
1. Firebase Console → App Check → APIs
2. Find "Cloud Functions"
3. Click "Enforce"
4. Apply to all functions or specific callable functions

**Remote Config:**
1. Firebase Console → App Check → APIs
2. Find "Remote Config"
3. Click "Enforce"
4. Note: Read-only by default, enforcement adds App Check requirement

**Cloud Storage:**
1. Firebase Console → App Check → APIs
2. Find "Cloud Storage"
3. Click "Enforce"
4. Update Security Rules to check App Check token

### 3. Configure Debug Tokens (Development)

Debug tokens allow testing without production attestation providers.

#### Get Debug Token:
1. Run app in debug mode
2. Check console logs for:
   ```
   AppCheckService: Get debug token from console:
   https://console.firebase.google.com/project/_/appcheck/apps
   ```
3. Copy the debug token from device logs
4. Go to Firebase Console → App Check → Apps
5. Select your app → Debug tokens
6. Click "Add debug token"
7. Paste token and save

#### Alternative: Set Debug Token Programmatically
```dart
// In AppCheckService.initialize() for kDebugMode:
await FirebaseAppCheck.instance.activate(
  androidProvider: AndroidProvider.debug,
  appleProvider: AppleProvider.debug,
);
```

### 4. Verify App Check is Working

#### Check Logs:
```
AppCheckService: Initializing in PRODUCTION mode
AppCheckService: Android Play Integrity activated
AppCheckService: Initialization complete
```

#### Monitor in Firebase Console:
1. Firebase Console → App Check → Metrics
2. View request counts, token generation, and errors
3. Check enforcement violations (if any)

## Integration with Existing Services

### Auth Service
App Check tokens are automatically included in Firebase Auth requests:
```dart
// No changes needed - Firebase Auth automatically uses App Check
await FirebaseAuth.instance.signInWithEmailAndPassword(
  email: email,
  password: password,
);
```

### Firestore Queries
App Check tokens are automatically included in Firestore requests:
```dart
// No changes needed - Firestore automatically uses App Check
await FirebaseFirestore.instance.collection('users').doc(uid).get();
```

### Remote Config
App Check tokens are automatically included in Remote Config fetches:
```dart
// No changes needed - Remote Config automatically uses App Check
await FirebaseRemoteConfig.instance.fetchAndActivate();
```

### Cloud Functions (Callable)
App Check tokens are automatically included in callable functions:
```dart
// No changes needed - Functions automatically use App Check
final callable = FirebaseFunctions.instance.httpsCallable('myFunction');
await callable.call({'param': 'value'});
```

### Custom Backend (Play Integrity Lambda)
For custom verification, get App Check token:
```dart
final appCheckToken = await AppCheckService.instance.getToken();
if (appCheckToken != null) {
  // Include in custom backend requests
  final response = await http.post(
    Uri.parse('https://your-backend.com/api'),
    headers: {
      'X-Firebase-AppCheck': appCheckToken,
    },
  );
}
```

## Remote Config Control

### Emergency Kill Switch

App Check can be dynamically enabled/disabled via Firebase Remote Config without requiring an app update. This provides an emergency rollback mechanism if issues arise in production.

**Parameter:** `app_check_enabled` (Boolean, default: `true`)

**Firebase Console Setup:**
1. Go to Firebase Console → Remote Config
2. Add parameter: `app_check_enabled`
3. Set value: `false` to disable, `true` to enable
4. Publish changes

**Behavior:**
- When `false`: App Check initialization is skipped entirely
- When `true`: App Check operates normally based on platform providers
- Default: `true` (enabled for security)

**Use Cases:**
- **Emergency Rollback**: Quickly disable if App Check causes production issues
- **Gradual Rollout**: Enable for percentage of users via Remote Config conditions
- **Regional Control**: Enable/disable based on user location
- **Maintenance**: Temporarily disable during backend maintenance

**Example:**
```dart
// AppCheckService automatically checks Remote Config on initialization
await AppCheckService.instance.initialize();
// If app_check_enabled is false, initialization is skipped
```

**Note**: Similar to Play Integrity's `integrity_enabled` parameter, this provides consistent security control patterns across the app.

## Rollout Strategy

### Phase 1: Monitoring (Week 1-2)
1. Enable App Check in "Monitor" mode for all services
2. Keep `app_check_enabled: true` in Remote Config
3. Monitor metrics in Firebase Console
4. Identify any legitimate traffic being flagged
5. Adjust debug tokens as needed

### Phase 2: Gradual Enforcement (Week 3-4)
1. Enable enforcement for Remote Config (low-risk)
2. Monitor for 1 week
3. Enable enforcement for Cloud Firestore reads
4. Monitor for 1 week
5. Keep `app_check_enabled: true` and monitor closely

### Phase 3: Full Enforcement (Week 5+)
1. Enable enforcement for Cloud Firestore writes
2. Enable enforcement for Cloud Functions
3. Enable enforcement for Cloud Storage
4. Monitor and respond to any issues
5. Use `app_check_enabled: false` as emergency rollback if needed

## Testing

### Unit Tests
```dart
test('AppCheckService initializes correctly', () async {
  final service = AppCheckService.instance;
  await service.initialize();
  expect(service.isInitialized, true);
});

test('AppCheckService can get token', () async {
  final service = AppCheckService.instance;
  await service.initialize();
  final token = await service.getToken();
  expect(token, isNotNull);
});
```

### Integration Tests
1. Run app in debug mode with debug token
2. Verify Firebase operations succeed
3. Remove debug token
4. Verify Firebase operations are blocked (if enforcement enabled)
5. Re-add debug token
6. Verify Firebase operations succeed again

## Troubleshooting

### App Check Token Errors

**Symptom**: `FirebaseAppCheckException: App Check token fetch failed`

**Causes**:
1. App Check not registered in Firebase Console
2. Wrong provider configuration
3. Debug token not registered (debug mode)
4. Play Integrity API not enabled (Android)
5. Network connectivity issues

**Solutions**:
1. Verify app is registered in Firebase Console → App Check
2. Check provider configuration matches platform
3. Register debug token for development
4. Enable Play Integrity API in Google Play Console
5. Check network connectivity

### App Check Disabled

**Symptom**: App Check not initializing, log shows "Disabled via Remote Config"

**Causes**:
1. `app_check_enabled` set to `false` in Firebase Remote Config
2. Remote Config not properly initialized

**Solutions**:
1. Check Firebase Console → Remote Config → `app_check_enabled` parameter
2. Set to `true` to re-enable App Check
3. Verify Remote Config service is initialized before App Check
4. Check Remote Config initialization logs

### Enforcement Violations

**Symptom**: Firebase operations return permission denied errors

**Causes**:
1. App Check enforcement enabled but tokens not working
2. Debug token not registered for development
3. App not properly configured in Firebase Console
4. App Check disabled via Remote Config (`app_check_enabled: false`)

**Solutions**:
1. Check App Check initialization logs
2. Register debug tokens for all development devices
3. Verify app configuration in Firebase Console
4. Verify `app_check_enabled: true` in Remote Config
5. Switch to "Monitor" mode temporarily to diagnose

### Play Integrity + App Check Conflicts

**Issue**: Both use Play Integrity on Android

**Solution**: They work together! App Check uses Play Integrity for attestation, while your custom Play Integrity integration provides detailed signals for business logic.

## Security Considerations

### Defense in Depth
- **App Check**: Protects Firebase backend from unauthorized clients
- **Play Integrity**: Provides device/app integrity signals for custom logic
- **Firebase Security Rules**: Enforces user-level access control
- **Backend Validation**: Additional custom verification

### Token Security
- App Check tokens are short-lived (1 hour)
- Tokens are automatically refreshed
- Tokens are stored securely by Firebase SDK
- Never log or expose tokens in production

### Monitoring
- Monitor App Check metrics in Firebase Console
- Set up alerts for sudden drops in token generation
- Track enforcement violations to identify attacks
- Review logs regularly for anomalies

## Cost Considerations

### App Check Pricing
- **Free Tier**: 10,000 verifications/day per app
- **Paid Tier**: $0.01 per 1,000 verifications after free tier
- **Estimate**: ~$3/month for 100K daily active users

### Play Integrity Pricing
- **Free**: Unlimited API calls
- **Cost**: Already included in Play Integrity implementation

### Combined Usage
- Both can run simultaneously
- App Check handles Firebase protection
- Play Integrity handles custom business logic
- Total cost: App Check fees only

## Maintenance

### Regular Tasks
1. **Weekly**: Review App Check metrics in Firebase Console
2. **Monthly**: Audit debug tokens and remove unused ones
3. **Quarterly**: Review enforcement configuration
4. **Annually**: Update dependencies and provider configuration

### Updates
- Monitor firebase_app_check package updates
- Test thoroughly before updating in production
- Review breaking changes in release notes
- Update documentation accordingly

## Resources

### Documentation
- [Firebase App Check Docs](https://firebase.google.com/docs/app-check)
- [Play Integrity API Docs](https://developer.android.com/google/play/integrity)
- [DeviceCheck Docs](https://developer.apple.com/documentation/devicecheck)
- [reCAPTCHA v3 Docs](https://developers.google.com/recaptcha/docs/v3)

### Firebase Console Links
- [App Check Dashboard](https://console.firebase.google.com/project/_/appcheck)
- [Play Integrity Setup](https://console.firebase.google.com/project/_/appcheck/apps)
- [Debug Tokens](https://console.firebase.google.com/project/_/appcheck/apps)
- [Enforcement Settings](https://console.firebase.google.com/project/_/appcheck/apis)

## Support

For issues or questions:
1. Check troubleshooting section above
2. Review Firebase Console logs and metrics
3. Check device logs for App Check errors
4. Contact Firebase Support for provider issues
5. File GitHub issue for app-specific problems
