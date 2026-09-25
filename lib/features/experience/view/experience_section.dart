import 'package:flutter/material.dart';

import 'package:portfolio/core/constants/app_spacing.dart';
import 'package:portfolio/core/di/app_scope.dart';
import 'package:portfolio/features/experience/view_model/experience_view_model.dart';
import 'package:portfolio/features/experience/widgets/experience_record.dart';
import 'package:portfolio/features/home/models/portfolio_section.dart';
import 'package:portfolio/shared/widgets/section_header.dart';
import 'package:portfolio/shared/widgets/section_shell.dart';

/// Professional experience.
///
/// Not a timeline. With a single continuous role, a vertical rail of dots would
/// be decoration around one entry, so the role gets a full-width record
/// instead: identity pinned to the left, contributions numbered on the right,
/// and the products touched listed as their own rail. It scans in one pass.
class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = ExperienceViewModel(context.repository);
    final section = PortfolioSection.experience;

    return SectionShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            index: section.index,
            label: section.label,
            title: 'What the job actually\nlooked like.',
            lead:
                'Over a year of continuous production work across a '
                'portfolio of client applications.',
          ),
          const SizedBox(height: AppSpacing.x4l),
          for (final entry in viewModel.entries)
            ExperienceRecord(
              entry: entry,
              isCurrent: ExperienceViewModel.isCurrent(entry),
            ),
        ],
      ),
    );
  }
}
