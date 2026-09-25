import 'package:flutter/material.dart';

import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/shared/widgets/hover_builder.dart';

/// A card that lifts, brightens and tightens its border on hover.
///
/// The one surface behind skill panels, principle cards, additional-project
/// tiles and contact rows. Pass [child] for static content, or [builder] when
/// the content itself reacts to the hover (a tinted index, an arrow that
/// slides).
class HoverCard extends StatelessWidget {
  const HoverCard({
    super.key,
    this.child,
    this.builder,
    this.onTap,
    this.semanticLabel,
    this.padding = const EdgeInsets.all(24),
    this.borderRadius,
    this.lift = 4,
    this.accent,
    this.accentAlpha = 0.5,
    this.shadow = true,
    this.pinned = false,
  }) : assert(child != null || builder != null);

  final Widget? child;

  /// Builds content from the highlight progress `t` (0 → 1).
  final Widget Function(BuildContext context, double t)? builder;

  final VoidCallback? onTap;
  final String? semanticLabel;
  final EdgeInsets padding;
  final BorderRadius? borderRadius;

  /// How far the card rises on hover.
  final double lift;

  /// Border colour on hover. Defaults to the primary accent.
  final Color? accent;
  final double accentAlpha;

  /// Whether a soft drop shadow grows in on hover.
  final bool shadow;

  /// Keeps the highlighted look while true, e.g. for an expanded tile.
  final bool pinned;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radius = borderRadius ?? BorderRadius.circular(14);
    final highlight = (accent ?? colors.primary).withValues(alpha: accentAlpha);

    return HoverBuilder(
      onTap: onTap,
      semanticLabel: semanticLabel,
      cursor: onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
      notifyCursor: onTap != null,
      child: child,
      builder: (context, hover, child) {
        final t = pinned ? 1.0 : hover;

        return Transform.translate(
          offset: Offset(0, -lift * hover),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Color.lerp(colors.card, colors.cardHover, t),
              borderRadius: radius,
              border: Border.all(
                color: Color.lerp(colors.border, highlight, t)!,
              ),
              boxShadow: !shadow || hover == 0
                  ? null
                  : [
                      BoxShadow(
                        color: colors.shadow,
                        blurRadius: 24 * hover,
                        offset: Offset(0, 8 * hover),
                      ),
                    ],
            ),
            child: Padding(
              padding: padding,
              child: builder?.call(context, t) ?? child,
            ),
          ),
        );
      },
    );
  }
}
