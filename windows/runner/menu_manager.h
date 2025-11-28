#ifndef RUNNER_MENU_MANAGER_H_
#define RUNNER_MENU_MANAGER_H_

#include <windows.h>
#include <flutter/flutter_view_controller.h>
#include <flutter/method_channel.h>
#include <flutter/standard_method_codec.h>
#include <memory>
#include <string>

// Menu IDs for all menu items
namespace MenuIds {
  // File Menu
  constexpr int kTakeScreenshot = 1001;
  constexpr int kCopyScreenshot = 1002;
  constexpr int kExit = 1003;

  // Edit Menu
  constexpr int kSelectBody = 2001;

  // Simulation Menu
  constexpr int kPlayPause = 3001;
  constexpr int kReset = 3002;
  constexpr int kIncreaseSpeed = 3003;
  constexpr int kDecreaseSpeed = 3004;

  // View Menu
  constexpr int kCenterCamera = 4001;
  constexpr int kToggleFullscreen = 4002;
  constexpr int kToggleStatistics = 4003;
  constexpr int kToggleBodyLabels = 4004;
  constexpr int kToggleTrails = 4005;
  constexpr int kZoomIn = 4006;
  constexpr int kZoomOut = 4007;
  constexpr int kActualSize = 4008;

  // Window Menu
  constexpr int kMinimize = 5001;

  // Help Menu
  constexpr int kGravitonHelp = 6001;
  constexpr int kTutorial = 6002;
  constexpr int kChangelog = 6003;
  constexpr int kReportIssue = 6004;
  constexpr int kPrivacyPolicy = 6005;
  constexpr int kLicenseInfo = 6006;
  constexpr int kAbout = 6007;
}

class MenuManager {
 public:
  MenuManager();
  ~MenuManager();

  // Initialize the menu with the Flutter controller and window handle
  void Initialize(flutter::FlutterViewController* controller, HWND window);

  // Create and attach the menu bar to the window
  HMENU CreateMenuBar();

  // Handle menu command
  bool HandleMenuCommand(int command_id);

 private:
  // Menu creation methods
  HMENU CreateFileMenu();
  HMENU CreateEditMenu();
  HMENU CreateSimulationMenu();
  HMENU CreateViewMenu();
  HMENU CreateWindowMenu();
  HMENU CreateHelpMenu();

  // Command handlers
  void SendNavigationCommand(const std::string& command);
  void SendSimulationCommand(const std::string& command);
  void OpenUrl(const std::string& url);
  void MinimizeWindow();
  void ToggleFullscreen();
  void ShowAbout();
  void ExitApplication();

  // Helper methods
  void AppendMenuItemWithShortcut(HMENU menu, int id, const wchar_t* text, 
                                 const wchar_t* shortcut = nullptr);

  flutter::FlutterViewController* flutter_controller_;
  std::unique_ptr<flutter::MethodChannel<>> navigation_channel_;
  std::unique_ptr<flutter::MethodChannel<>> simulation_channel_;
  HWND window_handle_;
  bool is_fullscreen_;
  WINDOWPLACEMENT window_placement_;
};

#endif  // RUNNER_MENU_MANAGER_H_
