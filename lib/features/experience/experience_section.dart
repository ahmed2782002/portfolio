import 'package:flutter/material.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/extensions/context_extensions.dart';
import '../../data/models/portfolio_models.dart';
import '../../data/portfolio_data.dart';
import '../../shared/animations/reveal_on_scroll.dart';
import '../../shared/widgets/hover_builder.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/section_shell.dart';
import '../../shared/widgets/tech_chip.dart';
import '../home/portfolio_section.dart';

/// Professional experience.
///
/// Not a timeline. With a single continuous role, a vertical rail of dots would
/// be decoration around one entry — so the role gets a full-width record
/// instead: identity pinned to the left, contributions numbered on the right,
/// and the products touched listed as their own rail. It scans in one pass.
class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final section = PortfolioSection.experience;

    return SectionShell(
      background: context.colors.backgroundAlt,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            index: section.index,
            label: section.label,
            title: 'What the job actually\nlooked like.',
            lead: 'Over a year of continuous production work across a '
                'portfolio of client applications.',
          ),
          const SizedBox(height: AppSpacing.x4l),
          for (final entry in PortfolioData.experience)
            _ExperienceRecord(entry: entry),
        ],
      ),
    );
  }
}

class _ExperienceRecord extends StatelessWidget {
  const _ExperienceRecord({required this.entry});

  final ExperienceEntry entry;

  @override
  Widget build(BuildContext context) {
    final stacked = context.isTabletOrBelow;
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: AppRadius.brLg,
        border: Border.all(color: colors.border),
      ),
      padding: EdgeInsets.all(stacked ? AppSpacing.xl : AppSpacing.x3l),
      child: stacked
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Identity(entry: entry),
                const SizedBox(height: AppSpacing.xxl),
                _Contributions(entry: entry),
              ],
            )
          : IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 4, child: _Identity(entry: entry)),
                  const SizedBox(width: AppSpacing.x3l),
                  Container(width: 1, color: colors.border),
                  const SizedBox(width: AppSpacing.x3l),
                  Expanded(flex: 7, child: _Contributions(entry: entry)),
                ],
              ),
            ),
    );
  }
}

class _Identity extends StatelessWidget {
  const _Identity({required this.entry});

  final ExperienceEntry entry;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;

    Widget meta(String label, String value) => Padding(
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RevealOnScroll(
          child: Builder(builder: (context) {
            final isCurrent =
                entry.period.toLowerCase().contains('present');
            final indicatorColor =
                isCurrent ? colors.success : colors.textTertiary;
            final labelText = isCurrent ? 'CURRENT ROLE' : 'PAST ROLE';
            return Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: indicatorColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  labelText,
                  style: type.label.copyWith(color: indicatorColor),
                ),
              ],
            );
          }),
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
              meta('Period', entry.period),
              meta('Location', '${entry.workMode} · ${entry.location}'),
              meta('Products', entry.products.join(' · ')),
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

/// Numbered contribution rows. The index column doubles as the hover target,
/// which is why the whole row lights rather than just the text.
class _Contributions extends StatelessWidget {
  const _Contributions({required this.entry});

  final ExperienceEntry entry;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RevealOnScroll(
          offsetY: 16,
          child: Text(
            'KEY CONTRIBUTIONS',
            style: context.type.label.copyWith(color: colors.textTertiary),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        ...staggered(
          [
            for (var i = 0; i < entry.highlights.length; i++)
              _ContributionRow(
                index: i + 1,
                text: entry.highlights[i],
                isLast: i == entry.highlights.length - 1,
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
                  color: Color.lerp(colors.textSecondary, colors.textPrimary, t),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
