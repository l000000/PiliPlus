import 'dart:io';
import 'dart:ui';

import 'package:dpad/dpad.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// TV 适配辅助类 — 所有 TV 相关逻辑集中在此
abstract final class TvHelper {
  /// 是否为 TV 设备（仅 Android TV）
  static bool? _cachedIsTV;

  /// 检测是否为 Android TV 设备
  /// 使用多个条件检测：
  /// 1. 平台必须是 Android
  /// 2. 屏幕尺寸较大（TV 通常 > 7英寸）
  /// 3. 设备方向通常固定为横屏
  static bool get isTV {
    if (!Platform.isAndroid) return false;
    if (kDebugMode) {
      // 调试模式下可以通过环境变量强制启用 TV 模式
      if (const bool.hasEnvironment('force_tv_mode')) {
        return const bool.fromEnvironment('force_tv_mode');
      }
    }
    // 使用缓存避免重复计算
    _cachedIsTV ??= _detectTV();
    return _cachedIsTV!;
  }

  /// 内部检测逻辑
  static bool _detectTV() {
    final view = PlatformDispatcher.views.first;
    final size = view.physicalSize / view.devicePixelRatio;
    final width = size.width;
    final height = size.height;

    // TV 设备特征：
    // 1. 较大的屏幕尺寸（通常 > 800px 宽度，保守估计）
    // 2. 通常是横屏
    const minTVWidth = 800.0;
    const aspectRatioThreshold = 1.3;

    // 检查屏幕尺寸和宽高比
    final isLandscape = width > height;
    final hasTVSize = width >= minTVWidth || height >= minTVWidth;
    final aspectRatio = isLandscape ? width / height : height / width;
    final hasTVAspectRatio = aspectRatio >= aspectRatioThreshold;

    // 需要同时满足：大屏幕 + 横屏/宽比例
    return hasTVSize && (isLandscape || hasTVAspectRatio);
  }

  /// 在 Android TV 上用 `Dpad` 包裹 child，非 TV 平台直接透传
  static Widget wrapWithDpad({required Widget child}) {
    if (!isTV) return child;
    return Dpad(
      child: child,
    );
  }

  /// 重置 TV 检测缓存（用于测试或动态切换）
  static void resetCache() {
    _cachedIsTV = null;
  }
}
