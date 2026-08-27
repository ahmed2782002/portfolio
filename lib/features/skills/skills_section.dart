import 'package:flutter/material.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/portfolio_models.dart';
import '../../data/portfolio_data.dart';
import '../../shared/animations/reveal_on_scroll.dart';
import '../../shared/widgets/hover_builder.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/section_shell.dart';
import '../../shared/widgets/tech_chip.dart';
import '../home/portfolio_section.dart';

/// The stack, grouped by what each part is *for*.
///
/// No percentage bars and no five-star ratings — a self-assigned "Flutter 95%"
/// tells a reader nothing. Grouping by purpose does: it shows the shape of the
/// stack and lets a recruiter find the one name they came looking for.
class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final section = PortfolioSection.skills;
    final groups = PortfolioData.skillGroups;

    final columns = responsiveValue(
      context.screen,
      compact: 1,
      medium: 2,
      expanded: 2,
      large: 3,
      xlarge: 4,
    );

    return SectionShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            index: section.index,
            label: section.label,
            title: 'The stack, grouped\nby what it does.',
          ),
          const SizedBox(height: AppSpacing.x4l),
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
                      for (var i = 0; i < groups.length; i++)
                        SizedBox(
                          width: width,
                          child: _SkillPanel(index: i + 1, group: groups[i]),
                        ),
                    ],
                    offsetY: 22,
                    interval: const Duration(milliseconds: 55),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SkillPanel extends StatelessWidget {
  const _SkillPanel({required this.index, required this.group});

  final int index;
  final SkillGroup group;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;

    return HoverBuilder(
      notifyCursor: false,
      builder: (context, t, _) => Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
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
          boxShadow: t == 0
              ? null
              : [
                  BoxShadow(
                    color: colors.shadow,
                    blurRadius: 26 * t,
                    offset: Offset(0, 8 * t),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  index.toString().padLeft(2, '0'),
                  style: type.label.copyWith(
                    color: Color.lerp(colors.textTertiary, colors.primary, t),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Container(
                    height: 1,
                    color: Color.lerp(
                      colors.border,
                      colors.primary.withValues(alpha: 0.35),
                      t,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              group.title,
              style: type.bodyStrong.copyWith(
                color: colors.textPrimary,
                fontFamily: 'SpaceGrotesk',
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TechChipRail(items: group.items, dense: true),
          ],
        ),
      ),
    );
  }
}
