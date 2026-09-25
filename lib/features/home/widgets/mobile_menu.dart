import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:portfolio/core/constants/app_animations.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/features/home/models/portfolio_section.dart';
import 'package:portfolio/features/home/widgets/mobile_menu_body.dart';

/// The compact-layout menu.
///
/// A full-bleed panel rather than a Material drawer: the section names become
/// the whole screen, numbered like the section eyebrows, and stagger in over
/// the page. Closing runs the same motion in reverse, so it reads as one
/// surface opening and shutting rather than a sheet appearing from nowhere.
class MobileMenu extends StatefulWidget {
  const MobileMenu({
    super.key,
    required this.visible,
    required this.active,
    required this.email,
    required this.onNavigate,
    required this.onClose,
    required this.onDownloadCv,
  });

  final bool visible;
  final PortfolioSection active;
  final String email;
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

        // The panel is near-opaque, so a backdrop blur under it was invisible
        // while costing a full-screen blur on every animation frame.
        return IgnorePointer(
          ignoring: !widget.visible,
          child: CallbackShortcuts(
            bindings: {
              const SingleActivator(LogicalKeyboardKey.escape): widget.onClose,
            },
            child: Focus(
              autofocus: widget.visible,
              child: ColoredBox(
                color: colors.background.withValues(alpha: 0.97 * t),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: context.gutter),
                    child: MobileMenuBody(
                      t: t,
                      active: widget.active,
                      email: widget.email,
                      onNavigate: widget.onNavigate,
                      onClose: widget.onClose,
                      onDownloadCv: widget.onDownloadCv,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
