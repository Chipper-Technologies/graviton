import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
    
    // Window configuration
    configureWindow()
  }
  
  private func configureWindow() {
    // Set window style mask to control which buttons appear
    // Available options:
    // - .titled: Shows title bar
    // - .closable: Shows close button
    // - .miniaturizable: Shows minimize button
    // - .resizable: Shows maximize/zoom button and allows resizing
    // - .fullSizeContentView: Content extends under title bar
    // - .borderless: No border
    
    // Default: All buttons visible and resizable
    self.styleMask = [.titled, .closable, .miniaturizable, .resizable]
    
    // Set minimum window size
    self.minSize = NSSize(width: 800, height: 600)
    
    // Set maximum window size (optional)
    // self.maxSize = NSSize(width: 1920, height: 1080)
    
    // Set initial window size
    self.setContentSize(NSSize(width: 1200, height: 800))
    
    // Center window on screen
    self.center()
    
    // Set window title
    self.title = "Graviton"
    
    // Additional window options:
    
    // Make window appear on all spaces/desktops
    // self.collectionBehavior = [.canJoinAllSpaces]
    
    // Prevent window from being restored when app reopens
    // self.isRestorable = false
    
    // Make window always on top
    // self.level = .floating
    
    // Hide title bar but keep buttons
    // self.titlebarAppearsTransparent = true
    // self.titleVisibility = .hidden
    
    // Full screen support
    // self.collectionBehavior.insert(.fullScreenPrimary)
  }
}
