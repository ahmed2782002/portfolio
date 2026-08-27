import 'package:flutter/material.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/extensions/context_extensions.dart';
import 'hover_builder.dart';

/// A technology label.
///
/// Monospaced and small — the point is a dense, scannable rail of names, not a
/// wall of vendor logos. Hover lifts it a hair and tints the border, enough to
/// confirm it responds without implying it is a link.
class TechChip extends StatelessWidget {
  const TechChip({
    super.key,
    required this.label,
    this.accent,
    this.dense = false,
    this.emphasised = false,
  });

  final String label;

  /// Per-project tint. Defaults to indigo.
  final Color? accent;

  /// Tighter padding for inline rails inside cards.
  final bool dense;

  /// Gives the chip a filled ground — used for the primary stack on a project.
  final bool emphasised;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tint = accent ?? colors.primary;

    return HoverBuilder(
      notifyCursor: false,
      builder: (context, t, _) => Transform.translate(
        offset: Offset(0, -1.5 * t),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: dense ? 8 : 10,
            vertical: dense ? 4 : 6,
          ),
          decoration: BoxDecoration(
            color: Color.lerp(
              emphasised ? tint.withValues(alpha: 0.10) : colors.backgroundAlt,
              tint.withValues(alpha: 0.16),
              t,
            ),
            borderRadius: AppRadius.brXs,
            border: Border.all(
              color: Color.lerp(
                emphasised ? tint.withValues(alpha: 0.32) : colors.border,
                tint.withValues(alpha: 0.7),
                t,
              )!,
            ),
          ),
          child: Text(
            label,
            style: (dense ? context.type.labelSmall : context.type.mono)
                .copyWith(
              color: Color.lerp(
                emphasised ? tint : colors.textSecondary,
                tint,
                t,
              ),
              letterSpacing: 0.1,
            ),
          ),
        ),
      ),
    );
  }
}

/// Lays out chips in a wrap with the site's standard gaps.
class TechChipRail extends StatelessWidget {
  const TechChipRail({
    super.key,
    required this.items,
    this.accent,
    this.dense = false,
    this.emphasised = false,
    this.alignment = WrapAlignment.start,
  });

  final List<String> items;
  final Color? accent;
  final bool dense;
  final bool emphasised;
  final WrapAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      alignment: alignment,
      children: [
        for (final item in items)
          TechChip(
            label: item,
            accent: accent,
            dense: dense,
            emphasised: emphasised,
          ),
      ],
    );
  }
}
