#include "menu_manager.h"
#include <shellapi.h>
#include <string>

constexpr char kNavigationChannelName[] = "io.chipper.graviton/navigation";
constexpr char kSimulationChannelName[] = "io.chipper.graviton/simulation";

// Configuration URLs
constexpr char kReportIssueUrl[] = "https://github.com/Chipper-Technologies/graviton/issues";
constexpr char kPrivacyPolicyUrl[] = "https://github.com/Chipper-Technologies/graviton/blob/main/PRIVACY.md";
constexpr char kLicenseUrl[] = "https://github.com/Chipper-Technologies/graviton/blob/main/LICENSE.md";

MenuManager::MenuManager() 
    : flutter_controller_(nullptr),
      window_handle_(nullptr),
      is_fullscreen_(false) {
  ZeroMemory(&window_placement_, sizeof(WINDOWPLACEMENT));
  window_placement_.length = sizeof(WINDOWPLACEMENT);
}

MenuManager::~MenuManager() {}

void MenuManager::Initialize(flutter::FlutterViewController* controller, HWND window) {
  flutter_controller_ = controller;
  window_handle_ = window;
  
  if (flutter_controller_) {
    navigation_channel_ = std::make_unique<flutter::MethodChannel<>>(
        flutter_controller_->engine()->messenger(),
        kNavigationChannelName,
        &flutter::StandardMethodCodec::GetInstance());
    
    simulation_channel_ = std::make_unique<flutter::MethodChannel<>>(
        flutter_controller_->engine()->messenger(),
        kSimulationChannelName,
        &flutter::StandardMethodCodec::GetInstance());
  }
}

HMENU MenuManager::CreateMenuBar() {
  HMENU menu_bar = CreateMenu();
  
  AppendMenu(menu_bar, MF_POPUP, reinterpret_cast<UINT_PTR>(CreateFileMenu()), L"&File");
  AppendMenu(menu_bar, MF_POPUP, reinterpret_cast<UINT_PTR>(CreateEditMenu()), L"&Edit");
  AppendMenu(menu_bar, MF_POPUP, reinterpret_cast<UINT_PTR>(CreateSimulationMenu()), L"&Simulation");
  AppendMenu(menu_bar, MF_POPUP, reinterpret_cast<UINT_PTR>(CreateViewMenu()), L"&View");
  AppendMenu(menu_bar, MF_POPUP, reinterpret_cast<UINT_PTR>(CreateWindowMenu()), L"&Window");
  AppendMenu(menu_bar, MF_POPUP, reinterpret_cast<UINT_PTR>(CreateHelpMenu()), L"&Help");
  
  return menu_bar;
}

HMENU MenuManager::CreateFileMenu() {
  HMENU menu = CreateMenu();
  
  AppendMenuItemWithShortcut(menu, MenuIds::kTakeScreenshot, L"Take Screenshot", L"Ctrl+Shift+S");
  AppendMenuItemWithShortcut(menu, MenuIds::kCopyScreenshot, L"Copy Screenshot", L"Ctrl+C");
  AppendMenu(menu, MF_SEPARATOR, 0, nullptr);
  AppendMenuItemWithShortcut(menu, MenuIds::kExit, L"E&xit", L"Alt+F4");
  
  return menu;
}

HMENU MenuManager::CreateEditMenu() {
  HMENU menu = CreateMenu();
  
  AppendMenuItemWithShortcut(menu, MenuIds::kSelectBody, L"Select Body", L"Ctrl+B");
  
  return menu;
}

HMENU MenuManager::CreateSimulationMenu() {
  HMENU menu = CreateMenu();
  
  AppendMenuItemWithShortcut(menu, MenuIds::kPlayPause, L"Play/Pause", L"Ctrl+Space");
  AppendMenuItemWithShortcut(menu, MenuIds::kReset, L"Reset", L"Ctrl+R");
  AppendMenu(menu, MF_SEPARATOR, 0, nullptr);
  AppendMenuItemWithShortcut(menu, MenuIds::kIncreaseSpeed, L"Faster", L"Ctrl++");
  AppendMenuItemWithShortcut(menu, MenuIds::kDecreaseSpeed, L"Slower", L"Ctrl+-");
  
  return menu;
}

HMENU MenuManager::CreateViewMenu() {
  HMENU menu = CreateMenu();
  
  AppendMenuItemWithShortcut(menu, MenuIds::kCenterCamera, L"Center Camera", L"Ctrl+C");
  AppendMenuItemWithShortcut(menu, MenuIds::kToggleFullscreen, L"Toggle Fullscreen", L"F11");
  AppendMenu(menu, MF_SEPARATOR, 0, nullptr);
  AppendMenuItemWithShortcut(menu, MenuIds::kToggleStatistics, L"Statistics", L"Ctrl+I");
  AppendMenuItemWithShortcut(menu, MenuIds::kToggleBodyLabels, L"Body Labels", L"Ctrl+L");
  AppendMenuItemWithShortcut(menu, MenuIds::kToggleTrails, L"Trails", L"Ctrl+T");
  AppendMenu(menu, MF_SEPARATOR, 0, nullptr);
  AppendMenuItemWithShortcut(menu, MenuIds::kZoomIn, L"Zoom In", L"Ctrl+=");
  AppendMenuItemWithShortcut(menu, MenuIds::kZoomOut, L"Zoom Out", L"Ctrl+-");
  AppendMenuItemWithShortcut(menu, MenuIds::kActualSize, L"Actual Size", L"Ctrl+0");
  
  return menu;
}

HMENU MenuManager::CreateWindowMenu() {
  HMENU menu = CreateMenu();
  
  AppendMenuItemWithShortcut(menu, MenuIds::kMinimize, L"Minimize", L"Ctrl+M");
  
  return menu;
}

HMENU MenuManager::CreateHelpMenu() {
  HMENU menu = CreateMenu();
  
  AppendMenuItemWithShortcut(menu, MenuIds::kGravitonHelp, L"Graviton Help", L"F1");
  AppendMenu(menu, MF_STRING, MenuIds::kTutorial, L"Tutorial");
  AppendMenu(menu, MF_STRING, MenuIds::kChangelog, L"Changelog");
  AppendMenu(menu, MF_SEPARATOR, 0, nullptr);
  AppendMenu(menu, MF_STRING, MenuIds::kReportIssue, L"Report an Issue");
  AppendMenu(menu, MF_SEPARATOR, 0, nullptr);
  AppendMenu(menu, MF_STRING, MenuIds::kPrivacyPolicy, L"Privacy Policy");
  AppendMenu(menu, MF_STRING, MenuIds::kLicenseInfo, L"License Information");
  AppendMenu(menu, MF_SEPARATOR, 0, nullptr);
  AppendMenu(menu, MF_STRING, MenuIds::kAbout, L"About Graviton");
  
  return menu;
}

bool MenuManager::HandleMenuCommand(int command_id) {
  switch (command_id) {
    // File Menu
    case MenuIds::kTakeScreenshot:
      SendSimulationCommand("takeScreenshot");
      return true;
    case MenuIds::kCopyScreenshot:
      SendSimulationCommand("copyScreenshot");
      return true;
    case MenuIds::kExit:
      ExitApplication();
      return true;

    // Edit Menu
    case MenuIds::kSelectBody:
      SendSimulationCommand("selectBody");
      return true;

    // Simulation Menu
    case MenuIds::kPlayPause:
      SendSimulationCommand("togglePlayPause");
      return true;
    case MenuIds::kReset:
      SendSimulationCommand("reset");
      return true;
    case MenuIds::kIncreaseSpeed:
      SendSimulationCommand("increaseSpeed");
      return true;
    case MenuIds::kDecreaseSpeed:
      SendSimulationCommand("decreaseSpeed");
      return true;

    // View Menu
    case MenuIds::kCenterCamera:
      SendSimulationCommand("centerCamera");
      return true;
    case MenuIds::kToggleFullscreen:
      ToggleFullscreen();
      return true;
    case MenuIds::kToggleStatistics:
      SendSimulationCommand("toggleStatistics");
      return true;
    case MenuIds::kToggleBodyLabels:
      SendSimulationCommand("toggleBodyLabels");
      return true;
    case MenuIds::kToggleTrails:
      SendSimulationCommand("toggleTrails");
      return true;
    case MenuIds::kZoomIn:
      SendSimulationCommand("zoomIn");
      return true;
    case MenuIds::kZoomOut:
      SendSimulationCommand("zoomOut");
      return true;
    case MenuIds::kActualSize:
      SendSimulationCommand("actualSize");
      return true;

    // Window Menu
    case MenuIds::kMinimize:
      MinimizeWindow();
      return true;

    // Help Menu
    case MenuIds::kGravitonHelp:
      SendNavigationCommand("showHelp");
      return true;
    case MenuIds::kTutorial:
      SendSimulationCommand("showTutorial");
      return true;
    case MenuIds::kChangelog:
      SendNavigationCommand("showChangelog");
      return true;
    case MenuIds::kReportIssue:
      OpenUrl(kReportIssueUrl);
      return true;
    case MenuIds::kPrivacyPolicy:
      OpenUrl(kPrivacyPolicyUrl);
      return true;
    case MenuIds::kLicenseInfo:
      OpenUrl(kLicenseUrl);
      return true;
    case MenuIds::kAbout:
      ShowAbout();
      return true;

    default:
      return false;
  }
}

void MenuManager::SendNavigationCommand(const std::string& command) {
  if (navigation_channel_) {
    navigation_channel_->InvokeMethod(command, nullptr);
  }
}

void MenuManager::SendSimulationCommand(const std::string& command) {
  if (simulation_channel_) {
    simulation_channel_->InvokeMethod(command, nullptr);
  }
}

void MenuManager::OpenUrl(const std::string& url) {
  ShellExecuteA(nullptr, "open", url.c_str(), nullptr, nullptr, SW_SHOWNORMAL);
}

void MenuManager::MinimizeWindow() {
  if (window_handle_) {
    ShowWindow(window_handle_, SW_MINIMIZE);
  }
}

void MenuManager::ToggleFullscreen() {
  if (!window_handle_) {
    return;
  }

  DWORD style = GetWindowLong(window_handle_, GWL_STYLE);
  
  if (is_fullscreen_) {
    // Restore windowed mode
    SetWindowLong(window_handle_, GWL_STYLE, style | WS_OVERLAPPEDWINDOW);
    SetWindowPlacement(window_handle_, &window_placement_);
    SetWindowPos(window_handle_, nullptr, 0, 0, 0, 0,
                SWP_NOMOVE | SWP_NOSIZE | SWP_NOZORDER |
                SWP_NOOWNERZORDER | SWP_FRAMECHANGED);
    is_fullscreen_ = false;
  } else {
    // Enter fullscreen mode
    GetWindowPlacement(window_handle_, &window_placement_);
    SetWindowLong(window_handle_, GWL_STYLE, style & ~WS_OVERLAPPEDWINDOW);
    
    MONITORINFO mi = { sizeof(mi) };
    if (GetMonitorInfo(MonitorFromWindow(window_handle_, MONITOR_DEFAULTTOPRIMARY), &mi)) {
      SetWindowPos(window_handle_, HWND_TOP,
                  mi.rcMonitor.left, mi.rcMonitor.top,
                  mi.rcMonitor.right - mi.rcMonitor.left,
                  mi.rcMonitor.bottom - mi.rcMonitor.top,
                  SWP_NOOWNERZORDER | SWP_FRAMECHANGED);
    }
    is_fullscreen_ = true;
  }
}

void MenuManager::ShowAbout() {
  SendNavigationCommand("showAbout");
}

void MenuManager::ExitApplication() {
  if (window_handle_) {
    PostMessage(window_handle_, WM_CLOSE, 0, 0);
  }
}

void MenuManager::AppendMenuItemWithShortcut(HMENU menu, int id, 
                                            const wchar_t* text,
                                            const wchar_t* shortcut) {
  std::wstring menu_text = text;
  if (shortcut && wcslen(shortcut) > 0) {
    menu_text += L"\t";
    menu_text += shortcut;
  }
  AppendMenu(menu, MF_STRING, id, menu_text.c_str());
}
