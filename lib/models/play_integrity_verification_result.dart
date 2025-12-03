/// Result from Play Integrity token verification
class PlayIntegrityVerificationResult {
  final bool isValid;
  final RequestDetails? requestDetails;
  final AppIntegrity? appIntegrity;
  final DeviceIntegrity? deviceIntegrity;
  final AccountDetails? accountDetails;
  final String? error;
  final String timestamp;

  PlayIntegrityVerificationResult({
    required this.isValid,
    this.requestDetails,
    this.appIntegrity,
    this.deviceIntegrity,
    this.accountDetails,
    this.error,
    required this.timestamp,
  });

  factory PlayIntegrityVerificationResult.fromJson(Map<String, dynamic> json) {
    return PlayIntegrityVerificationResult(
      isValid: json['success'] == true,
      requestDetails: json['requestDetails'] != null
          ? RequestDetails.fromJson(
              json['requestDetails'] as Map<String, dynamic>,
            )
          : null,
      appIntegrity: json['appIntegrity'] != null
          ? AppIntegrity.fromJson(json['appIntegrity'] as Map<String, dynamic>)
          : null,
      deviceIntegrity: json['deviceIntegrity'] != null
          ? DeviceIntegrity.fromJson(
              json['deviceIntegrity'] as Map<String, dynamic>,
            )
          : null,
      accountDetails: json['accountDetails'] != null
          ? AccountDetails.fromJson(
              json['accountDetails'] as Map<String, dynamic>,
            )
          : null,
      error: json['error'] as String?,
      timestamp: json['timestamp'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': isValid,
      if (requestDetails != null) 'requestDetails': requestDetails!.toJson(),
      if (appIntegrity != null) 'appIntegrity': appIntegrity!.toJson(),
      if (deviceIntegrity != null) 'deviceIntegrity': deviceIntegrity!.toJson(),
      if (accountDetails != null) 'accountDetails': accountDetails!.toJson(),
      if (error != null) 'error': error,
      'timestamp': timestamp,
    };
  }
}

/// Request details from the integrity token
class RequestDetails {
  final String? requestPackageName;
  final String? timestampMillis;
  final String? nonce;

  RequestDetails({this.requestPackageName, this.timestampMillis, this.nonce});

  factory RequestDetails.fromJson(Map<String, dynamic> json) {
    return RequestDetails(
      requestPackageName: json['requestPackageName'] as String?,
      timestampMillis: json['timestampMillis'] as String?,
      nonce: json['nonce'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (requestPackageName != null) 'requestPackageName': requestPackageName,
      if (timestampMillis != null) 'timestampMillis': timestampMillis,
      if (nonce != null) 'nonce': nonce,
    };
  }
}

/// App integrity verdict
class AppIntegrity {
  final String? appRecognitionVerdict;
  final String? packageName;
  final List<String>? certificateSha256Digest;
  final String? versionCode;

  AppIntegrity({
    this.appRecognitionVerdict,
    this.packageName,
    this.certificateSha256Digest,
    this.versionCode,
  });

  factory AppIntegrity.fromJson(Map<String, dynamic> json) {
    return AppIntegrity(
      appRecognitionVerdict: json['appRecognitionVerdict'] as String?,
      packageName: json['packageName'] as String?,
      certificateSha256Digest:
          (json['certificateSha256Digest'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
      versionCode: json['versionCode'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (appRecognitionVerdict != null)
        'appRecognitionVerdict': appRecognitionVerdict,
      if (packageName != null) 'packageName': packageName,
      if (certificateSha256Digest != null)
        'certificateSha256Digest': certificateSha256Digest,
      if (versionCode != null) 'versionCode': versionCode,
    };
  }
}

/// Device integrity verdict
class DeviceIntegrity {
  final List<String>? deviceRecognitionVerdict;

  DeviceIntegrity({this.deviceRecognitionVerdict});

  factory DeviceIntegrity.fromJson(Map<String, dynamic> json) {
    return DeviceIntegrity(
      deviceRecognitionVerdict:
          (json['deviceRecognitionVerdict'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (deviceRecognitionVerdict != null)
        'deviceRecognitionVerdict': deviceRecognitionVerdict,
    };
  }
}

/// Account details and licensing verdict
class AccountDetails {
  final String? appLicensingVerdict;

  AccountDetails({this.appLicensingVerdict});

  factory AccountDetails.fromJson(Map<String, dynamic> json) {
    return AccountDetails(
      appLicensingVerdict: json['appLicensingVerdict'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (appLicensingVerdict != null)
        'appLicensingVerdict': appLicensingVerdict,
    };
  }
}
