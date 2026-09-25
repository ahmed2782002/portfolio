import 'package:flutter/material.dart';

import 'package:portfolio/core/constants/app_spacing.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/data/models/models.dart';
import 'package:portfolio/features/experience/widgets/experience_contributions.dart';
import 'package:portfolio/features/experience/widgets/experience_identity.dart';

/// One role as a full-width card: identity on the left, contributions on the
/// right (stacked on narrow layouts).
class ExperienceRecord extends StatelessWidget {
  const ExperienceRecord({
    super.key,
    required this.entry,
    required this.isCurrent,
  });

  final ExperienceEntry entry;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    final stacked = context.isTabletOrBelow;
    final colors = context.colors;
    final identity = ExperienceIdentity(entry: entry, isCurrent: isCurrent);
    final contributions = ExperienceContributions(highlights: entry.highlights);

    return Container(
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: AppRadius.brLg,
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: EdgeInsets.all(stacked ? AppSpacing.xl : AppSpacing.x3l),
      child: stacked
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                identity,
                const SizedBox(height: AppSpacing.xxl),
                contributions,
              ],
            )
          : IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 4, child: identity),
                  const SizedBox(width: AppSpacing.x3l),
                  Container(width: 1, color: colors.border),
                  const SizedBox(width: AppSpacing.x3l),
                  Expanded(flex: 7, child: contributions),
                ],
              ),
            ),
    );
  }
}
