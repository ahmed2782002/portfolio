import 'package:flutter/material.dart';

import 'package:portfolio/core/constants/app_spacing.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/data/models/models.dart';
import 'package:portfolio/shared/widgets/hover_card.dart';
import 'package:portfolio/shared/widgets/tech_chip.dart';

/// One skill group: a numbered rule, the group title and its chips.
class SkillPanel extends StatelessWidget {
  const SkillPanel({super.key, required this.index, required this.group});

  final int index;
  final SkillGroup group;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;

    return HoverCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      borderRadius: AppRadius.brMd,
      lift: 0,
      accentAlpha: 0.4,
      builder: (context, t) => Column(
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
    );
  }
}
