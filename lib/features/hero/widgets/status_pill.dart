import 'package:flutter/material.dart';

import 'package:portfolio/core/constants/app_spacing.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/features/hero/widgets/pulse_dot.dart';

/// Live status: the current employer and work mode, from the CV.
class StatusPill extends StatelessWidget {
  const StatusPill({
    super.key,
    required this.text,
    required this.workMode,
    required this.active,
  });

  final String text;
  final String workMode;

  /// Whether the role is ongoing — drives the dot colour.
  final bool active;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final style = context.type.labelSmall;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: AppRadius.brPill,
        border: Border.all(color: colors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          PulseDot(color: active ? colors.success : colors.textTertiary),
          const SizedBox(width: AppSpacing.xs),
          Flexible(
            child: Text(
              text,
              style: style.copyWith(color: colors.textSecondary),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Container(width: 1, height: 11, color: colors.border),
          const SizedBox(width: AppSpacing.xs),
          Text(workMode, style: style.copyWith(color: colors.textTertiary)),
        ],
      ),
    );
  }
}
