import 'package:flutter/material.dart';

import 'package:portfolio/core/constants/app_spacing.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/core/utils/responsive.dart';
import 'package:portfolio/data/models/models.dart';
import 'package:portfolio/features/projects/widgets/project_meta_panel.dart';
import 'package:portfolio/features/projects/widgets/project_stage.dart';

/// One case study: the written panel beside the screenshot stage, on a card
/// washed with the product's own brand colour.
class ProjectShowcase extends StatelessWidget {
  const ProjectShowcase({
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

    final stage = ProjectStage(
      project: project,
      shotIndex: shotIndex,
      onSelectShot: onSelectShot,
      onStep: onStep,
      height: responsiveValue(
        context.screen,
        compact: 380.0,
        medium: 430.0,
        expanded: 470.0,
        large: 520.0,
        xlarge: 560.0,
      ),
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
          // Each case study feels like its own product without breaking the
          // site palette.
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
                      project.tint.withValues(
                        alpha: colors.isDark ? 0.16 : 0.10,
                      ),
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
