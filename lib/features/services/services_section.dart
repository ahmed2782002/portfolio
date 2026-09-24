import 'package:flutter/material.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/portfolio_models.dart';
import '../../data/portfolio_data.dart';
import '../../shared/animations/reveal_on_scroll.dart';
import '../../shared/widgets/hover_builder.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/section_shell.dart';
import '../home/portfolio_section.dart';

/// The Services section — presents what Ahmed builds and delivers.
///
/// Designed with a soft pastel, modern SaaS aesthetic: rounded white cards,
/// subtle shadows, mint & lavender accents, and crisp Dark Charcoal typography.
class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final section = PortfolioSection.services;
    final services = PortfolioData.services;

    final columns = responsiveValue(
      context.screen,
      compact: 1,
      medium: 2,
      expanded: 2,
      large: 3,
      xlarge: 3,
    );

    return SectionShell(
      background: context.colors.backgroundAlt,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            index: section.index,
            label: section.label,
            title: 'What I bring to\nyour product team.',
            lead:
                'Full-cycle Flutter mobile development from UI engineering '
                'to clean state management, API integration, and third-party services.',
          ),
          const SizedBox(height: AppSpacing.x4l),
          LayoutBuilder(
            builder: (context, constraints) {
              const gap = AppSpacing.lg;
              final width =
                  (constraints.maxWidth - gap * (columns - 1)) / columns;

              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  ...staggered(
                    [
                      for (var i = 0; i < services.length; i++)
                        SizedBox(
                          width: width,
                          child: _ServiceCard(
                            index: i + 1,
                            service: services[i],
                          ),
                        ),
                    ],
                    offsetY: 24,
                    interval: const Duration(milliseconds: 60),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.index, required this.service});

  final int index;
  final ServiceOffering service;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;

    return HoverBuilder(
      notifyCursor: false,
      builder: (context, t, _) {
        final lift = -4.0 * t;

        return Transform.translate(
          offset: Offset(0, lift),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            decoration: BoxDecoration(
              color: Color.lerp(colors.card, colors.cardHover, t),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Color.lerp(
                  colors.border,
                  AppColors.lavenderPurple.withValues(alpha: 0.6),
                  t,
                )!,
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: colors.shadow.withValues(alpha: 0.05 + 0.06 * t),
                  blurRadius: 16 + 12 * t,
                  offset: Offset(0, 6 + 6 * t),
                ),
                if (t > 0)
                  BoxShadow(
                    color: AppColors.lavenderPurple.withValues(alpha: 0.08 * t),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Gradient icon container
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.modernMint.withValues(
                              alpha: colors.isDark ? 0.30 : 0.45,
                            ),
                            AppColors.lavenderPurple.withValues(
                              alpha: colors.isDark ? 0.30 : 0.35,
                            ),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppColors.lavenderPurple.withValues(
                            alpha: 0.3,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          service.icon,
                          size: 22,
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (service.badge != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.modernMint.withValues(
                            alpha: colors.isDark ? 0.22 : 0.35,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.modernMint.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Text(
                          service.badge!,
                          style: type.labelSmall.copyWith(
                            color: colors.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  service.title,
                  style: type.title.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  service.description,
                  style: type.body.copyWith(
                    color: colors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Container(height: 1, color: colors.border),
                const SizedBox(height: AppSpacing.md),
                // Deliverable bullet items
                for (final item in service.deliverables)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: AppColors.modernMint.withValues(
                              alpha: colors.isDark ? 0.25 : 0.40,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check_rounded,
                            size: 10,
                            color: colors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            item,
                            style: type.bodySmall.copyWith(
                              color: colors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
