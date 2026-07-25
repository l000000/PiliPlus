import 'package:flutter/material.dart';

import 'tv_helper.dart';

/// 在现有主题上叠加 TV 焦点高亮样式
extension TvThemeExtension on ThemeData {
  ThemeData applyTvTheme() {
    if (!TvHelper.isTV) return this;
    final cs = colorScheme;
    final focusOverlay = WidgetStateProperty.resolveWith<Color?>(
      (states) => states.contains(WidgetState.focused)
          ? cs.primary.withValues(alpha: 0.15)
          : null,
    );
    final focusBorder = WidgetStateProperty.resolveWith<BorderSide?>(
      (states) => states.contains(WidgetState.focused)
          ? BorderSide(color: cs.primary, width: 2.5)
          : null,
    );

    return copyWith(
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          overlayColor: focusOverlay,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          overlayColor: focusOverlay,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          overlayColor: focusOverlay,
          side: focusBorder,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          overlayColor: focusOverlay,
        ),
      ),
      listTileTheme: ListTileThemeData(
        tileColor: Colors.transparent,
        selectedTileColor: cs.primary.withValues(alpha: 0.12),
      ),
      cardTheme: cardTheme.copyWith(
        clipBehavior: Clip.antiAlias,
      ),
    );
  }
}
