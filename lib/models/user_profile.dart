import 'package:graviton/enums/auth_provider_type.dart';
import 'package:graviton/enums/user_avatar.dart';

/// User profile data model
///
/// Represents a user's profile information including authentication
/// details, avatar selection, and account metadata.
class UserProfile {
  /// Unique user identifier from Firebase Auth
  final String uid;

  /// User's email address (may be null for anonymous users)
  final String? email;

  /// User's display name (may be null)
  final String? displayName;

  /// URL to user's profile photo (from social auth providers)
  final String? photoUrl;

  /// Selected avatar (predefined cosmic theme)
  final UserAvatar? avatar;

  /// Whether the user is anonymous (guest)
  final bool isAnonymous;

  /// Primary authentication provider
  final AuthProviderType? authProvider;

  /// Timestamp when account was created
  final DateTime? createdAt;

  /// Timestamp of last sign-in
  final DateTime? lastSignInAt;

  const UserProfile({
    required this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
    this.avatar,
    required this.isAnonymous,
    this.authProvider,
    this.createdAt,
    this.lastSignInAt,
  });

  /// Create a profile from Firebase User data
  factory UserProfile.fromFirebaseUser(
    dynamic user, {
    UserAvatar? avatar,
    String? displayNameOverride,
  }) {
    return UserProfile(
      uid: user.uid as String,
      email: user.email as String?,
      displayName: displayNameOverride ?? user.displayName as String?,
      photoUrl: user.photoURL as String?,
      avatar: avatar,
      isAnonymous: user.isAnonymous as bool,
      authProvider: _getAuthProvider(user),
      createdAt: user.metadata?.creationTime,
      lastSignInAt: user.metadata?.lastSignInTime,
    );
  }

  /// Create a copy with updated fields
  UserProfile copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoUrl,
    UserAvatar? avatar,
    bool? isAnonymous,
    AuthProviderType? authProvider,
    DateTime? createdAt,
    DateTime? lastSignInAt,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      avatar: avatar ?? this.avatar,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      authProvider: authProvider ?? this.authProvider,
      createdAt: createdAt ?? this.createdAt,
      lastSignInAt: lastSignInAt ?? this.lastSignInAt,
    );
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'avatar': avatar?.id,
      'isAnonymous': isAnonymous,
      'authProvider': authProvider?.providerId,
      'createdAt': createdAt?.toIso8601String(),
      'lastSignInAt': lastSignInAt?.toIso8601String(),
    };
  }

  /// Create from JSON
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      uid: json['uid'] as String,
      email: json['email'] as String?,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      avatar: json['avatar'] != null
          ? UserAvatar.fromId(json['avatar'] as String)
          : null,
      isAnonymous: json['isAnonymous'] as bool? ?? false,
      authProvider: json['authProvider'] != null
          ? AuthProviderType.fromProviderId(json['authProvider'] as String)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      lastSignInAt: json['lastSignInAt'] != null
          ? DateTime.parse(json['lastSignInAt'] as String)
          : null,
    );
  }

  /// Determine primary auth provider from Firebase User
  static AuthProviderType? _getAuthProvider(dynamic user) {
    final providerData = user.providerData as List<dynamic>?;
    if (providerData == null || providerData.isEmpty) {
      if (user.isAnonymous as bool) {
        return AuthProviderType.anonymous;
      }
      return null;
    }

    final primaryProvider = providerData.first;
    final providerId = primaryProvider.providerId as String;
    return AuthProviderType.fromProviderId(providerId);
  }

  @override
  String toString() {
    return 'UserProfile(uid: $uid, email: $email, displayName: $displayName, '
        'isAnonymous: $isAnonymous, authProvider: ${authProvider?.displayName})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserProfile &&
        other.uid == uid &&
        other.email == email &&
        other.displayName == displayName &&
        other.photoUrl == photoUrl &&
        other.avatar == avatar &&
        other.isAnonymous == isAnonymous &&
        other.authProvider == authProvider;
  }

  @override
  int get hashCode {
    return Object.hash(
      uid,
      email,
      displayName,
      photoUrl,
      avatar,
      isAnonymous,
      authProvider,
    );
  }
}
