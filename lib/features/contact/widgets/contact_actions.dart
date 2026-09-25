import 'package:flutter/material.dart';

import 'package:portfolio/core/constants/app_spacing.dart';
import 'package:portfolio/core/utils/link_launcher.dart';
import 'package:portfolio/shared/animations/reveal_on_scroll.dart';
import 'package:portfolio/shared/widgets/app_button.dart';

/// The two primary contact actions: email and the CV.
class ContactActions extends StatelessWidget {
  const ContactActions({
    super.key,
    required this.mailtoUri,
    required this.onDownloadCv,
  });

  final String mailtoUri;
  final VoidCallback onDownloadCv;

  @override
  Widget build(BuildContext context) {
    return RevealOnScroll(
      child: Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: [
          AppButton(
            label: 'Email me',
            icon: Icons.arrow_outward_rounded,
            variant: AppButtonVariant.primary,
            onPressed: () => LinkLauncher.open(context, mailtoUri),
          ),
          AppButton(
            label: 'Download CV',
            icon: Icons.arrow_downward_rounded,
            onPressed: onDownloadCv,
          ),
        ],
      ),
    );
  }
}
