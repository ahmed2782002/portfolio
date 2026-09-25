import 'package:flutter/material.dart';

import 'package:portfolio/core/constants/app_animations.dart';
import 'package:portfolio/core/constants/app_spacing.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';

/// `02 / 04` with a progress rule that fills as you move through the set.
class ShotCounter extends StatelessWidget {
  const ShotCounter({
    super.key,
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
    final style = context.type.monoIndex;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          (index + 1).toString().padLeft(2, '0'),
          style: style.copyWith(color: colors.textPrimary),
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
          style: style.copyWith(color: colors.textTertiary),
        ),
      ],
    );
  }
}
