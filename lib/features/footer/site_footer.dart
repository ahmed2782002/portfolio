import 'package:flutter/material.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/link_launcher.dart';
import '../../data/models/portfolio_models.dart';
import '../../data/portfolio_data.dart';
import '../../shared/widgets/hover_builder.dart';
import '../../shared/widgets/section_shell.dart';
import '../../shared/widgets/social_icon_bar.dart';
import '../home/portfolio_section.dart';

/// Conventional multi-column site footer: brand, sitemap, contact and
/// resources, over a bottom bar with the copyright and a back-to-top control.
///
/// It sits on an inverted surface ([AppColors.footer]) so the page visibly
/// ends — darker than the canvas in light mode, lighter in dark mode.
class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key, required this.onNavigate});

  final ValueChanged<PortfolioSection> onNavigate;

  /// Cached at class load — avoids calling DateTime.now() on every rebuild.
  static final int _year = DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;
    final profile = PortfolioData.profile;
    final on = colors.onFooter;
    final muted = on.withValues(alpha: 0.62);
    final rule = on.withValues(alpha: 0.12);

    final columns = <Widget>[
      _Brand(muted: muted),
      _LinkColumn(
        title: 'Explore',
        children: [
          for (final section in PortfolioSection.navItems)
            _FooterLink(
              label: section.label,
              onTap: () => onNavigate(section),
            ),
        ],
      ),
      _LinkColumn(
        title: 'Contact',
        children: [
          for (final channel in PortfolioData.contactChannels)
            _FooterLink(
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
      _LinkColumn(
        title: 'Resources',
        children: [
          _FooterLink(
            label: 'Download CV',
            icon: Icons.download_rounded,
            onTap: () => LinkLauncher.openAsset(context, profile.cvAsset),
          ),
          for (final link in PortfolioData.socialLinks)
            _FooterLink(
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
            LayoutBuilder(
              builder: (context, constraints) {
                // 4 across on desktop, 2×2 on tablet, a single stack on phones.
                final perRow = constraints.maxWidth >= 900
                    ? 4
                    : constraints.maxWidth >= 560
                        ? 2
                        : 1;
                const gap = AppSpacing.xxl;
                // Shave a pixel so rounding never pushes the last column down.
                final width =
                    (constraints.maxWidth - 1 - gap * (perRow - 1)) / perRow;
                return Wrap(
                  spacing: gap,
                  runSpacing: AppSpacing.x3l,
                  children: [
                    for (var i = 0; i < columns.length; i++)
                      SizedBox(
                        // The brand column earns a little more room on desktop.
                        width: perRow == 4
                            ? (i == 0 ? width * 1.3 : width * 0.9)
                            : width,
                        child: columns[i],
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: AppSpacing.x4l),
            Container(height: 1, color: rule),
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
                    '© $_year ${profile.fullName}. All rights reserved.',
                    style: type.labelSmall.copyWith(color: muted),
                  ),
                  _FooterLink(
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

class _Brand extends StatelessWidget {
  const _Brand({required this.muted});

  final Color muted;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;
    final profile = PortfolioData.profile;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          profile.fullName,
          style: type.title.copyWith(
            color: colors.onFooter,
            fontFamily: 'SpaceGrotesk',
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          profile.role,
          style: type.bodySmall.copyWith(color: AppColors.modernMint),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          profile.tagline,
          style: type.bodySmall.copyWith(color: muted, height: 1.6),
        ),
        const SizedBox(height: AppSpacing.lg),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            _FooterSocial(
              label: 'Email',
              kind: ContactKind.email,
              url: profile.mailtoUri,
            ),
            for (final link in PortfolioData.socialLinks)
              _FooterSocial(label: link.label, kind: link.kind, url: link.url),
          ],
        ),
      ],
    );
  }
}

class _LinkColumn extends StatelessWidget {
  const _LinkColumn({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: type.labelSmall.copyWith(
            color: colors.onFooter,
            letterSpacing: 1.4,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        for (final child in children)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: child,
          ),
      ],
    );
  }
}

/// A text link on the footer surface: muted at rest, mint on hover.
class _FooterLink extends StatelessWidget {
  const _FooterLink({
    required this.label,
    required this.onTap,
    this.icon,
    this.small = false,
  });

  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;
    final rest = colors.onFooter.withValues(alpha: 0.72);
    final style = small ? type.labelSmall : type.bodySmall;

    return HoverBuilder(
      onTap: onTap,
      enabled: onTap != null,
      notifyCursor: onTap != null,
      semanticLabel: label,
      builder: (context, t, _) {
        final color = Color.lerp(rest, AppColors.modernMint, t)!;
        return Transform.translate(
          offset: Offset(3 * t, 0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: small ? 14 : 16, color: color),
                const SizedBox(width: AppSpacing.xs),
              ],
              Flexible(
                child: Text(
                  label,
                  style: style.copyWith(color: color),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Round icon button sized for the footer. Uses the same brand assets as the
/// hero's [SocialIconBar], tinted for the dark footer surface.
class _FooterSocial extends StatelessWidget {
  const _FooterSocial({
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
    // The footer surface is dark in both themes.
    final glyph = SocialIconBar.brandIcon(kind, size: 18, onDark: true) ??
        Icon(Icons.link_rounded, size: 18, color: on);

    return Tooltip(
      message: label,
      child: HoverBuilder(
        onTap: () => LinkLauncher.open(context, url),
        semanticLabel: label,
        builder: (context, t, _) {

          return Transform.translate(
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
          );
        },
      ),
    );
  }
}
