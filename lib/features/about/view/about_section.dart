import 'package:flutter/material.dart';

import 'package:portfolio/core/constants/app_spacing.dart';
import 'package:portfolio/core/di/app_scope.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/core/utils/responsive.dart';
import 'package:portfolio/features/about/view_model/about_view_model.dart';
import 'package:portfolio/features/about/widgets/about_summary.dart';
import 'package:portfolio/features/about/widgets/facts_panel.dart';
import 'package:portfolio/features/about/widgets/principle_card.dart';
import 'package:portfolio/features/home/models/portfolio_section.dart';
import 'package:portfolio/shared/widgets/responsive_grid.dart';
import 'package:portfolio/shared/widgets/section_header.dart';
import 'package:portfolio/shared/widgets/section_shell.dart';

/// Who he is and how he works, in the fewest words that still say something.
///
/// The summary carries the facts; the four cards below carry the working style,
/// each one traceable to a specific line in the CV's experience section rather
/// than to portfolio boilerplate.
class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = AboutViewModel(context.repository);
    final section = PortfolioSection.about;
    final colors = context.colors;
    final summary = AboutSummary(summary: viewModel.summary);
    final facts = FactsPanel(viewModel: viewModel);
    final principles = viewModel.principles;

    return SectionShell(
      background: colors.backgroundAlt,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            index: section.index,
            label: section.label,
            title: 'Production Flutter,\nfrom API to interface.',
          ),
          const SizedBox(height: AppSpacing.x4l),
          if (context.isTabletOrBelow) ...[
            summary,
            const SizedBox(height: AppSpacing.xxl),
            facts,
          ] else
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 7, child: summary),
                  const SizedBox(width: AppSpacing.x4l),
                  Container(width: 1, color: colors.border),
                  const SizedBox(width: AppSpacing.x4l),
                  Expanded(flex: 4, child: facts),
                ],
              ),
            ),
          const SizedBox(height: AppSpacing.x5l),
          ResponsiveGrid(
            columns: responsiveValue(
              context.screen,
              compact: 1,
              expanded: 2,
              large: 4,
            ),
            gap: AppSpacing.md,
            children: [
              for (var i = 0; i < principles.length; i++)
                PrincipleCard(index: i + 1, principle: principles[i]),
            ],
          ),
        ],
      ),
    );
  }
}
