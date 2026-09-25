import 'package:flutter/material.dart';

import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_typography.dart';
import 'package:portfolio/core/utils/responsive.dart';

/// Ergonomic access to the design system. Widgets read tokens through these
/// getters instead of reaching for hardcoded values.
extension DesignSystemContext on BuildContext {
  /// The active palette.
  AppColors get colors =>
      Theme.of(this).extension<AppColors>() ?? AppColors.light;

  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  Size get screenSize => MediaQuery.sizeOf(this);

  ScreenSize get screen => Breakpoints.of(MediaQuery.sizeOf(this).width);

  /// Type scaled for the current breakpoint.
  AppTypography get type => AppTypography.of(Breakpoints.typeScale(screen));

  /// Horizontal page gutter for the current breakpoint.
  double get gutter => Breakpoints.gutter(screen);

  /// Vertical space between top-level sections.
  double get sectionGap => Breakpoints.sectionGap(screen);

  bool get isMobile => screen.isMobile;
  bool get isTabletOrBelow => screen.isTabletOrBelow;
  bool get isDesktop => screen.isDesktop;

  /// Honours the OS "reduce motion" setting. Decorative motion (parallax,
  /// staggered reveals, the depth carousel's rotation) is suppressed when true;
  /// state changes still animate, just plainly.
  bool get reduceMotion => MediaQuery.disableAnimationsOf(this);

  /// Pointer devices get hover affordances and the custom cursor; touch
  /// devices get neither.
  bool get hasPointer => !isMobile;
}
