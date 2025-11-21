import Cocoa

/// Provides helper methods for displaying notifications
class NotificationHelper {
  static let shared = NotificationHelper()
  
  private init() {}
  
  /// Show a user notification with title and message
  func showNotification(title: String, message: String) {
    let notification = NSUserNotification()
    notification.title = title
    notification.informativeText = message
    notification.soundName = NSUserNotificationDefaultSoundName
    
    NSUserNotificationCenter.default.deliver(notification)
  }
}
