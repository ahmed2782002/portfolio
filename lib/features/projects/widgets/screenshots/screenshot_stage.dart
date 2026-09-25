import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:portfolio/core/constants/app_animations.dart';
import 'package:portfolio/data/models/models.dart';
import 'package:portfolio/features/projects/widgets/screenshots/screenshot_rank_plate.dart';

/// The interactive screenshot viewer.
///
/// The selected screenshot sits forward in the centre — full size, fully
/// opaque and carrying the shadow — while its neighbours sit behind it on
/// either side, smaller and dimmed. Picking another screenshot slides the
/// whole rank, so the new one travels into the centre while the old one
/// recedes to the side.
///
/// One `AnimationController` drives a continuous `position` value; every plate
/// derives its transform from its distance to that value. That is what lets a
/// drag scrub the rank smoothly and a tap animate it — the two inputs write to
/// the same number.
class ScreenshotStage extends StatefulWidget {
  const ScreenshotStage({
    super.key,
    required this.screenshots,
    required this.activeIndex,
    required this.onSelect,
    required this.tint,
    required this.height,
  });

  final List<Screenshot> screenshots;
  final int activeIndex;
  final ValueChanged<int> onSelect;
  final Color tint;

  /// Every plate is sized to this height; widths follow from each aspect ratio.
  final double height;

  @override
  State<ScreenshotStage> createState() => _ScreenshotStageState();
}

class _ScreenshotStageState extends State<ScreenshotStage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppAnimations.deep,
  );

  late Animation<double> _position = AlwaysStoppedAnimation<double>(
    widget.activeIndex.toDouble(),
  );

  /// Live position while a drag is in flight; `null` when animating.
  double? _dragPosition;

  @override
  void didUpdateWidget(ScreenshotStage oldWidget) {
    super.didUpdateWidget(oldWidget);

    // A different project was selected — jump, don't travel across a rank that
    // no longer exists.
    if (widget.screenshots != oldWidget.screenshots) {
      _controller.stop();
      _dragPosition = null;
      _position = AlwaysStoppedAnimation<double>(widget.activeIndex.toDouble());
      return;
    }

    if (widget.activeIndex != oldWidget.activeIndex) {
      _animateTo(widget.activeIndex.toDouble());
    }
  }

  void _animateTo(double target) {
    final from = _dragPosition ?? _position.value;
    _dragPosition = null;
    _position = Tween<double>(begin: from, end: target).animate(
      CurvedAnimation(parent: _controller, curve: AppAnimations.emphasized),
    );
    _controller.forward(from: 0);
  }

  double get _currentPosition => _dragPosition ?? _position.value;

  // --- drag scrubbing --------------------------------------------------------

  void _onDragStart(DragStartDetails _) {
    _controller.stop();
    _dragPosition = _position.value;
  }

  void _onDragUpdate(DragUpdateDetails details, double spread) {
    setState(() {
      _dragPosition =
          ((_dragPosition ?? widget.activeIndex.toDouble()) -
                  details.primaryDelta! / spread)
              .clamp(-0.5, widget.screenshots.length - 0.5);
    });
  }

  void _onDragEnd(DragEndDetails details, double spread) {
    final velocity = details.primaryVelocity ?? 0;
    // A flick advances one step; otherwise settle on whatever is nearest.
    final raw = _dragPosition ?? widget.activeIndex.toDouble();
    final projected = velocity.abs() > 320 ? raw - velocity.sign * 0.5 : raw;
    final target = projected.round().clamp(0, widget.screenshots.length - 1);

    if (target == widget.activeIndex) {
      _animateTo(target.toDouble());
    } else {
      // Let the parent own the selection; didUpdateWidget animates from here.
      widget.onSelect(target);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final count = widget.screenshots.length;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Plates overlap heavily so the rank reads as depth, not as a row.
        final spread = math.min(
          widget.height * 0.30,
          constraints.maxWidth * 0.26,
        );

        return Focus(
          child: Shortcuts(
            shortcuts: const {
              SingleActivator(LogicalKeyboardKey.arrowLeft): _StepIntent(-1),
              SingleActivator(LogicalKeyboardKey.arrowRight): _StepIntent(1),
            },
            child: Actions(
              actions: {
                _StepIntent: CallbackAction<_StepIntent>(
                  onInvoke: (intent) {
                    widget.onSelect(
                      (widget.activeIndex + intent.delta).clamp(0, count - 1),
                    );
                    return null;
                  },
                ),
              },
              child: GestureDetector(
                onHorizontalDragStart: _onDragStart,
                onHorizontalDragUpdate: (d) => _onDragUpdate(d, spread),
                onHorizontalDragEnd: (d) => _onDragEnd(d, spread),
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  height: widget.height * 1.06,
                  width: double.infinity,
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) => _buildRank(spread),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRank(double spread) {
    final position = _currentPosition;
    final count = widget.screenshots.length;

    // Every plate stays mounted (galleries are short) so none has to decode and
    // fade in mid-transition; far plates are simply transparent. Paint from the
    // back forward so the active plate lands on top without a z-index.
    final visible = List<int>.generate(count, (i) => i)
      ..sort((a, b) => (b - position).abs().compareTo((a - position).abs()));

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        for (final index in visible)
          ScreenshotRankPlate(
            key: ValueKey(widget.screenshots[index].asset),
            screenshot: widget.screenshots[index],
            distance: index - position,
            spread: spread,
            height: widget.height,
            tint: widget.tint,
            onTap: index == widget.activeIndex
                ? null
                : () => widget.onSelect(index),
            label:
                'Screenshot ${index + 1} of $count: '
                '${widget.screenshots[index].caption}',
          ),
      ],
    );
  }
}

class _StepIntent extends Intent {
  const _StepIntent(this.delta);

  final int delta;
}
