import 'package:dpad/dpad.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'tv_helper.dart';

/// TV 焦点包裹器 — 让任意 widget 支持遥控器方向键导航
class TvFocusable extends StatelessWidget {
  final Widget child;
  final VoidCallback? onSelect;
  final bool autofocus;

  const TvFocusable({
    super.key,
    required this.child,
    this.onSelect,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!TvHelper.isTV) return child;
    return DpadFocusable(
      onSelect: onSelect,
      autofocus: autofocus,
      child: child,
    );
  }
}

/// TV 友好的列表 Tile
class TvListTile extends StatelessWidget {
  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onPressed;
  final double? height;

  const TvListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onPressed,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final tile = ListTile(
      title: title,
      subtitle: subtitle,
      leading: leading,
      trailing: trailing,
      onTap: TvHelper.isTV ? null : onPressed,
    );
    if (!TvHelper.isTV) return tile;
    return SizedBox(
      height: height,
      child: TvFocusable(onSelect: onPressed, child: tile),
    );
  }
}

/// TV 友好的图标按钮
class TvIconButton extends StatelessWidget {
  final IconData icon;
  final String? tooltip;
  final VoidCallback? onPressed;
  final double? iconSize;

  const TvIconButton({
    super.key,
    required this.icon,
    this.tooltip,
    this.onPressed,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    final btn = IconButton(
      icon: Icon(icon),
      tooltip: tooltip,
      onPressed: TvHelper.isTV ? null : onPressed,
      iconSize: iconSize,
    );
    if (!TvHelper.isTV) return btn;
    return TvFocusable(onSelect: onPressed, child: btn);
  }
}

/// GestureDetector 的 TV 替代品 — 在 TV 上自动添加遥控器焦点支持
/// 用法完全兼容：直接把 `GestureDetector(` 换成 `TvTap(`
class TvTap extends StatelessWidget {
  final Widget child;
  final GestureTapDownCallback? onTapDown;
  final GestureTapUpCallback? onTapUp;
  final GestureTapCallback? onTap;
  final GestureTapCancelCallback? onTapCancel;
  final GestureTapDownCallback? onSecondaryTapDown;
  final GestureTapUpCallback? onSecondaryTapUp;
  final GestureTapCallback? onSecondaryTap;
  final GestureTapCancelCallback? onSecondaryTapCancel;
  final GestureTapDownCallback? onTertiaryTapDown;
  final GestureTapUpCallback? onTertiaryTapUp;
  final GestureTapCancelCallback? onTertiaryTapCancel;
  final GestureTapCallback? onDoubleTap;
  final GestureLongPressCallback? onLongPress;
  final GestureLongPressStartCallback? onLongPressStart;
  final GestureLongPressMoveUpdateCallback? onLongPressMoveUpdate;
  final GestureLongPressUpCallback? onLongPressUp;
  final GestureLongPressEndCallback? onLongPressEnd;
  final GestureDragDownCallback? onVerticalDragDown;
  final GestureDragStartCallback? onVerticalDragStart;
  final GestureDragUpdateCallback? onVerticalDragUpdate;
  final GestureDragEndCallback? onVerticalDragEnd;
  final GestureDragCancelCallback? onVerticalDragCancel;
  final GestureDragDownCallback? onHorizontalDragDown;
  final GestureDragStartCallback? onHorizontalDragStart;
  final GestureDragUpdateCallback? onHorizontalDragUpdate;
  final GestureDragEndCallback? onHorizontalDragEnd;
  final GestureDragCancelCallback? onHorizontalDragCancel;
  final GestureDragDownCallback? onPanDown;
  final GestureDragStartCallback? onPanStart;
  final GestureDragUpdateCallback? onPanUpdate;
  final GestureDragEndCallback? onPanEnd;
  final GestureDragCancelCallback? onPanCancel;
  final GestureScaleStartCallback? onScaleStart;
  final GestureScaleUpdateCallback? onScaleUpdate;
  final GestureScaleEndCallback? onScaleEnd;
  final GestureForcePressStartCallback? onForcePressStart;
  final GestureForcePressPeakCallback? onForcePressPeak;
  final GestureForcePressUpdateCallback? onForcePressUpdate;
  final GestureForcePressEndCallback? onForcePressEnd;
  final HitTestBehavior? behavior;
  final bool excludeFromSemantics;
  final DragStartBehavior dragStartBehavior;

  const TvTap({
    super.key,
    required this.child,
    this.onTapDown,
    this.onTapUp,
    this.onTap,
    this.onTapCancel,
    this.onSecondaryTapDown,
    this.onSecondaryTapUp,
    this.onSecondaryTap,
    this.onSecondaryTapCancel,
    this.onTertiaryTapDown,
    this.onTertiaryTapUp,
    this.onTertiaryTapCancel,
    this.onDoubleTap,
    this.onLongPress,
    this.onLongPressStart,
    this.onLongPressMoveUpdate,
    this.onLongPressUp,
    this.onLongPressEnd,
    this.onVerticalDragDown,
    this.onVerticalDragStart,
    this.onVerticalDragUpdate,
    this.onVerticalDragEnd,
    this.onVerticalDragCancel,
    this.onHorizontalDragDown,
    this.onHorizontalDragStart,
    this.onHorizontalDragUpdate,
    this.onHorizontalDragEnd,
    this.onHorizontalDragCancel,
    this.onPanDown,
    this.onPanStart,
    this.onPanUpdate,
    this.onPanEnd,
    this.onPanCancel,
    this.onScaleStart,
    this.onScaleUpdate,
    this.onScaleEnd,
    this.onForcePressStart,
    this.onForcePressPeak,
    this.onForcePressUpdate,
    this.onForcePressEnd,
    this.behavior,
    this.excludeFromSemantics = false,
    this.dragStartBehavior = DragStartBehavior.start,
  });

  @override
  Widget build(BuildContext context) {
    final gesture = GestureDetector(
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTap: onTap,
      onTapCancel: onTapCancel,
      onSecondaryTapDown: onSecondaryTapDown,
      onSecondaryTapUp: onSecondaryTapUp,
      onSecondaryTap: onSecondaryTap,
      onSecondaryTapCancel: onSecondaryTapCancel,
      onTertiaryTapDown: onTertiaryTapDown,
      onTertiaryTapUp: onTertiaryTapUp,
      onTertiaryTapCancel: onTertiaryTapCancel,
      onDoubleTap: onDoubleTap,
      onLongPress: onLongPress,
      onLongPressStart: onLongPressStart,
      onLongPressMoveUpdate: onLongPressMoveUpdate,
      onLongPressUp: onLongPressUp,
      onLongPressEnd: onLongPressEnd,
      onVerticalDragDown: onVerticalDragDown,
      onVerticalDragStart: onVerticalDragStart,
      onVerticalDragUpdate: onVerticalDragUpdate,
      onVerticalDragEnd: onVerticalDragEnd,
      onVerticalDragCancel: onVerticalDragCancel,
      onHorizontalDragDown: onHorizontalDragDown,
      onHorizontalDragStart: onHorizontalDragStart,
      onHorizontalDragUpdate: onHorizontalDragUpdate,
      onHorizontalDragEnd: onHorizontalDragEnd,
      onHorizontalDragCancel: onHorizontalDragCancel,
      onPanDown: onPanDown,
      onPanStart: onPanStart,
      onPanUpdate: onPanUpdate,
      onPanEnd: onPanEnd,
      onPanCancel: onPanCancel,
      onScaleStart: onScaleStart,
      onScaleUpdate: onScaleUpdate,
      onScaleEnd: onScaleEnd,
      onForcePressStart: onForcePressStart,
      onForcePressPeak: onForcePressPeak,
      onForcePressUpdate: onForcePressUpdate,
      onForcePressEnd: onForcePressEnd,
      behavior: behavior,
      excludeFromSemantics: excludeFromSemantics,
      dragStartBehavior: dragStartBehavior,
      child: child,
    );
    if (!TvHelper.isTV || onTap == null && onLongPress == null) {
      return gesture;
    }
    return DpadFocusable(
      onSelect: onTap,
      onLongSelect: onLongPress,
      child: gesture,
    );
  }
}

/// 将任意 TextButton 转为 TV 可控
class TvTextButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;

  const TvTextButton({super.key, required this.child, this.onPressed});

  @override
  Widget build(BuildContext context) {
    if (!TvHelper.isTV) {
      return TextButton(onPressed: onPressed, child: child);
    }
    return TvFocusable(
      onSelect: onPressed,
      child: TextButton(onPressed: null, child: child),
    );
  }
}
