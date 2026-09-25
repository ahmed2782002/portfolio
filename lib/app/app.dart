import 'package:flutter/material.dart';

import 'package:portfolio/app/app_scroll_behavior.dart';
import 'package:portfolio/core/constants/app_animations.dart';
import 'package:portfolio/core/di/app_scope.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/core/theme/theme_controller.dart';
import 'package:portfolio/data/repositories/portfolio_repository.dart';
import 'package:portfolio/features/home/view/home_page.dart';
import 'package:portfolio/shared/widgets/cursor_layer.dart';

/// Application root.
///
/// [MaterialApp] cross-fades between the two themes over
/// [AppAnimations.deep] — because every colour lives in a lerping
/// `ThemeExtension`, the whole page transitions as one surface instead of
/// snapping.
class PortfolioApp extends StatelessWidget {
  const PortfolioApp({
    super.key,
    required this.themeController,
    this.repository = const PortfolioRepository(),
  });

  final ThemeController themeController;
  final PortfolioRepository repository;

  @override
  Widget build(BuildContext context) {
    final profile = repository.profile;

    return AppScope(
      repository: repository,
      themeController: themeController,
      child: ListenableBuilder(
        listenable: themeController,
        builder: (context, _) => MaterialApp(
          title: '${profile.fullName} — ${profile.role}',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: themeController.mode,
          themeAnimationDuration: AppAnimations.deep,
          themeAnimationCurve: AppAnimations.standard,
          scrollBehavior: const AppScrollBehavior(),
          builder: (context, child) =>
              CursorLayer(child: child ?? const SizedBox.shrink()),
          home: const HomePage(),
        ),
      ),
    );
  }
}
