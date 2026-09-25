import 'package:flutter/material.dart';

import 'package:portfolio/core/constants/app_spacing.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/data/models/models.dart';
import 'package:portfolio/shared/animations/reveal_on_scroll.dart';
import 'package:portfolio/shared/widgets/tech_chip.dart';

/// Status, role, company, period/location/products and the stack.
class ExperienceIdentity extends StatelessWidget {
  const ExperienceIdentity({
    super.key,
    required this.entry,
    required this.isCurrent,
  });

  final ExperienceEntry entry;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;
    final indicator = isCurrent ? colors.success : colors.textTertiary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RevealOnScroll(
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: indicator,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                isCurrent ? 'CURRENT ROLE' : 'PAST ROLE',
                style: type.label.copyWith(color: indicator),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        RevealOnScroll(
          delay: const Duration(milliseconds: 60),
          child: Text(
            entry.role,
            style: type.title.copyWith(color: colors.textPrimary),
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        RevealOnScroll(
          delay: const Duration(milliseconds: 90),
          child: Text(
            entry.company,
            style: type.subtitle.copyWith(color: colors.primary),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        RevealOnScroll(
          delay: const Duration(milliseconds: 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _MetaRow(label: 'Period', value: entry.period),
              _MetaRow(
                label: 'Location',
                value: '${entry.workMode} · ${entry.location}',
              ),
              _MetaRow(label: 'Products', value: entry.products.join(' · ')),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        RevealOnScroll(
          delay: const Duration(milliseconds: 150),
          child: TechChipRail(items: entry.technologies, dense: true),
        ),
      ],
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 76,
            child: Text(
              label.toUpperCase(),
              style: type.labelSmall.copyWith(color: colors.textTertiary),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: type.bodySmall.copyWith(color: colors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
