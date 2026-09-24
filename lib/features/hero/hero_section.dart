import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_animations.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/portfolio_models.dart';
import '../../data/portfolio_data.dart';
import '../../shared/widgets/ambient_backdrop.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/section_shell.dart';
import '../../shared/widgets/social_icon_bar.dart';
import '../home/portfolio_section.dart';
import 'widgets/hero_portrait.dart';

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

  Offset _parallax = Offset.zero;

  /// Maps the pointer's position within the hero to a small opposing offset.
  ///
  /// [size] is the hero's laid-out size, not its constraints: the section sits
  /// in a scroll view, so the incoming `maxHeight` is unbounded and dividing by
  /// it would yield NaN — which then poisons every rect painted from the
  /// parallax offset.
  void _onHover(PointerHoverEvent event, Size size) {
    if (context.reduceMotion || context.isMobile) return;
    if (size.width <= 0 ||
        size.height <= 0 ||
        !size.width.isFinite ||
        !size.height.isFinite) {
      return;
    }
    final centre = Offset(size.width / 2, size.height / 2);
    final delta = event.localPosition - centre;
    setState(() {
      _parallax = Offset(
        (delta.dx / size.width) * -22,
        (delta.dy / size.height) * -16,
      );
    });
  }

  /// The hero's painted size. Falls back to the incoming constraints on the
  /// first frame, before the render box has been laid out.
  Size _heroSize(BuildContext context, BoxConstraints constraints) {
    final box = context.findRenderObject();
    if (box is RenderBox && box.hasSize) return box.size;
    return Size(constraints.maxWidth, constraints.maxHeight);
  }

  @override
  void dispose() {
    _entrance.dispose();
    _drift.dispose();
    super.dispose();
  }

  /// Staggered sub-animation of the entrance controller.
  Animation<double> _step(double begin, double end) => CurvedAnimation(
        parent: _entrance,
        curve: Interval(begin, end, curve: AppAnimations.emphasized),
      );

  @override
  Widget build(BuildContext context) {
    final screen = context.screen;
    final stacked = screen.index <= ScreenSize.expanded.index;
    final reduce = context.reduceMotion;

    return LayoutBuilder(
      builder: (context, constraints) {
        return MouseRegion(
          opaque: false,
          onHover: (event) => _onHover(event, _heroSize(context, constraints)),
          onExit: (_) {
            if (_parallax != Offset.zero) {
              setState(() => _parallax = Offset.zero);
            }
          },
          child: Stack(
            children: [
              Positioned.fill(
                child: AnimatedBackdrop(
                  drift: _drift,
                  parallax: reduce ? Offset.zero : _parallax,
                  enabled: !reduce,
                ),
              ),
              SectionShell(
                verticalPadding: stacked ? 96 : 120,
                child: stacked
                    ? _StackedLayout(
                        entrance: _entrance,
                        drift: _drift,
                        step: _step,
                        parallax: reduce ? Offset.zero : _parallax,
                        onNavigate: widget.onNavigate,
                        onDownloadCv: widget.onDownloadCv,
                      )
                    : _SideBySideLayout(
                        entrance: _entrance,
                        drift: _drift,
                        step: _step,
                        parallax: reduce ? Offset.zero : _parallax,
                        onNavigate: widget.onNavigate,
                        onDownloadCv: widget.onDownloadCv,
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// The backdrop only repaints while the pointer is actually moving.
class AnimatedBackdrop extends StatelessWidget {
  const AnimatedBackdrop({
    super.key,
    required this.drift,
    required this.parallax,
    required this.enabled,
  });

  final Animation<double> drift;
  final Offset parallax;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return AmbientBackdrop(
      gridSpacing: context.isMobile ? 48 : 72,
      fadeFrom: 0.45,
      parallax: enabled ? parallax * 1.4 : Offset.zero,
    );
  }
}

// -----------------------------------------------------------------------------
// Layouts
// -----------------------------------------------------------------------------

class _SideBySideLayout extends StatelessWidget {
  const _SideBySideLayout({
    required this.entrance,
    required this.drift,
    required this.step,
    required this.parallax,
    required this.onNavigate,
    required this.onDownloadCv,
  });

  final AnimationController entrance;
  final AnimationController drift;
  final Animation<double> Function(double, double) step;
  final Offset parallax;
  final ValueChanged<PortfolioSection> onNavigate;
  final VoidCallback onDownloadCv;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 7,
          child: _HeroCopy(
            step: step,
            onNavigate: onNavigate,
            onDownloadCv: onDownloadCv,
          ),
        ),
        const SizedBox(width: AppSpacing.x5l),
        Expanded(
          flex: 5,
          child: Align(
            alignment: Alignment.centerRight,
            child: AnimatedBuilder(
              animation: Listenable.merge([entrance, drift]),
              builder: (context, _) => HeroPortrait(
                width: math.min(
                  context.screen == ScreenSize.xlarge ? 400 : 340,
                  MediaQuery.sizeOf(context).width * 0.28,
                ),
                entrance: step(0.15, 0.75).value,
                float: drift.value,
                parallax: parallax,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _StackedLayout extends StatelessWidget {
  const _StackedLayout({
    required this.entrance,
    required this.drift,
    required this.step,
    required this.parallax,
    required this.onNavigate,
    required this.onDownloadCv,
  });

  final AnimationController entrance;
  final AnimationController drift;
  final Animation<double> Function(double, double) step;
  final Offset parallax;
  final ValueChanged<PortfolioSection> onNavigate;
  final VoidCallback onDownloadCv;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final portraitWidth = math.min(width * 0.62, 300.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _HeroCopy(
          step: step,
          onNavigate: onNavigate,
          onDownloadCv: onDownloadCv,
          portrait: Padding(
            padding: const EdgeInsets.only(
              top: AppSpacing.xxl,
              bottom: AppSpacing.x3l,
            ),
            child: Center(
              child: AnimatedBuilder(
                animation: Listenable.merge([entrance, drift]),
                builder: (context, _) => HeroPortrait(
                  width: portraitWidth,
                  entrance: step(0.15, 0.75).value,
                  float: drift.value,
                  parallax: parallax,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// Copy block
// -----------------------------------------------------------------------------

class _HeroCopy extends StatelessWidget {
  const _HeroCopy({
    required this.step,
    required this.onNavigate,
    required this.onDownloadCv,
    this.portrait,
  });

  final Animation<double> Function(double, double) step;
  final ValueChanged<PortfolioSection> onNavigate;
  final VoidCallback onDownloadCv;

  /// Injected between the role line and the tagline on stacked layouts.
  final Widget? portrait;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;
    final profile = PortfolioData.profile;
    final stacked = portrait != null;

    final nameGradient = LinearGradient(
      colors: colors.isDark
          ? const [
              AppColors.modernMint,
              AppColors.lavenderPurple,
            ]
          : const [
              Color(0xFF168A78),
              Color(0xFF73368E),
            ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _Rise(step(0.00, 0.40), child: const _StatusPill()),
        const SizedBox(height: AppSpacing.xl),

        // The tripartite name styled with the project's signature gradient
        // blending modern mint and lavender purple.
        _Rise(
          step(0.06, 0.50),
          child: _GradientText(
            'Ahmed Esam',
            style: type.display1,
            gradient: nameGradient,
          ),
        ),
        _Rise(
          step(0.10, 0.54),
          child: _GradientText(
            'Abdelsalam',
            style: type.display1,
            gradient: nameGradient,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        _Rise(
          step(0.16, 0.60),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.modernMint.withValues(
                    alpha: colors.isDark ? 0.22 : 0.35,
                  ),
                  AppColors.lavenderPurple.withValues(
                    alpha: colors.isDark ? 0.22 : 0.25,
                  ),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.lavenderPurple.withValues(alpha: 0.45),
                width: 1.2,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.modernMint,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Flutter Developer',
                  style: type.label.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),

        if (stacked) portrait!,

        SizedBox(height: stacked ? 0 : AppSpacing.xl),
        _Rise(
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

        _Rise(
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

        _Rise(step(0.38, 0.82), child: const _StatRail()),
        const SizedBox(height: AppSpacing.xl),

        _Rise(
          step(0.44, 0.88),
          child: SocialIconBar(
            links: PortfolioData.socialLinks,
            emailUrl: PortfolioData.profile.mailtoUri,
            size: 44,
          ),
        ),
      ],
    );
  }
}

/// Fade + rise driven by an interval of the hero's entrance controller.
class _Rise extends StatelessWidget {
  const _Rise(this.animation, {required this.child});

  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: FadeTransition(
        opacity: animation,
        child: AnimatedBuilder(
          animation: animation,
          child: child,
          builder: (context, child) => Transform.translate(
            offset: Offset(0, 22 * (1 - animation.value)),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Renders text with a shader mask linear gradient.
class _GradientText extends StatelessWidget {
  const _GradientText(
    this.text, {
    required this.style,
    required this.gradient,
  });

  final String text;
  final TextStyle style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        style: style.copyWith(color: Colors.white),
      ),
    );
  }
}

/// Live status: the current employer, from the CV's experience section.
class _StatusPill extends StatelessWidget {
  const _StatusPill();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final entry = PortfolioData.experience.first;
    final isCurrent = entry.period.toLowerCase().contains('present');

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: AppRadius.brPill,
        border: Border.all(color: colors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _PulseDot(color: isCurrent ? colors.success : colors.textTertiary),
          const SizedBox(width: AppSpacing.xs),
          Text(
            isCurrent
                ? 'Currently at ${entry.company}'
                : 'Previously at ${entry.company}',
            style: context.type.labelSmall.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(width: AppSpacing.xs),
          Container(width: 1, height: 11, color: colors.border),
          const SizedBox(width: AppSpacing.xs),
          Text(
            entry.workMode,
            style: context.type.labelSmall.copyWith(color: colors.textTertiary),
          ),
        ],
      ),
    );
  }
}

/// The one piece of ambient looping motion on the page — a slow breath on the
/// status dot. Suppressed under reduced motion.
class _PulseDot extends StatefulWidget {
  const _PulseDot({required this.color});

  final Color color;

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2200),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dot = Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
    );

    if (context.reduceMotion) return SizedBox.square(dimension: 14, child: Center(child: dot));

    return SizedBox.square(
      dimension: 14,
      child: AnimatedBuilder(
        animation: _controller,
        child: dot,
        builder: (context, child) {
          final t = Curves.easeOut.transform(_controller.value);
          return Stack(
            alignment: Alignment.center,
            children: [
              Opacity(
                opacity: (1 - t) * 0.45,
                child: Container(
                  width: 6 + 8 * t,
                  height: 6 + 8 * t,
                  decoration: BoxDecoration(
                    color: widget.color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              child!,
            ],
          );
        },
      ),
    );
  }
}

/// Three numbers, hairline-separated. Every value is countable from the CV.
class _StatRail extends StatelessWidget {
  const _StatRail();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;
    final stats = PortfolioData.profile.stats;

    Widget cell(Stat stat) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              stat.value,
              style: type.title.copyWith(color: colors.textPrimary),
            ),
            const SizedBox(height: 2),
            Text(
              stat.label,
              style: type.labelSmall.copyWith(color: colors.textSecondary),
            ),
          ],
        );

    return Wrap(
      spacing: AppSpacing.xxl,
      runSpacing: AppSpacing.lg,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (var i = 0; i < stats.length; i++) ...[
          if (i > 0)
            Container(width: 1, height: 34, color: colors.border),
          cell(stats[i]),
        ],
      ],
    );
  }
}
