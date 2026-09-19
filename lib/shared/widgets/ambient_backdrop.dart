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

  List<TextPainter>? _cachedPainters;

  List<TextPainter> _buildTokenPainters() {
    final tokenStyle = TextStyle(
      fontFamily: 'JetBrainsMono',
      fontSize: 10.5,
      fontWeight: FontWeight.w500,
      color: colors.primary.withValues(alpha: colors.isDark ? 0.10 : 0.07),
      letterSpacing: 0.5,
    );

    return _codeTokens.map((token) {
      final painter = TextPainter(
        text: TextSpan(text: token, style: tokenStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      return painter;
    }).toList(growable: false);
  }

  static const List<String> _codeTokens = [
    '</>',
    '{ }',
    '//',
    '=>',
    '0101',
    'const',
    'fn()',
    '[ ]',
    ';',
    'async',
    'git',
    '&&',
    'state',
    'build()',
  ];

  @override
  void paint(Canvas canvas, Size size) {
    if (showWashes) _paintWashes(canvas, size);
    _paintTechPattern(canvas, size);
  }

  void _paintWashes(Canvas canvas, Size size) {
    final emeraldCentre = Offset(size.width * 0.82, size.height * 0.16) + parallax;
    final amberCentre =
        Offset(size.width * 0.14, size.height * 0.68) - parallax * 0.6;
    final radius = math.max(size.width, size.height) * 0.52;

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

    // Emerald primary glow & Warm Amber secondary glow (NO blue, NO purple)
    wash(emeraldCentre, colors.primary, colors.isDark ? 0.12 : 0.08);
    wash(amberCentre, colors.secondary, colors.isDark ? 0.09 : 0.06);
  }

  void _paintTechPattern(Canvas canvas, Size size) {
    // Fade the pattern out toward the bottom so content sits on clean ground.
    canvas.saveLayer(Offset.zero & size, Paint());

    final crosshairPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = colors.primary.withValues(alpha: colors.isDark ? 0.14 : 0.10);

    final dotPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = colors.textPrimary.withValues(alpha: colors.isDark ? 0.07 : 0.05);

    const crossSize = 3.5;

    // 1. Tech Matrix Grid with micro-crosshairs and grid dots
    int colIndex = 0;
    for (double x = gridSpacing / 2; x <= size.width; x += gridSpacing) {
      int rowIndex = 0;
      for (double y = gridSpacing / 2; y <= size.height; y += gridSpacing) {
        // Draw crosshair at every 2nd intersection, dot at others
        if ((colIndex + rowIndex) % 2 == 0) {
          canvas.drawLine(
            Offset(x - crossSize, y),
            Offset(x + crossSize, y),
            crosshairPaint,
          );
          canvas.drawLine(
            Offset(x, y - crossSize),
            Offset(x, y + crossSize),
            crosshairPaint,
          );
        } else {
          canvas.drawCircle(Offset(x, y), 1.0, dotPaint);
        }
        rowIndex++;
      }
      colIndex++;
    }

    // 2. Floating Programmer & Code Tokens
    // TextPainters are cached and only rebuilt when shouldRepaint returns true.
    final painters = _cachedPainters ??= _buildTokenPainters();

    final double tokenStepX = gridSpacing * 3.5;
    final double tokenStepY = gridSpacing * 2.8;
    int tokenIndex = 0;

    for (double x = gridSpacing * 1.5; x < size.width - 40; x += tokenStepX) {
      for (double y = gridSpacing * 1.2; y < size.height - 40; y += tokenStepY) {
        final painter = painters[tokenIndex % painters.length];

        // Slight deterministic offset based on position
        final offsetX = x + (math.sin(tokenIndex * 2.1) * 16);
        final offsetY = y + (math.cos(tokenIndex * 1.7) * 12);

        painter.paint(canvas, Offset(offsetX, offsetY));
        tokenIndex++;
      }
    }

    // 3. Smooth bottom fade gradient
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

