import 'package:flutter/material.dart';

import 'package:portfolio/core/constants/app_spacing.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/shared/animations/reveal_on_scroll.dart';

/// A monospaced eyebrow — `02 / EXPERIENCE` — with a hairline that runs to the
/// edge of the column. Repeated at the top of every section, it is the main
/// device holding the page together as one document.
class SectionEyebrow extends StatelessWidget {
  const SectionEyebrow({
    super.key,
    required this.index,
    required this.label,
    this.accent,
  });

  final int index;
  final String label;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tint = accent ?? colors.primary;

    return Row(
      children: [
        Text(
          index.toString().padLeft(2, '0'),
          style: context.type.label.copyWith(color: tint),
        ),
        const SizedBox(width: AppSpacing.sm),
        Container(width: 18, height: 1, color: colors.borderStrong),
        const SizedBox(width: AppSpacing.sm),
        Flexible(
          child: Text(
            label.toUpperCase(),
            style: context.type.label.copyWith(color: colors.textSecondary),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: Container(height: 1, color: colors.border)),
      ],
    );
  }
}

/// The standard opening block for a section: eyebrow, title, and an optional
/// lead paragraph constrained to a readable measure.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.index,
    required this.label,
    required this.title,
    this.lead,
    this.trailing,
    this.accent,
  });

  final int index;
  final String label;
  final String title;
  final String? lead;

  /// Optional control aligned to the title's right on wide layouts.
  final Widget? trailing;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;
    final stackTrailing = context.isTabletOrBelow;

    final heading = Text(
      title,
      style: type.headline.copyWith(color: colors.textPrimary),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RevealOnScroll(
          offsetY: 16,
          child: SectionEyebrow(index: index, label: label, accent: accent),
        ),
        const SizedBox(height: AppSpacing.xl),
        RevealOnScroll(
          delay: const Duration(milliseconds: 60),
          child: stackTrailing || trailing == null
              ? heading
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(child: heading),
                    const SizedBox(width: AppSpacing.xl),
                    trailing!,
                  ],
                ),
        ),
        if (lead != null) ...[
          const SizedBox(height: AppSpacing.md),
          RevealOnScroll(
            delay: const Duration(milliseconds: 120),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppSpacing.maxProseWidth,
              ),
              child: Text(
                lead!,
                style: type.bodyLarge.copyWith(color: colors.textSecondary),
              ),
            ),
          ),
        ],
        if (trailing != null && stackTrailing) ...[
          const SizedBox(height: AppSpacing.lg),
          RevealOnScroll(
            delay: const Duration(milliseconds: 160),
            child: trailing!,
          ),
        ],
      ],
    );
  }
}
