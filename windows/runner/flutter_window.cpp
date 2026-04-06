#include "flutter_window.h"

#include <optional>
#include <string>

#include "flutter/generated_plugin_registrant.h"
#include "utils.h"

#include <flutter/method_channel.h>
#include <flutter/standard_method_codec.h>

FlutterWindow::FlutterWindow(const flutter::DartProject& project)
    : project_(project) {}

FlutterWindow::~FlutterWindow() {}

static std::wstring Utf16FromUtf8(const std::string& utf8_string) {
  if (utf8_string.empty()) {
    return std::wstring();
  }
  int target_length =
      ::MultiByteToWideChar(CP_UTF8, MB_ERR_INVALID_CHARS, utf8_string.data(),
                            static_cast<int>(utf8_string.size()), nullptr, 0);
  if (target_length <= 0) {
    return std::wstring();
  }
  std::wstring utf16_string(target_length, L'\0');
  int converted_length = ::MultiByteToWideChar(
      CP_UTF8, MB_ERR_INVALID_CHARS, utf8_string.data(),
      static_cast<int>(utf8_string.size()), utf16_string.data(), target_length);
  if (converted_length <= 0) {
    return std::wstring();
  }
  return utf16_string;
}

bool FlutterWindow::OnCreate() {
  if (!Win32Window::OnCreate()) {
    return false;
  }

  RECT frame = GetClientArea();

  // The size here must match the window dimensions to avoid unnecessary surface
  // creation / destruction in the startup path.
  flutter_controller_ = std::make_unique<flutter::FlutterViewController>(
      frame.right - frame.left, frame.bottom - frame.top, project_);
  // Ensure that basic setup of the controller was successful.
  if (!flutter_controller_->engine() || !flutter_controller_->view()) {
    return false;
  }
  RegisterPlugins(flutter_controller_->engine());

  // flutter_inappwebview
  // 6.2.0-beta.2+ https://github.com/pichillilorenzo/flutter_inappwebview/issues/2482
  // 6.1.5 https://github.com/pichillilorenzo/flutter_inappwebview/issues/2512#issuecomment-3031039587
  flutter::MethodChannel<> channel(
      flutter_controller_->engine()->messenger(), "window_control",
      &flutter::StandardMethodCodec::GetInstance());
  channel.SetMethodCallHandler(
      [](const flutter::MethodCall<>& call,
         std::unique_ptr<flutter::MethodResult<>> result) {
          if (call.method_name().compare("closeWindow") == 0) {
            HANDLE hProcess = GetCurrentProcess();
            TerminateProcess(hProcess, 0);
            result->Success();
          } else if (call.method_name().compare("openVideoWindow") == 0) {
            const auto* encoded_video_data =
                std::get_if<std::string>(call.arguments());
            if (encoded_video_data == nullptr) {
              result->Error("invalid_args",
                            "openVideoWindow expects an encoded string.");
              return;
            }

            HWND old_video_hwnd = ::FindWindow(L"FLUTTER_RUNNER_WIN32_WINDOW",
                                               L"piliplus_video");
            if (old_video_hwnd != NULL) {
              ::PostMessage(old_video_hwnd, WM_CLOSE, 0, 0);
            }

            wchar_t exe_path[MAX_PATH];
            DWORD path_len = ::GetModuleFileName(nullptr, exe_path, MAX_PATH);
            if (path_len == 0 || path_len == MAX_PATH) {
              result->Error("open_failed", "Cannot resolve executable path.");
              return;
            }

            std::wstring params = L"--video-window-data=";
            params += Utf16FromUtf8(*encoded_video_data);
            HINSTANCE open_result = ::ShellExecute(
                nullptr, L"open", exe_path, params.c_str(), nullptr,
                SW_SHOWNORMAL);
            if (reinterpret_cast<intptr_t>(open_result) <= 32) {
              result->Error("open_failed", "Failed to create video window.");
              return;
            }

            result->Success();
          } else {
            result->NotImplemented();
          }
      });

  SetChildContent(flutter_controller_->view()->GetNativeWindow());

  // flutter_controller_->engine()->SetNextFrameCallback([&]() {
  //   this->Show();
  // });

  // Flutter can complete the first frame before the "show window" callback is
  // registered. The following call ensures a frame is pending to ensure the
  // window is shown. It is a no-op if the first frame hasn't completed yet.
  flutter_controller_->ForceRedraw();

  return true;
}

void FlutterWindow::OnDestroy() {
  if (flutter_controller_) {
    flutter_controller_ = nullptr;
  }

  Win32Window::OnDestroy();
}

LRESULT
FlutterWindow::MessageHandler(HWND hwnd, UINT const message,
                              WPARAM const wparam,
                              LPARAM const lparam) noexcept {
  // Give Flutter, including plugins, an opportunity to handle window messages.
  if (flutter_controller_) {
    std::optional<LRESULT> result =
        flutter_controller_->HandleTopLevelWindowProc(hwnd, message, wparam,
                                                      lparam);
    if (result) {
      return *result;
    }
  }

  switch (message) {
    case WM_FONTCHANGE:
      flutter_controller_->engine()->ReloadSystemFonts();
      break;
  }

  return Win32Window::MessageHandler(hwnd, message, wparam, lparam);
}
