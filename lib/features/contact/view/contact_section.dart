import 'package:flutter/material.dart';

import 'package:portfolio/core/constants/app_spacing.dart';
import 'package:portfolio/core/di/app_scope.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/core/utils/responsive.dart';
import 'package:portfolio/features/contact/view_model/contact_view_model.dart';
import 'package:portfolio/features/contact/widgets/channel_tile.dart';
import 'package:portfolio/features/contact/widgets/contact_actions.dart';
import 'package:portfolio/features/home/models/portfolio_section.dart';
import 'package:portfolio/shared/animations/reveal_on_scroll.dart';
import 'package:portfolio/shared/widgets/ambient_backdrop.dart';
import 'package:portfolio/shared/widgets/responsive_grid.dart';
import 'package:portfolio/shared/widgets/section_header.dart';
import 'package:portfolio/shared/widgets/section_shell.dart';

/// The closing call to action.
///
/// Contact details are shown as real, copyable values next to their actions: a
/// recruiter who wants to paste an address into their own client should not
/// have to hover a button to find it.
class ContactSection extends StatelessWidget {
  const ContactSection({super.key, required this.onDownloadCv});

  final VoidCallback onDownloadCv;

  @override
  Widget build(BuildContext context) {
    final viewModel = ContactViewModel(context.repository);
    final section = PortfolioSection.contact;
    final colors = context.colors;

    final actions = ContactActions(
      mailtoUri: viewModel.mailtoUri,
      onDownloadCv: onDownloadCv,
    );
    final channels = ResponsiveGrid(
      columns: responsiveValue(context.screen, compact: 1, expanded: 2),
      gap: AppSpacing.sm,
      revealOffset: 16,
      revealInterval: const Duration(milliseconds: 60),
      children: [
        for (final channel in viewModel.channels) ChannelTile(channel: channel),
      ],
    );

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
                lead:
                    'Open to Flutter roles and freelance work. Feel free to '
                    'reach out via email, WhatsApp, or LinkedIn.',
              ),
              const SizedBox(height: AppSpacing.x4l),
              if (context.isTabletOrBelow) ...[
                actions,
                const SizedBox(height: AppSpacing.xxl),
                channels,
              ] else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 5, child: actions),
                    const SizedBox(width: AppSpacing.x4l),
                    Expanded(flex: 6, child: channels),
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
                        '${viewModel.location} · '
                        'Working remotely with distributed teams',
                        style: context.type.bodySmall.copyWith(
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
