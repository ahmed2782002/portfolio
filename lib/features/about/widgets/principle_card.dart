import 'package:flutter/material.dart';

import 'package:portfolio/core/constants/app_spacing.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/data/models/models.dart';
import 'package:portfolio/shared/widgets/hover_card.dart';

/// One numbered working principle.
class PrincipleCard extends StatelessWidget {
  const PrincipleCard({
    super.key,
    required this.index,
    required this.principle,
  });

  final int index;
  final Principle principle;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;

    return HoverCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      borderRadius: AppRadius.brMd,
      lift: 3,
      accentAlpha: 0.45,
      builder: (context, t) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            index.toString().padLeft(2, '0'),
            style: type.label.copyWith(
              color: Color.lerp(colors.textTertiary, colors.primary, t),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            principle.title,
            style: type.subtitle.copyWith(
              color: colors.textPrimary,
              fontSize: type.subtitle.fontSize! * 0.86,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            principle.body,
            style: type.bodySmall.copyWith(color: colors.textSecondary),
          ),
        ],
      ),
    );
  }
}
