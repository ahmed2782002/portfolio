import 'package:flutter/material.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/extensions/context_extensions.dart';
import 'hover_builder.dart';

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

        final (Color background, Color foreground, Color? border) =
            switch (variant) {
          AppButtonVariant.primary => (
              Color.lerp(tint, _deepen(tint, colors.isDark), t)!,
              colors.onPrimary,
              null,
            ),
          AppButtonVariant.outline => (
              Color.lerp(Colors.transparent, tint.withValues(alpha: 0.08), t)!,
              Color.lerp(colors.textPrimary, tint, t)!,
              Color.lerp(colors.borderStrong, tint, t)!,
            ),
          AppButtonVariant.quiet => (
              Colors.transparent,
              Color.lerp(colors.textSecondary, tint, t)!,
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
                  // Underline wipes in from the left instead of fading. The
                  // line is laid out at full label width and clipped back to
                  // `t`, so it never needs a bounded width of its own.
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
              vertical: 15,
            ),
            decoration: BoxDecoration(
              color: background,
              borderRadius: AppRadius.brSm,
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

  /// Hover state for a filled button: darken in light mode, lighten in dark, so
  /// the change is visible against either canvas.
  static Color _deepen(Color base, bool isDark) {
    final hsl = HSLColor.fromColor(base);
    final lightness =
        isDark ? (hsl.lightness + 0.07) : (hsl.lightness - 0.06);
    return hsl.withLightness(lightness.clamp(0.0, 1.0)).toColor();
  }
}

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
