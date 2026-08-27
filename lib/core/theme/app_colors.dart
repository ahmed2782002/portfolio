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
  // Light — cool paper, slate ink.
  //
  // The canvas sits a step below pure white so white cards read as *lifted*
  // rather than flush; every neutral carries the same faint blue cast so the
  // greys never drift toward beige.
  // ---------------------------------------------------------------------------
  static const AppColors light = AppColors(
    brightness: Brightness.light,
    background: Color(0xFFF6F7F9),
    backgroundAlt: Color(0xFFEEF0F4),
    surface: Color(0xFFFCFCFD),
    card: Color(0xFFFFFFFF),
    cardHover: Color(0xFFFAFBFC),
    textPrimary: Color(0xFF14161A),
    textSecondary: Color(0xFF5A6272),
    textTertiary: Color(0xFF8D95A5),
    border: Color(0xFFE3E6EC),
    borderStrong: Color(0xFFC7CCD6),
    primary: Color(0xFF4B44E0),
    primaryMuted: Color(0x1F4B44E0),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFF0E7C86),
    secondaryMuted: Color(0x1A0E7C86),
    accent: Color(0xFFB26205),
    success: Color(0xFF16794F),
    error: Color(0xFFC2382F),
    shadow: Color(0x14101828),
    scrim: Color(0xB3F6F7F9),
  );

  // ---------------------------------------------------------------------------
  // Dark — deep slate ink, accents lifted for contrast.
  //
  // Not an inversion: the canvas drops well below the card level so surfaces
  // read as lit, and the hues shift lighter and slightly desaturated because a
  // dark ground exaggerates chroma.
  // ---------------------------------------------------------------------------
  static const AppColors dark = AppColors(
    brightness: Brightness.dark,
    background: Color(0xFF0B0D12),
    backgroundAlt: Color(0xFF101319),
    surface: Color(0xFF12151C),
    card: Color(0xFF171B23),
    cardHover: Color(0xFF1E232D),
    textPrimary: Color(0xFFEDEFF3),
    textSecondary: Color(0xFF9AA3B2),
    textTertiary: Color(0xFF666F7E),
    border: Color(0xFF242A34),
    borderStrong: Color(0xFF39414F),
    primary: Color(0xFF8B85FF),
    primaryMuted: Color(0x248B85FF),
    onPrimary: Color(0xFF0D0B26),
    secondary: Color(0xFF3FC2CE),
    secondaryMuted: Color(0x1F3FC2CE),
    accent: Color(0xFFF0B44E),
    success: Color(0xFF4ECB8B),
    error: Color(0xFFF08279),
    shadow: Color(0x8C000000),
    scrim: Color(0xB30B0D12),
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
