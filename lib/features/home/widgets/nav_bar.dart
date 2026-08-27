import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../../../core/constants/app_animations.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../data/portfolio_data.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/hover_builder.dart';
import '../../../shared/widgets/theme_toggle.dart';
import '../portfolio_section.dart';

/// Sticky top navigation.
///
/// Two states, cross-faded on scroll: transparent and roomy at the top of the
/// page, then condensed onto a blurred, bordered bar once content passes under
/// it. The active-section indicator is an underline that grows on the current
/// item as it shrinks on the last — the travel reads as one indicator moving.
class NavBar extends StatelessWidget {
  const NavBar({
    super.key,
    required this.active,
    required this.onNavigate,
    required this.condensed,
    required this.isDark,
    required this.onToggleTheme,
    required this.onOpenMenu,
    required this.onDownloadCv,
  });

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
      decoration: BoxDecoration(
        color: condensed ? colors.scrim : Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: condensed ? colors.border : Colors.transparent,
          ),
        ),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: condensed
              ? ImageFilter.blur(sigmaX: 18, sigmaY: 18)
              : ImageFilter.blur(sigmaX: 0.001, sigmaY: 0.001),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: context.gutter),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AppSpacing.maxContentWidth,
                ),
                child: Row(
                  children: [
                    _Wordmark(onTap: () => onNavigate(PortfolioSection.home)),
                    const Spacer(),
                    if (!compact) ...[
                      for (final section in PortfolioSection.navItems)
                        _NavItem(
                          section: section,
                          isActive: section == active,
                          onTap: () => onNavigate(section),
                        ),
                      const SizedBox(width: AppSpacing.lg),
                      Container(
                        width: 1,
                        height: 22,
                        color: colors.border,
                      ),
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
          ),
        ),
      ),
    );
  }
}

/// `AE ·` monogram plus the full name, which drops away on narrow layouts.
class _Wordmark extends StatelessWidget {
  const _Wordmark({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;

    return HoverBuilder(
      onTap: onTap,
      semanticLabel: 'Back to top',
      builder: (context, t, _) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color.lerp(colors.primary, colors.primary, t),
              borderRadius: AppRadius.brXs,
              boxShadow: [
                BoxShadow(
                  color: colors.primary.withValues(alpha: 0.32 * t),
                  blurRadius: 16 * t,
                  offset: Offset(0, 3 * t),
                ),
              ],
            ),
            child: Text(
              'AE',
              style: type.labelSmall.copyWith(
                color: colors.onPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (context.screen.index >= 1) ...[
            const SizedBox(width: AppSpacing.sm),
            Text(
              PortfolioData.profile.shortName,
              style: type.bodyStrong.copyWith(
                color: Color.lerp(colors.textPrimary, colors.primary, t),
                fontFamily: 'SpaceGrotesk',
                letterSpacing: -0.2,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.section,
    required this.isActive,
    required this.onTap,
  });

  final PortfolioSection section;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return HoverBuilder(
      onTap: onTap,
      semanticLabel: 'Go to ${section.label}',
      builder: (context, hover, _) {
        final emphasis = isActive ? 1.0 : hover;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                section.label,
                style: context.type.bodySmall.copyWith(
                  color: Color.lerp(
                    colors.textSecondary,
                    isActive ? colors.textPrimary : colors.primary,
                    emphasis,
                  ),
                  fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
              const SizedBox(height: 5),
              // The indicator: full width when active, a short stub on hover.
              AnimatedContainer(
                duration: AppAnimations.base,
                curve: AppAnimations.emphasized,
                height: 2,
                width: isActive ? 18 : 10 * hover,
                decoration: BoxDecoration(
                  color: isActive
                      ? colors.primary
                      : colors.primary.withValues(alpha: 0.5 * hover),
                  borderRadius: AppRadius.brPill,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
