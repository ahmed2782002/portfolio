import 'package:flutter/material.dart';

import 'package:portfolio/core/constants/app_spacing.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/data/models/models.dart';
import 'package:portfolio/features/services/widgets/service_parts.dart';
import 'package:portfolio/shared/widgets/hover_builder.dart';

/// One service: icon, optional badge, title, description and deliverables.
///
/// Rounded card with a permanent soft shadow that deepens, plus a lavender
/// glow, on hover.
class ServiceCard extends StatelessWidget {
  const ServiceCard({super.key, required this.service});

  final ServiceOffering service;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return HoverBuilder(
      notifyCursor: false,
      child: _ServiceContent(service: service),
      builder: (context, t, content) => Transform.translate(
        offset: Offset(0, -4.0 * t),
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
          child: content,
        ),
      ),
    );
  }
}

/// The card body. It does not react to hover, so it is built once and reused
/// across hover frames.
class _ServiceContent extends StatelessWidget {
  const _ServiceContent({required this.service});

  final ServiceOffering service;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ServiceIconBadge(icon: service.icon),
            const Spacer(),
            if (service.badge != null) ServiceBadge(label: service.badge!),
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
          style: type.body.copyWith(color: colors.textSecondary, height: 1.5),
        ),
        const SizedBox(height: AppSpacing.lg),
        Container(height: 1, color: colors.border),
        const SizedBox(height: AppSpacing.md),
        for (final item in service.deliverables) DeliverableRow(text: item),
      ],
    );
  }
}
