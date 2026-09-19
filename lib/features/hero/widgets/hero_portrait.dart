import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/portfolio_data.dart';
import '../../../shared/widgets/app_image.dart';

/// The hero's portrait composition.
///
/// The photo is not dropped into a circular avatar. It sits in a layered plate:
/// an offset indigo outline behind it, a masked panel with a gradient foot that
/// grounds the figure against the page, an editorial vertical caption down the
/// right edge, and glass technology labels floating at two different depths.
///
/// The source photo is 3:4, and the plate is 3:4, so nothing about the subject
/// is cropped.
class HeroPortrait extends StatelessWidget {
  const HeroPortrait({
    super.key,
    required this.width,
    required this.entrance,
    required this.float,
    required this.parallax,
  });

  final double width;

  /// 0 → 1 page-load reveal.
  final double entrance;

  /// Continuous 0 → 1 → 0 drift driving the floating labels.
  final double float;

  /// Pointer parallax in logical pixels, already damped by the caller.
  final Offset parallax;

  static const double _aspect = 3 / 4;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final height = width / _aspect;
    final profile = PortfolioData.profile;

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 1. Arched pastel backing aura plate
          Positioned(
            left: -12 + parallax.dx * 0.3,
            top: -12 + parallax.dy * 0.3,
            width: width + 24,
            height: height + 20,
            child: Opacity(
              opacity: entrance * 0.85,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular((width + 24) / 2),
                    bottom: const Radius.circular(32),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      colors.isDark
                          ? AppColors.lavenderPurple.withValues(alpha: 0.18)
                          : const Color(0xFFDCD0FA).withValues(alpha: 0.65),
                      colors.isDark
                          ? AppColors.modernMint.withValues(alpha: 0.12)
                          : const Color(0xFFD2F4EC).withValues(alpha: 0.50),
                    ],
                  ),
                  border: Border.all(
                    color: colors.isDark
                        ? AppColors.lavenderPurple.withValues(alpha: 0.35)
                        : AppColors.lavenderPurple.withValues(alpha: 0.40),
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),

          // 2. The photo plate in a clean arched window
          Positioned(
            left: parallax.dx * -0.4,
            top: parallax.dy * -0.4,
            width: width,
            height: height,
            child: Transform.scale(
              scale: 0.95 + 0.05 * entrance,
              child: Opacity(
                opacity: entrance,
                child: _PhotoPlate(
                  asset: profile.photoAsset,
                  width: width,
                  name: profile.fullName,
                ),
              ),
            ),
          ),

          // 3. Floating labels
          ..._floatingLabels(context, width, height),
        ],
      ),
    );
  }

  List<Widget> _floatingLabels(
    BuildContext context,
    double width,
    double height,
  ) {
    final labels = PortfolioData.profile.focusAreas;
    // Fractional anchors around the plate; kept off the face, which sits in the
    // upper-middle third of the photo.
    const anchors = <({double x, double y, double depth, Alignment align})>[
      (x: -0.10, y: 0.30, depth: 1.0, align: Alignment.centerLeft),
      (x: 0.72, y: 0.11, depth: 0.6, align: Alignment.centerRight),
      (x: 0.66, y: 0.62, depth: 1.3, align: Alignment.centerRight),
      (x: -0.06, y: 0.80, depth: 0.8, align: Alignment.centerLeft),
    ];

    final count = math.min(labels.length, anchors.length);
    return [
      for (var i = 0; i < count; i++)
        Positioned(
          left: width * anchors[i].x + parallax.dx * anchors[i].depth * 1.6,
          top: height * anchors[i].y +
              parallax.dy * anchors[i].depth * 1.6 +
              math.sin((float * 2 * math.pi) + i * 1.7) * 5 * anchors[i].depth,
          child: Opacity(
            // Labels arrive last, once the plate has settled.
            opacity: ((entrance - 0.55) / 0.45).clamp(0.0, 1.0),
            child: _GlassLabel(text: labels[i]),
          ),
        ),
    ];
  }
}

class _PhotoPlate extends StatelessWidget {
  const _PhotoPlate({
    required this.asset,
    required this.width,
    required this.name,
  });

  final String asset;
  final double width;
  final String name;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final archRadius = BorderRadius.vertical(
      top: Radius.circular(width / 2),
      bottom: const Radius.circular(28),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: archRadius,
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: colors.isDark ? 0.35 : 0.12),
            blurRadius: 36,
            spreadRadius: -4,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: archRadius,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(
              color: colors.isDark
                  ? const Color(0xFF243241)
                  : AppColors.softLavender,
            ),
            AppImage(
              asset: asset,
              layoutWidth: width,
              fit: BoxFit.cover,
              semanticLabel: 'Portrait of $name',
            ),

            // Subtle bottom fade to anchor portrait
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    colors.background.withValues(alpha: 0.30),
                    colors.background.withValues(alpha: 0.70),
                  ],
                  stops: const [0.0, 0.60, 0.88, 1.0],
                ),
              ),
            ),

            // Arched outer hairline border
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: archRadius,
                border: Border.all(
                  color: colors.isDark
                      ? Colors.white.withValues(alpha: 0.15)
                      : AppColors.lavenderPurple.withValues(alpha: 0.35),
                  width: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A frosted technology label. Small, low contrast, and never covering the face.
class _GlassLabel extends StatelessWidget {
  const _GlassLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: colors.card.withValues(alpha: colors.isDark ? 0.82 : 0.90),
        borderRadius: AppRadius.brSm,
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: colors.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            text,
            style: context.type.labelSmall.copyWith(color: colors.textPrimary),
          ),
        ],
      ),
    );
  }
}
