import 'package:flutter/material.dart';

import 'package:portfolio/core/constants/app_spacing.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/shared/widgets/hover_builder.dart';

/// A square icon-only control (theme toggle, carousel arrows, menu button).
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.tooltip,
    this.size = 42,
    this.bordered = true,
    this.accent,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String tooltip;
  final double size;
  final bool bordered;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tint = accent ?? colors.primary;
    final enabled = onPressed != null;

    return Tooltip(
      message: tooltip,
      child: HoverBuilder(
        onTap: onPressed,
        enabled: enabled,
        semanticLabel: tooltip,
        builder: (context, t, _) => Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Color.lerp(
              colors.card,
              tint.withValues(alpha: 0.12),
              enabled ? t : 0,
            ),
            borderRadius: AppRadius.brSm,
            border: bordered
                ? Border.all(
                    color: Color.lerp(colors.border, tint, enabled ? t : 0)!,
                  )
                : null,
          ),
          child: Icon(
            icon,
            size: size * 0.42,
            color: enabled
                ? Color.lerp(colors.textSecondary, tint, t)
                : colors.textTertiary.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}
