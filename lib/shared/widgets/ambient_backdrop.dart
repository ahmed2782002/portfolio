import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/extensions/context_extensions.dart';
import '../../core/theme/app_colors.dart';

/// Developer & Tech ambient backdrop texture.
///
/// Features a high-tech blueprint dot-and-crosshair matrix, floating syntax/code
/// tokens (`</>`, `{ }`, `//`, `=>`, `0101`, `const`, `fn()`), and cyber
/// emerald & amber glow washes.
class AmbientBackdrop extends StatelessWidget {
  const AmbientBackdrop({
    super.key,
    this.gridSpacing = 56,
    this.fadeFrom = 0.0,
    this.showWashes = true,
    this.parallax = Offset.zero,
  });

  /// Grid pitch in logical pixels.
  final double gridSpacing;

  /// Fraction of the height at which the pattern starts fading out.
  final double fadeFrom;

  final bool showWashes;

  /// Small offset applied to the washes so they drift with pointer parallax.
  final Offset parallax;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: _TechBackdropPainter(
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

class _TechBackdropPainter extends CustomPainter {
  _TechBackdropPainter({
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
    _paintSoftPattern(canvas, size);
  }

  void _paintWashes(Canvas canvas, Size size) {
    final mintCentre = Offset(size.width * 0.78, size.height * 0.20) + parallax;
    final lavenderCentre =
        Offset(size.width * 0.18, size.height * 0.65) - parallax * 0.6;
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

    // Subtle Modern Mint primary glow & Lavender Purple secondary glow
    wash(mintCentre, colors.primary, colors.isDark ? 0.18 : 0.22);
    wash(lavenderCentre, colors.secondary, colors.isDark ? 0.15 : 0.18);
  }

  void _paintSoftPattern(Canvas canvas, Size size) {
    canvas.saveLayer(Offset.zero & size, Paint());

    final dotPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = colors.isDark
          ? colors.secondary.withValues(alpha: 0.07)
          : colors.secondary.withValues(alpha: 0.06);

    // Subtle, sparse stationery dot grid
    final double step = gridSpacing.clamp(56, 72);
    for (double x = step / 2; x <= size.width; x += step) {
      for (double y = step / 2; y <= size.height; y += step) {
        canvas.drawCircle(Offset(x, y), 0.9, dotPaint);
      }
    }

    // Smooth bottom fade gradient
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
  bool shouldRepaint(_TechBackdropPainter old) =>
      old.colors != colors ||
      old.gridSpacing != gridSpacing ||
      old.fadeFrom != fadeFrom ||
      old.showWashes != showWashes ||
      old.parallax != parallax;
}

