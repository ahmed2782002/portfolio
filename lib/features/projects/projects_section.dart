import 'package:flutter/material.dart';

import '../../core/constants/app_animations.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/portfolio_models.dart';
import '../../data/portfolio_data.dart';
import '../../shared/animations/reveal_on_scroll.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/hover_builder.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/section_shell.dart';
import '../home/portfolio_section.dart';
import 'widgets/project_meta_panel.dart';
import 'widgets/project_switcher.dart';
import 'widgets/screenshot_stage.dart';

/// The heart of the site.
///
/// Each project is a small case study rather than a card: what it is, what he
/// did on it, what it is built from, and its screens presented in a depth
/// carousel. Only one case is mounted at a time, which keeps the reading focused
/// and means a visitor only ever downloads the screenshots they are looking at.
class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  int _projectIndex = 0;
  int _shotIndex = 0;

  List<Project> get _projects => PortfolioData.projects;
  Project get _project => _projects[_projectIndex];

  void _selectProject(int index) {
    if (index == _projectIndex) return;
    setState(() {
      _projectIndex = index;
      _shotIndex = 0;
    });
  }

  void _selectShot(int index) {
    if (index == _shotIndex) return;
    setState(() => _shotIndex = index);
  }

  void _step(int delta) {
    final count = _project.screenshots.length;
    _selectShot((_shotIndex + delta).clamp(0, count - 1));
  }

  @override
  Widget build(BuildContext context) {
    final section = PortfolioSection.projects;

    return SectionShell(
      background: context.colors.backgroundAlt,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            index: section.index,
            label: 'Selected work',
            title: 'Four products,\nshipped end to end.',
            lead: 'Booking, delivery, social and ticketing — each one a '
                'different domain, a different team and a different set of '
                'constraints.',
          ),
          const SizedBox(height: AppSpacing.xxl),

          RevealOnScroll(
            offsetY: 18,
            child: ProjectSwitcher(
              projects: _projects,
              activeIndex: _projectIndex,
              onSelect: _selectProject,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),

          // The case study itself. Cross-fading on the project id makes the
          // switch feel like one panel changing rather than a page reloading.
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
            child: _ProjectShowcase(
              key: ValueKey(_project.id),
              project: _project,
              shotIndex: _shotIndex,
              onSelectShot: _selectShot,
              onStep: _step,
            ),
          ),

          const SizedBox(height: AppSpacing.x5l),
          const _AdditionalWork(),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// One case study
// -----------------------------------------------------------------------------

class _ProjectShowcase extends StatelessWidget {
  const _ProjectShowcase({
    super.key,
    required this.project,
    required this.shotIndex,
    required this.onSelectShot,
    required this.onStep,
  });

  final Project project;
  final int shotIndex;
  final ValueChanged<int> onSelectShot;
  final ValueChanged<int> onStep;

  @override
  Widget build(BuildContext context) {
    final stacked = context.isTabletOrBelow;
    final colors = context.colors;

    final stageHeight = responsiveValue(
      context.screen,
      compact: 380.0,
      medium: 430.0,
      expanded: 470.0,
      large: 520.0,
      xlarge: 560.0,
    );

    final stage = _Stage(
      project: project,
      shotIndex: shotIndex,
      onSelectShot: onSelectShot,
      onStep: onStep,
      height: stageHeight,
    );

    final meta = ProjectMetaPanel(project: project);

    return Container(
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: AppRadius.brXl,
        border: Border.all(color: colors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // A wash of the product's own brand colour, so each case study feels
          // like its own thing without breaking the site palette.
          Positioned(
            right: -120,
            top: -120,
            width: 420,
            height: 420,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      project.tint.withValues(alpha: colors.isDark ? 0.16 : 0.10),
                      project.tint.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(stacked ? AppSpacing.xl : AppSpacing.x3l),
            child: stacked
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      stage,
                      const SizedBox(height: AppSpacing.xxl),
                      meta,
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 5, child: meta),
                      const SizedBox(width: AppSpacing.x3l),
                      Expanded(flex: 6, child: stage),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

/// Stage, caption, counter, controls and thumbnails.
class _Stage extends StatelessWidget {
  const _Stage({
    required this.project,
    required this.shotIndex,
    required this.onSelectShot,
    required this.onStep,
    required this.height,
  });

  final Project project;
  final int shotIndex;
  final ValueChanged<int> onSelectShot;
  final ValueChanged<int> onStep;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;
    final shots = project.screenshots;
    final active = shots[shotIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ScreenshotStage(
          screenshots: shots,
          activeIndex: shotIndex,
          onSelect: onSelectShot,
          tint: project.tint,
          height: height,
        ),
        const SizedBox(height: AppSpacing.lg),

        // Caption swaps with a short cross-fade so the eye follows the plate,
        // not the text.
        SizedBox(
          height: 40,
          child: AnimatedSwitcher(
            duration: AppAnimations.base,
            child: Text(
              active.caption,
              key: ValueKey(active.asset),
              style: type.bodySmall.copyWith(color: colors.textSecondary),
            ),
          ),
        ),

        Row(
          children: [
            _Counter(index: shotIndex, total: shots.length, tint: project.tint),
            const Spacer(),
            AppIconButton(
              icon: Icons.arrow_back_rounded,
              tooltip: 'Previous screenshot',
              size: 38,
              accent: project.tint,
              onPressed: shotIndex == 0 ? null : () => onStep(-1),
            ),
            const SizedBox(width: AppSpacing.xs),
            AppIconButton(
              icon: Icons.arrow_forward_rounded,
              tooltip: 'Next screenshot',
              size: 38,
              accent: project.tint,
              onPressed:
                  shotIndex == shots.length - 1 ? null : () => onStep(1),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),

        ScreenshotThumbnails(
          screenshots: shots,
          activeIndex: shotIndex,
          onSelect: onSelectShot,
          tint: project.tint,
        ),
      ],
    );
  }
}

/// `02 / 04` with a progress rule that fills as you move through the set.
class _Counter extends StatelessWidget {
  const _Counter({
    required this.index,
    required this.total,
    required this.tint,
  });

  final int index;
  final int total;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          (index + 1).toString().padLeft(2, '0'),
          style: type.monoIndex.copyWith(color: colors.textPrimary),
        ),
        const SizedBox(width: AppSpacing.xs),
        SizedBox(
          width: 46,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Container(height: 1.5, color: colors.border),
              AnimatedFractionallySizedBox(
                duration: AppAnimations.deep,
                curve: AppAnimations.emphasized,
                widthFactor: total <= 1 ? 1 : (index + 1) / total,
                alignment: Alignment.centerLeft,
                child: Container(height: 1.5, color: tint),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          total.toString().padLeft(2, '0'),
          style: type.monoIndex.copyWith(color: colors.textTertiary),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// Additional work
// -----------------------------------------------------------------------------

/// Projects the CV names but supplies no screenshots for.
///
/// They are listed rather than padded out with stock imagery — an honest index
/// of everything else he has touched.
class _AdditionalWork extends StatelessWidget {
  const _AdditionalWork();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;
    final items = PortfolioData.additionalProjects;

    final columns = responsiveValue(
      context.screen,
      compact: 1,
      medium: 2,
      expanded: 2,
      large: 3,
    );

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
                '${items.length} more',
                style: type.label.copyWith(color: colors.textTertiary),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: Container(height: 1, color: colors.border)),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        LayoutBuilder(
          builder: (context, constraints) {
            const gap = AppSpacing.md;
            final width =
                (constraints.maxWidth - gap * (columns - 1)) / columns;

            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: [
                ...staggered(
                  [
                    for (final item in items)
                      SizedBox(
                        width: width,
                        child: _AdditionalCard(project: item),
                      ),
                  ],
                  offsetY: 18,
                  interval: const Duration(milliseconds: 45),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _AdditionalCard extends StatelessWidget {
  const _AdditionalCard({required this.project});

  final AdditionalProject project;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;

    return HoverBuilder(
      notifyCursor: false,
      builder: (context, t, _) => Transform.translate(
        offset: Offset(0, -3 * t),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: Color.lerp(colors.card, colors.cardHover, t),
            borderRadius: AppRadius.brMd,
            border: Border.all(
              color: Color.lerp(
                colors.border,
                colors.primary.withValues(alpha: 0.4),
                t,
              )!,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      project.name,
                      style: type.subtitle.copyWith(
                        color: colors.textPrimary,
                        fontSize: type.subtitle.fontSize! * 0.85,
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(3 * t, -3 * t),
                    child: Icon(
                      Icons.north_east_rounded,
                      size: 15,
                      color: Color.lerp(
                        colors.textTertiary,
                        colors.primary,
                        t,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                project.category,
                style: type.labelSmall.copyWith(color: colors.textTertiary),
              ),
              if (project.description != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  project.description!,
                  style: type.bodySmall.copyWith(color: colors.textSecondary),
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              Container(height: 1, color: colors.border),
              const SizedBox(height: AppSpacing.sm),
              Text(
                project.contribution,
                style: type.labelSmall.copyWith(color: colors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
