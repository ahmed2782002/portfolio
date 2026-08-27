import 'package:flutter/material.dart';

import '../../core/constants/app_animations.dart';
import '../../core/extensions/context_extensions.dart';
import 'cursor_layer.dart';

/// Drives a 0→1 animation from pointer hover and exposes it to a builder.
///
/// Every hover affordance on the site goes through this one widget, which keeps
/// hover timing consistent and means the custom cursor is notified automatically
/// — individual call sites never have to think about it.
class HoverBuilder extends StatefulWidget {
  const HoverBuilder({
    super.key,
    required this.builder,
    this.onTap,
    this.cursor = SystemMouseCursors.click,
    this.duration = AppAnimations.fast,
    this.enabled = true,
    this.semanticLabel,
    this.notifyCursor = true,
    this.child,
  });

  /// `t` runs 0 (idle) → 1 (hovered), already curved.
  final Widget Function(BuildContext context, double t, Widget? child) builder;

  /// Passed straight through to [builder] so an expensive subtree can be built
  /// once and reused across hover frames.
  final Widget? child;

  final VoidCallback? onTap;
  final MouseCursor cursor;
  final Duration duration;
  final bool enabled;
  final String? semanticLabel;

  /// Whether hovering should enlarge the custom cursor ring.
  final bool notifyCursor;

  @override
  State<HoverBuilder> createState() => _HoverBuilderState();
}

class _HoverBuilderState extends State<HoverBuilder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );

  late final Animation<double> _curved = CurvedAnimation(
    parent: _controller,
    curve: AppAnimations.standard,
    reverseCurve: AppAnimations.standard.flipped,
  );

  bool _hovering = false;

  /// Captured here rather than looked up on demand so it stays usable from
  /// [dispose], where inherited-widget lookups are not allowed.
  CursorSignal? _cursor;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cursor = CursorLayer.maybeOf(context);
  }

  void _setHover(bool value) {
    if (_hovering == value) return;
    _hovering = value;
    value ? _controller.forward() : _controller.reverse();
    if (widget.notifyCursor) _cursor?.setActive(value);
  }

  @override
  void dispose() {
    // A card can be unmounted while hovered (e.g. the project switches);
    // release the ring so it doesn't stay swollen.
    if (_hovering && widget.notifyCursor) _cursor?.setActive(false);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget result = AnimatedBuilder(
      animation: _curved,
      child: widget.child,
      builder: (context, child) => widget.builder(context, _curved.value, child),
    );

    if (!widget.enabled) return result;

    if (widget.onTap != null) {
      result = GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: result,
      );
      if (widget.semanticLabel != null) {
        result = Semantics(
          button: true,
          label: widget.semanticLabel,
          child: ExcludeSemantics(child: result),
        );
      }
    }

    return MouseRegion(
      cursor: widget.onTap != null ? widget.cursor : MouseCursor.defer,
      onEnter: (_) => _setHover(true),
      onExit: (_) => _setHover(false),
      child: result,
    );
  }
}

/// A card-like container that lifts, brightens and tightens its border on hover.
/// Used for skill panels, additional-project tiles and contact rows.
class HoverCard extends StatelessWidget {
  const HoverCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(24),
    this.borderRadius,
    this.lift = 4,
    this.accent,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets padding;
  final BorderRadius? borderRadius;

  /// How far the card rises on hover.
  final double lift;

  /// Border/glow colour on hover. Defaults to the indigo accent.
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radius = borderRadius ?? BorderRadius.circular(14);
    final highlight = accent ?? colors.primary;

    return HoverBuilder(
      onTap: onTap,
      cursor: onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
      notifyCursor: onTap != null,
      child: child,
      builder: (context, t, child) => Transform.translate(
        offset: Offset(0, -lift * t),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Color.lerp(colors.card, colors.cardHover, t),
            borderRadius: radius,
            border: Border.all(
              color: Color.lerp(colors.border, highlight.withValues(alpha: 0.5), t)!,
            ),
            boxShadow: t == 0
                ? null
                : [
                    BoxShadow(
                      color: colors.shadow,
                      blurRadius: 24 * t,
                      offset: Offset(0, 8 * t),
                    ),
                  ],
          ),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
