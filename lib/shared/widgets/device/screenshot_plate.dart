import 'package:flutter/material.dart';

import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/data/models/models.dart';
import 'package:portfolio/shared/widgets/app_image.dart';
import 'package:portfolio/shared/widgets/device/device_frame.dart';

/// Renders one screenshot at [width], choosing the right presentation.
///
/// This is the single place that acts on [Screenshot.hasDeviceFrame]: store
/// graphics that already contain a phone are given rounded corners and a shadow
/// only; raw screenshots get the shared [DeviceFrame].
class ScreenshotPlate extends StatelessWidget {
  const ScreenshotPlate({
    super.key,
    required this.screenshot,
    required this.width,
    this.elevation = 1,
    this.tint,
  });

  final Screenshot screenshot;
  final double width;

  /// 0 → flat and recessed, 1 → fully forward. Drives shadow depth only.
  final double elevation;

  /// Product tint used for the drop glow behind the active plate.
  final Color? tint;

  /// Width this screenshot needs in order to stand exactly [height] tall.
  ///
  /// The showcase sizes plates by height rather than width so that a long
  /// scroll-capture and a standard screen sit at the same scale — the phones
  /// line up, and the tall one is simply narrower, which is how a real device
  /// would look.
  static double widthForHeight(Screenshot screenshot, double height) {
    if (screenshot.hasDeviceFrame) return height * screenshot.aspectRatio;

    // height = (w - 2b)/aspect + 2b, with b = w * bezelRatio.
    const b = DeviceFrame.bezelRatio;
    return height / ((1 - 2 * b) / screenshot.aspectRatio + 2 * b);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final glow = tint ?? colors.primary;

    final image = AppImage(
      asset: screenshot.asset,
      layoutWidth: width,
      fit: BoxFit.cover,
      semanticLabel: screenshot.caption,
    );

    final shadows = <BoxShadow>[
      BoxShadow(
        color: Colors.black.withValues(
          alpha: (colors.isDark ? 0.55 : 0.22) * elevation,
        ),
        blurRadius: 40 * elevation + 8,
        spreadRadius: -6,
        offset: Offset(0, 18 * elevation + 4),
      ),
      if (elevation > 0.6)
        BoxShadow(
          color: glow.withValues(alpha: 0.16 * (elevation - 0.6) / 0.4),
          blurRadius: 60,
          spreadRadius: -10,
          offset: const Offset(0, 12),
        ),
    ];

    if (screenshot.hasDeviceFrame) {
      // Already a mockup — corner radius matches the frame we draw elsewhere so
      // both kinds of asset sit on the page with the same silhouette.
      final radius = BorderRadius.circular(width * 0.045);
      return SizedBox(
        width: width,
        child: AspectRatio(
          aspectRatio: screenshot.aspectRatio,
          child: DecoratedBox(
            decoration: BoxDecoration(borderRadius: radius, boxShadow: shadows),
            child: ClipRRect(borderRadius: radius, child: image),
          ),
        ),
      );
    }

    final bezel = width * DeviceFrame.bezelRatio;
    final screenWidth = width - bezel * 2;
    final height = screenWidth / screenshot.aspectRatio + bezel * 2;

    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            width * DeviceFrame.bodyRadiusRatio,
          ),
          boxShadow: shadows,
        ),
        child: DeviceFrame(
          width: width,
          aspectRatio: screenshot.aspectRatio,
          child: image,
        ),
      ),
    );
  }
}
