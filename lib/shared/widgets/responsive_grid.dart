import 'package:flutter/widgets.dart';

import 'package:portfolio/core/constants/app_animations.dart';
import 'package:portfolio/shared/animations/staggered.dart';

/// Lays [children] out in [columns] equal-width columns, cascading them in as
/// they scroll into view.
///
/// Replaces the `LayoutBuilder` + `Wrap` + width arithmetic that every card
/// grid on the page used to repeat.
class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({
    super.key,
    required this.columns,
    required this.children,
    this.gap = 16,
    this.revealOffset = 22,
    this.revealInterval = AppAnimations.stagger,
  });

  final int columns;
  final List<Widget> children;
  final double gap;

  /// Distance each tile rises while revealing.
  final double revealOffset;
  final Duration revealInterval;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = (constraints.maxWidth - gap * (columns - 1)) / columns;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: staggered(
            [
              for (final child in children)
                SizedBox(width: width, child: child),
            ],
            offsetY: revealOffset,
            interval: revealInterval,
          ),
        );
      },
    );
  }
}
