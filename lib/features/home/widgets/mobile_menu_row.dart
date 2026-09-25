import 'package:flutter/material.dart';

import 'package:portfolio/core/constants/app_spacing.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/features/home/models/portfolio_section.dart';
import 'package:portfolio/shared/widgets/hover_builder.dart';

/// One numbered section link in the mobile menu.
class MobileMenuRow extends StatelessWidget {
  const MobileMenuRow({
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
    final type = context.type;

    return HoverBuilder(
      onTap: onTap,
      semanticLabel: 'Go to ${section.label}',
      builder: (context, hover, _) => Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            SizedBox(
              width: 34,
              child: Text(
                section.displayIndex,
                style: type.label.copyWith(
                  color: isActive ? colors.primary : colors.textTertiary,
                ),
              ),
            ),
            Text(
              section.label,
              style: type.title.copyWith(
                color: isActive || hover > 0
                    ? colors.primary
                    : colors.textPrimary,
              ),
            ),
            if (isActive) ...[
              const SizedBox(width: AppSpacing.sm),
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: colors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
