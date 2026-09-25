import 'package:flutter/material.dart';

import 'package:portfolio/core/constants/app_spacing.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/data/models/models.dart';
import 'package:portfolio/features/footer/view_model/footer_view_model.dart';
import 'package:portfolio/features/footer/widgets/footer_social_button.dart';

/// Name, role, tagline and the social buttons.
class FooterBrand extends StatelessWidget {
  const FooterBrand({super.key, required this.viewModel, required this.muted});

  final FooterViewModel viewModel;
  final Color muted;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;
    final profile = viewModel.profile;

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
            FooterSocialButton(
              label: 'Email',
              kind: ContactKind.email,
              url: profile.mailtoUri,
            ),
            for (final link in viewModel.socialLinks)
              FooterSocialButton(
                label: link.label,
                kind: link.kind,
                url: link.url,
              ),
          ],
        ),
      ],
    );
  }
}
