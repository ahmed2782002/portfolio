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
  // Light — crisp canvas with sage undertones, emerald primary, and warm amber.
  //
  // The canvas sits a step below pure white so white cards read as lifted
  // rather than flush; neutrals carry a faint green cast matching the theme.
  // ---------------------------------------------------------------------------
  static const AppColors light = AppColors(
    brightness: Brightness.light,
    background: Color(0xFFF8FAF8),
    backgroundAlt: Color(0xFFEFF3EF),
    surface: Color(0xFFFFFFFF),
    card: Color(0xFFFFFFFF),
    cardHover: Color(0xFFF5F8F5),
    textPrimary: Color(0xFF121B16),
    textSecondary: Color(0xFF4C5D54),
    textTertiary: Color(0xFF86978E),
    border: Color(0xFFDCE3DE),
    borderStrong: Color(0xFFC4CFC7),
    primary: Color(0xFF059669),
    primaryMuted: Color(0x1A059669),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFFD97706),
    secondaryMuted: Color(0x1AD97706),
    accent: Color(0xFFEA580C),
    success: Color(0xFF059669),
    error: Color(0xFFDC2626),
    shadow: Color(0x0D121B16),
    scrim: Color(0xCCF8FAF8),
  );

  // ---------------------------------------------------------------------------
  // Dark — Cyber carbon & matrix emerald with warm amber accents.
  // No blue, no purple. Ultra-modern developer aesthetic.
  // ---------------------------------------------------------------------------
  static const AppColors dark = AppColors(
    brightness: Brightness.dark,
    background: Color(0xFF0C100E),
    backgroundAlt: Color(0xFF111714),
    surface: Color(0xFF151C18),
    card: Color(0xFF18221D),
    cardHover: Color(0xFF202C26),
    textPrimary: Color(0xFFF2F5F3),
    textSecondary: Color(0xFF96A69E),
    textTertiary: Color(0xFF64756D),
    border: Color(0xFF24332B),
    borderStrong: Color(0xFF354B3F),
    primary: Color(0xFF10B981),
    primaryMuted: Color(0x2410B981),
    onPrimary: Color(0xFF062117),
    secondary: Color(0xFFF59E0B),
    secondaryMuted: Color(0x1FF59E0B),
    accent: Color(0xFFFF6B4A),
    success: Color(0xFF10B981),
    error: Color(0xFFEF4444),
    shadow: Color(0x80000000),
    scrim: Color(0xD90C100E),
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
