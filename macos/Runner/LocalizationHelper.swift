import Foundation

/// Provides helper methods for localization
class LocalizationHelper {
  static let shared = LocalizationHelper()
  
  private init() {}
  
  /// Get localized string from main bundle
  func localizedString(_ key: String) -> String {
    let localizedValue = Bundle.main.localizedString(forKey: key, value: "", table: nil)
    
    if localizedValue.isEmpty {
      print("[Localization] ERROR: Key '\(key)' not found in bundle")
      print("[Localization] Bundle path: \(Bundle.main.bundlePath)")
      print("[Localization] Localizations: \(Bundle.main.localizations)")
    }
    
    return localizedValue
  }
}
