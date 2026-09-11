import 'package:flutter/material.dart';

import '../../core/constants/app_animations.dart';
import '../../core/extensions/context_extensions.dart';
import 'hover_builder.dart';

/// Refined Light/Dark theme toggle.
///
/// Features a compact modern footprint, smooth rotation & scale icon transitions,
/// and contextual warm-gold / indigo lighting based on active brightness.
class ThemeToggle extends StatelessWidget {
  const ThemeToggle({
    super.key,
    required this.isDark,
    required this.onToggle,
    this.size = 35,
  });

  final bool isDark;
  final VoidCallback onToggle;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final label = isDark ? 'Switch to light mode' : 'Switch to dark mode';
    final iconColor = isDark ? colors.accent : colors.primary;

    return Tooltip(
      message: label,
      child: HoverBuilder(
        onTap: onToggle,
        semanticLabel: label,
        builder: (context, hover, _) {
          return AnimatedContainer(
            duration: AppAnimations.base,
            curve: AppAnimations.standard,
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Color.lerp(
                colors.surface,
                iconColor.withValues(alpha: isDark ? 0.18 : 0.10),
                hover,
              ),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Color.lerp(
                  colors.border,
                  iconColor.withValues(alpha: 0.55),
                  hover,
                )!,
                width: 1,
              ),
              boxShadow: hover > 0.05
                  ? [
                      BoxShadow(
                        color: iconColor.withValues(alpha: 0.16 * hover),
                        blurRadius: 10 * hover,
                        offset: Offset(0, 2 * hover),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 320),
                switchInCurve: Curves.easeOutBack,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, animation) {
                  return RotationTransition(
                    turns: Tween<double>(
                      begin: isDark ? 0.25 : -0.25,
                      end: 0.0,
                    ).animate(animation),
                    child: ScaleTransition(
                      scale: animation,
                      child: FadeTransition(opacity: animation, child: child),
                    ),
                  );
                },
                child: Icon(
                  isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                  key: ValueKey<bool>(isDark),
                  size: 17,
                  color: Color.lerp(
                    isDark ? colors.accent : colors.textSecondary,
                    iconColor,
                    hover,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
