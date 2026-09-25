import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/core/theme/app_colors.dart';

/// Ambient backdrop: a sparse dot grid that fades out downwards, under two soft
/// mint and lavender glow washes.
///
/// The two are painted on separate layers. The grid (a save-layer plus a few
/// hundred dots) is painted once and cached; only the cheap washes repaint
/// when [parallax] moves, and they do so without rebuilding any widget.
class AmbientBackdrop extends StatelessWidget {
  const AmbientBackdrop({
    super.key,
    this.gridSpacing = 56,
    this.fadeFrom = 0.0,
    this.showWashes = true,
    this.parallax,
  });

  /// Grid pitch in logical pixels.
  final double gridSpacing;

  /// Fraction of the height at which the pattern starts fading out.
  final double fadeFrom;

  final bool showWashes;

  /// Pointer-driven offset for the washes. `null` keeps them still.
  final ValueListenable<Offset>? parallax;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Stack(
      fit: StackFit.expand,
      children: [
        if (showWashes)
          RepaintBoundary(
            child: CustomPaint(
              painter: _WashPainter(colors: colors, parallax: parallax),
            ),
          ),
        RepaintBoundary(
          child: CustomPaint(
            isComplex: true,
            painter: _DotGridPainter(
              colors: colors,
              gridSpacing: gridSpacing,
              fadeFrom: fadeFrom,
            ),
          ),
        ),
      ],
    );
  }
}

class _WashPainter extends CustomPainter {
  _WashPainter({required this.colors, this.parallax})
    : super(repaint: parallax);

  final AppColors colors;
  final ValueListenable<Offset>? parallax;

  @override
  void paint(Canvas canvas, Size size) {
    final offset = (parallax?.value ?? Offset.zero) * 1.4;
    final radius = math.max(size.width, size.height) * 0.55;

    void wash(Offset centre, Color color, double alpha) {
      final rect = Rect.fromCircle(center: centre, radius: radius);
      canvas.drawRect(
        rect,
        Paint()
          ..shader = RadialGradient(
            colors: [
              color.withValues(alpha: alpha),
              color.withValues(alpha: 0),
            ],
          ).createShader(rect),
      );
    }

    wash(
      Offset(size.width * 0.78, size.height * 0.20) + offset,
      colors.primary,
      colors.isDark ? 0.18 : 0.22,
    );
    wash(
      Offset(size.width * 0.18, size.height * 0.65) - offset * 0.6,
      colors.secondary,
      colors.isDark ? 0.15 : 0.18,
    );
  }

  @override
  bool shouldRepaint(_WashPainter old) =>
      old.colors != colors || old.parallax != parallax;
}

class _DotGridPainter extends CustomPainter {
  _DotGridPainter({
    required this.colors,
    required this.gridSpacing,
    required this.fadeFrom,
  });

  final AppColors colors;
  final double gridSpacing;
  final double fadeFrom;

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    canvas.saveLayer(bounds, Paint());

    final dotPaint = Paint()
      ..color = colors.secondary.withValues(alpha: colors.isDark ? 0.07 : 0.06);

    final step = gridSpacing.clamp(56.0, 72.0);
    for (var x = step / 2; x <= size.width; x += step) {
      for (var y = step / 2; y <= size.height; y += step) {
        canvas.drawCircle(Offset(x, y), 0.9, dotPaint);
      }
    }

    // Fade the grid out towards the bottom edge.
    canvas.drawRect(
      bounds,
      Paint()
        ..blendMode = BlendMode.dstIn
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: const [Colors.white, Colors.white, Colors.transparent],
          stops: [0.0, fadeFrom.clamp(0.0, 0.99), 1.0],
        ).createShader(bounds),
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(_DotGridPainter old) =>
      old.colors != colors ||
      old.gridSpacing != gridSpacing ||
      old.fadeFrom != fadeFrom;
}
