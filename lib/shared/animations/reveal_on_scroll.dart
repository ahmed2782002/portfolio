import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../core/constants/app_animations.dart';
import '../../core/extensions/context_extensions.dart';

/// Reveals its child once, when it first scrolls into view.
///
/// Rather than pulling in a visibility package, this reads the nearest
/// [Scrollable]'s position directly. Each instance listens only until it has
/// fired, then detaches — so a fully-revealed page costs nothing per frame.
///
/// Honours the platform "reduce motion" setting by rendering the end state
/// immediately.
class RevealOnScroll extends StatefulWidget {
  const RevealOnScroll({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = AppAnimations.slow,
    this.offsetY = 28,
    this.offsetX = 0,
    this.startScale = 1,
    this.threshold = 0.92,
  });

  final Widget child;

  /// Used to stagger siblings. See [StaggeredReveal].
  final Duration delay;
  final Duration duration;

  /// Distance travelled during the reveal, in logical pixels.
  final double offsetY;
  final double offsetX;

  /// Scale to grow from. `1` disables the scale component.
  final double startScale;

  /// Fraction of the viewport height the widget's top must cross before it
  /// reveals. `0.92` fires just as the element clears the bottom edge.
  final double threshold;

  @override
  State<RevealOnScroll> createState() => _RevealOnScrollState();
}

class _RevealOnScrollState extends State<RevealOnScroll>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );

  late final Animation<double> _curved = CurvedAnimation(
    parent: _controller,
    curve: AppAnimations.emphasized,
  );

  ScrollPosition? _position;
  bool _fired = false;

  /// Guards against queueing a post-frame check on every scroll tick.
  bool _evaluateScheduled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _evaluate());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (context.reduceMotion && !_fired) {
      _fired = true;
      _controller.value = 1;
      _detach();
      return;
    }

    final next = Scrollable.maybeOf(context)?.position;
    if (identical(next, _position)) return;
    _detach();
    _position = next?..addListener(_scheduleEvaluate);
  }

  void _detach() {
    _position?.removeListener(_scheduleEvaluate);
    _position = null;
  }

  /// Scroll positions notify their listeners from inside the viewport's own
  /// layout pass. Reading geometry there would re-enter layout on a render
  /// object that is mid-flight, so the actual check is deferred to the end of
  /// the frame — by which time every box has a final size and offset.
  void _scheduleEvaluate() {
    if (_fired || _evaluateScheduled) return;

    final phase = SchedulerBinding.instance.schedulerPhase;
    final safeNow = phase == SchedulerPhase.idle ||
        phase == SchedulerPhase.postFrameCallbacks;
    if (safeNow) {
      _evaluate();
      return;
    }

    _evaluateScheduled = true;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _evaluateScheduled = false;
      _evaluate();
    });
  }

  /// Fires the reveal as soon as the widget's top edge crosses the threshold.
  void _evaluate() {
    if (_fired || !mounted) return;

    final scrollable = Scrollable.maybeOf(context);
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;

    final viewportBox = scrollable?.context.findRenderObject() as RenderBox?;
    final viewportHeight =
        viewportBox?.size.height ?? MediaQuery.sizeOf(context).height;
    final top = box.localToGlobal(Offset.zero, ancestor: viewportBox).dy;

    // Also reveal anything already scrolled past (deep links, restored scroll).
    final entered = top < viewportHeight * widget.threshold;
    if (!entered) return;

    _fired = true;
    _detach();
    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future<void>.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _detach();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _curved,
      // The subtree is built once and reused for every animation frame.
      child: widget.child,
      builder: (context, child) {
        final t = _curved.value;
        final scale = widget.startScale == 1
            ? 1.0
            : widget.startScale + (1 - widget.startScale) * t;
        return Opacity(
          opacity: t.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(
              widget.offsetX * (1 - t),
              widget.offsetY * (1 - t),
            ),
            child: scale == 1.0
                ? child
                : Transform.scale(scale: scale, child: child),
          ),
        );
      },
    );
  }
}

/// Wraps each child in a [RevealOnScroll] whose delay grows with its index, so
/// siblings cascade instead of snapping in together.
///
/// The stagger is deliberately capped: past [maxSteps] siblings it stops
/// accumulating, so a long grid never leaves the reader waiting on the last row.
List<Widget> staggered(
  List<Widget> children, {
  Duration interval = AppAnimations.stagger,
  Duration baseDelay = Duration.zero,
  int maxSteps = 8,
  double offsetY = 24,
  double offsetX = 0,
  double startScale = 1,
}) {
  return [
    for (var i = 0; i < children.length; i++)
      RevealOnScroll(
        delay: baseDelay + interval * (i.clamp(0, maxSteps)),
        offsetY: offsetY,
        offsetX: offsetX,
        startScale: startScale,
        child: children[i],
      ),
  ];
}
