import 'package:flutter/material.dart';

import 'package:portfolio/core/extensions/context_extensions.dart';

/// A two-pixel reading-progress rule pinned to the top of the window.
///
/// It is the only always-visible piece of chrome besides the nav, so it stays
/// hairline-thin and uses the indigo accent at partial opacity — enough to tell
/// you where you are in a long page, not enough to draw the eye off the content.
class ScrollProgressBar extends StatelessWidget {
  const ScrollProgressBar({super.key, required this.progress});

  /// 0 → top of the page, 1 → fully scrolled.
  final double progress;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return IgnorePointer(
      child: SizedBox(
        height: 2,
        child: Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: progress.clamp(0.0, 1.0),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colors.primary.withValues(alpha: 0.55),
                    colors.primary,
                  ],
                ),
              ),
              child: const SizedBox(height: 2),
            ),
          ),
        ),
      ),
    );
  }
}
