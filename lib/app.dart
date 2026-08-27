import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'core/constants/app_animations.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'data/portfolio_data.dart';
import 'features/home/home_page.dart';
import 'shared/widgets/cursor_layer.dart';

/// Application root.
///
/// [MaterialApp] cross-fades between the two themes over
/// [AppAnimations.deep] — because every colour lives in a lerping
/// `ThemeExtension`, the whole page transitions as one surface instead of
/// snapping.
class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key, required this.themeController});

  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeController,
      builder: (context, _) => MaterialApp(
        title: '${PortfolioData.profile.fullName} — '
            '${PortfolioData.profile.role}',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: themeController.mode,
        themeAnimationDuration: AppAnimations.deep,
        themeAnimationCurve: AppAnimations.standard,
        scrollBehavior: const _AppScrollBehavior(),
        builder: (context, child) => CursorLayer(
          child: child ?? const SizedBox.shrink(),
        ),
        home: HomePage(themeController: themeController),
      ),
    );
  }
}

/// Lets a trackpad, mouse wheel and touch all drive the same page scroll.
class _AppScrollBehavior extends MaterialScrollBehavior {
  const _AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => const {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };

  /// The page draws its own progress rule; a stretch overscroll on top of that
  /// would read as a glitch.
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) =>
      child;
}
