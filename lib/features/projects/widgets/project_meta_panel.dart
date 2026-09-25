import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:portfolio/core/constants/app_spacing.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/data/models/models.dart';
import 'package:portfolio/shared/widgets/tech_chip.dart';

/// The written half of a project case study.
///
/// Ordered the way someone actually reads a product page: what it is, what it
/// does, what he did on it, then the stack. Everything on it comes from the CV
/// or is visible in the screenshots beside it.
class ProjectMetaPanel extends StatelessWidget {
  const ProjectMetaPanel({super.key, required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(
                color: project.tint.withValues(alpha: 0.12),
                borderRadius: AppRadius.brXs,
                border: Border.all(color: project.tint.withValues(alpha: 0.35)),
              ),
              child: Text(
                project.category.toUpperCase(),
                style: type.labelSmall.copyWith(color: project.tint),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),

        Text(
          project.name,
          style: type.display2.copyWith(
            color: colors.textPrimary,
            fontSize: type.display2.fontSize! * 0.72,
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        Text(
          project.description,
          style: type.body.copyWith(color: colors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.xl),

        _MetaGrid(project: project),
        const SizedBox(height: AppSpacing.xl),

        Text(
          'KEY FEATURES',
          style: type.label.copyWith(color: colors.textTertiary),
        ),
        const SizedBox(height: AppSpacing.sm),
        for (final feature in project.features)
          _FeatureRow(text: feature, tint: project.tint),
        const SizedBox(height: AppSpacing.xl),

        Text(
          'BUILT WITH',
          style: type.label.copyWith(color: colors.textTertiary),
        ),
        const SizedBox(height: AppSpacing.sm),
        TechChipRail(
          items: project.technologies,
          accent: project.tint,
          dense: true,
        ),
      ],
    );
  }
}

/// Role / platform / context, as a labelled key-value block.
class _MetaGrid extends StatelessWidget {
  const _MetaGrid({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;

    final entries = <({String label, String value})>[
      (label: 'My role', value: project.role),
      (label: 'Platform', value: project.platform),
      (label: 'Context', value: project.context),
    ];

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: colors.border),
          bottom: BorderSide(color: colors.border),
        ),
      ),
      child: Column(
        children: [
          for (var i = 0; i < entries.length; i++)
            Container(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              decoration: BoxDecoration(
                border: i == entries.length - 1
                    ? null
                    : Border(bottom: BorderSide(color: colors.border)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 92,
                    child: Text(
                      entries[i].label.toUpperCase(),
                      style: type.labelSmall.copyWith(
                        color: colors.textTertiary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      entries[i].value,
                      style: type.bodySmall.copyWith(color: colors.textPrimary),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.text, required this.tint});

  final String text;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // A small rotated square instead of a bullet — the same geometric
          // language as the section rules and the device corners.
          Padding(
            padding: const EdgeInsets.only(top: 7, right: AppSpacing.sm),
            child: Transform.rotate(
              angle: math.pi / 4,
              child: Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  color: tint,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: context.type.bodySmall.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
