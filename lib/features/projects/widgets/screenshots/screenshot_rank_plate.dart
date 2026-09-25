import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:portfolio/data/models/models.dart';
import 'package:portfolio/shared/widgets/device/screenshot_plate.dart';

/// One screenshot, transformed by its signed distance from the active position.
class ScreenshotRankPlate extends StatelessWidget {
  const ScreenshotRankPlate({
    super.key,
    required this.screenshot,
    required this.distance,
    required this.spread,
    required this.height,
    required this.tint,
    required this.onTap,
    required this.label,
  });

  final Screenshot screenshot;

  /// Signed distance from the active position. 0 is fully forward.
  final double distance;

  final double spread;
  final double height;
  final Color tint;
  final VoidCallback? onTap;
  final String label;

  /// How many neighbours stay visible on each side of the active plate.
  static const int visibleRadius = 2;

  @override
  Widget build(BuildContext context) {
    final d = distance;
    final abs = d.abs();

    // Flat depth: the active plate is full size and opaque; neighbours sit
    // behind it, smaller and dimmer. No rotation or perspective — those made
    // the plates shimmer while travelling.
    final offsetX = spread * d.sign * math.pow(abs, 0.85);
    final scale = (1 - 0.16 * abs).clamp(0.6, 1.0);
    final opacity = abs > visibleRadius + 0.5
        ? 0.0
        : (1 - 0.32 * abs).clamp(0.0, 1.0);
    final elevation = (1 - 0.55 * abs).clamp(0.0, 1.0);

    // Laid out at full height and shrunk with a transform, never re-laid out:
    // a constant width keeps the image's decode size constant, so the picture
    // is decoded once instead of on every animation frame (the old flicker).
    final width = ScreenshotPlate.widthForHeight(screenshot, height);

    final transform = Matrix4.identity()
      ..translateByDouble(offsetX, 0, 0, 1)
      ..scaleByDouble(scale, scale, 1, 1);

    Widget plate = RepaintBoundary(
      child: ScreenshotPlate(
        screenshot: screenshot,
        width: width,
        elevation: elevation,
        tint: tint,
      ),
    );

    if (onTap != null) {
      plate = MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: plate,
        ),
      );
    }

    return Transform(
      transform: transform,
      alignment: Alignment.center,
      child: Opacity(
        opacity: opacity,
        child: Semantics(
          image: true,
          label: label,
          button: onTap != null,
          child: plate,
        ),
      ),
    );
  }
}
