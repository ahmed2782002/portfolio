import 'package:flutter/material.dart';

import 'package:portfolio/core/constants/app_spacing.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/shared/animations/reveal_on_scroll.dart';
import 'package:portfolio/shared/animations/staggered.dart';
import 'package:portfolio/shared/widgets/hover_builder.dart';

/// Numbered contribution rows. The whole row lights on hover, not just the
/// text.
class ExperienceContributions extends StatelessWidget {
  const ExperienceContributions({super.key, required this.highlights});

  final List<String> highlights;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RevealOnScroll(
          offsetY: 16,
          child: Text(
            'KEY CONTRIBUTIONS',
            style: context.type.label.copyWith(
              color: context.colors.textTertiary,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        ...staggered(
          [
            for (var i = 0; i < highlights.length; i++)
              _ContributionRow(
                index: i + 1,
                text: highlights[i],
                isLast: i == highlights.length - 1,
              ),
          ],
          offsetY: 16,
          interval: const Duration(milliseconds: 60),
        ),
      ],
    );
  }
}

class _ContributionRow extends StatelessWidget {
  const _ContributionRow({
    required this.index,
    required this.text,
    required this.isLast,
  });

  final int index;
  final String text;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;

    return HoverBuilder(
      notifyCursor: false,
      builder: (context, t, _) => Container(
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(bottom: BorderSide(color: colors.border)),
        ),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 38,
              child: Transform.translate(
                offset: Offset(3 * t, 0),
                child: Text(
                  index.toString().padLeft(2, '0'),
                  style: type.monoIndex.copyWith(
                    color: Color.lerp(colors.textTertiary, colors.primary, t),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Text(
                text,
                style: type.body.copyWith(
                  color: Color.lerp(
                    colors.textSecondary,
                    colors.textPrimary,
                    t,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
