import 'package:flutter/material.dart';

import 'package:portfolio/core/constants/app_spacing.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/features/about/view_model/about_view_model.dart';
import 'package:portfolio/shared/animations/staggered.dart';

/// Education, certifications and languages: the details a recruiter scans for
/// but that don't deserve their own section.
class FactsPanel extends StatelessWidget {
  const FactsPanel({super.key, required this.viewModel});

  final AboutViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final education = viewModel.education;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: staggered([
        _FactBlock(
          label: 'Education',
          lines: [
            (
              education.degree,
              '${education.institution} · ${education.period}',
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        _FactBlock(
          label: 'Certifications',
          lines: [
            for (final certification in viewModel.certifications)
              (
                certification.name,
                [
                  certification.issuer,
                  if (certification.detail.isNotEmpty) certification.detail,
                ].join(' · '),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        _FactBlock(
          label: 'Languages',
          lines: [
            for (final language in viewModel.languages)
              (language.name, language.level),
          ],
        ),
      ], offsetY: 18),
    );
  }
}

/// A labelled group of `(primary, secondary)` lines.
class _FactBlock extends StatelessWidget {
  const _FactBlock({required this.label, required this.lines});

  final String label;
  final List<(String, String)> lines;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: type.label.copyWith(color: colors.textTertiary),
        ),
        const SizedBox(height: AppSpacing.sm),
        for (final (primary, secondary) in lines)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  primary,
                  style: type.bodyStrong.copyWith(color: colors.textPrimary),
                ),
                if (secondary.isNotEmpty)
                  Text(
                    secondary,
                    style: type.bodySmall.copyWith(color: colors.textSecondary),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
