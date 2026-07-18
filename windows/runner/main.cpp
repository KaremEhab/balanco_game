#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <windows.h>

#include <string>

#include "app_links/app_links_plugin_c_api.h"

#include "flutter_window.h"
#include "utils.h"

namespace {

constexpr wchar_t kWindowTitle[] = L"Balanco";
constexpr wchar_t kProtocolRegistryKey[] =
    L"Software\\Classes\\balanco";

bool SetRegistryString(const std::wstring& key_path,
                       const wchar_t* value_name,
                       const std::wstring& value) {
  HKEY key = nullptr;
  const auto create_result = RegCreateKeyExW(
      HKEY_CURRENT_USER, key_path.c_str(), 0, nullptr, REG_OPTION_NON_VOLATILE,
      KEY_SET_VALUE, nullptr, &key, nullptr);
  if (create_result != ERROR_SUCCESS) {
    return false;
  }

  const auto* bytes = reinterpret_cast<const BYTE*>(value.c_str());
  const DWORD byte_count =
      static_cast<DWORD>((value.size() + 1) * sizeof(wchar_t));
  const auto set_result =
      RegSetValueExW(key, value_name, 0, REG_SZ, bytes, byte_count);
  RegCloseKey(key);
  return set_result == ERROR_SUCCESS;
}

// Unpackaged Flutter Windows builds do not register custom URL schemes for
// app_links automatically. Register per-user so Google/Supabase can return to
// the exact Balanco executable without requiring administrator access.
bool RegisterBalancoProtocol() {
  wchar_t executable_path[MAX_PATH];
  const DWORD path_length =
      GetModuleFileNameW(nullptr, executable_path, MAX_PATH);
  if (path_length == 0 || path_length >= MAX_PATH) {
    return false;
  }

  const std::wstring base_key(kProtocolRegistryKey);
  const std::wstring command =
      L"\"" + std::wstring(executable_path) + L"\" \"%1\"";
  return SetRegistryString(base_key, nullptr,
                           L"URL:Balanco OAuth Callback") &&
         SetRegistryString(base_key, L"URL Protocol", L"") &&
         SetRegistryString(base_key + L"\\shell\\open\\command", nullptr,
                           command);
}

// When Balanco is already open, Windows starts a short-lived second process
// for balanco:// links. Forward that URL to the existing game process so its
// Supabase session and AuthScreen receive the callback.
bool SendAppLinkToRunningInstance() {
  HWND window =
      FindWindowW(L"FLUTTER_RUNNER_WIN32_WINDOW", kWindowTitle);
  if (window == nullptr) {
    return false;
  }

  SendAppLink(window);

  WINDOWPLACEMENT placement = {sizeof(WINDOWPLACEMENT)};
  GetWindowPlacement(window, &placement);
  ShowWindow(window, placement.showCmd == SW_SHOWMAXIMIZED ? SW_SHOWMAXIMIZED
                                                            : SW_RESTORE);
  SetWindowPos(window, HWND_TOP, 0, 0, 0, 0,
               SWP_SHOWWINDOW | SWP_NOSIZE | SWP_NOMOVE);
  SetForegroundWindow(window);
  return true;
}

}  // namespace

int APIENTRY wWinMain(_In_ HINSTANCE instance, _In_opt_ HINSTANCE prev,
                      _In_ wchar_t *command_line, _In_ int show_command) {
  RegisterBalancoProtocol();
  if (SendAppLinkToRunningInstance()) {
    return EXIT_SUCCESS;
  }

  // Attach to console when present (e.g., 'flutter run') or create a
  // new console when running with a debugger.
  if (!::AttachConsole(ATTACH_PARENT_PROCESS) && ::IsDebuggerPresent()) {
    CreateAndAttachConsole();
  }

  // Initialize COM, so that it is available for use in the library and/or
  // plugins.
  ::CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);

  flutter::DartProject project(L"data");

  std::vector<std::string> command_line_arguments =
      GetCommandLineArguments();

  project.set_dart_entrypoint_arguments(std::move(command_line_arguments));

  FlutterWindow window(project);
  Win32Window::Point origin(10, 10);
  Win32Window::Size size(1280, 720);
  if (!window.Create(kWindowTitle, origin, size)) {
    return EXIT_FAILURE;
  }
  window.SetQuitOnClose(true);

  ::MSG msg;
  while (::GetMessage(&msg, nullptr, 0, 0)) {
    ::TranslateMessage(&msg);
    ::DispatchMessage(&msg);
  }

  ::CoUninitialize();
  return EXIT_SUCCESS;
}
