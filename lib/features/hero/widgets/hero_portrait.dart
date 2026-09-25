import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/data/models/models.dart';
import 'package:portfolio/features/hero/widgets/glass_label.dart';
import 'package:portfolio/features/hero/widgets/photo_plate.dart';

/// The hero's portrait composition.
///
/// The photo sits in a layered plate: an arched aura behind it, the photo in
/// an arched window, and glass technology labels floating at different depths.
///
/// Every layer is built once and cached behind a [RepaintBoundary]; the
/// entrance, the drift and the pointer parallax only move and fade those
/// layers. Before, the whole composition, photo and shadows included, was
/// rebuilt and repainted on every frame of the endless drift.
class HeroPortrait extends StatelessWidget {
  const HeroPortrait({
    super.key,
    required this.width,
    required this.profile,
    required this.entrance,
    required this.drift,
    this.parallax,
  });

  final double width;
  final Profile profile;

  /// 0 → 1 page-load reveal.
  final Animation<double> entrance;

  /// Continuous 0 → 1 loop driving the floating labels.
  final Animation<double> drift;

  /// Pointer parallax in logical pixels. `null` keeps the layers still.
  final ValueListenable<Offset>? parallax;

  /// The source photo is 3:4 and so is the plate — nothing is cropped.
  static const double _aspect = 3 / 4;

  /// Fractional anchors around the plate, kept off the face.
  static const _anchors = <({double x, double y, double depth})>[
    (x: -0.10, y: 0.30, depth: 1.0),
    (x: 0.72, y: 0.11, depth: 0.6),
    (x: 0.66, y: 0.62, depth: 1.3),
    (x: -0.06, y: 0.80, depth: 0.8),
  ];

  Offset get _offset => parallax?.value ?? Offset.zero;

  @override
  Widget build(BuildContext context) {
    final height = width / _aspect;
    final layers = Listenable.merge([entrance, ?parallax]);

    final aura = RepaintBoundary(child: _Aura(width: width + 24));
    final plate = RepaintBoundary(
      child: PhotoPlate(
        asset: profile.photoAsset,
        width: width,
        name: profile.fullName,
      ),
    );

    final count = math.min(profile.focusAreas.length, _anchors.length);
    final labels = [
      for (var i = 0; i < count; i++)
        RepaintBoundary(child: GlassLabel(text: profile.focusAreas[i])),
    ];

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedBuilder(
            animation: layers,
            builder: (context, _) {
              final e = entrance.value;
              final p = _offset;
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: -12 + p.dx * 0.3,
                    top: -12 + p.dy * 0.3,
                    width: width + 24,
                    height: height + 20,
                    child: Opacity(opacity: e * 0.85, child: aura),
                  ),
                  Positioned(
                    left: p.dx * -0.4,
                    top: p.dy * -0.4,
                    width: width,
                    height: height,
                    child: Transform.scale(
                      scale: 0.95 + 0.05 * e,
                      child: Opacity(opacity: e, child: plate),
                    ),
                  ),
                ],
              );
            },
          ),
          AnimatedBuilder(
            animation: Listenable.merge([layers, drift]),
            builder: (context, _) {
              final p = _offset;
              // Labels arrive last, once the plate has settled.
              final opacity = ((entrance.value - 0.55) / 0.45).clamp(0.0, 1.0);
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  for (var i = 0; i < count; i++)
                    Positioned(
                      left:
                          width * _anchors[i].x +
                          p.dx * _anchors[i].depth * 1.6,
                      top:
                          height * _anchors[i].y +
                          p.dy * _anchors[i].depth * 1.6 +
                          math.sin(drift.value * 2 * math.pi + i * 1.7) *
                              5 *
                              _anchors[i].depth,
                      child: Opacity(opacity: opacity, child: labels[i]),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

/// The arched pastel plate behind the photo.
class _Aura extends StatelessWidget {
  const _Aura({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    final isDark = context.colors.isDark;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(width / 2),
          bottom: const Radius.circular(32),
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            isDark
                ? AppColors.lavenderPurple.withValues(alpha: 0.18)
                : const Color(0xFFDCD0FA).withValues(alpha: 0.65),
            isDark
                ? AppColors.modernMint.withValues(alpha: 0.12)
                : const Color(0xFFD2F4EC).withValues(alpha: 0.50),
          ],
        ),
        border: Border.all(
          color: AppColors.lavenderPurple.withValues(
            alpha: isDark ? 0.35 : 0.40,
          ),
          width: 1.5,
        ),
      ),
    );
  }
}
