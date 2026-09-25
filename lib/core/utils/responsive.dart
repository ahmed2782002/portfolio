/// Named breakpoints. The layouts below are authored per breakpoint rather than
/// being a shrunk-down desktop design.
enum ScreenSize {
  /// Phones.
  compact,

  /// Large phones / small tablets in portrait.
  medium,

  /// Tablets, small laptops.
  expanded,

  /// 1366 / 1440 laptops.
  large,

  /// 1920+ desktops.
  xlarge;

  bool get isMobile => index <= ScreenSize.medium.index;
  bool get isTabletOrBelow => index <= ScreenSize.expanded.index;
  bool get isDesktop => index >= ScreenSize.large.index;
}

abstract final class Breakpoints {
  static const double medium = 640;
  static const double expanded = 900;
  static const double large = 1200;
  static const double xlarge = 1600;

  static ScreenSize of(double width) {
    if (width < medium) return ScreenSize.compact;
    if (width < expanded) return ScreenSize.medium;
    if (width < large) return ScreenSize.expanded;
    if (width < xlarge) return ScreenSize.large;
    return ScreenSize.xlarge;
  }

  /// Type scale multiplier per breakpoint. Headlines shrink faster than body
  /// copy, which is why the display styles carry a larger base size.
  static double typeScale(ScreenSize size) => switch (size) {
    ScreenSize.compact => 0.80,
    ScreenSize.medium => 0.88,
    ScreenSize.expanded => 0.93,
    ScreenSize.large => 1.0,
    ScreenSize.xlarge => 1.06,
  };

  /// Horizontal page gutter per breakpoint.
  static double gutter(ScreenSize size) => switch (size) {
    ScreenSize.compact => 20,
    ScreenSize.medium => 28,
    ScreenSize.expanded => 40,
    ScreenSize.large => 56,
    ScreenSize.xlarge => 72,
  };

  /// Vertical rhythm between top-level sections.
  static double sectionGap(ScreenSize size) => switch (size) {
    ScreenSize.compact => 72,
    ScreenSize.medium => 88,
    ScreenSize.expanded => 104,
    ScreenSize.large => 128,
    ScreenSize.xlarge => 144,
  };
}

/// Picks one of a set of values based on the current breakpoint, falling back
/// to the nearest smaller value that was supplied.
T responsiveValue<T>(
  ScreenSize size, {
  required T compact,
  T? medium,
  T? expanded,
  T? large,
  T? xlarge,
}) {
  final ladder = <T?>[compact, medium, expanded, large, xlarge];
  T resolved = compact;
  for (var i = 0; i <= size.index; i++) {
    final value = ladder[i];
    if (value != null) resolved = value;
  }
  return resolved;
}
