import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/data/models/models.dart';

/// Each channel's brand colour, logo asset and fallback glyph, in one place.
///
/// The colours match the fills baked into the icon assets, so a button's glow
/// and its logo agree.
abstract final class SocialBrand {
  static const Color linkedin = Color(0xFF0077B7);
  static const Color whatsapp = Color(0xFF67C15E);
  static const Color github = Color(0xFF181717);
  static const Color gmail = Color(0xFFEA4335);
  static const Color phone = AppColors.modernMint;

  static String? assetFor(ContactKind kind) => switch (kind) {
    ContactKind.linkedin => 'assets/icons/linkedin-svgrepo-com.svg',
    ContactKind.github => 'assets/icons/github.svg',
    ContactKind.whatsapp => 'assets/icons/whatsapp-color-svgrepo-com.svg',
    ContactKind.email => 'assets/icons/icons8-gmail-48.png',
    _ => null,
  };

  static IconData iconFor(ContactKind kind) => switch (kind) {
    ContactKind.linkedin => Icons.business_center_rounded,
    ContactKind.github => Icons.code_rounded,
    ContactKind.whatsapp => Icons.chat_rounded,
    ContactKind.email => Icons.alternate_email_rounded,
    ContactKind.phone => Icons.call_rounded,
    ContactKind.location => Icons.place_outlined,
    ContactKind.website => Icons.language_rounded,
  };

  static Color colorFor(ContactKind kind, {required bool isDark}) =>
      switch (kind) {
        ContactKind.linkedin => linkedin,
        ContactKind.github => isDark ? AppColors.white : github,
        ContactKind.whatsapp => whatsapp,
        ContactKind.email => gmail,
        ContactKind.phone => phone,
        _ => AppColors.lavenderPurple,
      };

  /// The channel's logo in its own brand colours, or `null` when the channel
  /// has no logo asset.
  ///
  /// Every asset carries its official colours and is drawn as-is. The one
  /// exception is GitHub, whose mark is plain black: it is painted
  /// GitHub-black on light surfaces and white on dark ones, the two colours
  /// GitHub itself uses, so it never disappears.
  static Widget? logo(
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
          ? ColorFilter.mode(onDark ? AppColors.white : github, BlendMode.srcIn)
          : null,
    );
  }
}
