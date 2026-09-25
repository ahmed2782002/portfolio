import 'package:flutter/material.dart';

import 'package:portfolio/core/constants/app_animations.dart';
import 'package:portfolio/core/constants/app_spacing.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/features/home/models/portfolio_section.dart';
import 'package:portfolio/features/home/widgets/nav_item.dart';
import 'package:portfolio/features/home/widgets/nav_wordmark.dart';
import 'package:portfolio/shared/widgets/app_button.dart';
import 'package:portfolio/shared/widgets/app_icon_button.dart';
import 'package:portfolio/shared/widgets/theme_toggle.dart';

/// Sticky top navigation.
///
/// Two states, cross-faded on scroll: transparent and roomy at the top of the
/// page, then condensed onto a solid, bordered bar once content passes under
/// it. The bar deliberately has no backdrop blur: on the web a blur has to be
/// recomputed over the moving page on every scroll frame, which made it the
/// most expensive thing the site painted.
class NavBar extends StatelessWidget {
  const NavBar({
    super.key,
    required this.shortName,
    required this.active,
    required this.onNavigate,
    required this.condensed,
    required this.isDark,
    required this.onToggleTheme,
    required this.onOpenMenu,
    required this.onDownloadCv,
  });

  final String shortName;
  final PortfolioSection active;
  final ValueChanged<PortfolioSection> onNavigate;

  /// True once the page has scrolled past the hero's first fold.
  final bool condensed;

  final bool isDark;
  final VoidCallback onToggleTheme;
  final VoidCallback onOpenMenu;
  final VoidCallback onDownloadCv;

  static const double heightExpanded = 88;
  static const double heightCondensed = 66;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final compact = context.isTabletOrBelow;

    return AnimatedContainer(
      duration: AppAnimations.base,
      curve: AppAnimations.standard,
      height: condensed ? heightCondensed : heightExpanded,
      padding: EdgeInsets.symmetric(horizontal: context.gutter),
      decoration: BoxDecoration(
        color: condensed ? colors.scrim : Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: condensed ? colors.border : Colors.transparent,
          ),
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSpacing.maxContentWidth,
          ),
          child: Row(
            children: [
              NavWordmark(
                name: shortName,
                onTap: () => onNavigate(PortfolioSection.home),
              ),
              const Spacer(),
              if (!compact) ...[
                for (final section in PortfolioSection.navItems)
                  NavItem(
                    section: section,
                    isActive: section == active,
                    onTap: () => onNavigate(section),
                  ),
                const SizedBox(width: AppSpacing.lg),
                Container(width: 1, height: 22, color: colors.border),
                const SizedBox(width: AppSpacing.lg),
                AppButton(
                  label: 'CV',
                  icon: Icons.arrow_downward_rounded,
                  variant: AppButtonVariant.quiet,
                  onPressed: onDownloadCv,
                ),
                const SizedBox(width: AppSpacing.lg),
              ],
              ThemeToggle(isDark: isDark, onToggle: onToggleTheme),
              if (compact) ...[
                const SizedBox(width: AppSpacing.xs),
                AppIconButton(
                  icon: Icons.menu_rounded,
                  tooltip: 'Open menu',
                  onPressed: onOpenMenu,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
