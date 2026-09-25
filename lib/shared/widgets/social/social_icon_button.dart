import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import 'package:portfolio/core/constants/app_animations.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/core/utils/link_launcher.dart';
import 'package:portfolio/data/models/models.dart';
import 'package:portfolio/shared/widgets/hover_builder.dart';
import 'package:portfolio/shared/widgets/social/social_brand.dart';

/// A single 3D social icon button.
///
/// The 3D effect is built from four visual layers:
///   1. A bottom shadow (dark, offset down), the button's "depth"
///   2. A coloured glow (brand colour, blurred), the ambient lighting
///   3. A gradient surface (lighter top, darker bottom), the face
///   4. A rim highlight (light inner border), the machined edge
///
/// On hover, the button lifts, the glow intensifies, and the icon brightens.
class SocialIconButton extends StatelessWidget {
  const SocialIconButton({
    super.key,
    required this.kind,
    required this.brandColor,
    required this.label,
    required this.url,
    required this.size,
  });

  final ContactKind kind;
  final Color brandColor;
  final String label;
  final String url;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = colors.isDark;

    return Tooltip(
      message: label,
      child: HoverBuilder(
        onTap: () => LinkLauncher.open(context, url),
        semanticLabel: label,
        duration: AppAnimations.base,
        builder: (context, t, _) {
          Color tone(double rest, double hover) => Color.lerp(
            brandColor.withValues(alpha: rest),
            brandColor.withValues(alpha: hover),
            t,
          )!;

          final iconColor = Color.lerp(
            isDark ? brandColor.withValues(alpha: 0.85) : colors.textPrimary,
            brandColor,
            t,
          )!;

          return Transform.translate(
            offset: Offset(0, -4.0 * t),
            child: Transform.scale(
              scale: 1.0 + 0.06 * t,
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      tone(isDark ? 0.22 : 0.12, isDark ? 0.40 : 0.28),
                      tone(isDark ? 0.10 : 0.05, isDark ? 0.22 : 0.14),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(size * 0.28),
                  border: Border.all(
                    color: tone(isDark ? 0.28 : 0.20, 0.65),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.45 : 0.16,
                      ),
                      blurRadius: lerpDouble(6, 14, t)!,
                      offset: Offset(0, lerpDouble(3, 6, t)!),
                      spreadRadius: -1,
                    ),
                    BoxShadow(
                      color: brandColor.withValues(alpha: 0.45 * t),
                      blurRadius: 22 * t,
                      offset: Offset(0, 4 * t),
                    ),
                    BoxShadow(
                      color: Colors.white.withValues(
                        alpha: isDark ? 0.04 : 0.12,
                      ),
                      blurRadius: 1,
                      spreadRadius: -1,
                      offset: const Offset(0, -0.5),
                    ),
                  ],
                ),
                child: Center(
                  child:
                      SocialBrand.logo(
                        kind,
                        size: size * 0.46,
                        onDark: isDark,
                      ) ??
                      Icon(
                        SocialBrand.iconFor(kind),
                        size: size * 0.44,
                        color: iconColor,
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
