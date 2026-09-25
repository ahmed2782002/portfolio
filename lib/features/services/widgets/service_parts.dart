import 'package:flutter/material.dart';

import 'package:portfolio/core/constants/app_spacing.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/core/theme/app_colors.dart';

/// The mint-to-lavender tile holding a service's icon.
class ServiceIconBadge extends StatelessWidget {
  const ServiceIconBadge({super.key, required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.modernMint.withValues(alpha: colors.isDark ? 0.30 : 0.45),
            AppColors.lavenderPurple.withValues(
              alpha: colors.isDark ? 0.30 : 0.35,
            ),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.lavenderPurple.withValues(alpha: 0.3),
        ),
      ),
      child: Icon(icon, size: 22, color: colors.textPrimary),
    );
  }
}

/// A small mint tag such as "Core Focus".
class ServiceBadge extends StatelessWidget {
  const ServiceBadge({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.modernMint.withValues(
          alpha: colors.isDark ? 0.22 : 0.35,
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.modernMint.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: context.type.labelSmall.copyWith(
          color: colors.textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
      ),
    );
  }
}

/// A checkmarked deliverable line.
class DeliverableRow extends StatelessWidget {
  const DeliverableRow({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
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
              text,
              style: context.type.bodySmall.copyWith(
                color: colors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
