import Cocoa
import FlutterMacOS

/// Manages Flutter method channel communication
class FlutterChannelManager {
  static let shared = FlutterChannelManager()
  
  private static let navigationChannelName = "io.chipper.graviton/navigation"
  private static let simulationChannelName = "io.chipper.graviton/simulation"
  
  private init() {}
  
  /// Get the Flutter view controller from the first window
  private var flutterViewController: FlutterViewController? {
    guard let window = NSApp.windows.first,
          let viewController = window.contentViewController as? FlutterViewController else {
      return nil
    }
    return viewController
  }
  
  /// Send a command to the navigation channel
  func sendNavigationCommand(_ command: String) {
    guard let flutterViewController = flutterViewController else {
      print("[FlutterChannel] No Flutter view controller available")
      return
    }
    
    let channel = FlutterMethodChannel(
      name: FlutterChannelManager.navigationChannelName,
      binaryMessenger: flutterViewController.engine.binaryMessenger
    )
    channel.invokeMethod(command, arguments: nil)
  }
  
  /// Send a command to the simulation channel
  func sendSimulationCommand(_ command: String, arguments: Any? = nil) {
    guard let flutterViewController = flutterViewController else {
      print("[FlutterChannel] No Flutter view controller available")
      return
    }
    
    let channel = FlutterMethodChannel(
      name: FlutterChannelManager.simulationChannelName,
      binaryMessenger: flutterViewController.engine.binaryMessenger
    )
    channel.invokeMethod(command, arguments: arguments)
  }
}
