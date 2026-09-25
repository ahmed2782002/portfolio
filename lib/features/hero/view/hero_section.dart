import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:portfolio/core/constants/app_animations.dart';
import 'package:portfolio/core/constants/app_spacing.dart';
import 'package:portfolio/core/di/app_scope.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/core/utils/responsive.dart';
import 'package:portfolio/features/hero/view_model/hero_view_model.dart';
import 'package:portfolio/features/hero/widgets/hero_copy.dart';
import 'package:portfolio/features/hero/widgets/hero_portrait.dart';
import 'package:portfolio/features/home/models/portfolio_section.dart';
import 'package:portfolio/shared/widgets/ambient_backdrop.dart';
import 'package:portfolio/shared/widgets/section_shell.dart';

/// The opening screen.
///
/// Everything a recruiter needs in the first ten seconds is above the fold:
/// name, role, the stack, a one-line statement of what he actually builds, a
/// route into the work, and the CV. The composition earns attention with
/// layering and a slow pointer parallax rather than with a wall of motion.
class HeroSection extends StatefulWidget {
  const HeroSection({
    super.key,
    required this.onNavigate,
    required this.onDownloadCv,
  });

  final ValueChanged<PortfolioSection> onNavigate;
  final VoidCallback onDownloadCv;

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with TickerProviderStateMixin {
  late final HeroViewModel _viewModel = HeroViewModel(context.repository);

  /// One-shot page-load reveal.
  late final AnimationController _entrance = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  )..forward();

  /// Slow, continuous drift for the floating labels.
  late final AnimationController _drift = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 9),
  )..repeat();

  /// Staggered slices of [_entrance], created once and reused.
  final Map<(double, double), CurvedAnimation> _steps = {};

  Animation<double> _step(double begin, double end) => _steps.putIfAbsent(
    (begin, end),
    () => CurvedAnimation(
      parent: _entrance,
      curve: Interval(begin, end, curve: AppAnimations.emphasized),
    ),
  );

  @override
  void dispose() {
    for (final step in _steps.values) {
      step.dispose();
    }
    _entrance.dispose();
    _drift.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  bool get _parallaxEnabled => !context.reduceMotion && !context.isMobile;

  void _onHover(PointerHoverEvent event) {
    if (!_parallaxEnabled) return;
    final box = context.findRenderObject();
    if (box is RenderBox && box.hasSize) {
      _viewModel.onPointerMoved(event.localPosition, box.size);
    }
  }

  @override
  Widget build(BuildContext context) {
    final stacked = context.screen.index <= ScreenSize.expanded.index;
    final parallax = _parallaxEnabled ? _viewModel.parallax : null;

    final portrait = HeroPortrait(
      width: stacked
          ? math.min(context.screenSize.width * 0.62, 300.0)
          : math.min(
              context.screen == ScreenSize.xlarge ? 400 : 340,
              context.screenSize.width * 0.28,
            ),
      profile: _viewModel.profile,
      entrance: _step(0.15, 0.75),
      drift: _drift,
      parallax: parallax,
    );

    final copy = HeroCopy(
      viewModel: _viewModel,
      step: _step,
      onNavigate: widget.onNavigate,
      onDownloadCv: widget.onDownloadCv,
      portrait: stacked
          ? Padding(
              padding: const EdgeInsets.only(
                top: AppSpacing.xxl,
                bottom: AppSpacing.x3l,
              ),
              child: Center(child: portrait),
            )
          : null,
    );

    return MouseRegion(
      opaque: false,
      onHover: _onHover,
      onExit: (_) => _viewModel.onPointerLeft(),
      child: Stack(
        children: [
          Positioned.fill(
            child: AmbientBackdrop(
              gridSpacing: context.isMobile ? 48 : 72,
              fadeFrom: 0.45,
              parallax: parallax,
            ),
          ),
          SectionShell(
            verticalPadding: stacked ? 96 : 120,
            child: stacked
                ? copy
                : Row(
                    children: [
                      Expanded(flex: 7, child: copy),
                      const SizedBox(width: AppSpacing.x5l),
                      Expanded(
                        flex: 5,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: portrait,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
