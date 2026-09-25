import 'package:flutter/material.dart';

import 'package:portfolio/core/constants/app_spacing.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/features/home/models/portfolio_section.dart';
import 'package:portfolio/features/home/widgets/mobile_menu_row.dart';
import 'package:portfolio/shared/widgets/app_button.dart';
import 'package:portfolio/shared/widgets/app_icon_button.dart';

/// The menu's contents, laid out for a given open progress [t].
class MobileMenuBody extends StatelessWidget {
  const MobileMenuBody({
    super.key,
    required this.t,
    required this.active,
    required this.email,
    required this.onNavigate,
    required this.onClose,
    required this.onDownloadCv,
  });

  final double t;
  final PortfolioSection active;
  final String email;
  final ValueChanged<PortfolioSection> onNavigate;
  final VoidCallback onClose;
  final VoidCallback onDownloadCv;

  /// Each row lags the one above it, then all of them settle together.
  double _rowProgress(int index, int total) {
    const span = 0.55;
    final start = (index / total) * (1 - span);
    return ((t - start) / span).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;
    final items = PortfolioSection.navItems;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 66,
          child: Row(
            children: [
              Text(
                'Menu',
                style: type.label.copyWith(color: colors.textTertiary),
              ),
              const Spacer(),
              AppIconButton(
                icon: Icons.close_rounded,
                tooltip: 'Close menu',
                onPressed: onClose,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        for (var i = 0; i < items.length; i++)
          _Staggered(
            progress: _rowProgress(i, items.length),
            child: MobileMenuRow(
              section: items[i],
              isActive: items[i] == active,
              onTap: () => onNavigate(items[i]),
            ),
          ),
        const Spacer(),
        Opacity(
          opacity: _rowProgress(items.length, items.length + 1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(height: 1, color: colors.border),
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                label: 'Download CV',
                icon: Icons.arrow_downward_rounded,
                variant: AppButtonVariant.outline,
                onPressed: onDownloadCv,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                email,
                style: type.mono.copyWith(color: colors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ],
    );
  }
}

class _Staggered extends StatelessWidget {
  const _Staggered({required this.progress, required this.child});

  final double progress;
  final Widget child;

  @override
  Widget build(BuildContext context) => Opacity(
    opacity: progress,
    child: Transform.translate(
      offset: Offset(0, 24 * (1 - progress)),
      child: child,
    ),
  );
}
