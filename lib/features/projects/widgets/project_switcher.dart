import 'package:flutter/material.dart';

import '../../../core/constants/app_animations.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../data/models/portfolio_models.dart';
import '../../../shared/widgets/hover_builder.dart';

/// Numbered tabs across the top of the showcase.
///
/// Selecting a project is the primary control of this section, so the tabs are
/// named and numbered rather than reduced to dots — a reader can see how many
/// case studies exist and what each one is before committing a click. Each tab
/// carries its product's own tint, which is the same colour the showcase then
/// uses, so the connection is obvious.
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
        _ProjectTab(
          project: projects[i],
          index: i,
          isActive: i == activeIndex,
          onTap: () => onSelect(i),
          expand: !scrollable,
        ),
    ];

    if (!scrollable) {
      return Row(
        children: [
          for (var i = 0; i < tabs.length; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.xs),
            Expanded(child: tabs[i]),
          ],
        ],
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          for (var i = 0; i < tabs.length; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.xs),
            tabs[i],
          ],
        ],
      ),
    );
  }
}

class _ProjectTab extends StatelessWidget {
  const _ProjectTab({
    required this.project,
    required this.index,
    required this.isActive,
    required this.onTap,
    required this.expand,
  });

  final Project project;
  final int index;
  final bool isActive;
  final VoidCallback onTap;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;

    return HoverBuilder(
      onTap: onTap,
      semanticLabel: 'Show the ${project.name} case study',
      builder: (context, hover, _) {
        final emphasis = isActive ? 1.0 : hover;

        return AnimatedContainer(
          duration: AppAnimations.base,
          curve: AppAnimations.standard,
          width: expand ? null : 210,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm + 2,
          ),
          decoration: BoxDecoration(
            color: Color.lerp(
              colors.card,
              project.tint.withValues(alpha: 0.10),
              emphasis,
            ),
            borderRadius: AppRadius.brSm,
            border: Border.all(
              color: Color.lerp(
                colors.border,
                project.tint.withValues(alpha: isActive ? 0.9 : 0.45),
                emphasis,
              )!,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    (index + 1).toString().padLeft(2, '0'),
                    style: type.labelSmall.copyWith(
                      color: Color.lerp(
                        colors.textTertiary,
                        project.tint,
                        emphasis,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Flexible(
                    child: Text(
                      project.name,
                      style: type.bodyStrong.copyWith(
                        color: colors.textPrimary,
                        fontFamily: 'SpaceGrotesk',
                        letterSpacing: -0.2,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                project.category,
                style: type.labelSmall.copyWith(color: colors.textSecondary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}
