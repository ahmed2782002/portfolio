import 'package:flutter/material.dart';

import 'package:portfolio/core/constants/app_spacing.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/core/utils/link_launcher.dart';
import 'package:portfolio/data/models/models.dart';
import 'package:portfolio/shared/widgets/hover_card.dart';
import 'package:portfolio/shared/widgets/social/social_brand.dart';

/// A contact channel shown as its real, copyable value, with an outbound
/// arrow when it can be opened.
class ChannelTile extends StatelessWidget {
  const ChannelTile({super.key, required this.channel});

  final ContactLink channel;

  IconData get _icon => switch (channel.kind) {
    ContactKind.email => Icons.alternate_email_rounded,
    ContactKind.phone => Icons.call_outlined,
    ContactKind.location => Icons.place_outlined,
    ContactKind.github => Icons.code_rounded,
    ContactKind.linkedin => Icons.business_center_outlined,
    ContactKind.website => Icons.language_rounded,
    ContactKind.whatsapp => Icons.chat_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;
    final actionable = channel.url.isNotEmpty;

    return HoverCard(
      onTap: actionable ? () => LinkLauncher.open(context, channel.url) : null,
      semanticLabel: '${channel.label}: ${channel.value}',
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      borderRadius: AppRadius.brMd,
      lift: 0,
      shadow: false,
      // Static rows brighten but keep their border.
      accent: actionable ? null : colors.border,
      accentAlpha: actionable ? 0.5 : 1,
      builder: (context, t) {
        final emphasis = actionable ? t : 0.0;

        return Row(
          children: [
            SocialBrand.logo(channel.kind, size: 18, onDark: context.isDark) ??
                Icon(
                  _icon,
                  size: 17,
                  color: Color.lerp(
                    colors.textTertiary,
                    colors.primary,
                    emphasis,
                  ),
                ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    channel.label.toUpperCase(),
                    style: type.labelSmall.copyWith(color: colors.textTertiary),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    channel.value,
                    style: type.bodySmall.copyWith(color: colors.textPrimary),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (actionable)
              Transform.translate(
                offset: Offset(4 * t, -4 * t),
                child: Icon(
                  Icons.north_east_rounded,
                  size: 15,
                  color: Color.lerp(colors.textTertiary, colors.primary, t),
                ),
              ),
          ],
        );
      },
    );
  }
}
