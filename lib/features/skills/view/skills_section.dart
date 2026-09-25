import 'package:flutter/material.dart';

import 'package:portfolio/core/constants/app_spacing.dart';
import 'package:portfolio/core/di/app_scope.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/core/utils/responsive.dart';
import 'package:portfolio/features/home/models/portfolio_section.dart';
import 'package:portfolio/features/skills/view_model/skills_view_model.dart';
import 'package:portfolio/features/skills/widgets/skill_panel.dart';
import 'package:portfolio/shared/widgets/responsive_grid.dart';
import 'package:portfolio/shared/widgets/section_header.dart';
import 'package:portfolio/shared/widgets/section_shell.dart';

/// The stack, grouped by what each part is *for*.
///
/// No percentage bars and no five-star ratings: a self-assigned "Flutter 95%"
/// tells a reader nothing. Grouping by purpose does: it shows the shape of the
/// stack and lets a recruiter find the one name they came looking for.
class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = SkillsViewModel(context.repository);
    final section = PortfolioSection.skills;
    final groups = viewModel.groups;

    return SectionShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            index: section.index,
            label: section.label,
            title: 'The stack, grouped\nby what it does.',
          ),
          const SizedBox(height: AppSpacing.x4l),
          ResponsiveGrid(
            columns: responsiveValue(
              context.screen,
              compact: 1,
              medium: 2,
              large: 3,
              xlarge: 4,
            ),
            gap: AppSpacing.md,
            revealInterval: const Duration(milliseconds: 55),
            children: [
              for (var i = 0; i < groups.length; i++)
                SkillPanel(index: i + 1, group: groups[i]),
            ],
          ),
        ],
      ),
    );
  }
}
