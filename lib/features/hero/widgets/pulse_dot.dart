import 'package:flutter/material.dart';

import 'package:portfolio/core/extensions/context_extensions.dart';

/// A slow breath on the status dot. Suppressed under reduced motion, and
/// paused with the rest of the hero once it scrolls out of view.
class PulseDot extends StatefulWidget {
  const PulseDot({super.key, required this.color});

  final Color color;

  @override
  State<PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<PulseDot>
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

    if (context.reduceMotion) {
      return SizedBox.square(dimension: 14, child: Center(child: dot));
    }

    return RepaintBoundary(
      child: SizedBox.square(
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
      ),
    );
  }
}
