import 'package:flutter/material.dart';

import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_typography.dart';

/// Builds the two [ThemeData]s from the single [AppColors] palette.
///
/// Both themes are authored — dark is not an inversion of light. The light
/// theme leans on paper-warm neutrals and hairline borders; the dark theme
/// drops the canvas well below the card level so surfaces read as lit.
abstract final class AppTheme {
  static ThemeData light() => _build(AppColors.light);
  static ThemeData dark() => _build(AppColors.dark);

  static ThemeData _build(AppColors c) {
    final type = AppTypography.of(1.0);
    final scheme = ColorScheme(
      brightness: c.brightness,
      primary: c.primary,
      onPrimary: c.onPrimary,
      secondary: c.secondary,
      onSecondary: c.onPrimary,
      error: c.error,
      onError: c.onPrimary,
      surface: c.surface,
      onSurface: c.textPrimary,
      outline: c.border,
      outlineVariant: c.borderStrong,
      shadow: c.shadow,
      surfaceContainerHighest: c.card,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: c.brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: c.background,
      canvasColor: c.background,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      fontFamily: AppTypography.bodyFamily,
      extensions: <ThemeExtension<dynamic>>[c],
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: c.primary,
        selectionColor: c.primaryMuted,
        selectionHandleColor: c.primary,
      ),
      iconTheme: IconThemeData(color: c.textSecondary, size: 20),
      dividerTheme: DividerThemeData(color: c.border, thickness: 1, space: 1),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: c.textPrimary,
          borderRadius: const BorderRadius.all(Radius.circular(6)),
        ),
        textStyle: type.labelSmall.copyWith(color: c.background),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        waitDuration: const Duration(milliseconds: 400),
      ),
      textTheme: TextTheme(
        displayLarge: type.display1,
        displayMedium: type.display2,
        headlineLarge: type.headline,
        titleLarge: type.title,
        titleMedium: type.subtitle,
        bodyLarge: type.bodyLarge,
        bodyMedium: type.body,
        bodySmall: type.bodySmall,
        labelLarge: type.label,
        labelSmall: type.labelSmall,
      ).apply(bodyColor: c.textPrimary, displayColor: c.textPrimary),
    );
  }
}
