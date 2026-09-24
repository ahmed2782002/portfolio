import 'package:flutter/material.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/utils/responsive.dart';
import '../../data/portfolio_data.dart';
import '../../shared/animations/reveal_on_scroll.dart';
import '../../shared/widgets/hover_builder.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/section_shell.dart';
import '../home/portfolio_section.dart';

/// Who he is and how he works, in the fewest words that still say something.
///
/// The summary carries the facts; the four cards below carry the working style,
/// each one traceable to a specific line in the CV's experience section rather
/// than to portfolio boilerplate.
class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final section = PortfolioSection.about;
    final colors = context.colors;
    final stacked = context.isTabletOrBelow;

    return SectionShell(
      background: context.colors.backgroundAlt,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            index: section.index,
            label: section.label,
            title: 'Production Flutter,\nfrom API to interface.',
          ),
          const SizedBox(height: AppSpacing.x4l),

          if (stacked) ...[
            const _Summary(),
            const SizedBox(height: AppSpacing.xxl),
            const _FactsPanel(),
          ] else
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(flex: 7, child: _Summary()),
                  const SizedBox(width: AppSpacing.x4l),
                  Container(width: 1, color: colors.border),
                  const SizedBox(width: AppSpacing.x4l),
                  const Expanded(flex: 4, child: _FactsPanel()),
                ],
              ),
            ),

          const SizedBox(height: AppSpacing.x5l),
          const _PrinciplesGrid(),
        ],
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RevealOnScroll(
          child: Text(
            PortfolioData.profile.summary,
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
              border: Border(
                left: BorderSide(color: colors.primary, width: 2),
              ),
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

/// Education, certifications and languages — the details a recruiter scans for
/// but that don't deserve their own section.
class _FactsPanel extends StatelessWidget {
  const _FactsPanel();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;
    final education = PortfolioData.education;

    Widget block({required String label, required List<Widget> children}) =>
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: type.label.copyWith(color: colors.textTertiary),
            ),
            const SizedBox(height: AppSpacing.sm),
            ...children,
          ],
        );

    Widget line(String primary, String secondary) => Padding(
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
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...staggered(
          [
            block(
              label: 'Education',
              children: [
                line(
                  education.degree,
                  '${education.institution} · ${education.period}',
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            block(
              label: 'Certifications',
              children: [
                for (final certification in PortfolioData.certifications)
                  line(
                    certification.name,
                    [
                      certification.issuer,
                      if (certification.detail.isNotEmpty) certification.detail,
                    ].join(' · '),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            block(
              label: 'Languages',
              children: [
                for (final language in PortfolioData.languages)
                  line(language.name, language.level),
              ],
            ),
          ],
          offsetY: 18,
        ),
      ],
    );
  }
}

/// Four working principles in a responsive grid.
class _PrinciplesGrid extends StatelessWidget {
  const _PrinciplesGrid();

  @override
  Widget build(BuildContext context) {
    final columns = responsiveValue(
      context.screen,
      compact: 1,
      expanded: 2,
      large: 4,
    );
    final principles = PortfolioData.principles;

    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = AppSpacing.md;
        final width =
            (constraints.maxWidth - gap * (columns - 1)) / columns;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            ...staggered(
              [
                for (var i = 0; i < principles.length; i++)
                  SizedBox(
                    width: width,
                    child: _PrincipleCard(
                      index: i + 1,
                      title: principles[i].title,
                      body: principles[i].body,
                    ),
                  ),
              ],
              offsetY: 22,
            ),
          ],
        );
      },
    );
  }
}

class _PrincipleCard extends StatelessWidget {
  const _PrincipleCard({
    required this.index,
    required this.title,
    required this.body,
  });

  final int index;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;

    return HoverBuilder(
      notifyCursor: false,
      builder: (context, t, _) => Transform.translate(
        offset: Offset(0, -3 * t),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: Color.lerp(colors.card, colors.cardHover, t),
            borderRadius: AppRadius.brMd,
            border: Border.all(
              color: Color.lerp(
                colors.border,
                colors.primary.withValues(alpha: 0.45),
                t,
              )!,
            ),
            boxShadow: t == 0
                ? null
                : [
                    BoxShadow(
                      color: colors.shadow,
                      blurRadius: 22 * t,
                      offset: Offset(0, 6 * t),
                    ),
                  ],
          ),
          child: Column(
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
                title,
                style: type.subtitle.copyWith(
                  color: colors.textPrimary,
                  fontSize: type.subtitle.fontSize! * 0.86,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                body,
                style: type.bodySmall.copyWith(color: colors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
