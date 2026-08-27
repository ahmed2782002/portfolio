import 'package:flutter/material.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/link_launcher.dart';
import '../../data/models/portfolio_models.dart';
import '../../data/portfolio_data.dart';
import '../../shared/animations/reveal_on_scroll.dart';
import '../../shared/widgets/ambient_backdrop.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/hover_builder.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/section_shell.dart';
import '../home/portfolio_section.dart';

/// The closing call to action.
///
/// Contact details are shown as real, copyable values next to their actions —
/// a recruiter who wants to paste an address into their own client should not
/// have to hover a button to find it. Only channels the CV actually lists are
/// rendered; [PortfolioData.socialLinks] is empty, so no profile row appears
/// until real links are added.
class ContactSection extends StatelessWidget {
  const ContactSection({
    super.key,
    required this.onDownloadCv,
  });

  final VoidCallback onDownloadCv;

  @override
  Widget build(BuildContext context) {
    final section = PortfolioSection.contact;
    final colors = context.colors;
    final type = context.type;
    final profile = PortfolioData.profile;
    final stacked = context.isTabletOrBelow;

    final channels = [
      ...PortfolioData.contactChannels,
      ...PortfolioData.socialLinks,
    ];

    return Stack(
      children: [
        Positioned.fill(
          child: AmbientBackdrop(
            gridSpacing: context.isMobile ? 48 : 72,
            fadeFrom: 0.2,
          ),
        ),
        SectionShell(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(
                index: section.index,
                label: section.label,
                title: "Let's build something\nthat ships.",
                lead: 'Open to Flutter roles and freelance work. The fastest '
                    'route is email — I reply to everything.',
              ),
              const SizedBox(height: AppSpacing.x4l),

              if (stacked) ...[
                _Actions(onDownloadCv: onDownloadCv),
                const SizedBox(height: AppSpacing.xxl),
                _ChannelList(channels: channels),
              ] else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: _Actions(onDownloadCv: onDownloadCv),
                    ),
                    const SizedBox(width: AppSpacing.x4l),
                    Expanded(flex: 6, child: _ChannelList(channels: channels)),
                  ],
                ),

              const SizedBox(height: AppSpacing.x4l),
              RevealOnScroll(
                offsetY: 12,
                child: Row(
                  children: [
                    Icon(
                      Icons.place_outlined,
                      size: 15,
                      color: colors.textTertiary,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Flexible(
                      child: Text(
                        '${profile.location} · '
                        'Working remotely with distributed teams',
                        style: type.bodySmall.copyWith(
                          color: colors.textTertiary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions({required this.onDownloadCv});

  final VoidCallback onDownloadCv;

  @override
  Widget build(BuildContext context) {
    final profile = PortfolioData.profile;

    return RevealOnScroll(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              AppButton(
                label: 'Email me',
                icon: Icons.arrow_outward_rounded,
                variant: AppButtonVariant.primary,
                onPressed: () => LinkLauncher.open(context, profile.mailtoUri),
              ),
              AppButton(
                label: 'Download CV',
                icon: Icons.arrow_downward_rounded,
                onPressed: onDownloadCv,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChannelList extends StatelessWidget {
  const _ChannelList({required this.channels});

  final List<ContactLink> channels;

  @override
  Widget build(BuildContext context) {
    final columns = responsiveValue(context.screen, compact: 1, expanded: 2);

    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = AppSpacing.sm;
        final width = (constraints.maxWidth - gap * (columns - 1)) / columns;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            ...staggered(
              [
                for (final channel in channels)
                  SizedBox(width: width, child: _ChannelTile(channel: channel)),
              ],
              offsetY: 16,
              interval: const Duration(milliseconds: 60),
            ),
          ],
        );
      },
    );
  }
}

class _ChannelTile extends StatelessWidget {
  const _ChannelTile({required this.channel});

  final ContactLink channel;

  IconData get _icon => switch (channel.kind) {
        ContactKind.email => Icons.alternate_email_rounded,
        ContactKind.phone => Icons.call_outlined,
        ContactKind.location => Icons.place_outlined,
        ContactKind.github => Icons.code_rounded,
        ContactKind.linkedin => Icons.business_center_outlined,
        ContactKind.website => Icons.language_rounded,
      };

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;
    final actionable = channel.url.isNotEmpty;

    return HoverBuilder(
      onTap: actionable ? () => LinkLauncher.open(context, channel.url) : null,
      notifyCursor: actionable,
      semanticLabel: '${channel.label}: ${channel.value}',
      builder: (context, t, _) => Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: Color.lerp(colors.card, colors.cardHover, t),
          borderRadius: AppRadius.brMd,
          border: Border.all(
            color: Color.lerp(
              colors.border,
              colors.primary.withValues(alpha: 0.5),
              actionable ? t : 0,
            )!,
          ),
        ),
        child: Row(
          children: [
            Icon(
              _icon,
              size: 17,
              color: Color.lerp(
                colors.textTertiary,
                colors.primary,
                actionable ? t : 0,
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
                    style: type.labelSmall.copyWith(
                      color: colors.textTertiary,
                    ),
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
        ),
      ),
    );
  }
}
