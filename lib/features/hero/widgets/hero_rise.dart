import 'package:flutter/widgets.dart';

/// Fade + rise driven by a slice of the hero's entrance controller.
class HeroRise extends StatelessWidget {
  const HeroRise(this.animation, {super.key, required this.child});

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
