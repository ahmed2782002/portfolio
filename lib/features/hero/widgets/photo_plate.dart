import 'package:flutter/material.dart';

import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/shared/widgets/app_image.dart';

/// The portrait photo in an arched window, with a soft foot shadow and a
/// gradient that grounds the figure against the page.
class PhotoPlate extends StatelessWidget {
  const PhotoPlate({
    super.key,
    required this.asset,
    required this.width,
    required this.name,
  });

  final String asset;
  final double width;
  final String name;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final archRadius = BorderRadius.vertical(
      top: Radius.circular(width / 2),
      bottom: const Radius.circular(28),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: archRadius,
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: colors.isDark ? 0.35 : 0.12),
            blurRadius: 36,
            spreadRadius: -4,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: archRadius,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(
              color: colors.isDark
                  ? const Color(0xFF243241)
                  : AppColors.softLavender,
            ),
            AppImage(
              asset: asset,
              layoutWidth: width,
              semanticLabel: 'Portrait of $name',
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    colors.background.withValues(alpha: 0.30),
                    colors.background.withValues(alpha: 0.70),
                  ],
                  stops: const [0.0, 0.60, 0.88, 1.0],
                ),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: archRadius,
                border: Border.all(
                  color: colors.isDark
                      ? Colors.white.withValues(alpha: 0.15)
                      : AppColors.lavenderPurple.withValues(alpha: 0.35),
                  width: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
