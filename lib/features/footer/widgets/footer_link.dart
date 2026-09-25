import 'package:flutter/material.dart';

import 'package:portfolio/core/constants/app_spacing.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/shared/widgets/hover_builder.dart';

/// A text link on the footer surface: muted at rest, mint on hover.
class FooterLink extends StatelessWidget {
  const FooterLink({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.small = false,
  });

  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final rest = context.colors.onFooter.withValues(alpha: 0.72);
    final style = small ? context.type.labelSmall : context.type.bodySmall;

    return HoverBuilder(
      onTap: onTap,
      enabled: onTap != null,
      notifyCursor: onTap != null,
      semanticLabel: label,
      builder: (context, t, _) {
        final color = Color.lerp(rest, AppColors.modernMint, t)!;
        return Transform.translate(
          offset: Offset(3 * t, 0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: small ? 14 : 16, color: color),
                const SizedBox(width: AppSpacing.xs),
              ],
              Flexible(
                child: Text(
                  label,
                  style: style.copyWith(color: color),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
