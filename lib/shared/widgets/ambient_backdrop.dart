import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/extensions/context_extensions.dart';
import '../../core/theme/app_colors.dart';

/// The page's quiet background texture: a blueprint grid that fades out
/// downward, plus two very low-alpha washes in indigo and teal.
///
/// It is painted once into a [RepaintBoundary] and never animates — the depth
/// in the layout comes from content moving over it, not from the backdrop
/// moving on its own.
class AmbientBackdrop extends StatelessWidget {
  const AmbientBackdrop({
    super.key,
    this.gridSpacing = 64,
    this.fadeFrom = 0.0,
    this.showWashes = true,
    this.parallax = Offset.zero,
  });

  /// Grid pitch in logical pixels.
  final double gridSpacing;

  /// Fraction of the height at which the grid starts fading out.
  final double fadeFrom;

  final bool showWashes;

  /// Small offset applied to the washes so they drift with pointer parallax.
  final Offset parallax;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: _BackdropPainter(
          colors: context.colors,
          gridSpacing: gridSpacing,
          fadeFrom: fadeFrom,
          showWashes: showWashes,
          parallax: parallax,
        ),
        isComplex: true,
        willChange: parallax != Offset.zero,
      ),
    );
  }
}

class _BackdropPainter extends CustomPainter {
  _BackdropPainter({
    required this.colors,
    required this.gridSpacing,
    required this.fadeFrom,
    required this.showWashes,
    required this.parallax,
  });

  final AppColors colors;
  final double gridSpacing;
  final double fadeFrom;
  final bool showWashes;
  final Offset parallax;

  @override
  void paint(Canvas canvas, Size size) {
    if (showWashes) _paintWashes(canvas, size);
    _paintGrid(canvas, size);
  }

  void _paintWashes(Canvas canvas, Size size) {
    final indigoCentre = Offset(size.width * 0.78, size.height * 0.18) + parallax;
    final tealCentre =
        Offset(size.width * 0.12, size.height * 0.72) - parallax * 0.6;
    final radius = math.max(size.width, size.height) * 0.55;

    void wash(Offset centre, Color color, double alpha) {
      final rect = Rect.fromCircle(center: centre, radius: radius);
      canvas.drawRect(
        rect,
        Paint()
          ..shader = RadialGradient(
            colors: [color.withValues(alpha: alpha), color.withValues(alpha: 0)],
          ).createShader(rect),
      );
    }

    wash(indigoCentre, colors.primary, colors.isDark ? 0.13 : 0.10);
    wash(tealCentre, colors.secondary, colors.isDark ? 0.10 : 0.07);
  }

  void _paintGrid(Canvas canvas, Size size) {
    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = colors.textPrimary.withValues(alpha: colors.isDark ? 0.05 : 0.045);

    // Fade the grid out toward the bottom so content sits on clean ground.
    canvas.saveLayer(Offset.zero & size, Paint());

    for (double x = 0; x <= size.width; x += gridSpacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), line);
    }
    for (double y = 0; y <= size.height; y += gridSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), line);
    }

    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..blendMode = BlendMode.dstIn
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: const [Colors.white, Colors.white, Colors.transparent],
          stops: [0.0, fadeFrom.clamp(0.0, 0.99), 1.0],
        ).createShader(Offset.zero & size),
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(_BackdropPainter old) =>
      old.colors != colors ||
      old.gridSpacing != gridSpacing ||
      old.fadeFrom != fadeFrom ||
      old.showWashes != showWashes ||
      old.parallax != parallax;
}
