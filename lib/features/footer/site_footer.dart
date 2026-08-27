import 'package:flutter/material.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/utils/link_launcher.dart';
import '../../data/portfolio_data.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/section_shell.dart';
import '../home/portfolio_section.dart';

/// Minimal closing bar: who, what, where to go next.
class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key, required this.onNavigate});

  final ValueChanged<PortfolioSection> onNavigate;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;
    final profile = PortfolioData.profile;
    final stacked = context.isMobile;

    final identity = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          profile.fullName,
          style: type.bodyStrong.copyWith(
            color: colors.textPrimary,
            fontFamily: 'SpaceGrotesk',
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '${profile.role} · ${profile.location}',
          style: type.labelSmall.copyWith(color: colors.textSecondary),
        ),
      ],
    );

    final links = Wrap(
      spacing: AppSpacing.lg,
      runSpacing: AppSpacing.sm,
      children: [
        AppButton(
          label: 'Email',
          variant: AppButtonVariant.quiet,
          onPressed: () => LinkLauncher.open(context, profile.mailtoUri),
        ),
        AppButton(
          label: 'CV',
          variant: AppButtonVariant.quiet,
          onPressed: () => LinkLauncher.openAsset(context, profile.cvAsset),
        ),
        for (final link in PortfolioData.socialLinks)
          AppButton(
            label: link.label,
            variant: AppButtonVariant.quiet,
            onPressed: () => LinkLauncher.open(context, link.url),
          ),
        AppButton(
          label: 'Back to top',
          icon: Icons.arrow_upward_rounded,
          variant: AppButtonVariant.quiet,
          onPressed: () => onNavigate(PortfolioSection.home),
        ),
      ],
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.backgroundAlt,
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: SectionShell(
        verticalPadding: AppSpacing.x3l,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (stacked) ...[
              identity,
              const SizedBox(height: AppSpacing.lg),
              links,
            ] else
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  identity,
                  const Spacer(),
                  links,
                ],
              ),
            const SizedBox(height: AppSpacing.xl),
            Container(height: 1, color: colors.border),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '© ${DateTime.now().year} ${profile.fullName}',
                    style: type.labelSmall.copyWith(color: colors.textTertiary),
                  ),
                ),
                Text(
                  'Built with Flutter Web',
                  style: type.labelSmall.copyWith(color: colors.textTertiary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
