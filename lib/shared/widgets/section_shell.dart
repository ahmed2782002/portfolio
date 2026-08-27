import 'package:flutter/material.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/extensions/context_extensions.dart';

/// Standard horizontal frame for a page section.
///
/// Holds the content column to a readable maximum and applies the breakpoint's
/// gutter, so every section lines up on the same vertical edges no matter what
/// it contains. This is what keeps a long scrolling page reading as one
/// document rather than a stack of unrelated screens.
class SectionShell extends StatelessWidget {
  const SectionShell({
    super.key,
    required this.child,
    this.background,
    this.maxWidth = AppSpacing.maxContentWidth,
    this.verticalPadding,
    this.clip = false,
  });

  final Widget child;

  /// Alternating band colour. `null` keeps the page canvas.
  final Color? background;
  final double maxWidth;

  /// Overrides the breakpoint's section rhythm.
  final double? verticalPadding;

  final bool clip;

  @override
  Widget build(BuildContext context) {
    final pad = verticalPadding ?? context.sectionGap;

    Widget content = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.gutter,
        vertical: pad,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: child,
        ),
      ),
    );

    if (background != null) {
      content = ColoredBox(color: background!, child: content);
    }
    if (clip) {
      content = ClipRect(child: content);
    }
    return content;
  }
}

/// A hairline rule with an optional label, used to separate sub-blocks inside a
/// section without introducing another card.
class HairlineDivider extends StatelessWidget {
  const HairlineDivider({super.key, this.label});

  final String? label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    if (label == null) {
      return Container(height: 1, color: colors.border);
    }
    return Row(
      children: [
        Text(
          label!.toUpperCase(),
          style: context.type.label.copyWith(color: colors.textTertiary),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: Container(height: 1, color: colors.border)),
      ],
    );
  }
}
