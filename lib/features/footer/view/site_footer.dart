import 'package:flutter/material.dart';

import 'package:portfolio/core/constants/app_spacing.dart';
import 'package:portfolio/core/di/app_scope.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/core/utils/link_launcher.dart';
import 'package:portfolio/data/models/models.dart';
import 'package:portfolio/features/footer/view_model/footer_view_model.dart';
import 'package:portfolio/features/footer/widgets/footer_brand.dart';
import 'package:portfolio/features/footer/widgets/footer_link.dart';
import 'package:portfolio/features/footer/widgets/footer_link_column.dart';
import 'package:portfolio/features/home/models/portfolio_section.dart';
import 'package:portfolio/shared/widgets/section_shell.dart';

/// Conventional multi-column site footer: brand, sitemap, contact and
/// resources, over a bottom bar with the copyright and a back-to-top control.
///
/// It sits on an inverted surface so the page visibly ends: darker than the
/// canvas in light mode, lighter in dark mode.
class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key, required this.onNavigate});

  final ValueChanged<PortfolioSection> onNavigate;

  @override
  Widget build(BuildContext context) {
    final viewModel = FooterViewModel(context.repository);
    final colors = context.colors;
    final muted = colors.onFooter.withValues(alpha: 0.62);

    final columns = <Widget>[
      FooterBrand(viewModel: viewModel, muted: muted),
      FooterLinkColumn(
        title: 'Explore',
        children: [
          for (final section in PortfolioSection.navItems)
            FooterLink(label: section.label, onTap: () => onNavigate(section)),
        ],
      ),
      FooterLinkColumn(
        title: 'Contact',
        children: [
          for (final channel in viewModel.contactChannels)
            FooterLink(
              label: channel.value,
              icon: switch (channel.kind) {
                ContactKind.email => Icons.mail_outline_rounded,
                ContactKind.phone => Icons.call_outlined,
                _ => Icons.place_outlined,
              },
              onTap: channel.url.isEmpty
                  ? null
                  : () => LinkLauncher.open(context, channel.url),
            ),
        ],
      ),
      FooterLinkColumn(
        title: 'Resources',
        children: [
          FooterLink(
            label: 'Download CV',
            icon: Icons.download_rounded,
            onTap: () =>
                LinkLauncher.openAsset(context, viewModel.profile.cvAsset),
          ),
          for (final link in viewModel.socialLinks)
            FooterLink(
              label: link.label,
              onTap: () => LinkLauncher.open(context, link.url),
            ),
        ],
      ),
    ];

    return ColoredBox(
      color: colors.footer,
      child: SectionShell(
        verticalPadding: AppSpacing.x5l,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FooterColumns(columns: columns),
            const SizedBox(height: AppSpacing.x4l),
            Container(
              height: 1,
              color: colors.onFooter.withValues(alpha: 0.12),
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.sm,
                children: [
                  Text(
                    viewModel.copyright,
                    style: context.type.labelSmall.copyWith(color: muted),
                  ),
                  FooterLink(
                    label: 'Back to top',
                    icon: Icons.arrow_upward_rounded,
                    small: true,
                    onTap: () => onNavigate(PortfolioSection.home),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Four across on desktop, 2×2 on tablet, a single stack on phones. The brand
/// column earns a little more room on desktop.
class _FooterColumns extends StatelessWidget {
  const _FooterColumns({required this.columns});

  final List<Widget> columns;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final perRow = constraints.maxWidth >= 900
            ? 4
            : constraints.maxWidth >= 560
            ? 2
            : 1;
        const gap = AppSpacing.xxl;
        // Shave a pixel so rounding never pushes the last column down.
        final width = (constraints.maxWidth - 1 - gap * (perRow - 1)) / perRow;

        return Wrap(
          spacing: gap,
          runSpacing: AppSpacing.x3l,
          children: [
            for (var i = 0; i < columns.length; i++)
              SizedBox(
                width: perRow == 4
                    ? (i == 0 ? width * 1.3 : width * 0.9)
                    : width,
                child: columns[i],
              ),
          ],
        );
      },
    );
  }
}
