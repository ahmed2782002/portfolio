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

/// Each platform's own brand colour — matching the fills baked into the icon
/// assets, so a button's glow and its logo agree.
abstract final class SocialBrand {
  static const Color linkedin = Color(0xFF0077B7);
  static const Color whatsapp = Color(0xFF67C15E);
  static const Color github = Color(0xFF181717);
  static const Color gmail = Color(0xFFEA4335);
  static const Color phone = AppColors.modernMint;
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
            kind: ContactKind.email,
            brandColor: SocialBrand.gmail,
            label: 'Send email',
            url: emailUrl!,
            size: size,
          ),
        for (final link in links)
          _SocialIcon3D(
            icon: _iconFor(link.kind),
            kind: link.kind,
            brandColor: _colorFor(link.kind, context.isDark),
            label: link.label,
            url: link.url,
            size: size,
          ),
      ],
    );
  }

  /// The channel's logo in its own brand colours, or `null` when the channel
  /// has no logo asset.
  ///
  /// Every asset carries its official colours and is drawn as-is. The one
  /// exception is GitHub, whose mark is plain black: it is painted
  /// GitHub-black on light surfaces and white on dark ones — the two colours
  /// GitHub itself uses — so it never disappears.
  static Widget? brandIcon(
    ContactKind kind, {
    required double size,
    required bool onDark,
  }) {
    final asset = assetFor(kind);
    if (asset == null) return null;
    if (!asset.endsWith('.svg')) {
      return Image.asset(
        asset,
        width: size * 1.12,
        height: size * 1.12,
        filterQuality: FilterQuality.medium,
      );
    }
    return SvgPicture.asset(
      asset,
      width: size,
      height: size,
      colorFilter: kind == ContactKind.github
          ? ColorFilter.mode(
              onDark ? AppColors.white : SocialBrand.github,
              BlendMode.srcIn,
            )
          : null,
    );
  }

  static String? assetFor(ContactKind kind) => switch (kind) {
        ContactKind.linkedin => 'assets/icons/linkedin-svgrepo-com.svg',
        ContactKind.github => 'assets/icons/github.svg',
        ContactKind.whatsapp => 'assets/icons/whatsapp-color-svgrepo-com.svg',
        ContactKind.email => 'assets/icons/icons8-gmail-48.png',
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
        ContactKind.linkedin => SocialBrand.linkedin,
        ContactKind.github => isDark ? AppColors.white : SocialBrand.github,
        ContactKind.whatsapp => SocialBrand.whatsapp,
        ContactKind.email => SocialBrand.gmail,
        ContactKind.phone => SocialBrand.phone,
        _ => AppColors.lavenderPurple,
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
    this.kind,
    required this.brandColor,
    required this.label,
    required this.url,
    required this.size,
  });

  final IconData? icon;

  /// Channel whose brand logo to draw; falls back to [icon] without one.
  final ContactKind? kind;
  final Color brandColor;
  final String label;
  final String url;
  final double size;

  Widget _buildIcon(Color iconColor, bool isDark) {
    final logo = kind == null
        ? null
        : SocialIconBar.brandIcon(kind!, size: size * 0.46, onDark: isDark);
    if (logo != null) return logo;
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
                  child: _buildIcon(iconColor, colors.isDark),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
