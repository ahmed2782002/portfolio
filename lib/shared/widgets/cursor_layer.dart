import 'dart:ui' show lerpDouble;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:portfolio/core/extensions/context_extensions.dart';

/// The state a [CursorLayer] ring is drawn from.
@immutable
class _RingState {
  const _RingState({required this.position, required this.activation});

  final Offset? position;

  /// 0 → idle ring, 1 → expanded over an interactive element.
  final double activation;
}

/// Lets descendants tell the cursor ring that the pointer is over something
/// interactive. Obtained once in `didChangeDependencies` and cached, so it is
/// safe to use from `dispose`.
class CursorSignal {
  CursorSignal._();

  int _activeCount = 0;
  final ValueNotifier<bool> _active = ValueNotifier<bool>(false);

  void setActive(bool value) {
    _activeCount = (_activeCount + (value ? 1 : -1)).clamp(0, 1 << 20);
    _active.value = _activeCount > 0;
  }

  void _dispose() => _active.dispose();
}

/// A restrained desktop cursor flourish: a ring that trails the pointer and
/// swells over interactive elements.
///
/// It sits *behind* the native cursor rather than replacing it — the pointer
/// never disappears, so precision and accessibility are unaffected. The layer
/// disables itself entirely on touch layouts and when the OS asks for reduced
/// motion, and repaints inside a [RepaintBoundary] so pointer movement never
/// invalidates the page.
class CursorLayer extends StatefulWidget {
  const CursorLayer({super.key, required this.child});

  final Widget child;

  static CursorSignal? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_CursorScope>()?.signal;

  /// Convenience for one-off call sites that already hold a live context.
  static void setActive(BuildContext context, bool value) {
    context.getInheritedWidgetOfExactType<_CursorScope>()?.signal.setActive(
      value,
    );
  }

  @override
  State<CursorLayer> createState() => _CursorLayerState();
}

class _CursorLayerState extends State<CursorLayer>
    with SingleTickerProviderStateMixin {
  final CursorSignal _signal = CursorSignal._();
  final ValueNotifier<_RingState> _ring = ValueNotifier(
    const _RingState(position: null, activation: 0),
  );

  late final Ticker _ticker = createTicker(_onTick);

  Offset? _target;
  Offset? _current;
  double _activation = 0;

  /// Only true once a real mouse has moved — trackpad/mouse users get the ring,
  /// touch users never see it.
  bool _pointerSeen = false;

  @override
  void initState() {
    super.initState();
    _signal._active.addListener(_ensureTicking);
  }

  void _ensureTicking() {
    if (!_ticker.isActive) _ticker.start();
  }

  void _onTick(Duration _) {
    final target = _target;
    final wantActivation = _signal._active.value ? 1.0 : 0.0;

    // Critically-damped follow: fast enough to feel attached, slow enough to
    // read as a deliberate trail.
    if (target != null) {
      _current = _current == null
          ? target
          : Offset.lerp(_current, target, 0.22)!;
    }
    _activation = lerpDouble(_activation, wantActivation, 0.18)!;

    _ring.value = _RingState(position: _current, activation: _activation);

    final settled =
        target == null ||
        ((_current! - target).distance < 0.4 &&
            (_activation - wantActivation).abs() < 0.004);
    if (settled) {
      _current = target;
      _activation = wantActivation;
      _ring.value = _RingState(position: _current, activation: _activation);
      _ticker.stop();
    }
  }

  void _onHover(PointerHoverEvent event) {
    if (!_pointerSeen) {
      setState(() => _pointerSeen = true);
      _current = event.position;
    }
    _target = event.position;
    _ensureTicking();
  }

  void _onExit(PointerExitEvent _) {
    _target = null;
    _ring.value = const _RingState(position: null, activation: 0);
    _current = null;
    _ticker.stop();
  }

  @override
  void dispose() {
    _signal._active.removeListener(_ensureTicking);
    _ticker.dispose();
    _ring.dispose();
    _signal._dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final enabled = !context.isMobile && !context.reduceMotion;
    final content = _CursorScope(signal: _signal, child: widget.child);

    if (!enabled) return content;

    return MouseRegion(
      opaque: false,
      onHover: _onHover,
      onExit: _onExit,
      child: Stack(
        children: [
          content,
          if (_pointerSeen)
            Positioned.fill(
              child: IgnorePointer(
                child: RepaintBoundary(
                  child: ValueListenableBuilder<_RingState>(
                    valueListenable: _ring,
                    // The ring positions itself absolutely, so it needs a Stack
                    // of its own here — the RepaintBoundary above would
                    // otherwise be its parent and reject the Positioned.
                    builder: (context, ring, _) =>
                        Stack(children: [_CursorRing(ring: ring)]),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CursorRing extends StatelessWidget {
  const _CursorRing({required this.ring});

  final _RingState ring;

  @override
  Widget build(BuildContext context) {
    final position = ring.position;
    if (position == null) return const SizedBox.shrink();

    final t = ring.activation;
    final size = lerpDouble(26, 46, t)!;
    final primary = context.colors.primary;

    return Positioned(
      left: position.dx - size / 2,
      top: position.dy - size / 2,
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: primary.withValues(alpha: 0.10 * t),
          border: Border.all(
            color: primary.withValues(alpha: lerpDouble(0.32, 0.6, t)!),
            width: lerpDouble(1.2, 1.0, t)!,
          ),
        ),
      ),
    );
  }
}

class _CursorScope extends InheritedWidget {
  const _CursorScope({required this.signal, required super.child});

  final CursorSignal signal;

  @override
  bool updateShouldNotify(_CursorScope oldWidget) => signal != oldWidget.signal;
}
