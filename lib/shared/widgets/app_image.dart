import 'package:flutter/material.dart';

import 'package:portfolio/core/constants/app_animations.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';

/// Asset image with a calm fade-in and a decode budget.
///
/// Two things matter for Flutter Web here:
/// * `cacheWidth` — decode at roughly the size actually painted rather than the
///   source resolution, which keeps the image cache small on long pages.
/// * `frameBuilder` — a short cross-fade so images arrive instead of popping.
///   Already-cached frames are returned synchronously and skip the fade.
class AppImage extends StatelessWidget {
  const AppImage({
    super.key,
    required this.asset,
    required this.layoutWidth,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.semanticLabel,
  });

  final String asset;

  /// The width this image will actually occupy, in logical pixels. Multiplied
  /// by the device pixel ratio to pick a decode size.
  final double layoutWidth;

  final BoxFit fit;
  final Alignment alignment;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final colors = context.colors;

    return Image.asset(
      asset,
      fit: fit,
      alignment: alignment,
      semanticLabel: semanticLabel,
      // Cap the decode at 2x — beyond that the extra pixels are invisible.
      cacheWidth: (layoutWidth * dpr.clamp(1.0, 2.0)).round(),
      filterQuality: FilterQuality.medium,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) return child;
        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: AppAnimations.slow,
          curve: AppAnimations.standard,
          child: child,
        );
      },
      errorBuilder: (context, error, stack) => ColoredBox(
        color: colors.backgroundAlt,
        child: Center(
          child: Icon(
            Icons.image_not_supported_outlined,
            color: colors.textTertiary,
            size: 28,
          ),
        ),
      ),
    );
  }
}
