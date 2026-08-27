import 'package:flutter/widgets.dart';

/// A 4pt spacing scale. Every gap in the portfolio comes from here.
abstract final class AppSpacing {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;
  static const double x3l = 40;
  static const double x4l = 48;
  static const double x5l = 64;
  static const double x6l = 80;
  static const double x7l = 96;
  static const double x8l = 128;
  static const double x9l = 160;

  /// Vertical rhythm between major page sections, per breakpoint.
  static const double sectionGapMobile = x5l;
  static const double sectionGapTablet = x6l;
  static const double sectionGapDesktop = x8l;

  /// Widest the content column is ever allowed to grow, so 1920px screens
  /// don't stretch line lengths past readability.
  static const double maxContentWidth = 1240;
  static const double maxProseWidth = 680;

  static const SizedBox gapXxs = SizedBox(height: xxs, width: xxs);
  static const SizedBox gapXs = SizedBox(height: xs, width: xs);
  static const SizedBox gapSm = SizedBox(height: sm, width: sm);
  static const SizedBox gapMd = SizedBox(height: md, width: md);
  static const SizedBox gapLg = SizedBox(height: lg, width: lg);
  static const SizedBox gapXl = SizedBox(height: xl, width: xl);
  static const SizedBox gapXxl = SizedBox(height: xxl, width: xxl);
}

/// Corner radii. Kept few and consistent — the device mockups and cards share
/// the same geometric family.
abstract final class AppRadius {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double pill = 999;

  static const BorderRadius brXs = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius brSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius brMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius brLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius brXl = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius brXxl = BorderRadius.all(Radius.circular(xxl));
  static const BorderRadius brPill = BorderRadius.all(Radius.circular(pill));
}
