import Cocoa

/// Builds and manages the application menu bar
class MenuBuilder {
  static let shared = MenuBuilder()
  
  private weak var delegate: MenuActionDelegate?
  
  private init() {}
  
  /// Customize the menu bar with app-specific menus
  func customizeMenuBar(delegate: MenuActionDelegate) {
    self.delegate = delegate
    
    guard let mainMenu = NSApp.mainMenu else { return }
    
    // Remove unwanted menus
    removeUnwantedMenus(from: mainMenu)
    
    // Customize app menu
    customizeAppMenu(mainMenu)
    
    // Add custom menus
    addFileMenu(to: mainMenu)
    addEditMenu(to: mainMenu)
    addSimulationMenu(to: mainMenu)
    addViewMenu(to: mainMenu)
    addWindowMenu(to: mainMenu)
    addHelpMenu(to: mainMenu)
  }
  
  // MARK: - Private Menu Building Methods
  
  private func removeUnwantedMenus(from mainMenu: NSMenu) {
    // Remove specific unwanted menus, keep the App menu (index 0)
    let menusToRemove = ["Help", "Window", "View", "Edit"]
    
    for menuTitle in menusToRemove {
      if let index = mainMenu.items.firstIndex(where: { $0.title == menuTitle }) {
        mainMenu.removeItem(at: index)
      }
    }
  }
  
  private func customizeAppMenu(_ mainMenu: NSMenu) {
    guard let appMenu = mainMenu.items.first?.submenu else { return }
    
    // Customize About menu item
    if let aboutItem = appMenu.item(withTitle: "About \(ProcessInfo.processInfo.processName)") {
      aboutItem.action = #selector(MenuActionDelegate.showAboutScreen)
      aboutItem.target = delegate
    }
    
    // Enable and customize Preferences menu item
    if let preferencesItem = appMenu.item(withTitle: "Preferences…") {
      preferencesItem.action = #selector(MenuActionDelegate.showSettings)
      preferencesItem.target = delegate
      preferencesItem.isEnabled = true
    }
  }
  
  private func addFileMenu(to mainMenu: NSMenu) {
    let fileTitle = LocalizationHelper.shared.localizedString("file")
    let fileMenu = NSMenu(title: fileTitle)
    let fileMenuItem = NSMenuItem(title: fileTitle, action: nil, keyEquivalent: "")
    fileMenuItem.submenu = fileMenu
    
    // Take Screenshot - Cmd+Shift+S
    let screenshotItem = NSMenuItem(
      title: LocalizationHelper.shared.localizedString("takeScreenshot"),
      action: #selector(MenuActionDelegate.takeScreenshot),
      keyEquivalent: "s"
    )
    screenshotItem.keyEquivalentModifierMask = [.command, .shift]
    screenshotItem.target = delegate
    fileMenu.addItem(screenshotItem)
    
    // Copy Screenshot - Cmd+C
    let copyScreenshotItem = NSMenuItem(
      title: LocalizationHelper.shared.localizedString("copyScreenshot"),
      action: #selector(MenuActionDelegate.copyScreenshot),
      keyEquivalent: "c"
    )
    copyScreenshotItem.target = delegate
    fileMenu.addItem(copyScreenshotItem)
    
    // Insert File menu after App menu (index 1)
    mainMenu.insertItem(fileMenuItem, at: 1)
  }
  
  private func addEditMenu(to mainMenu: NSMenu) {
    let editTitle = LocalizationHelper.shared.localizedString("edit")
    let editMenu = NSMenu(title: editTitle)
    let editMenuItem = NSMenuItem(title: editTitle, action: nil, keyEquivalent: "")
    editMenuItem.submenu = editMenu
    
    // Select Body - Cmd+B
    let selectBodyItem = NSMenuItem(
      title: LocalizationHelper.shared.localizedString("selectBody"),
      action: #selector(MenuActionDelegate.selectBody),
      keyEquivalent: "b"
    )
    selectBodyItem.target = delegate
    editMenu.addItem(selectBodyItem)
    
    mainMenu.addItem(editMenuItem)
  }
  
  private func addSimulationMenu(to mainMenu: NSMenu) {
    let simulationTitle = LocalizationHelper.shared.localizedString("simulation")
    let simulationMenu = NSMenu(title: simulationTitle)
    let simulationMenuItem = NSMenuItem(title: simulationTitle, action: nil, keyEquivalent: "")
    simulationMenuItem.submenu = simulationMenu
    
    // Play/Pause - Cmd+Space
    let playPauseItem = NSMenuItem(
      title: LocalizationHelper.shared.localizedString("playPause"),
      action: #selector(MenuActionDelegate.togglePlayPause),
      keyEquivalent: " "
    )
    playPauseItem.keyEquivalentModifierMask = [.command]
    playPauseItem.target = delegate
    simulationMenu.addItem(playPauseItem)
    
    // Reset - Cmd+R
    let resetItem = NSMenuItem(
      title: LocalizationHelper.shared.localizedString("reset"),
      action: #selector(MenuActionDelegate.resetSimulation),
      keyEquivalent: "r"
    )
    resetItem.target = delegate
    simulationMenu.addItem(resetItem)
    
    simulationMenu.addItem(NSMenuItem.separator())
    
    // Faster - Cmd++
    let fasterItem = NSMenuItem(
      title: LocalizationHelper.shared.localizedString("faster"),
      action: #selector(MenuActionDelegate.increaseSpeed),
      keyEquivalent: "+"
    )
    fasterItem.target = delegate
    simulationMenu.addItem(fasterItem)
    
    // Slower - Cmd+-
    let slowerItem = NSMenuItem(
      title: LocalizationHelper.shared.localizedString("slower"),
      action: #selector(MenuActionDelegate.decreaseSpeed),
      keyEquivalent: "-"
    )
    slowerItem.target = delegate
    simulationMenu.addItem(slowerItem)
    
    mainMenu.addItem(simulationMenuItem)
  }
  
  private func addViewMenu(to mainMenu: NSMenu) {
    let viewTitle = LocalizationHelper.shared.localizedString("view")
    let viewMenu = NSMenu(title: viewTitle)
    let viewMenuItem = NSMenuItem(title: viewTitle, action: nil, keyEquivalent: "")
    viewMenuItem.submenu = viewMenu
    
    // Center Camera - Cmd+C
    let centerCameraItem = NSMenuItem(
      title: LocalizationHelper.shared.localizedString("centerCamera"),
      action: #selector(MenuActionDelegate.centerCamera),
      keyEquivalent: "c"
    )
    centerCameraItem.target = delegate
    viewMenu.addItem(centerCameraItem)
    
    // Toggle Fullscreen - Ctrl+Cmd+F
    let fullscreenItem = NSMenuItem(
      title: LocalizationHelper.shared.localizedString("toggleFullscreen"),
      action: #selector(MenuActionDelegate.toggleFullscreen),
      keyEquivalent: "f"
    )
    fullscreenItem.keyEquivalentModifierMask = [.command, .control]
    fullscreenItem.target = delegate
    viewMenu.addItem(fullscreenItem)
    
    viewMenu.addItem(NSMenuItem.separator())
    
    // Statistics - Cmd+I
    let statsItem = NSMenuItem(
      title: LocalizationHelper.shared.localizedString("statistics"),
      action: #selector(MenuActionDelegate.toggleStatistics),
      keyEquivalent: "i"
    )
    statsItem.target = delegate
    viewMenu.addItem(statsItem)
    
    // Body Labels - Cmd+L
    let labelsItem = NSMenuItem(
      title: LocalizationHelper.shared.localizedString("bodyLabels"),
      action: #selector(MenuActionDelegate.toggleBodyLabels),
      keyEquivalent: "l"
    )
    labelsItem.target = delegate
    viewMenu.addItem(labelsItem)
    
    // Trails - Cmd+T
    let trailsItem = NSMenuItem(
      title: LocalizationHelper.shared.localizedString("trails"),
      action: #selector(MenuActionDelegate.toggleTrails),
      keyEquivalent: "t"
    )
    trailsItem.target = delegate
    viewMenu.addItem(trailsItem)
    
    viewMenu.addItem(NSMenuItem.separator())
    
    // Zoom In - Cmd+=
    let zoomInItem = NSMenuItem(
      title: LocalizationHelper.shared.localizedString("zoomIn"),
      action: #selector(MenuActionDelegate.zoomIn),
      keyEquivalent: "="
    )
    zoomInItem.target = delegate
    viewMenu.addItem(zoomInItem)
    
    // Zoom Out - Cmd+-
    let zoomOutItem = NSMenuItem(
      title: LocalizationHelper.shared.localizedString("zoomOut"),
      action: #selector(MenuActionDelegate.zoomOut),
      keyEquivalent: "-"
    )
    zoomOutItem.target = delegate
    viewMenu.addItem(zoomOutItem)
    
    // Actual Size - Cmd+0
    let actualSizeItem = NSMenuItem(
      title: LocalizationHelper.shared.localizedString("actualSize"),
      action: #selector(MenuActionDelegate.actualSize),
      keyEquivalent: "0"
    )
    actualSizeItem.target = delegate
    viewMenu.addItem(actualSizeItem)
    
    mainMenu.addItem(viewMenuItem)
  }
  
  private func addWindowMenu(to mainMenu: NSMenu) {
    let windowTitle = LocalizationHelper.shared.localizedString("window")
    let windowMenu = NSMenu(title: windowTitle)
    let windowMenuItem = NSMenuItem(title: windowTitle, action: nil, keyEquivalent: "")
    windowMenuItem.submenu = windowMenu
    
    // Minimize - Cmd+M
    let minimizeItem = NSMenuItem(
      title: LocalizationHelper.shared.localizedString("minimize"),
      action: #selector(NSWindow.miniaturize(_:)),
      keyEquivalent: "m"
    )
    windowMenu.addItem(minimizeItem)
    
    // Zoom
    let zoomItem = NSMenuItem(
      title: LocalizationHelper.shared.localizedString("zoom"),
      action: #selector(NSWindow.zoom(_:)),
      keyEquivalent: ""
    )
    windowMenu.addItem(zoomItem)
    
    windowMenu.addItem(NSMenuItem.separator())
    
    // Bring All to Front
    let bringAllItem = NSMenuItem(
      title: LocalizationHelper.shared.localizedString("bringAllToFront"),
      action: #selector(NSApplication.arrangeInFront(_:)),
      keyEquivalent: ""
    )
    windowMenu.addItem(bringAllItem)
    
    mainMenu.addItem(windowMenuItem)
    NSApp.windowsMenu = windowMenu
  }
  
  private func addHelpMenu(to mainMenu: NSMenu) {
    let helpTitle = LocalizationHelper.shared.localizedString("help")
    let helpMenu = NSMenu(title: helpTitle)
    let helpMenuItem = NSMenuItem(title: helpTitle, action: nil, keyEquivalent: "")
    helpMenuItem.submenu = helpMenu
    
    // Graviton Help - Cmd+?
    let gravitonHelpItem = NSMenuItem(
      title: LocalizationHelper.shared.localizedString("gravitonHelp"),
      action: #selector(MenuActionDelegate.showHelp),
      keyEquivalent: "?"
    )
    gravitonHelpItem.target = delegate
    helpMenu.addItem(gravitonHelpItem)
    
    // Tutorial
    let tutorialItem = NSMenuItem(
      title: LocalizationHelper.shared.localizedString("tutorial"),
      action: #selector(MenuActionDelegate.showTutorial),
      keyEquivalent: ""
    )
    tutorialItem.target = delegate
    helpMenu.addItem(tutorialItem)
    
    // Changelog
    let changelogItem = NSMenuItem(
      title: LocalizationHelper.shared.localizedString("changelog"),
      action: #selector(MenuActionDelegate.showChangelog),
      keyEquivalent: ""
    )
    changelogItem.target = delegate
    helpMenu.addItem(changelogItem)
    
    helpMenu.addItem(NSMenuItem.separator())
    
    // Report an Issue
    let reportItem = NSMenuItem(
      title: LocalizationHelper.shared.localizedString("reportIssue"),
      action: #selector(MenuActionDelegate.reportIssue),
      keyEquivalent: ""
    )
    reportItem.target = delegate
    helpMenu.addItem(reportItem)
    
    helpMenu.addItem(NSMenuItem.separator())
    
    // Privacy Policy
    let privacyItem = NSMenuItem(
      title: LocalizationHelper.shared.localizedString("privacyPolicy"),
      action: #selector(MenuActionDelegate.showPrivacyPolicy),
      keyEquivalent: ""
    )
    privacyItem.target = delegate
    helpMenu.addItem(privacyItem)
    
    // License Information
    let licenseItem = NSMenuItem(
      title: LocalizationHelper.shared.localizedString("licenseInfo"),
      action: #selector(MenuActionDelegate.showLicenseInfo),
      keyEquivalent: ""
    )
    licenseItem.target = delegate
    helpMenu.addItem(licenseItem)
    
    mainMenu.addItem(helpMenuItem)
    NSApp.helpMenu = helpMenu
  }
}

// MARK: - MenuActionDelegate Protocol

/// Protocol defining all menu action methods
@objc protocol MenuActionDelegate: AnyObject {
  // App Menu
  func showAboutScreen()
  func showSettings()
  
  // File Menu
  func takeScreenshot()
  func copyScreenshot()
  
  // Edit Menu
  func selectBody()
  
  // Simulation Menu
  func togglePlayPause()
  func resetSimulation()
  func increaseSpeed()
  func decreaseSpeed()
  
  // View Menu
  func centerCamera()
  func toggleFullscreen()
  func toggleStatistics()
  func toggleBodyLabels()
  func toggleTrails()
  func zoomIn()
  func zoomOut()
  func actualSize()
  
  // Help Menu
  func showHelp()
  func showTutorial()
  func showChangelog()
  func reportIssue()
  func showPrivacyPolicy()
  func showLicenseInfo()
}
