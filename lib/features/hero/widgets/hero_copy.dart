import 'package:flutter/material.dart';

import 'package:portfolio/core/constants/app_spacing.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/features/hero/view_model/hero_view_model.dart';
import 'package:portfolio/features/hero/widgets/gradient_text.dart';
import 'package:portfolio/features/hero/widgets/hero_rise.dart';
import 'package:portfolio/features/hero/widgets/role_badge.dart';
import 'package:portfolio/features/hero/widgets/stat_rail.dart';
import 'package:portfolio/features/hero/widgets/status_pill.dart';
import 'package:portfolio/features/home/models/portfolio_section.dart';
import 'package:portfolio/shared/widgets/app_button.dart';
import 'package:portfolio/shared/widgets/social/social_icon_bar.dart';

/// The hero's text column: status, name, role, tagline, actions, stats and
/// social links, each rising in on its own slice of the entrance.
class HeroCopy extends StatelessWidget {
  const HeroCopy({
    super.key,
    required this.viewModel,
    required this.step,
    required this.onNavigate,
    required this.onDownloadCv,
    this.portrait,
  });

  final HeroViewModel viewModel;
  final Animation<double> Function(double begin, double end) step;
  final ValueChanged<PortfolioSection> onNavigate;
  final VoidCallback onDownloadCv;

  /// Injected between the role line and the tagline on stacked layouts.
  final Widget? portrait;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;
    final profile = viewModel.profile;
    final (firstLine, secondLine) = viewModel.nameLines;

    final nameGradient = LinearGradient(
      colors: colors.isDark
          ? const [AppColors.modernMint, AppColors.lavenderPurple]
          : const [Color(0xFF168A78), Color(0xFF73368E)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        HeroRise(
          step(0.00, 0.40),
          child: StatusPill(
            text: viewModel.statusText,
            workMode: viewModel.currentRole.workMode,
            active: viewModel.isCurrentlyEmployed,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        HeroRise(
          step(0.06, 0.50),
          child: GradientText(
            firstLine,
            style: type.display1,
            gradient: nameGradient,
          ),
        ),
        if (secondLine.isNotEmpty)
          HeroRise(
            step(0.10, 0.54),
            child: GradientText(
              secondLine,
              style: type.display1,
              gradient: nameGradient,
            ),
          ),
        const SizedBox(height: AppSpacing.lg),
        HeroRise(
          step(0.16, 0.60),
          child: RoleBadge(label: profile.role),
        ),
        ?portrait,
        SizedBox(height: portrait != null ? 0 : AppSpacing.xl),
        HeroRise(
          step(0.22, 0.66),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 540),
            child: Text(
              profile.tagline,
              style: type.bodyLarge.copyWith(color: colors.textSecondary),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        HeroRise(
          step(0.30, 0.74),
          child: Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              AppButton(
                label: 'View selected work',
                icon: Icons.arrow_forward_rounded,
                variant: AppButtonVariant.primary,
                onPressed: () => onNavigate(PortfolioSection.projects),
              ),
              AppButton(
                label: 'Download CV',
                icon: Icons.arrow_downward_rounded,
                onPressed: onDownloadCv,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4l),
        HeroRise(step(0.38, 0.82), child: StatRail(stats: profile.stats)),
        const SizedBox(height: AppSpacing.xl),
        HeroRise(
          step(0.44, 0.88),
          child: SocialIconBar(
            links: viewModel.socialLinks,
            emailUrl: profile.mailtoUri,
            size: 44,
          ),
        ),
      ],
    );
  }
}
