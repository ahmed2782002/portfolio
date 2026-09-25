import 'package:flutter/material.dart';

import 'package:portfolio/core/constants/app_spacing.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/core/utils/responsive.dart';
import 'package:portfolio/data/models/models.dart';
import 'package:portfolio/features/projects/widgets/additional_project_card.dart';
import 'package:portfolio/shared/animations/reveal_on_scroll.dart';
import 'package:portfolio/shared/widgets/responsive_grid.dart';

/// Projects the CV names but supplies no screenshots for.
///
/// They are listed rather than padded out with stock imagery: an honest index
/// of everything else he has touched.
class AdditionalWork extends StatelessWidget {
  const AdditionalWork({super.key, required this.projects});

  final List<AdditionalProject> projects;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RevealOnScroll(
          offsetY: 16,
          child: Row(
            children: [
              Text(
                'ALSO SHIPPED',
                style: type.label.copyWith(color: colors.textSecondary),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                '${projects.length} more',
                style: type.label.copyWith(color: colors.textTertiary),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: Container(height: 1, color: colors.border)),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        ResponsiveGrid(
          columns: responsiveValue(
            context.screen,
            compact: 1,
            medium: 2,
            large: 3,
          ),
          gap: AppSpacing.md,
          revealOffset: 18,
          revealInterval: const Duration(milliseconds: 45),
          children: [
            for (final project in projects)
              AdditionalProjectCard(project: project),
          ],
        ),
      ],
    );
  }
}
