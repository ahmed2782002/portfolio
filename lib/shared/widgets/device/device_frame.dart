import 'package:flutter/material.dart';

/// A restrained modern phone mockup.
///
/// Only ever wrapped around *raw* screenshots. Assets that already ship inside
/// a device mockup are rendered by [ScreenshotPlate] without a second frame.
///
/// Deliberately no notch or dynamic island: the supplied screenshots include
/// their own status bar, so drawing one would double it up. The frame is body,
/// bezel, rim highlight and side hardware — nothing that competes with the
/// screen content.
class DeviceFrame extends StatelessWidget {
  const DeviceFrame({
    super.key,
    required this.child,
    required this.width,
    this.aspectRatio = 390 / 844,
    this.showHardware = true,
  });

  final Widget child;
  final double width;

  /// Screen aspect ratio (w / h) — taken from the screenshot itself so the
  /// image is never letterboxed or cropped.
  final double aspectRatio;

  final bool showHardware;

  /// Bezel thickness as a fraction of device width.
  static const double bezelRatio = 0.035;

  /// Outer body corner radius as a fraction of device width.
  static const double bodyRadiusRatio = 0.135;

  @override
  Widget build(BuildContext context) {
    final bezel = width * bezelRatio;
    final bodyRadius = width * bodyRadiusRatio;
    final screenRadius = bodyRadius - bezel;
    final screenWidth = width - bezel * 2;
    final height = screenWidth / aspectRatio + bezel * 2;

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (showHardware)
            Positioned.fill(
              child: _Hardware(width: width, bezel: bezel),
            ),
          // Body: a graphite gradient in both themes — phones are dark objects,
          // and keeping the frame constant makes the screens comparable.
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(bodyRadius),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF3A3D3F),
                  Color(0xFF17191A),
                  Color(0xFF2B2E30),
                ],
                stops: [0.0, 0.55, 1.0],
              ),
            ),
            padding: EdgeInsets.all(bezel),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(screenRadius),
              // The screenshot is the focus; everything else is scaffolding.
              child: child,
            ),
          ),
          // Rim highlight — a single hairline that reads as machined metal.
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(bodyRadius),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.14),
                    width: 0.8,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Volume rocker, silent switch and power button, drawn just outside the body.
class _Hardware extends StatelessWidget {
  const _Hardware({required this.width, required this.bezel});

  final double width;
  final double bezel;

  @override
  Widget build(BuildContext context) {
    final thickness = (width * 0.011).clamp(2.0, 4.0);
    const color = Color(0xFF303335);

    Widget button(double heightFactor, {required bool left}) {
      return Align(
        alignment: left ? Alignment.centerLeft : Alignment.centerRight,
        child: FractionallySizedBox(
          heightFactor: heightFactor,
          child: Transform.translate(
            offset: Offset(left ? -thickness + 1 : thickness - 1, 0),
            child: Container(
              width: thickness,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(left ? thickness : 0),
                  right: Radius.circular(left ? 0 : thickness),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Stack(
      children: [
        Positioned(
          top: width * 0.30,
          bottom: 0,
          left: 0,
          child: button(0.10, left: true),
        ),
        Positioned(
          top: width * 0.46,
          bottom: 0,
          left: 0,
          child: button(0.10, left: true),
        ),
        Positioned(
          top: width * 0.38,
          bottom: 0,
          right: 0,
          child: button(0.14, left: false),
        ),
      ],
    );
  }
}
