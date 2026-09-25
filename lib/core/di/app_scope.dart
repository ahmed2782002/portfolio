import 'package:flutter/widgets.dart';

import 'package:portfolio/core/theme/theme_controller.dart';
import 'package:portfolio/data/repositories/portfolio_repository.dart';

/// App-wide dependencies, provided once above [MaterialApp].
///
/// ViewModels are created with what they need from here, so no widget ever
/// reaches for a global or a static content class.
class AppScope extends InheritedWidget {
  const AppScope({
    super.key,
    required this.repository,
    required this.themeController,
    required super.child,
  });

  final PortfolioRepository repository;
  final ThemeController themeController;

  static AppScope of(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'No AppScope found above this widget.');
    return scope!;
  }

  @override
  bool updateShouldNotify(AppScope oldWidget) =>
      repository != oldWidget.repository ||
      themeController != oldWidget.themeController;
}

extension AppScopeContext on BuildContext {
  PortfolioRepository get repository => AppScope.of(this).repository;
  ThemeController get themeController => AppScope.of(this).themeController;
}
