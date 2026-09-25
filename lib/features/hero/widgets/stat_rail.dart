import 'package:flutter/material.dart';

import 'package:portfolio/core/constants/app_spacing.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/data/models/models.dart';

/// At-a-glance numbers, hairline-separated. Every value is countable from the
/// CV.
class StatRail extends StatelessWidget {
  const StatRail({super.key, required this.stats});

  final List<Stat> stats;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;

    Widget cell(Stat stat) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(stat.value, style: type.title.copyWith(color: colors.textPrimary)),
        const SizedBox(height: 2),
        Text(
          stat.label,
          style: type.labelSmall.copyWith(color: colors.textSecondary),
        ),
      ],
    );

    return Wrap(
      spacing: AppSpacing.xxl,
      runSpacing: AppSpacing.lg,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (var i = 0; i < stats.length; i++) ...[
          if (i > 0) Container(width: 1, height: 34, color: colors.border),
          cell(stats[i]),
        ],
      ],
    );
  }
}
