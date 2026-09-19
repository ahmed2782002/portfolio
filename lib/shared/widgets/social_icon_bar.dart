import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/app_animations.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/link_launcher.dart';
import '../../data/models/portfolio_models.dart';
import 'hover_builder.dart';

/// Brand-harmonized colours for each social platform using the strict palette.
abstract final class SocialBrand {
  static const Color mint = AppColors.modernMint;
  static const Color lavender = AppColors.lavenderPurple;
  static const Color charcoal = AppColors.darkCharcoal;
}

/// A row of 3D-style social icon buttons.
///
/// Each icon uses custom assets from `assets/icons/` (GitHub, LinkedIn, WhatsApp)
/// or high-fidelity vector icons, framed with a 3D gradient surface, layered
/// depth shadows, and lift + glow on hover.
class SocialIconBar extends StatelessWidget {
  const SocialIconBar({
    super.key,
    required this.links,
    this.emailUrl,
    this.size = 46,
    this.spacing = AppSpacing.md,
  });

  final List<ContactLink> links;

  /// Optional mailto: URI shown as a separate email icon.
  final String? emailUrl;
  final double size;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: [
        if (emailUrl != null)
          _SocialIcon3D(
            icon: Icons.alternate_email_rounded,
            brandColor: SocialBrand.lavender,
            label: 'Send email',
            url: emailUrl!,
            size: size,
          ),
        for (final link in links)
          _SocialIcon3D(
            icon: _iconFor(link.kind),
            assetPath: _assetFor(link.kind),
            brandColor: _colorFor(link.kind, context.isDark),
            label: link.label,
            url: link.url,
            size: size,
          ),
      ],
    );
  }

  static String? _assetFor(ContactKind kind) => switch (kind) {
        ContactKind.linkedin => 'assets/icons/linkedin-svgrepo-com.svg',
        ContactKind.github => 'assets/icons/github.png',
        ContactKind.whatsapp => 'assets/icons/whatsapp-color-svgrepo-com.svg',
        _ => null,
      };

  static IconData _iconFor(ContactKind kind) => switch (kind) {
        ContactKind.linkedin => Icons.business_center_rounded,
        ContactKind.github => Icons.code_rounded,
        ContactKind.whatsapp => Icons.chat_rounded,
        ContactKind.email => Icons.alternate_email_rounded,
        ContactKind.phone => Icons.call_rounded,
        ContactKind.location => Icons.place_outlined,
        ContactKind.website => Icons.language_rounded,
      };

  static Color _colorFor(ContactKind kind, bool isDark) => switch (kind) {
        ContactKind.linkedin => SocialBrand.lavender,
        ContactKind.github => isDark ? AppColors.white : SocialBrand.charcoal,
        ContactKind.whatsapp => SocialBrand.mint,
        ContactKind.email => SocialBrand.lavender,
        ContactKind.phone => SocialBrand.mint,
        _ => SocialBrand.lavender,
      };
}

/// A single 3D social icon button.
///
/// The 3D effect is built from four visual layers:
///   1. A bottom shadow (dark, offset down) — the button's "depth"
///   2. A coloured glow (brand colour, blurred) — ambient lighting
///   3. A gradient surface (lighter top, darker bottom) — the face
///   4. A rim highlight (light inner border) — the machined edge
///
/// On hover, the button lifts, the glow intensifies, and the icon brightens.
class _SocialIcon3D extends StatelessWidget {
  const _SocialIcon3D({
    this.icon,
    this.assetPath,
    required this.brandColor,
    required this.label,
    required this.url,
    required this.size,
  });

  final IconData? icon;
  final String? assetPath;
  final Color brandColor;
  final String label;
  final String url;
  final double size;

  Widget _buildIcon(Color iconColor) {
    final asset = assetPath;
    if (asset != null) {
      if (asset.endsWith('.svg')) {
        return SvgPicture.asset(
          asset,
          width: size * 0.46,
          height: size * 0.46,
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        );
      } else {
        return Image.asset(
          asset,
          width: size * 0.46,
          height: size * 0.46,
          color: iconColor,
        );
      }
    }
    if (icon != null) {
      return Icon(icon, size: size * 0.44, color: iconColor);
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Tooltip(
      message: label,
      child: HoverBuilder(
        onTap: () => LinkLauncher.open(context, url),
        semanticLabel: label,
        duration: AppAnimations.base,
        builder: (context, t, _) {
          final lift = -4.0 * t;
          final scale = 1.0 + 0.06 * t;

          // 3D depth: the face of the button
          final faceTop = Color.lerp(
            colors.isDark
                ? brandColor.withValues(alpha: 0.22)
                : brandColor.withValues(alpha: 0.12),
            brandColor.withValues(alpha: colors.isDark ? 0.40 : 0.28),
            t,
          )!;

          final faceBottom = Color.lerp(
            colors.isDark
                ? brandColor.withValues(alpha: 0.10)
                : brandColor.withValues(alpha: 0.05),
            brandColor.withValues(alpha: colors.isDark ? 0.22 : 0.14),
            t,
          )!;

          final borderColor = Color.lerp(
            colors.isDark
                ? brandColor.withValues(alpha: 0.28)
                : brandColor.withValues(alpha: 0.20),
            brandColor.withValues(alpha: 0.65),
            t,
          )!;

          final iconColor = Color.lerp(
            colors.isDark
                ? brandColor.withValues(alpha: 0.85)
                : colors.textPrimary,
            brandColor,
            t,
          )!;

          return Transform.translate(
            offset: Offset(0, lift),
            child: Transform.scale(
              scale: scale,
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  // 3D surface gradient — lighter at top, darker at bottom
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [faceTop, faceBottom],
                  ),
                  borderRadius: BorderRadius.circular(size * 0.28),
                  // Rim highlight — machined edge
                  border: Border.all(color: borderColor, width: 1.2),
                  boxShadow: [
                    // 1. Bottom shadow — depth
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: colors.isDark ? 0.45 : 0.16,
                      ),
                      blurRadius: lerpDouble(6, 14, t)!,
                      offset: Offset(0, lerpDouble(3, 6, t)!),
                      spreadRadius: -1,
                    ),
                    // 2. Coloured glow — ambient lighting
                    BoxShadow(
                      color: brandColor.withValues(
                        alpha: lerpDouble(0.0, 0.45, t)!,
                      ),
                      blurRadius: lerpDouble(0, 22, t)!,
                      offset: Offset(0, lerpDouble(0, 4, t)!),
                    ),
                    // 3. Inner light at top — simulates a highlight
                    BoxShadow(
                      color: Colors.white.withValues(
                        alpha: colors.isDark ? 0.04 : 0.12,
                      ),
                      blurRadius: 1,
                      spreadRadius: -1,
                      offset: const Offset(0, -0.5),
                    ),
                  ],
                ),
                child: Center(
                  child: _buildIcon(iconColor),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
