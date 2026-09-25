import 'package:flutter/material.dart';

import 'package:portfolio/core/constants/app_animations.dart';
import 'package:portfolio/core/constants/app_spacing.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/features/home/models/portfolio_section.dart';
import 'package:portfolio/shared/widgets/hover_builder.dart';

/// A nav link. The active-section indicator is an underline that grows on the
/// current item as it shrinks on the last, so the travel reads as one
/// indicator moving.
class NavItem extends StatelessWidget {
  const NavItem({
    super.key,
    required this.section,
    required this.isActive,
    required this.onTap,
  });

  final PortfolioSection section;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return HoverBuilder(
      onTap: onTap,
      semanticLabel: 'Go to ${section.label}',
      builder: (context, hover, _) {
        final emphasis = isActive ? 1.0 : hover;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                section.label,
                style: context.type.bodySmall.copyWith(
                  color: Color.lerp(
                    colors.textSecondary,
                    isActive ? colors.textPrimary : colors.primary,
                    emphasis,
                  ),
                  fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
              const SizedBox(height: 5),
              // The indicator: full width when active, a short stub on hover.
              AnimatedContainer(
                duration: AppAnimations.base,
                curve: AppAnimations.emphasized,
                height: 2,
                width: isActive ? 18 : 10 * hover,
                decoration: BoxDecoration(
                  color: isActive
                      ? colors.primary
                      : colors.primary.withValues(alpha: 0.5 * hover),
                  borderRadius: AppRadius.brPill,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
