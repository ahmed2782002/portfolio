import 'package:flutter/material.dart';

import '../../../core/constants/app_animations.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../data/models/portfolio_models.dart';
import '../../../shared/widgets/hover_builder.dart';

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
        _ProjectTab(
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
          transform: Matrix4.translationValues(0.0, isActive ? -2.0 : -3.0 * hover, 0.0),
          width: expand ? null : 236,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md - 2,
          ),
          decoration: BoxDecoration(
            color: Color.lerp(
              colors.card,
              project.tint.withValues(alpha: colors.isDark ? 0.16 : 0.08),
              emphasis,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Color.lerp(
                colors.border,
                project.tint.withValues(alpha: isActive ? 0.95 : 0.45),
                emphasis,
              )!,
              width: isActive ? 1.5 : 1.0,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: project.tint.withValues(alpha: colors.isDark ? 0.28 : 0.16),
                      blurRadius: 18,
                      offset: const Offset(0, 5),
                    ),
                  ]
                : (hover > 0.1
                    ? [
                        BoxShadow(
                          color: colors.shadow,
                          blurRadius: 12 * hover,
                          offset: Offset(0, 4 * hover),
                        ),
                      ]
                    : null),
          ),
          child: Row(
            children: [
              // 1. Bespoke Project Icon Badge
              AnimatedContainer(
                duration: AppAnimations.base,
                curve: AppAnimations.standard,
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: project.tint.withValues(
                    alpha: isActive ? (colors.isDark ? 0.26 : 0.18) : (0.08 + 0.08 * hover),
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: project.tint.withValues(alpha: isActive ? 0.6 : 0.25),
                    width: 1,
                  ),
                ),
                child: project.iconAsset != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(11),
                        child: Image.asset(
                          project.iconAsset!,
                          fit: BoxFit.cover,
                          cacheWidth: 120,
                          filterQuality: FilterQuality.medium,
                        ),
                      )
                    : Center(
                        child: Icon(
                          project.icon,
                          size: 20,
                          color: project.tint,
                        ),
                      ),
              ),
              const SizedBox(width: AppSpacing.sm),

              // 2. Project Name and Domain Category
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            project.name,
                            style: type.bodyStrong.copyWith(
                              color: colors.textPrimary,
                              fontFamily: 'SpaceGrotesk',
                              fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                              letterSpacing: -0.2,
                              fontSize: 14.5,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isActive) ...[
                          const SizedBox(width: 6),
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: project.tint,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: project.tint.withValues(alpha: 0.8),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      project.category,
                      style: type.labelSmall.copyWith(
                        color: Color.lerp(
                          colors.textSecondary,
                          project.tint,
                          isActive ? 0.7 : 0.0,
                        ),
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // 3. Subtle Index tag
              Text(
                '0${index + 1}',
                style: type.labelSmall.copyWith(
                  color: Color.lerp(
                    colors.textTertiary.withValues(alpha: 0.6),
                    project.tint.withValues(alpha: 0.8),
                    emphasis,
                  ),
                  fontFamily: 'JetBrainsMono',
                  fontSize: 10,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

