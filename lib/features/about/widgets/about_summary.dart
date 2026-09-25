import 'package:flutter/material.dart';

import 'package:portfolio/core/constants/app_spacing.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/shared/animations/reveal_on_scroll.dart';

/// The CV summary, followed by a pull quote on adaptability.
class AboutSummary extends StatelessWidget {
  const AboutSummary({super.key, required this.summary});

  final String summary;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RevealOnScroll(
          child: Text(
            summary,
            style: type.bodyLarge.copyWith(
              color: colors.textSecondary,
              height: 1.75,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        RevealOnScroll(
          delay: const Duration(milliseconds: 80),
          child: Container(
            padding: const EdgeInsets.only(left: AppSpacing.lg),
            decoration: BoxDecoration(
              border: Border(left: BorderSide(color: colors.primary, width: 2)),
            ),
            child: Text(
              'Comfortable moving between product domains — and picking up each '
              "project's structure and business logic without a long ramp.",
              style: type.subtitle.copyWith(color: colors.textPrimary),
            ),
          ),
        ),
      ],
    );
  }
}
