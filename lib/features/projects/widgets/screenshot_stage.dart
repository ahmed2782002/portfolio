import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_animations.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../data/models/portfolio_models.dart';
import '../../../shared/widgets/device_frame.dart';

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

  late Animation<double> _position =
      AlwaysStoppedAnimation<double>(widget.activeIndex.toDouble());

  /// Live position while a drag is in flight; `null` when animating.
  double? _dragPosition;

  /// How many neighbours stay visible on each side of the active plate.
  static const int _visibleRadius = 2;

  @override
  void didUpdateWidget(ScreenshotStage oldWidget) {
    super.didUpdateWidget(oldWidget);

    // A different project was selected — jump, don't travel across a rank that
    // no longer exists.
    if (widget.screenshots != oldWidget.screenshots) {
      _controller.stop();
      _dragPosition = null;
      _position =
          AlwaysStoppedAnimation<double>(widget.activeIndex.toDouble());
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
      _dragPosition = ((_dragPosition ?? widget.activeIndex.toDouble()) -
              details.primaryDelta! / spread)
          .clamp(-0.5, widget.screenshots.length - 0.5);
    });
  }

  void _onDragEnd(DragEndDetails details, double spread) {
    final velocity = details.primaryVelocity ?? 0;
    // A flick advances one step; otherwise settle on whatever is nearest.
    final raw = _dragPosition ?? widget.activeIndex.toDouble();
    final projected = velocity.abs() > 320 ? raw - velocity.sign * 0.5 : raw;
    final target =
        projected.round().clamp(0, widget.screenshots.length - 1);

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
              SingleActivator(LogicalKeyboardKey.arrowLeft):
                  _StepIntent(-1),
              SingleActivator(LogicalKeyboardKey.arrowRight):
                  _StepIntent(1),
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
          _Plate(
            key: ValueKey(widget.screenshots[index].asset),
            screenshot: widget.screenshots[index],
            distance: index - position,
            spread: spread,
            height: widget.height,
            tint: widget.tint,
            onTap: index == widget.activeIndex
                ? null
                : () => widget.onSelect(index),
            label: 'Screenshot ${index + 1} of $count: '
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

/// One screenshot, transformed by its signed distance from the active position.
class _Plate extends StatelessWidget {
  const _Plate({
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

  @override
  Widget build(BuildContext context) {
    final d = distance;
    final abs = d.abs();

    // Flat depth: the active plate is full size and opaque; neighbours sit
    // behind it, smaller and dimmer. No rotation or perspective — those made
    // the plates shimmer while travelling.
    final offsetX = spread * d.sign * math.pow(abs, 0.85);
    final scale = (1 - 0.16 * abs).clamp(0.6, 1.0);
    final opacity = abs > _ScreenshotStageState._visibleRadius + 0.5
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

/// The strip below the stage: a thumbnail per screenshot, the active one marked
/// by a growing indigo rule rather than a border, so nothing shifts position.
class ScreenshotThumbnails extends StatelessWidget {
  const ScreenshotThumbnails({
    super.key,
    required this.screenshots,
    required this.activeIndex,
    required this.onSelect,
    required this.tint,
  });

  final List<Screenshot> screenshots;
  final int activeIndex;
  final ValueChanged<int> onSelect;
  final Color tint;

  static const double _height = 66;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height + 12,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: screenshots.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) => _Thumbnail(
          screenshot: screenshots[index],
          index: index,
          isActive: index == activeIndex,
          tint: tint,
          onTap: () => onSelect(index),
        ),
      ),
    );
  }
}

class _Thumbnail extends StatefulWidget {
  const _Thumbnail({
    required this.screenshot,
    required this.index,
    required this.isActive,
    required this.tint,
    required this.onTap,
  });

  final Screenshot screenshot;
  final int index;
  final bool isActive;
  final Color tint;
  final VoidCallback onTap;

  @override
  State<_Thumbnail> createState() => _ThumbnailState();
}

class _ThumbnailState extends State<_Thumbnail> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    const height = ScreenshotThumbnails._height;
    final width = height * widget.screenshot.aspectRatio;
    final emphasised = widget.isActive || _hovering;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: Semantics(
        button: true,
        selected: widget.isActive,
        label: 'Show screenshot ${widget.index + 1}',
        child: GestureDetector(
          onTap: widget.onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: AppAnimations.base,
                curve: AppAnimations.standard,
                width: width,
                height: height,
                decoration: BoxDecoration(
                  borderRadius: AppRadius.brXs,
                  border: Border.all(
                    color: emphasised ? widget.tint : colors.border,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.xs - 1),
                  child: AnimatedOpacity(
                    duration: AppAnimations.base,
                    opacity: emphasised ? 1 : 0.55,
                    child: Image.asset(
                      widget.screenshot.asset,
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      cacheWidth: (width * 2).round(),
                      filterQuality: FilterQuality.low,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              AnimatedContainer(
                duration: AppAnimations.base,
                curve: AppAnimations.emphasized,
                height: 2,
                width: widget.isActive ? width : 0,
                color: widget.tint,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
