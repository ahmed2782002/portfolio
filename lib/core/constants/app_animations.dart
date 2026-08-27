import 'package:flutter/animation.dart';

/// Motion tokens.
///
/// The portfolio uses a small, deliberate motion vocabulary: things enter from
/// slightly below with an ease-out curve, hover states settle quickly, and the
/// only long animation in the product is the screenshot depth transition.
abstract final class AppAnimations {
  /// Hover / press feedback. Must feel instantaneous.
  static const Duration instant = Duration(milliseconds: 120);
  static const Duration fast = Duration(milliseconds: 180);

  /// Default UI transition.
  static const Duration base = Duration(milliseconds: 280);

  /// Section reveals, nav indicator travel.
  static const Duration slow = Duration(milliseconds: 480);

  /// Screenshot depth transition and theme cross-fade.
  static const Duration deep = Duration(milliseconds: 620);

  /// Programmatic scroll between sections.
  static const Duration scrollTo = Duration(milliseconds: 900);

  /// Delay between siblings in a staggered reveal.
  static const Duration stagger = Duration(milliseconds: 70);

  /// Ease-out with a long tail — the workhorse for entrances.
  static const Curve emphasized = Cubic(0.19, 1.0, 0.22, 1.0);

  /// Symmetric ease for state changes that can reverse (hover, toggles).
  static const Curve standard = Curves.easeOutCubic;

  /// Used where an element should settle with a hint of overshoot.
  static const Curve settle = Cubic(0.34, 1.28, 0.64, 1.0);

  /// Long scroll animations.
  static const Curve scrollCurve = Cubic(0.22, 1.0, 0.36, 1.0);
}
