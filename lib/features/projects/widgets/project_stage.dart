import 'package:flutter/material.dart';

import 'package:portfolio/core/constants/app_animations.dart';
import 'package:portfolio/core/constants/app_spacing.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/data/models/models.dart';
import 'package:portfolio/features/projects/widgets/screenshots/screenshot_stage.dart';
import 'package:portfolio/features/projects/widgets/screenshots/screenshot_thumbnails.dart';
import 'package:portfolio/features/projects/widgets/shot_counter.dart';
import 'package:portfolio/shared/widgets/app_icon_button.dart';

/// Stage, caption, counter, controls and thumbnails.
class ProjectStage extends StatelessWidget {
  const ProjectStage({
    super.key,
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

        // The caption cross-fades so the eye follows the plate, not the text.
        SizedBox(
          height: 40,
          child: AnimatedSwitcher(
            duration: AppAnimations.base,
            child: Text(
              active.caption,
              key: ValueKey(active.asset),
              style: context.type.bodySmall.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ),
        ),
        Row(
          children: [
            ShotCounter(
              index: shotIndex,
              total: shots.length,
              tint: project.tint,
            ),
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
              onPressed: shotIndex == shots.length - 1 ? null : () => onStep(1),
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
