import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'tv_helper.dart';

/// TV 焦点的自定义滚动物理 — 确保方向键正确触发列表滚动
/// 使用 ClampingScrollPhysics 作为基础，TV上更适合固定边界
class TvScrollPhysics extends ClampingScrollPhysics {
  const TvScrollPhysics({super.parent});

  @override
  TvScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return TvScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    // TV上更严格的边界控制，防止过度滚动
    if (value < position.pixels && position.pixels <= position.minScrollExtent) {
      return value - position.pixels;
    }
    if (value > position.pixels && position.pixels >= position.maxScrollExtent) {
      return value - position.pixels;
    }
    return 0.0;
  }

  /// 创建TV友好的滚动物理
  static ScrollPhysics? create({ScrollPhysics? parent}) {
    if (!TvHelper.isTV) return parent;
    return const TvScrollPhysics(parent: null);
  }
}

/// TV 友好的 ScrollBehavior — 让所有可滚动区域接受键盘/遥控器方向键
class TvScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        if (TvHelper.isTV) ...{
          PointerDeviceKind.unknown,
        },
      };

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    // 为TV设备应用自定义的滚动物理
    if (TvHelper.isTV) {
      final physics = super.getScrollPhysics(context);
      return const TvScrollPhysics(parent: null).applyTo(physics);
    }
    return super.getScrollPhysics(context);
  }
}

/// ScrollView 扩展，方便应用 TV 物理效果
extension TvScrollExtension on ScrollView {
  /// 获取适合当前设备的滚动物理效果
  static ScrollPhysics getPhysics({ScrollPhysics? physics}) {
    if (TvHelper.isTV) {
      return const TvScrollPhysics(parent: null);
    }
    return physics ?? const ClampingScrollPhysics();
  }
}
