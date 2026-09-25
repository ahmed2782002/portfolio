import 'package:flutter/foundation.dart';

import 'package:portfolio/data/models/models.dart';
import 'package:portfolio/data/repositories/portfolio_repository.dart';
import 'package:portfolio/features/home/models/portfolio_section.dart';

/// Page-level state: which section is active, how far the page has scrolled,
/// whether the nav is condensed and whether the mobile menu is open.
///
/// Every value is its own [ValueListenable], so a scroll tick only rebuilds
/// the widget that shows the value that changed (the progress rule, the nav)
/// — never the page's sections.
class HomeViewModel {
  HomeViewModel(this._repository);

  final PortfolioRepository _repository;

  /// Scroll distance after which the nav bar condenses.
  static const double condenseAfter = 40;

  final ValueNotifier<PortfolioSection> _activeSection = ValueNotifier(
    PortfolioSection.home,
  );
  final ValueNotifier<bool> _condensed = ValueNotifier(false);
  final ValueNotifier<double> _progress = ValueNotifier(0);
  final ValueNotifier<bool> _menuOpen = ValueNotifier(false);
  final ValueNotifier<bool> _heroVisible = ValueNotifier(true);

  ValueListenable<PortfolioSection> get activeSection => _activeSection;
  ValueListenable<bool> get condensed => _condensed;

  /// 0 → top of the page, 1 → fully scrolled.
  ValueListenable<double> get progress => _progress;
  ValueListenable<bool> get menuOpen => _menuOpen;

  /// False once the hero has scrolled out of view — its looping animations
  /// pause so they stop costing frames nobody can see.
  ValueListenable<bool> get heroVisible => _heroVisible;

  Profile get profile => _repository.profile;

  /// Feeds the latest scroll geometry in. Called at most once per frame.
  void onScrolled({
    required double pixels,
    required double maxExtent,
    required double heroExtent,
    required PortfolioSection active,
  }) {
    _condensed.value = pixels > condenseAfter;
    _activeSection.value = active;
    _heroVisible.value = pixels < heroExtent;

    final progress = maxExtent <= 0
        ? 0.0
        : (pixels / maxExtent).clamp(0.0, 1.0);
    // Sub-pixel changes on a 2px rule are invisible; skip the rebuild.
    if ((progress - _progress.value).abs() >= 0.001 ||
        progress == 0 ||
        progress == 1) {
      _progress.value = progress;
    }
  }

  void openMenu() => _menuOpen.value = true;
  void closeMenu() => _menuOpen.value = false;

  void dispose() {
    _activeSection.dispose();
    _condensed.dispose();
    _progress.dispose();
    _menuOpen.dispose();
    _heroVisible.dispose();
  }
}
