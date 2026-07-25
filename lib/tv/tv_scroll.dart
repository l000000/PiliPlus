import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'tv_helper.dart';

/// TV 焦点的自定义滚动物理 — 确保方向键正确触发列表滚动
class TvScrollPhysics extends ScrollPhysics {
  const TvScrollPhysics({super.parent});

  @override
  TvScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return TvScrollPhysics(parent: buildParent(ancestor));
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
}
