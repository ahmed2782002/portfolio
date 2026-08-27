import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/constants/app_animations.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/extensions/context_extensions.dart';
import 'hover_builder.dart';

/// Light/dark switch.
///
/// The mark morphs rather than swapping icons: a filled disc that rotates while
/// a second disc slides across it to bite out a crescent. It runs on the same
/// clock as the theme's own colour lerp, so the control and the page change
/// together.
class ThemeToggle extends StatefulWidget {
  const ThemeToggle({
    super.key,
    required this.isDark,
    required this.onToggle,
    this.size = 42,
  });

  final bool isDark;
  final VoidCallback onToggle;
  final double size;

  @override
  State<ThemeToggle> createState() => _ThemeToggleState();
}

class _ThemeToggleState extends State<ThemeToggle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppAnimations.deep,
    value: widget.isDark ? 1 : 0,
  );

  late final Animation<double> _t = CurvedAnimation(
    parent: _controller,
    curve: AppAnimations.emphasized,
  );

  @override
  void didUpdateWidget(ThemeToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isDark != oldWidget.isDark) {
      widget.isDark ? _controller.forward() : _controller.reverse();
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
    final label = widget.isDark ? 'Switch to light mode' : 'Switch to dark mode';

    return Tooltip(
      message: label,
      child: HoverBuilder(
        onTap: widget.onToggle,
        semanticLabel: label,
        builder: (context, hover, _) => AnimatedBuilder(
          animation: _t,
          builder: (context, _) {
            final t = _t.value;
            final tint = Color.lerp(colors.accent, colors.primary, t)!;
            return Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: Color.lerp(colors.card, tint.withValues(alpha: 0.14), hover),
                borderRadius: AppRadius.brSm,
                border: Border.all(
                  color: Color.lerp(colors.border, tint, hover)!,
                ),
              ),
              child: Center(
                child: SizedBox.square(
                  dimension: widget.size * 0.44,
                  child: CustomPaint(
                    painter: _MorphPainter(
                      t: t,
                      color: Color.lerp(colors.textSecondary, tint, hover)!,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _MorphPainter extends CustomPainter {
  _MorphPainter({required this.t, required this.color});

  /// 0 → sun, 1 → crescent moon.
  final double t;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final centre = size.center(Offset.zero);
    final paint = Paint()..color = color;

    // The disc shrinks slightly as it becomes a moon.
    final radius = size.width / 2 * (1 - 0.18 * t);

    final disc = Path()
      ..addOval(Rect.fromCircle(center: centre, radius: radius));

    // A second disc slides in from the upper-right to carve the crescent.
    final biteCentre = centre +
        Offset(size.width * 0.52, -size.width * 0.34) * t;
    final bite = Path()
      ..addOval(Rect.fromCircle(center: biteCentre, radius: radius * 0.95));

    canvas.drawPath(
      t < 0.02 ? disc : Path.combine(PathOperation.difference, disc, bite),
      paint,
    );

    // Sun rays fade and retract as the moon takes over.
    if (t < 0.98) {
      final rayPaint = Paint()
        ..color = color.withValues(alpha: 1 - t)
        ..strokeWidth = size.width * 0.09
        ..strokeCap = StrokeCap.round;
      final inner = radius * 1.42;
      final outer = inner + size.width * 0.20 * (1 - t);
      for (var i = 0; i < 8; i++) {
        final angle = i * math.pi / 4 + t * math.pi / 4;
        final direction = Offset(math.cos(angle), math.sin(angle));
        canvas.drawLine(
          centre + direction * inner,
          centre + direction * outer,
          rayPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_MorphPainter old) => old.t != t || old.color != color;
}
