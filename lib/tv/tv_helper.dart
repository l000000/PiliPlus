import 'dart:io';

import 'package:dpad/dpad.dart';
import 'package:flutter/material.dart';

/// TV 适配辅助类 — 所有 TV 相关逻辑集中在此
abstract final class TvHelper {
  /// 是否为 TV 设备（仅 Android TV）
  @pragma('vm:platform-const')
  static bool get isTV => Platform.isAndroid;

  /// 在 Android TV 上用 `Dpad` 包裹 child，非 TV 平台直接透传
  static Widget wrapWithDpad({required Widget child}) {
    if (!isTV) return child;
    return Dpad(
      child: child,
    );
  }
}
