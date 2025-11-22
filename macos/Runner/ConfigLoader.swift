import Foundation

/// Handles loading and managing configuration from Config.plist
class ConfigLoader {
  static let shared = ConfigLoader()
  
  // Config URLs loaded from Config.plist
  private(set) var reportIssueUrl: String = "https://github.com/Chipper-Technologies/graviton/issues"
  private(set) var privacyPolicyUrl: String = "https://github.com/Chipper-Technologies/graviton/blob/main/PRIVACY.md"
  private(set) var licenseUrl: String = "https://github.com/Chipper-Technologies/graviton/blob/main/LICENSE.md"
  
  private init() {}
  
  func loadConfig() {
    guard let configPath = Bundle.main.path(forResource: "Config", ofType: "plist"),
          let configDict = NSDictionary(contentsOfFile: configPath),
          let gitHubUrls = configDict["GitHubUrls"] as? [String: String] else {
      print("[Config] Warning: Could not load Config.plist, using default URLs")
      return
    }
    
    if let reportIssue = gitHubUrls["reportIssue"] {
      reportIssueUrl = reportIssue
    }
    if let privacy = gitHubUrls["privacyPolicy"] {
      privacyPolicyUrl = privacy
    }
    if let license = gitHubUrls["license"] {
      licenseUrl = license
    }
    
    print("[Config] Loaded URLs from Config.plist:")
    print("  Report Issue: \(reportIssueUrl)")
    print("  Privacy Policy: \(privacyPolicyUrl)")
    print("  License: \(licenseUrl)")
  }
}
