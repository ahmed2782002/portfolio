import 'package:flutter/widgets.dart';

/// The type system.
///
/// Three families, each with one job:
/// * **Space Grotesk** — display and headings. Geometric, slightly technical.
/// * **Inter** — body copy. Neutral and highly legible at small sizes.
/// * **JetBrains Mono** — micro labels, section indices, technology chips. It
///   is what signals "built by a developer" without resorting to decoration.
///
/// Sizes are authored at the `large` breakpoint and multiplied by a responsive
/// [scale]. Instances are cached per scale so rebuilds don't allocate.
@immutable
class AppTypography {
  AppTypography._(this.scale)
      : display1 = _display(76 * scale, FontWeight.w700, -2.6, 0.96),
        display2 = _display(56 * scale, FontWeight.w700, -1.8, 1.02),
        headline = _display(40 * scale, FontWeight.w700, -1.1, 1.10),
        title = _display(28 * scale, FontWeight.w700, -0.7, 1.18),
        subtitle = _display(21 * scale, FontWeight.w500, -0.3, 1.30),
        bodyLarge = _body(18 * scale, FontWeight.w400, 0, 1.62),
        body = _body(16 * scale, FontWeight.w400, 0, 1.68),
        bodySmall = _body(14.5 * scale, FontWeight.w400, 0, 1.62),
        bodyStrong = _body(16 * scale, FontWeight.w500, 0, 1.55),
        label = _mono(12 * scale, FontWeight.w500, 1.5, 1.2),
        labelSmall = _mono(11 * scale, FontWeight.w400, 1.2, 1.2),
        mono = _mono(13.5 * scale, FontWeight.w400, 0.2, 1.5),
        monoIndex = _mono(13 * scale, FontWeight.w500, 0.6, 1.0);

  static final Map<double, AppTypography> _cache = {};

  factory AppTypography.of(double scale) =>
      _cache[scale] ??= AppTypography._(scale);

  final double scale;

  static const String displayFamily = 'SpaceGrotesk';
  static const String bodyFamily = 'Inter';
  static const String monoFamily = 'JetBrainsMono';

  /// Oversized hero name.
  final TextStyle display1;

  /// Section-opening statements and the contact CTA.
  final TextStyle display2;

  /// Section titles.
  final TextStyle headline;

  /// Project names, card titles.
  final TextStyle title;

  /// Lead-ins and pull quotes.
  final TextStyle subtitle;

  final TextStyle bodyLarge;
  final TextStyle body;
  final TextStyle bodySmall;
  final TextStyle bodyStrong;

  /// Uppercase mono eyebrow — "03 / PROJECTS".
  final TextStyle label;
  final TextStyle labelSmall;

  /// Technology chips, inline code-ish values.
  final TextStyle mono;

  /// Numeric indices in the screenshot viewer and experience list.
  final TextStyle monoIndex;

  static TextStyle _display(
    double size,
    FontWeight weight,
    double letterSpacing,
    double height,
  ) =>
      TextStyle(
        fontFamily: displayFamily,
        fontSize: size,
        fontWeight: weight,
        letterSpacing: letterSpacing,
        height: height,
        leadingDistribution: TextLeadingDistribution.even,
      );

  static TextStyle _body(
    double size,
    FontWeight weight,
    double letterSpacing,
    double height,
  ) =>
      TextStyle(
        fontFamily: bodyFamily,
        fontSize: size,
        fontWeight: weight,
        letterSpacing: letterSpacing,
        height: height,
        leadingDistribution: TextLeadingDistribution.even,
      );

  static TextStyle _mono(
    double size,
    FontWeight weight,
    double letterSpacing,
    double height,
  ) =>
      TextStyle(
        fontFamily: monoFamily,
        fontSize: size,
        fontWeight: weight,
        letterSpacing: letterSpacing,
        height: height,
        leadingDistribution: TextLeadingDistribution.even,
      );
}
