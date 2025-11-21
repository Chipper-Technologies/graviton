import Cocoa

/// Handles screenshot capture, saving, and clipboard operations
class ScreenshotManager {
  static let shared = ScreenshotManager()
  
  private init() {}
  
  /// Take a screenshot and show save panel
  func takeScreenshot() {
    guard let window = NSApp.windows.first else {
      print("No window found for screenshot")
      return
    }
    
    guard let pngData = captureWindowContent(window) else {
      print("Failed to capture screenshot")
      return
    }
    
    showSavePanel(with: pngData)
  }
  
  /// Copy screenshot to clipboard
  func copyScreenshot() {
    guard let window = NSApp.windows.first else {
      print("No window found for screenshot")
      return
    }
    
    guard let pngData = captureWindowContent(window),
          let image = NSImage(data: pngData) else {
      print("Failed to create screenshot")
      return
    }
    
    // Copy to clipboard
    let pasteboard = NSPasteboard.general
    pasteboard.clearContents()
    pasteboard.writeObjects([image])
    
    print("Screenshot copied to clipboard")
    
    // Show success notification
    let title = LocalizationHelper.shared.localizedString("screenshotCopied")
    let message = LocalizationHelper.shared.localizedString("screenshotCopiedMessage")
    NotificationHelper.shared.showNotification(title: title, message: message)
  }
  
  // MARK: - Private Methods
  
  private func captureWindowContent(_ window: NSWindow) -> Data? {
    guard let contentView = window.contentView else {
      print("No content view found")
      return nil
    }
    
    // Create bitmap representation of the view
    guard let bitmapRep = contentView.bitmapImageRepForCachingDisplay(in: contentView.bounds) else {
      print("Failed to create bitmap representation")
      return nil
    }
    
    contentView.cacheDisplay(in: contentView.bounds, to: bitmapRep)
    
    // Convert to PNG data
    guard let pngData = bitmapRep.representation(using: .png, properties: [:]) else {
      print("Failed to create PNG data")
      return nil
    }
    
    return pngData
  }
  
  private func showSavePanel(with pngData: Data) {
    let savePanel = NSSavePanel()
    savePanel.allowedContentTypes = [.png]
    savePanel.canCreateDirectories = true
    savePanel.isExtensionHidden = false
    savePanel.title = LocalizationHelper.shared.localizedString("saveScreenshot")
    savePanel.message = LocalizationHelper.shared.localizedString("saveScreenshotMessage")
    savePanel.nameFieldLabel = LocalizationHelper.shared.localizedString("fileName")
    
    // Generate default filename with timestamp
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
    let timestamp = dateFormatter.string(from: Date())
    savePanel.nameFieldStringValue = "graviton-screenshot-\(timestamp).png"
    
    // Show save panel
    savePanel.begin { response in
      if response == .OK, let url = savePanel.url {
        self.saveScreenshot(pngData, to: url)
      }
    }
  }
  
  private func saveScreenshot(_ pngData: Data, to url: URL) {
    do {
      try pngData.write(to: url)
      print("Screenshot saved to: \(url.path)")
      
      // Show success notification
      let title = LocalizationHelper.shared.localizedString("screenshotSaved")
      let message = String(
        format: LocalizationHelper.shared.localizedString("screenshotSavedMessage"),
        url.lastPathComponent
      )
      NotificationHelper.shared.showNotification(title: title, message: message)
    } catch {
      print("Failed to save screenshot: \(error)")
      
      // Show error notification
      let title = LocalizationHelper.shared.localizedString("screenshotFailed")
      let message = "Failed to save screenshot: \(error.localizedDescription)"
      NotificationHelper.shared.showNotification(title: title, message: message)
    }
  }
}
