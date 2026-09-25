import 'package:flutter/material.dart';

import 'package:portfolio/core/constants/app_spacing.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/data/models/models.dart';
import 'package:portfolio/shared/widgets/social/social_brand.dart';
import 'package:portfolio/shared/widgets/social/social_icon_button.dart';

/// A row of 3D-style social icon buttons.
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
          SocialIconButton(
            kind: ContactKind.email,
            brandColor: SocialBrand.gmail,
            label: 'Send email',
            url: emailUrl!,
            size: size,
          ),
        for (final link in links)
          SocialIconButton(
            kind: link.kind,
            brandColor: SocialBrand.colorFor(link.kind, isDark: context.isDark),
            label: link.label,
            url: link.url,
            size: size,
          ),
      ],
    );
  }
}
