import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
  
  override func applicationWillFinishLaunching(_ notification: Notification) {
    super.applicationWillFinishLaunching(notification)
    
    // Customize the menu bar early in the launch cycle
    customizeMenuBar()
  }
  
  private func customizeMenuBar() {
    guard let mainMenu = NSApp.mainMenu else { return }
    
    // Remove specific unwanted menus, keep the App menu (index 0)
    // Remove in reverse order to maintain correct indices
    let menusToRemove = ["Help", "Window", "View", "Edit"]
    
    for menuTitle in menusToRemove {
      if let index = mainMenu.items.firstIndex(where: { $0.title == menuTitle }) {
        mainMenu.removeItem(at: index)
      }
    }
    
    // Customize the About menu item
    if let appMenu = mainMenu.items.first?.submenu {
      if let aboutItem = appMenu.item(withTitle: "About \(ProcessInfo.processInfo.processName)") {
        aboutItem.action = #selector(showAboutScreen)
        aboutItem.target = self
      }
      
      // Enable and customize the Preferences menu item
      if let preferencesItem = appMenu.item(withTitle: "Preferences…") {
        preferencesItem.action = #selector(showSettings)
        preferencesItem.target = self
        preferencesItem.isEnabled = true
      }
    }
    
    // Now you should only see the "Graviton" (or "Graviton Dev") app menu
  }
  
  @objc private func showAboutScreen() {
    // Get the Flutter view controller
    if let window = NSApp.windows.first,
       let flutterViewController = window.contentViewController as? FlutterViewController {
      
      // Send message to Flutter to navigate to About screen
      let channel = FlutterMethodChannel(
        name: "io.chipper.graviton/navigation",
        binaryMessenger: flutterViewController.engine.binaryMessenger
      )
      
      channel.invokeMethod("showAbout", arguments: nil)
    }
  }
  
  @objc private func showSettings() {
    // Get the Flutter view controller
    if let window = NSApp.windows.first,
       let flutterViewController = window.contentViewController as? FlutterViewController {
      
      // Send message to Flutter to navigate to Settings screen
      let channel = FlutterMethodChannel(
        name: "io.chipper.graviton/navigation",
        binaryMessenger: flutterViewController.engine.binaryMessenger
      )
      
      channel.invokeMethod("showSettings", arguments: nil)
    }
  }
  
  private func addCustomMenuItem() {
    guard let mainMenu = NSApp.mainMenu else { return }
    
    // Create a new menu
    let customMenu = NSMenu(title: "Custom")
    let customMenuItem = NSMenuItem(title: "Custom", action: nil, keyEquivalent: "")
    customMenuItem.submenu = customMenu
    
    // Add items to the custom menu
    let item1 = NSMenuItem(title: "Settings", action: #selector(openSettings), keyEquivalent: ",")
    item1.target = self
    customMenu.addItem(item1)
    
    // Insert the custom menu before Help menu (usually last)
    let insertIndex = mainMenu.items.count - 1
    mainMenu.insertItem(customMenuItem, at: insertIndex)
  }
  
  @objc private func openSettings() {
    // Handle settings action
    print("Open Settings")
  }
}
