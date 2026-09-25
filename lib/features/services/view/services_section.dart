import 'package:flutter/material.dart';

import 'package:portfolio/core/constants/app_spacing.dart';
import 'package:portfolio/core/di/app_scope.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/core/utils/responsive.dart';
import 'package:portfolio/features/home/models/portfolio_section.dart';
import 'package:portfolio/features/services/view_model/services_view_model.dart';
import 'package:portfolio/features/services/widgets/service_card.dart';
import 'package:portfolio/shared/widgets/responsive_grid.dart';
import 'package:portfolio/shared/widgets/section_header.dart';
import 'package:portfolio/shared/widgets/section_shell.dart';

/// What Ahmed builds and delivers, as a grid of service cards.
class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = ServicesViewModel(context.repository);
    final section = PortfolioSection.services;

    return SectionShell(
      background: context.colors.backgroundAlt,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            index: section.index,
            label: section.label,
            title: 'What I bring to\nyour product team.',
            lead:
                'Full-cycle Flutter mobile development from UI engineering '
                'to clean state management, API integration, and third-party '
                'services.',
          ),
          const SizedBox(height: AppSpacing.x4l),
          ResponsiveGrid(
            columns: responsiveValue(
              context.screen,
              compact: 1,
              medium: 2,
              large: 3,
            ),
            gap: AppSpacing.lg,
            revealOffset: 24,
            revealInterval: const Duration(milliseconds: 60),
            children: [
              for (final service in viewModel.services)
                ServiceCard(service: service),
            ],
          ),
        ],
      ),
    );
  }
}
