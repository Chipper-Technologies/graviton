import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate, MenuActionDelegate {
  
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
  
  override func applicationDidFinishLaunching(_ notification: Notification) {
    super.applicationDidFinishLaunching(notification)
    
    // Load config from plist
    ConfigLoader.shared.loadConfig()
  }
  
  override func applicationWillFinishLaunching(_ notification: Notification) {
    super.applicationWillFinishLaunching(notification)
    
    // Customize the menu bar
    MenuBuilder.shared.customizeMenuBar(delegate: self)
  }
  
  // MARK: - App Menu Actions
  
  @objc func showAboutScreen() {
    FlutterChannelManager.shared.sendNavigationCommand("showAbout")
  }
  
  @objc func showSettings() {
    FlutterChannelManager.shared.sendNavigationCommand("showSettings")
  }
  
  // MARK: - File Menu Actions
  
  @objc func takeScreenshot() {
    ScreenshotManager.shared.takeScreenshot()
  }
  
  @objc func copyScreenshot() {
    ScreenshotManager.shared.copyScreenshot()
  }
  
  // MARK: - Edit Menu Actions
  
  @objc func selectBody() {
    FlutterChannelManager.shared.sendSimulationCommand("selectBody")
  }
  
  // MARK: - Simulation Menu Actions
  
  @objc func togglePlayPause() {
    FlutterChannelManager.shared.sendSimulationCommand("togglePlayPause")
  }
  
  @objc func resetSimulation() {
    FlutterChannelManager.shared.sendSimulationCommand("reset")
  }
  
  @objc func increaseSpeed() {
    FlutterChannelManager.shared.sendSimulationCommand("increaseSpeed")
  }
  
  @objc func decreaseSpeed() {
    FlutterChannelManager.shared.sendSimulationCommand("decreaseSpeed")
  }
  
  // MARK: - View Menu Actions
  
  @objc func centerCamera() {
    FlutterChannelManager.shared.sendSimulationCommand("centerCamera")
  }
  
  @objc func toggleFullscreen() {
    if let window = NSApp.windows.first {
      window.toggleFullScreen(nil)
    }
  }
  
  @objc func toggleStatistics() {
    FlutterChannelManager.shared.sendSimulationCommand("toggleStatistics")
  }
  
  @objc func toggleBodyLabels() {
    FlutterChannelManager.shared.sendSimulationCommand("toggleBodyLabels")
  }
  
  @objc func toggleTrails() {
    FlutterChannelManager.shared.sendSimulationCommand("toggleTrails")
  }
  
  @objc func zoomIn() {
    FlutterChannelManager.shared.sendSimulationCommand("zoomIn")
  }
  
  @objc func zoomOut() {
    FlutterChannelManager.shared.sendSimulationCommand("zoomOut")
  }
  
  @objc func actualSize() {
    FlutterChannelManager.shared.sendSimulationCommand("actualSize")
  }
  
  // MARK: - Help Menu Actions
  
  @objc func showHelp() {
    FlutterChannelManager.shared.sendNavigationCommand("showHelp")
  }
  
  @objc func showTutorial() {
    FlutterChannelManager.shared.sendSimulationCommand("showTutorial")
  }
  
  @objc func showChangelog() {
    FlutterChannelManager.shared.sendNavigationCommand("showChangelog")
  }
  
  @objc func reportIssue() {
    if let url = URL(string: ConfigLoader.shared.reportIssueUrl) {
      NSWorkspace.shared.open(url)
    }
  }
  
  @objc func showPrivacyPolicy() {
    if let url = URL(string: ConfigLoader.shared.privacyPolicyUrl) {
      NSWorkspace.shared.open(url)
    }
  }
  
  @objc func showLicenseInfo() {
    if let url = URL(string: ConfigLoader.shared.licenseUrl) {
      NSWorkspace.shared.open(url)
    }
  }
}
