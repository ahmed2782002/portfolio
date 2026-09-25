import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Lets a trackpad, mouse wheel and touch all drive the same page scroll.
class AppScrollBehavior extends MaterialScrollBehavior {
  const AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => const {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
    PointerDeviceKind.stylus,
  };

  /// The page draws its own progress rule; a stretch overscroll on top of that
  /// would read as a glitch.
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) => child;
}
