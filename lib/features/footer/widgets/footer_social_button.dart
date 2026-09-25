import 'package:flutter/material.dart';

import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/utils/link_launcher.dart';
import 'package:portfolio/data/models/models.dart';
import 'package:portfolio/shared/widgets/hover_builder.dart';
import 'package:portfolio/shared/widgets/social/social_brand.dart';

/// Round icon button sized for the footer, using the same brand logos as the
/// hero's social bar. The footer surface is dark in both themes.
class FooterSocialButton extends StatelessWidget {
  const FooterSocialButton({
    super.key,
    required this.label,
    required this.kind,
    required this.url,
  });

  final String label;
  final ContactKind kind;
  final String url;

  static const double _size = 38;

  @override
  Widget build(BuildContext context) {
    final on = context.colors.onFooter;
    final glyph =
        SocialBrand.logo(kind, size: 18, onDark: true) ??
        Icon(Icons.link_rounded, size: 18, color: on);

    return Tooltip(
      message: label,
      child: HoverBuilder(
        onTap: () => LinkLauncher.open(context, url),
        semanticLabel: label,
        child: glyph,
        builder: (context, t, glyph) => Transform.translate(
          offset: Offset(0, -2 * t),
          child: Container(
            width: _size,
            height: _size,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: on.withValues(alpha: 0.08 + 0.06 * t),
              border: Border.all(
                color: Color.lerp(
                  on.withValues(alpha: 0.16),
                  AppColors.modernMint,
                  t,
                )!,
              ),
            ),
            child: glyph,
          ),
        ),
      ),
    );
  }
}
