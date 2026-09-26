import 'package:flutter/material.dart';

import 'package:portfolio/core/constants/app_animations.dart';
import 'package:portfolio/core/constants/app_spacing.dart';
import 'package:portfolio/core/di/app_scope.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/core/mvvm/view_model_builder.dart';
import 'package:portfolio/features/home/models/portfolio_section.dart';
import 'package:portfolio/features/projects/view_model/projects_view_model.dart';
import 'package:portfolio/features/projects/widgets/additional_work.dart';
import 'package:portfolio/features/projects/widgets/project_showcase.dart';
import 'package:portfolio/features/projects/widgets/project_switcher.dart';
import 'package:portfolio/shared/animations/reveal_on_scroll.dart';
import 'package:portfolio/shared/widgets/section_header.dart';
import 'package:portfolio/shared/widgets/section_shell.dart';

/// The heart of the site.
///
/// Each project is a small case study rather than a card: what it is, what he
/// did on it, what it is built from, and its screens presented in a depth
/// carousel. Only one case is mounted at a time, which keeps the reading focused
/// and means a visitor only ever downloads the screenshots they are looking at.
class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final section = PortfolioSection.projects;

    return ViewModelBuilder<ProjectsViewModel>(
      create: (context) => ProjectsViewModel(context.repository),
      builder: (context, viewModel, _) => SectionShell(
        background: context.colors.backgroundAlt,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              index: section.index,
              label: 'Selected work',
              title:
                  '${viewModel.projects.length} featured products,\n'
                  'from UI to API.',
              lead:
                  'Laundry, consultation, property booking, delivery '
                  'logistics and social — client applications built at Nahr '
                  'Development for the Gulf and Egyptian markets, plus '
                  'YourSeat, my cinema-booking graduation project.',
            ),
            const SizedBox(height: AppSpacing.xxl),
            RevealOnScroll(
              offsetY: 18,
              child: ProjectSwitcher(
                projects: viewModel.projects,
                activeIndex: viewModel.projectIndex,
                onSelect: viewModel.selectProject,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),

            // Cross-fading on the project id makes the switch feel like one
            // panel changing rather than a page reloading.
            AnimatedSwitcher(
              duration: AppAnimations.base,
              switchInCurve: AppAnimations.emphasized,
              switchOutCurve: Curves.easeIn,
              layoutBuilder: (current, previous) => Stack(
                alignment: Alignment.topLeft,
                children: [...previous, ?current],
              ),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.02),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              ),
              // Values, not the ViewModel: the outgoing child must keep showing
              // the old project while it fades out.
              child: ProjectShowcase(
                key: ValueKey(viewModel.project.id),
                project: viewModel.project,
                shotIndex: viewModel.shotIndex,
                onSelectShot: viewModel.selectShot,
                onStep: viewModel.step,
              ),
            ),
            const SizedBox(height: AppSpacing.x5l),
            AdditionalWork(projects: viewModel.additionalProjects),
          ],
        ),
      ),
    );
  }
}
