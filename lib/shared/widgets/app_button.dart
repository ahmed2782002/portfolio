import 'package:flutter/material.dart';

import 'package:portfolio/core/constants/app_spacing.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/shared/widgets/hover_builder.dart';

enum AppButtonVariant {
  /// Filled indigo. One per screen, reserved for the primary action.
  primary,

  /// Hairline border on the canvas. The default for secondary actions.
  outline,

  /// Text-only with an animated underline. Used inline and in the footer.
  quiet,
}

/// The site's only button.
///
/// Hover does three things at once — the surface warms, the whole control lifts
/// a couple of pixels, and the trailing icon slides forward — which reads as one
/// gesture rather than three separate effects.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.outline,
    this.icon,
    this.expand = false,
    this.accent,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;

  /// Rendered trailing; slides right on hover.
  final IconData? icon;

  /// Stretch to the available width (mobile stacks).
  final bool expand;

  /// Overrides the indigo accent — used by the per-project actions.
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;
    final tint = accent ?? colors.primary;
    final enabled = onPressed != null;

    return HoverBuilder(
      onTap: onPressed,
      enabled: enabled,
      semanticLabel: label,
      builder: (context, t, _) {
        final lift = -2.0 * t;

        final (
          Color background,
          Color foreground,
          Color? border,
        ) = switch (variant) {
          AppButtonVariant.primary => (
            Color.lerp(
              colors.isDark ? colors.primary : colors.textPrimary,
              colors.isDark ? AppColors.modernMint : const Color(0xFF1E2833),
              t,
            )!,
            colors.isDark ? colors.onPrimary : AppColors.white,
            null,
          ),
          // Mint text washes out on the light canvas, so light mode fills the
          // pill with mint and keeps the label charcoal instead.
          AppButtonVariant.outline when !colors.isDark => (
            Color.lerp(Colors.transparent, colors.primary, t)!,
            colors.textPrimary,
            Color.lerp(colors.borderStrong, colors.primary, t)!,
          ),
          AppButtonVariant.outline => (
            Color.lerp(
              Colors.transparent,
              colors.textPrimary.withValues(alpha: 0.06),
              t,
            )!,
            Color.lerp(colors.textPrimary, colors.primary, t)!,
            Color.lerp(colors.borderStrong, colors.primary, t)!,
          ),
          AppButtonVariant.quiet => (
            Colors.transparent,
            Color.lerp(
              colors.textSecondary,
              colors.isDark ? colors.primary : colors.textPrimary,
              t,
            )!,
            null,
          ),
        };

        final content = Row(
          mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                label,
                style: type.bodyStrong.copyWith(
                  color: enabled ? foreground : colors.textTertiary,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (icon != null) ...[
              const SizedBox(width: AppSpacing.xs),
              Transform.translate(
                offset: Offset(4 * t, 0),
                child: Icon(
                  icon,
                  size: 17,
                  color: enabled ? foreground : colors.textTertiary,
                ),
              ),
            ],
          ],
        );

        if (variant == AppButtonVariant.quiet) {
          return Transform.translate(
            offset: Offset(0, lift),
            child: IntrinsicWidth(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  content,
                  const SizedBox(height: 3),
                  ClipRect(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      widthFactor: t,
                      child: Container(height: 1, color: foreground),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Transform.translate(
          offset: Offset(0, lift),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              color: background,
              borderRadius: AppRadius.brPill,
              border: border == null ? null : Border.all(color: border),
              boxShadow: variant == AppButtonVariant.primary && t > 0
                  ? [
                      BoxShadow(
                        color: tint.withValues(alpha: 0.28 * t),
                        blurRadius: 22 * t,
                        offset: Offset(0, 6 * t),
                      ),
                    ]
                  : null,
            ),
            child: content,
          ),
        );
      },
    );
  }
}
