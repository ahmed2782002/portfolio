import 'package:flutter/material.dart';

/// The portfolio's colour system.
///
/// One intentional palette — a near-neutral slate canvas, a single saturated
/// *indigo* accent, a *teal* secondary that sits a clean interval away on the
/// wheel, and an *amber* highlight for small marks. The canvas carries only a
/// trace of blue so it reads crisp rather than tinted, and so the app
/// screenshots (teal, green, violet, magenta) sit on it without fighting the
/// brand.
///
/// Everything is exposed through [AppColors], a [ThemeExtension], so the entire
/// palette can be swapped in one place. Widgets never hardcode a colour; they
/// read `context.colors.<role>`.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.brightness,
    required this.background,
    required this.backgroundAlt,
    required this.surface,
    required this.card,
    required this.cardHover,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.border,
    required this.borderStrong,
    required this.primary,
    required this.primaryMuted,
    required this.onPrimary,
    required this.secondary,
    required this.secondaryMuted,
    required this.accent,
    required this.success,
    required this.error,
    required this.shadow,
    required this.scrim,
  });

  final Brightness brightness;

  /// Page canvas.
  final Color background;

  /// Alternating band used to separate adjacent sections without a hard rule.
  final Color backgroundAlt;

  /// Raised sheet (nav bar, sticky rails).
  final Color surface;

  /// Content container.
  final Color card;
  final Color cardHover;

  final Color textPrimary;
  final Color textSecondary;

  /// Decorative only — indices, watermarks, hairline labels.
  final Color textTertiary;

  final Color border;
  final Color borderStrong;

  /// Indigo — the single brand accent. Used sparingly and always with intent.
  final Color primary;

  /// Indigo at low alpha, for washes and glows.
  final Color primaryMuted;
  final Color onPrimary;

  /// Teal — a calm technical counterweight to the indigo.
  final Color secondary;
  final Color secondaryMuted;

  /// Amber — highlight for small marks (active indicators, badges).
  final Color accent;

  final Color success;
  final Color error;

  final Color shadow;
  final Color scrim;

  bool get isDark => brightness == Brightness.dark;

  // ---------------------------------------------------------------------------
  // The Strict 5-Color Identity:
  // #A3E4D7 — Modern Mint
  // #BB8FCE — Lavender Purple
  // #E6E0F8 — Soft Lavender
  // #2C3E50 — Dark Charcoal
  // #FFFFFF — White
  // ---------------------------------------------------------------------------
  static const Color modernMint = Color(0xFFA3E4D7);
  static const Color lavenderPurple = Color(0xFFBB8FCE);
  static const Color softLavender = Color(0xFFE6E0F8);
  static const Color darkCharcoal = Color(0xFF2C3E50);
  static const Color white = Color(0xFFFFFFFF);

  // ---------------------------------------------------------------------------
  // Light — Soft Lavender (#E6E0F8) canvas, Crisp White (#FFFFFF) section bands & cards,
  // Dark Charcoal (#2C3E50) typography, Modern Mint (#A3E4D7) & Lavender Purple (#BB8FCE) accents.
  // ---------------------------------------------------------------------------
  static const AppColors light = AppColors(
    brightness: Brightness.light,
    background: softLavender,
    backgroundAlt: white,
    surface: white,
    card: white,
    cardHover: Color(0xFFFAF8FE),
    textPrimary: darkCharcoal,
    textSecondary: Color(0xFF4A5D6E),
    textTertiary: Color(0xFF7A8B99),
    border: Color(0x33BB8FCE),
    borderStrong: Color(0x66BB8FCE),
    primary: modernMint,
    primaryMuted: Color(0x2AA3E4D7),
    onPrimary: darkCharcoal,
    secondary: lavenderPurple,
    secondaryMuted: Color(0x28BB8FCE),
    accent: lavenderPurple,
    success: modernMint,
    error: Color(0xFFE74C3C),
    shadow: Color(0x142C3E50),
    scrim: Color(0xD9E6E0F8),
  );

  // ---------------------------------------------------------------------------
  // Dark — Fitting Deep Charcoal (#1B242F) night canvas, elevated cards (#243241),
  // White/Lavender text, and luminous Mint & Lavender accents.
  // ---------------------------------------------------------------------------
  static const AppColors dark = AppColors(
    brightness: Brightness.dark,
    background: Color(0xFF1B242F),
    backgroundAlt: Color(0xFF23303E),
    surface: Color(0xFF273646),
    card: Color(0xFF243241),
    cardHover: Color(0xFF2D3E50),
    textPrimary: white,
    textSecondary: softLavender,
    textTertiary: Color(0xFF9FB2C4),
    border: Color(0x38BB8FCE),
    borderStrong: Color(0x66A3E4D7),
    primary: modernMint,
    primaryMuted: Color(0x33A3E4D7),
    onPrimary: Color(0xFF1B242F),
    secondary: lavenderPurple,
    secondaryMuted: Color(0x33BB8FCE),
    accent: modernMint,
    success: modernMint,
    error: Color(0xFFE74C3C),
    shadow: Color(0x80000000),
    scrim: Color(0xE61B242F),
  );

  @override
  AppColors copyWith({
    Brightness? brightness,
    Color? background,
    Color? backgroundAlt,
    Color? surface,
    Color? card,
    Color? cardHover,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? border,
    Color? borderStrong,
    Color? primary,
    Color? primaryMuted,
    Color? onPrimary,
    Color? secondary,
    Color? secondaryMuted,
    Color? accent,
    Color? success,
    Color? error,
    Color? shadow,
    Color? scrim,
  }) {
    return AppColors(
      brightness: brightness ?? this.brightness,
      background: background ?? this.background,
      backgroundAlt: backgroundAlt ?? this.backgroundAlt,
      surface: surface ?? this.surface,
      card: card ?? this.card,
      cardHover: cardHover ?? this.cardHover,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      border: border ?? this.border,
      borderStrong: borderStrong ?? this.borderStrong,
      primary: primary ?? this.primary,
      primaryMuted: primaryMuted ?? this.primaryMuted,
      onPrimary: onPrimary ?? this.onPrimary,
      secondary: secondary ?? this.secondary,
      secondaryMuted: secondaryMuted ?? this.secondaryMuted,
      accent: accent ?? this.accent,
      success: success ?? this.success,
      error: error ?? this.error,
      shadow: shadow ?? this.shadow,
      scrim: scrim ?? this.scrim,
    );
  }

  /// Drives the cross-fade between the two themes. Every colour interpolates,
  /// which is what makes the light/dark switch read as one continuous move
  /// rather than a hard cut.
  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      brightness: t < 0.5 ? brightness : other.brightness,
      background: Color.lerp(background, other.background, t)!,
      backgroundAlt: Color.lerp(backgroundAlt, other.backgroundAlt, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      card: Color.lerp(card, other.card, t)!,
      cardHover: Color.lerp(cardHover, other.cardHover, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primaryMuted: Color.lerp(primaryMuted, other.primaryMuted, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      secondaryMuted: Color.lerp(secondaryMuted, other.secondaryMuted, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      success: Color.lerp(success, other.success, t)!,
      error: Color.lerp(error, other.error, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      scrim: Color.lerp(scrim, other.scrim, t)!,
    );
  }
}
