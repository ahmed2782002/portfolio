import 'package:flutter/widgets.dart';

import 'package:portfolio/core/constants/app_animations.dart';
import 'package:portfolio/shared/animations/reveal_on_scroll.dart';

/// Wraps each child in a [RevealOnScroll] whose delay grows with its index, so
/// siblings cascade instead of snapping in together.
///
/// The stagger is deliberately capped: past [maxSteps] siblings it stops
/// accumulating, so a long grid never leaves the reader waiting on the last row.
List<Widget> staggered(
  List<Widget> children, {
  Duration interval = AppAnimations.stagger,
  Duration baseDelay = Duration.zero,
  int maxSteps = 8,
  double offsetY = 24,
  double offsetX = 0,
  double startScale = 1,
}) {
  return [
    for (var i = 0; i < children.length; i++)
      RevealOnScroll(
        delay: baseDelay + interval * (i.clamp(0, maxSteps)),
        offsetY: offsetY,
        offsetX: offsetX,
        startScale: startScale,
        child: children[i],
      ),
  ];
}
