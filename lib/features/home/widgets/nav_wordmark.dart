import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:portfolio/core/constants/app_spacing.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/shared/widgets/hover_builder.dart';

/// Tiger mark plus the name, which drops away on the narrowest layout.
class NavWordmark extends StatelessWidget {
  const NavWordmark({super.key, required this.name, required this.onTap});

  final String name;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;

    return HoverBuilder(
      onTap: onTap,
      semanticLabel: 'Back to top',
      builder: (context, t, _) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color.lerp(
                colors.isDark ? colors.primary : colors.textPrimary,
                colors.isDark ? AppColors.modernMint : const Color(0xFF1E2833),
                t,
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: (colors.isDark ? colors.primary : colors.shadow)
                      .withValues(alpha: 0.25 * t),
                  blurRadius: 14 * t,
                  offset: Offset(0, 3 * t),
                ),
              ],
            ),
            child: SvgPicture.asset(
              'assets/icons/tiger.svg',
              width: 22,
              height: 22,
              semanticsLabel: 'Tiger logo',
              colorFilter: ColorFilter.mode(
                colors.isDark ? colors.onPrimary : AppColors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
          if (context.screen.index >= 1) ...[
            const SizedBox(width: AppSpacing.sm),
            Text(
              name,
              style: type.bodyStrong.copyWith(
                color: Color.lerp(colors.textPrimary, colors.primary, t),
                fontFamily: 'SpaceGrotesk',
                letterSpacing: -0.2,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
