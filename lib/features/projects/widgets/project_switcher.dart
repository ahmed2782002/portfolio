import 'package:flutter/material.dart';

import 'package:portfolio/core/constants/app_spacing.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/data/models/models.dart';
import 'package:portfolio/features/projects/widgets/project_tab.dart';

/// Modern interactive card deck switcher for the featured projects.
///
/// Each project features its dedicated domain icon, category badge, and active
/// glowing state that coordinates with the project's brand tint.
class ProjectSwitcher extends StatelessWidget {
  const ProjectSwitcher({
    super.key,
    required this.projects,
    required this.activeIndex,
    required this.onSelect,
  });

  final List<Project> projects;
  final int activeIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final scrollable = context.isTabletOrBelow;

    final tabs = [
      for (var i = 0; i < projects.length; i++)
        ProjectTab(
          project: projects[i],
          index: i,
          isActive: i == activeIndex,
          onTap: () => onSelect(i),
          expand: !scrollable,
        ),
    ];

    if (!scrollable) {
      // A grid of equal-width cards, as many per row as fit at >= 220px.
      return LayoutBuilder(
        builder: (context, constraints) {
          const gap = AppSpacing.sm;
          final columns = ((constraints.maxWidth + gap) / (220 + gap))
              .floor()
              .clamp(1, tabs.length);
          final width = (constraints.maxWidth - gap * (columns - 1)) / columns;
          return Wrap(
            spacing: gap,
            runSpacing: gap,
            children: [
              for (final tab in tabs) SizedBox(width: width, child: tab),
            ],
          );
        },
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      clipBehavior: Clip.none,
      child: Row(
        children: [
          for (var i = 0; i < tabs.length; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.sm),
            tabs[i],
          ],
        ],
      ),
    );
  }
}
