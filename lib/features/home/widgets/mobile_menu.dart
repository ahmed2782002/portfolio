import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_animations.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../data/portfolio_data.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/hover_builder.dart';
import '../portfolio_section.dart';

/// The compact-layout menu.
///
/// A full-bleed panel rather than a Material drawer: the section names become
/// the whole screen, numbered like the section eyebrows, and stagger in behind
/// a blur. Closing runs the same motion in reverse, so it reads as one surface
/// opening and shutting rather than a sheet appearing from nowhere.
class MobileMenu extends StatefulWidget {
  const MobileMenu({
    super.key,
    required this.visible,
    required this.active,
    required this.onNavigate,
    required this.onClose,
    required this.onDownloadCv,
  });

  final bool visible;
  final PortfolioSection active;
  final ValueChanged<PortfolioSection> onNavigate;
  final VoidCallback onClose;
  final VoidCallback onDownloadCv;

  @override
  State<MobileMenu> createState() => _MobileMenuState();
}

class _MobileMenuState extends State<MobileMenu>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppAnimations.slow,
    reverseDuration: AppAnimations.base,
    value: widget.visible ? 1 : 0,
  );

  late final Animation<double> _t = CurvedAnimation(
    parent: _controller,
    curve: AppAnimations.emphasized,
    reverseCurve: AppAnimations.standard,
  );

  @override
  void didUpdateWidget(MobileMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visible != oldWidget.visible) {
      widget.visible ? _controller.forward() : _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AnimatedBuilder(
      animation: _t,
      builder: (context, _) {
        final t = _t.value;
        if (t == 0) return const SizedBox.shrink();

        return IgnorePointer(
          ignoring: !widget.visible,
          child: CallbackShortcuts(
            bindings: {
              const SingleActivator(LogicalKeyboardKey.escape): widget.onClose,
            },
            child: Focus(
              autofocus: widget.visible,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 22 * t, sigmaY: 22 * t),
                      child: ColoredBox(
                        color: colors.background.withValues(alpha: 0.96 * t),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: SafeArea(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.gutter,
                        ),
                        child: _MenuBody(
                          t: t,
                          active: widget.active,
                          onNavigate: widget.onNavigate,
                          onClose: widget.onClose,
                          onDownloadCv: widget.onDownloadCv,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MenuBody extends StatelessWidget {
  const _MenuBody({
    required this.t,
    required this.active,
    required this.onNavigate,
    required this.onClose,
    required this.onDownloadCv,
  });

  final double t;
  final PortfolioSection active;
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
          Opacity(
            opacity: _rowProgress(i, items.length),
            child: Transform.translate(
              offset: Offset(0, 24 * (1 - _rowProgress(i, items.length))),
              child: _MenuRow(
                section: items[i],
                isActive: items[i] == active,
                onTap: () => onNavigate(items[i]),
              ),
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
                PortfolioData.profile.email,
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

class _MenuRow extends StatelessWidget {
  const _MenuRow({
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
    final type = context.type;

    return HoverBuilder(
      onTap: onTap,
      semanticLabel: 'Go to ${section.label}',
      builder: (context, hover, _) => Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            SizedBox(
              width: 34,
              child: Text(
                section.displayIndex,
                style: type.label.copyWith(
                  color: isActive ? colors.primary : colors.textTertiary,
                ),
              ),
            ),
            Text(
              section.label,
              style: type.title.copyWith(
                color: isActive || hover > 0
                    ? colors.primary
                    : colors.textPrimary,
              ),
            ),
            if (isActive) ...[
              const SizedBox(width: AppSpacing.sm),
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: colors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
